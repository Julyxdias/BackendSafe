"""
enel_client.py
Cliente HTTP para o microserviço Enel SP (Node.js).

Uso:
    from enel_client import EnelClient

    client = EnelClient()  # lê ENEL_SERVICE_URL e ENEL_SERVICE_KEY do ambiente

    # Consulta direta
    dados = await client.consultar(
        instalacao="7006123456",
        login_email="usuario@email.com",
        login_senha="senha",
    )

    # Consulta via credencial já salva no vault do microserviço
    dados = await client.consultar_salvo(login_email="usuario@email.com")

    # Gerenciar credenciais remotas
    await client.salvar_credencial("usuario@email.com", "senha", "7006123456")
    emails = await client.listar_credenciais()
    await client.remover_credencial("usuario@email.com")

Dependências:
    pip install httpx python-dotenv
"""

import asyncio
import logging
import os
from dataclasses import dataclass, field
from decimal import Decimal
from typing import Optional

import httpx
from dotenv import load_dotenv

load_dotenv()
log = logging.getLogger(__name__)


# ──────────────────────────────────────────────────────────────
# Modelos de dados
# ──────────────────────────────────────────────────────────────

@dataclass
class ItemFatura:
    descricao: str
    valor: Decimal


@dataclass
class Conta:
    mes_referencia: str
    vencimento: Optional[str]
    valor: Decimal
    status: str
    codigo_barras: Optional[str]
    conta_pdf_url: Optional[str]


@dataclass
class DadosOcr:
    cliente: Optional[str]
    distribuidora: Optional[str]
    nota_fiscal: Optional[str]
    aviso: Optional[str]
    endereco: Optional[str]
    codigo_barras: Optional[str]
    classe: Optional[str]
    subclasse: Optional[str]
    grupo: Optional[str]
    subgrupo: Optional[str]
    ref_mes: Optional[int]
    ref_ano: Optional[int]
    emissao_data: Optional[str]
    data_apresentacao: Optional[str]
    leitura_anterior_data: Optional[str]
    leitura_data: Optional[str]
    leitura_proxima_data: Optional[str]
    energia: Optional[Decimal]
    valor: Optional[Decimal]
    vencimento: Optional[str]
    preco_te: Optional[Decimal]
    preco_tusd: Optional[Decimal]
    normalizado_preco_te: Optional[Decimal]
    normalizado_preco_tusd: Optional[Decimal]
    normalizado_valor: Optional[Decimal]
    itens_fatura: list[ItemFatura] = field(default_factory=list)


@dataclass
class RespostaEnel:
    nome: Optional[str]
    instalacao: str
    endereco: Optional[str]
    lista_instalacoes: list[str]
    contas: list[Conta]
    ocr: Optional[DadosOcr]


# ──────────────────────────────────────────────────────────────
# Erros
# ──────────────────────────────────────────────────────────────

class EnelServiceError(Exception):
    def __init__(self, code: str, message: str, status: int):
        self.code = code
        self.message = message
        self.status = status
        super().__init__(f"[{status}] {code}: {message}")


class EnelServiceUnavailable(EnelServiceError):
    """Portal Enel fora do ar ou timeout no scraping."""


# ──────────────────────────────────────────────────────────────
# Cliente
# ──────────────────────────────────────────────────────────────

class EnelClient:
    """
    Cliente assíncrono para o microserviço Enel SP.

    Variáveis de ambiente:
        ENEL_SERVICE_URL  — URL base do microserviço
        ENEL_SERVICE_KEY  — Bearer token opcional
        ENEL_TIMEOUT      — Timeout HTTP em segundos (padrão: 30)
                            O polling aguarda o scraping terminar —
                            não confundir com o tempo total do job.
    """

    def __init__(
        self,
        base_url: str | None = None,
        api_key: str | None = None,
        timeout: float | None = None,
    ):
        self._base_url = (base_url or os.environ["ENEL_SERVICE_URL"]).rstrip("/")
        self._api_key  = api_key or os.getenv("ENEL_SERVICE_KEY")
        self._timeout  = timeout or float(os.getenv("ENEL_TIMEOUT", "30"))

    # ── HTTP base ──────────────────────────────────────────────

    def _headers(self) -> dict:
        h = {"Content-Type": "application/json"}
        if self._api_key:
            h["Authorization"] = f"Bearer {self._api_key}"
        return h

    async def _post(self, path: str, body: dict) -> dict:
        async with httpx.AsyncClient(timeout=self._timeout) as http:
            resp = await http.post(f"{self._base_url}{path}", json=body, headers=self._headers())
            return self._handle(resp)

    async def _get(self, path: str) -> dict:
        async with httpx.AsyncClient(timeout=self._timeout) as http:
            resp = await http.get(f"{self._base_url}{path}", headers=self._headers())
            return self._handle(resp)

    async def _delete(self, path: str) -> dict:
        async with httpx.AsyncClient(timeout=self._timeout) as http:
            resp = await http.delete(f"{self._base_url}{path}", headers=self._headers())
            return self._handle(resp)

    @staticmethod
    def _handle(resp: httpx.Response) -> dict:
        try:
            data = resp.json()
        except Exception:
            resp.raise_for_status()
            return {}
        if resp.is_error:
            err    = data.get("error", {})
            code   = err.get("code", "UNKNOWN")
            msg    = err.get("message", resp.text)
            status = resp.status_code
            if status in (503, 504):
                raise EnelServiceUnavailable(code, msg, status)
            raise EnelServiceError(code, msg, status)
        return data

    # ── Polling ────────────────────────────────────────────────

    async def _aguardar_job(self, job_id: str, intervalo: float = 5.0) -> dict:
        """
        Faz poll em GET /api/enel-sp/job/:id até status concluido ou erro.
        O scraping do Playwright pode levar 30-120s — o poll aguarda sem timeout.
        """
        while True:
            data   = await self._get(f"/api/enel-sp/job/{job_id}")
            status = data.get("status")

            if status == "concluido":
                return data["result"]

            if status == "erro":
                err         = data.get("error", {})
                code        = err.get("code", "UNKNOWN")
                msg         = err.get("message", "Erro no job")
                status_code = err.get("status", 503)
                if status_code in (503, 504):
                    raise EnelServiceUnavailable(code, msg, status_code)
                raise EnelServiceError(code, msg, status_code)

            log.debug("Job %s status=%s — aguardando %.0fs...", job_id, status, intervalo)
            await asyncio.sleep(intervalo)

    # ── Parsing ────────────────────────────────────────────────

    @staticmethod
    def _parse_conta(c: dict) -> Conta:
        return Conta(
            mes_referencia=c.get("mes_referencia", ""),
            vencimento=c.get("vencimento"),
            valor=Decimal(str(c.get("valor") or 0)),
            status=c.get("status", ""),
            codigo_barras=c.get("codigo_barras"),
            conta_pdf_url=c.get("conta_pdf_url"),
        )

    @staticmethod
    def _parse_ocr(o: dict | None) -> DadosOcr | None:
        if not o:
            return None
        return DadosOcr(
            cliente=o.get("cliente"),
            distribuidora=o.get("distribuidora"),
            nota_fiscal=o.get("nota_fiscal"),
            aviso=o.get("aviso"),
            endereco=o.get("endereco"),
            codigo_barras=o.get("codigo_barras"),
            classe=o.get("classe"),
            subclasse=o.get("subclasse"),
            grupo=o.get("grupo"),
            subgrupo=o.get("subgrupo"),
            ref_mes=int(o["ref_mes"]) if o.get("ref_mes") else None,
            ref_ano=int(o["ref_ano"]) if o.get("ref_ano") else None,
            emissao_data=o.get("emissao_data"),
            data_apresentacao=o.get("data_apresentacao"),
            leitura_anterior_data=o.get("leitura_anterior_data"),
            leitura_data=o.get("leitura_data"),
            leitura_proxima_data=o.get("leitura_proxima_data"),
            energia=Decimal(str(o["energia"])) if o.get("energia") is not None else None,
            valor=Decimal(str(o["valor"])) if o.get("valor") is not None else None,
            vencimento=o.get("vencimento"),
            preco_te=Decimal(str(o["preco_te"])) if o.get("preco_te") is not None else None,
            preco_tusd=Decimal(str(o["preco_tusd"])) if o.get("preco_tusd") is not None else None,
            normalizado_preco_te=Decimal(str(o["normalizado_preco_te"])) if o.get("normalizado_preco_te") is not None else None,
            normalizado_preco_tusd=Decimal(str(o["normalizado_preco_tusd"])) if o.get("normalizado_preco_tusd") is not None else None,
            normalizado_valor=Decimal(str(o["normalizado_valor"])) if o.get("normalizado_valor") is not None else None,
            itens_fatura=[
                ItemFatura(descricao=i["descricao"], valor=Decimal(str(i["valor"])))
                for i in o.get("itens_fatura") or []
            ],
        )

    @staticmethod
    def _parse_resposta(data: dict) -> RespostaEnel:
        return RespostaEnel(
            nome=data.get("nome"),
            instalacao=data.get("instalacao", ""),
            endereco=data.get("endereco"),
            lista_instalacoes=data.get("lista_instalacoes") or [],
            contas=[EnelClient._parse_conta(c) for c in data.get("contas") or []],
            ocr=EnelClient._parse_ocr(data.get("ocr")),
        )

    # ── API pública ────────────────────────────────────────────

    async def consultar(
        self,
        instalacao: str,
        login_email: str,
        login_senha: str,
        salvar_credencial: bool = False,
    ) -> RespostaEnel:
        """Dispara job e aguarda conclusão via polling."""
        data = await self._post("/api/enel-sp/contas", {
            "instalacao":       instalacao,
            "login_email":      login_email,
            "login_senha":      login_senha,
            "salvar_credencial": salvar_credencial,
        })
        result = await self._aguardar_job(data["job_id"])
        return self._parse_resposta(result)

    async def consultar_salvo(self, login_email: str) -> RespostaEnel:
        """Dispara job com credencial do vault e aguarda via polling."""
        data = await self._post("/api/enel-sp/contas/salvo", {
            "login_email": login_email,
        })
        result = await self._aguardar_job(data["job_id"])
        return self._parse_resposta(result)

    async def salvar_credencial(self, login_email: str, login_senha: str, instalacao: str) -> None:
        """Salva credencial no vault do microserviço."""
        await self._post("/api/enel-sp/contas", {
            "instalacao":        instalacao,
            "login_email":       login_email,
            "login_senha":       login_senha,
            "salvar_credencial": True,
        })
        log.info("Credencial salva no vault: %s", login_email)

    async def listar_credenciais(self) -> list[str]:
        data = await self._get("/api/secrets")
        return data.get("emails", [])

    async def remover_credencial(self, login_email: str) -> bool:
        data = await self._delete(f"/api/secrets/{login_email}")
        return data.get("deleted", False)