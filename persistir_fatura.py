"""
persistir_fatura.py
Persiste a saída do EnelClient no PostgreSQL.

Uso:
    from persistir_fatura import persistir_fatura
    await persistir_fatura(pool, local_id=1, dados=resposta_enel)

Dependências:
    pip install asyncpg
"""

import logging
from decimal import Decimal

import asyncpg

from enel_client import RespostaEnel

log = logging.getLogger(__name__)


# ──────────────────────────────────────────────────────────────
# Conversores de data
# ──────────────────────────────────────────────────────────────

def _mes_para_date(mes_ref: str | None) -> str | None:
    """'04/2025' → '2025-04-01'"""
    if not mes_ref:
        return None
    mm, yyyy = mes_ref.split("/")
    return f"{yyyy}-{mm.zfill(2)}-01"


def _br_para_iso(data_br: str | None) -> str | None:
    """'10/05/2025' → '2025-05-10'"""
    if not data_br:
        return None
    partes = data_br.split("/")
    if len(partes) != 3:
        return None
    dd, mm, yyyy = partes
    return f"{yyyy}-{mm.zfill(2)}-{dd.zfill(2)}"


# ──────────────────────────────────────────────────────────────
# Função principal
# ──────────────────────────────────────────────────────────────

async def persistir_fatura(
    pool: asyncpg.Pool,
    local_id: int,
    dados: RespostaEnel,
) -> None:
    """
    Persiste toda a saída do serviço Enel SP no banco em uma transação.

    - Faz upsert em enel_instalacoes, faturas, faturas_ocr e fatura_itens.
    - Itens da fatura são apagados e reinseridos (lista pode mudar a cada consulta).
    - Rollback automático em caso de qualquer erro.
    """
    async with pool.acquire() as conn:
        async with conn.transaction():

            # ── 1. Upsert da instalação ───────────────────────
            instalacao_id: int = await conn.fetchval(
                """
                INSERT INTO enel_instalacoes
                    (local_id, numero, titular, endereco, lista_raw)
                VALUES ($1, $2, $3, $4, $5)
                ON CONFLICT (local_id, numero) DO UPDATE SET
                    titular       = EXCLUDED.titular,
                    endereco      = EXCLUDED.endereco,
                    lista_raw     = EXCLUDED.lista_raw,
                    atualizado_em = CURRENT_TIMESTAMP
                RETURNING id
                """,
                local_id,
                dados.instalacao,
                dados.nome,
                dados.endereco,
                str(dados.lista_instalacoes),   # JSONB via cast no Postgres
            )

            # ── 2. Para cada conta ────────────────────────────
            for conta in dados.contas:
                fatura_id: int = await conn.fetchval(
                    """
                    INSERT INTO faturas
                        (local_id, instalacao_id, mes, vencimento, valor_total,
                         status, codigo_barras, conta_pdf_url)
                    VALUES ($1, $2, $3::date, $4::date, $5, $6, $7, $8)
                    ON CONFLICT (local_id, mes) DO UPDATE SET
                        vencimento    = EXCLUDED.vencimento,
                        valor_total   = EXCLUDED.valor_total,
                        status        = EXCLUDED.status,
                        codigo_barras = EXCLUDED.codigo_barras,
                        conta_pdf_url = EXCLUDED.conta_pdf_url,
                        atualizado_em = CURRENT_TIMESTAMP
                    RETURNING id
                    """,
                    local_id,
                    instalacao_id,
                    _mes_para_date(conta.mes_referencia),
                    _br_para_iso(conta.vencimento),
                    conta.valor,
                    conta.status,
                    conta.codigo_barras,
                    conta.conta_pdf_url,
                )

                # ── 3. OCR (1-para-1 com a fatura) ───────────
                if dados.ocr:
                    o = dados.ocr
                    await conn.execute(
                        """
                        INSERT INTO faturas_ocr (
                            fatura_id,
                            cliente, distribuidora, nota_fiscal, aviso, endereco,
                            codigo_barras, classe, subclasse, grupo, subgrupo,
                            ref_mes, ref_ano,
                            emissao_data, data_apresentacao,
                            leitura_anterior_data, leitura_data, leitura_proxima_data,
                            energia_kwh, valor, vencimento,
                            preco_te, preco_tusd,
                            normalizado_preco_te, normalizado_preco_tusd, normalizado_valor
                        )
                        VALUES (
                            $1,
                            $2,  $3,  $4,  $5,  $6,
                            $7,  $8,  $9,  $10, $11,
                            $12, $13,
                            $14::date, $15::date,
                            $16::date, $17::date, $18::date,
                            $19, $20, $21::date,
                            $22, $23, $24, $25, $26
                        )
                        ON CONFLICT (fatura_id) DO UPDATE SET
                            cliente                = EXCLUDED.cliente,
                            distribuidora          = EXCLUDED.distribuidora,
                            nota_fiscal            = EXCLUDED.nota_fiscal,
                            aviso                  = EXCLUDED.aviso,
                            endereco               = EXCLUDED.endereco,
                            codigo_barras          = EXCLUDED.codigo_barras,
                            classe                 = EXCLUDED.classe,
                            subclasse              = EXCLUDED.subclasse,
                            grupo                  = EXCLUDED.grupo,
                            subgrupo               = EXCLUDED.subgrupo,
                            ref_mes                = EXCLUDED.ref_mes,
                            ref_ano                = EXCLUDED.ref_ano,
                            emissao_data           = EXCLUDED.emissao_data,
                            data_apresentacao      = EXCLUDED.data_apresentacao,
                            leitura_anterior_data  = EXCLUDED.leitura_anterior_data,
                            leitura_data           = EXCLUDED.leitura_data,
                            leitura_proxima_data   = EXCLUDED.leitura_proxima_data,
                            energia_kwh            = EXCLUDED.energia_kwh,
                            valor                  = EXCLUDED.valor,
                            vencimento             = EXCLUDED.vencimento,
                            preco_te               = EXCLUDED.preco_te,
                            preco_tusd             = EXCLUDED.preco_tusd,
                            normalizado_preco_te   = EXCLUDED.normalizado_preco_te,
                            normalizado_preco_tusd = EXCLUDED.normalizado_preco_tusd,
                            normalizado_valor      = EXCLUDED.normalizado_valor,
                            atualizado_em          = CURRENT_TIMESTAMP
                        """,
                        fatura_id,
                        o.cliente,
                        o.distribuidora,
                        o.nota_fiscal,
                        o.aviso,
                        o.endereco,
                        o.codigo_barras,
                        o.classe,
                        o.subclasse,
                        o.grupo,
                        o.subgrupo,
                        o.ref_mes,
                        o.ref_ano,
                        _br_para_iso(o.emissao_data),
                        _br_para_iso(o.data_apresentacao),
                        _br_para_iso(o.leitura_anterior_data),
                        _br_para_iso(o.leitura_data),
                        _br_para_iso(o.leitura_proxima_data),
                        o.energia,
                        o.valor,
                        _br_para_iso(o.vencimento),
                        o.preco_te,
                        o.preco_tusd,
                        o.normalizado_preco_te,
                        o.normalizado_preco_tusd,
                        o.normalizado_valor,
                    )

                    # ── 4. Itens da fatura ────────────────────
                    await conn.execute(
                        "DELETE FROM fatura_itens WHERE fatura_id = $1",
                        fatura_id,
                    )
                    if o.itens_fatura:
                        await conn.executemany(
                            """
                            INSERT INTO fatura_itens (fatura_id, descricao, valor)
                            VALUES ($1, $2, $3)
                            """,
                            [
                                (fatura_id, item.descricao, item.valor)
                                for item in o.itens_fatura
                            ],
                        )

            log.info(
                "Fatura persistida — local_id=%s instalacao=%s contas=%s",
                local_id,
                dados.instalacao,
                len(dados.contas),
            )