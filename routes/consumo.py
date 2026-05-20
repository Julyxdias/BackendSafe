from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import Optional, Any, Dict
from datetime import date

import models, schemas
from database import get_db

router = APIRouter(prefix="/consumo", tags=["Consumo Diário"])


def _periodo(query, data_ini, data_fim):
    if data_ini:
        query = query.filter(models.ConsumoDiario.data >= data_ini)
    if data_fim:
        query = query.filter(models.ConsumoDiario.data <= data_fim)
    return query


@router.get("/")
def listar_consumo(
    local_id:  Optional[int]  = Query(None, description="0 ou ausente = geral"),
    quadro_id: Optional[int]  = Query(None),
    sensor_id: Optional[int]  = Query(None, description="canal_id do sensor"),
    data_ini:  Optional[date] = Query(None),
    data_fim:  Optional[date] = Query(None),
    skip:      int            = Query(0, ge=0),
    limit:     int            = Query(100, le=1000),
    db: Session = Depends(get_db),
) -> Dict[str, Any]:
    """
    Endpoint de consumo com agrupamento dinamico por nivel.
    Prioridade: sensor_id > quadro_id > local_id

    | Parametros           | Nivel  | Agrupamento                     |
    |----------------------|--------|---------------------------------|
    | nenhum / local_id=0  | geral  | soma total, detalhado por local  |
    | local_id > 0         | local  | soma por quadro do local         |
    | quadro_id            | quadro | soma por sensor (fases A+B+C)    |
    | sensor_id            | sensor | registros diarios do canal       |
    """

    # Nivel 4: sensor_id -> detalhe diario do canal
    if sensor_id is not None and sensor_id > 0:
        query = db.query(models.ConsumoDiario).filter(
            models.ConsumoDiario.canal_id == sensor_id
        )
        query = _periodo(query, data_ini, data_fim)
        rows  = query.order_by(models.ConsumoDiario.data.desc()).offset(skip).limit(limit).all()

        return {
            "nivel":     "sensor",
            "sensor_id": sensor_id,
            "total_kwh": round(sum(r.kwh or 0 for r in rows), 4),
            "dados": [
                {"data": str(r.data), "kwh": round(r.kwh or 0, 4)}
                for r in rows
            ],
        }

    # Nivel 3: quadro_id -> soma por sensor (canal), mostra fases A+B+C individualmente
    if quadro_id is not None and quadro_id > 0:
        query = (
            db.query(
                models.CanalMedicao.id.label("sensor_id"),
                models.CanalMedicao.fase.label("fase"),
                models.CanalMedicao.descricao.label("descricao"),
                func.sum(models.ConsumoDiario.kwh).label("kwh"),
            )
            .join(models.CanalMedicao, models.CanalMedicao.id     == models.ConsumoDiario.canal_id)
            .join(models.Dispositivo,  models.Dispositivo.id      == models.CanalMedicao.dispositivo_id)
            .filter(models.Dispositivo.quadro_id == quadro_id)
        )
        query = _periodo(query, data_ini, data_fim)
        rows  = (
            query
            .group_by(
                models.CanalMedicao.id,
                models.CanalMedicao.fase,
                models.CanalMedicao.descricao,
            )
            .offset(skip).limit(limit).all()
        )

        total = sum(r.kwh or 0 for r in rows)
        return {
            "nivel":     "quadro",
            "quadro_id": quadro_id,
            "total_kwh": round(total, 4),
            "dados": [
                {
                    "sensor_id": r.sensor_id,
                    "fase":      r.fase or "-",
                    "descricao": r.descricao or f"Sensor {r.sensor_id}",
                    "kwh":       round(r.kwh or 0, 4),
                }
                for r in rows
            ],
        }

    # Nivel 2: local_id > 0 -> soma por quadro (cada quadro = soma dos seus canais)
    if local_id is not None and local_id > 0:
        query = (
            db.query(
                models.Quadro.id.label("quadro_id"),
                models.Quadro.nome.label("quadro_nome"),
                func.sum(models.ConsumoDiario.kwh).label("kwh"),
            )
            .join(models.CanalMedicao, models.CanalMedicao.id  == models.ConsumoDiario.canal_id)
            .join(models.Dispositivo,  models.Dispositivo.id   == models.CanalMedicao.dispositivo_id)
            .join(models.Quadro,       models.Quadro.id        == models.Dispositivo.quadro_id)
            .filter(models.Quadro.local_id == local_id)
        )
        query = _periodo(query, data_ini, data_fim)
        rows  = (
            query
            .group_by(models.Quadro.id, models.Quadro.nome)
            .offset(skip).limit(limit).all()
        )

        total = sum(r.kwh or 0 for r in rows)
        return {
            "nivel":     "local",
            "local_id":  local_id,
            "total_kwh": round(total, 4),
            "dados": [
                {
                    "quadro_id":   r.quadro_id,
                    "quadro_nome": r.quadro_nome or f"Quadro {r.quadro_id}",
                    "kwh":         round(r.kwh or 0, 4),
                }
                for r in rows
            ],
        }

    # Nivel 1: geral (local_id=0 ou nenhum parametro) -> soma por local
    query = (
        db.query(
            models.Local.id.label("local_id"),
            models.Local.nome.label("local_nome"),
            func.sum(models.ConsumoDiario.kwh).label("kwh"),
        )
        .join(models.CanalMedicao, models.CanalMedicao.id  == models.ConsumoDiario.canal_id)
        .join(models.Dispositivo,  models.Dispositivo.id   == models.CanalMedicao.dispositivo_id)
        .join(models.Quadro,       models.Quadro.id        == models.Dispositivo.quadro_id)
        .join(models.Local,        models.Local.id         == models.Quadro.local_id)
    )
    query = _periodo(query, data_ini, data_fim)
    rows  = (
        query
        .group_by(models.Local.id, models.Local.nome)
        .offset(skip).limit(limit).all()
    )

    total = sum(r.kwh or 0 for r in rows)
    return {
        "nivel":     "geral",
        "total_kwh": round(total, 4),
        "dados": [
            {
                "local_id":   r.local_id,
                "local_nome": r.local_nome or f"Local {r.local_id}",
                "kwh":        round(r.kwh or 0, 4),
            }
            for r in rows
        ],
    }


# POST: registro manual (inalterado)
@router.post("/", response_model=schemas.ConsumoDiarioOut, status_code=201)
def registrar_consumo(consumo: schemas.ConsumoDiarioCreate, db: Session = Depends(get_db)):
    db_consumo = models.ConsumoDiario(**consumo.model_dump())
    db.add(db_consumo)
    db.commit()
    db.refresh(db_consumo)
    return db_consumo