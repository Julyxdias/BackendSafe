from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime, date


# ──────────────────────────────────────────
# LOCAL
# ──────────────────────────────────────────

class LocalBase(BaseModel):
    nome: str
    andar: Optional[int] = None
    descricao: Optional[str] = None

class LocalCreate(LocalBase): pass

class LocalOut(LocalBase):
    id: int
    class Config: from_attributes = True


# ──────────────────────────────────────────
# AREA
# ──────────────────────────────────────────

class AreaBase(BaseModel):
    nome: str
    local_id: Optional[int] = None
    descricao: Optional[str] = None

class AreaCreate(AreaBase): pass

class AreaOut(AreaBase):
    id: int
    class Config: from_attributes = True


# ──────────────────────────────────────────
# QUADRO
# ──────────────────────────────────────────

class QuadroBase(BaseModel):
    nome: str
    local_id: Optional[int] = None
    area_id: Optional[int] = None
    quadro_pai_id: Optional[int] = None
    descricao: Optional[str] = None

class QuadroCreate(QuadroBase): pass

class QuadroOut(QuadroBase):
    id: int
    class Config: from_attributes = True


# ──────────────────────────────────────────
# DISPOSITIVO
# ──────────────────────────────────────────

class DispositivoBase(BaseModel):
    nome: str
    quadro_id: Optional[int] = None
    ativo: bool = True
    data_instalacao: Optional[datetime] = None
    observacoes: Optional[str] = None

class DispositivoCreate(DispositivoBase): pass

class DispositivoOut(DispositivoBase):
    id: int
    class Config: from_attributes = True


# ──────────────────────────────────────────
# CANAL DE MEDIÇÃO
# ──────────────────────────────────────────

class CanalMedicaoBase(BaseModel):
    dispositivo_id: Optional[int] = None
    fase: Optional[str] = None
    tipo: Optional[str] = None
    descricao: Optional[str] = None

class CanalMedicaoCreate(CanalMedicaoBase): pass

class CanalMedicaoOut(CanalMedicaoBase):
    id: int
    class Config: from_attributes = True


# ──────────────────────────────────────────
# MEDIÇÃO
# ──────────────────────────────────────────

class MedicaoBase(BaseModel):
    timestamp: datetime
    canal_id: Optional[int] = None
    corrente: Optional[float] = None
    tensao: Optional[float] = None
    potencia: Optional[float] = None
    valido: bool = True

class MedicaoCreate(MedicaoBase): pass

class MedicaoOut(MedicaoBase):
    id: int
    criado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# ALERTA
# ──────────────────────────────────────────

class AlertaCreate(BaseModel):
    canal_id: int
    tipo: str
    nivel: str
    mensagem: Optional[str] = None
    valor: Optional[float] = None
    limite: Optional[float] = None
    timestamp: datetime

class AlertaOut(BaseModel):
    id: int
    canal_id: Optional[int] = None
    tipo: Optional[str] = None
    nivel: Optional[str] = None
    mensagem: Optional[str] = None
    valor: Optional[float] = None
    limite: Optional[float] = None
    timestamp: datetime
    resolvido: bool
    criado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# CONSUMO DIÁRIO
# ──────────────────────────────────────────

class ConsumoDiarioBase(BaseModel):
    canal_id: int
    data: date
    kwh: float

class ConsumoDiarioCreate(ConsumoDiarioBase): pass

class ConsumoDiarioOut(ConsumoDiarioBase):
    id: int
    criado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# FATURA
# ──────────────────────────────────────────

class FaturaBase(BaseModel):
    local_id: Optional[int] = None
    mes: date
    valor_total: float
    kwh_total: Optional[float] = None
    descricao: Optional[str] = None

class FaturaCreate(FaturaBase): pass

class FaturaOut(FaturaBase):
    id: int
    criado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# RATEIO
# ──────────────────────────────────────────

class RateioBase(BaseModel):
    fatura_id: int
    area_id: int
    kwh: float
    percentual: float
    valor_rs: float

class RateioCreate(RateioBase): pass

class RateioOut(RateioBase):
    id: int
    gerado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# TARIFA
# ──────────────────────────────────────────

class TarifaBase(BaseModel):
    local_id: Optional[int] = None
    valor_kwh: float
    vigencia: date
    descricao: Optional[str] = None

class TarifaCreate(TarifaBase): pass

class TarifaOut(TarifaBase):
    id: int
    criado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# META
# ──────────────────────────────────────────

class MetaBase(BaseModel):
    local_id: Optional[int] = None
    quadro_id: Optional[int] = None
    descricao: Optional[str] = None
    kwh_baseline: float
    kwh_meta: float
    data_inicio: date
    data_fim: Optional[date] = None

class MetaCreate(MetaBase): pass

class MetaOut(MetaBase):
    id: int
    criado_em: Optional[datetime] = None
    class Config: from_attributes = True


# ──────────────────────────────────────────
# DISPOSITIVO STATUS
# ──────────────────────────────────────────

class DispositivoStatusOut(BaseModel):
    id: int
    dispositivo_id: Optional[int] = None
    status: Optional[str] = None
    ultima_leitura: Optional[datetime] = None
    potencia_atual: Optional[float] = None
    atualizado_em: Optional[datetime] = None
    class Config: from_attributes = True
