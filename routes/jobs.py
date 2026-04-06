###
##Job de cálculo diário de consumo_diario.

##- Pode ser disparado manualmente via POST /jobs/consumo-diario
##- Roda automaticamente todo dia à meia-noite via APScheduler
##- Calcula kWh por canal por dia usando integração trapezoidal
##  kWh = SOMA( (P_i + P_{i+1}) / 2 × Δt_horas ) / 1000
###

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, text
from datetime import date, datetime, timedelta
from typing import Optional
import logging

import models
from database import get_db, SessionLocal

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/jobs", tags=["Jobs"])


def calcular_consumo_dia(db: Session, data_alvo: date) -> dict:
    """
    Calcula e persiste kWh por canal para um dia específico.
    Retorna resumo com quantos canais foram processados.
    """
    inicio = datetime.combine(data_alvo, datetime.min.time())
    fim    = datetime.combine(data_alvo, datetime.max.time())

    # Busca todos os canais que tiveram leitura no dia
    canais = (
        db.query(models.Medicao.canal_id)
        .filter(models.Medicao.timestamp.between(inicio, fim))
        .filter(models.Medicao.valido == True)
        .distinct()
        .all()
    )

    processados = 0
    ignorados   = 0

    for (canal_id,) in canais:
        medicoes = (
            db.query(models.Medicao)
            .filter(
                models.Medicao.canal_id == canal_id,
                models.Medicao.timestamp.between(inicio, fim),
                models.Medicao.valido   == True,
                models.Medicao.potencia != None,
            )
            .order_by(models.Medicao.timestamp.asc())
            .all()
        )

        if len(medicoes) < 2:
            ignorados += 1
            continue

        # Integração trapezoidal: área sob a curva de potência
        kwh = 0.0
        for i in range(len(medicoes) - 1):
            p1 = medicoes[i].potencia
            p2 = medicoes[i + 1].potencia
            dt = (medicoes[i + 1].timestamp - medicoes[i].timestamp).total_seconds() / 3600
            kwh += ((p1 + p2) / 2) * dt / 1000  # W → kWh

        kwh = round(kwh, 4)

        # Upsert — se já existe para este canal/dia, atualiza
        existente = (
            db.query(models.ConsumoDiario)
            .filter(
                models.ConsumoDiario.canal_id == canal_id,
                models.ConsumoDiario.data     == data_alvo,
            )
            .first()
        )

        if existente:
            existente.kwh = kwh
        else:
            db.add(models.ConsumoDiario(
                canal_id = canal_id,
                data     = data_alvo,
                kwh      = kwh,
            ))

        processados += 1

    db.commit()
    logger.info(f"consumo_diario [{data_alvo}]: {processados} canais processados, {ignorados} ignorados.")
    return {"data": str(data_alvo), "processados": processados, "ignorados": ignorados}


def job_noturno():
    """Função chamada pelo APScheduler — calcula o dia anterior."""
    db = SessionLocal()
    try:
        ontem = date.today() - timedelta(days=1)
        calcular_consumo_dia(db, ontem)
    except Exception as e:
        logger.error(f"Erro no job noturno: {e}")
    finally:
        db.close()


# ── endpoints manuais ────────────────────────────────────────────────────────

@router.post("/consumo-diario", summary="Dispara cálculo de consumo_diario manualmente")
def disparar_job(
    data: Optional[date] = Query(None, description="Data alvo (padrão: ontem)"),
    db: Session = Depends(get_db),
):
    """
    Calcula kWh por canal para uma data específica.
    Se não informada, usa o dia anterior.
    Seguro para reprocessar — faz upsert.
    """
    data_alvo = data or (date.today() - timedelta(days=1))
    resultado = calcular_consumo_dia(db, data_alvo)
    return {"status": "ok", **resultado}


@router.post("/consumo-diario/range", summary="Reprocessa um intervalo de datas")
def reprocessar_range(
    data_ini: date = Query(...),
    data_fim: date = Query(...),
    db: Session = Depends(get_db),
):
    """Útil para backfill quando há dados históricos."""
    if data_fim < data_ini:
        return {"error": "data_fim deve ser >= data_ini"}

    resultados = []
    dia = data_ini
    while dia <= data_fim:
        resultados.append(calcular_consumo_dia(db, dia))
        dia += timedelta(days=1)

    total_processados = sum(r["processados"] for r in resultados)
    return {"status": "ok", "dias": len(resultados), "total_canais": total_processados, "detalhes": resultados}