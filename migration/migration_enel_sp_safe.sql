-- =============================================================
-- Migration segura — Enel SP sobre banco EnergySafe existente
--
-- NÃO execute este arquivo diretamente com psql.
-- Use: ./run_migration.sh
--
-- O script usa --single-transaction, que envolve tudo em uma
-- transação automaticamente. BEGIN/COMMIT manuais foram removidos
-- para evitar conflito com essa flag.
--
-- Não toca em: locais, areas, quadros, dispositivos,
--              canais_medicao, medicoes, alertas, consumo_diario,
--              rateio, tarifas, metas, dispositivos_status
-- =============================================================


-- -------------------------------------------------------------
-- 1. enel_instalacoes  (nova — sem conflito)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS enel_instalacoes (
    id            SERIAL PRIMARY KEY,
    local_id      INTEGER NOT NULL REFERENCES locais(id) ON DELETE CASCADE,
    numero        TEXT    NOT NULL,
    titular       TEXT,
    endereco      TEXT,
    lista_raw     JSONB,
    criado_em     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (local_id, numero)
);

COMMENT ON TABLE  enel_instalacoes           IS 'Instalações Enel vinculadas a cada local';
COMMENT ON COLUMN enel_instalacoes.numero    IS 'Número da instalação Enel (ex: 7006123456)';
COMMENT ON COLUMN enel_instalacoes.lista_raw IS 'Array completo de instalações do login — para referência';


-- -------------------------------------------------------------
-- 2. Altera faturas — preserva tudo, adiciona colunas novas
--    e corrige os tipos REAL → NUMERIC
-- -------------------------------------------------------------
ALTER TABLE faturas
    ALTER COLUMN valor_total TYPE NUMERIC(10,2) USING valor_total::NUMERIC(10,2),
    ALTER COLUMN kwh_total   TYPE NUMERIC(10,3) USING kwh_total::NUMERIC(10,3);

ALTER TABLE faturas
    ADD COLUMN IF NOT EXISTS instalacao_id  INTEGER REFERENCES enel_instalacoes(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS vencimento     DATE,
    ADD COLUMN IF NOT EXISTS status         TEXT,
    ADD COLUMN IF NOT EXISTS codigo_barras  TEXT,
    ADD COLUMN IF NOT EXISTS conta_pdf_url  TEXT,
    ADD COLUMN IF NOT EXISTS atualizado_em  TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

COMMENT ON COLUMN faturas.valor_total   IS 'R$ total da fatura — NUMERIC para evitar erro de ponto flutuante';
COMMENT ON COLUMN faturas.kwh_total     IS 'kWh da fatura (para conferência com o medido)';
COMMENT ON COLUMN faturas.vencimento    IS 'Data de vencimento da fatura Enel';
COMMENT ON COLUMN faturas.status        IS 'Status retornado pelo serviço: em aberto | pago | vencido';
COMMENT ON COLUMN faturas.instalacao_id IS 'FK para enel_instalacoes — nullable, faturas manuais não precisam preencher';


-- -------------------------------------------------------------
-- 3. faturas_ocr  (nova — 1-para-1 com faturas)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS faturas_ocr (
    id                      SERIAL PRIMARY KEY,
    fatura_id               INTEGER NOT NULL UNIQUE REFERENCES faturas(id) ON DELETE CASCADE,

    cliente                 TEXT,
    distribuidora           TEXT,
    nota_fiscal             TEXT,
    aviso                   TEXT,
    endereco                TEXT,
    codigo_barras           TEXT,

    classe                  TEXT,
    subclasse               TEXT,
    grupo                   TEXT,
    subgrupo                TEXT,

    ref_mes                 SMALLINT,
    ref_ano                 SMALLINT,
    emissao_data            DATE,
    data_apresentacao       DATE,

    leitura_anterior_data   DATE,
    leitura_data            DATE,
    leitura_proxima_data    DATE,

    energia_kwh             NUMERIC(10,3),
    valor                   NUMERIC(10,2),
    vencimento              DATE,

    preco_te                NUMERIC(10,6),
    preco_tusd              NUMERIC(10,6),
    normalizado_preco_te    NUMERIC(10,6),
    normalizado_preco_tusd  NUMERIC(10,6),
    normalizado_valor       NUMERIC(10,2),

    criado_em               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE  faturas_ocr             IS 'Dados extraídos por OCR do PDF da fatura Enel — 1-para-1 com faturas';
COMMENT ON COLUMN faturas_ocr.energia_kwh IS 'Consumo total em kWh extraído do PDF';
COMMENT ON COLUMN faturas_ocr.preco_te    IS 'Tarifa de Energia (TE) em R$/kWh';
COMMENT ON COLUMN faturas_ocr.preco_tusd  IS 'Tarifa de Uso do Sistema de Distribuição em R$/kWh';


-- -------------------------------------------------------------
-- 4. fatura_itens  (nova — 1-para-N com faturas)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS fatura_itens (
    id        SERIAL PRIMARY KEY,
    fatura_id INTEGER       NOT NULL REFERENCES faturas(id) ON DELETE CASCADE,
    descricao TEXT          NOT NULL,
    valor     NUMERIC(10,2) NOT NULL
);

COMMENT ON TABLE fatura_itens IS 'Itens de composição da fatura (ocr.itens_fatura)';


-- -------------------------------------------------------------
-- 5. Índices
-- -------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_enel_inst_local    ON enel_instalacoes (local_id);
CREATE INDEX IF NOT EXISTS idx_faturas_status      ON faturas          (status);
CREATE INDEX IF NOT EXISTS idx_faturas_vencimento  ON faturas          (vencimento);
CREATE INDEX IF NOT EXISTS idx_faturas_ocr_fatura  ON faturas_ocr      (fatura_id);
CREATE INDEX IF NOT EXISTS idx_fatura_itens_fatura ON fatura_itens     (fatura_id);


-- -------------------------------------------------------------
-- 6. Função + triggers para atualizado_em
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_atualizado_em()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_faturas_atualizado_em
    BEFORE UPDATE ON faturas
    FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();

CREATE OR REPLACE TRIGGER trg_faturas_ocr_atualizado_em
    BEFORE UPDATE ON faturas_ocr
    FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();

CREATE OR REPLACE TRIGGER trg_enel_inst_atualizado_em
    BEFORE UPDATE ON enel_instalacoes
    FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();
