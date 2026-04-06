from sqlalchemy import (
    Column, Integer, BigInteger, String, Float, Boolean,
    DateTime, Date, ForeignKey, Text, Index, CheckConstraint, Numeric
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base


class Local(Base):
    __tablename__ = "locais"

    id        = Column(Integer, primary_key=True, index=True)
    nome      = Column(Text, nullable=False)
    andar     = Column(Integer, nullable=True)
    descricao = Column(Text, nullable=True)

    areas   = relationship("Area", back_populates="local")
    quadros = relationship("Quadro", back_populates="local")
    faturas = relationship("Fatura", back_populates="local")
    tarifas = relationship("Tarifa", back_populates="local")
    metas   = relationship("Meta", back_populates="local")


class Area(Base):
    __tablename__ = "areas"

    id        = Column(Integer, primary_key=True, index=True)
    nome      = Column(Text, nullable=False)
    local_id  = Column(Integer, ForeignKey("locais.id"), nullable=True)
    descricao = Column(Text, nullable=True)

    local   = relationship("Local", back_populates="areas")
    quadros = relationship("Quadro", back_populates="area")
    rateios = relationship("Rateio", back_populates="area")


class Quadro(Base):
    __tablename__ = "quadros"

    id            = Column(Integer, primary_key=True, index=True)
    nome          = Column(Text, nullable=False)
    local_id      = Column(Integer, ForeignKey("locais.id"), nullable=True)
    area_id       = Column(Integer, ForeignKey("areas.id"), nullable=True)
    quadro_pai_id = Column(Integer, ForeignKey("quadros.id"), nullable=True)
    descricao     = Column(Text, nullable=True)

    local        = relationship("Local", back_populates="quadros")
    area         = relationship("Area", back_populates="quadros")
    quadro_pai   = relationship("Quadro", remote_side=[id], backref="sub_quadros")
    dispositivos = relationship("Dispositivo", back_populates="quadro")
    metas        = relationship("Meta", back_populates="quadro")


class Dispositivo(Base):
    __tablename__ = "dispositivos"

    id              = Column(Integer, primary_key=True, index=True)
    nome            = Column(Text, nullable=False)
    quadro_id       = Column(Integer, ForeignKey("quadros.id"), nullable=True)
    ativo           = Column(Boolean, default=True)
    data_instalacao = Column(DateTime, nullable=True)
    observacoes     = Column(Text, nullable=True)

    quadro  = relationship("Quadro", back_populates="dispositivos")
    canais  = relationship("CanalMedicao", back_populates="dispositivo")
    status  = relationship("DispositivoStatus", back_populates="dispositivo", uselist=False)


class CanalMedicao(Base):
    __tablename__ = "canais_medicao"

    id             = Column(Integer, primary_key=True, index=True)
    dispositivo_id = Column(Integer, ForeignKey("dispositivos.id"), nullable=True)
    fase           = Column(Text, nullable=True)
    tipo           = Column(Text, nullable=True)
    descricao      = Column(Text, nullable=True)

    __table_args__ = (
        CheckConstraint("fase IN ('A','B','C')", name="ck_canal_fase"),
    )

    dispositivo     = relationship("Dispositivo", back_populates="canais")
    medicoes        = relationship("Medicao", back_populates="canal")
    alertas         = relationship("Alerta", back_populates="canal")
    consumo_diario  = relationship("ConsumoDiario", back_populates="canal")


class Medicao(Base):
    __tablename__ = "medicoes"

    id        = Column(BigInteger, primary_key=True, index=True)
    timestamp = Column(DateTime, nullable=False)
    canal_id  = Column(Integer, ForeignKey("canais_medicao.id"), nullable=True)
    corrente  = Column(Float, nullable=True)
    tensao    = Column(Float, nullable=True)
    potencia  = Column(Float, nullable=True)
    valido    = Column(Boolean, default=True)
    criado_em = Column(DateTime, server_default=func.now())

    canal = relationship("CanalMedicao", back_populates="medicoes")

    __table_args__ = (
        Index("idx_medicoes_timestamp", "timestamp"),
        Index("idx_medicoes_canal",     "canal_id"),
    )


class Alerta(Base):
    __tablename__ = "alertas"

    id        = Column(Integer, primary_key=True, index=True)
    canal_id  = Column(Integer, ForeignKey("canais_medicao.id"), nullable=True)
    tipo      = Column(Text, nullable=True)
    nivel     = Column(Text, nullable=True)
    mensagem  = Column(Text, nullable=True)
    valor     = Column(Float, nullable=True)
    limite    = Column(Float, nullable=True)
    timestamp = Column(DateTime, nullable=False)
    resolvido = Column(Boolean, default=False)
    criado_em = Column(DateTime, server_default=func.now())

    canal = relationship("CanalMedicao", back_populates="alertas")

    __table_args__ = (
        Index("idx_alertas_timestamp", "timestamp"),
    )


class ConsumoDiario(Base):
    __tablename__ = "consumo_diario"

    id        = Column(BigInteger, primary_key=True, index=True)
    canal_id  = Column(Integer, ForeignKey("canais_medicao.id"), nullable=True)
    data      = Column(Date, nullable=False)
    kwh       = Column(Float, nullable=False)
    criado_em = Column(DateTime, server_default=func.now())

    canal = relationship("CanalMedicao", back_populates="consumo_diario")

    __table_args__ = (
        Index("idx_consumo_diario_data", "canal_id", "data"),
    )


class Fatura(Base):
    __tablename__ = "faturas"

    id          = Column(Integer, primary_key=True, index=True)
    local_id    = Column(Integer, ForeignKey("locais.id"), nullable=True)
    mes         = Column(Date, nullable=False)
    valor_total = Column(Float, nullable=False)
    kwh_total   = Column(Float, nullable=True)
    descricao   = Column(Text, nullable=True)
    criado_em   = Column(DateTime, server_default=func.now())

    local   = relationship("Local", back_populates="faturas")
    rateios = relationship("Rateio", back_populates="fatura")


class Rateio(Base):
    __tablename__ = "rateio"

    id         = Column(BigInteger, primary_key=True, index=True)
    fatura_id  = Column(Integer, ForeignKey("faturas.id"), nullable=True)
    area_id    = Column(Integer, ForeignKey("areas.id"), nullable=True)
    kwh        = Column(Float, nullable=False)
    percentual = Column(Float, nullable=False)
    valor_rs   = Column(Float, nullable=False)
    gerado_em  = Column(DateTime, server_default=func.now())

    fatura = relationship("Fatura", back_populates="rateios")
    area   = relationship("Area", back_populates="rateios")


class Tarifa(Base):
    __tablename__ = "tarifas"

    id        = Column(Integer, primary_key=True, index=True)
    local_id  = Column(Integer, ForeignKey("locais.id"), nullable=True)
    valor_kwh = Column(Float, nullable=False)
    vigencia  = Column(Date, nullable=False)
    descricao = Column(Text, nullable=True)
    criado_em = Column(DateTime, server_default=func.now())

    local = relationship("Local", back_populates="tarifas")

    __table_args__ = (
        Index("idx_tarifas_local", "local_id", "vigencia"),
    )


class Meta(Base):
    __tablename__ = "metas"

    id           = Column(Integer, primary_key=True, index=True)
    local_id     = Column(Integer, ForeignKey("locais.id"), nullable=True)
    quadro_id    = Column(Integer, ForeignKey("quadros.id"), nullable=True)
    descricao    = Column(Text, nullable=True)
    kwh_baseline = Column(Float, nullable=False)
    kwh_meta     = Column(Float, nullable=False)
    data_inicio  = Column(Date, nullable=False)
    data_fim     = Column(Date, nullable=True)
    criado_em    = Column(DateTime, server_default=func.now())

    local  = relationship("Local", back_populates="metas")
    quadro = relationship("Quadro", back_populates="metas")


class DispositivoStatus(Base):
    __tablename__ = "dispositivos_status"

    id             = Column(Integer, primary_key=True, index=True)
    dispositivo_id = Column(Integer, ForeignKey("dispositivos.id"), nullable=True, unique=True)
    status         = Column(Text, nullable=True)   # ONLINE | ATRASO | OFFLINE
    ultima_leitura = Column(DateTime, nullable=True)
    potencia_atual = Column(Float, nullable=True)
    atualizado_em  = Column(DateTime, server_default=func.now())

    __table_args__ = (
        CheckConstraint("status IN ('ONLINE','ATRASO','OFFLINE')", name="ck_status_valor"),
    )

    dispositivo = relationship("Dispositivo", back_populates="status")
