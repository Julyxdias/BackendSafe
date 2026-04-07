from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

import models, schemas
from database import get_db

router = APIRouter(prefix="/metas", tags=["Metas"])


@router.get("/", response_model=List[schemas.MetaOut])
def listar_metas(
    local_id:  Optional[int] = Query(None),
    quadro_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(models.Meta)
    if local_id:
        query = query.filter(models.Meta.local_id == local_id)
    if quadro_id:
        query = query.filter(models.Meta.quadro_id == quadro_id)
    return query.order_by(models.Meta.data_inicio.desc()).all()


@router.get("/{meta_id}", response_model=schemas.MetaOut)
def obter_meta(meta_id: int, db: Session = Depends(get_db)):
    meta = db.query(models.Meta).filter(models.Meta.id == meta_id).first()
    if not meta:
        raise HTTPException(status_code=404, detail="Meta não encontrada.")
    return meta


@router.post("/", response_model=schemas.MetaOut, status_code=201)
def criar_meta(meta: schemas.MetaCreate, db: Session = Depends(get_db)):
    db_meta = models.Meta(**meta.model_dump())
    db.add(db_meta)
    db.commit()
    db.refresh(db_meta)
    return db_meta


@router.delete("/{meta_id}", status_code=204)
def deletar_meta(meta_id: int, db: Session = Depends(get_db)):
    meta = db.query(models.Meta).filter(models.Meta.id == meta_id).first()
    if not meta:
        raise HTTPException(status_code=404, detail="Meta não encontrada.")
    db.delete(meta)
    db.commit()