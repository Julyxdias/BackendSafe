from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

import models, schemas
from database import get_db

router = APIRouter(prefix="/areas", tags=["Áreas"])


@router.get("/", response_model=List[schemas.AreaOut])
def listar_areas(local_id: Optional[int] = Query(None), db: Session = Depends(get_db)):
    query = db.query(models.Area)
    if local_id:
        query = query.filter(models.Area.local_id == local_id)
    return query.order_by(models.Area.nome).all()


@router.get("/{area_id}", response_model=schemas.AreaOut)
def obter_area(area_id: int, db: Session = Depends(get_db)):
    area = db.query(models.Area).filter(models.Area.id == area_id).first()
    if not area:
        raise HTTPException(status_code=404, detail="Área não encontrada.")
    return area


@router.post("/", response_model=schemas.AreaOut, status_code=201)
def criar_area(area: schemas.AreaCreate, db: Session = Depends(get_db)):
    db_area = models.Area(**area.model_dump())
    db.add(db_area)
    db.commit()
    db.refresh(db_area)
    return db_area


@router.delete("/{area_id}", status_code=204)
def deletar_area(area_id: int, db: Session = Depends(get_db)):
    area = db.query(models.Area).filter(models.Area.id == area_id).first()
    if not area:
        raise HTTPException(status_code=404, detail="Área não encontrada.")
    db.delete(area)
    db.commit()