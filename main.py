from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from database import engine
import models
from routes import (
    locais, areas, quadros, dispositivos,
    canais, medicoes, alertas,
    consumo, faturas, tarifas, metas,
    jobs, relatorios
)

# APScheduler — job noturno de consumo_diario
from apscheduler.schedulers.background import BackgroundScheduler
from routes.jobs import job_noturno

scheduler = BackgroundScheduler(timezone="America/Sao_Paulo")
scheduler.add_job(job_noturno, "cron", hour=0, minute=5)  # todo dia 00:05


@asynccontextmanager
async def lifespan(app: FastAPI):
    models.Base.metadata.create_all(bind=engine)
    scheduler.start()
    yield
    scheduler.shutdown()


app = FastAPI(
    title="EnergySafe API",
    description="Monitoramento energético: Local → Área → Quadro → Dispositivo → Canal → Medição → Alerta",
    version="2.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://energy-safe-9m2q.vercel.app"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Estrutura física
app.include_router(locais.router)
app.include_router(areas.router)
app.include_router(quadros.router)
app.include_router(dispositivos.router)
app.include_router(canais.router)

# Medições e alertas
app.include_router(medicoes.router)
app.include_router(alertas.router)

# Financeiro
app.include_router(consumo.router)
app.include_router(faturas.router)
app.include_router(tarifas.router)
app.include_router(metas.router)

# Operacional
app.include_router(jobs.router)
app.include_router(relatorios.router)


@app.get("/", tags=["Health"])
def health_check():
    return {"status": "ok", "service": "EnergySafe API", "version": "2.0.0"}
