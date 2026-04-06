from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import date

import models, schemas
from database import get_db

router = APIRouter(prefix="/consumo", tags=["Consumo Diário"])


@router.get("/", response_model=List[schemas.ConsumoDiarioOut])
def listar_consumo(
    canal_id:  Optional[int]  = Query(None),
    data_ini:  Optional[date] = Query(None),
    data_fim:  Optional[date] = Query(None),
    skip: int  = Query(0, ge=0),
    limit: int = Query(100, le=1000),
    db: Session = Depends(get_db),
):
    query = db.query(models.ConsumoDiario)
    if canal_id:
        query = query.filter(models.ConsumoDiario.canal_id == canal_id)
    if data_ini:
        query = query.filter(models.ConsumoDiario.data >= data_ini)
    if data_fim:
        query = query.filter(models.ConsumoDiario.data <= data_fim)
    return query.order_by(models.ConsumoDiario.data.desc()).offset(skip).limit(limit).all()


@router.post("/", response_model=schemas.ConsumoDiarioOut, status_code=201)
def registrar_consumo(consumo: schemas.ConsumoDiarioCreate, db: Session = Depends(get_db)):
    db_consumo = models.ConsumoDiario(**consumo.model_dump())
    db.add(db_consumo)
    db.commit()
    db.refresh(db_consumo)
    return db_consumo