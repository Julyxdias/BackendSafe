from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

import models, schemas
from database import get_db

router = APIRouter(prefix="/tarifas", tags=["Tarifas"])


@router.get("/", response_model=List[schemas.TarifaOut])
def listar_tarifas(local_id: Optional[int] = Query(None), db: Session = Depends(get_db)):
    query = db.query(models.Tarifa)
    if local_id:
        query = query.filter(models.Tarifa.local_id == local_id)
    return query.order_by(models.Tarifa.vigencia.desc()).all()


@router.post("/", response_model=schemas.TarifaOut, status_code=201)
def criar_tarifa(tarifa: schemas.TarifaCreate, db: Session = Depends(get_db)):
    db_tarifa = models.Tarifa(**tarifa.model_dump())
    db.add(db_tarifa)
    db.commit()
    db.refresh(db_tarifa)
    return db_tarifa


@router.delete("/{tarifa_id}", status_code=204)
def deletar_tarifa(tarifa_id: int, db: Session = Depends(get_db)):
    tarifa = db.query(models.Tarifa).filter(models.Tarifa.id == tarifa_id).first()
    if not tarifa:
        raise HTTPException(status_code=404, detail="Tarifa não encontrada.")
    db.delete(tarifa)
    db.commit()