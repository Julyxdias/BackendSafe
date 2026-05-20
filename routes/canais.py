from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, timezone

import models, schemas
from database import get_db
from routes.notificacoes import enviar_alerta_email

router = APIRouter(prefix="/medicoes", tags=["Medições"])

# ── limites configuráveis ────────────────────────────────────────────────────
LIMITE_SOBRECORRENTE = 40.0
LIMITE_FORA_HORARIO  = 10.0
HORA_INICIO          = 6
HORA_FIM             = 22
QUEDA_FATOR          = 0.3

OFFLINE_MINUTOS = 60
ATRASO_MINUTOS  = 10


def _verificar_alertas(db: Session, medicao: models.Medicao):
    corrente  = medicao.corrente
    canal_id  = medicao.canal_id
    timestamp = medicao.timestamp

    if corrente is None:
        return

    novos = []

    # 1. Sobrecorrente
    if corrente > LIMITE_SOBRECORRENTE:
        novos.append(dict(
            canal_id=canal_id, tipo="sobrecorrente", nivel="critico",
            mensagem="Corrente acima do limite",
            valor=corrente, limite=LIMITE_SOBRECORRENTE, timestamp=timestamp,
        ))

    # 2. Consumo fora do horário
    hora = timestamp.hour
    if corrente > LIMITE_FORA_HORARIO and (hora < HORA_INICIO or hora >= HORA_FIM):
        novos.append(dict(
            canal_id=canal_id, tipo="consumo_fora_horario", nivel="aviso",
            mensagem="Consumo detectado fora do horário",
            valor=corrente, limite=LIMITE_FORA_HORARIO, timestamp=timestamp,
        ))

    # 3. Queda brusca
    anterior = (
        db.query(models.Medicao)
        .filter(
            models.Medicao.canal_id == canal_id,
            models.Medicao.id       != medicao.id,
            models.Medicao.corrente != None,
        )
        .order_by(models.Medicao.timestamp.desc())
        .first()
    )
    if anterior and anterior.corrente and corrente < anterior.corrente * QUEDA_FATOR:
        novos.append(dict(
            canal_id=canal_id, tipo="queda_brusca", nivel="aviso",
            mensagem="Queda brusca de corrente detectada",
            valor=corrente, limite=anterior.corrente, timestamp=timestamp,
        ))

    for dados in novos:
        db.add(models.Alerta(**dados))
        # Dispara e-mail para alertas críticos (e avisos se configurado)
        enviar_alerta_email(**dados)

    if novos:
        db.commit()


def _atualizar_status_dispositivo(db: Session, medicao: models.Medicao):
    canal = db.query(models.CanalMedicao).filter(
        models.CanalMedicao.id == medicao.canal_id
    ).first()
    if not canal or not canal.dispositivo_id:
        return

    agora = datetime.now(timezone.utc).replace(tzinfo=None)
    diff  = (agora - medicao.timestamp).total_seconds() / 60

    novo_status = "OFFLINE" if diff > OFFLINE_MINUTOS else ("ATRASO" if diff > ATRASO_MINUTOS else "ONLINE")

    status_rec = db.query(models.DispositivoStatus).filter(
        models.DispositivoStatus.dispositivo_id == canal.dispositivo_id
    ).first()

    if status_rec:
        status_rec.ultima_leitura = medicao.timestamp
        status_rec.potencia_atual = medicao.potencia
        status_rec.status         = novo_status
        status_rec.atualizado_em  = agora
    else:
        db.add(models.DispositivoStatus(
            dispositivo_id=canal.dispositivo_id,
            status=novo_status,
            ultima_leitura=medicao.timestamp,
            potencia_atual=medicao.potencia,
            atualizado_em=agora,
        ))
    db.commit()


# ── endpoints ────────────────────────────────────────────────────────────────

@router.post("/", response_model=schemas.MedicaoOut, status_code=201)
def criar_medicao(medicao: schemas.MedicaoCreate, db: Session = Depends(get_db)):
    if medicao.canal_id:
        canal = db.query(models.CanalMedicao).filter(
            models.CanalMedicao.id == medicao.canal_id
        ).first()
        if not canal:
            raise HTTPException(status_code=404, detail="Canal de medição não encontrado.")

    dados = medicao.model_dump()

    # Calcula potência se não enviada (P = I × V)
    # Se tensao real vier do ESP32, usa ela; caso contrário usa 220V como fallback
    if dados.get("potencia") is None:
        corrente = dados.get("corrente")
        tensao   = dados.get("tensao") or 220.0   # fallback enquanto sensor não está instalado
        if corrente:
            dados["potencia"] = round(corrente * tensao, 2)
            if not dados.get("tensao"):
                dados["tensao"] = tensao

    db_medicao = models.Medicao(**dados)
    db.add(db_medicao)
    db.commit()
    db.refresh(db_medicao)

    _verificar_alertas(db, db_medicao)
    _atualizar_status_dispositivo(db, db_medicao)

    return db_medicao


@router.get("/", response_model=List[schemas.MedicaoOut])
def listar_medicoes(
    canal_id: Optional[int]      = Query(None),
    inicio:   Optional[datetime] = Query(None),
    fim:      Optional[datetime] = Query(None),
    valido:   Optional[bool]     = Query(None),
    skip:     int                = Query(0, ge=0),
    limit:    int                = Query(100, le=1000),
    db: Session = Depends(get_db),
):
    query = db.query(models.Medicao)
    if canal_id is not None:
        query = query.filter(models.Medicao.canal_id == canal_id)
    if inicio:
        query = query.filter(models.Medicao.timestamp >= inicio)
    if fim:
        query = query.filter(models.Medicao.timestamp <= fim)
    if valido is not None:
        query = query.filter(models.Medicao.valido == valido)
    return query.order_by(models.Medicao.timestamp.desc()).offset(skip).limit(limit).all()


@router.get("/{medicao_id}", response_model=schemas.MedicaoOut)
def obter_medicao(medicao_id: int, db: Session = Depends(get_db)):
    medicao = db.query(models.Medicao).filter(models.Medicao.id == medicao_id).first()
    if not medicao:
        raise HTTPException(status_code=404, detail="Medição não encontrada.")
    return medicao


@router.delete("/{medicao_id}", status_code=204)
def deletar_medicao(medicao_id: int, db: Session = Depends(get_db)):
    medicao = db.query(models.Medicao).filter(models.Medicao.id == medicao_id).first()
    if not medicao:
        raise HTTPException(status_code=404, detail="Medição não encontrada.")
    db.delete(medicao)
    db.commit()