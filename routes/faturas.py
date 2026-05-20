"""
Rotas de faturas com cálculo automático de rateio.

POST /faturas → cadastra fatura e calcula rateio por área automaticamente.
GET  /faturas/{id}/rateio → retorna o rateio calculado.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional

import models, schemas
from database import get_db

router = APIRouter(prefix="/faturas", tags=["Faturas"])


def _calcular_rateio(db: Session, fatura: models.Fatura) -> List[models.Rateio]:
    """
    Calcula e persiste o rateio por área para uma fatura.
    Agrega consumo_diario pelo area_id do quadro de cada canal.
    """
    from sqlalchemy import extract

    mes_ini = fatura.mes.replace(day=1)
    # Último dia do mês
    if mes_ini.month == 12:
        mes_fim = mes_ini.replace(year=mes_ini.year + 1, month=1, day=1)
    else:
        mes_fim = mes_ini.replace(month=mes_ini.month + 1, day=1)

    # kWh por area_id no período da fatura
    rows = (
        db.query(
            models.Quadro.area_id,
            func.sum(models.ConsumoDiario.kwh).label("kwh_total")
        )
        .join(models.Dispositivo,    models.Dispositivo.quadro_id    == models.Quadro.id)
        .join(models.CanalMedicao,   models.CanalMedicao.dispositivo_id == models.Dispositivo.id)
        .join(models.ConsumoDiario,  models.ConsumoDiario.canal_id   == models.CanalMedicao.id)
        .filter(
            models.Quadro.local_id          == fatura.local_id,
            models.ConsumoDiario.data       >= mes_ini,
            models.ConsumoDiario.data       <  mes_fim,
            models.Quadro.area_id           != None,
        )
        .group_by(models.Quadro.area_id)
        .all()
    )

    if not rows:
        return []

    kwh_total = sum(r.kwh_total for r in rows)
    if kwh_total == 0:
        return []

    rateios = []
    for row in rows:
        percentual = round((row.kwh_total / kwh_total) * 100, 2)
        valor_rs   = round((row.kwh_total / kwh_total) * fatura.valor_total, 2)

        # Upsert
        existente = (
            db.query(models.Rateio)
            .filter(
                models.Rateio.fatura_id == fatura.id,
                models.Rateio.area_id   == row.area_id,
            )
            .first()
        )
        if existente:
            existente.kwh        = round(row.kwh_total, 3)
            existente.percentual = percentual
            existente.valor_rs   = valor_rs
            rateios.append(existente)
        else:
            r = models.Rateio(
                fatura_id  = fatura.id,
                area_id    = row.area_id,
                kwh        = round(row.kwh_total, 3),
                percentual = percentual,
                valor_rs   = valor_rs,
            )
            db.add(r)
            rateios.append(r)

    db.commit()
    return rateios


# ── endpoints ────────────────────────────────────────────────────────────────

@router.get("/", response_model=List[schemas.FaturaOut])
def listar_faturas(local_id: Optional[int] = Query(None), db: Session = Depends(get_db)):
    query = db.query(models.Fatura)
    if local_id:
        query = query.filter(models.Fatura.local_id == local_id)
    return query.order_by(models.Fatura.mes.desc()).all()


@router.get("/{fatura_id}", response_model=schemas.FaturaOut)
def obter_fatura(fatura_id: int, db: Session = Depends(get_db)):
    fatura = db.query(models.Fatura).filter(models.Fatura.id == fatura_id).first()
    if not fatura:
        raise HTTPException(status_code=404, detail="Fatura não encontrada.")
    return fatura


@router.post("/", response_model=schemas.FaturaOut, status_code=201)
def criar_fatura(fatura: schemas.FaturaCreate, db: Session = Depends(get_db)):
    """
    Cadastra fatura e calcula rateio automaticamente.
    Requer consumo_diario já preenchido para o mês.
    """
    db_fatura = models.Fatura(**fatura.model_dump())
    db.add(db_fatura)
    db.commit()
    db.refresh(db_fatura)

    # Calcula rateio automaticamente
    _calcular_rateio(db, db_fatura)

    return db_fatura


@router.post("/{fatura_id}/recalcular", response_model=List[schemas.RateioOut])
def recalcular_rateio(fatura_id: int, db: Session = Depends(get_db)):
    """Recalcula o rateio de uma fatura já existente (útil após correções)."""
    fatura = db.query(models.Fatura).filter(models.Fatura.id == fatura_id).first()
    if not fatura:
        raise HTTPException(status_code=404, detail="Fatura não encontrada.")
    rateios = _calcular_rateio(db, fatura)
    for r in rateios:
        db.refresh(r)
    return rateios


@router.get("/{fatura_id}/rateio", response_model=List[schemas.RateioOut])
def rateio_da_fatura(fatura_id: int, db: Session = Depends(get_db)):
    return db.query(models.Rateio).filter(models.Rateio.fatura_id == fatura_id).all()


@router.delete("/{fatura_id}", status_code=204)
def deletar_fatura(fatura_id: int, db: Session = Depends(get_db)):
    fatura = db.query(models.Fatura).filter(models.Fatura.id == fatura_id).first()
    if not fatura:
        raise HTTPException(status_code=404, detail="Fatura não encontrada.")
    db.delete(fatura)
    db.commit()