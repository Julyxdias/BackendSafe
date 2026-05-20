--
-- PostgreSQL database dump
--

\restrict Y2lsptNFf2PUov1EN4E7G5T8yTsOLqa82Z4cNmkcNw15L2g415VX3hT2UhvJrqw

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg12+1)
-- Dumped by pg_dump version 18.3 (Ubuntu 18.3-1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: julya
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO julya;

--
-- Name: set_atualizado_em(); Type: FUNCTION; Schema: public; Owner: julya
--

CREATE FUNCTION public.set_atualizado_em() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_atualizado_em() OWNER TO julya;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alertas; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.alertas (
    id integer NOT NULL,
    canal_id integer,
    tipo text,
    nivel text,
    mensagem text,
    valor real,
    limite real,
    "timestamp" timestamp without time zone NOT NULL,
    resolvido boolean DEFAULT false,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.alertas OWNER TO julya;

--
-- Name: alertas_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.alertas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alertas_id_seq OWNER TO julya;

--
-- Name: alertas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.alertas_id_seq OWNED BY public.alertas.id;


--
-- Name: areas; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.areas (
    id integer NOT NULL,
    nome text NOT NULL,
    local_id integer,
    descricao text
);


ALTER TABLE public.areas OWNER TO julya;

--
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.areas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.areas_id_seq OWNER TO julya;

--
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.areas_id_seq OWNED BY public.areas.id;


--
-- Name: canais_medicao; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.canais_medicao (
    id integer NOT NULL,
    dispositivo_id integer,
    fase text,
    tipo text,
    descricao text,
    CONSTRAINT canais_medicao_fase_check CHECK ((fase = ANY (ARRAY['A'::text, 'B'::text, 'C'::text])))
);


ALTER TABLE public.canais_medicao OWNER TO julya;

--
-- Name: canais_medicao_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.canais_medicao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.canais_medicao_id_seq OWNER TO julya;

--
-- Name: canais_medicao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.canais_medicao_id_seq OWNED BY public.canais_medicao.id;


--
-- Name: consumo_diario; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.consumo_diario (
    id bigint NOT NULL,
    canal_id integer,
    data date NOT NULL,
    kwh real NOT NULL,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.consumo_diario OWNER TO julya;

--
-- Name: consumo_diario_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.consumo_diario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.consumo_diario_id_seq OWNER TO julya;

--
-- Name: consumo_diario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.consumo_diario_id_seq OWNED BY public.consumo_diario.id;


--
-- Name: dispositivos; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.dispositivos (
    id integer NOT NULL,
    nome text NOT NULL,
    quadro_id integer,
    ativo boolean DEFAULT true,
    data_instalacao timestamp without time zone,
    observacoes text
);


ALTER TABLE public.dispositivos OWNER TO julya;

--
-- Name: dispositivos_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.dispositivos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dispositivos_id_seq OWNER TO julya;

--
-- Name: dispositivos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.dispositivos_id_seq OWNED BY public.dispositivos.id;


--
-- Name: dispositivos_status; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.dispositivos_status (
    id integer NOT NULL,
    dispositivo_id integer,
    status text,
    ultima_leitura timestamp without time zone,
    potencia_atual real,
    atualizado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT dispositivos_status_status_check CHECK ((status = ANY (ARRAY['ONLINE'::text, 'ATRASO'::text, 'OFFLINE'::text])))
);


ALTER TABLE public.dispositivos_status OWNER TO julya;

--
-- Name: dispositivos_status_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.dispositivos_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dispositivos_status_id_seq OWNER TO julya;

--
-- Name: dispositivos_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.dispositivos_status_id_seq OWNED BY public.dispositivos_status.id;


--
-- Name: enel_instalacoes; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.enel_instalacoes (
    id integer NOT NULL,
    local_id integer NOT NULL,
    numero text NOT NULL,
    titular text,
    endereco text,
    lista_raw jsonb,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    atualizado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.enel_instalacoes OWNER TO julya;

--
-- Name: TABLE enel_instalacoes; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON TABLE public.enel_instalacoes IS 'Instala‡äes Enel vinculadas a cada local';


--
-- Name: COLUMN enel_instalacoes.numero; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.enel_instalacoes.numero IS 'N£mero da instala‡Æo Enel (ex: 7006123456)';


--
-- Name: COLUMN enel_instalacoes.lista_raw; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.enel_instalacoes.lista_raw IS 'Array completo de instala‡äes do login - para referˆncia';


--
-- Name: enel_instalacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.enel_instalacoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enel_instalacoes_id_seq OWNER TO julya;

--
-- Name: enel_instalacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.enel_instalacoes_id_seq OWNED BY public.enel_instalacoes.id;


--
-- Name: fatura_itens; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.fatura_itens (
    id integer NOT NULL,
    fatura_id integer NOT NULL,
    descricao text NOT NULL,
    valor numeric(10,2) NOT NULL
);


ALTER TABLE public.fatura_itens OWNER TO julya;

--
-- Name: TABLE fatura_itens; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON TABLE public.fatura_itens IS 'Itens de composi‡Æo da fatura (ocr.itens_fatura)';


--
-- Name: fatura_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.fatura_itens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fatura_itens_id_seq OWNER TO julya;

--
-- Name: fatura_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.fatura_itens_id_seq OWNED BY public.fatura_itens.id;


--
-- Name: faturas; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.faturas (
    id integer NOT NULL,
    local_id integer,
    mes date NOT NULL,
    valor_total numeric(10,2) NOT NULL,
    kwh_total numeric(10,3),
    descricao text,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    instalacao_id integer,
    vencimento date,
    status text,
    codigo_barras text,
    conta_pdf_url text,
    atualizado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.faturas OWNER TO julya;

--
-- Name: COLUMN faturas.valor_total; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas.valor_total IS 'R$ total da fatura - NUMERIC para evitar erro de ponto flutuante';


--
-- Name: COLUMN faturas.kwh_total; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas.kwh_total IS 'kWh da fatura (para conferˆncia com o medido)';


--
-- Name: COLUMN faturas.instalacao_id; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas.instalacao_id IS 'FK para enel_instalacoes - preenchida quando vier do servi‡o Enel';


--
-- Name: COLUMN faturas.vencimento; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas.vencimento IS 'Data de vencimento da fatura Enel';


--
-- Name: COLUMN faturas.status; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas.status IS 'Status retornado pelo servi‡o: em aberto | pago | vencido';


--
-- Name: faturas_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.faturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faturas_id_seq OWNER TO julya;

--
-- Name: faturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.faturas_id_seq OWNED BY public.faturas.id;


--
-- Name: faturas_ocr; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.faturas_ocr (
    id integer NOT NULL,
    fatura_id integer NOT NULL,
    cliente text,
    distribuidora text,
    nota_fiscal text,
    aviso text,
    endereco text,
    codigo_barras text,
    classe text,
    subclasse text,
    grupo text,
    subgrupo text,
    ref_mes smallint,
    ref_ano smallint,
    emissao_data date,
    data_apresentacao date,
    leitura_anterior_data date,
    leitura_data date,
    leitura_proxima_data date,
    energia_kwh numeric(10,3),
    valor numeric(10,2),
    vencimento date,
    preco_te numeric(10,6),
    preco_tusd numeric(10,6),
    normalizado_preco_te numeric(10,6),
    normalizado_preco_tusd numeric(10,6),
    normalizado_valor numeric(10,2),
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    atualizado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.faturas_ocr OWNER TO julya;

--
-- Name: TABLE faturas_ocr; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON TABLE public.faturas_ocr IS 'Dados extra¡dos por OCR do PDF da fatura Enel - 1-para-1 com faturas';


--
-- Name: COLUMN faturas_ocr.energia_kwh; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas_ocr.energia_kwh IS 'Consumo total em kWh extra¡do do PDF';


--
-- Name: COLUMN faturas_ocr.preco_te; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas_ocr.preco_te IS 'Tarifa de Energia (TE) em R$/kWh';


--
-- Name: COLUMN faturas_ocr.preco_tusd; Type: COMMENT; Schema: public; Owner: julya
--

COMMENT ON COLUMN public.faturas_ocr.preco_tusd IS 'Tarifa de Uso do Sistema de Distribui‡Æo em R$/kWh';


--
-- Name: faturas_ocr_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.faturas_ocr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faturas_ocr_id_seq OWNER TO julya;

--
-- Name: faturas_ocr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.faturas_ocr_id_seq OWNED BY public.faturas_ocr.id;


--
-- Name: locais; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.locais (
    id integer NOT NULL,
    nome text NOT NULL,
    andar integer,
    descricao text
);


ALTER TABLE public.locais OWNER TO julya;

--
-- Name: locais_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.locais_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locais_id_seq OWNER TO julya;

--
-- Name: locais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.locais_id_seq OWNED BY public.locais.id;


--
-- Name: medicoes; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.medicoes (
    id bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    canal_id integer,
    corrente real,
    tensao real,
    potencia real,
    valido boolean DEFAULT true,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.medicoes OWNER TO julya;

--
-- Name: medicoes_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.medicoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medicoes_id_seq OWNER TO julya;

--
-- Name: medicoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.medicoes_id_seq OWNED BY public.medicoes.id;


--
-- Name: metas; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.metas (
    id integer NOT NULL,
    local_id integer,
    quadro_id integer,
    descricao text,
    kwh_baseline real NOT NULL,
    kwh_meta real NOT NULL,
    data_inicio date NOT NULL,
    data_fim date,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.metas OWNER TO julya;

--
-- Name: metas_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.metas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metas_id_seq OWNER TO julya;

--
-- Name: metas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.metas_id_seq OWNED BY public.metas.id;


--
-- Name: quadros; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.quadros (
    id integer NOT NULL,
    nome text NOT NULL,
    local_id integer,
    area_id integer,
    quadro_pai_id integer,
    descricao text
);


ALTER TABLE public.quadros OWNER TO julya;

--
-- Name: quadros_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.quadros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quadros_id_seq OWNER TO julya;

--
-- Name: quadros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.quadros_id_seq OWNED BY public.quadros.id;


--
-- Name: rateio; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.rateio (
    id bigint NOT NULL,
    fatura_id integer,
    area_id integer,
    kwh real NOT NULL,
    percentual real NOT NULL,
    valor_rs real NOT NULL,
    gerado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.rateio OWNER TO julya;

--
-- Name: rateio_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.rateio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rateio_id_seq OWNER TO julya;

--
-- Name: rateio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.rateio_id_seq OWNED BY public.rateio.id;


--
-- Name: tarifas; Type: TABLE; Schema: public; Owner: julya
--

CREATE TABLE public.tarifas (
    id integer NOT NULL,
    local_id integer,
    valor_kwh real NOT NULL,
    vigencia date NOT NULL,
    descricao text,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tarifas OWNER TO julya;

--
-- Name: tarifas_id_seq; Type: SEQUENCE; Schema: public; Owner: julya
--

CREATE SEQUENCE public.tarifas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarifas_id_seq OWNER TO julya;

--
-- Name: tarifas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: julya
--

ALTER SEQUENCE public.tarifas_id_seq OWNED BY public.tarifas.id;


--
-- Name: alertas id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.alertas ALTER COLUMN id SET DEFAULT nextval('public.alertas_id_seq'::regclass);


--
-- Name: areas id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.areas ALTER COLUMN id SET DEFAULT nextval('public.areas_id_seq'::regclass);


--
-- Name: canais_medicao id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.canais_medicao ALTER COLUMN id SET DEFAULT nextval('public.canais_medicao_id_seq'::regclass);


--
-- Name: consumo_diario id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.consumo_diario ALTER COLUMN id SET DEFAULT nextval('public.consumo_diario_id_seq'::regclass);


--
-- Name: dispositivos id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos ALTER COLUMN id SET DEFAULT nextval('public.dispositivos_id_seq'::regclass);


--
-- Name: dispositivos_status id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos_status ALTER COLUMN id SET DEFAULT nextval('public.dispositivos_status_id_seq'::regclass);


--
-- Name: enel_instalacoes id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.enel_instalacoes ALTER COLUMN id SET DEFAULT nextval('public.enel_instalacoes_id_seq'::regclass);


--
-- Name: fatura_itens id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.fatura_itens ALTER COLUMN id SET DEFAULT nextval('public.fatura_itens_id_seq'::regclass);


--
-- Name: faturas id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas ALTER COLUMN id SET DEFAULT nextval('public.faturas_id_seq'::regclass);


--
-- Name: faturas_ocr id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas_ocr ALTER COLUMN id SET DEFAULT nextval('public.faturas_ocr_id_seq'::regclass);


--
-- Name: locais id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.locais ALTER COLUMN id SET DEFAULT nextval('public.locais_id_seq'::regclass);


--
-- Name: medicoes id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.medicoes ALTER COLUMN id SET DEFAULT nextval('public.medicoes_id_seq'::regclass);


--
-- Name: metas id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.metas ALTER COLUMN id SET DEFAULT nextval('public.metas_id_seq'::regclass);


--
-- Name: quadros id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.quadros ALTER COLUMN id SET DEFAULT nextval('public.quadros_id_seq'::regclass);


--
-- Name: rateio id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.rateio ALTER COLUMN id SET DEFAULT nextval('public.rateio_id_seq'::regclass);


--
-- Name: tarifas id; Type: DEFAULT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.tarifas ALTER COLUMN id SET DEFAULT nextval('public.tarifas_id_seq'::regclass);


--
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.alertas (id, canal_id, tipo, nivel, mensagem, valor, limite, "timestamp", resolvido, criado_em) FROM stdin;
1	1	sobrecorrente	critico	Pico de corrente no Terreo - Fase A	44.2	40	2026-03-12 15:30:00	f	2026-05-08 00:01:30.692008
2	6	consumo_fora_horario	aviso	Consumo elevado 1 Andar fora do horario	11.5	10	2026-03-15 03:00:00	t	2026-05-08 00:01:30.692008
3	7	queda_brusca	aviso	Instabilidade de carga 2 Andar - TI	0.8	22	2026-03-22 09:15:00	f	2026-05-08 00:01:30.692008
4	3	sobrecorrente	info	Corrente elevada Terreo - Fase C historico	32.1	30	2026-01-08 14:00:00	t	2026-05-08 00:01:30.692008
5	4	queda_brusca	critico	Queda brusca 1 Andar - Fase A historico	0.3	22	2026-02-19 10:45:00	t	2026-05-08 00:01:30.692008
6	1	sobrecorrente	critico	Corrente acima do limite	183.20259	40	2026-05-11 21:31:54	f	2026-05-12 00:31:56.13455
7	1	queda_brusca	aviso	Queda brusca de corrente detectada	9.036039	183.20259	2026-05-11 21:36:54	f	2026-05-12 00:36:56.632683
8	1	sobrecorrente	critico	Corrente acima do limite	74.45641	40	2026-05-11 21:39:34	f	2026-05-12 00:39:36.518742
9	1	queda_brusca	aviso	Queda brusca de corrente detectada	10.248461	74.45641	2026-05-11 21:40:34	f	2026-05-12 00:40:36.079114
10	1	sobrecorrente	critico	Corrente acima do limite	169.827	40	2026-05-12 20:26:51	f	2026-05-13 00:40:55.573186
11	1	sobrecorrente	critico	Corrente acima do limite	73.1805	40	2026-05-12 21:39:53	f	2026-05-13 00:41:13.29468
12	1	sobrecorrente	critico	Corrente acima do limite	106.48156	40	2026-05-12 21:50:09	f	2026-05-13 00:50:11.243985
13	1	queda_brusca	aviso	Queda brusca de corrente detectada	7.948476	106.48156	2026-05-12 21:52:10	f	2026-05-13 00:52:13.050683
14	1	sobrecorrente	critico	Corrente acima do limite	86.539925	40	2026-05-12 21:58:34	f	2026-05-13 00:58:36.516504
15	1	queda_brusca	aviso	Queda brusca de corrente detectada	8.047358	86.539925	2026-05-12 21:59:34	f	2026-05-13 00:59:36.648071
16	1	sobrecorrente	critico	Corrente acima do limite	108.51792	40	2026-05-12 22:07:03	f	2026-05-13 01:07:06.779289
17	1	consumo_fora_horario	aviso	Consumo detectado fora do horário	108.51792	10	2026-05-12 22:07:03	t	2026-05-13 01:07:06.779289
\.


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.areas (id, nome, local_id, descricao) FROM stdin;
1	Terreo ADM	2	Salas de Aula - Andar 0
2	1 Andar ADM	3	Financeiro, Reuniao, Professores
3	2 Andar ADM	4	Coordenacao, Reitoria
\.


--
-- Data for Name: canais_medicao; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.canais_medicao (id, dispositivo_id, fase, tipo, descricao) FROM stdin;
1	1	A	corrente	ADM0_A307 Fase A
2	2	B	corrente	ADM0_A307 Fase B
3	3	C	corrente	ADM0_A307 Fase C
4	4	A	corrente	ADM1_A301 Fase A
5	5	B	corrente	ADM1_A301 Fase B
6	6	C	corrente	ADM1_A301 Fase C
7	7	A	corrente	ADM2_A302 Fase A
8	8	B	corrente	ADM2_A302 Fase B
9	9	C	corrente	ADM2_A302 Fase C
\.


--
-- Data for Name: consumo_diario; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.consumo_diario (id, canal_id, data, kwh, criado_em) FROM stdin;
1	7	2026-01-06	78.406	2026-05-08 00:01:30.431565
2	4	2026-03-09	65.2113	2026-05-08 00:01:30.431565
3	1	2026-03-09	54.0742	2026-05-08 00:01:30.431565
4	1	2026-03-10	53.5657	2026-05-08 00:01:30.431565
5	1	2026-03-21	11.5269	2026-05-08 00:01:30.431565
6	4	2026-03-01	10.7101	2026-05-08 00:01:30.431565
7	4	2026-02-05	67.2152	2026-05-08 00:01:30.431565
8	4	2026-01-31	10.9646	2026-05-08 00:01:30.431565
9	7	2026-02-26	77.0937	2026-05-08 00:01:30.431565
10	1	2026-01-08	52.7232	2026-05-08 00:01:30.431565
11	7	2026-02-28	10.3191	2026-05-08 00:01:30.431565
12	7	2026-01-11	10.5226	2026-05-08 00:01:30.431565
13	1	2026-03-31	55.8041	2026-05-08 00:01:30.431565
14	1	2026-02-01	11.2134	2026-05-08 00:01:30.431565
15	1	2026-03-19	53.3077	2026-05-08 00:01:30.431565
16	1	2026-01-31	10.7503	2026-05-08 00:01:30.431565
17	1	2026-03-15	9.5946	2026-05-08 00:01:30.431565
18	7	2026-03-09	77.0151	2026-05-08 00:01:30.431565
19	4	2026-02-02	62.5204	2026-05-08 00:01:30.431565
20	1	2026-02-12	53.0808	2026-05-08 00:01:30.431565
21	7	2026-02-22	10.4097	2026-05-08 00:01:30.431565
22	1	2026-03-30	52.156	2026-05-08 00:01:30.431565
23	4	2026-01-06	63.5148	2026-05-08 00:01:30.431565
24	4	2026-02-09	65.1507	2026-05-08 00:01:30.431565
25	1	2026-03-07	10.8455	2026-05-08 00:01:30.431565
26	4	2026-02-18	68.5243	2026-05-08 00:01:30.431565
27	1	2026-02-02	52.4498	2026-05-08 00:01:30.431565
28	1	2026-03-24	51.5432	2026-05-08 00:01:30.431565
29	1	2026-02-18	50.9463	2026-05-08 00:01:30.431565
30	4	2026-02-24	65.5165	2026-05-08 00:01:30.431565
31	4	2026-03-24	68.2585	2026-05-08 00:01:30.431565
32	4	2026-01-01	65.2715	2026-05-08 00:01:30.431565
33	4	2026-02-01	10.6902	2026-05-08 00:01:30.431565
34	1	2026-02-22	10.7307	2026-05-08 00:01:30.431565
35	1	2026-01-22	53.583	2026-05-08 00:01:30.431565
36	1	2026-02-05	54.0012	2026-05-08 00:01:30.431565
37	1	2026-02-20	56.3087	2026-05-08 00:01:30.431565
38	1	2026-02-06	55.4085	2026-05-08 00:01:30.431565
39	4	2026-01-05	65.1605	2026-05-08 00:01:30.431565
40	4	2026-03-29	11.0173	2026-05-08 00:01:30.431565
41	4	2026-02-11	63.9397	2026-05-08 00:01:30.431565
42	1	2026-02-08	10.7693	2026-05-08 00:01:30.431565
43	7	2026-03-17	79.1813	2026-05-08 00:01:30.431565
44	7	2026-01-23	78.2178	2026-05-08 00:01:30.431565
45	4	2026-03-26	65.641	2026-05-08 00:01:30.431565
46	1	2026-03-11	49.3732	2026-05-08 00:01:30.431565
47	1	2026-03-25	55.7608	2026-05-08 00:01:30.431565
48	4	2026-01-15	65.7779	2026-05-08 00:01:30.431565
49	1	2026-02-10	52.371	2026-05-08 00:01:30.431565
50	7	2026-02-14	11.1029	2026-05-08 00:01:30.431565
51	1	2026-01-25	10.7859	2026-05-08 00:01:30.431565
52	1	2026-01-04	10.2906	2026-05-08 00:01:30.431565
53	4	2026-02-27	64.2541	2026-05-08 00:01:30.431565
54	7	2026-03-21	10.8809	2026-05-08 00:01:30.431565
55	4	2026-01-21	65.9336	2026-05-08 00:01:30.431565
56	1	2026-01-13	52.0591	2026-05-08 00:01:30.431565
57	1	2026-03-06	52.7695	2026-05-08 00:01:30.431565
58	7	2026-01-31	11.1205	2026-05-08 00:01:30.431565
59	7	2026-02-13	77.2006	2026-05-08 00:01:30.431565
60	4	2026-01-13	64.9419	2026-05-08 00:01:30.431565
61	1	2026-01-01	52.3632	2026-05-08 00:01:30.431565
62	1	2026-02-28	10.8017	2026-05-08 00:01:30.431565
63	1	2026-03-13	50.4578	2026-05-08 00:01:30.431565
64	7	2026-01-12	80.4429	2026-05-08 00:01:30.431565
65	1	2026-02-27	54.239	2026-05-08 00:01:30.431565
66	1	2026-01-21	55.5612	2026-05-08 00:01:30.431565
67	1	2026-01-20	53.8258	2026-05-08 00:01:30.431565
68	7	2026-03-12	81.1249	2026-05-08 00:01:30.431565
69	1	2026-03-17	50.8817	2026-05-08 00:01:30.431565
70	4	2026-03-18	68.2272	2026-05-08 00:01:30.431565
71	7	2026-02-10	78.8624	2026-05-08 00:01:30.431565
72	4	2026-02-04	66.322	2026-05-08 00:01:30.431565
73	7	2026-01-05	82.3925	2026-05-08 00:01:30.431565
74	4	2026-03-02	66.6403	2026-05-08 00:01:30.431565
75	4	2026-01-10	11.2857	2026-05-08 00:01:30.431565
76	7	2026-01-02	76.3989	2026-05-08 00:01:30.431565
77	4	2026-02-26	62.2013	2026-05-08 00:01:30.431565
78	4	2026-03-30	64.1817	2026-05-08 00:01:30.431565
79	7	2026-02-19	79.9001	2026-05-08 00:01:30.431565
80	7	2026-01-15	79.7646	2026-05-08 00:01:30.431565
81	1	2026-02-21	10.5731	2026-05-08 00:01:30.431565
82	7	2026-01-08	74.8106	2026-05-08 00:01:30.431565
83	4	2026-03-31	65.6419	2026-05-08 00:01:30.431565
84	4	2026-02-03	66.1411	2026-05-08 00:01:30.431565
85	7	2026-03-31	77.0149	2026-05-08 00:01:30.431565
86	7	2026-03-08	10.0916	2026-05-08 00:01:30.431565
87	4	2026-01-29	66.3452	2026-05-08 00:01:30.431565
88	1	2026-01-14	50.6093	2026-05-08 00:01:30.431565
89	7	2026-03-13	77.3594	2026-05-08 00:01:30.431565
90	4	2026-03-22	10.6362	2026-05-08 00:01:30.431565
91	4	2026-03-21	10.5207	2026-05-08 00:01:30.431565
92	1	2026-01-09	51.8327	2026-05-08 00:01:30.431565
93	1	2026-03-05	50.5873	2026-05-08 00:01:30.431565
94	7	2026-01-16	81.1114	2026-05-08 00:01:30.431565
95	7	2026-02-21	10.3617	2026-05-08 00:01:30.431565
96	7	2026-02-11	80.6039	2026-05-08 00:01:30.431565
97	4	2026-02-07	10.9457	2026-05-08 00:01:30.431565
98	4	2026-03-13	67.4873	2026-05-08 00:01:30.431565
99	4	2026-03-19	66.1671	2026-05-08 00:01:30.431565
100	4	2026-03-16	67.7925	2026-05-08 00:01:30.431565
101	7	2026-02-06	79.4072	2026-05-08 00:01:30.431565
102	4	2026-01-26	65.966	2026-05-08 00:01:30.431565
103	1	2026-01-05	52.0168	2026-05-08 00:01:30.431565
104	4	2026-03-10	64.9264	2026-05-08 00:01:30.431565
105	7	2026-03-26	79.4337	2026-05-08 00:01:30.431565
106	1	2026-03-26	53.301	2026-05-08 00:01:30.431565
107	7	2026-01-17	10.0795	2026-05-08 00:01:30.431565
108	1	2026-03-22	10.8676	2026-05-08 00:01:30.431565
109	4	2026-02-15	11.117	2026-05-08 00:01:30.431565
110	7	2026-03-05	77.3448	2026-05-08 00:01:30.431565
111	4	2026-01-27	66.0134	2026-05-08 00:01:30.431565
112	7	2026-02-27	81.8527	2026-05-08 00:01:30.431565
113	4	2026-02-16	68.1861	2026-05-08 00:01:30.431565
114	1	2026-02-09	50.4795	2026-05-08 00:01:30.431565
115	1	2026-01-10	11.2233	2026-05-08 00:01:30.431565
116	4	2026-01-04	10.3169	2026-05-08 00:01:30.431565
117	4	2026-03-27	65.5902	2026-05-08 00:01:30.431565
118	1	2026-02-03	54.279	2026-05-08 00:01:30.431565
119	7	2026-03-16	78.3652	2026-05-08 00:01:30.431565
120	7	2026-01-21	78.5802	2026-05-08 00:01:30.431565
121	7	2026-03-14	9.757	2026-05-08 00:01:30.431565
122	1	2026-03-03	51.8622	2026-05-08 00:01:30.431565
123	7	2026-01-24	11.1472	2026-05-08 00:01:30.431565
124	1	2026-01-27	53.799	2026-05-08 00:01:30.431565
125	7	2026-02-08	11.2794	2026-05-08 00:01:30.431565
126	1	2026-02-16	55.169	2026-05-08 00:01:30.431565
127	4	2026-03-15	9.9785	2026-05-08 00:01:30.431565
128	4	2026-02-08	10.5192	2026-05-08 00:01:30.431565
129	7	2026-01-26	78.7599	2026-05-08 00:01:30.431565
130	7	2026-02-02	79.9638	2026-05-08 00:01:30.431565
131	4	2026-03-12	64.425	2026-05-08 00:01:30.431565
132	7	2026-01-13	79.8842	2026-05-08 00:01:30.431565
133	7	2026-03-19	79.8517	2026-05-08 00:01:30.431565
134	7	2026-01-30	78.9751	2026-05-08 00:01:30.431565
135	1	2026-01-23	54.0157	2026-05-08 00:01:30.431565
136	4	2026-03-28	11.1509	2026-05-08 00:01:30.431565
137	4	2026-01-18	10.5491	2026-05-08 00:01:30.431565
138	4	2026-01-28	67.7872	2026-05-08 00:01:30.431565
139	7	2026-01-09	77.0617	2026-05-08 00:01:30.431565
140	7	2026-02-16	79.8903	2026-05-08 00:01:30.431565
141	1	2026-01-28	52.8998	2026-05-08 00:01:30.431565
142	1	2026-02-26	55.3172	2026-05-08 00:01:30.431565
143	1	2026-03-12	52.5641	2026-05-08 00:01:30.431565
144	7	2026-01-29	78.1671	2026-05-08 00:01:30.431565
145	7	2026-03-01	10.3562	2026-05-08 00:01:30.431565
146	1	2026-02-07	10.7707	2026-05-08 00:01:30.431565
147	4	2026-01-12	61.5483	2026-05-08 00:01:30.431565
148	1	2026-03-18	54.1012	2026-05-08 00:01:30.431565
149	1	2026-01-26	56.0234	2026-05-08 00:01:30.431565
150	7	2026-02-17	78.785	2026-05-08 00:01:30.431565
151	7	2026-03-25	77.3489	2026-05-08 00:01:30.431565
152	1	2026-03-27	50.7942	2026-05-08 00:01:30.431565
153	4	2026-03-25	66.8413	2026-05-08 00:01:30.431565
154	4	2026-01-19	65.1149	2026-05-08 00:01:30.431565
155	4	2026-01-02	64.7405	2026-05-08 00:01:30.431565
156	1	2026-01-19	53.6753	2026-05-08 00:01:30.431565
157	1	2026-03-29	11.0647	2026-05-08 00:01:30.431565
158	4	2026-02-10	64.408	2026-05-08 00:01:30.431565
159	4	2026-03-23	66.0048	2026-05-08 00:01:30.431565
160	4	2026-01-08	66.8558	2026-05-08 00:01:30.431565
161	4	2026-01-14	64.8585	2026-05-08 00:01:30.431565
162	4	2026-02-12	66.8924	2026-05-08 00:01:30.431565
163	7	2026-03-10	80.9153	2026-05-08 00:01:30.431565
164	4	2026-03-11	64.4948	2026-05-08 00:01:30.431565
165	4	2026-03-03	68.1072	2026-05-08 00:01:30.431565
166	1	2026-02-25	54.6548	2026-05-08 00:01:30.431565
167	1	2026-02-24	55.8721	2026-05-08 00:01:30.431565
168	4	2026-02-21	11.5408	2026-05-08 00:01:30.431565
169	4	2026-02-17	67.7444	2026-05-08 00:01:30.431565
170	1	2026-03-02	54.4069	2026-05-08 00:01:30.431565
171	1	2026-01-07	53.4195	2026-05-08 00:01:30.431565
172	7	2026-03-28	9.967	2026-05-08 00:01:30.431565
173	4	2026-03-04	67.1566	2026-05-08 00:01:30.431565
174	4	2026-03-17	64.6834	2026-05-08 00:01:30.431565
175	7	2026-01-25	10.7497	2026-05-08 00:01:30.431565
176	1	2026-03-23	53.1482	2026-05-08 00:01:30.431565
177	7	2026-01-14	79.5207	2026-05-08 00:01:30.431565
178	7	2026-01-27	80.6521	2026-05-08 00:01:30.431565
179	1	2026-01-30	52.5341	2026-05-08 00:01:30.431565
180	7	2026-02-01	10.6544	2026-05-08 00:01:30.431565
181	1	2026-01-12	50.9387	2026-05-08 00:01:30.431565
182	4	2026-02-22	10.7378	2026-05-08 00:01:30.431565
183	7	2026-01-18	11.3759	2026-05-08 00:01:30.431565
184	7	2026-02-04	79.5312	2026-05-08 00:01:30.431565
185	4	2026-01-20	67.6836	2026-05-08 00:01:30.431565
186	4	2026-02-28	10.4962	2026-05-08 00:01:30.431565
187	1	2026-03-20	54.4001	2026-05-08 00:01:30.431565
188	7	2026-01-28	81.3678	2026-05-08 00:01:30.431565
189	4	2026-01-09	60.4004	2026-05-08 00:01:30.431565
190	1	2026-02-15	11.0787	2026-05-08 00:01:30.431565
191	1	2026-02-04	51.4539	2026-05-08 00:01:30.431565
192	4	2026-01-07	64.8757	2026-05-08 00:01:30.431565
193	4	2026-01-24	10.7846	2026-05-08 00:01:30.431565
194	1	2026-03-14	11.4209	2026-05-08 00:01:30.431565
195	4	2026-01-16	64.9228	2026-05-08 00:01:30.431565
196	1	2026-01-16	52.9022	2026-05-08 00:01:30.431565
197	7	2026-02-03	78.2895	2026-05-08 00:01:30.431565
198	7	2026-01-01	80.2159	2026-05-08 00:01:30.431565
199	1	2026-02-17	53.969	2026-05-08 00:01:30.431565
200	4	2026-02-14	10.5168	2026-05-08 00:01:30.431565
201	1	2026-01-06	53.5265	2026-05-08 00:01:30.431565
202	7	2026-03-22	10.1677	2026-05-08 00:01:30.431565
203	1	2026-02-11	51.3089	2026-05-08 00:01:30.431565
204	7	2026-01-22	78.8052	2026-05-08 00:01:30.431565
205	7	2026-03-20	78.4063	2026-05-08 00:01:30.431565
206	1	2026-03-16	55.0538	2026-05-08 00:01:30.431565
207	1	2026-03-08	10.5138	2026-05-08 00:01:30.431565
208	7	2026-02-25	80.0006	2026-05-08 00:01:30.431565
209	4	2026-01-11	10.3315	2026-05-08 00:01:30.431565
210	7	2026-03-04	79.6845	2026-05-08 00:01:30.431565
211	4	2026-01-30	65.1148	2026-05-08 00:01:30.431565
212	1	2026-01-24	10.7734	2026-05-08 00:01:30.431565
213	7	2026-03-06	76.1658	2026-05-08 00:01:30.431565
214	7	2026-03-15	9.7711	2026-05-08 00:01:30.431565
215	1	2026-01-11	10.7838	2026-05-08 00:01:30.431565
216	4	2026-03-05	65.207	2026-05-08 00:01:30.431565
217	1	2026-01-15	52.9611	2026-05-08 00:01:30.431565
218	1	2026-03-04	51.7678	2026-05-08 00:01:30.431565
219	7	2026-02-05	84.2419	2026-05-08 00:01:30.431565
220	4	2026-03-07	10.5165	2026-05-08 00:01:30.431565
221	7	2026-03-03	79.2906	2026-05-08 00:01:30.431565
222	7	2026-03-30	79.0414	2026-05-08 00:01:30.431565
223	7	2026-02-09	78.5352	2026-05-08 00:01:30.431565
224	4	2026-01-03	9.9694	2026-05-08 00:01:30.431565
225	4	2026-01-25	10.08	2026-05-08 00:01:30.431565
226	7	2026-01-10	11.4399	2026-05-08 00:01:30.431565
227	1	2026-01-17	10.6318	2026-05-08 00:01:30.431565
228	7	2026-02-18	78.2101	2026-05-08 00:01:30.431565
229	4	2026-02-25	64.7243	2026-05-08 00:01:30.431565
230	4	2026-02-13	65.0497	2026-05-08 00:01:30.431565
231	1	2026-01-02	51.3568	2026-05-08 00:01:30.431565
232	4	2026-01-23	63.8914	2026-05-08 00:01:30.431565
233	7	2026-01-04	10.9673	2026-05-08 00:01:30.431565
234	7	2026-03-24	78.9459	2026-05-08 00:01:30.431565
235	1	2026-02-13	54.8594	2026-05-08 00:01:30.431565
236	7	2026-03-23	78.2024	2026-05-08 00:01:30.431565
237	1	2026-02-23	50.9588	2026-05-08 00:01:30.431565
238	7	2026-03-18	77.2811	2026-05-08 00:01:30.431565
239	7	2026-02-12	78.7274	2026-05-08 00:01:30.431565
240	1	2026-02-19	54.4374	2026-05-08 00:01:30.431565
241	1	2026-01-18	10.6302	2026-05-08 00:01:30.431565
242	7	2026-03-27	79.6506	2026-05-08 00:01:30.431565
243	4	2026-03-06	63.8762	2026-05-08 00:01:30.431565
244	4	2026-02-20	65.9394	2026-05-08 00:01:30.431565
245	7	2026-01-20	81.5005	2026-05-08 00:01:30.431565
246	4	2026-03-14	11.9965	2026-05-08 00:01:30.431565
247	1	2026-02-14	10.7489	2026-05-08 00:01:30.431565
248	1	2026-03-28	10.5037	2026-05-08 00:01:30.431565
249	7	2026-03-02	76.5022	2026-05-08 00:01:30.431565
250	7	2026-01-19	77.4024	2026-05-08 00:01:30.431565
251	7	2026-03-07	10.5899	2026-05-08 00:01:30.431565
252	7	2026-01-03	9.9517	2026-05-08 00:01:30.431565
253	4	2026-01-17	10.2258	2026-05-08 00:01:30.431565
254	7	2026-02-07	10.1999	2026-05-08 00:01:30.431565
255	1	2026-01-03	10.7129	2026-05-08 00:01:30.431565
256	4	2026-02-06	64.6785	2026-05-08 00:01:30.431565
257	4	2026-02-23	64.7495	2026-05-08 00:01:30.431565
258	7	2026-02-23	81.5692	2026-05-08 00:01:30.431565
259	7	2026-01-07	80.447	2026-05-08 00:01:30.431565
260	7	2026-02-15	10.4219	2026-05-08 00:01:30.431565
261	1	2026-01-29	55.2265	2026-05-08 00:01:30.431565
262	7	2026-02-20	77.9284	2026-05-08 00:01:30.431565
263	4	2026-03-20	65.7256	2026-05-08 00:01:30.431565
264	4	2026-03-08	10.0729	2026-05-08 00:01:30.431565
265	7	2026-03-29	10.3879	2026-05-08 00:01:30.431565
266	1	2026-03-01	10.6858	2026-05-08 00:01:30.431565
267	7	2026-02-24	75.6383	2026-05-08 00:01:30.431565
268	4	2026-02-19	66.7284	2026-05-08 00:01:30.431565
269	4	2026-01-22	63.3111	2026-05-08 00:01:30.431565
270	7	2026-03-11	81.4504	2026-05-08 00:01:30.431565
\.


--
-- Data for Name: dispositivos; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.dispositivos (id, nome, quadro_id, ativo, data_instalacao, observacoes) FROM stdin;
1	ESP32_ADM0_A307	1	t	2025-01-10 08:00:00	\N
2	ESP32_ADM0_B307	1	f	2025-01-10 08:00:00	\N
3	ESP32_ADM0_C307	1	f	2025-01-10 08:00:00	\N
4	ESP32_ADM1_A301	2	t	2025-01-10 08:00:00	\N
5	ESP32_ADM1_B301	2	f	2025-01-10 08:00:00	\N
6	ESP32_ADM1_C301	2	f	2025-01-10 08:00:00	\N
7	ESP32_ADM2_A302	3	t	2025-01-11 08:00:00	\N
8	ESP32_ADM2_B302	3	f	2025-01-11 08:00:00	\N
9	ESP32_ADM2_C302	3	f	2025-01-11 08:00:00	\N
\.


--
-- Data for Name: dispositivos_status; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.dispositivos_status (id, dispositivo_id, status, ultima_leitura, potencia_atual, atualizado_em) FROM stdin;
4	4	ONLINE	2026-03-31 23:30:00	792.9	2026-05-08 00:01:31.132698
5	5	OFFLINE	\N	0	2026-05-08 00:01:31.132698
6	6	OFFLINE	\N	0	2026-05-08 00:01:31.132698
7	7	ONLINE	2026-03-31 23:30:00	317.1	2026-05-08 00:01:31.132698
8	8	OFFLINE	\N	0	2026-05-08 00:01:31.132698
9	9	OFFLINE	\N	0	2026-05-08 00:01:31.132698
2	2	OFFLINE	2026-05-11 21:23:25	0	2026-05-12 00:23:49.758916
3	3	OFFLINE	2026-05-11 21:23:25	0	2026-05-12 00:23:52.599523
1	1	OFFLINE	2026-05-12 22:07:03	34475.03	2026-05-13 01:07:06.789993
\.


--
-- Data for Name: enel_instalacoes; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.enel_instalacoes (id, local_id, numero, titular, endereco, lista_raw, criado_em, atualizado_em) FROM stdin;
\.


--
-- Data for Name: fatura_itens; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.fatura_itens (id, fatura_id, descricao, valor) FROM stdin;
\.


--
-- Data for Name: faturas; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.faturas (id, local_id, mes, valor_total, kwh_total, descricao, criado_em, instalacao_id, vencimento, status, codigo_barras, conta_pdf_url, atualizado_em) FROM stdin;
1	1	2026-01-01	133984.00	190661.000	Fatura Enel 01/2026 - Bandeira Amarela - NF 000029364	2026-05-08 00:01:25.658288	\N	\N	\N	\N	\N	2026-05-16 13:59:15.568543
2	1	2026-02-01	111794.00	161697.000	Fatura Enel 02/2026 - Bandeira Verde - NF 000034022	2026-05-08 00:01:25.658288	\N	\N	\N	\N	\N	2026-05-16 13:59:15.568543
3	1	2026-03-01	124125.00	174857.000	Fatura Enel 03/2026 - Bandeira Verde - NF 000041044	2026-05-08 00:01:25.658288	\N	\N	\N	\N	\N	2026-05-16 13:59:15.568543
\.


--
-- Data for Name: faturas_ocr; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.faturas_ocr (id, fatura_id, cliente, distribuidora, nota_fiscal, aviso, endereco, codigo_barras, classe, subclasse, grupo, subgrupo, ref_mes, ref_ano, emissao_data, data_apresentacao, leitura_anterior_data, leitura_data, leitura_proxima_data, energia_kwh, valor, vencimento, preco_te, preco_tusd, normalizado_preco_te, normalizado_preco_tusd, normalizado_valor, criado_em, atualizado_em) FROM stdin;
\.


--
-- Data for Name: locais; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.locais (id, nome, andar, descricao) FROM stdin;
1	Geral	0	P/ Faturas
2	Predio ADM - Terreo	0	Salas de Aula
3	Predio ADM - 1 Andar	1	Sala de Reuniao, Financeiro, Sala dos Professores
4	Predio ADM - 2 Andar	2	Coordenacao, Reitoria, Salas de Reuniao
\.


--
-- Data for Name: medicoes; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.medicoes (id, "timestamp", canal_id, corrente, tensao, potencia, valido, criado_em) FROM stdin;
1	2026-01-01 00:00:00	1	1.62	220	292.6	t	2026-05-08 00:01:27.547131
2	2026-01-01 00:00:00	4	2.39	220	394.3	t	2026-05-08 00:01:27.547131
3	2026-01-01 00:00:00	7	2.69	220	712.8	t	2026-05-08 00:01:27.547131
4	2026-01-01 00:30:00	1	1.2	220	554.9	t	2026-05-08 00:01:27.547131
5	2026-01-01 00:30:00	4	3.61	220	264.3	t	2026-05-08 00:01:27.547131
6	2026-01-01 00:30:00	7	3.05	220	681.8	t	2026-05-08 00:01:27.547131
7	2026-01-01 01:00:00	1	2.91	220	791.3	t	2026-05-08 00:01:27.547131
8	2026-01-01 01:00:00	4	2.03	220	428.5	t	2026-05-08 00:01:27.547131
9	2026-01-01 01:00:00	7	1.21	220	614.8	t	2026-05-08 00:01:27.547131
10	2026-01-01 01:30:00	1	2.48	220	550	t	2026-05-08 00:01:27.547131
11	2026-01-01 01:30:00	4	3.02	220	474.7	t	2026-05-08 00:01:27.547131
12	2026-01-01 01:30:00	7	2.85	220	556.5	t	2026-05-08 00:01:27.547131
13	2026-01-01 02:00:00	1	3.48	220	692.7	t	2026-05-08 00:01:27.547131
14	2026-01-01 02:00:00	4	3.16	220	733.6	t	2026-05-08 00:01:27.547131
15	2026-01-01 02:00:00	7	1.76	220	376.7	t	2026-05-08 00:01:27.547131
16	2026-01-01 02:30:00	1	2.61	220	616.6	t	2026-05-08 00:01:27.547131
17	2026-01-01 02:30:00	4	1.76	220	292	t	2026-05-08 00:01:27.547131
18	2026-01-01 02:30:00	7	1.87	220	691	t	2026-05-08 00:01:27.547131
19	2026-01-01 03:00:00	1	2.08	220	378.9	t	2026-05-08 00:01:27.547131
20	2026-01-01 03:00:00	4	2.01	220	686.5	t	2026-05-08 00:01:27.547131
21	2026-01-01 03:00:00	7	2.39	220	747.2	t	2026-05-08 00:01:27.547131
22	2026-01-01 03:30:00	1	3.27	220	582.1	t	2026-05-08 00:01:27.547131
23	2026-01-01 03:30:00	4	2.26	220	436.3	t	2026-05-08 00:01:27.547131
24	2026-01-01 03:30:00	7	3.62	220	412.7	t	2026-05-08 00:01:27.547131
25	2026-01-01 04:00:00	1	2.06	220	495.9	t	2026-05-08 00:01:27.547131
26	2026-01-01 04:00:00	4	3.03	220	777	t	2026-05-08 00:01:27.547131
27	2026-01-01 04:00:00	7	2.62	220	496.6	t	2026-05-08 00:01:27.547131
28	2026-01-01 04:30:00	1	3.1	220	515.3	t	2026-05-08 00:01:27.547131
29	2026-01-01 04:30:00	4	2.47	220	752.4	t	2026-05-08 00:01:27.547131
30	2026-01-01 04:30:00	7	2.4	220	720.1	t	2026-05-08 00:01:27.547131
31	2026-01-01 05:00:00	1	3.28	220	699.8	t	2026-05-08 00:01:27.547131
32	2026-01-01 05:00:00	4	2.74	220	505.4	t	2026-05-08 00:01:27.547131
33	2026-01-01 05:00:00	7	3.1	220	475.9	t	2026-05-08 00:01:27.547131
34	2026-01-01 05:30:00	1	2.86	220	487.3	t	2026-05-08 00:01:27.547131
35	2026-01-01 05:30:00	4	2.37	220	289.7	t	2026-05-08 00:01:27.547131
36	2026-01-01 05:30:00	7	2.47	220	777.9	t	2026-05-08 00:01:27.547131
37	2026-01-01 06:00:00	1	2.41	220	363	t	2026-05-08 00:01:27.547131
38	2026-01-01 06:00:00	4	1.71	220	542.9	t	2026-05-08 00:01:27.547131
39	2026-01-01 06:00:00	7	2.68	220	740.8	t	2026-05-08 00:01:27.547131
40	2026-01-01 06:30:00	1	1.75	220	746.1	t	2026-05-08 00:01:27.547131
41	2026-01-01 06:30:00	4	2.89	220	779.9	t	2026-05-08 00:01:27.547131
42	2026-01-01 06:30:00	7	1.33	220	404.3	t	2026-05-08 00:01:27.547131
43	2026-01-01 07:00:00	1	12.84	220	4513.5	t	2026-05-08 00:01:27.547131
44	2026-01-01 07:00:00	4	18.74	220	5318.4	t	2026-05-08 00:01:27.547131
45	2026-01-01 07:00:00	7	21.6	220	4863.8	t	2026-05-08 00:01:27.547131
46	2026-01-01 07:30:00	1	12.81	220	3430.1	t	2026-05-08 00:01:27.547131
47	2026-01-01 07:30:00	4	23.8	220	5485	t	2026-05-08 00:01:27.547131
48	2026-01-01 07:30:00	7	24.66	220	6486.3	t	2026-05-08 00:01:27.547131
49	2026-01-01 08:00:00	1	15.58	220	2690.5	t	2026-05-08 00:01:27.547131
50	2026-01-01 08:00:00	4	25.21	220	3691.4	t	2026-05-08 00:01:27.547131
51	2026-01-01 08:00:00	7	28.2	220	5318.2	t	2026-05-08 00:01:27.547131
52	2026-01-01 08:30:00	1	12.65	220	3230.3	t	2026-05-08 00:01:27.547131
53	2026-01-01 08:30:00	4	17.11	220	4323.5	t	2026-05-08 00:01:27.547131
54	2026-01-01 08:30:00	7	26.81	220	4999.6	t	2026-05-08 00:01:27.547131
55	2026-01-01 09:00:00	1	18.03	220	3241.1	t	2026-05-08 00:01:27.547131
56	2026-01-01 09:00:00	4	22.03	220	4269.2	t	2026-05-08 00:01:27.547131
57	2026-01-01 09:00:00	7	27.59	220	6636.9	t	2026-05-08 00:01:27.547131
58	2026-01-01 09:30:00	1	19.63	220	3678.5	t	2026-05-08 00:01:27.547131
59	2026-01-01 09:30:00	4	19.03	220	5192.8	t	2026-05-08 00:01:27.547131
60	2026-01-01 09:30:00	7	29.03	220	6305.5	t	2026-05-08 00:01:27.547131
61	2026-01-01 10:00:00	1	17.3	220	4697.5	t	2026-05-08 00:01:27.547131
62	2026-01-01 10:00:00	4	20.61	220	3883.1	t	2026-05-08 00:01:27.547131
63	2026-01-01 10:00:00	7	22.61	220	4615.6	t	2026-05-08 00:01:27.547131
64	2026-01-01 10:30:00	1	13.33	220	2566.4	t	2026-05-08 00:01:27.547131
65	2026-01-01 10:30:00	4	16.81	220	4837	t	2026-05-08 00:01:27.547131
66	2026-01-01 10:30:00	7	28.46	220	4922	t	2026-05-08 00:01:27.547131
67	2026-01-01 11:00:00	1	12.33	220	3871.8	t	2026-05-08 00:01:27.547131
68	2026-01-01 11:00:00	4	22.46	220	4365.6	t	2026-05-08 00:01:27.547131
69	2026-01-01 11:00:00	7	25.42	220	6354.7	t	2026-05-08 00:01:27.547131
70	2026-01-01 11:30:00	1	15.7	220	2618.6	t	2026-05-08 00:01:27.547131
71	2026-01-01 11:30:00	4	25.07	220	4270.6	t	2026-05-08 00:01:27.547131
72	2026-01-01 11:30:00	7	29.06	220	6005.7	t	2026-05-08 00:01:27.547131
73	2026-01-01 12:00:00	1	14.56	220	2803.4	t	2026-05-08 00:01:27.547131
74	2026-01-01 12:00:00	4	21.36	220	4360.5	t	2026-05-08 00:01:27.547131
75	2026-01-01 12:00:00	7	25.31	220	4815.4	t	2026-05-08 00:01:27.547131
76	2026-01-01 12:30:00	1	21.39	220	2650	t	2026-05-08 00:01:27.547131
77	2026-01-01 12:30:00	4	20.11	220	4056.7	t	2026-05-08 00:01:27.547131
78	2026-01-01 12:30:00	7	27.99	220	4931.5	t	2026-05-08 00:01:27.547131
79	2026-01-01 13:00:00	1	16.29	220	4359.8	t	2026-05-08 00:01:27.547131
80	2026-01-01 13:00:00	4	19.1	220	4595.2	t	2026-05-08 00:01:27.547131
81	2026-01-01 13:00:00	7	24.87	220	4876.3	t	2026-05-08 00:01:27.547131
82	2026-01-01 13:30:00	1	17.47	220	4413.7	t	2026-05-08 00:01:27.547131
83	2026-01-01 13:30:00	4	21.03	220	5644.1	t	2026-05-08 00:01:27.547131
84	2026-01-01 13:30:00	7	28.35	220	5847.6	t	2026-05-08 00:01:27.547131
85	2026-01-01 14:00:00	1	12.32	220	3308.7	t	2026-05-08 00:01:27.547131
86	2026-01-01 14:00:00	4	20.55	220	3672.9	t	2026-05-08 00:01:27.547131
87	2026-01-01 14:00:00	7	24.52	220	5976.9	t	2026-05-08 00:01:27.547131
88	2026-01-01 14:30:00	1	16.65	220	2806.5	t	2026-05-08 00:01:27.547131
89	2026-01-01 14:30:00	4	18.89	220	4181.1	t	2026-05-08 00:01:27.547131
90	2026-01-01 14:30:00	7	30.04	220	6570	t	2026-05-08 00:01:27.547131
91	2026-01-01 15:00:00	1	19.05	220	2833.4	t	2026-05-08 00:01:27.547131
92	2026-01-01 15:00:00	4	21.57	220	5123.3	t	2026-05-08 00:01:27.547131
93	2026-01-01 15:00:00	7	30.31	220	5733.7	t	2026-05-08 00:01:27.547131
94	2026-01-01 15:30:00	1	17.81	220	4554.2	t	2026-05-08 00:01:27.547131
95	2026-01-01 15:30:00	4	17.42	220	4067.7	t	2026-05-08 00:01:27.547131
96	2026-01-01 15:30:00	7	26.59	220	5832.3	t	2026-05-08 00:01:27.547131
97	2026-01-01 16:00:00	1	16.22	220	3202.2	t	2026-05-08 00:01:27.547131
98	2026-01-01 16:00:00	4	16.82	220	5690.5	t	2026-05-08 00:01:27.547131
99	2026-01-01 16:00:00	7	23.53	220	6131.7	t	2026-05-08 00:01:27.547131
100	2026-01-01 16:30:00	1	17.21	220	2897.6	t	2026-05-08 00:01:27.547131
101	2026-01-01 16:30:00	4	25.58	220	4335.5	t	2026-05-08 00:01:27.547131
102	2026-01-01 16:30:00	7	21.93	220	5865	t	2026-05-08 00:01:27.547131
103	2026-01-01 17:00:00	1	17.73	220	3246.8	t	2026-05-08 00:01:27.547131
104	2026-01-01 17:00:00	4	19.23	220	4825.8	t	2026-05-08 00:01:27.547131
105	2026-01-01 17:00:00	7	25.57	220	6287.5	t	2026-05-08 00:01:27.547131
106	2026-01-01 17:30:00	1	17.51	220	4245	t	2026-05-08 00:01:27.547131
107	2026-01-01 17:30:00	4	19.83	220	3540.8	t	2026-05-08 00:01:27.547131
108	2026-01-01 17:30:00	7	27.06	220	5945.5	t	2026-05-08 00:01:27.547131
109	2026-01-01 18:00:00	1	17.36	220	4122.7	t	2026-05-08 00:01:27.547131
110	2026-01-01 18:00:00	4	19.74	220	5387.2	t	2026-05-08 00:01:27.547131
111	2026-01-01 18:00:00	7	21.5	220	5616.9	t	2026-05-08 00:01:27.547131
112	2026-01-01 18:30:00	1	14.25	220	3258.9	t	2026-05-08 00:01:27.547131
113	2026-01-01 18:30:00	4	24.1	220	4864.2	t	2026-05-08 00:01:27.547131
114	2026-01-01 18:30:00	7	27.72	220	5431.8	t	2026-05-08 00:01:27.547131
115	2026-01-01 19:00:00	1	21.01	220	4711.9	t	2026-05-08 00:01:27.547131
116	2026-01-01 19:00:00	4	16.89	220	4395.9	t	2026-05-08 00:01:27.547131
117	2026-01-01 19:00:00	7	26.06	220	6707.7	t	2026-05-08 00:01:27.547131
118	2026-01-01 19:30:00	1	11.55	220	4084	t	2026-05-08 00:01:27.547131
119	2026-01-01 19:30:00	4	18.66	220	4496.6	t	2026-05-08 00:01:27.547131
120	2026-01-01 19:30:00	7	27.27	220	4736.1	t	2026-05-08 00:01:27.547131
121	2026-01-01 20:00:00	1	2.4	220	771.3	t	2026-05-08 00:01:27.547131
122	2026-01-01 20:00:00	4	1.9	220	757.6	t	2026-05-08 00:01:27.547131
123	2026-01-01 20:00:00	7	2.39	220	661.5	t	2026-05-08 00:01:27.547131
124	2026-01-01 20:30:00	1	1.25	220	520.2	t	2026-05-08 00:01:27.547131
125	2026-01-01 20:30:00	4	1.43	220	403.8	t	2026-05-08 00:01:27.547131
126	2026-01-01 20:30:00	7	2.65	220	327.2	t	2026-05-08 00:01:27.547131
127	2026-01-01 21:00:00	1	3.61	220	801.9	t	2026-05-08 00:01:27.547131
128	2026-01-01 21:00:00	4	2.47	220	663.4	t	2026-05-08 00:01:27.547131
129	2026-01-01 21:00:00	7	2.6	220	303.2	t	2026-05-08 00:01:27.547131
130	2026-01-01 21:30:00	1	1.62	220	787.2	t	2026-05-08 00:01:27.547131
131	2026-01-01 21:30:00	4	2.93	220	295.3	t	2026-05-08 00:01:27.547131
132	2026-01-01 21:30:00	7	3.41	220	508.7	t	2026-05-08 00:01:27.547131
133	2026-01-01 22:00:00	1	2.24	220	400.2	t	2026-05-08 00:01:27.547131
134	2026-01-01 22:00:00	4	2.09	220	402	t	2026-05-08 00:01:27.547131
135	2026-01-01 22:00:00	7	2.16	220	324.6	t	2026-05-08 00:01:27.547131
136	2026-01-01 22:30:00	1	2.9	220	476.2	t	2026-05-08 00:01:27.547131
137	2026-01-01 22:30:00	4	1.66	220	466.1	t	2026-05-08 00:01:27.547131
138	2026-01-01 22:30:00	7	3.42	220	807.3	t	2026-05-08 00:01:27.547131
139	2026-01-01 23:00:00	1	2.99	220	508.3	t	2026-05-08 00:01:27.547131
140	2026-01-01 23:00:00	4	2.06	220	682.8	t	2026-05-08 00:01:27.547131
141	2026-01-01 23:00:00	7	3.14	220	710.6	t	2026-05-08 00:01:27.547131
142	2026-01-01 23:30:00	1	3.12	220	657.5	t	2026-05-08 00:01:27.547131
143	2026-01-01 23:30:00	4	2.79	220	639.9	t	2026-05-08 00:01:27.547131
144	2026-01-01 23:30:00	7	1.91	220	565.4	t	2026-05-08 00:01:27.547131
145	2026-01-02 00:00:00	1	2.28	220	288.9	t	2026-05-08 00:01:27.547131
146	2026-01-02 00:00:00	4	1.56	220	278.3	t	2026-05-08 00:01:27.547131
147	2026-01-02 00:00:00	7	1.32	220	696.1	t	2026-05-08 00:01:27.547131
148	2026-01-02 00:30:00	1	3.01	220	606.1	t	2026-05-08 00:01:27.547131
149	2026-01-02 00:30:00	4	3.23	220	690.3	t	2026-05-08 00:01:27.547131
150	2026-01-02 00:30:00	7	3.29	220	348.9	t	2026-05-08 00:01:27.547131
151	2026-01-02 01:00:00	1	1.65	220	618.7	t	2026-05-08 00:01:27.547131
152	2026-01-02 01:00:00	4	2.4	220	658.3	t	2026-05-08 00:01:27.547131
153	2026-01-02 01:00:00	7	3.15	220	595.9	t	2026-05-08 00:01:27.547131
154	2026-01-02 01:30:00	1	2.03	220	791.9	t	2026-05-08 00:01:27.547131
155	2026-01-02 01:30:00	4	3.17	220	792.1	t	2026-05-08 00:01:27.547131
156	2026-01-02 01:30:00	7	2.92	220	730.6	t	2026-05-08 00:01:27.547131
157	2026-01-02 02:00:00	1	1.42	220	418.8	t	2026-05-08 00:01:27.547131
158	2026-01-02 02:00:00	4	2.61	220	519.5	t	2026-05-08 00:01:27.547131
159	2026-01-02 02:00:00	7	3.24	220	795.2	t	2026-05-08 00:01:27.547131
160	2026-01-02 02:30:00	1	3.45	220	807.6	t	2026-05-08 00:01:27.547131
161	2026-01-02 02:30:00	4	1.24	220	792.4	t	2026-05-08 00:01:27.547131
162	2026-01-02 02:30:00	7	3.28	220	538.4	t	2026-05-08 00:01:27.547131
163	2026-01-02 03:00:00	1	2.73	220	564.4	t	2026-05-08 00:01:27.547131
164	2026-01-02 03:00:00	4	1.59	220	271.5	t	2026-05-08 00:01:27.547131
165	2026-01-02 03:00:00	7	3.08	220	302.5	t	2026-05-08 00:01:27.547131
166	2026-01-02 03:30:00	1	2.57	220	698.3	t	2026-05-08 00:01:27.547131
167	2026-01-02 03:30:00	4	2.42	220	449.4	t	2026-05-08 00:01:27.547131
168	2026-01-02 03:30:00	7	1.41	220	766.1	t	2026-05-08 00:01:27.547131
169	2026-01-02 04:00:00	1	1.26	220	336.4	t	2026-05-08 00:01:27.547131
170	2026-01-02 04:00:00	4	1.86	220	583.5	t	2026-05-08 00:01:27.547131
171	2026-01-02 04:00:00	7	1.77	220	397.2	t	2026-05-08 00:01:27.547131
172	2026-01-02 04:30:00	1	3.08	220	656.1	t	2026-05-08 00:01:27.547131
173	2026-01-02 04:30:00	4	2.95	220	572.7	t	2026-05-08 00:01:27.547131
174	2026-01-02 04:30:00	7	3.14	220	795.5	t	2026-05-08 00:01:27.547131
175	2026-01-02 05:00:00	1	1.94	220	409.5	t	2026-05-08 00:01:27.547131
176	2026-01-02 05:00:00	4	3.05	220	469.5	t	2026-05-08 00:01:27.547131
177	2026-01-02 05:00:00	7	2.12	220	537.5	t	2026-05-08 00:01:27.547131
178	2026-01-02 05:30:00	1	1.35	220	281.6	t	2026-05-08 00:01:27.547131
179	2026-01-02 05:30:00	4	2.56	220	643.7	t	2026-05-08 00:01:27.547131
180	2026-01-02 05:30:00	7	1.85	220	796.1	t	2026-05-08 00:01:27.547131
181	2026-01-02 06:00:00	1	3.36	220	647.4	t	2026-05-08 00:01:27.547131
182	2026-01-02 06:00:00	4	3.37	220	676	t	2026-05-08 00:01:27.547131
183	2026-01-02 06:00:00	7	2.02	220	703.5	t	2026-05-08 00:01:27.547131
184	2026-01-02 06:30:00	1	2.55	220	657.1	t	2026-05-08 00:01:27.547131
185	2026-01-02 06:30:00	4	1.51	220	318	t	2026-05-08 00:01:27.547131
186	2026-01-02 06:30:00	7	3.3	220	422.8	t	2026-05-08 00:01:27.547131
187	2026-01-02 07:00:00	1	11.71	220	3889.7	t	2026-05-08 00:01:27.547131
188	2026-01-02 07:00:00	4	19.56	220	4066.2	t	2026-05-08 00:01:27.547131
189	2026-01-02 07:00:00	7	28.26	220	5352.4	t	2026-05-08 00:01:27.547131
190	2026-01-02 07:30:00	1	18.1	220	4179.8	t	2026-05-08 00:01:27.547131
191	2026-01-02 07:30:00	4	19.01	220	3853.1	t	2026-05-08 00:01:27.547131
192	2026-01-02 07:30:00	7	30.01	220	6460.3	t	2026-05-08 00:01:27.547131
193	2026-01-02 08:00:00	1	15.24	220	2947.4	t	2026-05-08 00:01:27.547131
194	2026-01-02 08:00:00	4	17.17	220	4467.5	t	2026-05-08 00:01:27.547131
195	2026-01-02 08:00:00	7	30.09	220	5083.7	t	2026-05-08 00:01:27.547131
196	2026-01-02 08:30:00	1	15.7	220	2549	t	2026-05-08 00:01:27.547131
197	2026-01-02 08:30:00	4	16.73	220	4820	t	2026-05-08 00:01:27.547131
198	2026-01-02 08:30:00	7	20.9	220	5541	t	2026-05-08 00:01:27.547131
199	2026-01-02 09:00:00	1	17.73	220	3113.1	t	2026-05-08 00:01:27.547131
200	2026-01-02 09:00:00	4	25.41	220	4439.6	t	2026-05-08 00:01:27.547131
201	2026-01-02 09:00:00	7	27.1	220	5262.9	t	2026-05-08 00:01:27.547131
202	2026-01-02 09:30:00	1	17.72	220	3514.4	t	2026-05-08 00:01:27.547131
203	2026-01-02 09:30:00	4	18.3	220	4582.3	t	2026-05-08 00:01:27.547131
204	2026-01-02 09:30:00	7	24.76	220	4897.7	t	2026-05-08 00:01:27.547131
205	2026-01-02 10:00:00	1	12.6	220	4065.3	t	2026-05-08 00:01:27.547131
206	2026-01-02 10:00:00	4	18.85	220	4041.8	t	2026-05-08 00:01:27.547131
207	2026-01-02 10:00:00	7	24.99	220	4806.6	t	2026-05-08 00:01:27.547131
208	2026-01-02 10:30:00	1	14.81	220	2547.5	t	2026-05-08 00:01:27.547131
209	2026-01-02 10:30:00	4	18.16	220	3959	t	2026-05-08 00:01:27.547131
210	2026-01-02 10:30:00	7	21.34	220	4554.8	t	2026-05-08 00:01:27.547131
211	2026-01-02 11:00:00	1	20.61	220	2820.2	t	2026-05-08 00:01:27.547131
212	2026-01-02 11:00:00	4	20.29	220	4648.8	t	2026-05-08 00:01:27.547131
213	2026-01-02 11:00:00	7	20.67	220	4585.4	t	2026-05-08 00:01:27.547131
214	2026-01-02 11:30:00	1	16.76	220	3795.7	t	2026-05-08 00:01:27.547131
215	2026-01-02 11:30:00	4	25.7	220	3703	t	2026-05-08 00:01:27.547131
216	2026-01-02 11:30:00	7	28	220	5931.7	t	2026-05-08 00:01:27.547131
217	2026-01-02 12:00:00	1	20.33	220	2980.3	t	2026-05-08 00:01:27.547131
218	2026-01-02 12:00:00	4	23.64	220	5410.6	t	2026-05-08 00:01:27.547131
219	2026-01-02 12:00:00	7	24.76	220	5999	t	2026-05-08 00:01:27.547131
220	2026-01-02 12:30:00	1	18.01	220	3621	t	2026-05-08 00:01:27.547131
221	2026-01-02 12:30:00	4	17.39	220	5519.9	t	2026-05-08 00:01:27.547131
222	2026-01-02 12:30:00	7	20.59	220	5343.8	t	2026-05-08 00:01:27.547131
223	2026-01-02 13:00:00	1	18.39	220	3598.4	t	2026-05-08 00:01:27.547131
224	2026-01-02 13:00:00	4	24.19	220	5702.8	t	2026-05-08 00:01:27.547131
225	2026-01-02 13:00:00	7	21.56	220	4524.4	t	2026-05-08 00:01:27.547131
226	2026-01-02 13:30:00	1	17.87	220	2871.4	t	2026-05-08 00:01:27.547131
227	2026-01-02 13:30:00	4	20.74	220	4121.1	t	2026-05-08 00:01:27.547131
228	2026-01-02 13:30:00	7	24.67	220	4654.8	t	2026-05-08 00:01:27.547131
229	2026-01-02 14:00:00	1	14.54	220	3174.6	t	2026-05-08 00:01:27.547131
230	2026-01-02 14:00:00	4	19.94	220	3564.6	t	2026-05-08 00:01:27.547131
231	2026-01-02 14:00:00	7	21.39	220	5518	t	2026-05-08 00:01:27.547131
232	2026-01-02 14:30:00	1	19.34	220	4651.5	t	2026-05-08 00:01:27.547131
233	2026-01-02 14:30:00	4	19.06	220	4150.8	t	2026-05-08 00:01:27.547131
234	2026-01-02 14:30:00	7	22.68	220	4960.7	t	2026-05-08 00:01:27.547131
235	2026-01-02 15:00:00	1	20	220	3498.9	t	2026-05-08 00:01:27.547131
236	2026-01-02 15:00:00	4	23.93	220	4365.3	t	2026-05-08 00:01:27.547131
237	2026-01-02 15:00:00	7	23.34	220	5923.8	t	2026-05-08 00:01:27.547131
238	2026-01-02 15:30:00	1	16.18	220	2553.3	t	2026-05-08 00:01:27.547131
239	2026-01-02 15:30:00	4	24.38	220	3701.5	t	2026-05-08 00:01:27.547131
240	2026-01-02 15:30:00	7	28.3	220	5878.4	t	2026-05-08 00:01:27.547131
241	2026-01-02 16:00:00	1	17.2	220	4410.3	t	2026-05-08 00:01:27.547131
242	2026-01-02 16:00:00	4	20.39	220	4965.4	t	2026-05-08 00:01:27.547131
243	2026-01-02 16:00:00	7	29.67	220	5249.3	t	2026-05-08 00:01:27.547131
244	2026-01-02 16:30:00	1	20.28	220	3938	t	2026-05-08 00:01:27.547131
245	2026-01-02 16:30:00	4	19.29	220	5015.5	t	2026-05-08 00:01:27.547131
246	2026-01-02 16:30:00	7	27.26	220	5697.6	t	2026-05-08 00:01:27.547131
247	2026-01-02 17:00:00	1	20.62	220	4239	t	2026-05-08 00:01:27.547131
248	2026-01-02 17:00:00	4	17.23	220	4624.9	t	2026-05-08 00:01:27.547131
249	2026-01-02 17:00:00	7	26.14	220	5848.7	t	2026-05-08 00:01:27.547131
250	2026-01-02 17:30:00	1	11.79	220	3054.3	t	2026-05-08 00:01:27.547131
251	2026-01-02 17:30:00	4	17.28	220	4799.3	t	2026-05-08 00:01:27.547131
252	2026-01-02 17:30:00	7	22.98	220	6596.7	t	2026-05-08 00:01:27.547131
253	2026-01-02 18:00:00	1	20.47	220	2627.1	t	2026-05-08 00:01:27.547131
254	2026-01-02 18:00:00	4	18.73	220	5354.8	t	2026-05-08 00:01:27.547131
255	2026-01-02 18:00:00	7	24.57	220	5713.1	t	2026-05-08 00:01:27.547131
256	2026-01-02 18:30:00	1	20.04	220	3620	t	2026-05-08 00:01:27.547131
257	2026-01-02 18:30:00	4	25.06	220	5193.8	t	2026-05-08 00:01:27.547131
258	2026-01-02 18:30:00	7	28.22	220	5906.5	t	2026-05-08 00:01:27.547131
259	2026-01-02 19:00:00	1	20.54	220	3029	t	2026-05-08 00:01:27.547131
260	2026-01-02 19:00:00	4	19.28	220	3684.4	t	2026-05-08 00:01:27.547131
261	2026-01-02 19:00:00	7	30.47	220	5061.7	t	2026-05-08 00:01:27.547131
262	2026-01-02 19:30:00	1	20.99	220	4053.5	t	2026-05-08 00:01:27.547131
263	2026-01-02 19:30:00	4	16.71	220	5141.6	t	2026-05-08 00:01:27.547131
264	2026-01-02 19:30:00	7	26.39	220	4649.8	t	2026-05-08 00:01:27.547131
265	2026-01-02 20:00:00	1	3.25	220	595.6	t	2026-05-08 00:01:27.547131
266	2026-01-02 20:00:00	4	3.37	220	559.7	t	2026-05-08 00:01:27.547131
267	2026-01-02 20:00:00	7	2.86	220	804.5	t	2026-05-08 00:01:27.547131
268	2026-01-02 20:30:00	1	3.28	220	743.4	t	2026-05-08 00:01:27.547131
269	2026-01-02 20:30:00	4	3.4	220	271.1	t	2026-05-08 00:01:27.547131
270	2026-01-02 20:30:00	7	2.19	220	272.6	t	2026-05-08 00:01:27.547131
271	2026-01-02 21:00:00	1	1.34	220	677.4	t	2026-05-08 00:01:27.547131
272	2026-01-02 21:00:00	4	3.08	220	465.3	t	2026-05-08 00:01:27.547131
273	2026-01-02 21:00:00	7	3.3	220	432.4	t	2026-05-08 00:01:27.547131
274	2026-01-02 21:30:00	1	2.9	220	692	t	2026-05-08 00:01:27.547131
275	2026-01-02 21:30:00	4	2.55	220	625.2	t	2026-05-08 00:01:27.547131
276	2026-01-02 21:30:00	7	1.66	220	494.4	t	2026-05-08 00:01:27.547131
277	2026-01-02 22:00:00	1	2.14	220	584.9	t	2026-05-08 00:01:27.547131
278	2026-01-02 22:00:00	4	1.88	220	658.6	t	2026-05-08 00:01:27.547131
279	2026-01-02 22:00:00	7	2.42	220	610.5	t	2026-05-08 00:01:27.547131
280	2026-01-02 22:30:00	1	2.77	220	779.1	t	2026-05-08 00:01:27.547131
281	2026-01-02 22:30:00	4	2.76	220	539.6	t	2026-05-08 00:01:27.547131
282	2026-01-02 22:30:00	7	2.12	220	608	t	2026-05-08 00:01:27.547131
283	2026-01-02 23:00:00	1	1.22	220	709.5	t	2026-05-08 00:01:27.547131
284	2026-01-02 23:00:00	4	1.9	220	460.9	t	2026-05-08 00:01:27.547131
285	2026-01-02 23:00:00	7	2.89	220	536.7	t	2026-05-08 00:01:27.547131
286	2026-01-02 23:30:00	1	2.04	220	806.3	t	2026-05-08 00:01:27.547131
287	2026-01-02 23:30:00	4	3.29	220	287.8	t	2026-05-08 00:01:27.547131
288	2026-01-02 23:30:00	7	2.88	220	609.6	t	2026-05-08 00:01:27.547131
289	2026-01-03 00:00:00	1	2.18	220	239.4	t	2026-05-08 00:01:27.547131
290	2026-01-03 00:00:00	4	2.63	220	627.8	t	2026-05-08 00:01:27.547131
291	2026-01-03 00:00:00	7	1.92	220	256.5	t	2026-05-08 00:01:27.547131
292	2026-01-03 00:30:00	1	1.87	220	456.1	t	2026-05-08 00:01:27.547131
293	2026-01-03 00:30:00	4	1.45	220	472.1	t	2026-05-08 00:01:27.547131
294	2026-01-03 00:30:00	7	1.6	220	394	t	2026-05-08 00:01:27.547131
295	2026-01-03 01:00:00	1	1.58	220	577.5	t	2026-05-08 00:01:27.547131
296	2026-01-03 01:00:00	4	2.91	220	278.6	t	2026-05-08 00:01:27.547131
297	2026-01-03 01:00:00	7	1.84	220	412.3	t	2026-05-08 00:01:27.547131
298	2026-01-03 01:30:00	1	2.99	220	385.4	t	2026-05-08 00:01:27.547131
299	2026-01-03 01:30:00	4	1.15	220	451.1	t	2026-05-08 00:01:27.547131
300	2026-01-03 01:30:00	7	2.52	220	295.8	t	2026-05-08 00:01:27.547131
301	2026-01-03 02:00:00	1	2.66	220	333.3	t	2026-05-08 00:01:27.547131
302	2026-01-03 02:00:00	4	1.55	220	230.3	t	2026-05-08 00:01:27.547131
303	2026-01-03 02:00:00	7	2	220	266.3	t	2026-05-08 00:01:27.547131
304	2026-01-03 02:30:00	1	2.13	220	340.7	t	2026-05-08 00:01:27.547131
305	2026-01-03 02:30:00	4	2.6	220	232	t	2026-05-08 00:01:27.547131
306	2026-01-03 02:30:00	7	2.16	220	398.2	t	2026-05-08 00:01:27.547131
307	2026-01-03 03:00:00	1	1.03	220	633.7	t	2026-05-08 00:01:27.547131
308	2026-01-03 03:00:00	4	2.21	220	329.7	t	2026-05-08 00:01:27.547131
309	2026-01-03 03:00:00	7	1.96	220	400.8	t	2026-05-08 00:01:27.547131
310	2026-01-03 03:30:00	1	1.15	220	492.5	t	2026-05-08 00:01:27.547131
311	2026-01-03 03:30:00	4	1.63	220	503.6	t	2026-05-08 00:01:27.547131
312	2026-01-03 03:30:00	7	1.11	220	385.8	t	2026-05-08 00:01:27.547131
313	2026-01-03 04:00:00	1	2.41	220	597.8	t	2026-05-08 00:01:27.547131
314	2026-01-03 04:00:00	4	2.58	220	240.4	t	2026-05-08 00:01:27.547131
315	2026-01-03 04:00:00	7	1.71	220	337.7	t	2026-05-08 00:01:27.547131
316	2026-01-03 04:30:00	1	2.4	220	309.3	t	2026-05-08 00:01:27.547131
317	2026-01-03 04:30:00	4	1.59	220	537	t	2026-05-08 00:01:27.547131
318	2026-01-03 04:30:00	7	1.7	220	577.7	t	2026-05-08 00:01:27.547131
319	2026-01-03 05:00:00	1	2.47	220	577.3	t	2026-05-08 00:01:27.547131
320	2026-01-03 05:00:00	4	2.14	220	550.9	t	2026-05-08 00:01:27.547131
321	2026-01-03 05:00:00	7	2.49	220	511.1	t	2026-05-08 00:01:27.547131
322	2026-01-03 05:30:00	1	1.59	220	297.2	t	2026-05-08 00:01:27.547131
323	2026-01-03 05:30:00	4	2.09	220	620	t	2026-05-08 00:01:27.547131
324	2026-01-03 05:30:00	7	1.69	220	645.7	t	2026-05-08 00:01:27.547131
325	2026-01-03 06:00:00	1	1.32	220	545.3	t	2026-05-08 00:01:27.547131
326	2026-01-03 06:00:00	4	2.27	220	435.7	t	2026-05-08 00:01:27.547131
327	2026-01-03 06:00:00	7	1.39	220	451.8	t	2026-05-08 00:01:27.547131
328	2026-01-03 06:30:00	1	1.43	220	623.5	t	2026-05-08 00:01:27.547131
329	2026-01-03 06:30:00	4	2.36	220	287.3	t	2026-05-08 00:01:27.547131
330	2026-01-03 06:30:00	7	2.5	220	516.6	t	2026-05-08 00:01:27.547131
331	2026-01-03 07:00:00	1	1.67	220	225.1	t	2026-05-08 00:01:27.547131
332	2026-01-03 07:00:00	4	2.98	220	275.2	t	2026-05-08 00:01:27.547131
333	2026-01-03 07:00:00	7	1.91	220	283.7	t	2026-05-08 00:01:27.547131
334	2026-01-03 07:30:00	1	2.94	220	235.6	t	2026-05-08 00:01:27.547131
335	2026-01-03 07:30:00	4	1.98	220	548.3	t	2026-05-08 00:01:27.547131
336	2026-01-03 07:30:00	7	2.83	220	405.4	t	2026-05-08 00:01:27.547131
337	2026-01-03 08:00:00	1	2.39	220	322.6	t	2026-05-08 00:01:27.547131
338	2026-01-03 08:00:00	4	2.41	220	600.5	t	2026-05-08 00:01:27.547131
339	2026-01-03 08:00:00	7	1.74	220	221.8	t	2026-05-08 00:01:27.547131
340	2026-01-03 08:30:00	1	2.93	220	432.2	t	2026-05-08 00:01:27.547131
341	2026-01-03 08:30:00	4	1.95	220	519.7	t	2026-05-08 00:01:27.547131
342	2026-01-03 08:30:00	7	2.74	220	501.9	t	2026-05-08 00:01:27.547131
343	2026-01-03 09:00:00	1	1.6	220	483.9	t	2026-05-08 00:01:27.547131
344	2026-01-03 09:00:00	4	2.83	220	652.7	t	2026-05-08 00:01:27.547131
345	2026-01-03 09:00:00	7	2.34	220	278.2	t	2026-05-08 00:01:27.547131
346	2026-01-03 09:30:00	1	2.56	220	645.4	t	2026-05-08 00:01:27.547131
347	2026-01-03 09:30:00	4	2.07	220	467.4	t	2026-05-08 00:01:27.547131
348	2026-01-03 09:30:00	7	1.31	220	470.5	t	2026-05-08 00:01:27.547131
349	2026-01-03 10:00:00	1	1.18	220	276.3	t	2026-05-08 00:01:27.547131
350	2026-01-03 10:00:00	4	2.46	220	307.5	t	2026-05-08 00:01:27.547131
351	2026-01-03 10:00:00	7	2.29	220	255.3	t	2026-05-08 00:01:27.547131
352	2026-01-03 10:30:00	1	2.84	220	645.6	t	2026-05-08 00:01:27.547131
353	2026-01-03 10:30:00	4	2.94	220	511.2	t	2026-05-08 00:01:27.547131
354	2026-01-03 10:30:00	7	2.15	220	396.9	t	2026-05-08 00:01:27.547131
355	2026-01-03 11:00:00	1	1.47	220	555.4	t	2026-05-08 00:01:27.547131
356	2026-01-03 11:00:00	4	1.97	220	404.7	t	2026-05-08 00:01:27.547131
357	2026-01-03 11:00:00	7	2.46	220	554.9	t	2026-05-08 00:01:27.547131
358	2026-01-03 11:30:00	1	1.89	220	386.7	t	2026-05-08 00:01:27.547131
359	2026-01-03 11:30:00	4	1.61	220	601.5	t	2026-05-08 00:01:27.547131
360	2026-01-03 11:30:00	7	1.88	220	432.1	t	2026-05-08 00:01:27.547131
361	2026-01-03 12:00:00	1	1.18	220	483.6	t	2026-05-08 00:01:27.547131
362	2026-01-03 12:00:00	4	2.76	220	247.9	t	2026-05-08 00:01:27.547131
363	2026-01-03 12:00:00	7	1.79	220	348.6	t	2026-05-08 00:01:27.547131
364	2026-01-03 12:30:00	1	2.78	220	489.4	t	2026-05-08 00:01:27.547131
365	2026-01-03 12:30:00	4	2.07	220	594.3	t	2026-05-08 00:01:27.547131
366	2026-01-03 12:30:00	7	2.89	220	261.4	t	2026-05-08 00:01:27.547131
367	2026-01-03 13:00:00	1	1.64	220	595.1	t	2026-05-08 00:01:27.547131
368	2026-01-03 13:00:00	4	2.12	220	634.5	t	2026-05-08 00:01:27.547131
369	2026-01-03 13:00:00	7	2.91	220	314.4	t	2026-05-08 00:01:27.547131
370	2026-01-03 13:30:00	1	2.75	220	279	t	2026-05-08 00:01:27.547131
371	2026-01-03 13:30:00	4	1.01	220	298	t	2026-05-08 00:01:27.547131
372	2026-01-03 13:30:00	7	2.94	220	507.7	t	2026-05-08 00:01:27.547131
373	2026-01-03 14:00:00	1	1.72	220	259.5	t	2026-05-08 00:01:27.547131
374	2026-01-03 14:00:00	4	2.14	220	579.9	t	2026-05-08 00:01:27.547131
375	2026-01-03 14:00:00	7	2.82	220	585.2	t	2026-05-08 00:01:27.547131
376	2026-01-03 14:30:00	1	2.82	220	268	t	2026-05-08 00:01:27.547131
377	2026-01-03 14:30:00	4	2.67	220	238.4	t	2026-05-08 00:01:27.547131
378	2026-01-03 14:30:00	7	2.87	220	561	t	2026-05-08 00:01:27.547131
379	2026-01-03 15:00:00	1	2.97	220	529	t	2026-05-08 00:01:27.547131
380	2026-01-03 15:00:00	4	1.02	220	266.6	t	2026-05-08 00:01:27.547131
381	2026-01-03 15:00:00	7	2.42	220	221.9	t	2026-05-08 00:01:27.547131
382	2026-01-03 15:30:00	1	2.48	220	489.1	t	2026-05-08 00:01:27.547131
383	2026-01-03 15:30:00	4	2.06	220	370.1	t	2026-05-08 00:01:27.547131
384	2026-01-03 15:30:00	7	1.52	220	659.7	t	2026-05-08 00:01:27.547131
385	2026-01-03 16:00:00	1	1.08	220	492.2	t	2026-05-08 00:01:27.547131
386	2026-01-03 16:00:00	4	2.69	220	479.1	t	2026-05-08 00:01:27.547131
387	2026-01-03 16:00:00	7	1.58	220	255.5	t	2026-05-08 00:01:27.547131
388	2026-01-03 16:30:00	1	1.22	220	608.3	t	2026-05-08 00:01:27.547131
389	2026-01-03 16:30:00	4	1.35	220	285.8	t	2026-05-08 00:01:27.547131
390	2026-01-03 16:30:00	7	1.9	220	558.3	t	2026-05-08 00:01:27.547131
391	2026-01-03 17:00:00	1	2.43	220	425.2	t	2026-05-08 00:01:27.547131
392	2026-01-03 17:00:00	4	1.23	220	244.6	t	2026-05-08 00:01:27.547131
393	2026-01-03 17:00:00	7	1.99	220	342.3	t	2026-05-08 00:01:27.547131
394	2026-01-03 17:30:00	1	1.13	220	295	t	2026-05-08 00:01:27.547131
395	2026-01-03 17:30:00	4	1.95	220	495.5	t	2026-05-08 00:01:27.547131
396	2026-01-03 17:30:00	7	1.09	220	411	t	2026-05-08 00:01:27.547131
397	2026-01-03 18:00:00	1	2.1	220	593.7	t	2026-05-08 00:01:27.547131
398	2026-01-03 18:00:00	4	2.81	220	224.2	t	2026-05-08 00:01:27.547131
399	2026-01-03 18:00:00	7	1.25	220	576.4	t	2026-05-08 00:01:27.547131
400	2026-01-03 18:30:00	1	1.24	220	575.9	t	2026-05-08 00:01:27.547131
401	2026-01-03 18:30:00	4	2.03	220	398.2	t	2026-05-08 00:01:27.547131
402	2026-01-03 18:30:00	7	1.06	220	325.8	t	2026-05-08 00:01:27.547131
403	2026-01-03 19:00:00	1	1.37	220	497.8	t	2026-05-08 00:01:27.547131
404	2026-01-03 19:00:00	4	2.27	220	320.4	t	2026-05-08 00:01:27.547131
405	2026-01-03 19:00:00	7	2.46	220	256.2	t	2026-05-08 00:01:27.547131
406	2026-01-03 19:30:00	1	2.19	220	236.2	t	2026-05-08 00:01:27.547131
407	2026-01-03 19:30:00	4	1.14	220	486.2	t	2026-05-08 00:01:27.547131
408	2026-01-03 19:30:00	7	2.42	220	344.7	t	2026-05-08 00:01:27.547131
409	2026-01-03 20:00:00	1	1.12	220	385.2	t	2026-05-08 00:01:27.547131
410	2026-01-03 20:00:00	4	1.2	220	398.5	t	2026-05-08 00:01:27.547131
411	2026-01-03 20:00:00	7	2.69	220	485.4	t	2026-05-08 00:01:27.547131
412	2026-01-03 20:30:00	1	1.99	220	652.3	t	2026-05-08 00:01:27.547131
413	2026-01-03 20:30:00	4	2.4	220	533.1	t	2026-05-08 00:01:27.547131
414	2026-01-03 20:30:00	7	1.92	220	478.5	t	2026-05-08 00:01:27.547131
415	2026-01-03 21:00:00	1	2.71	220	268.1	t	2026-05-08 00:01:27.547131
416	2026-01-03 21:00:00	4	2.78	220	266.8	t	2026-05-08 00:01:27.547131
417	2026-01-03 21:00:00	7	1.7	220	428	t	2026-05-08 00:01:27.547131
418	2026-01-03 21:30:00	1	2.88	220	375.4	t	2026-05-08 00:01:27.547131
419	2026-01-03 21:30:00	4	2.7	220	292.8	t	2026-05-08 00:01:27.547131
420	2026-01-03 21:30:00	7	2.52	220	514.1	t	2026-05-08 00:01:27.547131
421	2026-01-03 22:00:00	1	2.34	220	501.3	t	2026-05-08 00:01:27.547131
422	2026-01-03 22:00:00	4	2.5	220	445.8	t	2026-05-08 00:01:27.547131
423	2026-01-03 22:00:00	7	2.24	220	304.1	t	2026-05-08 00:01:27.547131
424	2026-01-03 22:30:00	1	2.57	220	654.1	t	2026-05-08 00:01:27.547131
425	2026-01-03 22:30:00	4	1.72	220	330.8	t	2026-05-08 00:01:27.547131
426	2026-01-03 22:30:00	7	2.61	220	267	t	2026-05-08 00:01:27.547131
427	2026-01-03 23:00:00	1	1.39	220	347.1	t	2026-05-08 00:01:27.547131
428	2026-01-03 23:00:00	4	2.44	220	488	t	2026-05-08 00:01:27.547131
429	2026-01-03 23:00:00	7	2.67	220	653.7	t	2026-05-08 00:01:27.547131
430	2026-01-03 23:30:00	1	2.46	220	507.5	t	2026-05-08 00:01:27.547131
431	2026-01-03 23:30:00	4	2.39	220	334	t	2026-05-08 00:01:27.547131
432	2026-01-03 23:30:00	7	2.79	220	591.4	t	2026-05-08 00:01:27.547131
433	2026-01-04 00:00:00	1	1.74	220	535.1	t	2026-05-08 00:01:27.547131
434	2026-01-04 00:00:00	4	1.01	220	274.5	t	2026-05-08 00:01:27.547131
435	2026-01-04 00:00:00	7	1.07	220	473.7	t	2026-05-08 00:01:27.547131
436	2026-01-04 00:30:00	1	1.69	220	640.6	t	2026-05-08 00:01:27.547131
437	2026-01-04 00:30:00	4	2.68	220	595.8	t	2026-05-08 00:01:27.547131
438	2026-01-04 00:30:00	7	1.42	220	482.1	t	2026-05-08 00:01:27.547131
439	2026-01-04 01:00:00	1	2.45	220	229.9	t	2026-05-08 00:01:27.547131
440	2026-01-04 01:00:00	4	1.46	220	440.3	t	2026-05-08 00:01:27.547131
441	2026-01-04 01:00:00	7	2.51	220	650.5	t	2026-05-08 00:01:27.547131
442	2026-01-04 01:30:00	1	2.9	220	310	t	2026-05-08 00:01:27.547131
443	2026-01-04 01:30:00	4	1.84	220	223.4	t	2026-05-08 00:01:27.547131
444	2026-01-04 01:30:00	7	2.15	220	471.9	t	2026-05-08 00:01:27.547131
445	2026-01-04 02:00:00	1	2.23	220	557	t	2026-05-08 00:01:27.547131
446	2026-01-04 02:00:00	4	1.57	220	359.1	t	2026-05-08 00:01:27.547131
447	2026-01-04 02:00:00	7	1.55	220	635.7	t	2026-05-08 00:01:27.547131
448	2026-01-04 02:30:00	1	2.35	220	286.6	t	2026-05-08 00:01:27.547131
449	2026-01-04 02:30:00	4	2.67	220	641.4	t	2026-05-08 00:01:27.547131
450	2026-01-04 02:30:00	7	1.15	220	558.7	t	2026-05-08 00:01:27.547131
451	2026-01-04 03:00:00	1	2.94	220	225.7	t	2026-05-08 00:01:27.547131
452	2026-01-04 03:00:00	4	1.71	220	238.4	t	2026-05-08 00:01:27.547131
453	2026-01-04 03:00:00	7	1.58	220	566.2	t	2026-05-08 00:01:27.547131
454	2026-01-04 03:30:00	1	1.17	220	246.9	t	2026-05-08 00:01:27.547131
455	2026-01-04 03:30:00	4	2.47	220	503.1	t	2026-05-08 00:01:27.547131
456	2026-01-04 03:30:00	7	2.19	220	576.4	t	2026-05-08 00:01:27.547131
457	2026-01-04 04:00:00	1	1.17	220	621.9	t	2026-05-08 00:01:27.547131
458	2026-01-04 04:00:00	4	1.5	220	471.3	t	2026-05-08 00:01:27.547131
459	2026-01-04 04:00:00	7	3	220	652.7	t	2026-05-08 00:01:27.547131
460	2026-01-04 04:30:00	1	2.18	220	395.6	t	2026-05-08 00:01:27.547131
461	2026-01-04 04:30:00	4	2.2	220	566.3	t	2026-05-08 00:01:27.547131
462	2026-01-04 04:30:00	7	1.76	220	432.7	t	2026-05-08 00:01:27.547131
463	2026-01-04 05:00:00	1	1.58	220	366.8	t	2026-05-08 00:01:27.547131
464	2026-01-04 05:00:00	4	1.31	220	606.8	t	2026-05-08 00:01:27.547131
465	2026-01-04 05:00:00	7	2.97	220	405.1	t	2026-05-08 00:01:27.547131
466	2026-01-04 05:30:00	1	2.53	220	324.5	t	2026-05-08 00:01:27.547131
467	2026-01-04 05:30:00	4	2.01	220	369	t	2026-05-08 00:01:27.547131
468	2026-01-04 05:30:00	7	1.77	220	355.7	t	2026-05-08 00:01:27.547131
469	2026-01-04 06:00:00	1	2.5	220	642.7	t	2026-05-08 00:01:27.547131
470	2026-01-04 06:00:00	4	2.05	220	251.8	t	2026-05-08 00:01:27.547131
471	2026-01-04 06:00:00	7	1.17	220	229.6	t	2026-05-08 00:01:27.547131
472	2026-01-04 06:30:00	1	1.18	220	371.4	t	2026-05-08 00:01:27.547131
473	2026-01-04 06:30:00	4	2.66	220	459.4	t	2026-05-08 00:01:27.547131
474	2026-01-04 06:30:00	7	2.63	220	508	t	2026-05-08 00:01:27.547131
475	2026-01-04 07:00:00	1	1.37	220	337.6	t	2026-05-08 00:01:27.547131
476	2026-01-04 07:00:00	4	1.27	220	534.6	t	2026-05-08 00:01:27.547131
477	2026-01-04 07:00:00	7	2.88	220	443.9	t	2026-05-08 00:01:27.547131
478	2026-01-04 07:30:00	1	2.14	220	447.3	t	2026-05-08 00:01:27.547131
479	2026-01-04 07:30:00	4	1.36	220	375.7	t	2026-05-08 00:01:27.547131
480	2026-01-04 07:30:00	7	2.2	220	507	t	2026-05-08 00:01:27.547131
481	2026-01-04 08:00:00	1	2.16	220	476.2	t	2026-05-08 00:01:27.547131
482	2026-01-04 08:00:00	4	1.66	220	625	t	2026-05-08 00:01:27.547131
483	2026-01-04 08:00:00	7	1.4	220	448.4	t	2026-05-08 00:01:27.547131
484	2026-01-04 08:30:00	1	2.32	220	437	t	2026-05-08 00:01:27.547131
485	2026-01-04 08:30:00	4	1.39	220	239.6	t	2026-05-08 00:01:27.547131
486	2026-01-04 08:30:00	7	1.04	220	430.8	t	2026-05-08 00:01:27.547131
487	2026-01-04 09:00:00	1	2.38	220	436	t	2026-05-08 00:01:27.547131
488	2026-01-04 09:00:00	4	1.85	220	475.2	t	2026-05-08 00:01:27.547131
489	2026-01-04 09:00:00	7	2.28	220	497.2	t	2026-05-08 00:01:27.547131
490	2026-01-04 09:30:00	1	2.02	220	561.3	t	2026-05-08 00:01:27.547131
491	2026-01-04 09:30:00	4	1.71	220	544.9	t	2026-05-08 00:01:27.547131
492	2026-01-04 09:30:00	7	2.79	220	326.7	t	2026-05-08 00:01:27.547131
493	2026-01-04 10:00:00	1	2.26	220	562.1	t	2026-05-08 00:01:27.547131
494	2026-01-04 10:00:00	4	1.63	220	380.8	t	2026-05-08 00:01:27.547131
495	2026-01-04 10:00:00	7	2.19	220	271.5	t	2026-05-08 00:01:27.547131
496	2026-01-04 10:30:00	1	1.14	220	411.6	t	2026-05-08 00:01:27.547131
497	2026-01-04 10:30:00	4	1.13	220	390	t	2026-05-08 00:01:27.547131
498	2026-01-04 10:30:00	7	2.04	220	543.7	t	2026-05-08 00:01:27.547131
499	2026-01-04 11:00:00	1	1.65	220	291.7	t	2026-05-08 00:01:27.547131
500	2026-01-04 11:00:00	4	1.88	220	494.6	t	2026-05-08 00:01:27.547131
501	2026-01-04 11:00:00	7	1.76	220	551.5	t	2026-05-08 00:01:27.547131
502	2026-01-04 11:30:00	1	2.17	220	629	t	2026-05-08 00:01:27.547131
503	2026-01-04 11:30:00	4	1.69	220	603.2	t	2026-05-08 00:01:27.547131
504	2026-01-04 11:30:00	7	1.29	220	561.4	t	2026-05-08 00:01:27.547131
505	2026-01-04 12:00:00	1	1.39	220	309.4	t	2026-05-08 00:01:27.547131
506	2026-01-04 12:00:00	4	2.84	220	650.7	t	2026-05-08 00:01:27.547131
507	2026-01-04 12:00:00	7	1.71	220	492.7	t	2026-05-08 00:01:27.547131
508	2026-01-04 12:30:00	1	1.85	220	518.3	t	2026-05-08 00:01:27.547131
509	2026-01-04 12:30:00	4	2.12	220	464	t	2026-05-08 00:01:27.547131
510	2026-01-04 12:30:00	7	1.33	220	368	t	2026-05-08 00:01:27.547131
511	2026-01-04 13:00:00	1	2.19	220	331.2	t	2026-05-08 00:01:27.547131
512	2026-01-04 13:00:00	4	1.36	220	342.5	t	2026-05-08 00:01:27.547131
513	2026-01-04 13:00:00	7	1.77	220	474.4	t	2026-05-08 00:01:27.547131
514	2026-01-04 13:30:00	1	1.02	220	427.1	t	2026-05-08 00:01:27.547131
515	2026-01-04 13:30:00	4	1.5	220	290.4	t	2026-05-08 00:01:27.547131
516	2026-01-04 13:30:00	7	1.69	220	496	t	2026-05-08 00:01:27.547131
517	2026-01-04 14:00:00	1	1.89	220	457.1	t	2026-05-08 00:01:27.547131
518	2026-01-04 14:00:00	4	1.94	220	549.8	t	2026-05-08 00:01:27.547131
519	2026-01-04 14:00:00	7	1.73	220	511.5	t	2026-05-08 00:01:27.547131
520	2026-01-04 14:30:00	1	2.54	220	471.2	t	2026-05-08 00:01:27.547131
521	2026-01-04 14:30:00	4	2.9	220	447.9	t	2026-05-08 00:01:27.547131
522	2026-01-04 14:30:00	7	1.34	220	338.4	t	2026-05-08 00:01:27.547131
523	2026-01-04 15:00:00	1	1.5	220	567.1	t	2026-05-08 00:01:27.547131
524	2026-01-04 15:00:00	4	2.74	220	493.1	t	2026-05-08 00:01:27.547131
525	2026-01-04 15:00:00	7	1.34	220	515.6	t	2026-05-08 00:01:27.547131
526	2026-01-04 15:30:00	1	2.69	220	521	t	2026-05-08 00:01:27.547131
527	2026-01-04 15:30:00	4	2.79	220	645.7	t	2026-05-08 00:01:27.547131
528	2026-01-04 15:30:00	7	1.17	220	487.4	t	2026-05-08 00:01:27.547131
529	2026-01-04 16:00:00	1	2.99	220	328	t	2026-05-08 00:01:27.547131
530	2026-01-04 16:00:00	4	2.66	220	342.2	t	2026-05-08 00:01:27.547131
531	2026-01-04 16:00:00	7	2.36	220	441.4	t	2026-05-08 00:01:27.547131
532	2026-01-04 16:30:00	1	1.13	220	310.3	t	2026-05-08 00:01:27.547131
533	2026-01-04 16:30:00	4	2.53	220	221	t	2026-05-08 00:01:27.547131
534	2026-01-04 16:30:00	7	1.26	220	505.6	t	2026-05-08 00:01:27.547131
535	2026-01-04 17:00:00	1	1.27	220	309.3	t	2026-05-08 00:01:27.547131
536	2026-01-04 17:00:00	4	2.81	220	326.4	t	2026-05-08 00:01:27.547131
537	2026-01-04 17:00:00	7	1.43	220	564.9	t	2026-05-08 00:01:27.547131
538	2026-01-04 17:30:00	1	1.32	220	380.3	t	2026-05-08 00:01:27.547131
539	2026-01-04 17:30:00	4	2.97	220	228.7	t	2026-05-08 00:01:27.547131
540	2026-01-04 17:30:00	7	2.82	220	513.2	t	2026-05-08 00:01:27.547131
541	2026-01-04 18:00:00	1	2.91	220	572.7	t	2026-05-08 00:01:27.547131
542	2026-01-04 18:00:00	4	2.45	220	261.3	t	2026-05-08 00:01:27.547131
543	2026-01-04 18:00:00	7	2.51	220	346.1	t	2026-05-08 00:01:27.547131
544	2026-01-04 18:30:00	1	1.51	220	223.4	t	2026-05-08 00:01:27.547131
545	2026-01-04 18:30:00	4	1.47	220	271.9	t	2026-05-08 00:01:27.547131
546	2026-01-04 18:30:00	7	1.69	220	248.6	t	2026-05-08 00:01:27.547131
547	2026-01-04 19:00:00	1	1.33	220	316.8	t	2026-05-08 00:01:27.547131
548	2026-01-04 19:00:00	4	2.17	220	473.3	t	2026-05-08 00:01:27.547131
549	2026-01-04 19:00:00	7	1.98	220	288.4	t	2026-05-08 00:01:27.547131
550	2026-01-04 19:30:00	1	1.26	220	514	t	2026-05-08 00:01:27.547131
551	2026-01-04 19:30:00	4	1.07	220	414.9	t	2026-05-08 00:01:27.547131
552	2026-01-04 19:30:00	7	1.44	220	405.3	t	2026-05-08 00:01:27.547131
553	2026-01-04 20:00:00	1	1.65	220	388.2	t	2026-05-08 00:01:27.547131
554	2026-01-04 20:00:00	4	1.59	220	651.1	t	2026-05-08 00:01:27.547131
555	2026-01-04 20:00:00	7	2.08	220	424.3	t	2026-05-08 00:01:27.547131
556	2026-01-04 20:30:00	1	2.88	220	659.2	t	2026-05-08 00:01:27.547131
557	2026-01-04 20:30:00	4	1.19	220	223.7	t	2026-05-08 00:01:27.547131
558	2026-01-04 20:30:00	7	2.04	220	515.7	t	2026-05-08 00:01:27.547131
559	2026-01-04 21:00:00	1	1.96	220	612.1	t	2026-05-08 00:01:27.547131
560	2026-01-04 21:00:00	4	2.78	220	308.6	t	2026-05-08 00:01:27.547131
561	2026-01-04 21:00:00	7	2.22	220	540.7	t	2026-05-08 00:01:27.547131
562	2026-01-04 21:30:00	1	2.69	220	309	t	2026-05-08 00:01:27.547131
563	2026-01-04 21:30:00	4	1.66	220	404.3	t	2026-05-08 00:01:27.547131
564	2026-01-04 21:30:00	7	1.39	220	239	t	2026-05-08 00:01:27.547131
565	2026-01-04 22:00:00	1	2.6	220	347.5	t	2026-05-08 00:01:27.547131
566	2026-01-04 22:00:00	4	1.1	220	615.7	t	2026-05-08 00:01:27.547131
567	2026-01-04 22:00:00	7	2.12	220	556.9	t	2026-05-08 00:01:27.547131
568	2026-01-04 22:30:00	1	2.39	220	403.2	t	2026-05-08 00:01:27.547131
569	2026-01-04 22:30:00	4	1.03	220	317.4	t	2026-05-08 00:01:27.547131
570	2026-01-04 22:30:00	7	2.66	220	524.2	t	2026-05-08 00:01:27.547131
571	2026-01-04 23:00:00	1	2.02	220	584.9	t	2026-05-08 00:01:27.547131
572	2026-01-04 23:00:00	4	1.88	220	488.7	t	2026-05-08 00:01:27.547131
573	2026-01-04 23:00:00	7	1.29	220	271.8	t	2026-05-08 00:01:27.547131
574	2026-01-04 23:30:00	1	2.04	220	375.5	t	2026-05-08 00:01:27.547131
575	2026-01-04 23:30:00	4	2.36	220	536.4	t	2026-05-08 00:01:27.547131
576	2026-01-04 23:30:00	7	1.43	220	283.3	t	2026-05-08 00:01:27.547131
577	2026-01-05 00:00:00	1	1.37	220	296.8	t	2026-05-08 00:01:27.547131
578	2026-01-05 00:00:00	4	1.89	220	571.9	t	2026-05-08 00:01:27.547131
579	2026-01-05 00:00:00	7	2.06	220	375.9	t	2026-05-08 00:01:27.547131
580	2026-01-05 00:30:00	1	2.01	220	345.4	t	2026-05-08 00:01:27.547131
581	2026-01-05 00:30:00	4	2.54	220	759.2	t	2026-05-08 00:01:27.547131
582	2026-01-05 00:30:00	7	1.87	220	798.7	t	2026-05-08 00:01:27.547131
583	2026-01-05 01:00:00	1	2.91	220	273.7	t	2026-05-08 00:01:27.547131
584	2026-01-05 01:00:00	4	2.88	220	450.2	t	2026-05-08 00:01:27.547131
585	2026-01-05 01:00:00	7	3.05	220	497.3	t	2026-05-08 00:01:27.547131
586	2026-01-05 01:30:00	1	2.54	220	385.7	t	2026-05-08 00:01:27.547131
587	2026-01-05 01:30:00	4	3.32	220	741.9	t	2026-05-08 00:01:27.547131
588	2026-01-05 01:30:00	7	3.03	220	471.5	t	2026-05-08 00:01:27.547131
589	2026-01-05 02:00:00	1	2.9	220	334.1	t	2026-05-08 00:01:27.547131
590	2026-01-05 02:00:00	4	2.1	220	535.4	t	2026-05-08 00:01:27.547131
591	2026-01-05 02:00:00	7	2.63	220	573.6	t	2026-05-08 00:01:27.547131
592	2026-01-05 02:30:00	1	1.98	220	579.8	t	2026-05-08 00:01:27.547131
593	2026-01-05 02:30:00	4	2.43	220	705.3	t	2026-05-08 00:01:27.547131
594	2026-01-05 02:30:00	7	2.14	220	753.4	t	2026-05-08 00:01:27.547131
595	2026-01-05 03:00:00	1	2	220	477.6	t	2026-05-08 00:01:27.547131
596	2026-01-05 03:00:00	4	1.61	220	326.6	t	2026-05-08 00:01:27.547131
597	2026-01-05 03:00:00	7	3.6	220	448.3	t	2026-05-08 00:01:27.547131
598	2026-01-05 03:30:00	1	2.52	220	790.7	t	2026-05-08 00:01:27.547131
599	2026-01-05 03:30:00	4	1.51	220	712.6	t	2026-05-08 00:01:27.547131
600	2026-01-05 03:30:00	7	2.76	220	580.8	t	2026-05-08 00:01:27.547131
601	2026-01-05 04:00:00	1	3.59	220	284.9	t	2026-05-08 00:01:27.547131
602	2026-01-05 04:00:00	4	1.58	220	506.5	t	2026-05-08 00:01:27.547131
603	2026-01-05 04:00:00	7	3.39	220	387	t	2026-05-08 00:01:27.547131
604	2026-01-05 04:30:00	1	3.18	220	803.6	t	2026-05-08 00:01:27.547131
605	2026-01-05 04:30:00	4	3.59	220	480.9	t	2026-05-08 00:01:27.547131
606	2026-01-05 04:30:00	7	1.27	220	341.7	t	2026-05-08 00:01:27.547131
607	2026-01-05 05:00:00	1	1.38	220	275.9	t	2026-05-08 00:01:27.547131
608	2026-01-05 05:00:00	4	2.05	220	445	t	2026-05-08 00:01:27.547131
609	2026-01-05 05:00:00	7	2.52	220	435.9	t	2026-05-08 00:01:27.547131
610	2026-01-05 05:30:00	1	3.51	220	320	t	2026-05-08 00:01:27.547131
611	2026-01-05 05:30:00	4	1.42	220	461.7	t	2026-05-08 00:01:27.547131
612	2026-01-05 05:30:00	7	2.31	220	645.4	t	2026-05-08 00:01:27.547131
613	2026-01-05 06:00:00	1	2.04	220	699.6	t	2026-05-08 00:01:27.547131
614	2026-01-05 06:00:00	4	3.59	220	378.7	t	2026-05-08 00:01:27.547131
615	2026-01-05 06:00:00	7	2.14	220	670.5	t	2026-05-08 00:01:27.547131
616	2026-01-05 06:30:00	1	1.92	220	370.9	t	2026-05-08 00:01:27.547131
617	2026-01-05 06:30:00	4	2.14	220	395.8	t	2026-05-08 00:01:27.547131
618	2026-01-05 06:30:00	7	3.54	220	277.2	t	2026-05-08 00:01:27.547131
619	2026-01-05 07:00:00	1	17.19	220	3081.6	t	2026-05-08 00:01:27.547131
620	2026-01-05 07:00:00	4	18.9	220	5115.9	t	2026-05-08 00:01:27.547131
621	2026-01-05 07:00:00	7	30.25	220	5111.3	t	2026-05-08 00:01:27.547131
622	2026-01-05 07:30:00	1	12.25	220	4066.4	t	2026-05-08 00:01:27.547131
623	2026-01-05 07:30:00	4	24.21	220	4785.4	t	2026-05-08 00:01:27.547131
624	2026-01-05 07:30:00	7	24.88	220	4548.4	t	2026-05-08 00:01:27.547131
625	2026-01-05 08:00:00	1	15.33	220	4626.7	t	2026-05-08 00:01:27.547131
626	2026-01-05 08:00:00	4	20.24	220	4161.4	t	2026-05-08 00:01:27.547131
627	2026-01-05 08:00:00	7	23.66	220	5389.1	t	2026-05-08 00:01:27.547131
628	2026-01-05 08:30:00	1	14.82	220	3611.2	t	2026-05-08 00:01:27.547131
629	2026-01-05 08:30:00	4	23.16	220	4423.7	t	2026-05-08 00:01:27.547131
630	2026-01-05 08:30:00	7	24.57	220	6483.9	t	2026-05-08 00:01:27.547131
631	2026-01-05 09:00:00	1	20.82	220	2804.8	t	2026-05-08 00:01:27.547131
632	2026-01-05 09:00:00	4	21.18	220	3775.9	t	2026-05-08 00:01:27.547131
633	2026-01-05 09:00:00	7	27.88	220	5657.1	t	2026-05-08 00:01:27.547131
634	2026-01-05 09:30:00	1	21.16	220	3396.4	t	2026-05-08 00:01:27.547131
635	2026-01-05 09:30:00	4	17.26	220	4255.8	t	2026-05-08 00:01:27.547131
636	2026-01-05 09:30:00	7	24.71	220	4833.6	t	2026-05-08 00:01:27.547131
637	2026-01-05 10:00:00	1	14.55	220	3190.9	t	2026-05-08 00:01:27.547131
638	2026-01-05 10:00:00	4	23.53	220	4267	t	2026-05-08 00:01:27.547131
639	2026-01-05 10:00:00	7	29.48	220	6519.7	t	2026-05-08 00:01:27.547131
640	2026-01-05 10:30:00	1	15	220	4232.7	t	2026-05-08 00:01:27.547131
641	2026-01-05 10:30:00	4	21.44	220	5419.5	t	2026-05-08 00:01:27.547131
642	2026-01-05 10:30:00	7	23.22	220	5986.1	t	2026-05-08 00:01:27.547131
643	2026-01-05 11:00:00	1	11.96	220	3217	t	2026-05-08 00:01:27.547131
644	2026-01-05 11:00:00	4	23.69	220	5413.5	t	2026-05-08 00:01:27.547131
645	2026-01-05 11:00:00	7	21.54	220	6385.9	t	2026-05-08 00:01:27.547131
646	2026-01-05 11:30:00	1	18.96	220	3316.5	t	2026-05-08 00:01:27.547131
647	2026-01-05 11:30:00	4	20.92	220	4344.3	t	2026-05-08 00:01:27.547131
648	2026-01-05 11:30:00	7	21.44	220	6175.2	t	2026-05-08 00:01:27.547131
649	2026-01-05 12:00:00	1	12.59	220	2560.4	t	2026-05-08 00:01:27.547131
650	2026-01-05 12:00:00	4	18.07	220	5358.3	t	2026-05-08 00:01:27.547131
651	2026-01-05 12:00:00	7	22.06	220	5124.8	t	2026-05-08 00:01:27.547131
652	2026-01-05 12:30:00	1	20.95	220	3220	t	2026-05-08 00:01:27.547131
653	2026-01-05 12:30:00	4	18.98	220	4407.5	t	2026-05-08 00:01:27.547131
654	2026-01-05 12:30:00	7	20.98	220	6704.6	t	2026-05-08 00:01:27.547131
655	2026-01-05 13:00:00	1	12.37	220	2582.2	t	2026-05-08 00:01:27.547131
656	2026-01-05 13:00:00	4	22.18	220	5179.5	t	2026-05-08 00:01:27.547131
657	2026-01-05 13:00:00	7	22.4	220	6387.3	t	2026-05-08 00:01:27.547131
658	2026-01-05 13:30:00	1	21.42	220	3781.1	t	2026-05-08 00:01:27.547131
659	2026-01-05 13:30:00	4	22.46	220	5546.7	t	2026-05-08 00:01:27.547131
660	2026-01-05 13:30:00	7	24.79	220	5435.9	t	2026-05-08 00:01:27.547131
661	2026-01-05 14:00:00	1	11.73	220	4584.2	t	2026-05-08 00:01:27.547131
662	2026-01-05 14:00:00	4	17.12	220	4131.6	t	2026-05-08 00:01:27.547131
663	2026-01-05 14:00:00	7	27.81	220	5479.6	t	2026-05-08 00:01:27.547131
664	2026-01-05 14:30:00	1	12.39	220	3320.1	t	2026-05-08 00:01:27.547131
665	2026-01-05 14:30:00	4	24.65	220	4710.3	t	2026-05-08 00:01:27.547131
666	2026-01-05 14:30:00	7	21.95	220	6206.2	t	2026-05-08 00:01:27.547131
667	2026-01-05 15:00:00	1	21.33	220	4452.5	t	2026-05-08 00:01:27.547131
668	2026-01-05 15:00:00	4	19.19	220	5354.9	t	2026-05-08 00:01:27.547131
669	2026-01-05 15:00:00	7	22.23	220	5327.5	t	2026-05-08 00:01:27.547131
670	2026-01-05 15:30:00	1	14.29	220	4098.4	t	2026-05-08 00:01:27.547131
671	2026-01-05 15:30:00	4	21.05	220	3906.9	t	2026-05-08 00:01:27.547131
672	2026-01-05 15:30:00	7	21.36	220	6693.5	t	2026-05-08 00:01:27.547131
673	2026-01-05 16:00:00	1	21.15	220	3199.3	t	2026-05-08 00:01:27.547131
674	2026-01-05 16:00:00	4	19.98	220	3564.7	t	2026-05-08 00:01:27.547131
675	2026-01-05 16:00:00	7	22.11	220	5328.7	t	2026-05-08 00:01:27.547131
676	2026-01-05 16:30:00	1	13.88	220	3008.4	t	2026-05-08 00:01:27.547131
677	2026-01-05 16:30:00	4	21.8	220	3765.4	t	2026-05-08 00:01:27.547131
678	2026-01-05 16:30:00	7	28.92	220	5788	t	2026-05-08 00:01:27.547131
679	2026-01-05 17:00:00	1	15.55	220	4671.8	t	2026-05-08 00:01:27.547131
680	2026-01-05 17:00:00	4	24.38	220	4233.7	t	2026-05-08 00:01:27.547131
681	2026-01-05 17:00:00	7	26.06	220	6121	t	2026-05-08 00:01:27.547131
682	2026-01-05 17:30:00	1	20.81	220	3741.5	t	2026-05-08 00:01:27.547131
683	2026-01-05 17:30:00	4	16.5	220	5033.1	t	2026-05-08 00:01:27.547131
684	2026-01-05 17:30:00	7	23.83	220	6234.8	t	2026-05-08 00:01:27.547131
685	2026-01-05 18:00:00	1	13.53	220	4446.8	t	2026-05-08 00:01:27.547131
686	2026-01-05 18:00:00	4	20.09	220	5109.9	t	2026-05-08 00:01:27.547131
687	2026-01-05 18:00:00	7	21.9	220	6385.9	t	2026-05-08 00:01:27.547131
688	2026-01-05 18:30:00	1	15.25	220	2554.3	t	2026-05-08 00:01:27.547131
689	2026-01-05 18:30:00	4	19.38	220	3931.1	t	2026-05-08 00:01:27.547131
690	2026-01-05 18:30:00	7	28.74	220	6220.6	t	2026-05-08 00:01:27.547131
691	2026-01-05 19:00:00	1	19.73	220	2560.1	t	2026-05-08 00:01:27.547131
692	2026-01-05 19:00:00	4	24.81	220	4634.4	t	2026-05-08 00:01:27.547131
693	2026-01-05 19:00:00	7	21.98	220	6632	t	2026-05-08 00:01:27.547131
694	2026-01-05 19:30:00	1	12.61	220	4715.3	t	2026-05-08 00:01:27.547131
695	2026-01-05 19:30:00	4	20.67	220	3643.7	t	2026-05-08 00:01:27.547131
696	2026-01-05 19:30:00	7	28.46	220	5422.6	t	2026-05-08 00:01:27.547131
697	2026-01-05 20:00:00	1	2.8	220	776.4	t	2026-05-08 00:01:27.547131
698	2026-01-05 20:00:00	4	1.55	220	572.7	t	2026-05-08 00:01:27.547131
699	2026-01-05 20:00:00	7	3.32	220	694.2	t	2026-05-08 00:01:27.547131
700	2026-01-05 20:30:00	1	2.71	220	553.8	t	2026-05-08 00:01:27.547131
701	2026-01-05 20:30:00	4	3.01	220	269.7	t	2026-05-08 00:01:27.547131
702	2026-01-05 20:30:00	7	2.25	220	607.4	t	2026-05-08 00:01:27.547131
703	2026-01-05 21:00:00	1	3.5	220	717.1	t	2026-05-08 00:01:27.547131
704	2026-01-05 21:00:00	4	3.07	220	690.6	t	2026-05-08 00:01:27.547131
705	2026-01-05 21:00:00	7	3.06	220	782.8	t	2026-05-08 00:01:27.547131
706	2026-01-05 21:30:00	1	2.2	220	526.5	t	2026-05-08 00:01:27.547131
707	2026-01-05 21:30:00	4	1.6	220	774.1	t	2026-05-08 00:01:27.547131
708	2026-01-05 21:30:00	7	3.56	220	790.3	t	2026-05-08 00:01:27.547131
709	2026-01-05 22:00:00	1	1.65	220	485.9	t	2026-05-08 00:01:27.547131
710	2026-01-05 22:00:00	4	2.67	220	433.6	t	2026-05-08 00:01:27.547131
711	2026-01-05 22:00:00	7	1.31	220	308.5	t	2026-05-08 00:01:27.547131
712	2026-01-05 22:30:00	1	3.69	220	661.9	t	2026-05-08 00:01:27.547131
713	2026-01-05 22:30:00	4	3.2	220	369.5	t	2026-05-08 00:01:27.547131
714	2026-01-05 22:30:00	7	3.51	220	654	t	2026-05-08 00:01:27.547131
715	2026-01-05 23:00:00	1	1.5	220	702.5	t	2026-05-08 00:01:27.547131
716	2026-01-05 23:00:00	4	1.5	220	516	t	2026-05-08 00:01:27.547131
717	2026-01-05 23:00:00	7	1.4	220	366.3	t	2026-05-08 00:01:27.547131
718	2026-01-05 23:30:00	1	3.44	220	330.2	t	2026-05-08 00:01:27.547131
719	2026-01-05 23:30:00	4	2.11	220	749	t	2026-05-08 00:01:27.547131
720	2026-01-05 23:30:00	7	2.32	220	740.9	t	2026-05-08 00:01:27.547131
721	2026-01-06 00:00:00	1	2.94	220	466.3	t	2026-05-08 00:01:27.547131
722	2026-01-06 00:00:00	4	2.18	220	688.3	t	2026-05-08 00:01:27.547131
723	2026-01-06 00:00:00	7	2.62	220	291	t	2026-05-08 00:01:27.547131
724	2026-01-06 00:30:00	1	3.66	220	375.6	t	2026-05-08 00:01:27.547131
725	2026-01-06 00:30:00	4	2.77	220	647.1	t	2026-05-08 00:01:27.547131
726	2026-01-06 00:30:00	7	1.63	220	709.7	t	2026-05-08 00:01:27.547131
727	2026-01-06 01:00:00	1	2.22	220	548.6	t	2026-05-08 00:01:27.547131
728	2026-01-06 01:00:00	4	1.43	220	273.9	t	2026-05-08 00:01:27.547131
729	2026-01-06 01:00:00	7	2.84	220	280.7	t	2026-05-08 00:01:27.547131
730	2026-01-06 01:30:00	1	3.13	220	773.2	t	2026-05-08 00:01:27.547131
731	2026-01-06 01:30:00	4	2.45	220	345.5	t	2026-05-08 00:01:27.547131
732	2026-01-06 01:30:00	7	2.85	220	680	t	2026-05-08 00:01:27.547131
733	2026-01-06 02:00:00	1	2.02	220	566.4	t	2026-05-08 00:01:27.547131
734	2026-01-06 02:00:00	4	3.44	220	516.3	t	2026-05-08 00:01:27.547131
735	2026-01-06 02:00:00	7	3	220	641.2	t	2026-05-08 00:01:27.547131
736	2026-01-06 02:30:00	1	3.06	220	315.6	t	2026-05-08 00:01:27.547131
737	2026-01-06 02:30:00	4	3.12	220	461.4	t	2026-05-08 00:01:27.547131
738	2026-01-06 02:30:00	7	3.06	220	788.2	t	2026-05-08 00:01:27.547131
739	2026-01-06 03:00:00	1	1.37	220	608.4	t	2026-05-08 00:01:27.547131
740	2026-01-06 03:00:00	4	2.73	220	327.1	t	2026-05-08 00:01:27.547131
741	2026-01-06 03:00:00	7	1.9	220	555.9	t	2026-05-08 00:01:27.547131
742	2026-01-06 03:30:00	1	1.31	220	408.2	t	2026-05-08 00:01:27.547131
743	2026-01-06 03:30:00	4	1.33	220	458.7	t	2026-05-08 00:01:27.547131
744	2026-01-06 03:30:00	7	2.04	220	641.6	t	2026-05-08 00:01:27.547131
745	2026-01-06 04:00:00	1	2.96	220	343.6	t	2026-05-08 00:01:27.547131
746	2026-01-06 04:00:00	4	1.47	220	653.2	t	2026-05-08 00:01:27.547131
747	2026-01-06 04:00:00	7	3.13	220	448	t	2026-05-08 00:01:27.547131
748	2026-01-06 04:30:00	1	1.56	220	351	t	2026-05-08 00:01:27.547131
749	2026-01-06 04:30:00	4	2.82	220	416.8	t	2026-05-08 00:01:27.547131
750	2026-01-06 04:30:00	7	2.13	220	773	t	2026-05-08 00:01:27.547131
751	2026-01-06 05:00:00	1	2.01	220	290.2	t	2026-05-08 00:01:27.547131
752	2026-01-06 05:00:00	4	2.17	220	462.6	t	2026-05-08 00:01:27.547131
753	2026-01-06 05:00:00	7	3.64	220	758.9	t	2026-05-08 00:01:27.547131
754	2026-01-06 05:30:00	1	3.37	220	671	t	2026-05-08 00:01:27.547131
755	2026-01-06 05:30:00	4	3.09	220	687.6	t	2026-05-08 00:01:27.547131
756	2026-01-06 05:30:00	7	1.22	220	390.8	t	2026-05-08 00:01:27.547131
757	2026-01-06 06:00:00	1	2.71	220	387.9	t	2026-05-08 00:01:27.547131
758	2026-01-06 06:00:00	4	3.48	220	330.8	t	2026-05-08 00:01:27.547131
759	2026-01-06 06:00:00	7	2.17	220	308.5	t	2026-05-08 00:01:27.547131
760	2026-01-06 06:30:00	1	3.43	220	289.2	t	2026-05-08 00:01:27.547131
761	2026-01-06 06:30:00	4	3.52	220	515.4	t	2026-05-08 00:01:27.547131
762	2026-01-06 06:30:00	7	2.91	220	515.6	t	2026-05-08 00:01:27.547131
763	2026-01-06 07:00:00	1	16.16	220	3114.8	t	2026-05-08 00:01:27.547131
764	2026-01-06 07:00:00	4	25.08	220	3789	t	2026-05-08 00:01:27.547131
765	2026-01-06 07:00:00	7	22.4	220	5820.6	t	2026-05-08 00:01:27.547131
766	2026-01-06 07:30:00	1	11.71	220	4249.4	t	2026-05-08 00:01:27.547131
767	2026-01-06 07:30:00	4	20.79	220	4744.7	t	2026-05-08 00:01:27.547131
768	2026-01-06 07:30:00	7	24.28	220	4786.2	t	2026-05-08 00:01:27.547131
769	2026-01-06 08:00:00	1	20.32	220	4325.8	t	2026-05-08 00:01:27.547131
770	2026-01-06 08:00:00	4	21.19	220	3622.9	t	2026-05-08 00:01:27.547131
771	2026-01-06 08:00:00	7	24.59	220	6603.1	t	2026-05-08 00:01:27.547131
772	2026-01-06 08:30:00	1	20.68	220	3694.8	t	2026-05-08 00:01:27.547131
773	2026-01-06 08:30:00	4	24.15	220	4995.9	t	2026-05-08 00:01:27.547131
774	2026-01-06 08:30:00	7	21.49	220	6458.9	t	2026-05-08 00:01:27.547131
775	2026-01-06 09:00:00	1	14	220	3752.6	t	2026-05-08 00:01:27.547131
776	2026-01-06 09:00:00	4	17.48	220	3806.4	t	2026-05-08 00:01:27.547131
777	2026-01-06 09:00:00	7	28.81	220	5808.3	t	2026-05-08 00:01:27.547131
778	2026-01-06 09:30:00	1	17.35	220	4240.9	t	2026-05-08 00:01:27.547131
779	2026-01-06 09:30:00	4	19.83	220	4047.5	t	2026-05-08 00:01:27.547131
780	2026-01-06 09:30:00	7	21.37	220	5440.7	t	2026-05-08 00:01:27.547131
781	2026-01-06 10:00:00	1	16.14	220	3989.3	t	2026-05-08 00:01:27.547131
782	2026-01-06 10:00:00	4	19.16	220	4611.2	t	2026-05-08 00:01:27.547131
783	2026-01-06 10:00:00	7	21.07	220	4960.7	t	2026-05-08 00:01:27.547131
784	2026-01-06 10:30:00	1	11.85	220	2779.4	t	2026-05-08 00:01:27.547131
785	2026-01-06 10:30:00	4	22.13	220	5368.3	t	2026-05-08 00:01:27.547131
786	2026-01-06 10:30:00	7	23.81	220	5304.7	t	2026-05-08 00:01:27.547131
787	2026-01-06 11:00:00	1	16.2	220	4462.1	t	2026-05-08 00:01:27.547131
788	2026-01-06 11:00:00	4	22.41	220	3742.2	t	2026-05-08 00:01:27.547131
789	2026-01-06 11:00:00	7	23.84	220	5611.5	t	2026-05-08 00:01:27.547131
790	2026-01-06 11:30:00	1	12.61	220	3312.6	t	2026-05-08 00:01:27.547131
791	2026-01-06 11:30:00	4	23.87	220	4743.3	t	2026-05-08 00:01:27.547131
792	2026-01-06 11:30:00	7	20.83	220	5250.9	t	2026-05-08 00:01:27.547131
793	2026-01-06 12:00:00	1	12.18	220	4650.2	t	2026-05-08 00:01:27.547131
794	2026-01-06 12:00:00	4	17.16	220	5693.7	t	2026-05-08 00:01:27.547131
795	2026-01-06 12:00:00	7	27.99	220	5292.6	t	2026-05-08 00:01:27.547131
796	2026-01-06 12:30:00	1	13.13	220	3332.4	t	2026-05-08 00:01:27.547131
797	2026-01-06 12:30:00	4	25.1	220	3639.8	t	2026-05-08 00:01:27.547131
798	2026-01-06 12:30:00	7	26.62	220	5198.7	t	2026-05-08 00:01:27.547131
799	2026-01-06 13:00:00	1	12.63	220	4009	t	2026-05-08 00:01:27.547131
800	2026-01-06 13:00:00	4	16.79	220	4568.7	t	2026-05-08 00:01:27.547131
801	2026-01-06 13:00:00	7	21	220	4667.7	t	2026-05-08 00:01:27.547131
802	2026-01-06 13:30:00	1	19.34	220	3616.6	t	2026-05-08 00:01:27.547131
803	2026-01-06 13:30:00	4	23.17	220	4907.2	t	2026-05-08 00:01:27.547131
804	2026-01-06 13:30:00	7	26.02	220	5548.9	t	2026-05-08 00:01:27.547131
805	2026-01-06 14:00:00	1	12.21	220	4214.8	t	2026-05-08 00:01:27.547131
806	2026-01-06 14:00:00	4	18.78	220	3915.8	t	2026-05-08 00:01:27.547131
807	2026-01-06 14:00:00	7	21.56	220	6105.3	t	2026-05-08 00:01:27.547131
808	2026-01-06 14:30:00	1	18.4	220	4324.5	t	2026-05-08 00:01:27.547131
809	2026-01-06 14:30:00	4	17.89	220	3819.9	t	2026-05-08 00:01:27.547131
810	2026-01-06 14:30:00	7	24.67	220	6058.1	t	2026-05-08 00:01:27.547131
811	2026-01-06 15:00:00	1	12	220	3647.6	t	2026-05-08 00:01:27.547131
812	2026-01-06 15:00:00	4	22.07	220	3970.6	t	2026-05-08 00:01:27.547131
813	2026-01-06 15:00:00	7	28.46	220	5003.7	t	2026-05-08 00:01:27.547131
814	2026-01-06 15:30:00	1	18.54	220	3195.7	t	2026-05-08 00:01:27.547131
815	2026-01-06 15:30:00	4	23.41	220	5212.6	t	2026-05-08 00:01:27.547131
816	2026-01-06 15:30:00	7	26.1	220	6373.6	t	2026-05-08 00:01:27.547131
817	2026-01-06 16:00:00	1	19.08	220	4443.9	t	2026-05-08 00:01:27.547131
818	2026-01-06 16:00:00	4	23.32	220	5323.8	t	2026-05-08 00:01:27.547131
819	2026-01-06 16:00:00	7	24.84	220	5190.2	t	2026-05-08 00:01:27.547131
820	2026-01-06 16:30:00	1	17.36	220	2949.9	t	2026-05-08 00:01:27.547131
821	2026-01-06 16:30:00	4	21.61	220	4536	t	2026-05-08 00:01:27.547131
822	2026-01-06 16:30:00	7	21.99	220	5108.8	t	2026-05-08 00:01:27.547131
823	2026-01-06 17:00:00	1	20.8	220	3189.3	t	2026-05-08 00:01:27.547131
824	2026-01-06 17:00:00	4	16.11	220	5211.4	t	2026-05-08 00:01:27.547131
825	2026-01-06 17:00:00	7	29.44	220	6450.4	t	2026-05-08 00:01:27.547131
826	2026-01-06 17:30:00	1	17.48	220	3834.2	t	2026-05-08 00:01:27.547131
827	2026-01-06 17:30:00	4	21.25	220	4815.6	t	2026-05-08 00:01:27.547131
828	2026-01-06 17:30:00	7	22.8	220	6223.1	t	2026-05-08 00:01:27.547131
829	2026-01-06 18:00:00	1	14.83	220	4172.4	t	2026-05-08 00:01:27.547131
830	2026-01-06 18:00:00	4	24.94	220	4014.2	t	2026-05-08 00:01:27.547131
831	2026-01-06 18:00:00	7	27.9	220	5674.7	t	2026-05-08 00:01:27.547131
832	2026-01-06 18:30:00	1	16.11	220	3941.2	t	2026-05-08 00:01:27.547131
833	2026-01-06 18:30:00	4	17.3	220	4422.3	t	2026-05-08 00:01:27.547131
834	2026-01-06 18:30:00	7	21.6	220	5850.3	t	2026-05-08 00:01:27.547131
835	2026-01-06 19:00:00	1	20.06	220	2645.5	t	2026-05-08 00:01:27.547131
836	2026-01-06 19:00:00	4	19.86	220	3847.1	t	2026-05-08 00:01:27.547131
837	2026-01-06 19:00:00	7	27.62	220	5382.5	t	2026-05-08 00:01:27.547131
838	2026-01-06 19:30:00	1	12.53	220	2861.3	t	2026-05-08 00:01:27.547131
839	2026-01-06 19:30:00	4	23.28	220	4358	t	2026-05-08 00:01:27.547131
840	2026-01-06 19:30:00	7	23.87	220	5105.3	t	2026-05-08 00:01:27.547131
841	2026-01-06 20:00:00	1	2.88	220	265.1	t	2026-05-08 00:01:27.547131
842	2026-01-06 20:00:00	4	3.2	220	355.9	t	2026-05-08 00:01:27.547131
843	2026-01-06 20:00:00	7	1.52	220	589.6	t	2026-05-08 00:01:27.547131
844	2026-01-06 20:30:00	1	3.38	220	629.3	t	2026-05-08 00:01:27.547131
845	2026-01-06 20:30:00	4	3.43	220	809.4	t	2026-05-08 00:01:27.547131
846	2026-01-06 20:30:00	7	2.36	220	264.4	t	2026-05-08 00:01:27.547131
847	2026-01-06 21:00:00	1	2.49	220	728.2	t	2026-05-08 00:01:27.547131
848	2026-01-06 21:00:00	4	2.08	220	656.6	t	2026-05-08 00:01:27.547131
849	2026-01-06 21:00:00	7	2.68	220	410.4	t	2026-05-08 00:01:27.547131
850	2026-01-06 21:30:00	1	1.81	220	497.5	t	2026-05-08 00:01:27.547131
851	2026-01-06 21:30:00	4	3.68	220	793.6	t	2026-05-08 00:01:27.547131
852	2026-01-06 21:30:00	7	2.78	220	726.8	t	2026-05-08 00:01:27.547131
853	2026-01-06 22:00:00	1	2.39	220	297.5	t	2026-05-08 00:01:27.547131
854	2026-01-06 22:00:00	4	1.41	220	524.2	t	2026-05-08 00:01:27.547131
855	2026-01-06 22:00:00	7	2.68	220	404.3	t	2026-05-08 00:01:27.547131
856	2026-01-06 22:30:00	1	1.29	220	374.7	t	2026-05-08 00:01:27.547131
857	2026-01-06 22:30:00	4	2.66	220	703.4	t	2026-05-08 00:01:27.547131
858	2026-01-06 22:30:00	7	3.17	220	279.4	t	2026-05-08 00:01:27.547131
859	2026-01-06 23:00:00	1	2.59	220	447.2	t	2026-05-08 00:01:27.547131
860	2026-01-06 23:00:00	4	1.38	220	380.3	t	2026-05-08 00:01:27.547131
861	2026-01-06 23:00:00	7	1.64	220	536.3	t	2026-05-08 00:01:27.547131
862	2026-01-06 23:30:00	1	2.13	220	468.2	t	2026-05-08 00:01:27.547131
863	2026-01-06 23:30:00	4	2.99	220	293.4	t	2026-05-08 00:01:27.547131
864	2026-01-06 23:30:00	7	1.44	220	538.2	t	2026-05-08 00:01:27.547131
865	2026-01-07 00:00:00	1	2.21	220	282	t	2026-05-08 00:01:27.547131
866	2026-01-07 00:00:00	4	1.35	220	293.5	t	2026-05-08 00:01:27.547131
867	2026-01-07 00:00:00	7	1.44	220	810.1	t	2026-05-08 00:01:27.547131
868	2026-01-07 00:30:00	1	2.71	220	568.5	t	2026-05-08 00:01:27.547131
869	2026-01-07 00:30:00	4	1.65	220	423.3	t	2026-05-08 00:01:27.547131
870	2026-01-07 00:30:00	7	3.39	220	443	t	2026-05-08 00:01:27.547131
871	2026-01-07 01:00:00	1	3.18	220	785	t	2026-05-08 00:01:27.547131
872	2026-01-07 01:00:00	4	2.76	220	304.2	t	2026-05-08 00:01:27.547131
873	2026-01-07 01:00:00	7	1.44	220	286.9	t	2026-05-08 00:01:27.547131
874	2026-01-07 01:30:00	1	2.82	220	741.1	t	2026-05-08 00:01:27.547131
875	2026-01-07 01:30:00	4	2.68	220	366	t	2026-05-08 00:01:27.547131
876	2026-01-07 01:30:00	7	2.22	220	296.8	t	2026-05-08 00:01:27.547131
877	2026-01-07 02:00:00	1	2.33	220	520	t	2026-05-08 00:01:27.547131
878	2026-01-07 02:00:00	4	2.76	220	329.2	t	2026-05-08 00:01:27.547131
879	2026-01-07 02:00:00	7	1.63	220	778.2	t	2026-05-08 00:01:27.547131
880	2026-01-07 02:30:00	1	1.99	220	571.8	t	2026-05-08 00:01:27.547131
881	2026-01-07 02:30:00	4	3	220	454.4	t	2026-05-08 00:01:27.547131
882	2026-01-07 02:30:00	7	3.05	220	694.8	t	2026-05-08 00:01:27.547131
883	2026-01-07 03:00:00	1	3.12	220	611.7	t	2026-05-08 00:01:27.547131
884	2026-01-07 03:00:00	4	3.51	220	324.4	t	2026-05-08 00:01:27.547131
885	2026-01-07 03:00:00	7	2.71	220	555	t	2026-05-08 00:01:27.547131
886	2026-01-07 03:30:00	1	2.4	220	635.1	t	2026-05-08 00:01:27.547131
887	2026-01-07 03:30:00	4	3.55	220	636.2	t	2026-05-08 00:01:27.547131
888	2026-01-07 03:30:00	7	2.96	220	345.4	t	2026-05-08 00:01:27.547131
889	2026-01-07 04:00:00	1	3.55	220	410.7	t	2026-05-08 00:01:27.547131
890	2026-01-07 04:00:00	4	1.8	220	498.2	t	2026-05-08 00:01:27.547131
891	2026-01-07 04:00:00	7	2.3	220	509.3	t	2026-05-08 00:01:27.547131
892	2026-01-07 04:30:00	1	3.51	220	760.1	t	2026-05-08 00:01:27.547131
893	2026-01-07 04:30:00	4	3.58	220	408.9	t	2026-05-08 00:01:27.547131
894	2026-01-07 04:30:00	7	3.7	220	661.5	t	2026-05-08 00:01:27.547131
895	2026-01-07 05:00:00	1	1.37	220	312	t	2026-05-08 00:01:27.547131
896	2026-01-07 05:00:00	4	3.54	220	554.5	t	2026-05-08 00:01:27.547131
897	2026-01-07 05:00:00	7	3.51	220	755.7	t	2026-05-08 00:01:27.547131
898	2026-01-07 05:30:00	1	1.87	220	709.4	t	2026-05-08 00:01:27.547131
899	2026-01-07 05:30:00	4	2.45	220	710.3	t	2026-05-08 00:01:27.547131
900	2026-01-07 05:30:00	7	3.37	220	381.2	t	2026-05-08 00:01:27.547131
901	2026-01-07 06:00:00	1	2.93	220	735.9	t	2026-05-08 00:01:27.547131
902	2026-01-07 06:00:00	4	3.07	220	684.8	t	2026-05-08 00:01:27.547131
903	2026-01-07 06:00:00	7	3.06	220	801.5	t	2026-05-08 00:01:27.547131
904	2026-01-07 06:30:00	1	2.52	220	628.5	t	2026-05-08 00:01:27.547131
905	2026-01-07 06:30:00	4	3.2	220	766.8	t	2026-05-08 00:01:27.547131
906	2026-01-07 06:30:00	7	2.29	220	644.9	t	2026-05-08 00:01:27.547131
907	2026-01-07 07:00:00	1	14.49	220	2873.8	t	2026-05-08 00:01:27.547131
908	2026-01-07 07:00:00	4	16.2	220	5113.3	t	2026-05-08 00:01:27.547131
909	2026-01-07 07:00:00	7	22.92	220	6047.8	t	2026-05-08 00:01:27.547131
910	2026-01-07 07:30:00	1	21.33	220	4455.4	t	2026-05-08 00:01:27.547131
911	2026-01-07 07:30:00	4	19.75	220	3560.2	t	2026-05-08 00:01:27.547131
912	2026-01-07 07:30:00	7	29.1	220	6037.5	t	2026-05-08 00:01:27.547131
913	2026-01-07 08:00:00	1	15.21	220	3111.4	t	2026-05-08 00:01:27.547131
914	2026-01-07 08:00:00	4	21.88	220	4921.9	t	2026-05-08 00:01:27.547131
915	2026-01-07 08:00:00	7	27.33	220	6025.6	t	2026-05-08 00:01:27.547131
916	2026-01-07 08:30:00	1	13.22	220	2783.7	t	2026-05-08 00:01:27.547131
917	2026-01-07 08:30:00	4	24.53	220	3946.3	t	2026-05-08 00:01:27.547131
918	2026-01-07 08:30:00	7	24.81	220	5031.1	t	2026-05-08 00:01:27.547131
919	2026-01-07 09:00:00	1	12.32	220	3586.1	t	2026-05-08 00:01:27.547131
920	2026-01-07 09:00:00	4	20.16	220	5702	t	2026-05-08 00:01:27.547131
921	2026-01-07 09:00:00	7	27.1	220	5396.1	t	2026-05-08 00:01:27.547131
922	2026-01-07 09:30:00	1	19.33	220	2782.4	t	2026-05-08 00:01:27.547131
923	2026-01-07 09:30:00	4	22.74	220	4494.1	t	2026-05-08 00:01:27.547131
924	2026-01-07 09:30:00	7	27	220	4947.7	t	2026-05-08 00:01:27.547131
925	2026-01-07 10:00:00	1	17.41	220	3786.4	t	2026-05-08 00:01:27.547131
926	2026-01-07 10:00:00	4	23.06	220	4542.9	t	2026-05-08 00:01:27.547131
927	2026-01-07 10:00:00	7	27.35	220	6672.8	t	2026-05-08 00:01:27.547131
928	2026-01-07 10:30:00	1	19.31	220	3985.6	t	2026-05-08 00:01:27.547131
929	2026-01-07 10:30:00	4	20.07	220	4189.1	t	2026-05-08 00:01:27.547131
930	2026-01-07 10:30:00	7	24.42	220	6356.4	t	2026-05-08 00:01:27.547131
931	2026-01-07 11:00:00	1	17.9	220	4622.2	t	2026-05-08 00:01:27.547131
932	2026-01-07 11:00:00	4	18.21	220	5575.7	t	2026-05-08 00:01:27.547131
933	2026-01-07 11:00:00	7	25.75	220	5760.8	t	2026-05-08 00:01:27.547131
934	2026-01-07 11:30:00	1	16.94	220	3400.8	t	2026-05-08 00:01:27.547131
935	2026-01-07 11:30:00	4	25.57	220	5130.6	t	2026-05-08 00:01:27.547131
936	2026-01-07 11:30:00	7	22.96	220	5142.7	t	2026-05-08 00:01:27.547131
937	2026-01-07 12:00:00	1	13.26	220	3890.9	t	2026-05-08 00:01:27.547131
938	2026-01-07 12:00:00	4	22.76	220	4692	t	2026-05-08 00:01:27.547131
939	2026-01-07 12:00:00	7	28.54	220	5396.9	t	2026-05-08 00:01:27.547131
940	2026-01-07 12:30:00	1	16.44	220	3915.8	t	2026-05-08 00:01:27.547131
941	2026-01-07 12:30:00	4	24.12	220	4350.4	t	2026-05-08 00:01:27.547131
942	2026-01-07 12:30:00	7	20.74	220	4889.9	t	2026-05-08 00:01:27.547131
943	2026-01-07 13:00:00	1	13.96	220	3952.5	t	2026-05-08 00:01:27.547131
944	2026-01-07 13:00:00	4	24.64	220	4571.7	t	2026-05-08 00:01:27.547131
945	2026-01-07 13:00:00	7	29.11	220	5153.5	t	2026-05-08 00:01:27.547131
946	2026-01-07 13:30:00	1	16.96	220	4120.2	t	2026-05-08 00:01:27.547131
947	2026-01-07 13:30:00	4	16.2	220	3986	t	2026-05-08 00:01:27.547131
948	2026-01-07 13:30:00	7	27.22	220	6466.1	t	2026-05-08 00:01:27.547131
949	2026-01-07 14:00:00	1	18.93	220	4728.2	t	2026-05-08 00:01:27.547131
950	2026-01-07 14:00:00	4	23.75	220	3800.6	t	2026-05-08 00:01:27.547131
951	2026-01-07 14:00:00	7	20.87	220	6137	t	2026-05-08 00:01:27.547131
952	2026-01-07 14:30:00	1	13.36	220	3339.7	t	2026-05-08 00:01:27.547131
953	2026-01-07 14:30:00	4	22.25	220	5058.7	t	2026-05-08 00:01:27.547131
954	2026-01-07 14:30:00	7	29.7	220	5452	t	2026-05-08 00:01:27.547131
955	2026-01-07 15:00:00	1	19.8	220	4392	t	2026-05-08 00:01:27.547131
956	2026-01-07 15:00:00	4	23.75	220	4233.6	t	2026-05-08 00:01:27.547131
957	2026-01-07 15:00:00	7	25.72	220	6555.7	t	2026-05-08 00:01:27.547131
958	2026-01-07 15:30:00	1	16.43	220	2673.4	t	2026-05-08 00:01:27.547131
959	2026-01-07 15:30:00	4	23.48	220	5072.3	t	2026-05-08 00:01:27.547131
960	2026-01-07 15:30:00	7	23.08	220	5389.2	t	2026-05-08 00:01:27.547131
961	2026-01-07 16:00:00	1	14.03	220	3574.4	t	2026-05-08 00:01:27.547131
962	2026-01-07 16:00:00	4	22.65	220	3982.1	t	2026-05-08 00:01:27.547131
963	2026-01-07 16:00:00	7	24.35	220	5141.4	t	2026-05-08 00:01:27.547131
964	2026-01-07 16:30:00	1	21.06	220	3593.7	t	2026-05-08 00:01:27.547131
965	2026-01-07 16:30:00	4	25.53	220	5248.4	t	2026-05-08 00:01:27.547131
966	2026-01-07 16:30:00	7	29.83	220	5489.6	t	2026-05-08 00:01:27.547131
967	2026-01-07 17:00:00	1	18.11	220	3098.5	t	2026-05-08 00:01:27.547131
968	2026-01-07 17:00:00	4	18.76	220	3558.7	t	2026-05-08 00:01:27.547131
969	2026-01-07 17:00:00	7	24.7	220	6246.7	t	2026-05-08 00:01:27.547131
970	2026-01-07 17:30:00	1	11.95	220	3605.1	t	2026-05-08 00:01:27.547131
971	2026-01-07 17:30:00	4	16.83	220	4241.3	t	2026-05-08 00:01:27.547131
972	2026-01-07 17:30:00	7	21.69	220	5781.8	t	2026-05-08 00:01:27.547131
973	2026-01-07 18:00:00	1	13.78	220	3806.2	t	2026-05-08 00:01:27.547131
974	2026-01-07 18:00:00	4	21.6	220	4779	t	2026-05-08 00:01:27.547131
975	2026-01-07 18:00:00	7	28.94	220	5088.8	t	2026-05-08 00:01:27.547131
976	2026-01-07 18:30:00	1	19.18	220	3004.3	t	2026-05-08 00:01:27.547131
977	2026-01-07 18:30:00	4	18.79	220	5387.3	t	2026-05-08 00:01:27.547131
978	2026-01-07 18:30:00	7	27.82	220	5039.9	t	2026-05-08 00:01:27.547131
979	2026-01-07 19:00:00	1	21.37	220	3445.1	t	2026-05-08 00:01:27.547131
980	2026-01-07 19:00:00	4	20.7	220	3925.2	t	2026-05-08 00:01:27.547131
981	2026-01-07 19:00:00	7	28.01	220	5145	t	2026-05-08 00:01:27.547131
982	2026-01-07 19:30:00	1	16.13	220	4284.7	t	2026-05-08 00:01:27.547131
983	2026-01-07 19:30:00	4	22.31	220	4250.3	t	2026-05-08 00:01:27.547131
984	2026-01-07 19:30:00	7	23.34	220	6629.8	t	2026-05-08 00:01:27.547131
985	2026-01-07 20:00:00	1	2.63	220	351.5	t	2026-05-08 00:01:27.547131
986	2026-01-07 20:00:00	4	2.95	220	676.6	t	2026-05-08 00:01:27.547131
987	2026-01-07 20:00:00	7	1.22	220	755.3	t	2026-05-08 00:01:27.547131
988	2026-01-07 20:30:00	1	2.79	220	313.4	t	2026-05-08 00:01:27.547131
989	2026-01-07 20:30:00	4	1.79	220	644.7	t	2026-05-08 00:01:27.547131
990	2026-01-07 20:30:00	7	2.92	220	291.5	t	2026-05-08 00:01:27.547131
991	2026-01-07 21:00:00	1	2.92	220	499.2	t	2026-05-08 00:01:27.547131
992	2026-01-07 21:00:00	4	2.52	220	364.2	t	2026-05-08 00:01:27.547131
993	2026-01-07 21:00:00	7	1.52	220	805.1	t	2026-05-08 00:01:27.547131
994	2026-01-07 21:30:00	1	3.07	220	440.3	t	2026-05-08 00:01:27.547131
995	2026-01-07 21:30:00	4	1.31	220	737.6	t	2026-05-08 00:01:27.547131
996	2026-01-07 21:30:00	7	2.21	220	769.4	t	2026-05-08 00:01:27.547131
997	2026-01-07 22:00:00	1	2.1	220	602	t	2026-05-08 00:01:27.547131
998	2026-01-07 22:00:00	4	2.01	220	599	t	2026-05-08 00:01:27.547131
999	2026-01-07 22:00:00	7	2.65	220	799.7	t	2026-05-08 00:01:27.547131
1000	2026-01-07 22:30:00	1	1.28	220	495.6	t	2026-05-08 00:01:27.547131
1001	2026-01-07 22:30:00	4	3.16	220	344.4	t	2026-05-08 00:01:27.547131
1002	2026-01-07 22:30:00	7	1.23	220	755.3	t	2026-05-08 00:01:27.547131
1003	2026-01-07 23:00:00	1	3.59	220	661.7	t	2026-05-08 00:01:27.547131
1004	2026-01-07 23:00:00	4	1.29	220	552.5	t	2026-05-08 00:01:27.547131
1005	2026-01-07 23:00:00	7	2.84	220	518.7	t	2026-05-08 00:01:27.547131
1006	2026-01-07 23:30:00	1	3.34	220	391	t	2026-05-08 00:01:27.547131
1007	2026-01-07 23:30:00	4	3.09	220	764.1	t	2026-05-08 00:01:27.547131
1008	2026-01-07 23:30:00	7	1.52	220	813	t	2026-05-08 00:01:27.547131
1009	2026-01-08 00:00:00	1	3.57	220	304.6	t	2026-05-08 00:01:27.547131
1010	2026-01-08 00:00:00	4	2.84	220	628.9	t	2026-05-08 00:01:27.547131
1011	2026-01-08 00:00:00	7	1.94	220	308.9	t	2026-05-08 00:01:27.547131
1012	2026-01-08 00:30:00	1	2.47	220	419	t	2026-05-08 00:01:27.547131
1013	2026-01-08 00:30:00	4	2.64	220	717.6	t	2026-05-08 00:01:27.547131
1014	2026-01-08 00:30:00	7	1.67	220	797.4	t	2026-05-08 00:01:27.547131
1015	2026-01-08 01:00:00	1	3.41	220	312.8	t	2026-05-08 00:01:27.547131
1016	2026-01-08 01:00:00	4	3.17	220	663.2	t	2026-05-08 00:01:27.547131
1017	2026-01-08 01:00:00	7	1.54	220	429.9	t	2026-05-08 00:01:27.547131
1018	2026-01-08 01:30:00	1	3.26	220	280.3	t	2026-05-08 00:01:27.547131
1019	2026-01-08 01:30:00	4	2.34	220	362.7	t	2026-05-08 00:01:27.547131
1020	2026-01-08 01:30:00	7	3.3	220	307.5	t	2026-05-08 00:01:27.547131
1021	2026-01-08 02:00:00	1	1.21	220	522.4	t	2026-05-08 00:01:27.547131
1022	2026-01-08 02:00:00	4	2.22	220	316.4	t	2026-05-08 00:01:27.547131
1023	2026-01-08 02:00:00	7	3.58	220	609.1	t	2026-05-08 00:01:27.547131
1024	2026-01-08 02:30:00	1	2.6	220	390	t	2026-05-08 00:01:27.547131
1025	2026-01-08 02:30:00	4	2.83	220	604.5	t	2026-05-08 00:01:27.547131
1026	2026-01-08 02:30:00	7	2.56	220	792.9	t	2026-05-08 00:01:27.547131
1027	2026-01-08 03:00:00	1	3.69	220	367.9	t	2026-05-08 00:01:27.547131
1028	2026-01-08 03:00:00	4	3.17	220	273	t	2026-05-08 00:01:27.547131
1029	2026-01-08 03:00:00	7	1.7	220	447.1	t	2026-05-08 00:01:27.547131
1030	2026-01-08 03:30:00	1	1.71	220	282.9	t	2026-05-08 00:01:27.547131
1031	2026-01-08 03:30:00	4	3.62	220	607.1	t	2026-05-08 00:01:27.547131
1032	2026-01-08 03:30:00	7	1.43	220	284.6	t	2026-05-08 00:01:27.547131
1033	2026-01-08 04:00:00	1	3.03	220	708.9	t	2026-05-08 00:01:27.547131
1034	2026-01-08 04:00:00	4	1.66	220	702.6	t	2026-05-08 00:01:27.547131
1035	2026-01-08 04:00:00	7	2.34	220	663	t	2026-05-08 00:01:27.547131
1036	2026-01-08 04:30:00	1	2.83	220	771.3	t	2026-05-08 00:01:27.547131
1037	2026-01-08 04:30:00	4	2.49	220	812.2	t	2026-05-08 00:01:27.547131
1038	2026-01-08 04:30:00	7	3.46	220	297	t	2026-05-08 00:01:27.547131
1039	2026-01-08 05:00:00	1	2.11	220	794.8	t	2026-05-08 00:01:27.547131
1040	2026-01-08 05:00:00	4	2.52	220	637	t	2026-05-08 00:01:27.547131
1041	2026-01-08 05:00:00	7	2.12	220	703.5	t	2026-05-08 00:01:27.547131
1042	2026-01-08 05:30:00	1	1.42	220	560.1	t	2026-05-08 00:01:27.547131
1043	2026-01-08 05:30:00	4	3.53	220	546.8	t	2026-05-08 00:01:27.547131
1044	2026-01-08 05:30:00	7	3.42	220	311.5	t	2026-05-08 00:01:27.547131
1045	2026-01-08 06:00:00	1	1.72	220	681.6	t	2026-05-08 00:01:27.547131
1046	2026-01-08 06:00:00	4	1.48	220	573.5	t	2026-05-08 00:01:27.547131
1047	2026-01-08 06:00:00	7	1.38	220	776.7	t	2026-05-08 00:01:27.547131
1048	2026-01-08 06:30:00	1	1.79	220	472.3	t	2026-05-08 00:01:27.547131
1049	2026-01-08 06:30:00	4	2.53	220	474.3	t	2026-05-08 00:01:27.547131
1050	2026-01-08 06:30:00	7	1.49	220	270.6	t	2026-05-08 00:01:27.547131
1051	2026-01-08 07:00:00	1	12.95	220	3694.4	t	2026-05-08 00:01:27.547131
1052	2026-01-08 07:00:00	4	23.27	220	5322.8	t	2026-05-08 00:01:27.547131
1053	2026-01-08 07:00:00	7	25.21	220	5961.5	t	2026-05-08 00:01:27.547131
1054	2026-01-08 07:30:00	1	20.55	220	4478.4	t	2026-05-08 00:01:27.547131
1055	2026-01-08 07:30:00	4	22.22	220	4176.5	t	2026-05-08 00:01:27.547131
1056	2026-01-08 07:30:00	7	26.12	220	4582.6	t	2026-05-08 00:01:27.547131
1057	2026-01-08 08:00:00	1	14.93	220	4057.7	t	2026-05-08 00:01:27.547131
1058	2026-01-08 08:00:00	4	18.22	220	4810.4	t	2026-05-08 00:01:27.547131
1059	2026-01-08 08:00:00	7	26.7	220	5030.2	t	2026-05-08 00:01:27.547131
1060	2026-01-08 08:30:00	1	11.56	220	2731	t	2026-05-08 00:01:27.547131
1061	2026-01-08 08:30:00	4	21.81	220	5383	t	2026-05-08 00:01:27.547131
1062	2026-01-08 08:30:00	7	23.57	220	6452.3	t	2026-05-08 00:01:27.547131
1063	2026-01-08 09:00:00	1	17.15	220	3144	t	2026-05-08 00:01:27.547131
1064	2026-01-08 09:00:00	4	17.6	220	4581	t	2026-05-08 00:01:27.547131
1065	2026-01-08 09:00:00	7	28.35	220	5926.5	t	2026-05-08 00:01:27.547131
1066	2026-01-08 09:30:00	1	11.83	220	3613.5	t	2026-05-08 00:01:27.547131
1067	2026-01-08 09:30:00	4	25.59	220	4935.1	t	2026-05-08 00:01:27.547131
1068	2026-01-08 09:30:00	7	30.37	220	4775	t	2026-05-08 00:01:27.547131
1069	2026-01-08 10:00:00	1	18.5	220	4249.6	t	2026-05-08 00:01:27.547131
1070	2026-01-08 10:00:00	4	25.05	220	5080.7	t	2026-05-08 00:01:27.547131
1071	2026-01-08 10:00:00	7	30.1	220	4576.4	t	2026-05-08 00:01:27.547131
1072	2026-01-08 10:30:00	1	16.84	220	4012.3	t	2026-05-08 00:01:27.547131
1073	2026-01-08 10:30:00	4	18.82	220	3794.9	t	2026-05-08 00:01:27.547131
1074	2026-01-08 10:30:00	7	29.85	220	5223.3	t	2026-05-08 00:01:27.547131
1075	2026-01-08 11:00:00	1	11.5	220	3934.7	t	2026-05-08 00:01:27.547131
1076	2026-01-08 11:00:00	4	19.65	220	4304.6	t	2026-05-08 00:01:27.547131
1077	2026-01-08 11:00:00	7	27.61	220	5002.5	t	2026-05-08 00:01:27.547131
1078	2026-01-08 11:30:00	1	17.39	220	3057.7	t	2026-05-08 00:01:27.547131
1079	2026-01-08 11:30:00	4	17.19	220	4179.3	t	2026-05-08 00:01:27.547131
1080	2026-01-08 11:30:00	7	22.93	220	5938.9	t	2026-05-08 00:01:27.547131
1081	2026-01-08 12:00:00	1	16.96	220	3549.6	t	2026-05-08 00:01:27.547131
1082	2026-01-08 12:00:00	4	23.82	220	5162.7	t	2026-05-08 00:01:27.547131
1083	2026-01-08 12:00:00	7	21.19	220	4581.4	t	2026-05-08 00:01:27.547131
1084	2026-01-08 12:30:00	1	15.94	220	3614.2	t	2026-05-08 00:01:27.547131
1085	2026-01-08 12:30:00	4	21.66	220	5139.5	t	2026-05-08 00:01:27.547131
1086	2026-01-08 12:30:00	7	24.07	220	4884.9	t	2026-05-08 00:01:27.547131
1087	2026-01-08 13:00:00	1	20.67	220	4427.8	t	2026-05-08 00:01:27.547131
1088	2026-01-08 13:00:00	4	17.61	220	4216.5	t	2026-05-08 00:01:27.547131
1089	2026-01-08 13:00:00	7	28.69	220	6089.2	t	2026-05-08 00:01:27.547131
1090	2026-01-08 13:30:00	1	13.38	220	3151.8	t	2026-05-08 00:01:27.547131
1091	2026-01-08 13:30:00	4	16.07	220	5456	t	2026-05-08 00:01:27.547131
1092	2026-01-08 13:30:00	7	23.35	220	6129.4	t	2026-05-08 00:01:27.547131
1093	2026-01-08 14:00:00	1	18.03	220	4241.5	t	2026-05-08 00:01:27.547131
1094	2026-01-08 14:00:00	4	18	220	4886.9	t	2026-05-08 00:01:27.547131
1095	2026-01-08 14:00:00	7	26.53	220	4609.9	t	2026-05-08 00:01:27.547131
1096	2026-01-08 14:30:00	1	19.07	220	3946.4	t	2026-05-08 00:01:27.547131
1097	2026-01-08 14:30:00	4	16.91	220	3870.4	t	2026-05-08 00:01:27.547131
1098	2026-01-08 14:30:00	7	20.58	220	5252.7	t	2026-05-08 00:01:27.547131
1099	2026-01-08 15:00:00	1	12.91	220	3350.7	t	2026-05-08 00:01:27.547131
1100	2026-01-08 15:00:00	4	16.97	220	3974.4	t	2026-05-08 00:01:27.547131
1101	2026-01-08 15:00:00	7	22.53	220	5536.9	t	2026-05-08 00:01:27.547131
1102	2026-01-08 15:30:00	1	20.26	220	4427.2	t	2026-05-08 00:01:27.547131
1103	2026-01-08 15:30:00	4	17.32	220	4313.3	t	2026-05-08 00:01:27.547131
1104	2026-01-08 15:30:00	7	23.2	220	5300	t	2026-05-08 00:01:27.547131
1105	2026-01-08 16:00:00	1	13.25	220	2738	t	2026-05-08 00:01:27.547131
1106	2026-01-08 16:00:00	4	20.82	220	5002.3	t	2026-05-08 00:01:27.547131
1107	2026-01-08 16:00:00	7	28.28	220	4667.7	t	2026-05-08 00:01:27.547131
1108	2026-01-08 16:30:00	1	19.24	220	2618.5	t	2026-05-08 00:01:27.547131
1109	2026-01-08 16:30:00	4	17.62	220	4036.2	t	2026-05-08 00:01:27.547131
1110	2026-01-08 16:30:00	7	30	220	4635.9	t	2026-05-08 00:01:27.547131
1111	2026-01-08 17:00:00	1	20.29	220	3942	t	2026-05-08 00:01:27.547131
1112	2026-01-08 17:00:00	4	16.65	220	5538.9	t	2026-05-08 00:01:27.547131
1113	2026-01-08 17:00:00	7	24.5	220	5726.8	t	2026-05-08 00:01:27.547131
1114	2026-01-08 17:30:00	1	18.61	220	3362.4	t	2026-05-08 00:01:27.547131
1115	2026-01-08 17:30:00	4	23.6	220	5166.7	t	2026-05-08 00:01:27.547131
1116	2026-01-08 17:30:00	7	28.34	220	5705.1	t	2026-05-08 00:01:27.547131
1117	2026-01-08 18:00:00	1	13.32	220	2767.3	t	2026-05-08 00:01:27.547131
1118	2026-01-08 18:00:00	4	18.68	220	4285	t	2026-05-08 00:01:27.547131
1119	2026-01-08 18:00:00	7	26.61	220	5183.8	t	2026-05-08 00:01:27.547131
1120	2026-01-08 18:30:00	1	18.97	220	4556.9	t	2026-05-08 00:01:27.547131
1121	2026-01-08 18:30:00	4	24.86	220	4372.5	t	2026-05-08 00:01:27.547131
1122	2026-01-08 18:30:00	7	24.85	220	5059.1	t	2026-05-08 00:01:27.547131
1123	2026-01-08 19:00:00	1	21.16	220	3306.8	t	2026-05-08 00:01:27.547131
1124	2026-01-08 19:00:00	4	17.34	220	5073	t	2026-05-08 00:01:27.547131
1125	2026-01-08 19:00:00	7	23.76	220	6185.3	t	2026-05-08 00:01:27.547131
1126	2026-01-08 19:30:00	1	14.06	220	3302.7	t	2026-05-08 00:01:27.547131
1127	2026-01-08 19:30:00	4	17.1	220	3881.8	t	2026-05-08 00:01:27.547131
1128	2026-01-08 19:30:00	7	23.03	220	5357.4	t	2026-05-08 00:01:27.547131
1129	2026-01-08 20:00:00	1	2.96	220	308.9	t	2026-05-08 00:01:27.547131
1130	2026-01-08 20:00:00	4	2.45	220	764.1	t	2026-05-08 00:01:27.547131
1131	2026-01-08 20:00:00	7	2.66	220	489.2	t	2026-05-08 00:01:27.547131
1132	2026-01-08 20:30:00	1	2.92	220	760.7	t	2026-05-08 00:01:27.547131
1133	2026-01-08 20:30:00	4	3.1	220	329.8	t	2026-05-08 00:01:27.547131
1134	2026-01-08 20:30:00	7	3.03	220	640.8	t	2026-05-08 00:01:27.547131
1135	2026-01-08 21:00:00	1	2.84	220	496.6	t	2026-05-08 00:01:27.547131
1136	2026-01-08 21:00:00	4	3.47	220	551.4	t	2026-05-08 00:01:27.547131
1137	2026-01-08 21:00:00	7	3.69	220	313.9	t	2026-05-08 00:01:27.547131
1138	2026-01-08 21:30:00	1	3.33	220	475.2	t	2026-05-08 00:01:27.547131
1139	2026-01-08 21:30:00	4	3.11	220	449.7	t	2026-05-08 00:01:27.547131
1140	2026-01-08 21:30:00	7	2.81	220	660.9	t	2026-05-08 00:01:27.547131
1141	2026-01-08 22:00:00	1	3.44	220	431.4	t	2026-05-08 00:01:27.547131
1142	2026-01-08 22:00:00	4	1.23	220	735.1	t	2026-05-08 00:01:27.547131
1143	2026-01-08 22:00:00	7	3.44	220	332.4	t	2026-05-08 00:01:27.547131
1144	2026-01-08 22:30:00	1	3.47	220	743.2	t	2026-05-08 00:01:27.547131
1145	2026-01-08 22:30:00	4	3.08	220	792.8	t	2026-05-08 00:01:27.547131
1146	2026-01-08 22:30:00	7	3.6	220	722.3	t	2026-05-08 00:01:27.547131
1147	2026-01-08 23:00:00	1	3.15	220	402.5	t	2026-05-08 00:01:27.547131
1148	2026-01-08 23:00:00	4	1.68	220	455.5	t	2026-05-08 00:01:27.547131
1149	2026-01-08 23:00:00	7	3.17	220	749	t	2026-05-08 00:01:27.547131
1150	2026-01-08 23:30:00	1	2.56	220	682	t	2026-05-08 00:01:27.547131
1151	2026-01-08 23:30:00	4	3.4	220	769	t	2026-05-08 00:01:27.547131
1152	2026-01-08 23:30:00	7	2.23	220	338.4	t	2026-05-08 00:01:27.547131
1153	2026-01-09 00:00:00	1	3.37	220	643.9	t	2026-05-08 00:01:27.547131
1154	2026-01-09 00:00:00	4	3.42	220	473.4	t	2026-05-08 00:01:27.547131
1155	2026-01-09 00:00:00	7	1.63	220	347.8	t	2026-05-08 00:01:27.547131
1156	2026-01-09 00:30:00	1	2.5	220	367.4	t	2026-05-08 00:01:27.547131
1157	2026-01-09 00:30:00	4	1.31	220	700.2	t	2026-05-08 00:01:27.547131
1158	2026-01-09 00:30:00	7	3.08	220	749	t	2026-05-08 00:01:27.547131
1159	2026-01-09 01:00:00	1	1.37	220	591.4	t	2026-05-08 00:01:27.547131
1160	2026-01-09 01:00:00	4	1.67	220	276.4	t	2026-05-08 00:01:27.547131
1161	2026-01-09 01:00:00	7	3.1	220	508.6	t	2026-05-08 00:01:27.547131
1162	2026-01-09 01:30:00	1	1.69	220	712.6	t	2026-05-08 00:01:27.547131
1163	2026-01-09 01:30:00	4	3.06	220	395.7	t	2026-05-08 00:01:27.547131
1164	2026-01-09 01:30:00	7	3.65	220	759.3	t	2026-05-08 00:01:27.547131
1165	2026-01-09 02:00:00	1	2.16	220	386.8	t	2026-05-08 00:01:27.547131
1166	2026-01-09 02:00:00	4	3.21	220	462.7	t	2026-05-08 00:01:27.547131
1167	2026-01-09 02:00:00	7	2.53	220	614.4	t	2026-05-08 00:01:27.547131
1168	2026-01-09 02:30:00	1	2.47	220	804.2	t	2026-05-08 00:01:27.547131
1169	2026-01-09 02:30:00	4	3.02	220	375.2	t	2026-05-08 00:01:27.547131
1170	2026-01-09 02:30:00	7	2.04	220	756.1	t	2026-05-08 00:01:27.547131
1171	2026-01-09 03:00:00	1	3.63	220	276.4	t	2026-05-08 00:01:27.547131
1172	2026-01-09 03:00:00	4	1.38	220	628.5	t	2026-05-08 00:01:27.547131
1173	2026-01-09 03:00:00	7	2.35	220	266.4	t	2026-05-08 00:01:27.547131
1174	2026-01-09 03:30:00	1	1.66	220	348.3	t	2026-05-08 00:01:27.547131
1175	2026-01-09 03:30:00	4	3.39	220	579.2	t	2026-05-08 00:01:27.547131
1176	2026-01-09 03:30:00	7	1.32	220	502.4	t	2026-05-08 00:01:27.547131
1177	2026-01-09 04:00:00	1	1.45	220	387.6	t	2026-05-08 00:01:27.547131
1178	2026-01-09 04:00:00	4	1.51	220	683.6	t	2026-05-08 00:01:27.547131
1179	2026-01-09 04:00:00	7	2.51	220	525.9	t	2026-05-08 00:01:27.547131
1180	2026-01-09 04:30:00	1	1.56	220	433.3	t	2026-05-08 00:01:27.547131
1181	2026-01-09 04:30:00	4	1.35	220	473.4	t	2026-05-08 00:01:27.547131
1182	2026-01-09 04:30:00	7	2.32	220	589.8	t	2026-05-08 00:01:27.547131
1183	2026-01-09 05:00:00	1	1.26	220	517.7	t	2026-05-08 00:01:27.547131
1184	2026-01-09 05:00:00	4	1.71	220	675.2	t	2026-05-08 00:01:27.547131
1185	2026-01-09 05:00:00	7	3.53	220	442.8	t	2026-05-08 00:01:27.547131
1186	2026-01-09 05:30:00	1	2.04	220	731.3	t	2026-05-08 00:01:27.547131
1187	2026-01-09 05:30:00	4	3.17	220	285.9	t	2026-05-08 00:01:27.547131
1188	2026-01-09 05:30:00	7	2.37	220	396.9	t	2026-05-08 00:01:27.547131
1189	2026-01-09 06:00:00	1	1.92	220	593.8	t	2026-05-08 00:01:27.547131
1190	2026-01-09 06:00:00	4	3.32	220	433.4	t	2026-05-08 00:01:27.547131
1191	2026-01-09 06:00:00	7	3.52	220	643.5	t	2026-05-08 00:01:27.547131
1192	2026-01-09 06:30:00	1	2.88	220	648.4	t	2026-05-08 00:01:27.547131
1193	2026-01-09 06:30:00	4	3.4	220	288.7	t	2026-05-08 00:01:27.547131
1194	2026-01-09 06:30:00	7	1.34	220	682.3	t	2026-05-08 00:01:27.547131
1195	2026-01-09 07:00:00	1	17.59	220	2705.7	t	2026-05-08 00:01:27.547131
1196	2026-01-09 07:00:00	4	22.66	220	4444	t	2026-05-08 00:01:27.547131
1197	2026-01-09 07:00:00	7	30.25	220	5240.7	t	2026-05-08 00:01:27.547131
1198	2026-01-09 07:30:00	1	12.16	220	4297.2	t	2026-05-08 00:01:27.547131
1199	2026-01-09 07:30:00	4	23.8	220	3915.1	t	2026-05-08 00:01:27.547131
1200	2026-01-09 07:30:00	7	28.71	220	5450.4	t	2026-05-08 00:01:27.547131
1201	2026-01-09 08:00:00	1	16.59	220	4390.3	t	2026-05-08 00:01:27.547131
1202	2026-01-09 08:00:00	4	23.84	220	3965.4	t	2026-05-08 00:01:27.547131
1203	2026-01-09 08:00:00	7	22.17	220	4743.4	t	2026-05-08 00:01:27.547131
1204	2026-01-09 08:30:00	1	16.52	220	4123.8	t	2026-05-08 00:01:27.547131
1205	2026-01-09 08:30:00	4	20.26	220	3721.9	t	2026-05-08 00:01:27.547131
1206	2026-01-09 08:30:00	7	22.2	220	5542.1	t	2026-05-08 00:01:27.547131
1207	2026-01-09 09:00:00	1	17.01	220	4160.3	t	2026-05-08 00:01:27.547131
1208	2026-01-09 09:00:00	4	17.39	220	3816.1	t	2026-05-08 00:01:27.547131
1209	2026-01-09 09:00:00	7	23.67	220	4955.7	t	2026-05-08 00:01:27.547131
1210	2026-01-09 09:30:00	1	18.24	220	3741.6	t	2026-05-08 00:01:27.547131
1211	2026-01-09 09:30:00	4	23.27	220	3925.6	t	2026-05-08 00:01:27.547131
1212	2026-01-09 09:30:00	7	24.22	220	5393.8	t	2026-05-08 00:01:27.547131
1213	2026-01-09 10:00:00	1	21.5	220	2729.1	t	2026-05-08 00:01:27.547131
1214	2026-01-09 10:00:00	4	16.74	220	3655.2	t	2026-05-08 00:01:27.547131
1215	2026-01-09 10:00:00	7	27.57	220	5229.3	t	2026-05-08 00:01:27.547131
1216	2026-01-09 10:30:00	1	20.56	220	3673	t	2026-05-08 00:01:27.547131
1217	2026-01-09 10:30:00	4	20.42	220	4474.2	t	2026-05-08 00:01:27.547131
1218	2026-01-09 10:30:00	7	25.25	220	5479.1	t	2026-05-08 00:01:27.547131
1219	2026-01-09 11:00:00	1	20.06	220	3777	t	2026-05-08 00:01:27.547131
1220	2026-01-09 11:00:00	4	21.15	220	3982	t	2026-05-08 00:01:27.547131
1221	2026-01-09 11:00:00	7	23.48	220	5186.2	t	2026-05-08 00:01:27.547131
1222	2026-01-09 11:30:00	1	14.81	220	2719.4	t	2026-05-08 00:01:27.547131
1223	2026-01-09 11:30:00	4	17.16	220	4313.6	t	2026-05-08 00:01:27.547131
1224	2026-01-09 11:30:00	7	20.7	220	6391.2	t	2026-05-08 00:01:27.547131
1225	2026-01-09 12:00:00	1	20.84	220	2817.1	t	2026-05-08 00:01:27.547131
1226	2026-01-09 12:00:00	4	20.36	220	4312.7	t	2026-05-08 00:01:27.547131
1227	2026-01-09 12:00:00	7	28.63	220	5264.3	t	2026-05-08 00:01:27.547131
1228	2026-01-09 12:30:00	1	12.24	220	2550.4	t	2026-05-08 00:01:27.547131
1229	2026-01-09 12:30:00	4	22.81	220	4017	t	2026-05-08 00:01:27.547131
1230	2026-01-09 12:30:00	7	20.51	220	6122.6	t	2026-05-08 00:01:27.547131
1231	2026-01-09 13:00:00	1	20.48	220	4545.5	t	2026-05-08 00:01:27.547131
1232	2026-01-09 13:00:00	4	22.12	220	4876.2	t	2026-05-08 00:01:27.547131
1233	2026-01-09 13:00:00	7	26.43	220	5300.1	t	2026-05-08 00:01:27.547131
1234	2026-01-09 13:30:00	1	16.84	220	3293	t	2026-05-08 00:01:27.547131
1235	2026-01-09 13:30:00	4	23.75	220	4837	t	2026-05-08 00:01:27.547131
1236	2026-01-09 13:30:00	7	21.71	220	4898.8	t	2026-05-08 00:01:27.547131
1237	2026-01-09 14:00:00	1	18.81	220	3396.8	t	2026-05-08 00:01:27.547131
1238	2026-01-09 14:00:00	4	21.83	220	3821.6	t	2026-05-08 00:01:27.547131
1239	2026-01-09 14:00:00	7	25.01	220	5213.9	t	2026-05-08 00:01:27.547131
1240	2026-01-09 14:30:00	1	14.7	220	2819.2	t	2026-05-08 00:01:27.547131
1241	2026-01-09 14:30:00	4	21.4	220	4017.1	t	2026-05-08 00:01:27.547131
1242	2026-01-09 14:30:00	7	25.46	220	4991.3	t	2026-05-08 00:01:27.547131
1243	2026-01-09 15:00:00	1	13.09	220	4658.9	t	2026-05-08 00:01:27.547131
1244	2026-01-09 15:00:00	4	17.75	220	5295.5	t	2026-05-08 00:01:27.547131
1245	2026-01-09 15:00:00	7	25.14	220	6455.8	t	2026-05-08 00:01:27.547131
1246	2026-01-09 15:30:00	1	11.55	220	4316.2	t	2026-05-08 00:01:27.547131
1247	2026-01-09 15:30:00	4	18.5	220	4702.4	t	2026-05-08 00:01:27.547131
1248	2026-01-09 15:30:00	7	24.4	220	6114.7	t	2026-05-08 00:01:27.547131
1249	2026-01-09 16:00:00	1	11.99	220	3801	t	2026-05-08 00:01:27.547131
1250	2026-01-09 16:00:00	4	22.67	220	5021.8	t	2026-05-08 00:01:27.547131
1251	2026-01-09 16:00:00	7	29.45	220	5022.1	t	2026-05-08 00:01:27.547131
1252	2026-01-09 16:30:00	1	12.92	220	3230.8	t	2026-05-08 00:01:27.547131
1253	2026-01-09 16:30:00	4	24.61	220	4940.4	t	2026-05-08 00:01:27.547131
1254	2026-01-09 16:30:00	7	24.39	220	5546.4	t	2026-05-08 00:01:27.547131
1255	2026-01-09 17:00:00	1	15.21	220	3188.7	t	2026-05-08 00:01:27.547131
1256	2026-01-09 17:00:00	4	25.79	220	3850.3	t	2026-05-08 00:01:27.547131
1257	2026-01-09 17:00:00	7	30.08	220	5662.6	t	2026-05-08 00:01:27.547131
1258	2026-01-09 17:30:00	1	21.15	220	4139.7	t	2026-05-08 00:01:27.547131
1259	2026-01-09 17:30:00	4	17.9	220	3528.8	t	2026-05-08 00:01:27.547131
1260	2026-01-09 17:30:00	7	25.36	220	4992.5	t	2026-05-08 00:01:27.547131
1261	2026-01-09 18:00:00	1	20.18	220	3414.8	t	2026-05-08 00:01:27.547131
1262	2026-01-09 18:00:00	4	18.96	220	3776.6	t	2026-05-08 00:01:27.547131
1263	2026-01-09 18:00:00	7	28.9	220	5704.3	t	2026-05-08 00:01:27.547131
1264	2026-01-09 18:30:00	1	15.4	220	3192.1	t	2026-05-08 00:01:27.547131
1265	2026-01-09 18:30:00	4	22	220	4471.2	t	2026-05-08 00:01:27.547131
1266	2026-01-09 18:30:00	7	26.79	220	5097.5	t	2026-05-08 00:01:27.547131
1267	2026-01-09 19:00:00	1	17	220	3369.4	t	2026-05-08 00:01:27.547131
1268	2026-01-09 19:00:00	4	25.76	220	4564	t	2026-05-08 00:01:27.547131
1269	2026-01-09 19:00:00	7	26.19	220	5426.9	t	2026-05-08 00:01:27.547131
1270	2026-01-09 19:30:00	1	15.37	220	3604.2	t	2026-05-08 00:01:27.547131
1271	2026-01-09 19:30:00	4	17.57	220	3716.4	t	2026-05-08 00:01:27.547131
1272	2026-01-09 19:30:00	7	21.54	220	6617.4	t	2026-05-08 00:01:27.547131
1273	2026-01-09 20:00:00	1	2.85	220	333.3	t	2026-05-08 00:01:27.547131
1274	2026-01-09 20:00:00	4	3.32	220	715	t	2026-05-08 00:01:27.547131
1275	2026-01-09 20:00:00	7	1.43	220	334.3	t	2026-05-08 00:01:27.547131
1276	2026-01-09 20:30:00	1	3.02	220	401	t	2026-05-08 00:01:27.547131
1277	2026-01-09 20:30:00	4	1.2	220	323	t	2026-05-08 00:01:27.547131
1278	2026-01-09 20:30:00	7	1.36	220	501.3	t	2026-05-08 00:01:27.547131
1279	2026-01-09 21:00:00	1	3	220	796.6	t	2026-05-08 00:01:27.547131
1280	2026-01-09 21:00:00	4	2.06	220	311.4	t	2026-05-08 00:01:27.547131
1281	2026-01-09 21:00:00	7	1.47	220	588	t	2026-05-08 00:01:27.547131
1282	2026-01-09 21:30:00	1	1.94	220	479.3	t	2026-05-08 00:01:27.547131
1283	2026-01-09 21:30:00	4	1.69	220	536.1	t	2026-05-08 00:01:27.547131
1284	2026-01-09 21:30:00	7	3.04	220	754.1	t	2026-05-08 00:01:27.547131
1285	2026-01-09 22:00:00	1	2.42	220	391.5	t	2026-05-08 00:01:27.547131
1286	2026-01-09 22:00:00	4	2.95	220	377.8	t	2026-05-08 00:01:27.547131
1287	2026-01-09 22:00:00	7	1.87	220	470.4	t	2026-05-08 00:01:27.547131
1288	2026-01-09 22:30:00	1	3.31	220	378.1	t	2026-05-08 00:01:27.547131
1289	2026-01-09 22:30:00	4	1.4	220	573.6	t	2026-05-08 00:01:27.547131
1290	2026-01-09 22:30:00	7	3.43	220	669.8	t	2026-05-08 00:01:27.547131
1291	2026-01-09 23:00:00	1	1.73	220	374.7	t	2026-05-08 00:01:27.547131
1292	2026-01-09 23:00:00	4	3.57	220	495	t	2026-05-08 00:01:27.547131
1293	2026-01-09 23:00:00	7	3.1	220	696.7	t	2026-05-08 00:01:27.547131
1294	2026-01-09 23:30:00	1	2.46	220	412.6	t	2026-05-08 00:01:27.547131
1295	2026-01-09 23:30:00	4	1.85	220	775.3	t	2026-05-08 00:01:27.547131
1296	2026-01-09 23:30:00	7	2.43	220	280.5	t	2026-05-08 00:01:27.547131
1297	2026-01-10 00:00:00	1	2.46	220	476.6	t	2026-05-08 00:01:27.547131
1298	2026-01-10 00:00:00	4	2.46	220	511.2	t	2026-05-08 00:01:27.547131
1299	2026-01-10 00:00:00	7	2.88	220	426.5	t	2026-05-08 00:01:27.547131
1300	2026-01-10 00:30:00	1	2.72	220	590.7	t	2026-05-08 00:01:27.547131
1301	2026-01-10 00:30:00	4	2.24	220	541.2	t	2026-05-08 00:01:27.547131
1302	2026-01-10 00:30:00	7	1.87	220	262.4	t	2026-05-08 00:01:27.547131
1303	2026-01-10 01:00:00	1	2.76	220	412.3	t	2026-05-08 00:01:27.547131
1304	2026-01-10 01:00:00	4	1.56	220	632.8	t	2026-05-08 00:01:27.547131
1305	2026-01-10 01:00:00	7	1.11	220	286.3	t	2026-05-08 00:01:27.547131
1306	2026-01-10 01:30:00	1	1.01	220	572.2	t	2026-05-08 00:01:27.547131
1307	2026-01-10 01:30:00	4	1.26	220	318	t	2026-05-08 00:01:27.547131
1308	2026-01-10 01:30:00	7	1.12	220	283.5	t	2026-05-08 00:01:27.547131
1309	2026-01-10 02:00:00	1	1.39	220	526.2	t	2026-05-08 00:01:27.547131
1310	2026-01-10 02:00:00	4	1.93	220	301.4	t	2026-05-08 00:01:27.547131
1311	2026-01-10 02:00:00	7	2.52	220	580.8	t	2026-05-08 00:01:27.547131
1312	2026-01-10 02:30:00	1	2.29	220	576.2	t	2026-05-08 00:01:27.547131
1313	2026-01-10 02:30:00	4	1.04	220	591.8	t	2026-05-08 00:01:27.547131
1314	2026-01-10 02:30:00	7	1.89	220	466.8	t	2026-05-08 00:01:27.547131
1315	2026-01-10 03:00:00	1	2.32	220	629.1	t	2026-05-08 00:01:27.547131
1316	2026-01-10 03:00:00	4	1.83	220	635	t	2026-05-08 00:01:27.547131
1317	2026-01-10 03:00:00	7	2.49	220	414	t	2026-05-08 00:01:27.547131
1318	2026-01-10 03:30:00	1	2.8	220	346.5	t	2026-05-08 00:01:27.547131
1319	2026-01-10 03:30:00	4	2.31	220	385.9	t	2026-05-08 00:01:27.547131
1320	2026-01-10 03:30:00	7	2.07	220	286.1	t	2026-05-08 00:01:27.547131
1321	2026-01-10 04:00:00	1	1.74	220	500.3	t	2026-05-08 00:01:27.547131
1322	2026-01-10 04:00:00	4	2.9	220	452.2	t	2026-05-08 00:01:27.547131
1323	2026-01-10 04:00:00	7	2.2	220	223.4	t	2026-05-08 00:01:27.547131
1324	2026-01-10 04:30:00	1	2.24	220	321.8	t	2026-05-08 00:01:27.547131
1325	2026-01-10 04:30:00	4	2.47	220	421.6	t	2026-05-08 00:01:27.547131
1326	2026-01-10 04:30:00	7	2.16	220	507.5	t	2026-05-08 00:01:27.547131
1327	2026-01-10 05:00:00	1	2.93	220	586.6	t	2026-05-08 00:01:27.547131
1328	2026-01-10 05:00:00	4	2.88	220	640.4	t	2026-05-08 00:01:27.547131
1329	2026-01-10 05:00:00	7	1.88	220	525.7	t	2026-05-08 00:01:27.547131
1330	2026-01-10 05:30:00	1	1.15	220	389.4	t	2026-05-08 00:01:27.547131
1331	2026-01-10 05:30:00	4	2.39	220	571.2	t	2026-05-08 00:01:27.547131
1332	2026-01-10 05:30:00	7	1.92	220	459.3	t	2026-05-08 00:01:27.547131
1333	2026-01-10 06:00:00	1	2.82	220	245.6	t	2026-05-08 00:01:27.547131
1334	2026-01-10 06:00:00	4	1.47	220	553.4	t	2026-05-08 00:01:27.547131
1335	2026-01-10 06:00:00	7	1.74	220	531.8	t	2026-05-08 00:01:27.547131
1336	2026-01-10 06:30:00	1	1.76	220	450.9	t	2026-05-08 00:01:27.547131
1337	2026-01-10 06:30:00	4	1.19	220	498.8	t	2026-05-08 00:01:27.547131
1338	2026-01-10 06:30:00	7	2.5	220	571.6	t	2026-05-08 00:01:27.547131
1339	2026-01-10 07:00:00	1	1.56	220	270.4	t	2026-05-08 00:01:27.547131
1340	2026-01-10 07:00:00	4	1.96	220	306.6	t	2026-05-08 00:01:27.547131
1341	2026-01-10 07:00:00	7	2.43	220	420.1	t	2026-05-08 00:01:27.547131
1342	2026-01-10 07:30:00	1	1.5	220	635.7	t	2026-05-08 00:01:27.547131
1343	2026-01-10 07:30:00	4	2.84	220	460.1	t	2026-05-08 00:01:27.547131
1344	2026-01-10 07:30:00	7	2.31	220	622.8	t	2026-05-08 00:01:27.547131
1345	2026-01-10 08:00:00	1	2.04	220	379	t	2026-05-08 00:01:27.547131
1346	2026-01-10 08:00:00	4	2.3	220	341.2	t	2026-05-08 00:01:27.547131
1347	2026-01-10 08:00:00	7	1.32	220	588.1	t	2026-05-08 00:01:27.547131
1348	2026-01-10 08:30:00	1	2.74	220	644.8	t	2026-05-08 00:01:27.547131
1349	2026-01-10 08:30:00	4	1.39	220	615.1	t	2026-05-08 00:01:27.547131
1350	2026-01-10 08:30:00	7	2.94	220	598.6	t	2026-05-08 00:01:27.547131
1351	2026-01-10 09:00:00	1	2.56	220	636.8	t	2026-05-08 00:01:27.547131
1352	2026-01-10 09:00:00	4	1.57	220	578.2	t	2026-05-08 00:01:27.547131
1353	2026-01-10 09:00:00	7	2.46	220	513	t	2026-05-08 00:01:27.547131
1354	2026-01-10 09:30:00	1	2.08	220	521.8	t	2026-05-08 00:01:27.547131
1355	2026-01-10 09:30:00	4	2.97	220	498.8	t	2026-05-08 00:01:27.547131
1356	2026-01-10 09:30:00	7	1.66	220	459.2	t	2026-05-08 00:01:27.547131
1357	2026-01-10 10:00:00	1	1.89	220	638.4	t	2026-05-08 00:01:27.547131
1358	2026-01-10 10:00:00	4	2.32	220	420.2	t	2026-05-08 00:01:27.547131
1359	2026-01-10 10:00:00	7	1.97	220	301.5	t	2026-05-08 00:01:27.547131
1360	2026-01-10 10:30:00	1	1.08	220	520.3	t	2026-05-08 00:01:27.547131
1361	2026-01-10 10:30:00	4	1.7	220	407.1	t	2026-05-08 00:01:27.547131
1362	2026-01-10 10:30:00	7	1.78	220	600.5	t	2026-05-08 00:01:27.547131
1363	2026-01-10 11:00:00	1	2.43	220	328.6	t	2026-05-08 00:01:27.547131
1364	2026-01-10 11:00:00	4	2.31	220	453.5	t	2026-05-08 00:01:27.547131
1365	2026-01-10 11:00:00	7	2.73	220	431	t	2026-05-08 00:01:27.547131
1366	2026-01-10 11:30:00	1	1.09	220	645.3	t	2026-05-08 00:01:27.547131
1367	2026-01-10 11:30:00	4	2.75	220	610.2	t	2026-05-08 00:01:27.547131
1368	2026-01-10 11:30:00	7	2.29	220	528.7	t	2026-05-08 00:01:27.547131
1369	2026-01-10 12:00:00	1	2.95	220	342.6	t	2026-05-08 00:01:27.547131
1370	2026-01-10 12:00:00	4	1.61	220	245.8	t	2026-05-08 00:01:27.547131
1371	2026-01-10 12:00:00	7	1.82	220	355.1	t	2026-05-08 00:01:27.547131
1372	2026-01-10 12:30:00	1	1.95	220	534.8	t	2026-05-08 00:01:27.547131
1373	2026-01-10 12:30:00	4	1.56	220	595.6	t	2026-05-08 00:01:27.547131
1374	2026-01-10 12:30:00	7	2.11	220	636.2	t	2026-05-08 00:01:27.547131
1375	2026-01-10 13:00:00	1	2.84	220	597.7	t	2026-05-08 00:01:27.547131
1376	2026-01-10 13:00:00	4	1.96	220	450.2	t	2026-05-08 00:01:27.547131
1377	2026-01-10 13:00:00	7	1.16	220	491.3	t	2026-05-08 00:01:27.547131
1378	2026-01-10 13:30:00	1	1.41	220	599.5	t	2026-05-08 00:01:27.547131
1379	2026-01-10 13:30:00	4	2.72	220	313.8	t	2026-05-08 00:01:27.547131
1380	2026-01-10 13:30:00	7	2.4	220	606.1	t	2026-05-08 00:01:27.547131
1381	2026-01-10 14:00:00	1	2.82	220	284.3	t	2026-05-08 00:01:27.547131
1382	2026-01-10 14:00:00	4	2.98	220	270.7	t	2026-05-08 00:01:27.547131
1383	2026-01-10 14:00:00	7	1.47	220	469.4	t	2026-05-08 00:01:27.547131
1384	2026-01-10 14:30:00	1	2.89	220	370.4	t	2026-05-08 00:01:27.547131
1385	2026-01-10 14:30:00	4	2.48	220	501.2	t	2026-05-08 00:01:27.547131
1386	2026-01-10 14:30:00	7	1.89	220	269.9	t	2026-05-08 00:01:27.547131
1387	2026-01-10 15:00:00	1	2.94	220	266.3	t	2026-05-08 00:01:27.547131
1388	2026-01-10 15:00:00	4	2.63	220	600.1	t	2026-05-08 00:01:27.547131
1389	2026-01-10 15:00:00	7	2.01	220	347.1	t	2026-05-08 00:01:27.547131
1390	2026-01-10 15:30:00	1	2.78	220	463.4	t	2026-05-08 00:01:27.547131
1391	2026-01-10 15:30:00	4	2.73	220	304.1	t	2026-05-08 00:01:27.547131
1392	2026-01-10 15:30:00	7	1.29	220	582.7	t	2026-05-08 00:01:27.547131
1393	2026-01-10 16:00:00	1	1.36	220	229.9	t	2026-05-08 00:01:27.547131
1394	2026-01-10 16:00:00	4	1.32	220	657.7	t	2026-05-08 00:01:27.547131
1395	2026-01-10 16:00:00	7	1.11	220	568	t	2026-05-08 00:01:27.547131
1396	2026-01-10 16:30:00	1	1.67	220	654.9	t	2026-05-08 00:01:27.547131
1397	2026-01-10 16:30:00	4	2.38	220	588.5	t	2026-05-08 00:01:27.547131
1398	2026-01-10 16:30:00	7	1.41	220	629.6	t	2026-05-08 00:01:27.547131
1399	2026-01-10 17:00:00	1	1.53	220	280.9	t	2026-05-08 00:01:27.547131
1400	2026-01-10 17:00:00	4	1.4	220	474.8	t	2026-05-08 00:01:27.547131
1401	2026-01-10 17:00:00	7	1.76	220	439.4	t	2026-05-08 00:01:27.547131
1402	2026-01-10 17:30:00	1	1.22	220	282.4	t	2026-05-08 00:01:27.547131
1403	2026-01-10 17:30:00	4	2.56	220	433.5	t	2026-05-08 00:01:27.547131
1404	2026-01-10 17:30:00	7	1.05	220	627.5	t	2026-05-08 00:01:27.547131
1405	2026-01-10 18:00:00	1	2.72	220	604	t	2026-05-08 00:01:27.547131
1406	2026-01-10 18:00:00	4	1.12	220	384.8	t	2026-05-08 00:01:27.547131
1407	2026-01-10 18:00:00	7	1.4	220	521	t	2026-05-08 00:01:27.547131
1408	2026-01-10 18:30:00	1	1.94	220	590.6	t	2026-05-08 00:01:27.547131
1409	2026-01-10 18:30:00	4	2.01	220	649.5	t	2026-05-08 00:01:27.547131
1410	2026-01-10 18:30:00	7	1.51	220	610.9	t	2026-05-08 00:01:27.547131
1411	2026-01-10 19:00:00	1	1.54	220	301.8	t	2026-05-08 00:01:27.547131
1412	2026-01-10 19:00:00	4	1.61	220	376.1	t	2026-05-08 00:01:27.547131
1413	2026-01-10 19:00:00	7	2.74	220	592.2	t	2026-05-08 00:01:27.547131
1414	2026-01-10 19:30:00	1	2.73	220	574.7	t	2026-05-08 00:01:27.547131
1415	2026-01-10 19:30:00	4	1.4	220	467.3	t	2026-05-08 00:01:27.547131
1416	2026-01-10 19:30:00	7	2.43	220	486.6	t	2026-05-08 00:01:27.547131
1417	2026-01-10 20:00:00	1	1.36	220	496.7	t	2026-05-08 00:01:27.547131
1418	2026-01-10 20:00:00	4	2.48	220	470.3	t	2026-05-08 00:01:27.547131
1419	2026-01-10 20:00:00	7	1.82	220	501.8	t	2026-05-08 00:01:27.547131
1420	2026-01-10 20:30:00	1	1.26	220	342.5	t	2026-05-08 00:01:27.547131
1421	2026-01-10 20:30:00	4	2.89	220	401.5	t	2026-05-08 00:01:27.547131
1422	2026-01-10 20:30:00	7	1.59	220	516.6	t	2026-05-08 00:01:27.547131
1423	2026-01-10 21:00:00	1	2.67	220	510.3	t	2026-05-08 00:01:27.547131
1424	2026-01-10 21:00:00	4	2.17	220	286.5	t	2026-05-08 00:01:27.547131
1425	2026-01-10 21:00:00	7	2.55	220	484.4	t	2026-05-08 00:01:27.547131
1426	2026-01-10 21:30:00	1	1.88	220	524.1	t	2026-05-08 00:01:27.547131
1427	2026-01-10 21:30:00	4	1.21	220	625.5	t	2026-05-08 00:01:27.547131
1428	2026-01-10 21:30:00	7	1.77	220	486.4	t	2026-05-08 00:01:27.547131
1429	2026-01-10 22:00:00	1	2.75	220	256	t	2026-05-08 00:01:27.547131
1430	2026-01-10 22:00:00	4	1.07	220	458.3	t	2026-05-08 00:01:27.547131
1431	2026-01-10 22:00:00	7	1.49	220	263.1	t	2026-05-08 00:01:27.547131
1432	2026-01-10 22:30:00	1	2.86	220	341.2	t	2026-05-08 00:01:27.547131
1433	2026-01-10 22:30:00	4	1.27	220	396	t	2026-05-08 00:01:27.547131
1434	2026-01-10 22:30:00	7	2.91	220	538.2	t	2026-05-08 00:01:27.547131
1435	2026-01-10 23:00:00	1	2.92	220	569.4	t	2026-05-08 00:01:27.547131
1436	2026-01-10 23:00:00	4	2.37	220	254.8	t	2026-05-08 00:01:27.547131
1437	2026-01-10 23:00:00	7	1.56	220	378.8	t	2026-05-08 00:01:27.547131
1438	2026-01-10 23:30:00	1	1.96	220	582.7	t	2026-05-08 00:01:27.547131
1439	2026-01-10 23:30:00	4	2.65	220	618.9	t	2026-05-08 00:01:27.547131
1440	2026-01-10 23:30:00	7	2.11	220	588.3	t	2026-05-08 00:01:27.547131
1441	2026-01-11 00:00:00	1	1.94	220	444.7	t	2026-05-08 00:01:27.547131
1442	2026-01-11 00:00:00	4	1.45	220	302.1	t	2026-05-08 00:01:27.547131
1443	2026-01-11 00:00:00	7	1.32	220	371.9	t	2026-05-08 00:01:27.547131
1444	2026-01-11 00:30:00	1	1.92	220	580.7	t	2026-05-08 00:01:27.547131
1445	2026-01-11 00:30:00	4	2.29	220	554	t	2026-05-08 00:01:27.547131
1446	2026-01-11 00:30:00	7	1.88	220	578.5	t	2026-05-08 00:01:27.547131
1447	2026-01-11 01:00:00	1	1.19	220	516.7	t	2026-05-08 00:01:27.547131
1448	2026-01-11 01:00:00	4	2.41	220	477.7	t	2026-05-08 00:01:27.547131
1449	2026-01-11 01:00:00	7	2.73	220	353.4	t	2026-05-08 00:01:27.547131
1450	2026-01-11 01:30:00	1	1.57	220	373.9	t	2026-05-08 00:01:27.547131
1451	2026-01-11 01:30:00	4	1.81	220	286	t	2026-05-08 00:01:27.547131
1452	2026-01-11 01:30:00	7	1.18	220	236	t	2026-05-08 00:01:27.547131
1453	2026-01-11 02:00:00	1	1.69	220	650.9	t	2026-05-08 00:01:27.547131
1454	2026-01-11 02:00:00	4	1.38	220	530.7	t	2026-05-08 00:01:27.547131
1455	2026-01-11 02:00:00	7	1.16	220	405.1	t	2026-05-08 00:01:27.547131
1456	2026-01-11 02:30:00	1	2.01	220	376.5	t	2026-05-08 00:01:27.547131
1457	2026-01-11 02:30:00	4	2.14	220	290.3	t	2026-05-08 00:01:27.547131
1458	2026-01-11 02:30:00	7	1.3	220	318.4	t	2026-05-08 00:01:27.547131
1459	2026-01-11 03:00:00	1	2.76	220	287.3	t	2026-05-08 00:01:27.547131
1460	2026-01-11 03:00:00	4	2.91	220	630.8	t	2026-05-08 00:01:27.547131
1461	2026-01-11 03:00:00	7	2.27	220	623	t	2026-05-08 00:01:27.547131
1462	2026-01-11 03:30:00	1	2.14	220	467.4	t	2026-05-08 00:01:27.547131
1463	2026-01-11 03:30:00	4	1.05	220	529	t	2026-05-08 00:01:27.547131
1464	2026-01-11 03:30:00	7	2.91	220	615	t	2026-05-08 00:01:27.547131
1465	2026-01-11 04:00:00	1	2.35	220	526.4	t	2026-05-08 00:01:27.547131
1466	2026-01-11 04:00:00	4	1.19	220	363.3	t	2026-05-08 00:01:27.547131
1467	2026-01-11 04:00:00	7	1.35	220	590.6	t	2026-05-08 00:01:27.547131
1468	2026-01-11 04:30:00	1	1.66	220	521.1	t	2026-05-08 00:01:27.547131
1469	2026-01-11 04:30:00	4	2.64	220	513.9	t	2026-05-08 00:01:27.547131
1470	2026-01-11 04:30:00	7	1.57	220	499.4	t	2026-05-08 00:01:27.547131
1471	2026-01-11 05:00:00	1	2.78	220	592.5	t	2026-05-08 00:01:27.547131
1472	2026-01-11 05:00:00	4	1.08	220	454.3	t	2026-05-08 00:01:27.547131
1473	2026-01-11 05:00:00	7	1.28	220	477.8	t	2026-05-08 00:01:27.547131
1474	2026-01-11 05:30:00	1	1.48	220	290.5	t	2026-05-08 00:01:27.547131
1475	2026-01-11 05:30:00	4	2.06	220	293.8	t	2026-05-08 00:01:27.547131
1476	2026-01-11 05:30:00	7	1.17	220	495.8	t	2026-05-08 00:01:27.547131
1477	2026-01-11 06:00:00	1	1.99	220	443	t	2026-05-08 00:01:27.547131
1478	2026-01-11 06:00:00	4	2.2	220	453.2	t	2026-05-08 00:01:27.547131
1479	2026-01-11 06:00:00	7	2.81	220	281.8	t	2026-05-08 00:01:27.547131
1480	2026-01-11 06:30:00	1	1.8	220	450.3	t	2026-05-08 00:01:27.547131
1481	2026-01-11 06:30:00	4	1.9	220	348.9	t	2026-05-08 00:01:27.547131
1482	2026-01-11 06:30:00	7	2.6	220	607.1	t	2026-05-08 00:01:27.547131
1483	2026-01-11 07:00:00	1	2.14	220	373	t	2026-05-08 00:01:27.547131
1484	2026-01-11 07:00:00	4	1.06	220	641	t	2026-05-08 00:01:27.547131
1485	2026-01-11 07:00:00	7	2.39	220	268.9	t	2026-05-08 00:01:27.547131
1486	2026-01-11 07:30:00	1	2.15	220	539.1	t	2026-05-08 00:01:27.547131
1487	2026-01-11 07:30:00	4	1.04	220	443.8	t	2026-05-08 00:01:27.547131
1488	2026-01-11 07:30:00	7	2.42	220	477.8	t	2026-05-08 00:01:27.547131
1489	2026-01-11 08:00:00	1	2.28	220	327.5	t	2026-05-08 00:01:27.547131
1490	2026-01-11 08:00:00	4	1.06	220	385	t	2026-05-08 00:01:27.547131
1491	2026-01-11 08:00:00	7	2.68	220	579.5	t	2026-05-08 00:01:27.547131
1492	2026-01-11 08:30:00	1	1.48	220	426.4	t	2026-05-08 00:01:27.547131
1493	2026-01-11 08:30:00	4	1.58	220	431	t	2026-05-08 00:01:27.547131
1494	2026-01-11 08:30:00	7	1.31	220	629.9	t	2026-05-08 00:01:27.547131
1495	2026-01-11 09:00:00	1	2.73	220	531.1	t	2026-05-08 00:01:27.547131
1496	2026-01-11 09:00:00	4	1.53	220	427.7	t	2026-05-08 00:01:27.547131
1497	2026-01-11 09:00:00	7	2.79	220	581.9	t	2026-05-08 00:01:27.547131
1498	2026-01-11 09:30:00	1	2.69	220	658.7	t	2026-05-08 00:01:27.547131
1499	2026-01-11 09:30:00	4	2.22	220	235.3	t	2026-05-08 00:01:27.547131
1500	2026-01-11 09:30:00	7	1.99	220	462.3	t	2026-05-08 00:01:27.547131
1501	2026-01-11 10:00:00	1	2.16	220	271.9	t	2026-05-08 00:01:27.547131
1502	2026-01-11 10:00:00	4	1.02	220	293.9	t	2026-05-08 00:01:27.547131
1503	2026-01-11 10:00:00	7	2.49	220	402.6	t	2026-05-08 00:01:27.547131
1504	2026-01-11 10:30:00	1	1.32	220	437.6	t	2026-05-08 00:01:27.547131
1505	2026-01-11 10:30:00	4	1.16	220	438	t	2026-05-08 00:01:27.547131
1506	2026-01-11 10:30:00	7	1.77	220	377.9	t	2026-05-08 00:01:27.547131
1507	2026-01-11 11:00:00	1	2.12	220	452.3	t	2026-05-08 00:01:27.547131
1508	2026-01-11 11:00:00	4	2.47	220	554	t	2026-05-08 00:01:27.547131
1509	2026-01-11 11:00:00	7	2.26	220	302.3	t	2026-05-08 00:01:27.547131
1510	2026-01-11 11:30:00	1	1.1	220	651	t	2026-05-08 00:01:27.547131
1511	2026-01-11 11:30:00	4	1.47	220	238.9	t	2026-05-08 00:01:27.547131
1512	2026-01-11 11:30:00	7	2.17	220	254.9	t	2026-05-08 00:01:27.547131
1513	2026-01-11 12:00:00	1	2.14	220	640.9	t	2026-05-08 00:01:27.547131
1514	2026-01-11 12:00:00	4	2.87	220	402.3	t	2026-05-08 00:01:27.547131
1515	2026-01-11 12:00:00	7	1.4	220	537.9	t	2026-05-08 00:01:27.547131
1516	2026-01-11 12:30:00	1	1.74	220	222.1	t	2026-05-08 00:01:27.547131
1517	2026-01-11 12:30:00	4	2	220	326.5	t	2026-05-08 00:01:27.547131
1518	2026-01-11 12:30:00	7	1.53	220	478.4	t	2026-05-08 00:01:27.547131
1519	2026-01-11 13:00:00	1	2.85	220	373.8	t	2026-05-08 00:01:27.547131
1520	2026-01-11 13:00:00	4	2.56	220	492.5	t	2026-05-08 00:01:27.547131
1521	2026-01-11 13:00:00	7	1.4	220	271	t	2026-05-08 00:01:27.547131
1522	2026-01-11 13:30:00	1	1.98	220	646.7	t	2026-05-08 00:01:27.547131
1523	2026-01-11 13:30:00	4	2.36	220	557.7	t	2026-05-08 00:01:27.547131
1524	2026-01-11 13:30:00	7	2.9	220	287	t	2026-05-08 00:01:27.547131
1525	2026-01-11 14:00:00	1	2.65	220	257.3	t	2026-05-08 00:01:27.547131
1526	2026-01-11 14:00:00	4	1.51	220	387.1	t	2026-05-08 00:01:27.547131
1527	2026-01-11 14:00:00	7	2.26	220	573.6	t	2026-05-08 00:01:27.547131
1528	2026-01-11 14:30:00	1	2.74	220	575.7	t	2026-05-08 00:01:27.547131
1529	2026-01-11 14:30:00	4	1.49	220	437	t	2026-05-08 00:01:27.547131
1530	2026-01-11 14:30:00	7	1.72	220	470.3	t	2026-05-08 00:01:27.547131
1531	2026-01-11 15:00:00	1	1.4	220	422.7	t	2026-05-08 00:01:27.547131
1532	2026-01-11 15:00:00	4	1.84	220	339.3	t	2026-05-08 00:01:27.547131
1533	2026-01-11 15:00:00	7	1.04	220	272.3	t	2026-05-08 00:01:27.547131
1534	2026-01-11 15:30:00	1	2.23	220	286	t	2026-05-08 00:01:27.547131
1535	2026-01-11 15:30:00	4	2.76	220	549.1	t	2026-05-08 00:01:27.547131
1536	2026-01-11 15:30:00	7	1.14	220	384.4	t	2026-05-08 00:01:27.547131
1537	2026-01-11 16:00:00	1	2.37	220	441.6	t	2026-05-08 00:01:27.547131
1538	2026-01-11 16:00:00	4	2.02	220	480.5	t	2026-05-08 00:01:27.547131
1539	2026-01-11 16:00:00	7	2.6	220	564.7	t	2026-05-08 00:01:27.547131
1540	2026-01-11 16:30:00	1	1.85	220	597.8	t	2026-05-08 00:01:27.547131
1541	2026-01-11 16:30:00	4	1.99	220	606.9	t	2026-05-08 00:01:27.547131
1542	2026-01-11 16:30:00	7	1.28	220	249.6	t	2026-05-08 00:01:27.547131
1543	2026-01-11 17:00:00	1	1.78	220	450.9	t	2026-05-08 00:01:27.547131
1544	2026-01-11 17:00:00	4	2.63	220	419.4	t	2026-05-08 00:01:27.547131
1545	2026-01-11 17:00:00	7	2.73	220	620.3	t	2026-05-08 00:01:27.547131
1546	2026-01-11 17:30:00	1	2.08	220	395.9	t	2026-05-08 00:01:27.547131
1547	2026-01-11 17:30:00	4	1.86	220	407.8	t	2026-05-08 00:01:27.547131
1548	2026-01-11 17:30:00	7	1.83	220	236.2	t	2026-05-08 00:01:27.547131
1549	2026-01-11 18:00:00	1	2.24	220	430.6	t	2026-05-08 00:01:27.547131
1550	2026-01-11 18:00:00	4	2.98	220	580.6	t	2026-05-08 00:01:27.547131
1551	2026-01-11 18:00:00	7	2.26	220	375.2	t	2026-05-08 00:01:27.547131
1552	2026-01-11 18:30:00	1	2.76	220	287.3	t	2026-05-08 00:01:27.547131
1553	2026-01-11 18:30:00	4	2.31	220	447.1	t	2026-05-08 00:01:27.547131
1554	2026-01-11 18:30:00	7	1.52	220	487	t	2026-05-08 00:01:27.547131
1555	2026-01-11 19:00:00	1	2.5	220	552.7	t	2026-05-08 00:01:27.547131
1556	2026-01-11 19:00:00	4	2.95	220	508.8	t	2026-05-08 00:01:27.547131
1557	2026-01-11 19:00:00	7	2.83	220	434.9	t	2026-05-08 00:01:27.547131
1558	2026-01-11 19:30:00	1	2.08	220	357.1	t	2026-05-08 00:01:27.547131
1559	2026-01-11 19:30:00	4	1.3	220	526	t	2026-05-08 00:01:27.547131
1560	2026-01-11 19:30:00	7	2.83	220	486.7	t	2026-05-08 00:01:27.547131
1561	2026-01-11 20:00:00	1	2.1	220	469.6	t	2026-05-08 00:01:27.547131
1562	2026-01-11 20:00:00	4	2.37	220	277.1	t	2026-05-08 00:01:27.547131
1563	2026-01-11 20:00:00	7	2.23	220	316.6	t	2026-05-08 00:01:27.547131
1564	2026-01-11 20:30:00	1	1.89	220	467	t	2026-05-08 00:01:27.547131
1565	2026-01-11 20:30:00	4	2.24	220	437.7	t	2026-05-08 00:01:27.547131
1566	2026-01-11 20:30:00	7	2.72	220	510.8	t	2026-05-08 00:01:27.547131
1567	2026-01-11 21:00:00	1	1.49	220	426.4	t	2026-05-08 00:01:27.547131
1568	2026-01-11 21:00:00	4	2.7	220	587.7	t	2026-05-08 00:01:27.547131
1569	2026-01-11 21:00:00	7	1.05	220	624.5	t	2026-05-08 00:01:27.547131
1570	2026-01-11 21:30:00	1	2.29	220	288.7	t	2026-05-08 00:01:27.547131
1571	2026-01-11 21:30:00	4	1.56	220	501.7	t	2026-05-08 00:01:27.547131
1572	2026-01-11 21:30:00	7	1.53	220	606.3	t	2026-05-08 00:01:27.547131
1573	2026-01-11 22:00:00	1	2.79	220	502.2	t	2026-05-08 00:01:27.547131
1574	2026-01-11 22:00:00	4	2.62	220	324.3	t	2026-05-08 00:01:27.547131
1575	2026-01-11 22:00:00	7	2.03	220	393.2	t	2026-05-08 00:01:27.547131
1576	2026-01-11 22:30:00	1	2.19	220	320.4	t	2026-05-08 00:01:27.547131
1577	2026-01-11 22:30:00	4	2.83	220	227.6	t	2026-05-08 00:01:27.547131
1578	2026-01-11 22:30:00	7	2.63	220	284.9	t	2026-05-08 00:01:27.547131
1579	2026-01-11 23:00:00	1	2.17	220	641.5	t	2026-05-08 00:01:27.547131
1580	2026-01-11 23:00:00	4	1.75	220	437.8	t	2026-05-08 00:01:27.547131
1581	2026-01-11 23:00:00	7	1.45	220	490.2	t	2026-05-08 00:01:27.547131
1582	2026-01-11 23:30:00	1	1.87	220	322.2	t	2026-05-08 00:01:27.547131
1583	2026-01-11 23:30:00	4	1.55	220	283.9	t	2026-05-08 00:01:27.547131
1584	2026-01-11 23:30:00	7	1.18	220	297.5	t	2026-05-08 00:01:27.547131
1585	2026-01-12 00:00:00	1	3.25	220	443.6	t	2026-05-08 00:01:27.547131
1586	2026-01-12 00:00:00	4	3.7	220	376.9	t	2026-05-08 00:01:27.547131
1587	2026-01-12 00:00:00	7	3.59	220	784.9	t	2026-05-08 00:01:27.547131
1588	2026-01-12 00:30:00	1	1.9	220	708.2	t	2026-05-08 00:01:27.547131
1589	2026-01-12 00:30:00	4	3.22	220	379.2	t	2026-05-08 00:01:27.547131
1590	2026-01-12 00:30:00	7	2.94	220	643.1	t	2026-05-08 00:01:27.547131
1591	2026-01-12 01:00:00	1	1.78	220	314	t	2026-05-08 00:01:27.547131
1592	2026-01-12 01:00:00	4	1.87	220	467	t	2026-05-08 00:01:27.547131
1593	2026-01-12 01:00:00	7	3.65	220	766.3	t	2026-05-08 00:01:27.547131
1594	2026-01-12 01:30:00	1	1.64	220	270.8	t	2026-05-08 00:01:27.547131
1595	2026-01-12 01:30:00	4	2.14	220	495.3	t	2026-05-08 00:01:27.547131
1596	2026-01-12 01:30:00	7	3.42	220	288.1	t	2026-05-08 00:01:27.547131
1597	2026-01-12 02:00:00	1	1.75	220	550.7	t	2026-05-08 00:01:27.547131
1598	2026-01-12 02:00:00	4	2.35	220	716.7	t	2026-05-08 00:01:27.547131
1599	2026-01-12 02:00:00	7	1.85	220	493.4	t	2026-05-08 00:01:27.547131
1600	2026-01-12 02:30:00	1	3.58	220	401.9	t	2026-05-08 00:01:27.547131
1601	2026-01-12 02:30:00	4	1.77	220	555.8	t	2026-05-08 00:01:27.547131
1602	2026-01-12 02:30:00	7	1.61	220	759.3	t	2026-05-08 00:01:27.547131
1603	2026-01-12 03:00:00	1	3.64	220	481.5	t	2026-05-08 00:01:27.547131
1604	2026-01-12 03:00:00	4	3.51	220	579.3	t	2026-05-08 00:01:27.547131
1605	2026-01-12 03:00:00	7	3.35	220	768.4	t	2026-05-08 00:01:27.547131
1606	2026-01-12 03:30:00	1	1.63	220	454.9	t	2026-05-08 00:01:27.547131
1607	2026-01-12 03:30:00	4	3.37	220	393.4	t	2026-05-08 00:01:27.547131
1608	2026-01-12 03:30:00	7	2.56	220	412.3	t	2026-05-08 00:01:27.547131
1609	2026-01-12 04:00:00	1	2.67	220	366.8	t	2026-05-08 00:01:27.547131
1610	2026-01-12 04:00:00	4	2.59	220	328.1	t	2026-05-08 00:01:27.547131
1611	2026-01-12 04:00:00	7	1.34	220	382.6	t	2026-05-08 00:01:27.547131
1612	2026-01-12 04:30:00	1	2.4	220	591.8	t	2026-05-08 00:01:27.547131
1613	2026-01-12 04:30:00	4	2.71	220	631.3	t	2026-05-08 00:01:27.547131
1614	2026-01-12 04:30:00	7	3.3	220	813.6	t	2026-05-08 00:01:27.547131
1615	2026-01-12 05:00:00	1	3.63	220	682.8	t	2026-05-08 00:01:27.547131
1616	2026-01-12 05:00:00	4	2.22	220	657.4	t	2026-05-08 00:01:27.547131
1617	2026-01-12 05:00:00	7	2.96	220	657.6	t	2026-05-08 00:01:27.547131
1618	2026-01-12 05:30:00	1	2.98	220	313.3	t	2026-05-08 00:01:27.547131
1619	2026-01-12 05:30:00	4	2	220	751.9	t	2026-05-08 00:01:27.547131
1620	2026-01-12 05:30:00	7	2.9	220	667.9	t	2026-05-08 00:01:27.547131
1621	2026-01-12 06:00:00	1	1.79	220	794.2	t	2026-05-08 00:01:27.547131
1622	2026-01-12 06:00:00	4	2.38	220	494.8	t	2026-05-08 00:01:27.547131
1623	2026-01-12 06:00:00	7	3.64	220	282.2	t	2026-05-08 00:01:27.547131
1624	2026-01-12 06:30:00	1	2.58	220	746.2	t	2026-05-08 00:01:27.547131
1625	2026-01-12 06:30:00	4	2.49	220	519.2	t	2026-05-08 00:01:27.547131
1626	2026-01-12 06:30:00	7	1.54	220	537.7	t	2026-05-08 00:01:27.547131
1627	2026-01-12 07:00:00	1	17.09	220	3385.4	t	2026-05-08 00:01:27.547131
1628	2026-01-12 07:00:00	4	23.9	220	4738.8	t	2026-05-08 00:01:27.547131
1629	2026-01-12 07:00:00	7	23.34	220	5251.8	t	2026-05-08 00:01:27.547131
1630	2026-01-12 07:30:00	1	14.08	220	3574.9	t	2026-05-08 00:01:27.547131
1631	2026-01-12 07:30:00	4	16.13	220	4359.9	t	2026-05-08 00:01:27.547131
1632	2026-01-12 07:30:00	7	23.64	220	4940	t	2026-05-08 00:01:27.547131
1633	2026-01-12 08:00:00	1	19.28	220	3606.1	t	2026-05-08 00:01:27.547131
1634	2026-01-12 08:00:00	4	23.82	220	3642.7	t	2026-05-08 00:01:27.547131
1635	2026-01-12 08:00:00	7	25.94	220	6073.3	t	2026-05-08 00:01:27.547131
1636	2026-01-12 08:30:00	1	17.05	220	2745.8	t	2026-05-08 00:01:27.547131
1637	2026-01-12 08:30:00	4	23.84	220	4535.1	t	2026-05-08 00:01:27.547131
1638	2026-01-12 08:30:00	7	29.21	220	4758.2	t	2026-05-08 00:01:27.547131
1639	2026-01-12 09:00:00	1	12.77	220	3310.1	t	2026-05-08 00:01:27.547131
1640	2026-01-12 09:00:00	4	19.37	220	3752.1	t	2026-05-08 00:01:27.547131
1641	2026-01-12 09:00:00	7	28.54	220	5250.2	t	2026-05-08 00:01:27.547131
1642	2026-01-12 09:30:00	1	18.61	220	3899.5	t	2026-05-08 00:01:27.547131
1643	2026-01-12 09:30:00	4	19.44	220	3751.8	t	2026-05-08 00:01:27.547131
1644	2026-01-12 09:30:00	7	29.6	220	5463.4	t	2026-05-08 00:01:27.547131
1645	2026-01-12 10:00:00	1	13.27	220	4334.2	t	2026-05-08 00:01:27.547131
1646	2026-01-12 10:00:00	4	22.47	220	5696.3	t	2026-05-08 00:01:27.547131
1647	2026-01-12 10:00:00	7	20.84	220	6400.5	t	2026-05-08 00:01:27.547131
1648	2026-01-12 10:30:00	1	17.73	220	2545.3	t	2026-05-08 00:01:27.547131
1649	2026-01-12 10:30:00	4	21.32	220	3593.5	t	2026-05-08 00:01:27.547131
1650	2026-01-12 10:30:00	7	27.22	220	6591	t	2026-05-08 00:01:27.547131
1651	2026-01-12 11:00:00	1	16.02	220	3868.4	t	2026-05-08 00:01:27.547131
1652	2026-01-12 11:00:00	4	19.32	220	4582.7	t	2026-05-08 00:01:27.547131
1653	2026-01-12 11:00:00	7	30.31	220	5293.3	t	2026-05-08 00:01:27.547131
1654	2026-01-12 11:30:00	1	19.16	220	3473.7	t	2026-05-08 00:01:27.547131
1655	2026-01-12 11:30:00	4	18.03	220	3700.5	t	2026-05-08 00:01:27.547131
1656	2026-01-12 11:30:00	7	25.99	220	5239.2	t	2026-05-08 00:01:27.547131
1657	2026-01-12 12:00:00	1	14.35	220	3709.3	t	2026-05-08 00:01:27.547131
1658	2026-01-12 12:00:00	4	17.3	220	5005.8	t	2026-05-08 00:01:27.547131
1659	2026-01-12 12:00:00	7	25.59	220	6605.5	t	2026-05-08 00:01:27.547131
1660	2026-01-12 12:30:00	1	17.63	220	4386.7	t	2026-05-08 00:01:27.547131
1661	2026-01-12 12:30:00	4	21.48	220	4048.6	t	2026-05-08 00:01:27.547131
1662	2026-01-12 12:30:00	7	26.96	220	5698.8	t	2026-05-08 00:01:27.547131
1663	2026-01-12 13:00:00	1	18.96	220	4173.2	t	2026-05-08 00:01:27.547131
1664	2026-01-12 13:00:00	4	23.38	220	4303.6	t	2026-05-08 00:01:27.547131
1665	2026-01-12 13:00:00	7	24.13	220	6561.4	t	2026-05-08 00:01:27.547131
1666	2026-01-12 13:30:00	1	11.61	220	3747.3	t	2026-05-08 00:01:27.547131
1667	2026-01-12 13:30:00	4	22.63	220	4253.9	t	2026-05-08 00:01:27.547131
1668	2026-01-12 13:30:00	7	22.49	220	5087.7	t	2026-05-08 00:01:27.547131
1669	2026-01-12 14:00:00	1	17.7	220	3922.1	t	2026-05-08 00:01:27.547131
1670	2026-01-12 14:00:00	4	22.53	220	4578.1	t	2026-05-08 00:01:27.547131
1671	2026-01-12 14:00:00	7	28.43	220	4588.9	t	2026-05-08 00:01:27.547131
1672	2026-01-12 14:30:00	1	16.8	220	2592.5	t	2026-05-08 00:01:27.547131
1673	2026-01-12 14:30:00	4	24.05	220	3894.8	t	2026-05-08 00:01:27.547131
1674	2026-01-12 14:30:00	7	29.43	220	5724	t	2026-05-08 00:01:27.547131
1675	2026-01-12 15:00:00	1	15.65	220	3701.1	t	2026-05-08 00:01:27.547131
1676	2026-01-12 15:00:00	4	19.87	220	4724.5	t	2026-05-08 00:01:27.547131
1677	2026-01-12 15:00:00	7	25.82	220	5646.1	t	2026-05-08 00:01:27.547131
1678	2026-01-12 15:30:00	1	18.96	220	2926.7	t	2026-05-08 00:01:27.547131
1679	2026-01-12 15:30:00	4	19.7	220	5271.1	t	2026-05-08 00:01:27.547131
1680	2026-01-12 15:30:00	7	29.26	220	5328	t	2026-05-08 00:01:27.547131
1681	2026-01-12 16:00:00	1	14.99	220	2990.6	t	2026-05-08 00:01:27.547131
1682	2026-01-12 16:00:00	4	21.51	220	4193.8	t	2026-05-08 00:01:27.547131
1683	2026-01-12 16:00:00	7	21.77	220	6523.6	t	2026-05-08 00:01:27.547131
1684	2026-01-12 16:30:00	1	20.74	220	3463.3	t	2026-05-08 00:01:27.547131
1685	2026-01-12 16:30:00	4	22.39	220	5118.3	t	2026-05-08 00:01:27.547131
1686	2026-01-12 16:30:00	7	28.25	220	5572.4	t	2026-05-08 00:01:27.547131
1687	2026-01-12 17:00:00	1	19.65	220	3366.8	t	2026-05-08 00:01:27.547131
1688	2026-01-12 17:00:00	4	21.61	220	4957.8	t	2026-05-08 00:01:27.547131
1689	2026-01-12 17:00:00	7	21.44	220	6378.5	t	2026-05-08 00:01:27.547131
1690	2026-01-12 17:30:00	1	13.76	220	3685.7	t	2026-05-08 00:01:27.547131
1691	2026-01-12 17:30:00	4	19.35	220	3846.2	t	2026-05-08 00:01:27.547131
1692	2026-01-12 17:30:00	7	30.1	220	4823.6	t	2026-05-08 00:01:27.547131
1693	2026-01-12 18:00:00	1	12.61	220	3022.4	t	2026-05-08 00:01:27.547131
1694	2026-01-12 18:00:00	4	23.19	220	4006	t	2026-05-08 00:01:27.547131
1695	2026-01-12 18:00:00	7	24.89	220	6705.4	t	2026-05-08 00:01:27.547131
1696	2026-01-12 18:30:00	1	16.94	220	3633.9	t	2026-05-08 00:01:27.547131
1697	2026-01-12 18:30:00	4	22.09	220	3558.8	t	2026-05-08 00:01:27.547131
1698	2026-01-12 18:30:00	7	29.21	220	6208.3	t	2026-05-08 00:01:27.547131
1699	2026-01-12 19:00:00	1	12.2	220	2905.2	t	2026-05-08 00:01:27.547131
1700	2026-01-12 19:00:00	4	21.7	220	3653.9	t	2026-05-08 00:01:27.547131
1701	2026-01-12 19:00:00	7	25.35	220	4758	t	2026-05-08 00:01:27.547131
1702	2026-01-12 19:30:00	1	20.33	220	3607.7	t	2026-05-08 00:01:27.547131
1703	2026-01-12 19:30:00	4	16.92	220	4179.8	t	2026-05-08 00:01:27.547131
1704	2026-01-12 19:30:00	7	29.82	220	6619	t	2026-05-08 00:01:27.547131
1705	2026-01-12 20:00:00	1	2.52	220	273.2	t	2026-05-08 00:01:27.547131
1706	2026-01-12 20:00:00	4	3.03	220	360.2	t	2026-05-08 00:01:27.547131
1707	2026-01-12 20:00:00	7	1.43	220	605.5	t	2026-05-08 00:01:27.547131
1708	2026-01-12 20:30:00	1	1.75	220	529	t	2026-05-08 00:01:27.547131
1709	2026-01-12 20:30:00	4	2.49	220	330.2	t	2026-05-08 00:01:27.547131
1710	2026-01-12 20:30:00	7	3.32	220	681.5	t	2026-05-08 00:01:27.547131
1711	2026-01-12 21:00:00	1	2.81	220	602	t	2026-05-08 00:01:27.547131
1712	2026-01-12 21:00:00	4	3.31	220	356.9	t	2026-05-08 00:01:27.547131
1713	2026-01-12 21:00:00	7	1.9	220	543.2	t	2026-05-08 00:01:27.547131
1714	2026-01-12 21:30:00	1	1.51	220	620.1	t	2026-05-08 00:01:27.547131
1715	2026-01-12 21:30:00	4	2.53	220	548.1	t	2026-05-08 00:01:27.547131
1716	2026-01-12 21:30:00	7	1.33	220	649.1	t	2026-05-08 00:01:27.547131
1717	2026-01-12 22:00:00	1	1.81	220	663.2	t	2026-05-08 00:01:27.547131
1718	2026-01-12 22:00:00	4	1.41	220	373.4	t	2026-05-08 00:01:27.547131
1719	2026-01-12 22:00:00	7	2.89	220	316.2	t	2026-05-08 00:01:27.547131
1720	2026-01-12 22:30:00	1	2.23	220	519.4	t	2026-05-08 00:01:27.547131
1721	2026-01-12 22:30:00	4	2.19	220	547.3	t	2026-05-08 00:01:27.547131
1722	2026-01-12 22:30:00	7	1.76	220	662.8	t	2026-05-08 00:01:27.547131
1723	2026-01-12 23:00:00	1	1.64	220	297.1	t	2026-05-08 00:01:27.547131
1724	2026-01-12 23:00:00	4	2.84	220	781.1	t	2026-05-08 00:01:27.547131
1725	2026-01-12 23:00:00	7	2.27	220	745.4	t	2026-05-08 00:01:27.547131
1726	2026-01-12 23:30:00	1	3.06	220	674.8	t	2026-05-08 00:01:27.547131
1727	2026-01-12 23:30:00	4	3.09	220	504.7	t	2026-05-08 00:01:27.547131
1728	2026-01-12 23:30:00	7	1.74	220	334.6	t	2026-05-08 00:01:27.547131
1729	2026-01-13 00:00:00	1	1.49	220	315.6	t	2026-05-08 00:01:27.547131
1730	2026-01-13 00:00:00	4	1.59	220	726.1	t	2026-05-08 00:01:27.547131
1731	2026-01-13 00:00:00	7	2.57	220	776.9	t	2026-05-08 00:01:27.547131
1732	2026-01-13 00:30:00	1	1.37	220	296.7	t	2026-05-08 00:01:27.547131
1733	2026-01-13 00:30:00	4	2.5	220	740.8	t	2026-05-08 00:01:27.547131
1734	2026-01-13 00:30:00	7	1.95	220	685.2	t	2026-05-08 00:01:27.547131
1735	2026-01-13 01:00:00	1	2.9	220	797.9	t	2026-05-08 00:01:27.547131
1736	2026-01-13 01:00:00	4	1.33	220	595.9	t	2026-05-08 00:01:27.547131
1737	2026-01-13 01:00:00	7	1.61	220	735.3	t	2026-05-08 00:01:27.547131
1738	2026-01-13 01:30:00	1	2.09	220	272.5	t	2026-05-08 00:01:27.547131
1739	2026-01-13 01:30:00	4	2.36	220	338.1	t	2026-05-08 00:01:27.547131
1740	2026-01-13 01:30:00	7	2.11	220	455.4	t	2026-05-08 00:01:27.547131
1741	2026-01-13 02:00:00	1	1.63	220	566.5	t	2026-05-08 00:01:27.547131
1742	2026-01-13 02:00:00	4	3.27	220	323.7	t	2026-05-08 00:01:27.547131
1743	2026-01-13 02:00:00	7	2.27	220	450.7	t	2026-05-08 00:01:27.547131
1744	2026-01-13 02:30:00	1	1.97	220	616.4	t	2026-05-08 00:01:27.547131
1745	2026-01-13 02:30:00	4	3.41	220	784.7	t	2026-05-08 00:01:27.547131
1746	2026-01-13 02:30:00	7	2.42	220	589.9	t	2026-05-08 00:01:27.547131
1747	2026-01-13 03:00:00	1	2.6	220	765.7	t	2026-05-08 00:01:27.547131
1748	2026-01-13 03:00:00	4	3.44	220	652.2	t	2026-05-08 00:01:27.547131
1749	2026-01-13 03:00:00	7	1.96	220	308.1	t	2026-05-08 00:01:27.547131
1750	2026-01-13 03:30:00	1	3.11	220	373.9	t	2026-05-08 00:01:27.547131
1751	2026-01-13 03:30:00	4	1.64	220	667.6	t	2026-05-08 00:01:27.547131
1752	2026-01-13 03:30:00	7	2.33	220	657.7	t	2026-05-08 00:01:27.547131
1753	2026-01-13 04:00:00	1	2.73	220	750.3	t	2026-05-08 00:01:27.547131
1754	2026-01-13 04:00:00	4	1.9	220	595.6	t	2026-05-08 00:01:27.547131
1755	2026-01-13 04:00:00	7	1.71	220	566.2	t	2026-05-08 00:01:27.547131
1756	2026-01-13 04:30:00	1	2.43	220	722	t	2026-05-08 00:01:27.547131
1757	2026-01-13 04:30:00	4	2.6	220	813.2	t	2026-05-08 00:01:27.547131
1758	2026-01-13 04:30:00	7	1.67	220	733.9	t	2026-05-08 00:01:27.547131
1759	2026-01-13 05:00:00	1	1.22	220	354.4	t	2026-05-08 00:01:27.547131
1760	2026-01-13 05:00:00	4	1.42	220	357.2	t	2026-05-08 00:01:27.547131
1761	2026-01-13 05:00:00	7	2.2	220	283	t	2026-05-08 00:01:27.547131
1762	2026-01-13 05:30:00	1	3.28	220	309.5	t	2026-05-08 00:01:27.547131
1763	2026-01-13 05:30:00	4	3.43	220	423.2	t	2026-05-08 00:01:27.547131
1764	2026-01-13 05:30:00	7	1.39	220	296.6	t	2026-05-08 00:01:27.547131
1765	2026-01-13 06:00:00	1	3.66	220	679.2	t	2026-05-08 00:01:27.547131
1766	2026-01-13 06:00:00	4	3.41	220	509.6	t	2026-05-08 00:01:27.547131
1767	2026-01-13 06:00:00	7	1.61	220	764.5	t	2026-05-08 00:01:27.547131
1768	2026-01-13 06:30:00	1	3.41	220	503	t	2026-05-08 00:01:27.547131
1769	2026-01-13 06:30:00	4	1.98	220	629	t	2026-05-08 00:01:27.547131
1770	2026-01-13 06:30:00	7	3.02	220	630.5	t	2026-05-08 00:01:27.547131
1771	2026-01-13 07:00:00	1	12.56	220	4100.7	t	2026-05-08 00:01:27.547131
1772	2026-01-13 07:00:00	4	21.64	220	5503	t	2026-05-08 00:01:27.547131
1773	2026-01-13 07:00:00	7	24.73	220	6673.8	t	2026-05-08 00:01:27.547131
1774	2026-01-13 07:30:00	1	19.3	220	2704.1	t	2026-05-08 00:01:27.547131
1775	2026-01-13 07:30:00	4	20.19	220	3914.2	t	2026-05-08 00:01:27.547131
1776	2026-01-13 07:30:00	7	24.1	220	6386.3	t	2026-05-08 00:01:27.547131
1777	2026-01-13 08:00:00	1	12.08	220	3944	t	2026-05-08 00:01:27.547131
1778	2026-01-13 08:00:00	4	20.9	220	3633.3	t	2026-05-08 00:01:27.547131
1779	2026-01-13 08:00:00	7	27.92	220	6340.9	t	2026-05-08 00:01:27.547131
1780	2026-01-13 08:30:00	1	18.11	220	2927.6	t	2026-05-08 00:01:27.547131
1781	2026-01-13 08:30:00	4	17.94	220	3567	t	2026-05-08 00:01:27.547131
1782	2026-01-13 08:30:00	7	23.63	220	6652.4	t	2026-05-08 00:01:27.547131
1783	2026-01-13 09:00:00	1	17.5	220	3906	t	2026-05-08 00:01:27.547131
1784	2026-01-13 09:00:00	4	19.12	220	3702.1	t	2026-05-08 00:01:27.547131
1785	2026-01-13 09:00:00	7	27.53	220	6655.9	t	2026-05-08 00:01:27.547131
1786	2026-01-13 09:30:00	1	15.75	220	2842.7	t	2026-05-08 00:01:27.547131
1787	2026-01-13 09:30:00	4	16.6	220	3737.8	t	2026-05-08 00:01:27.547131
1788	2026-01-13 09:30:00	7	27.24	220	6020.2	t	2026-05-08 00:01:27.547131
1789	2026-01-13 10:00:00	1	18.23	220	2620.6	t	2026-05-08 00:01:27.547131
1790	2026-01-13 10:00:00	4	19.55	220	4406.6	t	2026-05-08 00:01:27.547131
1791	2026-01-13 10:00:00	7	23.69	220	6472.2	t	2026-05-08 00:01:27.547131
1792	2026-01-13 10:30:00	1	21.16	220	3131.1	t	2026-05-08 00:01:27.547131
1793	2026-01-13 10:30:00	4	21.46	220	4730.9	t	2026-05-08 00:01:27.547131
1794	2026-01-13 10:30:00	7	26.1	220	5429.2	t	2026-05-08 00:01:27.547131
1795	2026-01-13 11:00:00	1	12.69	220	3672.7	t	2026-05-08 00:01:27.547131
1796	2026-01-13 11:00:00	4	24.61	220	3740.2	t	2026-05-08 00:01:27.547131
1797	2026-01-13 11:00:00	7	29.03	220	5946.3	t	2026-05-08 00:01:27.547131
1798	2026-01-13 11:30:00	1	20.77	220	4054.4	t	2026-05-08 00:01:27.547131
1799	2026-01-13 11:30:00	4	22.14	220	3773.4	t	2026-05-08 00:01:27.547131
1800	2026-01-13 11:30:00	7	29.64	220	4809	t	2026-05-08 00:01:27.547131
1801	2026-01-13 12:00:00	1	16.68	220	4529.3	t	2026-05-08 00:01:27.547131
1802	2026-01-13 12:00:00	4	23.27	220	4274.1	t	2026-05-08 00:01:27.547131
1803	2026-01-13 12:00:00	7	25.64	220	5948.5	t	2026-05-08 00:01:27.547131
1804	2026-01-13 12:30:00	1	21.23	220	4601.6	t	2026-05-08 00:01:27.547131
1805	2026-01-13 12:30:00	4	17.76	220	4408.6	t	2026-05-08 00:01:27.547131
1806	2026-01-13 12:30:00	7	27.18	220	4765.2	t	2026-05-08 00:01:27.547131
1807	2026-01-13 13:00:00	1	15.1	220	3543.9	t	2026-05-08 00:01:27.547131
1808	2026-01-13 13:00:00	4	18.97	220	4476.9	t	2026-05-08 00:01:27.547131
1809	2026-01-13 13:00:00	7	22.46	220	6161.9	t	2026-05-08 00:01:27.547131
1810	2026-01-13 13:30:00	1	11.8	220	4005.8	t	2026-05-08 00:01:27.547131
1811	2026-01-13 13:30:00	4	25.52	220	5100.4	t	2026-05-08 00:01:27.547131
1812	2026-01-13 13:30:00	7	30.08	220	6233.5	t	2026-05-08 00:01:27.547131
1813	2026-01-13 14:00:00	1	12.82	220	3981.3	t	2026-05-08 00:01:27.547131
1814	2026-01-13 14:00:00	4	17.39	220	4905.1	t	2026-05-08 00:01:27.547131
1815	2026-01-13 14:00:00	7	26.58	220	4588.1	t	2026-05-08 00:01:27.547131
1816	2026-01-13 14:30:00	1	20.52	220	4129.8	t	2026-05-08 00:01:27.547131
1817	2026-01-13 14:30:00	4	25.51	220	4767.1	t	2026-05-08 00:01:27.547131
1818	2026-01-13 14:30:00	7	22.35	220	5868	t	2026-05-08 00:01:27.547131
1819	2026-01-13 15:00:00	1	13.82	220	2653.1	t	2026-05-08 00:01:27.547131
1820	2026-01-13 15:00:00	4	18.25	220	4350.3	t	2026-05-08 00:01:27.547131
1821	2026-01-13 15:00:00	7	25.7	220	5110.7	t	2026-05-08 00:01:27.547131
1822	2026-01-13 15:30:00	1	16.49	220	2741.3	t	2026-05-08 00:01:27.547131
1823	2026-01-13 15:30:00	4	16.77	220	5331.2	t	2026-05-08 00:01:27.547131
1824	2026-01-13 15:30:00	7	21.82	220	5216.7	t	2026-05-08 00:01:27.547131
1825	2026-01-13 16:00:00	1	15.04	220	3384.5	t	2026-05-08 00:01:27.547131
1826	2026-01-13 16:00:00	4	25.49	220	4812.9	t	2026-05-08 00:01:27.547131
1827	2026-01-13 16:00:00	7	21.28	220	4777.5	t	2026-05-08 00:01:27.547131
1828	2026-01-13 16:30:00	1	13.57	220	3175.8	t	2026-05-08 00:01:27.547131
1829	2026-01-13 16:30:00	4	24.75	220	5557.7	t	2026-05-08 00:01:27.547131
1830	2026-01-13 16:30:00	7	29.58	220	5350.5	t	2026-05-08 00:01:27.547131
1831	2026-01-13 17:00:00	1	20.45	220	3976.3	t	2026-05-08 00:01:27.547131
1832	2026-01-13 17:00:00	4	17.15	220	4407.9	t	2026-05-08 00:01:27.547131
1833	2026-01-13 17:00:00	7	25.73	220	5338	t	2026-05-08 00:01:27.547131
1834	2026-01-13 17:30:00	1	12.5	220	4065.5	t	2026-05-08 00:01:27.547131
1835	2026-01-13 17:30:00	4	25.76	220	4034.9	t	2026-05-08 00:01:27.547131
1836	2026-01-13 17:30:00	7	26.48	220	4972.4	t	2026-05-08 00:01:27.547131
1837	2026-01-13 18:00:00	1	19.88	220	2999.8	t	2026-05-08 00:01:27.547131
1838	2026-01-13 18:00:00	4	25.37	220	4934.1	t	2026-05-08 00:01:27.547131
1839	2026-01-13 18:00:00	7	27.76	220	4743.1	t	2026-05-08 00:01:27.547131
1840	2026-01-13 18:30:00	1	19.18	220	2996.4	t	2026-05-08 00:01:27.547131
1841	2026-01-13 18:30:00	4	21.55	220	4950.8	t	2026-05-08 00:01:27.547131
1842	2026-01-13 18:30:00	7	27.3	220	5629.5	t	2026-05-08 00:01:27.547131
1843	2026-01-13 19:00:00	1	12.59	220	3491.4	t	2026-05-08 00:01:27.547131
1844	2026-01-13 19:00:00	4	17.12	220	5067.4	t	2026-05-08 00:01:27.547131
1845	2026-01-13 19:00:00	7	29.25	220	5407.4	t	2026-05-08 00:01:27.547131
1846	2026-01-13 19:30:00	1	20.87	220	4214.7	t	2026-05-08 00:01:27.547131
1847	2026-01-13 19:30:00	4	22.44	220	5011.3	t	2026-05-08 00:01:27.547131
1848	2026-01-13 19:30:00	7	22.27	220	6084.3	t	2026-05-08 00:01:27.547131
1849	2026-01-13 20:00:00	1	1.57	220	458.2	t	2026-05-08 00:01:27.547131
1850	2026-01-13 20:00:00	4	1.3	220	489.2	t	2026-05-08 00:01:27.547131
1851	2026-01-13 20:00:00	7	3.23	220	742.5	t	2026-05-08 00:01:27.547131
1852	2026-01-13 20:30:00	1	2.35	220	581.3	t	2026-05-08 00:01:27.547131
1853	2026-01-13 20:30:00	4	2.33	220	681.6	t	2026-05-08 00:01:27.547131
1854	2026-01-13 20:30:00	7	3.02	220	356.8	t	2026-05-08 00:01:27.547131
1855	2026-01-13 21:00:00	1	3.22	220	753.7	t	2026-05-08 00:01:27.547131
1856	2026-01-13 21:00:00	4	2.91	220	490.1	t	2026-05-08 00:01:27.547131
1857	2026-01-13 21:00:00	7	3.37	220	786.1	t	2026-05-08 00:01:27.547131
1858	2026-01-13 21:30:00	1	1.58	220	538.8	t	2026-05-08 00:01:27.547131
1859	2026-01-13 21:30:00	4	2.07	220	444.4	t	2026-05-08 00:01:27.547131
1860	2026-01-13 21:30:00	7	1.59	220	585.5	t	2026-05-08 00:01:27.547131
1861	2026-01-13 22:00:00	1	3.24	220	265.4	t	2026-05-08 00:01:27.547131
1862	2026-01-13 22:00:00	4	1.59	220	438.2	t	2026-05-08 00:01:27.547131
1863	2026-01-13 22:00:00	7	2.33	220	311.8	t	2026-05-08 00:01:27.547131
1864	2026-01-13 22:30:00	1	2.62	220	272.4	t	2026-05-08 00:01:27.547131
1865	2026-01-13 22:30:00	4	1.5	220	685	t	2026-05-08 00:01:27.547131
1866	2026-01-13 22:30:00	7	1.75	220	484.3	t	2026-05-08 00:01:27.547131
1867	2026-01-13 23:00:00	1	2.73	220	754.6	t	2026-05-08 00:01:27.547131
1868	2026-01-13 23:00:00	4	2.81	220	766.3	t	2026-05-08 00:01:27.547131
1869	2026-01-13 23:00:00	7	1.43	220	480.9	t	2026-05-08 00:01:27.547131
1870	2026-01-13 23:30:00	1	3.38	220	775.7	t	2026-05-08 00:01:27.547131
1871	2026-01-13 23:30:00	4	1.92	220	633	t	2026-05-08 00:01:27.547131
1872	2026-01-13 23:30:00	7	2.17	220	505	t	2026-05-08 00:01:27.547131
1873	2026-01-14 00:00:00	1	3.54	220	403	t	2026-05-08 00:01:27.547131
1874	2026-01-14 00:00:00	4	3.62	220	778.5	t	2026-05-08 00:01:27.547131
1875	2026-01-14 00:00:00	7	1.58	220	768.2	t	2026-05-08 00:01:27.547131
1876	2026-01-14 00:30:00	1	1.73	220	531.9	t	2026-05-08 00:01:27.547131
1877	2026-01-14 00:30:00	4	2.89	220	664.8	t	2026-05-08 00:01:27.547131
1878	2026-01-14 00:30:00	7	3.6	220	741	t	2026-05-08 00:01:27.547131
1879	2026-01-14 01:00:00	1	1.49	220	602.8	t	2026-05-08 00:01:27.547131
1880	2026-01-14 01:00:00	4	2.21	220	395.4	t	2026-05-08 00:01:27.547131
1881	2026-01-14 01:00:00	7	1.37	220	549.3	t	2026-05-08 00:01:27.547131
1882	2026-01-14 01:30:00	1	3.68	220	563.8	t	2026-05-08 00:01:27.547131
1883	2026-01-14 01:30:00	4	3.62	220	556	t	2026-05-08 00:01:27.547131
1884	2026-01-14 01:30:00	7	2.35	220	657.6	t	2026-05-08 00:01:27.547131
1885	2026-01-14 02:00:00	1	2.66	220	298.6	t	2026-05-08 00:01:27.547131
1886	2026-01-14 02:00:00	4	2.46	220	446.9	t	2026-05-08 00:01:27.547131
1887	2026-01-14 02:00:00	7	3.21	220	325.3	t	2026-05-08 00:01:27.547131
1888	2026-01-14 02:30:00	1	2.94	220	610.2	t	2026-05-08 00:01:27.547131
1889	2026-01-14 02:30:00	4	2.2	220	466.9	t	2026-05-08 00:01:27.547131
1890	2026-01-14 02:30:00	7	3.33	220	521.8	t	2026-05-08 00:01:27.547131
1891	2026-01-14 03:00:00	1	2.53	220	303.2	t	2026-05-08 00:01:27.547131
1892	2026-01-14 03:00:00	4	1.75	220	561.2	t	2026-05-08 00:01:27.547131
1893	2026-01-14 03:00:00	7	1.67	220	721.9	t	2026-05-08 00:01:27.547131
1894	2026-01-14 03:30:00	1	3.06	220	619.6	t	2026-05-08 00:01:27.547131
1895	2026-01-14 03:30:00	4	3.2	220	496.2	t	2026-05-08 00:01:27.547131
1896	2026-01-14 03:30:00	7	3.68	220	381.3	t	2026-05-08 00:01:27.547131
1897	2026-01-14 04:00:00	1	1.75	220	445.8	t	2026-05-08 00:01:27.547131
1898	2026-01-14 04:00:00	4	2.28	220	781.9	t	2026-05-08 00:01:27.547131
1899	2026-01-14 04:00:00	7	1.36	220	429.5	t	2026-05-08 00:01:27.547131
1900	2026-01-14 04:30:00	1	1.55	220	493.3	t	2026-05-08 00:01:27.547131
1901	2026-01-14 04:30:00	4	3.64	220	561.1	t	2026-05-08 00:01:27.547131
1902	2026-01-14 04:30:00	7	1.95	220	587.7	t	2026-05-08 00:01:27.547131
1903	2026-01-14 05:00:00	1	1.53	220	364.7	t	2026-05-08 00:01:27.547131
1904	2026-01-14 05:00:00	4	2.41	220	329.1	t	2026-05-08 00:01:27.547131
1905	2026-01-14 05:00:00	7	2.23	220	516	t	2026-05-08 00:01:27.547131
1906	2026-01-14 05:30:00	1	2.15	220	601.7	t	2026-05-08 00:01:27.547131
1907	2026-01-14 05:30:00	4	1.48	220	661.5	t	2026-05-08 00:01:27.547131
1908	2026-01-14 05:30:00	7	1.42	220	349.1	t	2026-05-08 00:01:27.547131
1909	2026-01-14 06:00:00	1	3.06	220	490.7	t	2026-05-08 00:01:27.547131
1910	2026-01-14 06:00:00	4	3.14	220	528.7	t	2026-05-08 00:01:27.547131
1911	2026-01-14 06:00:00	7	1.56	220	443.7	t	2026-05-08 00:01:27.547131
1912	2026-01-14 06:30:00	1	3.3	220	490.3	t	2026-05-08 00:01:27.547131
1913	2026-01-14 06:30:00	4	2.45	220	387.5	t	2026-05-08 00:01:27.547131
1914	2026-01-14 06:30:00	7	2.3	220	573.5	t	2026-05-08 00:01:27.547131
1915	2026-01-14 07:00:00	1	14.77	220	3414.4	t	2026-05-08 00:01:27.547131
1916	2026-01-14 07:00:00	4	16.8	220	4115.1	t	2026-05-08 00:01:27.547131
1917	2026-01-14 07:00:00	7	26.65	220	6581.6	t	2026-05-08 00:01:27.547131
1918	2026-01-14 07:30:00	1	16.03	220	4088.1	t	2026-05-08 00:01:27.547131
1919	2026-01-14 07:30:00	4	18.42	220	4130.2	t	2026-05-08 00:01:27.547131
1920	2026-01-14 07:30:00	7	23.46	220	6703.4	t	2026-05-08 00:01:27.547131
1921	2026-01-14 08:00:00	1	14.03	220	4504.2	t	2026-05-08 00:01:27.547131
1922	2026-01-14 08:00:00	4	21.7	220	5614.8	t	2026-05-08 00:01:27.547131
1923	2026-01-14 08:00:00	7	22.39	220	5721.6	t	2026-05-08 00:01:27.547131
1924	2026-01-14 08:30:00	1	15.65	220	2708	t	2026-05-08 00:01:27.547131
1925	2026-01-14 08:30:00	4	24.88	220	4219.8	t	2026-05-08 00:01:27.547131
1926	2026-01-14 08:30:00	7	30	220	4628.2	t	2026-05-08 00:01:27.547131
1927	2026-01-14 09:00:00	1	12.32	220	4123.2	t	2026-05-08 00:01:27.547131
1928	2026-01-14 09:00:00	4	25.64	220	4930.5	t	2026-05-08 00:01:27.547131
1929	2026-01-14 09:00:00	7	22.89	220	6642.4	t	2026-05-08 00:01:27.547131
1930	2026-01-14 09:30:00	1	18.81	220	2570.6	t	2026-05-08 00:01:27.547131
1931	2026-01-14 09:30:00	4	22.57	220	3793.4	t	2026-05-08 00:01:27.547131
1932	2026-01-14 09:30:00	7	26.63	220	5903.3	t	2026-05-08 00:01:27.547131
1933	2026-01-14 10:00:00	1	16.44	220	2721	t	2026-05-08 00:01:27.547131
1934	2026-01-14 10:00:00	4	17.67	220	4984.2	t	2026-05-08 00:01:27.547131
1935	2026-01-14 10:00:00	7	23.58	220	5345.3	t	2026-05-08 00:01:27.547131
1936	2026-01-14 10:30:00	1	14.04	220	4617	t	2026-05-08 00:01:27.547131
1937	2026-01-14 10:30:00	4	18.58	220	3832.6	t	2026-05-08 00:01:27.547131
1938	2026-01-14 10:30:00	7	25.85	220	5771.9	t	2026-05-08 00:01:27.547131
1939	2026-01-14 11:00:00	1	12.48	220	3046.7	t	2026-05-08 00:01:27.547131
1940	2026-01-14 11:00:00	4	16.68	220	5229.8	t	2026-05-08 00:01:27.547131
1941	2026-01-14 11:00:00	7	25.47	220	5259.6	t	2026-05-08 00:01:27.547131
1942	2026-01-14 11:30:00	1	12.76	220	4087.9	t	2026-05-08 00:01:27.547131
1943	2026-01-14 11:30:00	4	16.84	220	4658.7	t	2026-05-08 00:01:27.547131
1944	2026-01-14 11:30:00	7	24.21	220	4906.5	t	2026-05-08 00:01:27.547131
1945	2026-01-14 12:00:00	1	12.12	220	2622.5	t	2026-05-08 00:01:27.547131
1946	2026-01-14 12:00:00	4	19.49	220	3882.6	t	2026-05-08 00:01:27.547131
1947	2026-01-14 12:00:00	7	26.02	220	5586.5	t	2026-05-08 00:01:27.547131
1948	2026-01-14 12:30:00	1	17.51	220	3841.7	t	2026-05-08 00:01:27.547131
1949	2026-01-14 12:30:00	4	22.97	220	4908.1	t	2026-05-08 00:01:27.547131
1950	2026-01-14 12:30:00	7	28.15	220	4745.4	t	2026-05-08 00:01:27.547131
1951	2026-01-14 13:00:00	1	21.47	220	3483.9	t	2026-05-08 00:01:27.547131
1952	2026-01-14 13:00:00	4	18.84	220	3681.2	t	2026-05-08 00:01:27.547131
1953	2026-01-14 13:00:00	7	25.68	220	5766.8	t	2026-05-08 00:01:27.547131
1954	2026-01-14 13:30:00	1	19.17	220	4087.6	t	2026-05-08 00:01:27.547131
1955	2026-01-14 13:30:00	4	22.96	220	3914.1	t	2026-05-08 00:01:27.547131
1956	2026-01-14 13:30:00	7	25.87	220	5047.4	t	2026-05-08 00:01:27.547131
1957	2026-01-14 14:00:00	1	12.69	220	2663.6	t	2026-05-08 00:01:27.547131
1958	2026-01-14 14:00:00	4	16.01	220	5099.1	t	2026-05-08 00:01:27.547131
1959	2026-01-14 14:00:00	7	26.94	220	5220	t	2026-05-08 00:01:27.547131
1960	2026-01-14 14:30:00	1	19.2	220	3823	t	2026-05-08 00:01:27.547131
1961	2026-01-14 14:30:00	4	17.38	220	4247.8	t	2026-05-08 00:01:27.547131
1962	2026-01-14 14:30:00	7	23.95	220	5195.2	t	2026-05-08 00:01:27.547131
1963	2026-01-14 15:00:00	1	14.64	220	3272.6	t	2026-05-08 00:01:27.547131
1964	2026-01-14 15:00:00	4	20.56	220	5449.2	t	2026-05-08 00:01:27.547131
1965	2026-01-14 15:00:00	7	26.54	220	5017.4	t	2026-05-08 00:01:27.547131
1966	2026-01-14 15:30:00	1	20.53	220	3625.7	t	2026-05-08 00:01:27.547131
1967	2026-01-14 15:30:00	4	18.76	220	5308.1	t	2026-05-08 00:01:27.547131
1968	2026-01-14 15:30:00	7	25.76	220	6193	t	2026-05-08 00:01:27.547131
1969	2026-01-14 16:00:00	1	21.06	220	4181.9	t	2026-05-08 00:01:27.547131
1970	2026-01-14 16:00:00	4	19.79	220	4611.1	t	2026-05-08 00:01:27.547131
1971	2026-01-14 16:00:00	7	26.97	220	5779.5	t	2026-05-08 00:01:27.547131
1972	2026-01-14 16:30:00	1	16.75	220	3015.6	t	2026-05-08 00:01:27.547131
1973	2026-01-14 16:30:00	4	21.2	220	5091.3	t	2026-05-08 00:01:27.547131
1974	2026-01-14 16:30:00	7	26.18	220	5894.3	t	2026-05-08 00:01:27.547131
1975	2026-01-14 17:00:00	1	13.83	220	4373.1	t	2026-05-08 00:01:27.547131
1976	2026-01-14 17:00:00	4	20.65	220	3770.2	t	2026-05-08 00:01:27.547131
1977	2026-01-14 17:00:00	7	22.45	220	6700.5	t	2026-05-08 00:01:27.547131
1978	2026-01-14 17:30:00	1	18.36	220	3127.2	t	2026-05-08 00:01:27.547131
1979	2026-01-14 17:30:00	4	19.59	220	4806.2	t	2026-05-08 00:01:27.547131
1980	2026-01-14 17:30:00	7	27.01	220	6380.6	t	2026-05-08 00:01:27.547131
1981	2026-01-14 18:00:00	1	12.03	220	3364.6	t	2026-05-08 00:01:27.547131
1982	2026-01-14 18:00:00	4	17.71	220	4368.7	t	2026-05-08 00:01:27.547131
1983	2026-01-14 18:00:00	7	26.87	220	4540.9	t	2026-05-08 00:01:27.547131
1984	2026-01-14 18:30:00	1	18.31	220	2705.8	t	2026-05-08 00:01:27.547131
1985	2026-01-14 18:30:00	4	25.66	220	3657.7	t	2026-05-08 00:01:27.547131
1986	2026-01-14 18:30:00	7	26.9	220	5080.3	t	2026-05-08 00:01:27.547131
1987	2026-01-14 19:00:00	1	18.76	220	3012.4	t	2026-05-08 00:01:27.547131
1988	2026-01-14 19:00:00	4	21.64	220	3771.5	t	2026-05-08 00:01:27.547131
1989	2026-01-14 19:00:00	7	21.29	220	6522.3	t	2026-05-08 00:01:27.547131
1990	2026-01-14 19:30:00	1	15.75	220	2912.8	t	2026-05-08 00:01:27.547131
1991	2026-01-14 19:30:00	4	22.75	220	5525.4	t	2026-05-08 00:01:27.547131
1992	2026-01-14 19:30:00	7	23.02	220	5928.4	t	2026-05-08 00:01:27.547131
1993	2026-01-14 20:00:00	1	2.43	220	421.9	t	2026-05-08 00:01:27.547131
1994	2026-01-14 20:00:00	4	2.12	220	617.1	t	2026-05-08 00:01:27.547131
1995	2026-01-14 20:00:00	7	2.11	220	772.6	t	2026-05-08 00:01:27.547131
1996	2026-01-14 20:30:00	1	2.04	220	619.2	t	2026-05-08 00:01:27.547131
1997	2026-01-14 20:30:00	4	2.01	220	679.9	t	2026-05-08 00:01:27.547131
1998	2026-01-14 20:30:00	7	1.63	220	288.3	t	2026-05-08 00:01:27.547131
1999	2026-01-14 21:00:00	1	1.78	220	799.3	t	2026-05-08 00:01:27.547131
2000	2026-01-14 21:00:00	4	2.41	220	384.3	t	2026-05-08 00:01:27.547131
2001	2026-01-14 21:00:00	7	2.02	220	704.9	t	2026-05-08 00:01:27.547131
2002	2026-01-14 21:30:00	1	3.59	220	459.2	t	2026-05-08 00:01:27.547131
2003	2026-01-14 21:30:00	4	1.3	220	373.2	t	2026-05-08 00:01:27.547131
2004	2026-01-14 21:30:00	7	1.74	220	804	t	2026-05-08 00:01:27.547131
2005	2026-01-14 22:00:00	1	1.7	220	744.2	t	2026-05-08 00:01:27.547131
2006	2026-01-14 22:00:00	4	1.88	220	721.2	t	2026-05-08 00:01:27.547131
2007	2026-01-14 22:00:00	7	3.32	220	657.1	t	2026-05-08 00:01:27.547131
2008	2026-01-14 22:30:00	1	1.61	220	333.8	t	2026-05-08 00:01:27.547131
2009	2026-01-14 22:30:00	4	2.05	220	645.2	t	2026-05-08 00:01:27.547131
2010	2026-01-14 22:30:00	7	2.84	220	330.9	t	2026-05-08 00:01:27.547131
2011	2026-01-14 23:00:00	1	1.63	220	343.1	t	2026-05-08 00:01:27.547131
2012	2026-01-14 23:00:00	4	1.73	220	357.1	t	2026-05-08 00:01:27.547131
2013	2026-01-14 23:00:00	7	3.28	220	307.7	t	2026-05-08 00:01:27.547131
2014	2026-01-14 23:30:00	1	1.35	220	683.2	t	2026-05-08 00:01:27.547131
2015	2026-01-14 23:30:00	4	1.77	220	721.9	t	2026-05-08 00:01:27.547131
2016	2026-01-14 23:30:00	7	1.73	220	547.8	t	2026-05-08 00:01:27.547131
2017	2026-01-15 00:00:00	1	2.15	220	277.5	t	2026-05-08 00:01:27.547131
2018	2026-01-15 00:00:00	4	1.66	220	755.4	t	2026-05-08 00:01:27.547131
2019	2026-01-15 00:00:00	7	2.65	220	639.3	t	2026-05-08 00:01:27.547131
2020	2026-01-15 00:30:00	1	3.19	220	413.2	t	2026-05-08 00:01:27.547131
2021	2026-01-15 00:30:00	4	2.15	220	268.9	t	2026-05-08 00:01:27.547131
2022	2026-01-15 00:30:00	7	1.48	220	415.5	t	2026-05-08 00:01:27.547131
2023	2026-01-15 01:00:00	1	3.57	220	682.4	t	2026-05-08 00:01:27.547131
2024	2026-01-15 01:00:00	4	1.77	220	693.5	t	2026-05-08 00:01:27.547131
2025	2026-01-15 01:00:00	7	2.75	220	609	t	2026-05-08 00:01:27.547131
2026	2026-01-15 01:30:00	1	3.1	220	397.4	t	2026-05-08 00:01:27.547131
2027	2026-01-15 01:30:00	4	2.24	220	275.8	t	2026-05-08 00:01:27.547131
2028	2026-01-15 01:30:00	7	2.63	220	701.9	t	2026-05-08 00:01:27.547131
2029	2026-01-15 02:00:00	1	3.56	220	796.9	t	2026-05-08 00:01:27.547131
2030	2026-01-15 02:00:00	4	2.76	220	497.4	t	2026-05-08 00:01:27.547131
2031	2026-01-15 02:00:00	7	2.1	220	404.6	t	2026-05-08 00:01:27.547131
2032	2026-01-15 02:30:00	1	3.34	220	436.3	t	2026-05-08 00:01:27.547131
2033	2026-01-15 02:30:00	4	1.64	220	277.8	t	2026-05-08 00:01:27.547131
2034	2026-01-15 02:30:00	7	3.7	220	390.6	t	2026-05-08 00:01:27.547131
2035	2026-01-15 03:00:00	1	3.17	220	332.5	t	2026-05-08 00:01:27.547131
2036	2026-01-15 03:00:00	4	3.06	220	559.4	t	2026-05-08 00:01:27.547131
2037	2026-01-15 03:00:00	7	2.21	220	492.5	t	2026-05-08 00:01:27.547131
2038	2026-01-15 03:30:00	1	2.97	220	801.1	t	2026-05-08 00:01:27.547131
2039	2026-01-15 03:30:00	4	3.27	220	488.9	t	2026-05-08 00:01:27.547131
2040	2026-01-15 03:30:00	7	2.05	220	494	t	2026-05-08 00:01:27.547131
2041	2026-01-15 04:00:00	1	2.1	220	364	t	2026-05-08 00:01:27.547131
2042	2026-01-15 04:00:00	4	2.51	220	398.7	t	2026-05-08 00:01:27.547131
2043	2026-01-15 04:00:00	7	1.33	220	669.9	t	2026-05-08 00:01:27.547131
2044	2026-01-15 04:30:00	1	1.59	220	716	t	2026-05-08 00:01:27.547131
2045	2026-01-15 04:30:00	4	2.48	220	497.1	t	2026-05-08 00:01:27.547131
2046	2026-01-15 04:30:00	7	2.05	220	452.8	t	2026-05-08 00:01:27.547131
2047	2026-01-15 05:00:00	1	2.7	220	398	t	2026-05-08 00:01:27.547131
2048	2026-01-15 05:00:00	4	1.29	220	800.2	t	2026-05-08 00:01:27.547131
2049	2026-01-15 05:00:00	7	1.71	220	626.6	t	2026-05-08 00:01:27.547131
2050	2026-01-15 05:30:00	1	1.75	220	407.8	t	2026-05-08 00:01:27.547131
2051	2026-01-15 05:30:00	4	1.53	220	607.7	t	2026-05-08 00:01:27.547131
2052	2026-01-15 05:30:00	7	3.54	220	276.2	t	2026-05-08 00:01:27.547131
2053	2026-01-15 06:00:00	1	3.11	220	539.8	t	2026-05-08 00:01:27.547131
2054	2026-01-15 06:00:00	4	3.53	220	437	t	2026-05-08 00:01:27.547131
2055	2026-01-15 06:00:00	7	1.76	220	349.1	t	2026-05-08 00:01:27.547131
2056	2026-01-15 06:30:00	1	1.26	220	488.6	t	2026-05-08 00:01:27.547131
2057	2026-01-15 06:30:00	4	3.28	220	303.8	t	2026-05-08 00:01:27.547131
2058	2026-01-15 06:30:00	7	2.76	220	503.7	t	2026-05-08 00:01:27.547131
2059	2026-01-15 07:00:00	1	12.79	220	2563	t	2026-05-08 00:01:27.547131
2060	2026-01-15 07:00:00	4	23.67	220	3620.8	t	2026-05-08 00:01:27.547131
2061	2026-01-15 07:00:00	7	25.85	220	5545.6	t	2026-05-08 00:01:27.547131
2062	2026-01-15 07:30:00	1	16.83	220	3393.9	t	2026-05-08 00:01:27.547131
2063	2026-01-15 07:30:00	4	23.69	220	4131.5	t	2026-05-08 00:01:27.547131
2064	2026-01-15 07:30:00	7	25.18	220	5783.5	t	2026-05-08 00:01:27.547131
2065	2026-01-15 08:00:00	1	17.44	220	4462.6	t	2026-05-08 00:01:27.547131
2066	2026-01-15 08:00:00	4	24.99	220	4723.5	t	2026-05-08 00:01:27.547131
2067	2026-01-15 08:00:00	7	24.45	220	4938.2	t	2026-05-08 00:01:27.547131
2068	2026-01-15 08:30:00	1	19.84	220	4623.6	t	2026-05-08 00:01:27.547131
2069	2026-01-15 08:30:00	4	19.34	220	5641.4	t	2026-05-08 00:01:27.547131
2070	2026-01-15 08:30:00	7	22.58	220	4817	t	2026-05-08 00:01:27.547131
2071	2026-01-15 09:00:00	1	20.66	220	2929.6	t	2026-05-08 00:01:27.547131
2072	2026-01-15 09:00:00	4	22.14	220	5456.6	t	2026-05-08 00:01:27.547131
2073	2026-01-15 09:00:00	7	23.65	220	6632.3	t	2026-05-08 00:01:27.547131
2074	2026-01-15 09:30:00	1	12.17	220	2654.1	t	2026-05-08 00:01:27.547131
2075	2026-01-15 09:30:00	4	25.8	220	4870.2	t	2026-05-08 00:01:27.547131
2076	2026-01-15 09:30:00	7	30.02	220	6665.5	t	2026-05-08 00:01:27.547131
2077	2026-01-15 10:00:00	1	18.93	220	4146.3	t	2026-05-08 00:01:27.547131
2078	2026-01-15 10:00:00	4	20.27	220	3748.8	t	2026-05-08 00:01:27.547131
2079	2026-01-15 10:00:00	7	24.62	220	6505.4	t	2026-05-08 00:01:27.547131
2080	2026-01-15 10:30:00	1	14.35	220	2543.5	t	2026-05-08 00:01:27.547131
2081	2026-01-15 10:30:00	4	24.95	220	4416.9	t	2026-05-08 00:01:27.547131
2082	2026-01-15 10:30:00	7	20.58	220	6036.2	t	2026-05-08 00:01:27.547131
2083	2026-01-15 11:00:00	1	17.47	220	3227.8	t	2026-05-08 00:01:27.547131
2084	2026-01-15 11:00:00	4	21.63	220	4879.9	t	2026-05-08 00:01:27.547131
2085	2026-01-15 11:00:00	7	26.34	220	6298.3	t	2026-05-08 00:01:27.547131
2086	2026-01-15 11:30:00	1	20.82	220	4299.6	t	2026-05-08 00:01:27.547131
2087	2026-01-15 11:30:00	4	22.42	220	3569.6	t	2026-05-08 00:01:27.547131
2088	2026-01-15 11:30:00	7	28.46	220	5566.8	t	2026-05-08 00:01:27.547131
2089	2026-01-15 12:00:00	1	16.45	220	4026.5	t	2026-05-08 00:01:27.547131
2090	2026-01-15 12:00:00	4	18.76	220	5112.7	t	2026-05-08 00:01:27.547131
2091	2026-01-15 12:00:00	7	27.07	220	5026	t	2026-05-08 00:01:27.547131
2092	2026-01-15 12:30:00	1	14.64	220	3369.8	t	2026-05-08 00:01:27.547131
2093	2026-01-15 12:30:00	4	22.53	220	4580.6	t	2026-05-08 00:01:27.547131
2094	2026-01-15 12:30:00	7	20.9	220	5061.4	t	2026-05-08 00:01:27.547131
2095	2026-01-15 13:00:00	1	11.64	220	2720.6	t	2026-05-08 00:01:27.547131
2096	2026-01-15 13:00:00	4	18.11	220	3834.5	t	2026-05-08 00:01:27.547131
2097	2026-01-15 13:00:00	7	22.91	220	5788.4	t	2026-05-08 00:01:27.547131
2098	2026-01-15 13:30:00	1	11.85	220	3426.4	t	2026-05-08 00:01:27.547131
2099	2026-01-15 13:30:00	4	19.33	220	4908.5	t	2026-05-08 00:01:27.547131
2100	2026-01-15 13:30:00	7	21.12	220	4668	t	2026-05-08 00:01:27.547131
2101	2026-01-15 14:00:00	1	20.67	220	4271.8	t	2026-05-08 00:01:27.547131
2102	2026-01-15 14:00:00	4	24.02	220	4218	t	2026-05-08 00:01:27.547131
2103	2026-01-15 14:00:00	7	28.81	220	6228.1	t	2026-05-08 00:01:27.547131
2104	2026-01-15 14:30:00	1	16.69	220	4066.3	t	2026-05-08 00:01:27.547131
2105	2026-01-15 14:30:00	4	20.12	220	3854.2	t	2026-05-08 00:01:27.547131
2106	2026-01-15 14:30:00	7	30.48	220	6239.7	t	2026-05-08 00:01:27.547131
2107	2026-01-15 15:00:00	1	21.22	220	4098.3	t	2026-05-08 00:01:27.547131
2108	2026-01-15 15:00:00	4	22.95	220	4171.1	t	2026-05-08 00:01:27.547131
2109	2026-01-15 15:00:00	7	24.03	220	6192.4	t	2026-05-08 00:01:27.547131
2110	2026-01-15 15:30:00	1	14.46	220	3183.7	t	2026-05-08 00:01:27.547131
2111	2026-01-15 15:30:00	4	16.83	220	4620.2	t	2026-05-08 00:01:27.547131
2112	2026-01-15 15:30:00	7	26.91	220	6703	t	2026-05-08 00:01:27.547131
2113	2026-01-15 16:00:00	1	15.14	220	3315	t	2026-05-08 00:01:27.547131
2114	2026-01-15 16:00:00	4	19.98	220	4479	t	2026-05-08 00:01:27.547131
2115	2026-01-15 16:00:00	7	25.78	220	4659.9	t	2026-05-08 00:01:27.547131
2116	2026-01-15 16:30:00	1	19.32	220	3668	t	2026-05-08 00:01:27.547131
2117	2026-01-15 16:30:00	4	17.28	220	5014.3	t	2026-05-08 00:01:27.547131
2118	2026-01-15 16:30:00	7	30.37	220	4838.2	t	2026-05-08 00:01:27.547131
2119	2026-01-15 17:00:00	1	17.21	220	4119.2	t	2026-05-08 00:01:27.547131
2120	2026-01-15 17:00:00	4	19.4	220	4579.8	t	2026-05-08 00:01:27.547131
2121	2026-01-15 17:00:00	7	27.52	220	5580.2	t	2026-05-08 00:01:27.547131
2122	2026-01-15 17:30:00	1	17.63	220	3574.9	t	2026-05-08 00:01:27.547131
2123	2026-01-15 17:30:00	4	23.33	220	5397.4	t	2026-05-08 00:01:27.547131
2124	2026-01-15 17:30:00	7	21.63	220	5666	t	2026-05-08 00:01:27.547131
2125	2026-01-15 18:00:00	1	13.18	220	4534.3	t	2026-05-08 00:01:27.547131
2126	2026-01-15 18:00:00	4	22.7	220	5334.9	t	2026-05-08 00:01:27.547131
2127	2026-01-15 18:00:00	7	29.12	220	4977.8	t	2026-05-08 00:01:27.547131
2128	2026-01-15 18:30:00	1	12.17	220	3412	t	2026-05-08 00:01:27.547131
2129	2026-01-15 18:30:00	4	25.81	220	5644.6	t	2026-05-08 00:01:27.547131
2130	2026-01-15 18:30:00	7	22.53	220	6258	t	2026-05-08 00:01:27.547131
2131	2026-01-15 19:00:00	1	17	220	3489.2	t	2026-05-08 00:01:27.547131
2132	2026-01-15 19:00:00	4	18.18	220	3586.2	t	2026-05-08 00:01:27.547131
2133	2026-01-15 19:00:00	7	22.5	220	6274.5	t	2026-05-08 00:01:27.547131
2134	2026-01-15 19:30:00	1	21	220	4144.3	t	2026-05-08 00:01:27.547131
2135	2026-01-15 19:30:00	4	22.2	220	5211.3	t	2026-05-08 00:01:27.547131
2136	2026-01-15 19:30:00	7	26.2	220	5597.1	t	2026-05-08 00:01:27.547131
2137	2026-01-15 20:00:00	1	2.09	220	685.1	t	2026-05-08 00:01:27.547131
2138	2026-01-15 20:00:00	4	1.48	220	711	t	2026-05-08 00:01:27.547131
2139	2026-01-15 20:00:00	7	2.43	220	337.5	t	2026-05-08 00:01:27.547131
2140	2026-01-15 20:30:00	1	1.58	220	765.6	t	2026-05-08 00:01:27.547131
2141	2026-01-15 20:30:00	4	2.93	220	753.8	t	2026-05-08 00:01:27.547131
2142	2026-01-15 20:30:00	7	2.28	220	615.3	t	2026-05-08 00:01:27.547131
2143	2026-01-15 21:00:00	1	1.85	220	415.1	t	2026-05-08 00:01:27.547131
2144	2026-01-15 21:00:00	4	3.55	220	296.9	t	2026-05-08 00:01:27.547131
2145	2026-01-15 21:00:00	7	1.65	220	340.9	t	2026-05-08 00:01:27.547131
2146	2026-01-15 21:30:00	1	1.57	220	781.3	t	2026-05-08 00:01:27.547131
2147	2026-01-15 21:30:00	4	2.7	220	723.7	t	2026-05-08 00:01:27.547131
2148	2026-01-15 21:30:00	7	1.84	220	373.9	t	2026-05-08 00:01:27.547131
2149	2026-01-15 22:00:00	1	2.94	220	459.4	t	2026-05-08 00:01:27.547131
2150	2026-01-15 22:00:00	4	1.65	220	343.5	t	2026-05-08 00:01:27.547131
2151	2026-01-15 22:00:00	7	1.78	220	359.7	t	2026-05-08 00:01:27.547131
2152	2026-01-15 22:30:00	1	2.92	220	436.6	t	2026-05-08 00:01:27.547131
2153	2026-01-15 22:30:00	4	2.2	220	791.6	t	2026-05-08 00:01:27.547131
2154	2026-01-15 22:30:00	7	3.41	220	777.8	t	2026-05-08 00:01:27.547131
2155	2026-01-15 23:00:00	1	2.34	220	739.9	t	2026-05-08 00:01:27.547131
2156	2026-01-15 23:00:00	4	1.82	220	692.9	t	2026-05-08 00:01:27.547131
2157	2026-01-15 23:00:00	7	1.41	220	794.6	t	2026-05-08 00:01:27.547131
2158	2026-01-15 23:30:00	1	2.34	220	323.5	t	2026-05-08 00:01:27.547131
2159	2026-01-15 23:30:00	4	2.44	220	774.2	t	2026-05-08 00:01:27.547131
2160	2026-01-15 23:30:00	7	1.91	220	356.4	t	2026-05-08 00:01:27.547131
2161	2026-01-16 00:00:00	1	1.91	220	739.3	t	2026-05-08 00:01:27.547131
2162	2026-01-16 00:00:00	4	2.25	220	672.9	t	2026-05-08 00:01:27.547131
2163	2026-01-16 00:00:00	7	1.31	220	655.6	t	2026-05-08 00:01:27.547131
2164	2026-01-16 00:30:00	1	3.11	220	722.2	t	2026-05-08 00:01:27.547131
2165	2026-01-16 00:30:00	4	2.96	220	333.9	t	2026-05-08 00:01:27.547131
2166	2026-01-16 00:30:00	7	1.95	220	399.5	t	2026-05-08 00:01:27.547131
2167	2026-01-16 01:00:00	1	1.33	220	790.2	t	2026-05-08 00:01:27.547131
2168	2026-01-16 01:00:00	4	3.53	220	751.9	t	2026-05-08 00:01:27.547131
2169	2026-01-16 01:00:00	7	2.02	220	316	t	2026-05-08 00:01:27.547131
2170	2026-01-16 01:30:00	1	1.2	220	359.4	t	2026-05-08 00:01:27.547131
2171	2026-01-16 01:30:00	4	1.37	220	593.8	t	2026-05-08 00:01:27.547131
2172	2026-01-16 01:30:00	7	2.61	220	349.8	t	2026-05-08 00:01:27.547131
2173	2026-01-16 02:00:00	1	2.97	220	532.3	t	2026-05-08 00:01:27.547131
2174	2026-01-16 02:00:00	4	2.09	220	333.8	t	2026-05-08 00:01:27.547131
2175	2026-01-16 02:00:00	7	1.61	220	424.2	t	2026-05-08 00:01:27.547131
2176	2026-01-16 02:30:00	1	1.64	220	759.3	t	2026-05-08 00:01:27.547131
2177	2026-01-16 02:30:00	4	1.74	220	366.5	t	2026-05-08 00:01:27.547131
2178	2026-01-16 02:30:00	7	1.74	220	530.3	t	2026-05-08 00:01:27.547131
2179	2026-01-16 03:00:00	1	3.13	220	716.9	t	2026-05-08 00:01:27.547131
2180	2026-01-16 03:00:00	4	3.23	220	553.6	t	2026-05-08 00:01:27.547131
2181	2026-01-16 03:00:00	7	2.94	220	295.2	t	2026-05-08 00:01:27.547131
2182	2026-01-16 03:30:00	1	2.86	220	760.1	t	2026-05-08 00:01:27.547131
2183	2026-01-16 03:30:00	4	1.8	220	737.1	t	2026-05-08 00:01:27.547131
2184	2026-01-16 03:30:00	7	1.21	220	528.9	t	2026-05-08 00:01:27.547131
2185	2026-01-16 04:00:00	1	1.47	220	813.8	t	2026-05-08 00:01:27.547131
2186	2026-01-16 04:00:00	4	3.43	220	425	t	2026-05-08 00:01:27.547131
2187	2026-01-16 04:00:00	7	3.22	220	600.5	t	2026-05-08 00:01:27.547131
2188	2026-01-16 04:30:00	1	2.12	220	751.4	t	2026-05-08 00:01:27.547131
2189	2026-01-16 04:30:00	4	3.27	220	436.6	t	2026-05-08 00:01:27.547131
2190	2026-01-16 04:30:00	7	3.39	220	433.9	t	2026-05-08 00:01:27.547131
2191	2026-01-16 05:00:00	1	3.26	220	602.5	t	2026-05-08 00:01:27.547131
2192	2026-01-16 05:00:00	4	2.93	220	386.8	t	2026-05-08 00:01:27.547131
2193	2026-01-16 05:00:00	7	3.21	220	565	t	2026-05-08 00:01:27.547131
2194	2026-01-16 05:30:00	1	3.3	220	456.6	t	2026-05-08 00:01:27.547131
2195	2026-01-16 05:30:00	4	1.65	220	682.1	t	2026-05-08 00:01:27.547131
2196	2026-01-16 05:30:00	7	2.23	220	747.5	t	2026-05-08 00:01:27.547131
2197	2026-01-16 06:00:00	1	1.84	220	296.2	t	2026-05-08 00:01:27.547131
2198	2026-01-16 06:00:00	4	1.35	220	773.3	t	2026-05-08 00:01:27.547131
2199	2026-01-16 06:00:00	7	1.65	220	625.9	t	2026-05-08 00:01:27.547131
2200	2026-01-16 06:30:00	1	1.79	220	756.1	t	2026-05-08 00:01:27.547131
2201	2026-01-16 06:30:00	4	3.52	220	634	t	2026-05-08 00:01:27.547131
2202	2026-01-16 06:30:00	7	3.53	220	287.8	t	2026-05-08 00:01:27.547131
2203	2026-01-16 07:00:00	1	17.2	220	2942.8	t	2026-05-08 00:01:27.547131
2204	2026-01-16 07:00:00	4	16.23	220	5076.7	t	2026-05-08 00:01:27.547131
2205	2026-01-16 07:00:00	7	26.63	220	6592.1	t	2026-05-08 00:01:27.547131
2206	2026-01-16 07:30:00	1	15.34	220	4472.9	t	2026-05-08 00:01:27.547131
2207	2026-01-16 07:30:00	4	17.49	220	5154.3	t	2026-05-08 00:01:27.547131
2208	2026-01-16 07:30:00	7	30.33	220	5038.6	t	2026-05-08 00:01:27.547131
2209	2026-01-16 08:00:00	1	16.93	220	3825.7	t	2026-05-08 00:01:27.547131
2210	2026-01-16 08:00:00	4	21.73	220	3917.9	t	2026-05-08 00:01:27.547131
2211	2026-01-16 08:00:00	7	30.3	220	5052.5	t	2026-05-08 00:01:27.547131
2212	2026-01-16 08:30:00	1	13.86	220	2774.3	t	2026-05-08 00:01:27.547131
2213	2026-01-16 08:30:00	4	24.78	220	3581.6	t	2026-05-08 00:01:27.547131
2214	2026-01-16 08:30:00	7	25.8	220	6006.8	t	2026-05-08 00:01:27.547131
2215	2026-01-16 09:00:00	1	16.66	220	3995.6	t	2026-05-08 00:01:27.547131
2216	2026-01-16 09:00:00	4	19.97	220	4119.3	t	2026-05-08 00:01:27.547131
2217	2026-01-16 09:00:00	7	26.99	220	5973.3	t	2026-05-08 00:01:27.547131
2218	2026-01-16 09:30:00	1	21.37	220	4265.3	t	2026-05-08 00:01:27.547131
2219	2026-01-16 09:30:00	4	23.4	220	4428.1	t	2026-05-08 00:01:27.547131
2220	2026-01-16 09:30:00	7	22.75	220	5735.1	t	2026-05-08 00:01:27.547131
2221	2026-01-16 10:00:00	1	14.88	220	4012.4	t	2026-05-08 00:01:27.547131
2222	2026-01-16 10:00:00	4	19.97	220	4186.5	t	2026-05-08 00:01:27.547131
2223	2026-01-16 10:00:00	7	27.17	220	5564.4	t	2026-05-08 00:01:27.547131
2224	2026-01-16 10:30:00	1	18.79	220	3620.9	t	2026-05-08 00:01:27.547131
2225	2026-01-16 10:30:00	4	18.06	220	4659.8	t	2026-05-08 00:01:27.547131
2226	2026-01-16 10:30:00	7	25.67	220	6465.7	t	2026-05-08 00:01:27.547131
2227	2026-01-16 11:00:00	1	11.86	220	3792.5	t	2026-05-08 00:01:27.547131
2228	2026-01-16 11:00:00	4	17.94	220	4695.3	t	2026-05-08 00:01:27.547131
2229	2026-01-16 11:00:00	7	29.45	220	5200.6	t	2026-05-08 00:01:27.547131
2230	2026-01-16 11:30:00	1	18.96	220	3873	t	2026-05-08 00:01:27.547131
2231	2026-01-16 11:30:00	4	19.49	220	3895.6	t	2026-05-08 00:01:27.547131
2232	2026-01-16 11:30:00	7	21.44	220	5953.8	t	2026-05-08 00:01:27.547131
2233	2026-01-16 12:00:00	1	20.84	220	3194.4	t	2026-05-08 00:01:27.547131
2234	2026-01-16 12:00:00	4	21.72	220	5000.5	t	2026-05-08 00:01:27.547131
2235	2026-01-16 12:00:00	7	23.63	220	6450.2	t	2026-05-08 00:01:27.547131
2236	2026-01-16 12:30:00	1	17.41	220	4144.7	t	2026-05-08 00:01:27.547131
2237	2026-01-16 12:30:00	4	16.64	220	4367.9	t	2026-05-08 00:01:27.547131
2238	2026-01-16 12:30:00	7	25.05	220	6479.5	t	2026-05-08 00:01:27.547131
2239	2026-01-16 13:00:00	1	18.29	220	3663.1	t	2026-05-08 00:01:27.547131
2240	2026-01-16 13:00:00	4	20.53	220	4643.4	t	2026-05-08 00:01:27.547131
2241	2026-01-16 13:00:00	7	26.46	220	5775.2	t	2026-05-08 00:01:27.547131
2242	2026-01-16 13:30:00	1	21.43	220	3606.6	t	2026-05-08 00:01:27.547131
2243	2026-01-16 13:30:00	4	18.97	220	5023.6	t	2026-05-08 00:01:27.547131
2244	2026-01-16 13:30:00	7	21.68	220	5908.8	t	2026-05-08 00:01:27.547131
2245	2026-01-16 14:00:00	1	18.6	220	4524.1	t	2026-05-08 00:01:27.547131
2246	2026-01-16 14:00:00	4	19	220	4040.8	t	2026-05-08 00:01:27.547131
2247	2026-01-16 14:00:00	7	24.53	220	5058.6	t	2026-05-08 00:01:27.547131
2248	2026-01-16 14:30:00	1	19.92	220	3045	t	2026-05-08 00:01:27.547131
2249	2026-01-16 14:30:00	4	19.62	220	4454	t	2026-05-08 00:01:27.547131
2250	2026-01-16 14:30:00	7	23.08	220	4846.1	t	2026-05-08 00:01:27.547131
2251	2026-01-16 15:00:00	1	20.91	220	3530.6	t	2026-05-08 00:01:27.547131
2252	2026-01-16 15:00:00	4	25.53	220	4984	t	2026-05-08 00:01:27.547131
2253	2026-01-16 15:00:00	7	26.57	220	6062.9	t	2026-05-08 00:01:27.547131
2254	2026-01-16 15:30:00	1	12.34	220	3041.4	t	2026-05-08 00:01:27.547131
2255	2026-01-16 15:30:00	4	19.13	220	4576.7	t	2026-05-08 00:01:27.547131
2256	2026-01-16 15:30:00	7	29.33	220	6289.7	t	2026-05-08 00:01:27.547131
2257	2026-01-16 16:00:00	1	11.66	220	2601.4	t	2026-05-08 00:01:27.547131
2258	2026-01-16 16:00:00	4	17.13	220	5237.1	t	2026-05-08 00:01:27.547131
2259	2026-01-16 16:00:00	7	25.72	220	5336.1	t	2026-05-08 00:01:27.547131
2260	2026-01-16 16:30:00	1	12.25	220	4616.7	t	2026-05-08 00:01:27.547131
2261	2026-01-16 16:30:00	4	24.59	220	5084.9	t	2026-05-08 00:01:27.547131
2262	2026-01-16 16:30:00	7	26.19	220	5003.5	t	2026-05-08 00:01:27.547131
2263	2026-01-16 17:00:00	1	16.61	220	3084.7	t	2026-05-08 00:01:27.547131
2264	2026-01-16 17:00:00	4	25.39	220	4837.5	t	2026-05-08 00:01:27.547131
2265	2026-01-16 17:00:00	7	21.5	220	5502.3	t	2026-05-08 00:01:27.547131
2266	2026-01-16 17:30:00	1	12.43	220	3221.9	t	2026-05-08 00:01:27.547131
2267	2026-01-16 17:30:00	4	23.3	220	4904.1	t	2026-05-08 00:01:27.547131
2268	2026-01-16 17:30:00	7	27.41	220	6643.2	t	2026-05-08 00:01:27.547131
2269	2026-01-16 18:00:00	1	21.13	220	3189.3	t	2026-05-08 00:01:27.547131
2270	2026-01-16 18:00:00	4	18.08	220	4339.1	t	2026-05-08 00:01:27.547131
2271	2026-01-16 18:00:00	7	21.8	220	6209.5	t	2026-05-08 00:01:27.547131
2272	2026-01-16 18:30:00	1	16.78	220	2607.5	t	2026-05-08 00:01:27.547131
2273	2026-01-16 18:30:00	4	22.88	220	4028.5	t	2026-05-08 00:01:27.547131
2274	2026-01-16 18:30:00	7	27.64	220	5795.2	t	2026-05-08 00:01:27.547131
2275	2026-01-16 19:00:00	1	19.7	220	3444.5	t	2026-05-08 00:01:27.547131
2276	2026-01-16 19:00:00	4	18.56	220	4106.8	t	2026-05-08 00:01:27.547131
2277	2026-01-16 19:00:00	7	23.24	220	6305.8	t	2026-05-08 00:01:27.547131
2278	2026-01-16 19:30:00	1	20.44	220	3297.4	t	2026-05-08 00:01:27.547131
2279	2026-01-16 19:30:00	4	18.16	220	3953.5	t	2026-05-08 00:01:27.547131
2280	2026-01-16 19:30:00	7	21.53	220	4978.7	t	2026-05-08 00:01:27.547131
2281	2026-01-16 20:00:00	1	3.22	220	710.7	t	2026-05-08 00:01:27.547131
2282	2026-01-16 20:00:00	4	3.61	220	605	t	2026-05-08 00:01:27.547131
2283	2026-01-16 20:00:00	7	2.07	220	544.4	t	2026-05-08 00:01:27.547131
2284	2026-01-16 20:30:00	1	2.26	220	596.1	t	2026-05-08 00:01:27.547131
2285	2026-01-16 20:30:00	4	1.71	220	678.3	t	2026-05-08 00:01:27.547131
2286	2026-01-16 20:30:00	7	2.03	220	558	t	2026-05-08 00:01:27.547131
2287	2026-01-16 21:00:00	1	1.52	220	405.9	t	2026-05-08 00:01:27.547131
2288	2026-01-16 21:00:00	4	3.42	220	609.9	t	2026-05-08 00:01:27.547131
2289	2026-01-16 21:00:00	7	2.74	220	698.1	t	2026-05-08 00:01:27.547131
2290	2026-01-16 21:30:00	1	1.97	220	520.6	t	2026-05-08 00:01:27.547131
2291	2026-01-16 21:30:00	4	3.16	220	410.5	t	2026-05-08 00:01:27.547131
2292	2026-01-16 21:30:00	7	3.02	220	689.7	t	2026-05-08 00:01:27.547131
2293	2026-01-16 22:00:00	1	3.03	220	744.2	t	2026-05-08 00:01:27.547131
2294	2026-01-16 22:00:00	4	3.19	220	710.9	t	2026-05-08 00:01:27.547131
2295	2026-01-16 22:00:00	7	2.54	220	581.1	t	2026-05-08 00:01:27.547131
2296	2026-01-16 22:30:00	1	2.26	220	594.8	t	2026-05-08 00:01:27.547131
2297	2026-01-16 22:30:00	4	3.64	220	785.2	t	2026-05-08 00:01:27.547131
2298	2026-01-16 22:30:00	7	1.64	220	698.7	t	2026-05-08 00:01:27.547131
2299	2026-01-16 23:00:00	1	2.19	220	386.2	t	2026-05-08 00:01:27.547131
2300	2026-01-16 23:00:00	4	3.22	220	388.3	t	2026-05-08 00:01:27.547131
2301	2026-01-16 23:00:00	7	3.39	220	718.8	t	2026-05-08 00:01:27.547131
2302	2026-01-16 23:30:00	1	2.48	220	401	t	2026-05-08 00:01:27.547131
2303	2026-01-16 23:30:00	4	2.82	220	678.7	t	2026-05-08 00:01:27.547131
2304	2026-01-16 23:30:00	7	1.98	220	745.7	t	2026-05-08 00:01:27.547131
2305	2026-01-17 00:00:00	1	2.91	220	641.7	t	2026-05-08 00:01:27.547131
2306	2026-01-17 00:00:00	4	2.03	220	476.8	t	2026-05-08 00:01:27.547131
2307	2026-01-17 00:00:00	7	2.32	220	508.6	t	2026-05-08 00:01:27.547131
2308	2026-01-17 00:30:00	1	1.23	220	487.5	t	2026-05-08 00:01:27.547131
2309	2026-01-17 00:30:00	4	1.66	220	233.7	t	2026-05-08 00:01:27.547131
2310	2026-01-17 00:30:00	7	2.82	220	221.4	t	2026-05-08 00:01:27.547131
2311	2026-01-17 01:00:00	1	2.62	220	600.2	t	2026-05-08 00:01:27.547131
2312	2026-01-17 01:00:00	4	1.4	220	478.7	t	2026-05-08 00:01:27.547131
2313	2026-01-17 01:00:00	7	2.41	220	284	t	2026-05-08 00:01:27.547131
2314	2026-01-17 01:30:00	1	1.52	220	519.3	t	2026-05-08 00:01:27.547131
2315	2026-01-17 01:30:00	4	2.12	220	576.5	t	2026-05-08 00:01:27.547131
2316	2026-01-17 01:30:00	7	2.72	220	536.8	t	2026-05-08 00:01:27.547131
2317	2026-01-17 02:00:00	1	1.02	220	522.3	t	2026-05-08 00:01:27.547131
2318	2026-01-17 02:00:00	4	2.67	220	221.8	t	2026-05-08 00:01:27.547131
2319	2026-01-17 02:00:00	7	1.84	220	249	t	2026-05-08 00:01:27.547131
2320	2026-01-17 02:30:00	1	2.29	220	410.8	t	2026-05-08 00:01:27.547131
2321	2026-01-17 02:30:00	4	1.76	220	646.9	t	2026-05-08 00:01:27.547131
2322	2026-01-17 02:30:00	7	1.83	220	436.4	t	2026-05-08 00:01:27.547131
2323	2026-01-17 03:00:00	1	2.64	220	591.1	t	2026-05-08 00:01:27.547131
2324	2026-01-17 03:00:00	4	2.97	220	283.8	t	2026-05-08 00:01:27.547131
2325	2026-01-17 03:00:00	7	2.88	220	619.7	t	2026-05-08 00:01:27.547131
2326	2026-01-17 03:30:00	1	2.44	220	269.7	t	2026-05-08 00:01:27.547131
2327	2026-01-17 03:30:00	4	2.48	220	449.6	t	2026-05-08 00:01:27.547131
2328	2026-01-17 03:30:00	7	2.49	220	635.2	t	2026-05-08 00:01:27.547131
2329	2026-01-17 04:00:00	1	2.97	220	613.3	t	2026-05-08 00:01:27.547131
2330	2026-01-17 04:00:00	4	2.03	220	529.3	t	2026-05-08 00:01:27.547131
2331	2026-01-17 04:00:00	7	2.06	220	314.6	t	2026-05-08 00:01:27.547131
2332	2026-01-17 04:30:00	1	1.58	220	244.8	t	2026-05-08 00:01:27.547131
2333	2026-01-17 04:30:00	4	2.46	220	254.4	t	2026-05-08 00:01:27.547131
2334	2026-01-17 04:30:00	7	1.1	220	407.9	t	2026-05-08 00:01:27.547131
2335	2026-01-17 05:00:00	1	1.86	220	534.6	t	2026-05-08 00:01:27.547131
2336	2026-01-17 05:00:00	4	1.72	220	392.1	t	2026-05-08 00:01:27.547131
2337	2026-01-17 05:00:00	7	1.77	220	542.8	t	2026-05-08 00:01:27.547131
2338	2026-01-17 05:30:00	1	2.33	220	254.2	t	2026-05-08 00:01:27.547131
2339	2026-01-17 05:30:00	4	1.34	220	584.6	t	2026-05-08 00:01:27.547131
2340	2026-01-17 05:30:00	7	1.47	220	429.3	t	2026-05-08 00:01:27.547131
2341	2026-01-17 06:00:00	1	1.29	220	408.9	t	2026-05-08 00:01:27.547131
2342	2026-01-17 06:00:00	4	2.98	220	551.1	t	2026-05-08 00:01:27.547131
2343	2026-01-17 06:00:00	7	2.36	220	520.3	t	2026-05-08 00:01:27.547131
2344	2026-01-17 06:30:00	1	2.03	220	639.6	t	2026-05-08 00:01:27.547131
2345	2026-01-17 06:30:00	4	2.25	220	630	t	2026-05-08 00:01:27.547131
2346	2026-01-17 06:30:00	7	2.83	220	279	t	2026-05-08 00:01:27.547131
2347	2026-01-17 07:00:00	1	2.86	220	575.6	t	2026-05-08 00:01:27.547131
2348	2026-01-17 07:00:00	4	1.82	220	430.3	t	2026-05-08 00:01:27.547131
2349	2026-01-17 07:00:00	7	2.02	220	543	t	2026-05-08 00:01:27.547131
2350	2026-01-17 07:30:00	1	2.28	220	655.9	t	2026-05-08 00:01:27.547131
2351	2026-01-17 07:30:00	4	2.66	220	526.1	t	2026-05-08 00:01:27.547131
2352	2026-01-17 07:30:00	7	2.98	220	238.6	t	2026-05-08 00:01:27.547131
2353	2026-01-17 08:00:00	1	1.38	220	307.9	t	2026-05-08 00:01:27.547131
2354	2026-01-17 08:00:00	4	3	220	304.3	t	2026-05-08 00:01:27.547131
2355	2026-01-17 08:00:00	7	2.02	220	394.7	t	2026-05-08 00:01:27.547131
2356	2026-01-17 08:30:00	1	1.6	220	519.2	t	2026-05-08 00:01:27.547131
2357	2026-01-17 08:30:00	4	2.84	220	655.7	t	2026-05-08 00:01:27.547131
2358	2026-01-17 08:30:00	7	1.18	220	257.3	t	2026-05-08 00:01:27.547131
2359	2026-01-17 09:00:00	1	2.53	220	630.3	t	2026-05-08 00:01:27.547131
2360	2026-01-17 09:00:00	4	2.45	220	575.9	t	2026-05-08 00:01:27.547131
2361	2026-01-17 09:00:00	7	2.97	220	227.7	t	2026-05-08 00:01:27.547131
2362	2026-01-17 09:30:00	1	2.14	220	353	t	2026-05-08 00:01:27.547131
2363	2026-01-17 09:30:00	4	1.12	220	523.8	t	2026-05-08 00:01:27.547131
2364	2026-01-17 09:30:00	7	1.91	220	653.3	t	2026-05-08 00:01:27.547131
2365	2026-01-17 10:00:00	1	1.34	220	398.7	t	2026-05-08 00:01:27.547131
2366	2026-01-17 10:00:00	4	2.07	220	266.2	t	2026-05-08 00:01:27.547131
2367	2026-01-17 10:00:00	7	2.22	220	389.9	t	2026-05-08 00:01:27.547131
2368	2026-01-17 10:30:00	1	2.81	220	530.5	t	2026-05-08 00:01:27.547131
2369	2026-01-17 10:30:00	4	1.36	220	488.8	t	2026-05-08 00:01:27.547131
2370	2026-01-17 10:30:00	7	2.65	220	473.7	t	2026-05-08 00:01:27.547131
2371	2026-01-17 11:00:00	1	2.85	220	253.8	t	2026-05-08 00:01:27.547131
2372	2026-01-17 11:00:00	4	2.27	220	574.3	t	2026-05-08 00:01:27.547131
2373	2026-01-17 11:00:00	7	1.46	220	445.7	t	2026-05-08 00:01:27.547131
2374	2026-01-17 11:30:00	1	2.3	220	434.7	t	2026-05-08 00:01:27.547131
2375	2026-01-17 11:30:00	4	2.51	220	606	t	2026-05-08 00:01:27.547131
2376	2026-01-17 11:30:00	7	2.99	220	283.5	t	2026-05-08 00:01:27.547131
2377	2026-01-17 12:00:00	1	2.27	220	398.4	t	2026-05-08 00:01:27.547131
2378	2026-01-17 12:00:00	4	2.57	220	329.2	t	2026-05-08 00:01:27.547131
2379	2026-01-17 12:00:00	7	1.17	220	284.4	t	2026-05-08 00:01:27.547131
2380	2026-01-17 12:30:00	1	2.82	220	405.3	t	2026-05-08 00:01:27.547131
2381	2026-01-17 12:30:00	4	3	220	367.4	t	2026-05-08 00:01:27.547131
2382	2026-01-17 12:30:00	7	2.2	220	416.8	t	2026-05-08 00:01:27.547131
2383	2026-01-17 13:00:00	1	1.29	220	649.6	t	2026-05-08 00:01:27.547131
2384	2026-01-17 13:00:00	4	2.5	220	233.4	t	2026-05-08 00:01:27.547131
2385	2026-01-17 13:00:00	7	2.69	220	588.4	t	2026-05-08 00:01:27.547131
2386	2026-01-17 13:30:00	1	2.95	220	478.7	t	2026-05-08 00:01:27.547131
2387	2026-01-17 13:30:00	4	2.48	220	318	t	2026-05-08 00:01:27.547131
2388	2026-01-17 13:30:00	7	1.53	220	550.3	t	2026-05-08 00:01:27.547131
2389	2026-01-17 14:00:00	1	2.23	220	622.3	t	2026-05-08 00:01:27.547131
2390	2026-01-17 14:00:00	4	2.36	220	574.9	t	2026-05-08 00:01:27.547131
2391	2026-01-17 14:00:00	7	2.16	220	297.5	t	2026-05-08 00:01:27.547131
2392	2026-01-17 14:30:00	1	2.81	220	436.1	t	2026-05-08 00:01:27.547131
2393	2026-01-17 14:30:00	4	1.14	220	294.9	t	2026-05-08 00:01:27.547131
2394	2026-01-17 14:30:00	7	1.9	220	269.4	t	2026-05-08 00:01:27.547131
2395	2026-01-17 15:00:00	1	2.62	220	443	t	2026-05-08 00:01:27.547131
2396	2026-01-17 15:00:00	4	1.92	220	231.7	t	2026-05-08 00:01:27.547131
2397	2026-01-17 15:00:00	7	1.14	220	469.4	t	2026-05-08 00:01:27.547131
2398	2026-01-17 15:30:00	1	1.19	220	406.6	t	2026-05-08 00:01:27.547131
2399	2026-01-17 15:30:00	4	2.86	220	287.5	t	2026-05-08 00:01:27.547131
2400	2026-01-17 15:30:00	7	1.82	220	467.1	t	2026-05-08 00:01:27.547131
2401	2026-01-17 16:00:00	1	1.16	220	413	t	2026-05-08 00:01:27.547131
2402	2026-01-17 16:00:00	4	1.59	220	262.5	t	2026-05-08 00:01:27.547131
2403	2026-01-17 16:00:00	7	2.82	220	478.7	t	2026-05-08 00:01:27.547131
2404	2026-01-17 16:30:00	1	1.74	220	270.5	t	2026-05-08 00:01:27.547131
2405	2026-01-17 16:30:00	4	1.18	220	603.4	t	2026-05-08 00:01:27.547131
2406	2026-01-17 16:30:00	7	2.11	220	357.8	t	2026-05-08 00:01:27.547131
2407	2026-01-17 17:00:00	1	1.08	220	513.5	t	2026-05-08 00:01:27.547131
2408	2026-01-17 17:00:00	4	1.33	220	477.2	t	2026-05-08 00:01:27.547131
2409	2026-01-17 17:00:00	7	2.48	220	400.7	t	2026-05-08 00:01:27.547131
2410	2026-01-17 17:30:00	1	1.79	220	263.9	t	2026-05-08 00:01:27.547131
2411	2026-01-17 17:30:00	4	2.81	220	285.5	t	2026-05-08 00:01:27.547131
2412	2026-01-17 17:30:00	7	1.55	220	484.7	t	2026-05-08 00:01:27.547131
2413	2026-01-17 18:00:00	1	1.87	220	251.8	t	2026-05-08 00:01:27.547131
2414	2026-01-17 18:00:00	4	1.01	220	230.7	t	2026-05-08 00:01:27.547131
2415	2026-01-17 18:00:00	7	1.99	220	311.3	t	2026-05-08 00:01:27.547131
2416	2026-01-17 18:30:00	1	1.46	220	608.6	t	2026-05-08 00:01:27.547131
2417	2026-01-17 18:30:00	4	1.79	220	431.7	t	2026-05-08 00:01:27.547131
2418	2026-01-17 18:30:00	7	1.34	220	421.1	t	2026-05-08 00:01:27.547131
2419	2026-01-17 19:00:00	1	2.8	220	332.8	t	2026-05-08 00:01:27.547131
2420	2026-01-17 19:00:00	4	1.69	220	372.4	t	2026-05-08 00:01:27.547131
2421	2026-01-17 19:00:00	7	1.86	220	479.2	t	2026-05-08 00:01:27.547131
2422	2026-01-17 19:30:00	1	1.87	220	371.3	t	2026-05-08 00:01:27.547131
2423	2026-01-17 19:30:00	4	1.49	220	583.3	t	2026-05-08 00:01:27.547131
2424	2026-01-17 19:30:00	7	1.53	220	305.9	t	2026-05-08 00:01:27.547131
2425	2026-01-17 20:00:00	1	1.69	220	342.7	t	2026-05-08 00:01:27.547131
2426	2026-01-17 20:00:00	4	2.18	220	285.4	t	2026-05-08 00:01:27.547131
2427	2026-01-17 20:00:00	7	2.66	220	506.2	t	2026-05-08 00:01:27.547131
2428	2026-01-17 20:30:00	1	1.34	220	449.9	t	2026-05-08 00:01:27.547131
2429	2026-01-17 20:30:00	4	2.54	220	278	t	2026-05-08 00:01:27.547131
2430	2026-01-17 20:30:00	7	2.96	220	652.9	t	2026-05-08 00:01:27.547131
2431	2026-01-17 21:00:00	1	2.2	220	268.8	t	2026-05-08 00:01:27.547131
2432	2026-01-17 21:00:00	4	2.38	220	342.6	t	2026-05-08 00:01:27.547131
2433	2026-01-17 21:00:00	7	2.57	220	390.8	t	2026-05-08 00:01:27.547131
2434	2026-01-17 21:30:00	1	1.37	220	307.3	t	2026-05-08 00:01:27.547131
2435	2026-01-17 21:30:00	4	1.31	220	591.2	t	2026-05-08 00:01:27.547131
2436	2026-01-17 21:30:00	7	1.95	220	350.4	t	2026-05-08 00:01:27.547131
2437	2026-01-17 22:00:00	1	1.06	220	292.1	t	2026-05-08 00:01:27.547131
2438	2026-01-17 22:00:00	4	2.96	220	458.5	t	2026-05-08 00:01:27.547131
2439	2026-01-17 22:00:00	7	2.81	220	401.9	t	2026-05-08 00:01:27.547131
2440	2026-01-17 22:30:00	1	1.24	220	386.8	t	2026-05-08 00:01:27.547131
2441	2026-01-17 22:30:00	4	2.5	220	472.2	t	2026-05-08 00:01:27.547131
2442	2026-01-17 22:30:00	7	1.99	220	471.7	t	2026-05-08 00:01:27.547131
2443	2026-01-17 23:00:00	1	2.16	220	585.6	t	2026-05-08 00:01:27.547131
2444	2026-01-17 23:00:00	4	2.43	220	487.5	t	2026-05-08 00:01:27.547131
2445	2026-01-17 23:00:00	7	2.47	220	334.3	t	2026-05-08 00:01:27.547131
2446	2026-01-17 23:30:00	1	2.45	220	367.5	t	2026-05-08 00:01:27.547131
2447	2026-01-17 23:30:00	4	1.37	220	391.7	t	2026-05-08 00:01:27.547131
2448	2026-01-17 23:30:00	7	1.25	220	575.8	t	2026-05-08 00:01:27.547131
2449	2026-01-18 00:00:00	1	1.67	220	362.6	t	2026-05-08 00:01:27.547131
2450	2026-01-18 00:00:00	4	2.73	220	248.2	t	2026-05-08 00:01:27.547131
2451	2026-01-18 00:00:00	7	1.62	220	600.6	t	2026-05-08 00:01:27.547131
2452	2026-01-18 00:30:00	1	2.05	220	559.1	t	2026-05-08 00:01:27.547131
2453	2026-01-18 00:30:00	4	2.01	220	378.1	t	2026-05-08 00:01:27.547131
2454	2026-01-18 00:30:00	7	2.21	220	341.1	t	2026-05-08 00:01:27.547131
2455	2026-01-18 01:00:00	1	1.24	220	344.8	t	2026-05-08 00:01:27.547131
2456	2026-01-18 01:00:00	4	2.96	220	549.4	t	2026-05-08 00:01:27.547131
2457	2026-01-18 01:00:00	7	2.79	220	364.4	t	2026-05-08 00:01:27.547131
2458	2026-01-18 01:30:00	1	2.03	220	478.3	t	2026-05-08 00:01:27.547131
2459	2026-01-18 01:30:00	4	1.98	220	644.5	t	2026-05-08 00:01:27.547131
2460	2026-01-18 01:30:00	7	2.88	220	601.3	t	2026-05-08 00:01:27.547131
2461	2026-01-18 02:00:00	1	2.96	220	570.4	t	2026-05-08 00:01:27.547131
2462	2026-01-18 02:00:00	4	2.24	220	296.7	t	2026-05-08 00:01:27.547131
2463	2026-01-18 02:00:00	7	2.14	220	302	t	2026-05-08 00:01:27.547131
2464	2026-01-18 02:30:00	1	2.25	220	428.4	t	2026-05-08 00:01:27.547131
2465	2026-01-18 02:30:00	4	1.51	220	459.6	t	2026-05-08 00:01:27.547131
2466	2026-01-18 02:30:00	7	1.18	220	406.9	t	2026-05-08 00:01:27.547131
2467	2026-01-18 03:00:00	1	2.75	220	394.3	t	2026-05-08 00:01:27.547131
2468	2026-01-18 03:00:00	4	1.41	220	420.2	t	2026-05-08 00:01:27.547131
2469	2026-01-18 03:00:00	7	1.76	220	580.6	t	2026-05-08 00:01:27.547131
2470	2026-01-18 03:30:00	1	2.59	220	621.1	t	2026-05-08 00:01:27.547131
2471	2026-01-18 03:30:00	4	2.17	220	447.7	t	2026-05-08 00:01:27.547131
2472	2026-01-18 03:30:00	7	2.55	220	241.2	t	2026-05-08 00:01:27.547131
2473	2026-01-18 04:00:00	1	1.68	220	223.3	t	2026-05-08 00:01:27.547131
2474	2026-01-18 04:00:00	4	2.62	220	366.3	t	2026-05-08 00:01:27.547131
2475	2026-01-18 04:00:00	7	2.95	220	386	t	2026-05-08 00:01:27.547131
2476	2026-01-18 04:30:00	1	1.44	220	299.7	t	2026-05-08 00:01:27.547131
2477	2026-01-18 04:30:00	4	2.47	220	252.7	t	2026-05-08 00:01:27.547131
2478	2026-01-18 04:30:00	7	1.28	220	275	t	2026-05-08 00:01:27.547131
2479	2026-01-18 05:00:00	1	2.09	220	271.8	t	2026-05-08 00:01:27.547131
2480	2026-01-18 05:00:00	4	1.71	220	409.1	t	2026-05-08 00:01:27.547131
2481	2026-01-18 05:00:00	7	2.79	220	516.2	t	2026-05-08 00:01:27.547131
2482	2026-01-18 05:30:00	1	2	220	637.5	t	2026-05-08 00:01:27.547131
2483	2026-01-18 05:30:00	4	2.72	220	531.5	t	2026-05-08 00:01:27.547131
2484	2026-01-18 05:30:00	7	1.68	220	581.9	t	2026-05-08 00:01:27.547131
2485	2026-01-18 06:00:00	1	2.7	220	221.4	t	2026-05-08 00:01:27.547131
2486	2026-01-18 06:00:00	4	1.08	220	585	t	2026-05-08 00:01:27.547131
2487	2026-01-18 06:00:00	7	2.38	220	341.8	t	2026-05-08 00:01:27.547131
2488	2026-01-18 06:30:00	1	1.7	220	266.2	t	2026-05-08 00:01:27.547131
2489	2026-01-18 06:30:00	4	2.56	220	568.3	t	2026-05-08 00:01:27.547131
2490	2026-01-18 06:30:00	7	1.36	220	559.1	t	2026-05-08 00:01:27.547131
2491	2026-01-18 07:00:00	1	2.24	220	463.8	t	2026-05-08 00:01:27.547131
2492	2026-01-18 07:00:00	4	1.47	220	567.4	t	2026-05-08 00:01:27.547131
2493	2026-01-18 07:00:00	7	1.39	220	586.9	t	2026-05-08 00:01:27.547131
2494	2026-01-18 07:30:00	1	2.55	220	540.1	t	2026-05-08 00:01:27.547131
2495	2026-01-18 07:30:00	4	2.38	220	341.6	t	2026-05-08 00:01:27.547131
2496	2026-01-18 07:30:00	7	2.49	220	220.6	t	2026-05-08 00:01:27.547131
2497	2026-01-18 08:00:00	1	1.8	220	559.1	t	2026-05-08 00:01:27.547131
2498	2026-01-18 08:00:00	4	1.37	220	251.4	t	2026-05-08 00:01:27.547131
2499	2026-01-18 08:00:00	7	1.25	220	619.7	t	2026-05-08 00:01:27.547131
2500	2026-01-18 08:30:00	1	2.66	220	363.8	t	2026-05-08 00:01:27.547131
2501	2026-01-18 08:30:00	4	1.12	220	505.4	t	2026-05-08 00:01:27.547131
2502	2026-01-18 08:30:00	7	2.36	220	388.5	t	2026-05-08 00:01:27.547131
2503	2026-01-18 09:00:00	1	2.9	220	567.2	t	2026-05-08 00:01:27.547131
2504	2026-01-18 09:00:00	4	1.86	220	489.1	t	2026-05-08 00:01:27.547131
2505	2026-01-18 09:00:00	7	1.37	220	655.4	t	2026-05-08 00:01:27.547131
2506	2026-01-18 09:30:00	1	2.15	220	542.7	t	2026-05-08 00:01:27.547131
2507	2026-01-18 09:30:00	4	1.27	220	231.4	t	2026-05-08 00:01:27.547131
2508	2026-01-18 09:30:00	7	1.77	220	353.5	t	2026-05-08 00:01:27.547131
2509	2026-01-18 10:00:00	1	1.03	220	644	t	2026-05-08 00:01:27.547131
2510	2026-01-18 10:00:00	4	2.04	220	236.7	t	2026-05-08 00:01:27.547131
2511	2026-01-18 10:00:00	7	1.48	220	457.8	t	2026-05-08 00:01:27.547131
2512	2026-01-18 10:30:00	1	2.89	220	223.9	t	2026-05-08 00:01:27.547131
2513	2026-01-18 10:30:00	4	2.73	220	394.2	t	2026-05-08 00:01:27.547131
2514	2026-01-18 10:30:00	7	2.89	220	350.4	t	2026-05-08 00:01:27.547131
2515	2026-01-18 11:00:00	1	2.95	220	420.1	t	2026-05-08 00:01:27.547131
2516	2026-01-18 11:00:00	4	1.3	220	446	t	2026-05-08 00:01:27.547131
2517	2026-01-18 11:00:00	7	2.54	220	613.3	t	2026-05-08 00:01:27.547131
2518	2026-01-18 11:30:00	1	2.61	220	234.9	t	2026-05-08 00:01:27.547131
2519	2026-01-18 11:30:00	4	1.64	220	305.2	t	2026-05-08 00:01:27.547131
2520	2026-01-18 11:30:00	7	2.96	220	297.7	t	2026-05-08 00:01:27.547131
2521	2026-01-18 12:00:00	1	1.4	220	443.7	t	2026-05-08 00:01:27.547131
2522	2026-01-18 12:00:00	4	2.99	220	397.9	t	2026-05-08 00:01:27.547131
2523	2026-01-18 12:00:00	7	2.74	220	522	t	2026-05-08 00:01:27.547131
2524	2026-01-18 12:30:00	1	2.21	220	443.7	t	2026-05-08 00:01:27.547131
2525	2026-01-18 12:30:00	4	1.12	220	529.8	t	2026-05-08 00:01:27.547131
2526	2026-01-18 12:30:00	7	2.48	220	342.5	t	2026-05-08 00:01:27.547131
2527	2026-01-18 13:00:00	1	1.33	220	260.5	t	2026-05-08 00:01:27.547131
2528	2026-01-18 13:00:00	4	1.04	220	298.3	t	2026-05-08 00:01:27.547131
2529	2026-01-18 13:00:00	7	2.24	220	559.1	t	2026-05-08 00:01:27.547131
2530	2026-01-18 13:30:00	1	1.65	220	291.4	t	2026-05-08 00:01:27.547131
2531	2026-01-18 13:30:00	4	2.02	220	657.5	t	2026-05-08 00:01:27.547131
2532	2026-01-18 13:30:00	7	2.51	220	347.1	t	2026-05-08 00:01:27.547131
2533	2026-01-18 14:00:00	1	1.52	220	559.4	t	2026-05-08 00:01:27.547131
2534	2026-01-18 14:00:00	4	2.89	220	541.2	t	2026-05-08 00:01:27.547131
2535	2026-01-18 14:00:00	7	1.11	220	511.1	t	2026-05-08 00:01:27.547131
2536	2026-01-18 14:30:00	1	1.08	220	567.1	t	2026-05-08 00:01:27.547131
2537	2026-01-18 14:30:00	4	2.52	220	563.7	t	2026-05-08 00:01:27.547131
2538	2026-01-18 14:30:00	7	2.72	220	603.5	t	2026-05-08 00:01:27.547131
2539	2026-01-18 15:00:00	1	2.44	220	285	t	2026-05-08 00:01:27.547131
2540	2026-01-18 15:00:00	4	1.51	220	302.6	t	2026-05-08 00:01:27.547131
2541	2026-01-18 15:00:00	7	1.05	220	311.4	t	2026-05-08 00:01:27.547131
2542	2026-01-18 15:30:00	1	2.53	220	362	t	2026-05-08 00:01:27.547131
2543	2026-01-18 15:30:00	4	1.54	220	577.8	t	2026-05-08 00:01:27.547131
2544	2026-01-18 15:30:00	7	1.48	220	352.3	t	2026-05-08 00:01:27.547131
2545	2026-01-18 16:00:00	1	1.36	220	623.8	t	2026-05-08 00:01:27.547131
2546	2026-01-18 16:00:00	4	1.17	220	547.3	t	2026-05-08 00:01:27.547131
2547	2026-01-18 16:00:00	7	2.92	220	453.9	t	2026-05-08 00:01:27.547131
2548	2026-01-18 16:30:00	1	1.07	220	485.1	t	2026-05-08 00:01:27.547131
2549	2026-01-18 16:30:00	4	2.83	220	333.3	t	2026-05-08 00:01:27.547131
2550	2026-01-18 16:30:00	7	2.12	220	509.9	t	2026-05-08 00:01:27.547131
2551	2026-01-18 17:00:00	1	2.74	220	635.8	t	2026-05-08 00:01:27.547131
2552	2026-01-18 17:00:00	4	1.33	220	532.1	t	2026-05-08 00:01:27.547131
2553	2026-01-18 17:00:00	7	2.51	220	441	t	2026-05-08 00:01:27.547131
2554	2026-01-18 17:30:00	1	1.65	220	343.2	t	2026-05-08 00:01:27.547131
2555	2026-01-18 17:30:00	4	2.17	220	543.2	t	2026-05-08 00:01:27.547131
2556	2026-01-18 17:30:00	7	2.62	220	636	t	2026-05-08 00:01:27.547131
2557	2026-01-18 18:00:00	1	1.17	220	491.1	t	2026-05-08 00:01:27.547131
2558	2026-01-18 18:00:00	4	2.34	220	313.6	t	2026-05-08 00:01:27.547131
2559	2026-01-18 18:00:00	7	1.25	220	599.7	t	2026-05-08 00:01:27.547131
2560	2026-01-18 18:30:00	1	2.84	220	332.2	t	2026-05-08 00:01:27.547131
2561	2026-01-18 18:30:00	4	1.94	220	279.7	t	2026-05-08 00:01:27.547131
2562	2026-01-18 18:30:00	7	1.11	220	378.5	t	2026-05-08 00:01:27.547131
2563	2026-01-18 19:00:00	1	2.53	220	501.2	t	2026-05-08 00:01:27.547131
2564	2026-01-18 19:00:00	4	1.47	220	251.5	t	2026-05-08 00:01:27.547131
2565	2026-01-18 19:00:00	7	1.17	220	547.9	t	2026-05-08 00:01:27.547131
2566	2026-01-18 19:30:00	1	2.56	220	595.7	t	2026-05-08 00:01:27.547131
2567	2026-01-18 19:30:00	4	1.58	220	470.5	t	2026-05-08 00:01:27.547131
2568	2026-01-18 19:30:00	7	2.66	220	549.8	t	2026-05-08 00:01:27.547131
2569	2026-01-18 20:00:00	1	2.24	220	504.7	t	2026-05-08 00:01:27.547131
2570	2026-01-18 20:00:00	4	2.34	220	598.8	t	2026-05-08 00:01:27.547131
2571	2026-01-18 20:00:00	7	1.04	220	414.3	t	2026-05-08 00:01:27.547131
2572	2026-01-18 20:30:00	1	1.82	220	327.4	t	2026-05-08 00:01:27.547131
2573	2026-01-18 20:30:00	4	2.22	220	277.5	t	2026-05-08 00:01:27.547131
2574	2026-01-18 20:30:00	7	1.71	220	602.7	t	2026-05-08 00:01:27.547131
2575	2026-01-18 21:00:00	1	1.14	220	654.6	t	2026-05-08 00:01:27.547131
2576	2026-01-18 21:00:00	4	2.47	220	494.8	t	2026-05-08 00:01:27.547131
2577	2026-01-18 21:00:00	7	1.54	220	633.3	t	2026-05-08 00:01:27.547131
2578	2026-01-18 21:30:00	1	2.39	220	388.9	t	2026-05-08 00:01:27.547131
2579	2026-01-18 21:30:00	4	2.49	220	261.1	t	2026-05-08 00:01:27.547131
2580	2026-01-18 21:30:00	7	1.98	220	490.4	t	2026-05-08 00:01:27.547131
2581	2026-01-18 22:00:00	1	1.48	220	283	t	2026-05-08 00:01:27.547131
2582	2026-01-18 22:00:00	4	2.11	220	636.2	t	2026-05-08 00:01:27.547131
2583	2026-01-18 22:00:00	7	2.03	220	457.2	t	2026-05-08 00:01:27.547131
2584	2026-01-18 22:30:00	1	1.12	220	626.4	t	2026-05-08 00:01:27.547131
2585	2026-01-18 22:30:00	4	2.42	220	553.7	t	2026-05-08 00:01:27.547131
2586	2026-01-18 22:30:00	7	2.32	220	586.1	t	2026-05-08 00:01:27.547131
2587	2026-01-18 23:00:00	1	1.01	220	473	t	2026-05-08 00:01:27.547131
2588	2026-01-18 23:00:00	4	2.49	220	575.5	t	2026-05-08 00:01:27.547131
2589	2026-01-18 23:00:00	7	2.63	220	638	t	2026-05-08 00:01:27.547131
2590	2026-01-18 23:30:00	1	1.75	220	543	t	2026-05-08 00:01:27.547131
2591	2026-01-18 23:30:00	4	1.88	220	634.8	t	2026-05-08 00:01:27.547131
2592	2026-01-18 23:30:00	7	2.12	220	622.3	t	2026-05-08 00:01:27.547131
2593	2026-01-19 00:00:00	1	1.39	220	422.1	t	2026-05-08 00:01:27.547131
2594	2026-01-19 00:00:00	4	2.88	220	690.6	t	2026-05-08 00:01:27.547131
2595	2026-01-19 00:00:00	7	3.55	220	768.7	t	2026-05-08 00:01:27.547131
2596	2026-01-19 00:30:00	1	2.05	220	332.7	t	2026-05-08 00:01:27.547131
2597	2026-01-19 00:30:00	4	3.67	220	369.5	t	2026-05-08 00:01:27.547131
2598	2026-01-19 00:30:00	7	3.68	220	792	t	2026-05-08 00:01:27.547131
2599	2026-01-19 01:00:00	1	2.55	220	370.5	t	2026-05-08 00:01:27.547131
2600	2026-01-19 01:00:00	4	1.48	220	755.2	t	2026-05-08 00:01:27.547131
2601	2026-01-19 01:00:00	7	1.57	220	359.1	t	2026-05-08 00:01:27.547131
2602	2026-01-19 01:30:00	1	2.45	220	451.1	t	2026-05-08 00:01:27.547131
2603	2026-01-19 01:30:00	4	3.65	220	612.1	t	2026-05-08 00:01:27.547131
2604	2026-01-19 01:30:00	7	1.47	220	447.3	t	2026-05-08 00:01:27.547131
2605	2026-01-19 02:00:00	1	2.17	220	457.9	t	2026-05-08 00:01:27.547131
2606	2026-01-19 02:00:00	4	2.09	220	714.2	t	2026-05-08 00:01:27.547131
2607	2026-01-19 02:00:00	7	2	220	384.1	t	2026-05-08 00:01:27.547131
2608	2026-01-19 02:30:00	1	2.62	220	676.5	t	2026-05-08 00:01:27.547131
2609	2026-01-19 02:30:00	4	3.39	220	385.1	t	2026-05-08 00:01:27.547131
2610	2026-01-19 02:30:00	7	2.54	220	543.3	t	2026-05-08 00:01:27.547131
2611	2026-01-19 03:00:00	1	3.64	220	510.6	t	2026-05-08 00:01:27.547131
2612	2026-01-19 03:00:00	4	1.57	220	418.2	t	2026-05-08 00:01:27.547131
2613	2026-01-19 03:00:00	7	1.34	220	626.5	t	2026-05-08 00:01:27.547131
2614	2026-01-19 03:30:00	1	2.35	220	283.4	t	2026-05-08 00:01:27.547131
2615	2026-01-19 03:30:00	4	3.26	220	623.5	t	2026-05-08 00:01:27.547131
2616	2026-01-19 03:30:00	7	3.13	220	435.9	t	2026-05-08 00:01:27.547131
2617	2026-01-19 04:00:00	1	3.41	220	723.9	t	2026-05-08 00:01:27.547131
2618	2026-01-19 04:00:00	4	2.42	220	386	t	2026-05-08 00:01:27.547131
2619	2026-01-19 04:00:00	7	2.48	220	659.9	t	2026-05-08 00:01:27.547131
2620	2026-01-19 04:30:00	1	2.78	220	583.4	t	2026-05-08 00:01:27.547131
2621	2026-01-19 04:30:00	4	2.41	220	352.2	t	2026-05-08 00:01:27.547131
2622	2026-01-19 04:30:00	7	2.73	220	498	t	2026-05-08 00:01:27.547131
2623	2026-01-19 05:00:00	1	3.13	220	645.2	t	2026-05-08 00:01:27.547131
2624	2026-01-19 05:00:00	4	1.59	220	455.2	t	2026-05-08 00:01:27.547131
2625	2026-01-19 05:00:00	7	2.36	220	770.6	t	2026-05-08 00:01:27.547131
2626	2026-01-19 05:30:00	1	1.77	220	281.9	t	2026-05-08 00:01:27.547131
2627	2026-01-19 05:30:00	4	1.72	220	579.9	t	2026-05-08 00:01:27.547131
2628	2026-01-19 05:30:00	7	3.12	220	525.5	t	2026-05-08 00:01:27.547131
2629	2026-01-19 06:00:00	1	2.29	220	688.7	t	2026-05-08 00:01:27.547131
2630	2026-01-19 06:00:00	4	2.84	220	685.4	t	2026-05-08 00:01:27.547131
2631	2026-01-19 06:00:00	7	3.36	220	333.2	t	2026-05-08 00:01:27.547131
2632	2026-01-19 06:30:00	1	1.42	220	650.7	t	2026-05-08 00:01:27.547131
2633	2026-01-19 06:30:00	4	3.63	220	492.9	t	2026-05-08 00:01:27.547131
2634	2026-01-19 06:30:00	7	3.47	220	587.8	t	2026-05-08 00:01:27.547131
2635	2026-01-19 07:00:00	1	18.44	220	2824.4	t	2026-05-08 00:01:27.547131
2636	2026-01-19 07:00:00	4	18.22	220	5401	t	2026-05-08 00:01:27.547131
2637	2026-01-19 07:00:00	7	29.52	220	4592.6	t	2026-05-08 00:01:27.547131
2638	2026-01-19 07:30:00	1	18.67	220	3849.1	t	2026-05-08 00:01:27.547131
2639	2026-01-19 07:30:00	4	23.45	220	4378.3	t	2026-05-08 00:01:27.547131
2640	2026-01-19 07:30:00	7	20.83	220	5060.9	t	2026-05-08 00:01:27.547131
2641	2026-01-19 08:00:00	1	19.27	220	3590.1	t	2026-05-08 00:01:27.547131
2642	2026-01-19 08:00:00	4	22.99	220	3940.7	t	2026-05-08 00:01:27.547131
2643	2026-01-19 08:00:00	7	22.03	220	6268.5	t	2026-05-08 00:01:27.547131
2644	2026-01-19 08:30:00	1	20.4	220	3945.2	t	2026-05-08 00:01:27.547131
2645	2026-01-19 08:30:00	4	16.71	220	4315.5	t	2026-05-08 00:01:27.547131
2646	2026-01-19 08:30:00	7	28.25	220	5758.6	t	2026-05-08 00:01:27.547131
2647	2026-01-19 09:00:00	1	18.98	220	3600.7	t	2026-05-08 00:01:27.547131
2648	2026-01-19 09:00:00	4	17.84	220	5532.9	t	2026-05-08 00:01:27.547131
2649	2026-01-19 09:00:00	7	26.49	220	4803.6	t	2026-05-08 00:01:27.547131
2650	2026-01-19 09:30:00	1	19.28	220	4237.4	t	2026-05-08 00:01:27.547131
2651	2026-01-19 09:30:00	4	19.29	220	3571.9	t	2026-05-08 00:01:27.547131
2652	2026-01-19 09:30:00	7	30.3	220	5138	t	2026-05-08 00:01:27.547131
2653	2026-01-19 10:00:00	1	20.54	220	4639.5	t	2026-05-08 00:01:27.547131
2654	2026-01-19 10:00:00	4	22.34	220	4288.8	t	2026-05-08 00:01:27.547131
2655	2026-01-19 10:00:00	7	26.43	220	6208	t	2026-05-08 00:01:27.547131
2656	2026-01-19 10:30:00	1	18.24	220	3979.1	t	2026-05-08 00:01:27.547131
2657	2026-01-19 10:30:00	4	21.8	220	4649.6	t	2026-05-08 00:01:27.547131
2658	2026-01-19 10:30:00	7	24.55	220	5716.7	t	2026-05-08 00:01:27.547131
2659	2026-01-19 11:00:00	1	20.08	220	4052.4	t	2026-05-08 00:01:27.547131
2660	2026-01-19 11:00:00	4	25.82	220	5193.4	t	2026-05-08 00:01:27.547131
2661	2026-01-19 11:00:00	7	29	220	6523	t	2026-05-08 00:01:27.547131
2662	2026-01-19 11:30:00	1	18.5	220	4650.6	t	2026-05-08 00:01:27.547131
2663	2026-01-19 11:30:00	4	16.32	220	5596.5	t	2026-05-08 00:01:27.547131
2664	2026-01-19 11:30:00	7	25.43	220	5873.6	t	2026-05-08 00:01:27.547131
2665	2026-01-19 12:00:00	1	13.96	220	4412.8	t	2026-05-08 00:01:27.547131
2666	2026-01-19 12:00:00	4	22.66	220	5301.7	t	2026-05-08 00:01:27.547131
2667	2026-01-19 12:00:00	7	29.2	220	4749.4	t	2026-05-08 00:01:27.547131
2668	2026-01-19 12:30:00	1	15.38	220	3941.8	t	2026-05-08 00:01:27.547131
2669	2026-01-19 12:30:00	4	23.27	220	4661.8	t	2026-05-08 00:01:27.547131
2670	2026-01-19 12:30:00	7	23.82	220	4646.8	t	2026-05-08 00:01:27.547131
2671	2026-01-19 13:00:00	1	20.84	220	3619	t	2026-05-08 00:01:27.547131
2672	2026-01-19 13:00:00	4	23.97	220	3922.7	t	2026-05-08 00:01:27.547131
2673	2026-01-19 13:00:00	7	23.94	220	5506.2	t	2026-05-08 00:01:27.547131
2674	2026-01-19 13:30:00	1	12.07	220	3874.4	t	2026-05-08 00:01:27.547131
2675	2026-01-19 13:30:00	4	17.47	220	3751.7	t	2026-05-08 00:01:27.547131
2676	2026-01-19 13:30:00	7	22.42	220	5017.2	t	2026-05-08 00:01:27.547131
2677	2026-01-19 14:00:00	1	21.34	220	3612.5	t	2026-05-08 00:01:27.547131
2678	2026-01-19 14:00:00	4	23.92	220	4687.1	t	2026-05-08 00:01:27.547131
2679	2026-01-19 14:00:00	7	29.14	220	4751.1	t	2026-05-08 00:01:27.547131
2680	2026-01-19 14:30:00	1	14.82	220	3370.5	t	2026-05-08 00:01:27.547131
2681	2026-01-19 14:30:00	4	19.34	220	4831.6	t	2026-05-08 00:01:27.547131
2682	2026-01-19 14:30:00	7	29.16	220	5547.3	t	2026-05-08 00:01:27.547131
2683	2026-01-19 15:00:00	1	14.11	220	2904.4	t	2026-05-08 00:01:27.547131
2684	2026-01-19 15:00:00	4	24.5	220	5484	t	2026-05-08 00:01:27.547131
2685	2026-01-19 15:00:00	7	27.34	220	5535.8	t	2026-05-08 00:01:27.547131
2686	2026-01-19 15:30:00	1	16.76	220	2575.9	t	2026-05-08 00:01:27.547131
2687	2026-01-19 15:30:00	4	22.05	220	5513	t	2026-05-08 00:01:27.547131
2688	2026-01-19 15:30:00	7	26.89	220	6474.7	t	2026-05-08 00:01:27.547131
2689	2026-01-19 16:00:00	1	20.03	220	3856.2	t	2026-05-08 00:01:27.547131
2690	2026-01-19 16:00:00	4	18.32	220	3576.7	t	2026-05-08 00:01:27.547131
2691	2026-01-19 16:00:00	7	25.88	220	5530.1	t	2026-05-08 00:01:27.547131
2692	2026-01-19 16:30:00	1	17.32	220	3442.3	t	2026-05-08 00:01:27.547131
2693	2026-01-19 16:30:00	4	18.87	220	4559.9	t	2026-05-08 00:01:27.547131
2694	2026-01-19 16:30:00	7	22.4	220	4858.3	t	2026-05-08 00:01:27.547131
2695	2026-01-19 17:00:00	1	16.69	220	4476.7	t	2026-05-08 00:01:27.547131
2696	2026-01-19 17:00:00	4	17.42	220	3646.9	t	2026-05-08 00:01:27.547131
2697	2026-01-19 17:00:00	7	27.47	220	6521.3	t	2026-05-08 00:01:27.547131
2698	2026-01-19 17:30:00	1	12.39	220	3110.7	t	2026-05-08 00:01:27.547131
2699	2026-01-19 17:30:00	4	18.41	220	4366.8	t	2026-05-08 00:01:27.547131
2700	2026-01-19 17:30:00	7	27.97	220	6162.1	t	2026-05-08 00:01:27.547131
2701	2026-01-19 18:00:00	1	17.91	220	3002.3	t	2026-05-08 00:01:27.547131
2702	2026-01-19 18:00:00	4	19.01	220	4042.5	t	2026-05-08 00:01:27.547131
2703	2026-01-19 18:00:00	7	25.79	220	5668.6	t	2026-05-08 00:01:27.547131
2704	2026-01-19 18:30:00	1	20.33	220	4131.1	t	2026-05-08 00:01:27.547131
2705	2026-01-19 18:30:00	4	20.43	220	5067.2	t	2026-05-08 00:01:27.547131
2706	2026-01-19 18:30:00	7	22.43	220	4539.9	t	2026-05-08 00:01:27.547131
2707	2026-01-19 19:00:00	1	18.55	220	3575.2	t	2026-05-08 00:01:27.547131
2708	2026-01-19 19:00:00	4	18.54	220	3819.4	t	2026-05-08 00:01:27.547131
2709	2026-01-19 19:00:00	7	28.2	220	4768.5	t	2026-05-08 00:01:27.547131
2710	2026-01-19 19:30:00	1	21.31	220	2559.2	t	2026-05-08 00:01:27.547131
2711	2026-01-19 19:30:00	4	18.38	220	4201.3	t	2026-05-08 00:01:27.547131
2712	2026-01-19 19:30:00	7	22.43	220	6547.6	t	2026-05-08 00:01:27.547131
2713	2026-01-19 20:00:00	1	2.21	220	546	t	2026-05-08 00:01:27.547131
2714	2026-01-19 20:00:00	4	1.66	220	439	t	2026-05-08 00:01:27.547131
2715	2026-01-19 20:00:00	7	1.31	220	652.1	t	2026-05-08 00:01:27.547131
2716	2026-01-19 20:30:00	1	1.51	220	643.9	t	2026-05-08 00:01:27.547131
2717	2026-01-19 20:30:00	4	2.64	220	507.3	t	2026-05-08 00:01:27.547131
2718	2026-01-19 20:30:00	7	2.29	220	318.7	t	2026-05-08 00:01:27.547131
2719	2026-01-19 21:00:00	1	2.37	220	769.9	t	2026-05-08 00:01:27.547131
2720	2026-01-19 21:00:00	4	2.65	220	669.8	t	2026-05-08 00:01:27.547131
2721	2026-01-19 21:00:00	7	2.55	220	445.6	t	2026-05-08 00:01:27.547131
2722	2026-01-19 21:30:00	1	2.67	220	313.8	t	2026-05-08 00:01:27.547131
2723	2026-01-19 21:30:00	4	2.65	220	343.8	t	2026-05-08 00:01:27.547131
2724	2026-01-19 21:30:00	7	3.53	220	310.9	t	2026-05-08 00:01:27.547131
2725	2026-01-19 22:00:00	1	2.48	220	393.6	t	2026-05-08 00:01:27.547131
2726	2026-01-19 22:00:00	4	3.58	220	306.2	t	2026-05-08 00:01:27.547131
2727	2026-01-19 22:00:00	7	3.42	220	678.8	t	2026-05-08 00:01:27.547131
2728	2026-01-19 22:30:00	1	3.05	220	762.2	t	2026-05-08 00:01:27.547131
2729	2026-01-19 22:30:00	4	3.38	220	742	t	2026-05-08 00:01:27.547131
2730	2026-01-19 22:30:00	7	1.9	220	544.8	t	2026-05-08 00:01:27.547131
2731	2026-01-19 23:00:00	1	3.05	220	573.1	t	2026-05-08 00:01:27.547131
2732	2026-01-19 23:00:00	4	2.49	220	700.4	t	2026-05-08 00:01:27.547131
2733	2026-01-19 23:00:00	7	3.04	220	598.5	t	2026-05-08 00:01:27.547131
2734	2026-01-19 23:30:00	1	2.05	220	436.1	t	2026-05-08 00:01:27.547131
2735	2026-01-19 23:30:00	4	3.47	220	698.4	t	2026-05-08 00:01:27.547131
2736	2026-01-19 23:30:00	7	3.55	220	755.1	t	2026-05-08 00:01:27.547131
2737	2026-01-20 00:00:00	1	2.28	220	511.8	t	2026-05-08 00:01:27.547131
2738	2026-01-20 00:00:00	4	1.28	220	737.9	t	2026-05-08 00:01:27.547131
2739	2026-01-20 00:00:00	7	1.53	220	750.1	t	2026-05-08 00:01:27.547131
2740	2026-01-20 00:30:00	1	3.35	220	344.1	t	2026-05-08 00:01:27.547131
2741	2026-01-20 00:30:00	4	2.98	220	487.7	t	2026-05-08 00:01:27.547131
2742	2026-01-20 00:30:00	7	3.19	220	339.2	t	2026-05-08 00:01:27.547131
2743	2026-01-20 01:00:00	1	3.62	220	394.3	t	2026-05-08 00:01:27.547131
2744	2026-01-20 01:00:00	4	1.91	220	589.3	t	2026-05-08 00:01:27.547131
2745	2026-01-20 01:00:00	7	1.33	220	699	t	2026-05-08 00:01:27.547131
2746	2026-01-20 01:30:00	1	1.97	220	532.3	t	2026-05-08 00:01:27.547131
2747	2026-01-20 01:30:00	4	1.37	220	699.4	t	2026-05-08 00:01:27.547131
2748	2026-01-20 01:30:00	7	2.04	220	657.7	t	2026-05-08 00:01:27.547131
2749	2026-01-20 02:00:00	1	1.73	220	715.4	t	2026-05-08 00:01:27.547131
2750	2026-01-20 02:00:00	4	3.3	220	326.7	t	2026-05-08 00:01:27.547131
2751	2026-01-20 02:00:00	7	3.31	220	336.1	t	2026-05-08 00:01:27.547131
2752	2026-01-20 02:30:00	1	1.7	220	523.3	t	2026-05-08 00:01:27.547131
2753	2026-01-20 02:30:00	4	2.05	220	726	t	2026-05-08 00:01:27.547131
2754	2026-01-20 02:30:00	7	1.23	220	294.7	t	2026-05-08 00:01:27.547131
2755	2026-01-20 03:00:00	1	1.4	220	489.5	t	2026-05-08 00:01:27.547131
2756	2026-01-20 03:00:00	4	1.48	220	346.2	t	2026-05-08 00:01:27.547131
2757	2026-01-20 03:00:00	7	2.63	220	692.9	t	2026-05-08 00:01:27.547131
2758	2026-01-20 03:30:00	1	1.4	220	627.2	t	2026-05-08 00:01:27.547131
2759	2026-01-20 03:30:00	4	3.59	220	487.5	t	2026-05-08 00:01:27.547131
2760	2026-01-20 03:30:00	7	2.8	220	456.2	t	2026-05-08 00:01:27.547131
2761	2026-01-20 04:00:00	1	3	220	649.3	t	2026-05-08 00:01:27.547131
2762	2026-01-20 04:00:00	4	3.44	220	676.1	t	2026-05-08 00:01:27.547131
2763	2026-01-20 04:00:00	7	3.42	220	733.2	t	2026-05-08 00:01:27.547131
2764	2026-01-20 04:30:00	1	1.37	220	498.8	t	2026-05-08 00:01:27.547131
2765	2026-01-20 04:30:00	4	2.28	220	333.4	t	2026-05-08 00:01:27.547131
2766	2026-01-20 04:30:00	7	2.73	220	393.1	t	2026-05-08 00:01:27.547131
2767	2026-01-20 05:00:00	1	3.51	220	765.4	t	2026-05-08 00:01:27.547131
2768	2026-01-20 05:00:00	4	3.23	220	311.1	t	2026-05-08 00:01:27.547131
2769	2026-01-20 05:00:00	7	2.36	220	711.8	t	2026-05-08 00:01:27.547131
2770	2026-01-20 05:30:00	1	1.45	220	315	t	2026-05-08 00:01:27.547131
2771	2026-01-20 05:30:00	4	3.14	220	288	t	2026-05-08 00:01:27.547131
2772	2026-01-20 05:30:00	7	2.37	220	321.3	t	2026-05-08 00:01:27.547131
2773	2026-01-20 06:00:00	1	2.06	220	483	t	2026-05-08 00:01:27.547131
2774	2026-01-20 06:00:00	4	1.76	220	711.5	t	2026-05-08 00:01:27.547131
2775	2026-01-20 06:00:00	7	1.93	220	711.5	t	2026-05-08 00:01:27.547131
2776	2026-01-20 06:30:00	1	2.88	220	731.4	t	2026-05-08 00:01:27.547131
2777	2026-01-20 06:30:00	4	2.32	220	568.9	t	2026-05-08 00:01:27.547131
2778	2026-01-20 06:30:00	7	1.82	220	750.9	t	2026-05-08 00:01:27.547131
2779	2026-01-20 07:00:00	1	19.31	220	3000	t	2026-05-08 00:01:27.547131
2780	2026-01-20 07:00:00	4	18.87	220	4406.3	t	2026-05-08 00:01:27.547131
2781	2026-01-20 07:00:00	7	28.85	220	6317.8	t	2026-05-08 00:01:27.547131
2782	2026-01-20 07:30:00	1	13.72	220	3131.4	t	2026-05-08 00:01:27.547131
2783	2026-01-20 07:30:00	4	23.38	220	4043.4	t	2026-05-08 00:01:27.547131
2784	2026-01-20 07:30:00	7	30.2	220	6621	t	2026-05-08 00:01:27.547131
2785	2026-01-20 08:00:00	1	15.06	220	2635.9	t	2026-05-08 00:01:27.547131
2786	2026-01-20 08:00:00	4	25.71	220	5301.5	t	2026-05-08 00:01:27.547131
2787	2026-01-20 08:00:00	7	24.66	220	4864.7	t	2026-05-08 00:01:27.547131
2788	2026-01-20 08:30:00	1	15.56	220	4348.8	t	2026-05-08 00:01:27.547131
2789	2026-01-20 08:30:00	4	20.05	220	5348.5	t	2026-05-08 00:01:27.547131
2790	2026-01-20 08:30:00	7	23.08	220	6029.4	t	2026-05-08 00:01:27.547131
2791	2026-01-20 09:00:00	1	18.62	220	2675.4	t	2026-05-08 00:01:27.547131
2792	2026-01-20 09:00:00	4	21.25	220	3990.9	t	2026-05-08 00:01:27.547131
2793	2026-01-20 09:00:00	7	23.78	220	6389.8	t	2026-05-08 00:01:27.547131
2794	2026-01-20 09:30:00	1	11.82	220	3690.6	t	2026-05-08 00:01:27.547131
2795	2026-01-20 09:30:00	4	22.01	220	4664.9	t	2026-05-08 00:01:27.547131
2796	2026-01-20 09:30:00	7	27.6	220	5940.4	t	2026-05-08 00:01:27.547131
2797	2026-01-20 10:00:00	1	19.24	220	4115.9	t	2026-05-08 00:01:27.547131
2798	2026-01-20 10:00:00	4	21.12	220	4404.3	t	2026-05-08 00:01:27.547131
2799	2026-01-20 10:00:00	7	21.92	220	5206.4	t	2026-05-08 00:01:27.547131
2800	2026-01-20 10:30:00	1	13.41	220	3047.4	t	2026-05-08 00:01:27.547131
2801	2026-01-20 10:30:00	4	17.75	220	4635.6	t	2026-05-08 00:01:27.547131
2802	2026-01-20 10:30:00	7	26.51	220	6313.2	t	2026-05-08 00:01:27.547131
2803	2026-01-20 11:00:00	1	14.6	220	4483.2	t	2026-05-08 00:01:27.547131
2804	2026-01-20 11:00:00	4	19.36	220	4423.7	t	2026-05-08 00:01:27.547131
2805	2026-01-20 11:00:00	7	25.71	220	5491.3	t	2026-05-08 00:01:27.547131
2806	2026-01-20 11:30:00	1	13.92	220	3523.5	t	2026-05-08 00:01:27.547131
2807	2026-01-20 11:30:00	4	23.91	220	4565.3	t	2026-05-08 00:01:27.547131
2808	2026-01-20 11:30:00	7	26.55	220	6106.7	t	2026-05-08 00:01:27.547131
2809	2026-01-20 12:00:00	1	18.42	220	4643.8	t	2026-05-08 00:01:27.547131
2810	2026-01-20 12:00:00	4	24.82	220	5061.9	t	2026-05-08 00:01:27.547131
2811	2026-01-20 12:00:00	7	24.97	220	4974	t	2026-05-08 00:01:27.547131
2812	2026-01-20 12:30:00	1	19.46	220	3789.7	t	2026-05-08 00:01:27.547131
2813	2026-01-20 12:30:00	4	24.78	220	5448.2	t	2026-05-08 00:01:27.547131
2814	2026-01-20 12:30:00	7	21	220	4896.9	t	2026-05-08 00:01:27.547131
2815	2026-01-20 13:00:00	1	19.14	220	3699.6	t	2026-05-08 00:01:27.547131
2816	2026-01-20 13:00:00	4	16.1	220	4563.6	t	2026-05-08 00:01:27.547131
2817	2026-01-20 13:00:00	7	21.06	220	5350.5	t	2026-05-08 00:01:27.547131
2818	2026-01-20 13:30:00	1	12.82	220	2781.7	t	2026-05-08 00:01:27.547131
2819	2026-01-20 13:30:00	4	24.05	220	4955.3	t	2026-05-08 00:01:27.547131
2820	2026-01-20 13:30:00	7	25.52	220	5443.4	t	2026-05-08 00:01:27.547131
2821	2026-01-20 14:00:00	1	21.46	220	4476.5	t	2026-05-08 00:01:27.547131
2822	2026-01-20 14:00:00	4	22.32	220	3731.5	t	2026-05-08 00:01:27.547131
2823	2026-01-20 14:00:00	7	25.05	220	6462.4	t	2026-05-08 00:01:27.547131
2824	2026-01-20 14:30:00	1	19.05	220	4062.9	t	2026-05-08 00:01:27.547131
2825	2026-01-20 14:30:00	4	17.85	220	4303	t	2026-05-08 00:01:27.547131
2826	2026-01-20 14:30:00	7	24.37	220	6466.8	t	2026-05-08 00:01:27.547131
2827	2026-01-20 15:00:00	1	12.64	220	2795.2	t	2026-05-08 00:01:27.547131
2828	2026-01-20 15:00:00	4	16.42	220	5309.3	t	2026-05-08 00:01:27.547131
2829	2026-01-20 15:00:00	7	24.53	220	5726.8	t	2026-05-08 00:01:27.547131
2830	2026-01-20 15:30:00	1	18.54	220	3845.5	t	2026-05-08 00:01:27.547131
2831	2026-01-20 15:30:00	4	16.52	220	5102.6	t	2026-05-08 00:01:27.547131
2832	2026-01-20 15:30:00	7	27.72	220	4939	t	2026-05-08 00:01:27.547131
2833	2026-01-20 16:00:00	1	18.05	220	4052.2	t	2026-05-08 00:01:27.547131
2834	2026-01-20 16:00:00	4	24.8	220	4899.9	t	2026-05-08 00:01:27.547131
2835	2026-01-20 16:00:00	7	30.31	220	5446.4	t	2026-05-08 00:01:27.547131
2836	2026-01-20 16:30:00	1	20.59	220	3651.3	t	2026-05-08 00:01:27.547131
2837	2026-01-20 16:30:00	4	20.03	220	3840.3	t	2026-05-08 00:01:27.547131
2838	2026-01-20 16:30:00	7	27.87	220	5589.3	t	2026-05-08 00:01:27.547131
2839	2026-01-20 17:00:00	1	16.55	220	3838.6	t	2026-05-08 00:01:27.547131
2840	2026-01-20 17:00:00	4	18.87	220	5482.2	t	2026-05-08 00:01:27.547131
2841	2026-01-20 17:00:00	7	23.59	220	6123.1	t	2026-05-08 00:01:27.547131
2842	2026-01-20 17:30:00	1	18.8	220	3901.6	t	2026-05-08 00:01:27.547131
2843	2026-01-20 17:30:00	4	21.2	220	3887.4	t	2026-05-08 00:01:27.547131
2844	2026-01-20 17:30:00	7	22.02	220	5420.3	t	2026-05-08 00:01:27.547131
2845	2026-01-20 18:00:00	1	13.99	220	4457.7	t	2026-05-08 00:01:27.547131
2846	2026-01-20 18:00:00	4	16.94	220	5444.1	t	2026-05-08 00:01:27.547131
2847	2026-01-20 18:00:00	7	22.67	220	5945.7	t	2026-05-08 00:01:27.547131
2848	2026-01-20 18:30:00	1	14.84	220	2865.3	t	2026-05-08 00:01:27.547131
2849	2026-01-20 18:30:00	4	22.24	220	5710.6	t	2026-05-08 00:01:27.547131
2850	2026-01-20 18:30:00	7	20.96	220	6578.7	t	2026-05-08 00:01:27.547131
2851	2026-01-20 19:00:00	1	14.33	220	4121.4	t	2026-05-08 00:01:27.547131
2852	2026-01-20 19:00:00	4	23.53	220	5056.7	t	2026-05-08 00:01:27.547131
2853	2026-01-20 19:00:00	7	22.9	220	5567.8	t	2026-05-08 00:01:27.547131
2854	2026-01-20 19:30:00	1	14.56	220	4174.8	t	2026-05-08 00:01:27.547131
2855	2026-01-20 19:30:00	4	24.65	220	5192.3	t	2026-05-08 00:01:27.547131
2856	2026-01-20 19:30:00	7	21.49	220	6469.3	t	2026-05-08 00:01:27.547131
2857	2026-01-20 20:00:00	1	3.6	220	384.2	t	2026-05-08 00:01:27.547131
2858	2026-01-20 20:00:00	4	3.11	220	767.2	t	2026-05-08 00:01:27.547131
2859	2026-01-20 20:00:00	7	1.75	220	678.8	t	2026-05-08 00:01:27.547131
2860	2026-01-20 20:30:00	1	1.63	220	717.8	t	2026-05-08 00:01:27.547131
2861	2026-01-20 20:30:00	4	3.35	220	356.1	t	2026-05-08 00:01:27.547131
2862	2026-01-20 20:30:00	7	1.38	220	691.6	t	2026-05-08 00:01:27.547131
2863	2026-01-20 21:00:00	1	3.53	220	439.8	t	2026-05-08 00:01:27.547131
2864	2026-01-20 21:00:00	4	1.27	220	486.1	t	2026-05-08 00:01:27.547131
2865	2026-01-20 21:00:00	7	1.84	220	584.6	t	2026-05-08 00:01:27.547131
2866	2026-01-20 21:30:00	1	1.58	220	393.1	t	2026-05-08 00:01:27.547131
2867	2026-01-20 21:30:00	4	1.72	220	629.5	t	2026-05-08 00:01:27.547131
2868	2026-01-20 21:30:00	7	2.96	220	723.7	t	2026-05-08 00:01:27.547131
2869	2026-01-20 22:00:00	1	2.73	220	401.5	t	2026-05-08 00:01:27.547131
2870	2026-01-20 22:00:00	4	2.75	220	409.5	t	2026-05-08 00:01:27.547131
2871	2026-01-20 22:00:00	7	2.21	220	491.9	t	2026-05-08 00:01:27.547131
2872	2026-01-20 22:30:00	1	1.73	220	769.8	t	2026-05-08 00:01:27.547131
2873	2026-01-20 22:30:00	4	1.32	220	518.1	t	2026-05-08 00:01:27.547131
2874	2026-01-20 22:30:00	7	2.51	220	303.2	t	2026-05-08 00:01:27.547131
2875	2026-01-20 23:00:00	1	3.2	220	603	t	2026-05-08 00:01:27.547131
2876	2026-01-20 23:00:00	4	1.46	220	473	t	2026-05-08 00:01:27.547131
2877	2026-01-20 23:00:00	7	1.26	220	646.6	t	2026-05-08 00:01:27.547131
2878	2026-01-20 23:30:00	1	3.12	220	551.7	t	2026-05-08 00:01:27.547131
2879	2026-01-20 23:30:00	4	2.42	220	664.7	t	2026-05-08 00:01:27.547131
2880	2026-01-20 23:30:00	7	2.67	220	351.9	t	2026-05-08 00:01:27.547131
2881	2026-01-21 00:00:00	1	3.68	220	351.4	t	2026-05-08 00:01:27.547131
2882	2026-01-21 00:00:00	4	2.54	220	684.9	t	2026-05-08 00:01:27.547131
2883	2026-01-21 00:00:00	7	1.54	220	424.8	t	2026-05-08 00:01:27.547131
2884	2026-01-21 00:30:00	1	1.21	220	806.5	t	2026-05-08 00:01:27.547131
2885	2026-01-21 00:30:00	4	3.66	220	548.9	t	2026-05-08 00:01:27.547131
2886	2026-01-21 00:30:00	7	3.48	220	384.6	t	2026-05-08 00:01:27.547131
2887	2026-01-21 01:00:00	1	2.53	220	650.9	t	2026-05-08 00:01:27.547131
2888	2026-01-21 01:00:00	4	2.09	220	618	t	2026-05-08 00:01:27.547131
2889	2026-01-21 01:00:00	7	1.8	220	363.3	t	2026-05-08 00:01:27.547131
2890	2026-01-21 01:30:00	1	2.61	220	614.6	t	2026-05-08 00:01:27.547131
2891	2026-01-21 01:30:00	4	1.54	220	339.4	t	2026-05-08 00:01:27.547131
2892	2026-01-21 01:30:00	7	2.61	220	630.9	t	2026-05-08 00:01:27.547131
2893	2026-01-21 02:00:00	1	1.98	220	432.9	t	2026-05-08 00:01:27.547131
2894	2026-01-21 02:00:00	4	2.28	220	289.9	t	2026-05-08 00:01:27.547131
2895	2026-01-21 02:00:00	7	2.42	220	396.5	t	2026-05-08 00:01:27.547131
2896	2026-01-21 02:30:00	1	3.43	220	394.3	t	2026-05-08 00:01:27.547131
2897	2026-01-21 02:30:00	4	3.18	220	267.3	t	2026-05-08 00:01:27.547131
2898	2026-01-21 02:30:00	7	3.37	220	427	t	2026-05-08 00:01:27.547131
2899	2026-01-21 03:00:00	1	2.3	220	734.4	t	2026-05-08 00:01:27.547131
2900	2026-01-21 03:00:00	4	2.8	220	488.3	t	2026-05-08 00:01:27.547131
2901	2026-01-21 03:00:00	7	2.49	220	371	t	2026-05-08 00:01:27.547131
2902	2026-01-21 03:30:00	1	2.08	220	266.2	t	2026-05-08 00:01:27.547131
2903	2026-01-21 03:30:00	4	2.5	220	573.7	t	2026-05-08 00:01:27.547131
2904	2026-01-21 03:30:00	7	3.01	220	632.2	t	2026-05-08 00:01:27.547131
2905	2026-01-21 04:00:00	1	3.66	220	696.6	t	2026-05-08 00:01:27.547131
2906	2026-01-21 04:00:00	4	1.69	220	747.1	t	2026-05-08 00:01:27.547131
2907	2026-01-21 04:00:00	7	3.42	220	314.3	t	2026-05-08 00:01:27.547131
2908	2026-01-21 04:30:00	1	1.45	220	550.4	t	2026-05-08 00:01:27.547131
2909	2026-01-21 04:30:00	4	3.06	220	348.4	t	2026-05-08 00:01:27.547131
2910	2026-01-21 04:30:00	7	2.76	220	680.6	t	2026-05-08 00:01:27.547131
2911	2026-01-21 05:00:00	1	2.19	220	796	t	2026-05-08 00:01:27.547131
2912	2026-01-21 05:00:00	4	1.39	220	622.5	t	2026-05-08 00:01:27.547131
2913	2026-01-21 05:00:00	7	1.85	220	656.7	t	2026-05-08 00:01:27.547131
2914	2026-01-21 05:30:00	1	1.56	220	497.9	t	2026-05-08 00:01:27.547131
2915	2026-01-21 05:30:00	4	1.59	220	311.5	t	2026-05-08 00:01:27.547131
2916	2026-01-21 05:30:00	7	1.25	220	652.6	t	2026-05-08 00:01:27.547131
2917	2026-01-21 06:00:00	1	1.92	220	452.6	t	2026-05-08 00:01:27.547131
2918	2026-01-21 06:00:00	4	2.51	220	449.8	t	2026-05-08 00:01:27.547131
2919	2026-01-21 06:00:00	7	1.72	220	453.3	t	2026-05-08 00:01:27.547131
2920	2026-01-21 06:30:00	1	3.55	220	354.3	t	2026-05-08 00:01:27.547131
2921	2026-01-21 06:30:00	4	1.9	220	670.6	t	2026-05-08 00:01:27.547131
2922	2026-01-21 06:30:00	7	2.66	220	451.2	t	2026-05-08 00:01:27.547131
2923	2026-01-21 07:00:00	1	19.94	220	3206.6	t	2026-05-08 00:01:27.547131
2924	2026-01-21 07:00:00	4	18.04	220	4489.7	t	2026-05-08 00:01:27.547131
2925	2026-01-21 07:00:00	7	24.91	220	6685.9	t	2026-05-08 00:01:27.547131
2926	2026-01-21 07:30:00	1	16.76	220	4668.7	t	2026-05-08 00:01:27.547131
2927	2026-01-21 07:30:00	4	18.6	220	5100.8	t	2026-05-08 00:01:27.547131
2928	2026-01-21 07:30:00	7	25.39	220	5035.5	t	2026-05-08 00:01:27.547131
2929	2026-01-21 08:00:00	1	20.03	220	4116.4	t	2026-05-08 00:01:27.547131
2930	2026-01-21 08:00:00	4	21.88	220	3887.5	t	2026-05-08 00:01:27.547131
2931	2026-01-21 08:00:00	7	21.28	220	5892.5	t	2026-05-08 00:01:27.547131
2932	2026-01-21 08:30:00	1	18.18	220	4573.3	t	2026-05-08 00:01:27.547131
2933	2026-01-21 08:30:00	4	20.94	220	4198.5	t	2026-05-08 00:01:27.547131
2934	2026-01-21 08:30:00	7	20.69	220	5225.6	t	2026-05-08 00:01:27.547131
2935	2026-01-21 09:00:00	1	14.63	220	3515.6	t	2026-05-08 00:01:27.547131
2936	2026-01-21 09:00:00	4	21.54	220	4106.2	t	2026-05-08 00:01:27.547131
2937	2026-01-21 09:00:00	7	22.82	220	4677.6	t	2026-05-08 00:01:27.547131
2938	2026-01-21 09:30:00	1	17.7	220	4494	t	2026-05-08 00:01:27.547131
2939	2026-01-21 09:30:00	4	17.72	220	5219.2	t	2026-05-08 00:01:27.547131
2940	2026-01-21 09:30:00	7	27.58	220	6537.6	t	2026-05-08 00:01:27.547131
2941	2026-01-21 10:00:00	1	17.34	220	3346.9	t	2026-05-08 00:01:27.547131
2942	2026-01-21 10:00:00	4	22.85	220	4689.1	t	2026-05-08 00:01:27.547131
2943	2026-01-21 10:00:00	7	25.11	220	5790	t	2026-05-08 00:01:27.547131
2944	2026-01-21 10:30:00	1	12.27	220	4309.8	t	2026-05-08 00:01:27.547131
2945	2026-01-21 10:30:00	4	17.67	220	4270.5	t	2026-05-08 00:01:27.547131
2946	2026-01-21 10:30:00	7	28.08	220	5159.8	t	2026-05-08 00:01:27.547131
2947	2026-01-21 11:00:00	1	21.17	220	3188.1	t	2026-05-08 00:01:27.547131
2948	2026-01-21 11:00:00	4	18.01	220	4984.5	t	2026-05-08 00:01:27.547131
2949	2026-01-21 11:00:00	7	25.77	220	5608.9	t	2026-05-08 00:01:27.547131
2950	2026-01-21 11:30:00	1	18.98	220	2888	t	2026-05-08 00:01:27.547131
2951	2026-01-21 11:30:00	4	23.93	220	4092.4	t	2026-05-08 00:01:27.547131
2952	2026-01-21 11:30:00	7	22.27	220	6452.6	t	2026-05-08 00:01:27.547131
2953	2026-01-21 12:00:00	1	14.56	220	3365.4	t	2026-05-08 00:01:27.547131
2954	2026-01-21 12:00:00	4	25.71	220	3739.3	t	2026-05-08 00:01:27.547131
2955	2026-01-21 12:00:00	7	20.58	220	4872.5	t	2026-05-08 00:01:27.547131
2956	2026-01-21 12:30:00	1	12.83	220	4668.1	t	2026-05-08 00:01:27.547131
2957	2026-01-21 12:30:00	4	21.75	220	5556.1	t	2026-05-08 00:01:27.547131
2958	2026-01-21 12:30:00	7	24.77	220	6230.4	t	2026-05-08 00:01:27.547131
2959	2026-01-21 13:00:00	1	13.78	220	3972.3	t	2026-05-08 00:01:27.547131
2960	2026-01-21 13:00:00	4	16.82	220	3865.9	t	2026-05-08 00:01:27.547131
2961	2026-01-21 13:00:00	7	30.17	220	5138.8	t	2026-05-08 00:01:27.547131
2962	2026-01-21 13:30:00	1	17.3	220	3013.3	t	2026-05-08 00:01:27.547131
2963	2026-01-21 13:30:00	4	17.18	220	5178.6	t	2026-05-08 00:01:27.547131
2964	2026-01-21 13:30:00	7	21.72	220	6152.3	t	2026-05-08 00:01:27.547131
2965	2026-01-21 14:00:00	1	21.34	220	3973.2	t	2026-05-08 00:01:27.547131
2966	2026-01-21 14:00:00	4	18.47	220	4068.1	t	2026-05-08 00:01:27.547131
2967	2026-01-21 14:00:00	7	22.28	220	6170.9	t	2026-05-08 00:01:27.547131
2968	2026-01-21 14:30:00	1	15.73	220	4048.1	t	2026-05-08 00:01:27.547131
2969	2026-01-21 14:30:00	4	17.48	220	5440.9	t	2026-05-08 00:01:27.547131
2970	2026-01-21 14:30:00	7	23.57	220	4586.6	t	2026-05-08 00:01:27.547131
2971	2026-01-21 15:00:00	1	15.43	220	4511.6	t	2026-05-08 00:01:27.547131
2972	2026-01-21 15:00:00	4	16.98	220	5137.4	t	2026-05-08 00:01:27.547131
2973	2026-01-21 15:00:00	7	29.91	220	5932.2	t	2026-05-08 00:01:27.547131
2974	2026-01-21 15:30:00	1	19.16	220	3532.4	t	2026-05-08 00:01:27.547131
2975	2026-01-21 15:30:00	4	22.62	220	4318.6	t	2026-05-08 00:01:27.547131
2976	2026-01-21 15:30:00	7	28.84	220	4601.2	t	2026-05-08 00:01:27.547131
2977	2026-01-21 16:00:00	1	13.62	220	3804.3	t	2026-05-08 00:01:27.547131
2978	2026-01-21 16:00:00	4	25	220	3727.3	t	2026-05-08 00:01:27.547131
2979	2026-01-21 16:00:00	7	25.95	220	6429.7	t	2026-05-08 00:01:27.547131
2980	2026-01-21 16:30:00	1	12.62	220	4111.1	t	2026-05-08 00:01:27.547131
2981	2026-01-21 16:30:00	4	20.07	220	4769.9	t	2026-05-08 00:01:27.547131
2982	2026-01-21 16:30:00	7	29.24	220	5366.6	t	2026-05-08 00:01:27.547131
2983	2026-01-21 17:00:00	1	12.88	220	4257.4	t	2026-05-08 00:01:27.547131
2984	2026-01-21 17:00:00	4	24.79	220	4485.5	t	2026-05-08 00:01:27.547131
2985	2026-01-21 17:00:00	7	21.07	220	4557.6	t	2026-05-08 00:01:27.547131
2986	2026-01-21 17:30:00	1	15.82	220	4193.4	t	2026-05-08 00:01:27.547131
2987	2026-01-21 17:30:00	4	16.58	220	5200.1	t	2026-05-08 00:01:27.547131
2988	2026-01-21 17:30:00	7	23.54	220	6555.2	t	2026-05-08 00:01:27.547131
2989	2026-01-21 18:00:00	1	19.51	220	4603.9	t	2026-05-08 00:01:27.547131
2990	2026-01-21 18:00:00	4	23.61	220	3569.7	t	2026-05-08 00:01:27.547131
2991	2026-01-21 18:00:00	7	26.65	220	5296.2	t	2026-05-08 00:01:27.547131
2992	2026-01-21 18:30:00	1	19.54	220	2677.5	t	2026-05-08 00:01:27.547131
2993	2026-01-21 18:30:00	4	19.18	220	4896.1	t	2026-05-08 00:01:27.547131
2994	2026-01-21 18:30:00	7	24.99	220	6036.1	t	2026-05-08 00:01:27.547131
2995	2026-01-21 19:00:00	1	19.11	220	4127.4	t	2026-05-08 00:01:27.547131
2996	2026-01-21 19:00:00	4	16.27	220	5661.5	t	2026-05-08 00:01:27.547131
2997	2026-01-21 19:00:00	7	24.03	220	5879.6	t	2026-05-08 00:01:27.547131
2998	2026-01-21 19:30:00	1	18.61	220	2626.6	t	2026-05-08 00:01:27.547131
2999	2026-01-21 19:30:00	4	16.97	220	5414.7	t	2026-05-08 00:01:27.547131
3000	2026-01-21 19:30:00	7	22.89	220	4537.3	t	2026-05-08 00:01:27.547131
3001	2026-01-21 20:00:00	1	3.19	220	354.3	t	2026-05-08 00:01:27.547131
3002	2026-01-21 20:00:00	4	1.92	220	747.1	t	2026-05-08 00:01:27.547131
3003	2026-01-21 20:00:00	7	3.02	220	802.5	t	2026-05-08 00:01:27.547131
3004	2026-01-21 20:30:00	1	1.52	220	715.7	t	2026-05-08 00:01:27.547131
3005	2026-01-21 20:30:00	4	2.55	220	545.7	t	2026-05-08 00:01:27.547131
3006	2026-01-21 20:30:00	7	1.98	220	680.2	t	2026-05-08 00:01:27.547131
3007	2026-01-21 21:00:00	1	3.69	220	294.5	t	2026-05-08 00:01:27.547131
3008	2026-01-21 21:00:00	4	1.59	220	802.3	t	2026-05-08 00:01:27.547131
3009	2026-01-21 21:00:00	7	1.4	220	448.4	t	2026-05-08 00:01:27.547131
3010	2026-01-21 21:30:00	1	2.61	220	673.3	t	2026-05-08 00:01:27.547131
3011	2026-01-21 21:30:00	4	2.51	220	682.6	t	2026-05-08 00:01:27.547131
3012	2026-01-21 21:30:00	7	2.78	220	746.3	t	2026-05-08 00:01:27.547131
3013	2026-01-21 22:00:00	1	2.18	220	285.9	t	2026-05-08 00:01:27.547131
3014	2026-01-21 22:00:00	4	2.29	220	343.2	t	2026-05-08 00:01:27.547131
3015	2026-01-21 22:00:00	7	1.96	220	265.3	t	2026-05-08 00:01:27.547131
3016	2026-01-21 22:30:00	1	2.92	220	267.8	t	2026-05-08 00:01:27.547131
3017	2026-01-21 22:30:00	4	1.41	220	355.2	t	2026-05-08 00:01:27.547131
3018	2026-01-21 22:30:00	7	2.65	220	553.2	t	2026-05-08 00:01:27.547131
3019	2026-01-21 23:00:00	1	3.21	220	707.8	t	2026-05-08 00:01:27.547131
3020	2026-01-21 23:00:00	4	1.75	220	785.3	t	2026-05-08 00:01:27.547131
3021	2026-01-21 23:00:00	7	3.06	220	683.8	t	2026-05-08 00:01:27.547131
3022	2026-01-21 23:30:00	1	1.4	220	430.8	t	2026-05-08 00:01:27.547131
3023	2026-01-21 23:30:00	4	2.03	220	577.4	t	2026-05-08 00:01:27.547131
3024	2026-01-21 23:30:00	7	1.86	220	732.5	t	2026-05-08 00:01:27.547131
3025	2026-01-22 00:00:00	1	2.71	220	759.6	t	2026-05-08 00:01:27.547131
3026	2026-01-22 00:00:00	4	2.01	220	480.6	t	2026-05-08 00:01:27.547131
3027	2026-01-22 00:00:00	7	2.69	220	384.6	t	2026-05-08 00:01:27.547131
3028	2026-01-22 00:30:00	1	3.07	220	751.5	t	2026-05-08 00:01:27.547131
3029	2026-01-22 00:30:00	4	1.22	220	401.8	t	2026-05-08 00:01:27.547131
3030	2026-01-22 00:30:00	7	1.77	220	495.8	t	2026-05-08 00:01:27.547131
3031	2026-01-22 01:00:00	1	2.31	220	769	t	2026-05-08 00:01:27.547131
3032	2026-01-22 01:00:00	4	3.42	220	663.8	t	2026-05-08 00:01:27.547131
3033	2026-01-22 01:00:00	7	1.46	220	408.1	t	2026-05-08 00:01:27.547131
3034	2026-01-22 01:30:00	1	3.16	220	417	t	2026-05-08 00:01:27.547131
3035	2026-01-22 01:30:00	4	2.13	220	650.6	t	2026-05-08 00:01:27.547131
3036	2026-01-22 01:30:00	7	1.9	220	697.9	t	2026-05-08 00:01:27.547131
3037	2026-01-22 02:00:00	1	2.86	220	265	t	2026-05-08 00:01:27.547131
3038	2026-01-22 02:00:00	4	1.93	220	481.7	t	2026-05-08 00:01:27.547131
3039	2026-01-22 02:00:00	7	2.76	220	762.4	t	2026-05-08 00:01:27.547131
3040	2026-01-22 02:30:00	1	1.39	220	466.5	t	2026-05-08 00:01:27.547131
3041	2026-01-22 02:30:00	4	2.53	220	788.4	t	2026-05-08 00:01:27.547131
3042	2026-01-22 02:30:00	7	2.96	220	271.4	t	2026-05-08 00:01:27.547131
3043	2026-01-22 03:00:00	1	1.22	220	272.6	t	2026-05-08 00:01:27.547131
3044	2026-01-22 03:00:00	4	3.49	220	710.2	t	2026-05-08 00:01:27.547131
3045	2026-01-22 03:00:00	7	2.31	220	800.9	t	2026-05-08 00:01:27.547131
3046	2026-01-22 03:30:00	1	2.24	220	352.4	t	2026-05-08 00:01:27.547131
3047	2026-01-22 03:30:00	4	3.47	220	379.4	t	2026-05-08 00:01:27.547131
3048	2026-01-22 03:30:00	7	2.85	220	791.3	t	2026-05-08 00:01:27.547131
3049	2026-01-22 04:00:00	1	2.03	220	720.7	t	2026-05-08 00:01:27.547131
3050	2026-01-22 04:00:00	4	2.18	220	397.9	t	2026-05-08 00:01:27.547131
3051	2026-01-22 04:00:00	7	3.32	220	652.1	t	2026-05-08 00:01:27.547131
3052	2026-01-22 04:30:00	1	1.54	220	781.3	t	2026-05-08 00:01:27.547131
3053	2026-01-22 04:30:00	4	1.41	220	737	t	2026-05-08 00:01:27.547131
3054	2026-01-22 04:30:00	7	3.69	220	663.3	t	2026-05-08 00:01:27.547131
3055	2026-01-22 05:00:00	1	2.43	220	572.1	t	2026-05-08 00:01:27.547131
3056	2026-01-22 05:00:00	4	2.85	220	797.9	t	2026-05-08 00:01:27.547131
3057	2026-01-22 05:00:00	7	1.63	220	473.7	t	2026-05-08 00:01:27.547131
3058	2026-01-22 05:30:00	1	1.42	220	793.9	t	2026-05-08 00:01:27.547131
3059	2026-01-22 05:30:00	4	3.69	220	570	t	2026-05-08 00:01:27.547131
3060	2026-01-22 05:30:00	7	3.21	220	548.5	t	2026-05-08 00:01:27.547131
3061	2026-01-22 06:00:00	1	3.37	220	605.2	t	2026-05-08 00:01:27.547131
3062	2026-01-22 06:00:00	4	3.19	220	414.4	t	2026-05-08 00:01:27.547131
3063	2026-01-22 06:00:00	7	3.36	220	481.9	t	2026-05-08 00:01:27.547131
3064	2026-01-22 06:30:00	1	3.08	220	732.5	t	2026-05-08 00:01:27.547131
3065	2026-01-22 06:30:00	4	3.39	220	550.9	t	2026-05-08 00:01:27.547131
3066	2026-01-22 06:30:00	7	3.56	220	603.5	t	2026-05-08 00:01:27.547131
3067	2026-01-22 07:00:00	1	13.03	220	3612.7	t	2026-05-08 00:01:27.547131
3068	2026-01-22 07:00:00	4	23.43	220	5602.1	t	2026-05-08 00:01:27.547131
3069	2026-01-22 07:00:00	7	23.79	220	5020.1	t	2026-05-08 00:01:27.547131
3070	2026-01-22 07:30:00	1	15.8	220	4711.9	t	2026-05-08 00:01:27.547131
3071	2026-01-22 07:30:00	4	20.02	220	5067.4	t	2026-05-08 00:01:27.547131
3072	2026-01-22 07:30:00	7	24.59	220	6218.3	t	2026-05-08 00:01:27.547131
3073	2026-01-22 08:00:00	1	19.62	220	3529.4	t	2026-05-08 00:01:27.547131
3074	2026-01-22 08:00:00	4	19.91	220	3775.8	t	2026-05-08 00:01:27.547131
3075	2026-01-22 08:00:00	7	21.2	220	5186.3	t	2026-05-08 00:01:27.547131
3076	2026-01-22 08:30:00	1	20.49	220	2636	t	2026-05-08 00:01:27.547131
3077	2026-01-22 08:30:00	4	18.96	220	5059.3	t	2026-05-08 00:01:27.547131
3078	2026-01-22 08:30:00	7	25.41	220	5304.1	t	2026-05-08 00:01:27.547131
3079	2026-01-22 09:00:00	1	17.19	220	4503.8	t	2026-05-08 00:01:27.547131
3080	2026-01-22 09:00:00	4	23.62	220	4048.8	t	2026-05-08 00:01:27.547131
3081	2026-01-22 09:00:00	7	23.06	220	5470.4	t	2026-05-08 00:01:27.547131
3082	2026-01-22 09:30:00	1	15.38	220	3291.2	t	2026-05-08 00:01:27.547131
3083	2026-01-22 09:30:00	4	22.23	220	4012.5	t	2026-05-08 00:01:27.547131
3084	2026-01-22 09:30:00	7	29.13	220	4778.9	t	2026-05-08 00:01:27.547131
3085	2026-01-22 10:00:00	1	17.61	220	2759	t	2026-05-08 00:01:27.547131
3086	2026-01-22 10:00:00	4	22.93	220	3961.6	t	2026-05-08 00:01:27.547131
3087	2026-01-22 10:00:00	7	27.84	220	5532.3	t	2026-05-08 00:01:27.547131
3088	2026-01-22 10:30:00	1	17.17	220	3267.9	t	2026-05-08 00:01:27.547131
3089	2026-01-22 10:30:00	4	18.74	220	3615.5	t	2026-05-08 00:01:27.547131
3090	2026-01-22 10:30:00	7	26.48	220	6075.1	t	2026-05-08 00:01:27.547131
3091	2026-01-22 11:00:00	1	17.48	220	3118	t	2026-05-08 00:01:27.547131
3092	2026-01-22 11:00:00	4	19.91	220	3949.7	t	2026-05-08 00:01:27.547131
3093	2026-01-22 11:00:00	7	24.31	220	6448.5	t	2026-05-08 00:01:27.547131
3094	2026-01-22 11:30:00	1	11.68	220	3264.7	t	2026-05-08 00:01:27.547131
3095	2026-01-22 11:30:00	4	18.8	220	3712.5	t	2026-05-08 00:01:27.547131
3096	2026-01-22 11:30:00	7	24.18	220	6510.2	t	2026-05-08 00:01:27.547131
3097	2026-01-22 12:00:00	1	11.65	220	3478.4	t	2026-05-08 00:01:27.547131
3098	2026-01-22 12:00:00	4	25.21	220	3649.7	t	2026-05-08 00:01:27.547131
3099	2026-01-22 12:00:00	7	28.26	220	5544.6	t	2026-05-08 00:01:27.547131
3100	2026-01-22 12:30:00	1	18.87	220	3331.6	t	2026-05-08 00:01:27.547131
3101	2026-01-22 12:30:00	4	23.31	220	5571.7	t	2026-05-08 00:01:27.547131
3102	2026-01-22 12:30:00	7	21.32	220	5997.5	t	2026-05-08 00:01:27.547131
3103	2026-01-22 13:00:00	1	12.44	220	3890.7	t	2026-05-08 00:01:27.547131
3104	2026-01-22 13:00:00	4	25.72	220	3888.2	t	2026-05-08 00:01:27.547131
3105	2026-01-22 13:00:00	7	21.67	220	5536.7	t	2026-05-08 00:01:27.547131
3106	2026-01-22 13:30:00	1	20.42	220	4692	t	2026-05-08 00:01:27.547131
3107	2026-01-22 13:30:00	4	25.61	220	4064.4	t	2026-05-08 00:01:27.547131
3108	2026-01-22 13:30:00	7	24.18	220	6180.5	t	2026-05-08 00:01:27.547131
3109	2026-01-22 14:00:00	1	13.92	220	3751.4	t	2026-05-08 00:01:27.547131
3110	2026-01-22 14:00:00	4	20.97	220	4199.4	t	2026-05-08 00:01:27.547131
3111	2026-01-22 14:00:00	7	25.07	220	5729.2	t	2026-05-08 00:01:27.547131
3112	2026-01-22 14:30:00	1	15.09	220	4578.9	t	2026-05-08 00:01:27.547131
3113	2026-01-22 14:30:00	4	21.85	220	3788.1	t	2026-05-08 00:01:27.547131
3114	2026-01-22 14:30:00	7	21.28	220	6148	t	2026-05-08 00:01:27.547131
3115	2026-01-22 15:00:00	1	18.55	220	4364.5	t	2026-05-08 00:01:27.547131
3116	2026-01-22 15:00:00	4	23.59	220	3928.1	t	2026-05-08 00:01:27.547131
3117	2026-01-22 15:00:00	7	26.49	220	5001.4	t	2026-05-08 00:01:27.547131
3118	2026-01-22 15:30:00	1	13.14	220	3757.3	t	2026-05-08 00:01:27.547131
3119	2026-01-22 15:30:00	4	25.56	220	4283.7	t	2026-05-08 00:01:27.547131
3120	2026-01-22 15:30:00	7	21.33	220	5804.3	t	2026-05-08 00:01:27.547131
3121	2026-01-22 16:00:00	1	16.29	220	3619.5	t	2026-05-08 00:01:27.547131
3122	2026-01-22 16:00:00	4	17.3	220	4422.2	t	2026-05-08 00:01:27.547131
3123	2026-01-22 16:00:00	7	24.12	220	5085.4	t	2026-05-08 00:01:27.547131
3124	2026-01-22 16:30:00	1	20.77	220	4297.1	t	2026-05-08 00:01:27.547131
3125	2026-01-22 16:30:00	4	19.01	220	5478.4	t	2026-05-08 00:01:27.547131
3126	2026-01-22 16:30:00	7	20.78	220	6061.1	t	2026-05-08 00:01:27.547131
3127	2026-01-22 17:00:00	1	15.16	220	3722.8	t	2026-05-08 00:01:27.547131
3128	2026-01-22 17:00:00	4	18.54	220	4869.8	t	2026-05-08 00:01:27.547131
3129	2026-01-22 17:00:00	7	28.86	220	4754.6	t	2026-05-08 00:01:27.547131
3130	2026-01-22 17:30:00	1	17.07	220	3207.5	t	2026-05-08 00:01:27.547131
3131	2026-01-22 17:30:00	4	18.79	220	5283.1	t	2026-05-08 00:01:27.547131
3132	2026-01-22 17:30:00	7	26.97	220	5427.2	t	2026-05-08 00:01:27.547131
3133	2026-01-22 18:00:00	1	11.95	220	3388.3	t	2026-05-08 00:01:27.547131
3134	2026-01-22 18:00:00	4	20.47	220	4738.9	t	2026-05-08 00:01:27.547131
3135	2026-01-22 18:00:00	7	23.33	220	6018.4	t	2026-05-08 00:01:27.547131
3136	2026-01-22 18:30:00	1	16.07	220	3930.2	t	2026-05-08 00:01:27.547131
3137	2026-01-22 18:30:00	4	23.36	220	5192.7	t	2026-05-08 00:01:27.547131
3138	2026-01-22 18:30:00	7	28.24	220	5427.1	t	2026-05-08 00:01:27.547131
3139	2026-01-22 19:00:00	1	14.51	220	2662.7	t	2026-05-08 00:01:27.547131
3140	2026-01-22 19:00:00	4	22.78	220	3761.1	t	2026-05-08 00:01:27.547131
3141	2026-01-22 19:00:00	7	25.29	220	4527.5	t	2026-05-08 00:01:27.547131
3142	2026-01-22 19:30:00	1	18.78	220	3615.7	t	2026-05-08 00:01:27.547131
3143	2026-01-22 19:30:00	4	25.71	220	4458.6	t	2026-05-08 00:01:27.547131
3144	2026-01-22 19:30:00	7	29.73	220	4948.7	t	2026-05-08 00:01:27.547131
3145	2026-01-22 20:00:00	1	1.86	220	448.1	t	2026-05-08 00:01:27.547131
3146	2026-01-22 20:00:00	4	1.54	220	570	t	2026-05-08 00:01:27.547131
3147	2026-01-22 20:00:00	7	2.5	220	317.7	t	2026-05-08 00:01:27.547131
3148	2026-01-22 20:30:00	1	3.07	220	374.5	t	2026-05-08 00:01:27.547131
3149	2026-01-22 20:30:00	4	2.82	220	727.6	t	2026-05-08 00:01:27.547131
3150	2026-01-22 20:30:00	7	2.07	220	573.4	t	2026-05-08 00:01:27.547131
3151	2026-01-22 21:00:00	1	2.62	220	692.8	t	2026-05-08 00:01:27.547131
3152	2026-01-22 21:00:00	4	3.6	220	530	t	2026-05-08 00:01:27.547131
3153	2026-01-22 21:00:00	7	2.67	220	748.9	t	2026-05-08 00:01:27.547131
3154	2026-01-22 21:30:00	1	2.09	220	452.8	t	2026-05-08 00:01:27.547131
3155	2026-01-22 21:30:00	4	2.75	220	532.6	t	2026-05-08 00:01:27.547131
3156	2026-01-22 21:30:00	7	2.69	220	584.7	t	2026-05-08 00:01:27.547131
3157	2026-01-22 22:00:00	1	3.38	220	297.5	t	2026-05-08 00:01:27.547131
3158	2026-01-22 22:00:00	4	2.16	220	501	t	2026-05-08 00:01:27.547131
3159	2026-01-22 22:00:00	7	2.24	220	711.4	t	2026-05-08 00:01:27.547131
3160	2026-01-22 22:30:00	1	2	220	532.7	t	2026-05-08 00:01:27.547131
3161	2026-01-22 22:30:00	4	1.35	220	438.3	t	2026-05-08 00:01:27.547131
3162	2026-01-22 22:30:00	7	2.07	220	783.1	t	2026-05-08 00:01:27.547131
3163	2026-01-22 23:00:00	1	3.38	220	397.3	t	2026-05-08 00:01:27.547131
3164	2026-01-22 23:00:00	4	1.36	220	560.8	t	2026-05-08 00:01:27.547131
3165	2026-01-22 23:00:00	7	1.57	220	500	t	2026-05-08 00:01:27.547131
3166	2026-01-22 23:30:00	1	1.66	220	727.8	t	2026-05-08 00:01:27.547131
3167	2026-01-22 23:30:00	4	1.71	220	354	t	2026-05-08 00:01:27.547131
3168	2026-01-22 23:30:00	7	2.11	220	619.3	t	2026-05-08 00:01:27.547131
3169	2026-01-23 00:00:00	1	3.58	220	498.5	t	2026-05-08 00:01:27.547131
3170	2026-01-23 00:00:00	4	2.32	220	795.3	t	2026-05-08 00:01:27.547131
3171	2026-01-23 00:00:00	7	2.33	220	682.1	t	2026-05-08 00:01:27.547131
3172	2026-01-23 00:30:00	1	3.64	220	391.2	t	2026-05-08 00:01:27.547131
3173	2026-01-23 00:30:00	4	2.45	220	782.4	t	2026-05-08 00:01:27.547131
3174	2026-01-23 00:30:00	7	3.07	220	606.1	t	2026-05-08 00:01:27.547131
3175	2026-01-23 01:00:00	1	2.62	220	508.4	t	2026-05-08 00:01:27.547131
3176	2026-01-23 01:00:00	4	3.48	220	480.6	t	2026-05-08 00:01:27.547131
3177	2026-01-23 01:00:00	7	1.86	220	754.1	t	2026-05-08 00:01:27.547131
3178	2026-01-23 01:30:00	1	1.39	220	659.1	t	2026-05-08 00:01:27.547131
3179	2026-01-23 01:30:00	4	2.72	220	604.4	t	2026-05-08 00:01:27.547131
3180	2026-01-23 01:30:00	7	1.63	220	483.5	t	2026-05-08 00:01:27.547131
3181	2026-01-23 02:00:00	1	2.29	220	477.7	t	2026-05-08 00:01:27.547131
3182	2026-01-23 02:00:00	4	1.3	220	437.5	t	2026-05-08 00:01:27.547131
3183	2026-01-23 02:00:00	7	1.45	220	383.8	t	2026-05-08 00:01:27.547131
3184	2026-01-23 02:30:00	1	3	220	521	t	2026-05-08 00:01:27.547131
3185	2026-01-23 02:30:00	4	3.46	220	522.3	t	2026-05-08 00:01:27.547131
3186	2026-01-23 02:30:00	7	1.9	220	613	t	2026-05-08 00:01:27.547131
3187	2026-01-23 03:00:00	1	1.94	220	620.6	t	2026-05-08 00:01:27.547131
3188	2026-01-23 03:00:00	4	3.55	220	733.4	t	2026-05-08 00:01:27.547131
3189	2026-01-23 03:00:00	7	2.01	220	460.1	t	2026-05-08 00:01:27.547131
3190	2026-01-23 03:30:00	1	1.42	220	706.3	t	2026-05-08 00:01:27.547131
3191	2026-01-23 03:30:00	4	2.75	220	321.4	t	2026-05-08 00:01:27.547131
3192	2026-01-23 03:30:00	7	1.39	220	778.8	t	2026-05-08 00:01:27.547131
3193	2026-01-23 04:00:00	1	1.9	220	400.3	t	2026-05-08 00:01:27.547131
3194	2026-01-23 04:00:00	4	2.95	220	293.8	t	2026-05-08 00:01:27.547131
3195	2026-01-23 04:00:00	7	2.71	220	354	t	2026-05-08 00:01:27.547131
3196	2026-01-23 04:30:00	1	1.94	220	710.8	t	2026-05-08 00:01:27.547131
3197	2026-01-23 04:30:00	4	1.61	220	738	t	2026-05-08 00:01:27.547131
3198	2026-01-23 04:30:00	7	1.44	220	376	t	2026-05-08 00:01:27.547131
3199	2026-01-23 05:00:00	1	3.69	220	731.9	t	2026-05-08 00:01:27.547131
3200	2026-01-23 05:00:00	4	1.97	220	335.6	t	2026-05-08 00:01:27.547131
3201	2026-01-23 05:00:00	7	3	220	344.7	t	2026-05-08 00:01:27.547131
3202	2026-01-23 05:30:00	1	2.89	220	574	t	2026-05-08 00:01:27.547131
3203	2026-01-23 05:30:00	4	3.04	220	613.8	t	2026-05-08 00:01:27.547131
3204	2026-01-23 05:30:00	7	3.11	220	564.1	t	2026-05-08 00:01:27.547131
3205	2026-01-23 06:00:00	1	1.31	220	518.1	t	2026-05-08 00:01:27.547131
3206	2026-01-23 06:00:00	4	3.22	220	309.3	t	2026-05-08 00:01:27.547131
3207	2026-01-23 06:00:00	7	3.13	220	384.7	t	2026-05-08 00:01:27.547131
3208	2026-01-23 06:30:00	1	1.46	220	642.3	t	2026-05-08 00:01:27.547131
3209	2026-01-23 06:30:00	4	1.41	220	516.5	t	2026-05-08 00:01:27.547131
3210	2026-01-23 06:30:00	7	3.39	220	476.6	t	2026-05-08 00:01:27.547131
3211	2026-01-23 07:00:00	1	17.67	220	2857.2	t	2026-05-08 00:01:27.547131
3212	2026-01-23 07:00:00	4	16.95	220	4178.2	t	2026-05-08 00:01:27.547131
3213	2026-01-23 07:00:00	7	28.01	220	5153.4	t	2026-05-08 00:01:27.547131
3214	2026-01-23 07:30:00	1	12.63	220	3441.3	t	2026-05-08 00:01:27.547131
3215	2026-01-23 07:30:00	4	18.72	220	3966.8	t	2026-05-08 00:01:27.547131
3216	2026-01-23 07:30:00	7	22.39	220	6084.3	t	2026-05-08 00:01:27.547131
3217	2026-01-23 08:00:00	1	13.63	220	2607.5	t	2026-05-08 00:01:27.547131
3218	2026-01-23 08:00:00	4	18.96	220	4502.4	t	2026-05-08 00:01:27.547131
3219	2026-01-23 08:00:00	7	25.36	220	6331.3	t	2026-05-08 00:01:27.547131
3220	2026-01-23 08:30:00	1	21.19	220	2850.9	t	2026-05-08 00:01:27.547131
3221	2026-01-23 08:30:00	4	23.68	220	4456.3	t	2026-05-08 00:01:27.547131
3222	2026-01-23 08:30:00	7	24.48	220	5435.6	t	2026-05-08 00:01:27.547131
3223	2026-01-23 09:00:00	1	19.01	220	2797.3	t	2026-05-08 00:01:27.547131
3224	2026-01-23 09:00:00	4	21.6	220	4257.3	t	2026-05-08 00:01:27.547131
3225	2026-01-23 09:00:00	7	29.25	220	5957.8	t	2026-05-08 00:01:27.547131
3226	2026-01-23 09:30:00	1	20.18	220	4211.5	t	2026-05-08 00:01:27.547131
3227	2026-01-23 09:30:00	4	25.83	220	4083.1	t	2026-05-08 00:01:27.547131
3228	2026-01-23 09:30:00	7	26.59	220	4919.1	t	2026-05-08 00:01:27.547131
3229	2026-01-23 10:00:00	1	12.05	220	4208.7	t	2026-05-08 00:01:27.547131
3230	2026-01-23 10:00:00	4	24.22	220	4532.6	t	2026-05-08 00:01:27.547131
3231	2026-01-23 10:00:00	7	24.43	220	4589.8	t	2026-05-08 00:01:27.547131
3232	2026-01-23 10:30:00	1	13.81	220	4644	t	2026-05-08 00:01:27.547131
3233	2026-01-23 10:30:00	4	25.67	220	5023.6	t	2026-05-08 00:01:27.547131
3234	2026-01-23 10:30:00	7	28.83	220	4650.3	t	2026-05-08 00:01:27.547131
3235	2026-01-23 11:00:00	1	12.93	220	4453.6	t	2026-05-08 00:01:27.547131
3236	2026-01-23 11:00:00	4	20.25	220	4339.3	t	2026-05-08 00:01:27.547131
3237	2026-01-23 11:00:00	7	23.72	220	6477.1	t	2026-05-08 00:01:27.547131
3238	2026-01-23 11:30:00	1	14.88	220	4011.8	t	2026-05-08 00:01:27.547131
3239	2026-01-23 11:30:00	4	23	220	5324.3	t	2026-05-08 00:01:27.547131
3240	2026-01-23 11:30:00	7	21.99	220	5155.8	t	2026-05-08 00:01:27.547131
3241	2026-01-23 12:00:00	1	18.33	220	4456.1	t	2026-05-08 00:01:27.547131
3242	2026-01-23 12:00:00	4	16.17	220	4151.2	t	2026-05-08 00:01:27.547131
3243	2026-01-23 12:00:00	7	27.86	220	6578.4	t	2026-05-08 00:01:27.547131
3244	2026-01-23 12:30:00	1	13.14	220	4504.3	t	2026-05-08 00:01:27.547131
3245	2026-01-23 12:30:00	4	22.1	220	5621.9	t	2026-05-08 00:01:27.547131
3246	2026-01-23 12:30:00	7	20.71	220	5468.8	t	2026-05-08 00:01:27.547131
3247	2026-01-23 13:00:00	1	19.17	220	3735.2	t	2026-05-08 00:01:27.547131
3248	2026-01-23 13:00:00	4	22.35	220	4156.2	t	2026-05-08 00:01:27.547131
3249	2026-01-23 13:00:00	7	28.35	220	5581.6	t	2026-05-08 00:01:27.547131
3250	2026-01-23 13:30:00	1	17.92	220	3280.3	t	2026-05-08 00:01:27.547131
3251	2026-01-23 13:30:00	4	22.77	220	4248.4	t	2026-05-08 00:01:27.547131
3252	2026-01-23 13:30:00	7	23.05	220	6269.3	t	2026-05-08 00:01:27.547131
3253	2026-01-23 14:00:00	1	19.36	220	3350.1	t	2026-05-08 00:01:27.547131
3254	2026-01-23 14:00:00	4	23.43	220	4813.4	t	2026-05-08 00:01:27.547131
3255	2026-01-23 14:00:00	7	24.72	220	5004.1	t	2026-05-08 00:01:27.547131
3256	2026-01-23 14:30:00	1	19.22	220	2883.7	t	2026-05-08 00:01:27.547131
3257	2026-01-23 14:30:00	4	20.75	220	3621	t	2026-05-08 00:01:27.547131
3258	2026-01-23 14:30:00	7	24.75	220	5549.3	t	2026-05-08 00:01:27.547131
3259	2026-01-23 15:00:00	1	20.77	220	3173	t	2026-05-08 00:01:27.547131
3260	2026-01-23 15:00:00	4	20.71	220	3953	t	2026-05-08 00:01:27.547131
3261	2026-01-23 15:00:00	7	28.97	220	5179.8	t	2026-05-08 00:01:27.547131
3262	2026-01-23 15:30:00	1	19.42	220	3239.4	t	2026-05-08 00:01:27.547131
3263	2026-01-23 15:30:00	4	19.82	220	4779	t	2026-05-08 00:01:27.547131
3264	2026-01-23 15:30:00	7	26.5	220	6371.9	t	2026-05-08 00:01:27.547131
3265	2026-01-23 16:00:00	1	20.62	220	3540.9	t	2026-05-08 00:01:27.547131
3266	2026-01-23 16:00:00	4	17.83	220	4148.5	t	2026-05-08 00:01:27.547131
3267	2026-01-23 16:00:00	7	23.5	220	5364.7	t	2026-05-08 00:01:27.547131
3268	2026-01-23 16:30:00	1	13.22	220	3259.6	t	2026-05-08 00:01:27.547131
3269	2026-01-23 16:30:00	4	17.04	220	4959	t	2026-05-08 00:01:27.547131
3270	2026-01-23 16:30:00	7	28.63	220	5184.3	t	2026-05-08 00:01:27.547131
3271	2026-01-23 17:00:00	1	17.12	220	3321.1	t	2026-05-08 00:01:27.547131
3272	2026-01-23 17:00:00	4	16.44	220	4361.1	t	2026-05-08 00:01:27.547131
3273	2026-01-23 17:00:00	7	24.05	220	6182.9	t	2026-05-08 00:01:27.547131
3274	2026-01-23 17:30:00	1	15.2	220	4441.8	t	2026-05-08 00:01:27.547131
3275	2026-01-23 17:30:00	4	21.55	220	5448.1	t	2026-05-08 00:01:27.547131
3276	2026-01-23 17:30:00	7	23.58	220	5669.4	t	2026-05-08 00:01:27.547131
3277	2026-01-23 18:00:00	1	18.95	220	3859	t	2026-05-08 00:01:27.547131
3278	2026-01-23 18:00:00	4	21.05	220	5026.1	t	2026-05-08 00:01:27.547131
3279	2026-01-23 18:00:00	7	21.85	220	5699.2	t	2026-05-08 00:01:27.547131
3280	2026-01-23 18:30:00	1	20.29	220	4167.5	t	2026-05-08 00:01:27.547131
3281	2026-01-23 18:30:00	4	23.13	220	3532.4	t	2026-05-08 00:01:27.547131
3282	2026-01-23 18:30:00	7	21.12	220	6185.6	t	2026-05-08 00:01:27.547131
3283	2026-01-23 19:00:00	1	20.77	220	4599	t	2026-05-08 00:01:27.547131
3284	2026-01-23 19:00:00	4	16	220	4534.4	t	2026-05-08 00:01:27.547131
3285	2026-01-23 19:00:00	7	27.66	220	5124.3	t	2026-05-08 00:01:27.547131
3286	2026-01-23 19:30:00	1	19.96	220	3743	t	2026-05-08 00:01:27.547131
3287	2026-01-23 19:30:00	4	16.02	220	4102.8	t	2026-05-08 00:01:27.547131
3288	2026-01-23 19:30:00	7	24.38	220	5497.4	t	2026-05-08 00:01:27.547131
3289	2026-01-23 20:00:00	1	2.64	220	462.9	t	2026-05-08 00:01:27.547131
3290	2026-01-23 20:00:00	4	2.23	220	347.6	t	2026-05-08 00:01:27.547131
3291	2026-01-23 20:00:00	7	1.27	220	554.4	t	2026-05-08 00:01:27.547131
3292	2026-01-23 20:30:00	1	2.87	220	797.7	t	2026-05-08 00:01:27.547131
3293	2026-01-23 20:30:00	4	2.2	220	542.5	t	2026-05-08 00:01:27.547131
3294	2026-01-23 20:30:00	7	2.71	220	331.9	t	2026-05-08 00:01:27.547131
3295	2026-01-23 21:00:00	1	3.26	220	515.6	t	2026-05-08 00:01:27.547131
3296	2026-01-23 21:00:00	4	3.22	220	806	t	2026-05-08 00:01:27.547131
3297	2026-01-23 21:00:00	7	1.38	220	448.1	t	2026-05-08 00:01:27.547131
3298	2026-01-23 21:30:00	1	2.49	220	638.9	t	2026-05-08 00:01:27.547131
3299	2026-01-23 21:30:00	4	2.12	220	598.2	t	2026-05-08 00:01:27.547131
3300	2026-01-23 21:30:00	7	2.06	220	418.1	t	2026-05-08 00:01:27.547131
3301	2026-01-23 22:00:00	1	2.47	220	377.2	t	2026-05-08 00:01:27.547131
3302	2026-01-23 22:00:00	4	3.36	220	417.7	t	2026-05-08 00:01:27.547131
3303	2026-01-23 22:00:00	7	2.59	220	431.1	t	2026-05-08 00:01:27.547131
3304	2026-01-23 22:30:00	1	1.61	220	784.6	t	2026-05-08 00:01:27.547131
3305	2026-01-23 22:30:00	4	1.7	220	514.7	t	2026-05-08 00:01:27.547131
3306	2026-01-23 22:30:00	7	1.63	220	508.4	t	2026-05-08 00:01:27.547131
3307	2026-01-23 23:00:00	1	1.56	220	577.6	t	2026-05-08 00:01:27.547131
3308	2026-01-23 23:00:00	4	1.37	220	589.7	t	2026-05-08 00:01:27.547131
3309	2026-01-23 23:00:00	7	1.71	220	453.5	t	2026-05-08 00:01:27.547131
3310	2026-01-23 23:30:00	1	1.34	220	278.9	t	2026-05-08 00:01:27.547131
3311	2026-01-23 23:30:00	4	1.4	220	361.7	t	2026-05-08 00:01:27.547131
3312	2026-01-23 23:30:00	7	2.45	220	363.1	t	2026-05-08 00:01:27.547131
3313	2026-01-24 00:00:00	1	2.51	220	308.8	t	2026-05-08 00:01:27.547131
3314	2026-01-24 00:00:00	4	2.65	220	517.5	t	2026-05-08 00:01:27.547131
3315	2026-01-24 00:00:00	7	2.94	220	516.2	t	2026-05-08 00:01:27.547131
3316	2026-01-24 00:30:00	1	2.86	220	345.2	t	2026-05-08 00:01:27.547131
3317	2026-01-24 00:30:00	4	2.9	220	535.4	t	2026-05-08 00:01:27.547131
3318	2026-01-24 00:30:00	7	1.11	220	284.4	t	2026-05-08 00:01:27.547131
3319	2026-01-24 01:00:00	1	2.66	220	501.9	t	2026-05-08 00:01:27.547131
3320	2026-01-24 01:00:00	4	1.17	220	274.1	t	2026-05-08 00:01:27.547131
3321	2026-01-24 01:00:00	7	2.72	220	348.6	t	2026-05-08 00:01:27.547131
3322	2026-01-24 01:30:00	1	2.34	220	550.6	t	2026-05-08 00:01:27.547131
3323	2026-01-24 01:30:00	4	2.42	220	444.1	t	2026-05-08 00:01:27.547131
3324	2026-01-24 01:30:00	7	2	220	344.2	t	2026-05-08 00:01:27.547131
3325	2026-01-24 02:00:00	1	2.15	220	618	t	2026-05-08 00:01:27.547131
3326	2026-01-24 02:00:00	4	1.19	220	451.5	t	2026-05-08 00:01:27.547131
3327	2026-01-24 02:00:00	7	2.2	220	506.4	t	2026-05-08 00:01:27.547131
3328	2026-01-24 02:30:00	1	2.67	220	410.6	t	2026-05-08 00:01:27.547131
3329	2026-01-24 02:30:00	4	2.33	220	384.9	t	2026-05-08 00:01:27.547131
3330	2026-01-24 02:30:00	7	2.09	220	274.6	t	2026-05-08 00:01:27.547131
3331	2026-01-24 03:00:00	1	1.84	220	391	t	2026-05-08 00:01:27.547131
3332	2026-01-24 03:00:00	4	2.51	220	623.9	t	2026-05-08 00:01:27.547131
3333	2026-01-24 03:00:00	7	1.17	220	603	t	2026-05-08 00:01:27.547131
3334	2026-01-24 03:30:00	1	1.1	220	325.8	t	2026-05-08 00:01:27.547131
3335	2026-01-24 03:30:00	4	1.42	220	638.7	t	2026-05-08 00:01:27.547131
3336	2026-01-24 03:30:00	7	2.68	220	262.3	t	2026-05-08 00:01:27.547131
3337	2026-01-24 04:00:00	1	2.84	220	489.8	t	2026-05-08 00:01:27.547131
3338	2026-01-24 04:00:00	4	1.45	220	499	t	2026-05-08 00:01:27.547131
3339	2026-01-24 04:00:00	7	1.53	220	468.5	t	2026-05-08 00:01:27.547131
3340	2026-01-24 04:30:00	1	1.17	220	554.9	t	2026-05-08 00:01:27.547131
3341	2026-01-24 04:30:00	4	2.71	220	281.9	t	2026-05-08 00:01:27.547131
3342	2026-01-24 04:30:00	7	2.22	220	570.8	t	2026-05-08 00:01:27.547131
3343	2026-01-24 05:00:00	1	1.35	220	586.6	t	2026-05-08 00:01:27.547131
3344	2026-01-24 05:00:00	4	1.55	220	254.2	t	2026-05-08 00:01:27.547131
3345	2026-01-24 05:00:00	7	1.65	220	643.4	t	2026-05-08 00:01:27.547131
3346	2026-01-24 05:30:00	1	1.66	220	618.6	t	2026-05-08 00:01:27.547131
3347	2026-01-24 05:30:00	4	1.04	220	604.2	t	2026-05-08 00:01:27.547131
3348	2026-01-24 05:30:00	7	2.88	220	601.2	t	2026-05-08 00:01:27.547131
3349	2026-01-24 06:00:00	1	1.79	220	616	t	2026-05-08 00:01:27.547131
3350	2026-01-24 06:00:00	4	1.73	220	224.3	t	2026-05-08 00:01:27.547131
3351	2026-01-24 06:00:00	7	1.08	220	433.9	t	2026-05-08 00:01:27.547131
3352	2026-01-24 06:30:00	1	1.03	220	312.5	t	2026-05-08 00:01:27.547131
3353	2026-01-24 06:30:00	4	1.19	220	398.1	t	2026-05-08 00:01:27.547131
3354	2026-01-24 06:30:00	7	2.99	220	656.6	t	2026-05-08 00:01:27.547131
3355	2026-01-24 07:00:00	1	1.45	220	383.9	t	2026-05-08 00:01:27.547131
3356	2026-01-24 07:00:00	4	2.45	220	561	t	2026-05-08 00:01:27.547131
3357	2026-01-24 07:00:00	7	1.88	220	596.6	t	2026-05-08 00:01:27.547131
3358	2026-01-24 07:30:00	1	1.16	220	451.1	t	2026-05-08 00:01:27.547131
3359	2026-01-24 07:30:00	4	2.08	220	395.1	t	2026-05-08 00:01:27.547131
3360	2026-01-24 07:30:00	7	2.14	220	460.1	t	2026-05-08 00:01:27.547131
3361	2026-01-24 08:00:00	1	2.55	220	496.7	t	2026-05-08 00:01:27.547131
3362	2026-01-24 08:00:00	4	2.26	220	573	t	2026-05-08 00:01:27.547131
3363	2026-01-24 08:00:00	7	1.76	220	563.3	t	2026-05-08 00:01:27.547131
3364	2026-01-24 08:30:00	1	2.08	220	613.2	t	2026-05-08 00:01:27.547131
3365	2026-01-24 08:30:00	4	2.53	220	612.4	t	2026-05-08 00:01:27.547131
3366	2026-01-24 08:30:00	7	1.48	220	603	t	2026-05-08 00:01:27.547131
3367	2026-01-24 09:00:00	1	1.63	220	503.1	t	2026-05-08 00:01:27.547131
3368	2026-01-24 09:00:00	4	2.82	220	325.8	t	2026-05-08 00:01:27.547131
3369	2026-01-24 09:00:00	7	1.75	220	493.2	t	2026-05-08 00:01:27.547131
3370	2026-01-24 09:30:00	1	1.09	220	470.2	t	2026-05-08 00:01:27.547131
3371	2026-01-24 09:30:00	4	1.27	220	597.9	t	2026-05-08 00:01:27.547131
3372	2026-01-24 09:30:00	7	1.04	220	471.9	t	2026-05-08 00:01:27.547131
3373	2026-01-24 10:00:00	1	1.69	220	456.7	t	2026-05-08 00:01:27.547131
3374	2026-01-24 10:00:00	4	1.39	220	231.5	t	2026-05-08 00:01:27.547131
3375	2026-01-24 10:00:00	7	1.29	220	361.9	t	2026-05-08 00:01:27.547131
3376	2026-01-24 10:30:00	1	2.85	220	342.7	t	2026-05-08 00:01:27.547131
3377	2026-01-24 10:30:00	4	1.61	220	469.8	t	2026-05-08 00:01:27.547131
3378	2026-01-24 10:30:00	7	2.93	220	572.8	t	2026-05-08 00:01:27.547131
3379	2026-01-24 11:00:00	1	2.86	220	609.6	t	2026-05-08 00:01:27.547131
3380	2026-01-24 11:00:00	4	2.2	220	508.5	t	2026-05-08 00:01:27.547131
3381	2026-01-24 11:00:00	7	2.39	220	222.4	t	2026-05-08 00:01:27.547131
3382	2026-01-24 11:30:00	1	3	220	379.9	t	2026-05-08 00:01:27.547131
3383	2026-01-24 11:30:00	4	2.04	220	333.8	t	2026-05-08 00:01:27.547131
3384	2026-01-24 11:30:00	7	1.48	220	322.7	t	2026-05-08 00:01:27.547131
3385	2026-01-24 12:00:00	1	2.14	220	235.7	t	2026-05-08 00:01:27.547131
3386	2026-01-24 12:00:00	4	2.02	220	235.2	t	2026-05-08 00:01:27.547131
3387	2026-01-24 12:00:00	7	2.88	220	604.7	t	2026-05-08 00:01:27.547131
3388	2026-01-24 12:30:00	1	2.67	220	403.7	t	2026-05-08 00:01:27.547131
3389	2026-01-24 12:30:00	4	2.99	220	338.5	t	2026-05-08 00:01:27.547131
3390	2026-01-24 12:30:00	7	1.48	220	270.1	t	2026-05-08 00:01:27.547131
3391	2026-01-24 13:00:00	1	1.77	220	222.5	t	2026-05-08 00:01:27.547131
3392	2026-01-24 13:00:00	4	2.95	220	270.9	t	2026-05-08 00:01:27.547131
3393	2026-01-24 13:00:00	7	2.78	220	416.1	t	2026-05-08 00:01:27.547131
3394	2026-01-24 13:30:00	1	3	220	363.6	t	2026-05-08 00:01:27.547131
3395	2026-01-24 13:30:00	4	3	220	466.6	t	2026-05-08 00:01:27.547131
3396	2026-01-24 13:30:00	7	2.68	220	460.7	t	2026-05-08 00:01:27.547131
3397	2026-01-24 14:00:00	1	2.51	220	366.7	t	2026-05-08 00:01:27.547131
3398	2026-01-24 14:00:00	4	2.18	220	524.3	t	2026-05-08 00:01:27.547131
3399	2026-01-24 14:00:00	7	2.06	220	481.7	t	2026-05-08 00:01:27.547131
3400	2026-01-24 14:30:00	1	1.38	220	480.2	t	2026-05-08 00:01:27.547131
3401	2026-01-24 14:30:00	4	1.48	220	407.5	t	2026-05-08 00:01:27.547131
3402	2026-01-24 14:30:00	7	2.42	220	349.4	t	2026-05-08 00:01:27.547131
3403	2026-01-24 15:00:00	1	2	220	651.7	t	2026-05-08 00:01:27.547131
3404	2026-01-24 15:00:00	4	1.72	220	497.4	t	2026-05-08 00:01:27.547131
3405	2026-01-24 15:00:00	7	2.47	220	272.2	t	2026-05-08 00:01:27.547131
3406	2026-01-24 15:30:00	1	2.3	220	536.5	t	2026-05-08 00:01:27.547131
3407	2026-01-24 15:30:00	4	2.53	220	653.4	t	2026-05-08 00:01:27.547131
3408	2026-01-24 15:30:00	7	1.76	220	331	t	2026-05-08 00:01:27.547131
3409	2026-01-24 16:00:00	1	1.28	220	495.9	t	2026-05-08 00:01:27.547131
3410	2026-01-24 16:00:00	4	1.06	220	371.2	t	2026-05-08 00:01:27.547131
3411	2026-01-24 16:00:00	7	1.78	220	269.1	t	2026-05-08 00:01:27.547131
3412	2026-01-24 16:30:00	1	1.68	220	531.2	t	2026-05-08 00:01:27.547131
3413	2026-01-24 16:30:00	4	1.35	220	612.3	t	2026-05-08 00:01:27.547131
3414	2026-01-24 16:30:00	7	2.61	220	478.6	t	2026-05-08 00:01:27.547131
3415	2026-01-24 17:00:00	1	1.78	220	573.3	t	2026-05-08 00:01:27.547131
3416	2026-01-24 17:00:00	4	2.9	220	511.2	t	2026-05-08 00:01:27.547131
3417	2026-01-24 17:00:00	7	2.41	220	622.4	t	2026-05-08 00:01:27.547131
3418	2026-01-24 17:30:00	1	2.9	220	313.5	t	2026-05-08 00:01:27.547131
3419	2026-01-24 17:30:00	4	2.66	220	428.9	t	2026-05-08 00:01:27.547131
3420	2026-01-24 17:30:00	7	1.67	220	544.3	t	2026-05-08 00:01:27.547131
3421	2026-01-24 18:00:00	1	2.37	220	517.5	t	2026-05-08 00:01:27.547131
3422	2026-01-24 18:00:00	4	1.74	220	535.5	t	2026-05-08 00:01:27.547131
3423	2026-01-24 18:00:00	7	2.99	220	576.8	t	2026-05-08 00:01:27.547131
3424	2026-01-24 18:30:00	1	1.7	220	248.6	t	2026-05-08 00:01:27.547131
3425	2026-01-24 18:30:00	4	1.91	220	295.1	t	2026-05-08 00:01:27.547131
3426	2026-01-24 18:30:00	7	2.61	220	564.5	t	2026-05-08 00:01:27.547131
3427	2026-01-24 19:00:00	1	1.96	220	288.4	t	2026-05-08 00:01:27.547131
3428	2026-01-24 19:00:00	4	1.71	220	437	t	2026-05-08 00:01:27.547131
3429	2026-01-24 19:00:00	7	1.39	220	585.2	t	2026-05-08 00:01:27.547131
3430	2026-01-24 19:30:00	1	1.67	220	339.3	t	2026-05-08 00:01:27.547131
3431	2026-01-24 19:30:00	4	2.04	220	620.8	t	2026-05-08 00:01:27.547131
3432	2026-01-24 19:30:00	7	1.96	220	633.5	t	2026-05-08 00:01:27.547131
3433	2026-01-24 20:00:00	1	1.52	220	586.3	t	2026-05-08 00:01:27.547131
3434	2026-01-24 20:00:00	4	1.97	220	305	t	2026-05-08 00:01:27.547131
3435	2026-01-24 20:00:00	7	1.79	220	425.4	t	2026-05-08 00:01:27.547131
3436	2026-01-24 20:30:00	1	1.72	220	349.1	t	2026-05-08 00:01:27.547131
3437	2026-01-24 20:30:00	4	2.71	220	595.4	t	2026-05-08 00:01:27.547131
3438	2026-01-24 20:30:00	7	2.87	220	637	t	2026-05-08 00:01:27.547131
3439	2026-01-24 21:00:00	1	2.09	220	654.7	t	2026-05-08 00:01:27.547131
3440	2026-01-24 21:00:00	4	2.68	220	360.1	t	2026-05-08 00:01:27.547131
3441	2026-01-24 21:00:00	7	2.45	220	385.1	t	2026-05-08 00:01:27.547131
3442	2026-01-24 21:30:00	1	1.31	220	611.5	t	2026-05-08 00:01:27.547131
3443	2026-01-24 21:30:00	4	1.74	220	480.7	t	2026-05-08 00:01:27.547131
3444	2026-01-24 21:30:00	7	2.23	220	456.6	t	2026-05-08 00:01:27.547131
3445	2026-01-24 22:00:00	1	2.22	220	480.9	t	2026-05-08 00:01:27.547131
3446	2026-01-24 22:00:00	4	1.1	220	272.1	t	2026-05-08 00:01:27.547131
3447	2026-01-24 22:00:00	7	2.83	220	637.4	t	2026-05-08 00:01:27.547131
3448	2026-01-24 22:30:00	1	1.78	220	422.7	t	2026-05-08 00:01:27.547131
3449	2026-01-24 22:30:00	4	1.08	220	618.2	t	2026-05-08 00:01:27.547131
3450	2026-01-24 22:30:00	7	2.51	220	497.8	t	2026-05-08 00:01:27.547131
3451	2026-01-24 23:00:00	1	2.01	220	269.5	t	2026-05-08 00:01:27.547131
3452	2026-01-24 23:00:00	4	1.21	220	419.2	t	2026-05-08 00:01:27.547131
3453	2026-01-24 23:00:00	7	2.63	220	252.2	t	2026-05-08 00:01:27.547131
3454	2026-01-24 23:30:00	1	2.2	220	266.4	t	2026-05-08 00:01:27.547131
3455	2026-01-24 23:30:00	4	2.89	220	572	t	2026-05-08 00:01:27.547131
3456	2026-01-24 23:30:00	7	1.03	220	360.5	t	2026-05-08 00:01:27.547131
3457	2026-01-25 00:00:00	1	2.37	220	432	t	2026-05-08 00:01:27.547131
3458	2026-01-25 00:00:00	4	1.07	220	617.8	t	2026-05-08 00:01:27.547131
3459	2026-01-25 00:00:00	7	2.35	220	426.4	t	2026-05-08 00:01:27.547131
3460	2026-01-25 00:30:00	1	1.89	220	301.5	t	2026-05-08 00:01:27.547131
3461	2026-01-25 00:30:00	4	2.66	220	627	t	2026-05-08 00:01:27.547131
3462	2026-01-25 00:30:00	7	1.97	220	619.8	t	2026-05-08 00:01:27.547131
3463	2026-01-25 01:00:00	1	2.93	220	394.7	t	2026-05-08 00:01:27.547131
3464	2026-01-25 01:00:00	4	2.51	220	613	t	2026-05-08 00:01:27.547131
3465	2026-01-25 01:00:00	7	2.85	220	346.5	t	2026-05-08 00:01:27.547131
3466	2026-01-25 01:30:00	1	1.52	220	474.1	t	2026-05-08 00:01:27.547131
3467	2026-01-25 01:30:00	4	1.43	220	389.7	t	2026-05-08 00:01:27.547131
3468	2026-01-25 01:30:00	7	2.11	220	355	t	2026-05-08 00:01:27.547131
3469	2026-01-25 02:00:00	1	1.98	220	473.3	t	2026-05-08 00:01:27.547131
3470	2026-01-25 02:00:00	4	1.88	220	389.2	t	2026-05-08 00:01:27.547131
3471	2026-01-25 02:00:00	7	1.5	220	302.5	t	2026-05-08 00:01:27.547131
3472	2026-01-25 02:30:00	1	1.14	220	479.4	t	2026-05-08 00:01:27.547131
3473	2026-01-25 02:30:00	4	2	220	603.2	t	2026-05-08 00:01:27.547131
3474	2026-01-25 02:30:00	7	1.44	220	443.1	t	2026-05-08 00:01:27.547131
3475	2026-01-25 03:00:00	1	1.05	220	265.9	t	2026-05-08 00:01:27.547131
3476	2026-01-25 03:00:00	4	2.45	220	436	t	2026-05-08 00:01:27.547131
3477	2026-01-25 03:00:00	7	2.91	220	621.6	t	2026-05-08 00:01:27.547131
3478	2026-01-25 03:30:00	1	2.97	220	638.7	t	2026-05-08 00:01:27.547131
3479	2026-01-25 03:30:00	4	1	220	302.4	t	2026-05-08 00:01:27.547131
3480	2026-01-25 03:30:00	7	1.85	220	281.4	t	2026-05-08 00:01:27.547131
3481	2026-01-25 04:00:00	1	2.4	220	391.6	t	2026-05-08 00:01:27.547131
3482	2026-01-25 04:00:00	4	1.76	220	392.5	t	2026-05-08 00:01:27.547131
3483	2026-01-25 04:00:00	7	1.46	220	631.5	t	2026-05-08 00:01:27.547131
3484	2026-01-25 04:30:00	1	1.23	220	566.3	t	2026-05-08 00:01:27.547131
3485	2026-01-25 04:30:00	4	1.38	220	516.1	t	2026-05-08 00:01:27.547131
3486	2026-01-25 04:30:00	7	1.15	220	421.5	t	2026-05-08 00:01:27.547131
3487	2026-01-25 05:00:00	1	2.61	220	559.9	t	2026-05-08 00:01:27.547131
3488	2026-01-25 05:00:00	4	3	220	476.5	t	2026-05-08 00:01:27.547131
3489	2026-01-25 05:00:00	7	1.46	220	428.1	t	2026-05-08 00:01:27.547131
3490	2026-01-25 05:30:00	1	1.6	220	386.3	t	2026-05-08 00:01:27.547131
3491	2026-01-25 05:30:00	4	1.12	220	350.7	t	2026-05-08 00:01:27.547131
3492	2026-01-25 05:30:00	7	1.18	220	644.7	t	2026-05-08 00:01:27.547131
3493	2026-01-25 06:00:00	1	2.18	220	536.6	t	2026-05-08 00:01:27.547131
3494	2026-01-25 06:00:00	4	2.07	220	417.7	t	2026-05-08 00:01:27.547131
3495	2026-01-25 06:00:00	7	1.31	220	333.5	t	2026-05-08 00:01:27.547131
3496	2026-01-25 06:30:00	1	1.58	220	511.1	t	2026-05-08 00:01:27.547131
3497	2026-01-25 06:30:00	4	1.57	220	318.8	t	2026-05-08 00:01:27.547131
3498	2026-01-25 06:30:00	7	1.72	220	522.5	t	2026-05-08 00:01:27.547131
3499	2026-01-25 07:00:00	1	2.41	220	328.9	t	2026-05-08 00:01:27.547131
3500	2026-01-25 07:00:00	4	1.85	220	260.3	t	2026-05-08 00:01:27.547131
3501	2026-01-25 07:00:00	7	2.79	220	318.1	t	2026-05-08 00:01:27.547131
3502	2026-01-25 07:30:00	1	2.91	220	381.8	t	2026-05-08 00:01:27.547131
3503	2026-01-25 07:30:00	4	2.44	220	231.1	t	2026-05-08 00:01:27.547131
3504	2026-01-25 07:30:00	7	2.55	220	623.8	t	2026-05-08 00:01:27.547131
3505	2026-01-25 08:00:00	1	2.68	220	621.2	t	2026-05-08 00:01:27.547131
3506	2026-01-25 08:00:00	4	2.94	220	476.2	t	2026-05-08 00:01:27.547131
3507	2026-01-25 08:00:00	7	2.86	220	291.2	t	2026-05-08 00:01:27.547131
3508	2026-01-25 08:30:00	1	2.99	220	392.7	t	2026-05-08 00:01:27.547131
3509	2026-01-25 08:30:00	4	2.75	220	463.1	t	2026-05-08 00:01:27.547131
3510	2026-01-25 08:30:00	7	2.41	220	355.6	t	2026-05-08 00:01:27.547131
3511	2026-01-25 09:00:00	1	2.6	220	304.6	t	2026-05-08 00:01:27.547131
3512	2026-01-25 09:00:00	4	1.69	220	454.3	t	2026-05-08 00:01:27.547131
3513	2026-01-25 09:00:00	7	2.39	220	515	t	2026-05-08 00:01:27.547131
3514	2026-01-25 09:30:00	1	2.04	220	635.7	t	2026-05-08 00:01:27.547131
3515	2026-01-25 09:30:00	4	1.93	220	416.8	t	2026-05-08 00:01:27.547131
3516	2026-01-25 09:30:00	7	1.74	220	627	t	2026-05-08 00:01:27.547131
3517	2026-01-25 10:00:00	1	2.61	220	399.3	t	2026-05-08 00:01:27.547131
3518	2026-01-25 10:00:00	4	2.25	220	632.7	t	2026-05-08 00:01:27.547131
3519	2026-01-25 10:00:00	7	2.83	220	498.1	t	2026-05-08 00:01:27.547131
3520	2026-01-25 10:30:00	1	2.22	220	241.4	t	2026-05-08 00:01:27.547131
3521	2026-01-25 10:30:00	4	2.19	220	368.9	t	2026-05-08 00:01:27.547131
3522	2026-01-25 10:30:00	7	1.14	220	293.5	t	2026-05-08 00:01:27.547131
3523	2026-01-25 11:00:00	1	1.64	220	626.9	t	2026-05-08 00:01:27.547131
3524	2026-01-25 11:00:00	4	2.45	220	395.8	t	2026-05-08 00:01:27.547131
3525	2026-01-25 11:00:00	7	2.02	220	617.4	t	2026-05-08 00:01:27.547131
3526	2026-01-25 11:30:00	1	2.41	220	561.1	t	2026-05-08 00:01:27.547131
3527	2026-01-25 11:30:00	4	1.12	220	400.5	t	2026-05-08 00:01:27.547131
3528	2026-01-25 11:30:00	7	1.9	220	272.9	t	2026-05-08 00:01:27.547131
3529	2026-01-25 12:00:00	1	1.77	220	653.1	t	2026-05-08 00:01:27.547131
3530	2026-01-25 12:00:00	4	2.78	220	332.9	t	2026-05-08 00:01:27.547131
3531	2026-01-25 12:00:00	7	2.44	220	516.9	t	2026-05-08 00:01:27.547131
3532	2026-01-25 12:30:00	1	1.31	220	393.2	t	2026-05-08 00:01:27.547131
3533	2026-01-25 12:30:00	4	1.21	220	473.3	t	2026-05-08 00:01:27.547131
3534	2026-01-25 12:30:00	7	1.51	220	343.9	t	2026-05-08 00:01:27.547131
3535	2026-01-25 13:00:00	1	1.67	220	264.4	t	2026-05-08 00:01:27.547131
3536	2026-01-25 13:00:00	4	1.54	220	494.3	t	2026-05-08 00:01:27.547131
3537	2026-01-25 13:00:00	7	2.7	220	257.6	t	2026-05-08 00:01:27.547131
3538	2026-01-25 13:30:00	1	1.45	220	363.5	t	2026-05-08 00:01:27.547131
3539	2026-01-25 13:30:00	4	2.62	220	538.4	t	2026-05-08 00:01:27.547131
3540	2026-01-25 13:30:00	7	2.14	220	330.2	t	2026-05-08 00:01:27.547131
3541	2026-01-25 14:00:00	1	1.93	220	546.1	t	2026-05-08 00:01:27.547131
3542	2026-01-25 14:00:00	4	2.24	220	267.4	t	2026-05-08 00:01:27.547131
3543	2026-01-25 14:00:00	7	2.23	220	377.2	t	2026-05-08 00:01:27.547131
3544	2026-01-25 14:30:00	1	1.8	220	649.4	t	2026-05-08 00:01:27.547131
3545	2026-01-25 14:30:00	4	1.91	220	317.5	t	2026-05-08 00:01:27.547131
3546	2026-01-25 14:30:00	7	1.11	220	361.3	t	2026-05-08 00:01:27.547131
3547	2026-01-25 15:00:00	1	1.15	220	292.1	t	2026-05-08 00:01:27.547131
3548	2026-01-25 15:00:00	4	1.29	220	414.1	t	2026-05-08 00:01:27.547131
3549	2026-01-25 15:00:00	7	1.35	220	295.9	t	2026-05-08 00:01:27.547131
3550	2026-01-25 15:30:00	1	1.03	220	630.2	t	2026-05-08 00:01:27.547131
3551	2026-01-25 15:30:00	4	1.73	220	332.2	t	2026-05-08 00:01:27.547131
3552	2026-01-25 15:30:00	7	1.69	220	578.9	t	2026-05-08 00:01:27.547131
3553	2026-01-25 16:00:00	1	1.76	220	369.7	t	2026-05-08 00:01:27.547131
3554	2026-01-25 16:00:00	4	1.61	220	336.8	t	2026-05-08 00:01:27.547131
3555	2026-01-25 16:00:00	7	1.6	220	477.6	t	2026-05-08 00:01:27.547131
3556	2026-01-25 16:30:00	1	1.27	220	536.7	t	2026-05-08 00:01:27.547131
3557	2026-01-25 16:30:00	4	1.02	220	331.4	t	2026-05-08 00:01:27.547131
3558	2026-01-25 16:30:00	7	1.82	220	581.8	t	2026-05-08 00:01:27.547131
3559	2026-01-25 17:00:00	1	2.77	220	269.1	t	2026-05-08 00:01:27.547131
3560	2026-01-25 17:00:00	4	1.21	220	398	t	2026-05-08 00:01:27.547131
3561	2026-01-25 17:00:00	7	1.67	220	558	t	2026-05-08 00:01:27.547131
3562	2026-01-25 17:30:00	1	2.95	220	231.4	t	2026-05-08 00:01:27.547131
3563	2026-01-25 17:30:00	4	2.18	220	370.2	t	2026-05-08 00:01:27.547131
3564	2026-01-25 17:30:00	7	1.19	220	453.4	t	2026-05-08 00:01:27.547131
3565	2026-01-25 18:00:00	1	2.53	220	382.3	t	2026-05-08 00:01:27.547131
3566	2026-01-25 18:00:00	4	1.86	220	231.7	t	2026-05-08 00:01:27.547131
3567	2026-01-25 18:00:00	7	1.58	220	634.1	t	2026-05-08 00:01:27.547131
3568	2026-01-25 18:30:00	1	2.83	220	245.7	t	2026-05-08 00:01:27.547131
3569	2026-01-25 18:30:00	4	1.6	220	446.8	t	2026-05-08 00:01:27.547131
3570	2026-01-25 18:30:00	7	2.53	220	539.7	t	2026-05-08 00:01:27.547131
3571	2026-01-25 19:00:00	1	2.41	220	429.2	t	2026-05-08 00:01:27.547131
3572	2026-01-25 19:00:00	4	2.89	220	435.9	t	2026-05-08 00:01:27.547131
3573	2026-01-25 19:00:00	7	1.25	220	509.7	t	2026-05-08 00:01:27.547131
3574	2026-01-25 19:30:00	1	1.17	220	596.8	t	2026-05-08 00:01:27.547131
3575	2026-01-25 19:30:00	4	1.04	220	545.5	t	2026-05-08 00:01:27.547131
3576	2026-01-25 19:30:00	7	1.47	220	286.9	t	2026-05-08 00:01:27.547131
3577	2026-01-25 20:00:00	1	2.6	220	422.1	t	2026-05-08 00:01:27.547131
3578	2026-01-25 20:00:00	4	1.7	220	377.9	t	2026-05-08 00:01:27.547131
3579	2026-01-25 20:00:00	7	2.21	220	455.5	t	2026-05-08 00:01:27.547131
3580	2026-01-25 20:30:00	1	1.45	220	515.1	t	2026-05-08 00:01:27.547131
3581	2026-01-25 20:30:00	4	2.5	220	370.1	t	2026-05-08 00:01:27.547131
3582	2026-01-25 20:30:00	7	2.08	220	636.4	t	2026-05-08 00:01:27.547131
3583	2026-01-25 21:00:00	1	2.13	220	537.9	t	2026-05-08 00:01:27.547131
3584	2026-01-25 21:00:00	4	2.66	220	371.9	t	2026-05-08 00:01:27.547131
3585	2026-01-25 21:00:00	7	1.92	220	419.7	t	2026-05-08 00:01:27.547131
3586	2026-01-25 21:30:00	1	2.34	220	458.3	t	2026-05-08 00:01:27.547131
3587	2026-01-25 21:30:00	4	1.17	220	565.2	t	2026-05-08 00:01:27.547131
3588	2026-01-25 21:30:00	7	2.34	220	577.6	t	2026-05-08 00:01:27.547131
3589	2026-01-25 22:00:00	1	2.79	220	564	t	2026-05-08 00:01:27.547131
3590	2026-01-25 22:00:00	4	1.49	220	432.8	t	2026-05-08 00:01:27.547131
3591	2026-01-25 22:00:00	7	2.77	220	425.5	t	2026-05-08 00:01:27.547131
3592	2026-01-25 22:30:00	1	2.9	220	617.6	t	2026-05-08 00:01:27.547131
3593	2026-01-25 22:30:00	4	2.58	220	406.8	t	2026-05-08 00:01:27.547131
3594	2026-01-25 22:30:00	7	1.36	220	263.3	t	2026-05-08 00:01:27.547131
3595	2026-01-25 23:00:00	1	1.06	220	436.8	t	2026-05-08 00:01:27.547131
3596	2026-01-25 23:00:00	4	2.16	220	295.7	t	2026-05-08 00:01:27.547131
3597	2026-01-25 23:00:00	7	1.64	220	372.1	t	2026-05-08 00:01:27.547131
3598	2026-01-25 23:30:00	1	2.96	220	262.1	t	2026-05-08 00:01:27.547131
3599	2026-01-25 23:30:00	4	2.79	220	522.9	t	2026-05-08 00:01:27.547131
3600	2026-01-25 23:30:00	7	1.76	220	455.5	t	2026-05-08 00:01:27.547131
3601	2026-01-26 00:00:00	1	2.88	220	287	t	2026-05-08 00:01:27.547131
3602	2026-01-26 00:00:00	4	2.85	220	610.2	t	2026-05-08 00:01:27.547131
3603	2026-01-26 00:00:00	7	2.67	220	615.2	t	2026-05-08 00:01:27.547131
3604	2026-01-26 00:30:00	1	2.15	220	299.8	t	2026-05-08 00:01:27.547131
3605	2026-01-26 00:30:00	4	1.45	220	713.7	t	2026-05-08 00:01:27.547131
3606	2026-01-26 00:30:00	7	1.84	220	639.1	t	2026-05-08 00:01:27.547131
3607	2026-01-26 01:00:00	1	3.37	220	680.5	t	2026-05-08 00:01:27.547131
3608	2026-01-26 01:00:00	4	1.92	220	660.7	t	2026-05-08 00:01:27.547131
3609	2026-01-26 01:00:00	7	3	220	769.8	t	2026-05-08 00:01:27.547131
3610	2026-01-26 01:30:00	1	2.25	220	371.5	t	2026-05-08 00:01:27.547131
3611	2026-01-26 01:30:00	4	2.71	220	589.6	t	2026-05-08 00:01:27.547131
3612	2026-01-26 01:30:00	7	2.81	220	435.4	t	2026-05-08 00:01:27.547131
3613	2026-01-26 02:00:00	1	2.29	220	675.9	t	2026-05-08 00:01:27.547131
3614	2026-01-26 02:00:00	4	2.16	220	597.6	t	2026-05-08 00:01:27.547131
3615	2026-01-26 02:00:00	7	3.52	220	391.8	t	2026-05-08 00:01:27.547131
3616	2026-01-26 02:30:00	1	2.03	220	300.4	t	2026-05-08 00:01:27.547131
3617	2026-01-26 02:30:00	4	2.92	220	646.3	t	2026-05-08 00:01:27.547131
3618	2026-01-26 02:30:00	7	2.06	220	264.3	t	2026-05-08 00:01:27.547131
3619	2026-01-26 03:00:00	1	2.34	220	710.2	t	2026-05-08 00:01:27.547131
3620	2026-01-26 03:00:00	4	2.57	220	739.3	t	2026-05-08 00:01:27.547131
3621	2026-01-26 03:00:00	7	1.89	220	464.3	t	2026-05-08 00:01:27.547131
3622	2026-01-26 03:30:00	1	2.67	220	669.2	t	2026-05-08 00:01:27.547131
3623	2026-01-26 03:30:00	4	2.24	220	395.3	t	2026-05-08 00:01:27.547131
3624	2026-01-26 03:30:00	7	2.79	220	287.6	t	2026-05-08 00:01:27.547131
3625	2026-01-26 04:00:00	1	1.84	220	618.5	t	2026-05-08 00:01:27.547131
3626	2026-01-26 04:00:00	4	3.4	220	607.2	t	2026-05-08 00:01:27.547131
3627	2026-01-26 04:00:00	7	2.35	220	403.4	t	2026-05-08 00:01:27.547131
3628	2026-01-26 04:30:00	1	3.57	220	385.3	t	2026-05-08 00:01:27.547131
3629	2026-01-26 04:30:00	4	1.55	220	603.6	t	2026-05-08 00:01:27.547131
3630	2026-01-26 04:30:00	7	3.66	220	324.7	t	2026-05-08 00:01:27.547131
3631	2026-01-26 05:00:00	1	1.6	220	726.9	t	2026-05-08 00:01:27.547131
3632	2026-01-26 05:00:00	4	1.27	220	297.1	t	2026-05-08 00:01:27.547131
3633	2026-01-26 05:00:00	7	2.71	220	349.1	t	2026-05-08 00:01:27.547131
3634	2026-01-26 05:30:00	1	2.9	220	661.9	t	2026-05-08 00:01:27.547131
3635	2026-01-26 05:30:00	4	1.96	220	684	t	2026-05-08 00:01:27.547131
3636	2026-01-26 05:30:00	7	3.24	220	424.3	t	2026-05-08 00:01:27.547131
3637	2026-01-26 06:00:00	1	1.3	220	483.4	t	2026-05-08 00:01:27.547131
3638	2026-01-26 06:00:00	4	2.19	220	485.3	t	2026-05-08 00:01:27.547131
3639	2026-01-26 06:00:00	7	1.73	220	629.7	t	2026-05-08 00:01:27.547131
3640	2026-01-26 06:30:00	1	3.1	220	518.9	t	2026-05-08 00:01:27.547131
3641	2026-01-26 06:30:00	4	3.1	220	523.6	t	2026-05-08 00:01:27.547131
3642	2026-01-26 06:30:00	7	2.64	220	552.8	t	2026-05-08 00:01:27.547131
3643	2026-01-26 07:00:00	1	20.49	220	4361.9	t	2026-05-08 00:01:27.547131
3644	2026-01-26 07:00:00	4	20.12	220	5597.1	t	2026-05-08 00:01:27.547131
3645	2026-01-26 07:00:00	7	21.91	220	5934.4	t	2026-05-08 00:01:27.547131
3646	2026-01-26 07:30:00	1	14.44	220	3986.6	t	2026-05-08 00:01:27.547131
3647	2026-01-26 07:30:00	4	25.89	220	3907.7	t	2026-05-08 00:01:27.547131
3648	2026-01-26 07:30:00	7	22.35	220	6027.1	t	2026-05-08 00:01:27.547131
3649	2026-01-26 08:00:00	1	12.86	220	2999.6	t	2026-05-08 00:01:27.547131
3650	2026-01-26 08:00:00	4	19.38	220	5177.3	t	2026-05-08 00:01:27.547131
3651	2026-01-26 08:00:00	7	27.35	220	5593.1	t	2026-05-08 00:01:27.547131
3652	2026-01-26 08:30:00	1	17.85	220	3409.1	t	2026-05-08 00:01:27.547131
3653	2026-01-26 08:30:00	4	16.39	220	4855.8	t	2026-05-08 00:01:27.547131
3654	2026-01-26 08:30:00	7	25.02	220	4983.5	t	2026-05-08 00:01:27.547131
3655	2026-01-26 09:00:00	1	11.66	220	4303.1	t	2026-05-08 00:01:27.547131
3656	2026-01-26 09:00:00	4	19.31	220	5370.6	t	2026-05-08 00:01:27.547131
3657	2026-01-26 09:00:00	7	24.47	220	5954.4	t	2026-05-08 00:01:27.547131
3658	2026-01-26 09:30:00	1	13.25	220	2828.4	t	2026-05-08 00:01:27.547131
3659	2026-01-26 09:30:00	4	21.34	220	5127.5	t	2026-05-08 00:01:27.547131
3660	2026-01-26 09:30:00	7	24.68	220	5682.7	t	2026-05-08 00:01:27.547131
3661	2026-01-26 10:00:00	1	12.44	220	4493	t	2026-05-08 00:01:27.547131
3662	2026-01-26 10:00:00	4	18.7	220	5638.5	t	2026-05-08 00:01:27.547131
3663	2026-01-26 10:00:00	7	25.97	220	5582.1	t	2026-05-08 00:01:27.547131
3664	2026-01-26 10:30:00	1	13.86	220	4426	t	2026-05-08 00:01:27.547131
3665	2026-01-26 10:30:00	4	23.57	220	3665.6	t	2026-05-08 00:01:27.547131
3666	2026-01-26 10:30:00	7	22.46	220	4518.1	t	2026-05-08 00:01:27.547131
3667	2026-01-26 11:00:00	1	21.25	220	4270.8	t	2026-05-08 00:01:27.547131
3668	2026-01-26 11:00:00	4	16.98	220	4519.3	t	2026-05-08 00:01:27.547131
3669	2026-01-26 11:00:00	7	22.85	220	5307.8	t	2026-05-08 00:01:27.547131
3670	2026-01-26 11:30:00	1	17.63	220	4369.2	t	2026-05-08 00:01:27.547131
3671	2026-01-26 11:30:00	4	19.13	220	5410.5	t	2026-05-08 00:01:27.547131
3672	2026-01-26 11:30:00	7	26.12	220	6521.3	t	2026-05-08 00:01:27.547131
3673	2026-01-26 12:00:00	1	21.01	220	4263.1	t	2026-05-08 00:01:27.547131
3674	2026-01-26 12:00:00	4	23.1	220	3728.4	t	2026-05-08 00:01:27.547131
3675	2026-01-26 12:00:00	7	21.48	220	5422.2	t	2026-05-08 00:01:27.547131
3676	2026-01-26 12:30:00	1	15.45	220	3922.2	t	2026-05-08 00:01:27.547131
3677	2026-01-26 12:30:00	4	25.98	220	3719	t	2026-05-08 00:01:27.547131
3678	2026-01-26 12:30:00	7	28.2	220	6661.6	t	2026-05-08 00:01:27.547131
3679	2026-01-26 13:00:00	1	18.23	220	4030.2	t	2026-05-08 00:01:27.547131
3680	2026-01-26 13:00:00	4	24.78	220	5080.2	t	2026-05-08 00:01:27.547131
3681	2026-01-26 13:00:00	7	30.14	220	5104.3	t	2026-05-08 00:01:27.547131
3682	2026-01-26 13:30:00	1	19.18	220	4587.9	t	2026-05-08 00:01:27.547131
3683	2026-01-26 13:30:00	4	25.95	220	5482.5	t	2026-05-08 00:01:27.547131
3684	2026-01-26 13:30:00	7	21.33	220	6316.9	t	2026-05-08 00:01:27.547131
3685	2026-01-26 14:00:00	1	20.83	220	3112.8	t	2026-05-08 00:01:27.547131
3686	2026-01-26 14:00:00	4	19.39	220	4086.1	t	2026-05-08 00:01:27.547131
3687	2026-01-26 14:00:00	7	29.34	220	4854.5	t	2026-05-08 00:01:27.547131
3688	2026-01-26 14:30:00	1	11.93	220	4513.3	t	2026-05-08 00:01:27.547131
3689	2026-01-26 14:30:00	4	17.02	220	4388	t	2026-05-08 00:01:27.547131
3690	2026-01-26 14:30:00	7	22.81	220	6450.6	t	2026-05-08 00:01:27.547131
3691	2026-01-26 15:00:00	1	18.8	220	2953.5	t	2026-05-08 00:01:27.547131
3692	2026-01-26 15:00:00	4	23.47	220	4094.5	t	2026-05-08 00:01:27.547131
3693	2026-01-26 15:00:00	7	30.45	220	6646.9	t	2026-05-08 00:01:27.547131
3694	2026-01-26 15:30:00	1	13.93	220	3873.8	t	2026-05-08 00:01:27.547131
3695	2026-01-26 15:30:00	4	22.05	220	4660.3	t	2026-05-08 00:01:27.547131
3696	2026-01-26 15:30:00	7	23.35	220	4734.9	t	2026-05-08 00:01:27.547131
3697	2026-01-26 16:00:00	1	13.39	220	2725	t	2026-05-08 00:01:27.547131
3698	2026-01-26 16:00:00	4	20.29	220	3991.9	t	2026-05-08 00:01:27.547131
3699	2026-01-26 16:00:00	7	24.86	220	4824.8	t	2026-05-08 00:01:27.547131
3700	2026-01-26 16:30:00	1	13.62	220	2734.1	t	2026-05-08 00:01:27.547131
3701	2026-01-26 16:30:00	4	19.02	220	5040.2	t	2026-05-08 00:01:27.547131
3702	2026-01-26 16:30:00	7	29.99	220	5653	t	2026-05-08 00:01:27.547131
3703	2026-01-26 17:00:00	1	21.36	220	4610.9	t	2026-05-08 00:01:27.547131
3704	2026-01-26 17:00:00	4	20.59	220	4271.6	t	2026-05-08 00:01:27.547131
3705	2026-01-26 17:00:00	7	23.69	220	5459.1	t	2026-05-08 00:01:27.547131
3706	2026-01-26 17:30:00	1	19.16	220	3538.9	t	2026-05-08 00:01:27.547131
3707	2026-01-26 17:30:00	4	22.31	220	4003.1	t	2026-05-08 00:01:27.547131
3708	2026-01-26 17:30:00	7	28.27	220	6578.2	t	2026-05-08 00:01:27.547131
3709	2026-01-26 18:00:00	1	15.05	220	4665.3	t	2026-05-08 00:01:27.547131
3710	2026-01-26 18:00:00	4	18.82	220	4445	t	2026-05-08 00:01:27.547131
3711	2026-01-26 18:00:00	7	21.52	220	4823	t	2026-05-08 00:01:27.547131
3712	2026-01-26 18:30:00	1	13.24	220	3490.1	t	2026-05-08 00:01:27.547131
3713	2026-01-26 18:30:00	4	21.19	220	4229.3	t	2026-05-08 00:01:27.547131
3714	2026-01-26 18:30:00	7	24.04	220	6704.5	t	2026-05-08 00:01:27.547131
3715	2026-01-26 19:00:00	1	17.08	220	3786	t	2026-05-08 00:01:27.547131
3716	2026-01-26 19:00:00	4	25.75	220	4384.8	t	2026-05-08 00:01:27.547131
3717	2026-01-26 19:00:00	7	24.44	220	5719.6	t	2026-05-08 00:01:27.547131
3718	2026-01-26 19:30:00	1	20.49	220	4081.9	t	2026-05-08 00:01:27.547131
3719	2026-01-26 19:30:00	4	18.93	220	3985.3	t	2026-05-08 00:01:27.547131
3720	2026-01-26 19:30:00	7	21.04	220	4623.6	t	2026-05-08 00:01:27.547131
3721	2026-01-26 20:00:00	1	2.11	220	535.1	t	2026-05-08 00:01:27.547131
3722	2026-01-26 20:00:00	4	3.49	220	759.7	t	2026-05-08 00:01:27.547131
3723	2026-01-26 20:00:00	7	3.17	220	459	t	2026-05-08 00:01:27.547131
3724	2026-01-26 20:30:00	1	1.27	220	708.8	t	2026-05-08 00:01:27.547131
3725	2026-01-26 20:30:00	4	1.22	220	544.3	t	2026-05-08 00:01:27.547131
3726	2026-01-26 20:30:00	7	2.37	220	605.3	t	2026-05-08 00:01:27.547131
3727	2026-01-26 21:00:00	1	3.08	220	558.3	t	2026-05-08 00:01:27.547131
3728	2026-01-26 21:00:00	4	1.39	220	570.1	t	2026-05-08 00:01:27.547131
3729	2026-01-26 21:00:00	7	1.74	220	547.6	t	2026-05-08 00:01:27.547131
3730	2026-01-26 21:30:00	1	1.55	220	581	t	2026-05-08 00:01:27.547131
3731	2026-01-26 21:30:00	4	2.92	220	566.9	t	2026-05-08 00:01:27.547131
3732	2026-01-26 21:30:00	7	2.03	220	678.1	t	2026-05-08 00:01:27.547131
3733	2026-01-26 22:00:00	1	2.87	220	389.3	t	2026-05-08 00:01:27.547131
3734	2026-01-26 22:00:00	4	1.35	220	612.4	t	2026-05-08 00:01:27.547131
3735	2026-01-26 22:00:00	7	1.62	220	648.9	t	2026-05-08 00:01:27.547131
3736	2026-01-26 22:30:00	1	1.22	220	438.6	t	2026-05-08 00:01:27.547131
3737	2026-01-26 22:30:00	4	1.64	220	551.9	t	2026-05-08 00:01:27.547131
3738	2026-01-26 22:30:00	7	2.34	220	321.8	t	2026-05-08 00:01:27.547131
3739	2026-01-26 23:00:00	1	1.39	220	502.3	t	2026-05-08 00:01:27.547131
3740	2026-01-26 23:00:00	4	2.93	220	602.1	t	2026-05-08 00:01:27.547131
3741	2026-01-26 23:00:00	7	2.02	220	679.2	t	2026-05-08 00:01:27.547131
3742	2026-01-26 23:30:00	1	3.25	220	607.3	t	2026-05-08 00:01:27.547131
3743	2026-01-26 23:30:00	4	1.59	220	711	t	2026-05-08 00:01:27.547131
3744	2026-01-26 23:30:00	7	3.24	220	346.2	t	2026-05-08 00:01:27.547131
3745	2026-01-27 00:00:00	1	2.09	220	310.5	t	2026-05-08 00:01:27.547131
3746	2026-01-27 00:00:00	4	2.06	220	644.7	t	2026-05-08 00:01:27.547131
3747	2026-01-27 00:00:00	7	3.07	220	732.6	t	2026-05-08 00:01:27.547131
3748	2026-01-27 00:30:00	1	1.48	220	758.7	t	2026-05-08 00:01:27.547131
3749	2026-01-27 00:30:00	4	3.1	220	430.3	t	2026-05-08 00:01:27.547131
3750	2026-01-27 00:30:00	7	1.5	220	579.2	t	2026-05-08 00:01:27.547131
3751	2026-01-27 01:00:00	1	2.71	220	634.2	t	2026-05-08 00:01:27.547131
3752	2026-01-27 01:00:00	4	1.48	220	459.1	t	2026-05-08 00:01:27.547131
3753	2026-01-27 01:00:00	7	1.78	220	284.7	t	2026-05-08 00:01:27.547131
3754	2026-01-27 01:30:00	1	3.01	220	469.9	t	2026-05-08 00:01:27.547131
3755	2026-01-27 01:30:00	4	3.34	220	562.1	t	2026-05-08 00:01:27.547131
3756	2026-01-27 01:30:00	7	2.63	220	291.2	t	2026-05-08 00:01:27.547131
3757	2026-01-27 02:00:00	1	2.3	220	609.7	t	2026-05-08 00:01:27.547131
3758	2026-01-27 02:00:00	4	2.94	220	308	t	2026-05-08 00:01:27.547131
3759	2026-01-27 02:00:00	7	2.05	220	283.2	t	2026-05-08 00:01:27.547131
3760	2026-01-27 02:30:00	1	2.27	220	360.2	t	2026-05-08 00:01:27.547131
3761	2026-01-27 02:30:00	4	2.61	220	339.3	t	2026-05-08 00:01:27.547131
3762	2026-01-27 02:30:00	7	3.08	220	557.5	t	2026-05-08 00:01:27.547131
3763	2026-01-27 03:00:00	1	3.06	220	493.1	t	2026-05-08 00:01:27.547131
3764	2026-01-27 03:00:00	4	2.35	220	454.9	t	2026-05-08 00:01:27.547131
3765	2026-01-27 03:00:00	7	3.66	220	481.5	t	2026-05-08 00:01:27.547131
3766	2026-01-27 03:30:00	1	3.63	220	315.4	t	2026-05-08 00:01:27.547131
3767	2026-01-27 03:30:00	4	3.63	220	530.2	t	2026-05-08 00:01:27.547131
3768	2026-01-27 03:30:00	7	1.74	220	283.7	t	2026-05-08 00:01:27.547131
3769	2026-01-27 04:00:00	1	2.14	220	502	t	2026-05-08 00:01:27.547131
3770	2026-01-27 04:00:00	4	3.01	220	466.8	t	2026-05-08 00:01:27.547131
3771	2026-01-27 04:00:00	7	1.28	220	467.4	t	2026-05-08 00:01:27.547131
3772	2026-01-27 04:30:00	1	3.57	220	515.4	t	2026-05-08 00:01:27.547131
3773	2026-01-27 04:30:00	4	2.57	220	571	t	2026-05-08 00:01:27.547131
3774	2026-01-27 04:30:00	7	2.52	220	298	t	2026-05-08 00:01:27.547131
3775	2026-01-27 05:00:00	1	1.72	220	594	t	2026-05-08 00:01:27.547131
3776	2026-01-27 05:00:00	4	2.86	220	601.1	t	2026-05-08 00:01:27.547131
3777	2026-01-27 05:00:00	7	2.64	220	441.7	t	2026-05-08 00:01:27.547131
3778	2026-01-27 05:30:00	1	3.4	220	405.2	t	2026-05-08 00:01:27.547131
3779	2026-01-27 05:30:00	4	3.36	220	456.6	t	2026-05-08 00:01:27.547131
3780	2026-01-27 05:30:00	7	1.21	220	536.6	t	2026-05-08 00:01:27.547131
3781	2026-01-27 06:00:00	1	2.47	220	683	t	2026-05-08 00:01:27.547131
3782	2026-01-27 06:00:00	4	1.58	220	603	t	2026-05-08 00:01:27.547131
3783	2026-01-27 06:00:00	7	2.48	220	466.3	t	2026-05-08 00:01:27.547131
3784	2026-01-27 06:30:00	1	3.63	220	293.4	t	2026-05-08 00:01:27.547131
3785	2026-01-27 06:30:00	4	3.59	220	319.9	t	2026-05-08 00:01:27.547131
3786	2026-01-27 06:30:00	7	2.62	220	401.7	t	2026-05-08 00:01:27.547131
3787	2026-01-27 07:00:00	1	18.46	220	4431.3	t	2026-05-08 00:01:27.547131
3788	2026-01-27 07:00:00	4	18.35	220	5192.6	t	2026-05-08 00:01:27.547131
3789	2026-01-27 07:00:00	7	29.99	220	6623	t	2026-05-08 00:01:27.547131
3790	2026-01-27 07:30:00	1	12.43	220	3712.8	t	2026-05-08 00:01:27.547131
3791	2026-01-27 07:30:00	4	24.19	220	5189.3	t	2026-05-08 00:01:27.547131
3792	2026-01-27 07:30:00	7	30.24	220	4760	t	2026-05-08 00:01:27.547131
3793	2026-01-27 08:00:00	1	14.21	220	3258	t	2026-05-08 00:01:27.547131
3794	2026-01-27 08:00:00	4	25.04	220	5199.6	t	2026-05-08 00:01:27.547131
3795	2026-01-27 08:00:00	7	24.13	220	4862	t	2026-05-08 00:01:27.547131
3796	2026-01-27 08:30:00	1	11.82	220	3707.7	t	2026-05-08 00:01:27.547131
3797	2026-01-27 08:30:00	4	16.42	220	4545.4	t	2026-05-08 00:01:27.547131
3798	2026-01-27 08:30:00	7	27.89	220	5501.5	t	2026-05-08 00:01:27.547131
3799	2026-01-27 09:00:00	1	13.83	220	4186.3	t	2026-05-08 00:01:27.547131
3800	2026-01-27 09:00:00	4	21.64	220	4463.8	t	2026-05-08 00:01:27.547131
3801	2026-01-27 09:00:00	7	28.12	220	5151.9	t	2026-05-08 00:01:27.547131
3802	2026-01-27 09:30:00	1	16.08	220	4227.6	t	2026-05-08 00:01:27.547131
3803	2026-01-27 09:30:00	4	17.12	220	3679	t	2026-05-08 00:01:27.547131
3804	2026-01-27 09:30:00	7	24.68	220	6443.3	t	2026-05-08 00:01:27.547131
3805	2026-01-27 10:00:00	1	19.1	220	4370.5	t	2026-05-08 00:01:27.547131
3806	2026-01-27 10:00:00	4	23.33	220	4697.9	t	2026-05-08 00:01:27.547131
3807	2026-01-27 10:00:00	7	27.38	220	6330.7	t	2026-05-08 00:01:27.547131
3808	2026-01-27 10:30:00	1	14.08	220	3668.2	t	2026-05-08 00:01:27.547131
3809	2026-01-27 10:30:00	4	24.13	220	3809.8	t	2026-05-08 00:01:27.547131
3810	2026-01-27 10:30:00	7	22.21	220	6143.4	t	2026-05-08 00:01:27.547131
3811	2026-01-27 11:00:00	1	20.94	220	3727.2	t	2026-05-08 00:01:27.547131
3812	2026-01-27 11:00:00	4	24.92	220	5611.1	t	2026-05-08 00:01:27.547131
3813	2026-01-27 11:00:00	7	27.34	220	6236.7	t	2026-05-08 00:01:27.547131
3814	2026-01-27 11:30:00	1	17.27	220	4311.2	t	2026-05-08 00:01:27.547131
3815	2026-01-27 11:30:00	4	20.83	220	4787	t	2026-05-08 00:01:27.547131
3816	2026-01-27 11:30:00	7	27.88	220	4528.8	t	2026-05-08 00:01:27.547131
3817	2026-01-27 12:00:00	1	20.51	220	3374.6	t	2026-05-08 00:01:27.547131
3818	2026-01-27 12:00:00	4	17.8	220	5457.3	t	2026-05-08 00:01:27.547131
3819	2026-01-27 12:00:00	7	24.19	220	5614.9	t	2026-05-08 00:01:27.547131
3820	2026-01-27 12:30:00	1	20.9	220	2601.6	t	2026-05-08 00:01:27.547131
3821	2026-01-27 12:30:00	4	18.68	220	4760.1	t	2026-05-08 00:01:27.547131
3822	2026-01-27 12:30:00	7	26.74	220	6575.5	t	2026-05-08 00:01:27.547131
3823	2026-01-27 13:00:00	1	15.77	220	4607.3	t	2026-05-08 00:01:27.547131
3824	2026-01-27 13:00:00	4	16.15	220	5288.3	t	2026-05-08 00:01:27.547131
3825	2026-01-27 13:00:00	7	27.59	220	5161.8	t	2026-05-08 00:01:27.547131
3826	2026-01-27 13:30:00	1	11.94	220	3513.2	t	2026-05-08 00:01:27.547131
3827	2026-01-27 13:30:00	4	22.4	220	4366.7	t	2026-05-08 00:01:27.547131
3828	2026-01-27 13:30:00	7	25.28	220	6276.2	t	2026-05-08 00:01:27.547131
3829	2026-01-27 14:00:00	1	12.96	220	2768	t	2026-05-08 00:01:27.547131
3830	2026-01-27 14:00:00	4	19.75	220	4424.8	t	2026-05-08 00:01:27.547131
3831	2026-01-27 14:00:00	7	25.72	220	5875.2	t	2026-05-08 00:01:27.547131
3832	2026-01-27 14:30:00	1	13.77	220	4635.8	t	2026-05-08 00:01:27.547131
3833	2026-01-27 14:30:00	4	16.92	220	5538.3	t	2026-05-08 00:01:27.547131
3834	2026-01-27 14:30:00	7	22.86	220	6609	t	2026-05-08 00:01:27.547131
3835	2026-01-27 15:00:00	1	18.05	220	3728	t	2026-05-08 00:01:27.547131
3836	2026-01-27 15:00:00	4	19.91	220	5078.9	t	2026-05-08 00:01:27.547131
3837	2026-01-27 15:00:00	7	23.98	220	5725.9	t	2026-05-08 00:01:27.547131
3838	2026-01-27 15:30:00	1	14.15	220	3570.8	t	2026-05-08 00:01:27.547131
3839	2026-01-27 15:30:00	4	23.88	220	5147.3	t	2026-05-08 00:01:27.547131
3840	2026-01-27 15:30:00	7	26.17	220	5016.5	t	2026-05-08 00:01:27.547131
3841	2026-01-27 16:00:00	1	15.12	220	2588.9	t	2026-05-08 00:01:27.547131
3842	2026-01-27 16:00:00	4	22.58	220	4790.1	t	2026-05-08 00:01:27.547131
3843	2026-01-27 16:00:00	7	22.56	220	6493.8	t	2026-05-08 00:01:27.547131
3844	2026-01-27 16:30:00	1	17.64	220	3592.8	t	2026-05-08 00:01:27.547131
3845	2026-01-27 16:30:00	4	22.43	220	4317	t	2026-05-08 00:01:27.547131
3846	2026-01-27 16:30:00	7	28.86	220	5526	t	2026-05-08 00:01:27.547131
3847	2026-01-27 17:00:00	1	19.1	220	4166.9	t	2026-05-08 00:01:27.547131
3848	2026-01-27 17:00:00	4	16.32	220	4524.5	t	2026-05-08 00:01:27.547131
3849	2026-01-27 17:00:00	7	30.09	220	6299.8	t	2026-05-08 00:01:27.547131
3850	2026-01-27 17:30:00	1	13.5	220	3432.6	t	2026-05-08 00:01:27.547131
3851	2026-01-27 17:30:00	4	21.57	220	4391.1	t	2026-05-08 00:01:27.547131
3852	2026-01-27 17:30:00	7	29.98	220	6407	t	2026-05-08 00:01:27.547131
3853	2026-01-27 18:00:00	1	16.63	220	2837.9	t	2026-05-08 00:01:27.547131
3854	2026-01-27 18:00:00	4	23.33	220	4699.4	t	2026-05-08 00:01:27.547131
3855	2026-01-27 18:00:00	7	28.8	220	5351.9	t	2026-05-08 00:01:27.547131
3856	2026-01-27 18:30:00	1	21.31	220	4397.9	t	2026-05-08 00:01:27.547131
3857	2026-01-27 18:30:00	4	24.3	220	4030.7	t	2026-05-08 00:01:27.547131
3858	2026-01-27 18:30:00	7	29.77	220	5031.5	t	2026-05-08 00:01:27.547131
3859	2026-01-27 19:00:00	1	19.07	220	2642.4	t	2026-05-08 00:01:27.547131
3860	2026-01-27 19:00:00	4	24.16	220	3925.8	t	2026-05-08 00:01:27.547131
3861	2026-01-27 19:00:00	7	23.42	220	5628.5	t	2026-05-08 00:01:27.547131
3862	2026-01-27 19:30:00	1	18.44	220	4085.9	t	2026-05-08 00:01:27.547131
3863	2026-01-27 19:30:00	4	24.41	220	3867	t	2026-05-08 00:01:27.547131
3864	2026-01-27 19:30:00	7	30.12	220	6082.7	t	2026-05-08 00:01:27.547131
3865	2026-01-27 20:00:00	1	3.11	220	742.3	t	2026-05-08 00:01:27.547131
3866	2026-01-27 20:00:00	4	2.62	220	432.1	t	2026-05-08 00:01:27.547131
3867	2026-01-27 20:00:00	7	3.48	220	586.7	t	2026-05-08 00:01:27.547131
3868	2026-01-27 20:30:00	1	2.33	220	327.9	t	2026-05-08 00:01:27.547131
3869	2026-01-27 20:30:00	4	2.82	220	309.5	t	2026-05-08 00:01:27.547131
3870	2026-01-27 20:30:00	7	2.13	220	534.5	t	2026-05-08 00:01:27.547131
3871	2026-01-27 21:00:00	1	2.19	220	563.9	t	2026-05-08 00:01:27.547131
3872	2026-01-27 21:00:00	4	2.78	220	688.8	t	2026-05-08 00:01:27.547131
3873	2026-01-27 21:00:00	7	3.25	220	491.7	t	2026-05-08 00:01:27.547131
3874	2026-01-27 21:30:00	1	3.2	220	552.9	t	2026-05-08 00:01:27.547131
3875	2026-01-27 21:30:00	4	1.26	220	531.9	t	2026-05-08 00:01:27.547131
3876	2026-01-27 21:30:00	7	2.39	220	699.3	t	2026-05-08 00:01:27.547131
3877	2026-01-27 22:00:00	1	2.13	220	673.7	t	2026-05-08 00:01:27.547131
3878	2026-01-27 22:00:00	4	2.88	220	308.6	t	2026-05-08 00:01:27.547131
3879	2026-01-27 22:00:00	7	2.37	220	459.9	t	2026-05-08 00:01:27.547131
3880	2026-01-27 22:30:00	1	2.33	220	475.9	t	2026-05-08 00:01:27.547131
3881	2026-01-27 22:30:00	4	2.29	220	272.4	t	2026-05-08 00:01:27.547131
3882	2026-01-27 22:30:00	7	1.64	220	801.1	t	2026-05-08 00:01:27.547131
3883	2026-01-27 23:00:00	1	3.19	220	394.4	t	2026-05-08 00:01:27.547131
3884	2026-01-27 23:00:00	4	1.89	220	373.4	t	2026-05-08 00:01:27.547131
3885	2026-01-27 23:00:00	7	2.04	220	730.6	t	2026-05-08 00:01:27.547131
3886	2026-01-27 23:30:00	1	2.15	220	777	t	2026-05-08 00:01:27.547131
3887	2026-01-27 23:30:00	4	2.85	220	580.4	t	2026-05-08 00:01:27.547131
3888	2026-01-27 23:30:00	7	1.96	220	637.6	t	2026-05-08 00:01:27.547131
3889	2026-01-28 00:00:00	1	2.16	220	808.6	t	2026-05-08 00:01:27.547131
3890	2026-01-28 00:00:00	4	2.89	220	578.6	t	2026-05-08 00:01:27.547131
3891	2026-01-28 00:00:00	7	3.42	220	570	t	2026-05-08 00:01:27.547131
3892	2026-01-28 00:30:00	1	1.26	220	308.2	t	2026-05-08 00:01:27.547131
3893	2026-01-28 00:30:00	4	1.45	220	682.1	t	2026-05-08 00:01:27.547131
3894	2026-01-28 00:30:00	7	2.54	220	778.2	t	2026-05-08 00:01:27.547131
3895	2026-01-28 01:00:00	1	2.01	220	802.6	t	2026-05-08 00:01:27.547131
3896	2026-01-28 01:00:00	4	2.97	220	606.9	t	2026-05-08 00:01:27.547131
3897	2026-01-28 01:00:00	7	2.11	220	731.6	t	2026-05-08 00:01:27.547131
3898	2026-01-28 01:30:00	1	2.92	220	315.7	t	2026-05-08 00:01:27.547131
3899	2026-01-28 01:30:00	4	2.8	220	410.2	t	2026-05-08 00:01:27.547131
3900	2026-01-28 01:30:00	7	2.55	220	331	t	2026-05-08 00:01:27.547131
3901	2026-01-28 02:00:00	1	2.06	220	282.9	t	2026-05-08 00:01:27.547131
3902	2026-01-28 02:00:00	4	2.57	220	669.2	t	2026-05-08 00:01:27.547131
3903	2026-01-28 02:00:00	7	1.73	220	384	t	2026-05-08 00:01:27.547131
3904	2026-01-28 02:30:00	1	2.03	220	346	t	2026-05-08 00:01:27.547131
3905	2026-01-28 02:30:00	4	3	220	775.7	t	2026-05-08 00:01:27.547131
3906	2026-01-28 02:30:00	7	3.25	220	648.6	t	2026-05-08 00:01:27.547131
3907	2026-01-28 03:00:00	1	2.24	220	342.5	t	2026-05-08 00:01:27.547131
3908	2026-01-28 03:00:00	4	3.52	220	735.9	t	2026-05-08 00:01:27.547131
3909	2026-01-28 03:00:00	7	2.45	220	688.8	t	2026-05-08 00:01:27.547131
3910	2026-01-28 03:30:00	1	3.28	220	808.5	t	2026-05-08 00:01:27.547131
3911	2026-01-28 03:30:00	4	2.89	220	699.1	t	2026-05-08 00:01:27.547131
3912	2026-01-28 03:30:00	7	3.33	220	549.6	t	2026-05-08 00:01:27.547131
3913	2026-01-28 04:00:00	1	2.25	220	756.9	t	2026-05-08 00:01:27.547131
3914	2026-01-28 04:00:00	4	2.39	220	565	t	2026-05-08 00:01:27.547131
3915	2026-01-28 04:00:00	7	1.91	220	265.1	t	2026-05-08 00:01:27.547131
3916	2026-01-28 04:30:00	1	2.96	220	365.2	t	2026-05-08 00:01:27.547131
3917	2026-01-28 04:30:00	4	1.37	220	524.8	t	2026-05-08 00:01:27.547131
3918	2026-01-28 04:30:00	7	2.47	220	445.8	t	2026-05-08 00:01:27.547131
3919	2026-01-28 05:00:00	1	1.76	220	792.2	t	2026-05-08 00:01:27.547131
3920	2026-01-28 05:00:00	4	3.25	220	537.3	t	2026-05-08 00:01:27.547131
3921	2026-01-28 05:00:00	7	2	220	573.9	t	2026-05-08 00:01:27.547131
3922	2026-01-28 05:30:00	1	1.28	220	342.9	t	2026-05-08 00:01:27.547131
3923	2026-01-28 05:30:00	4	2.82	220	507.2	t	2026-05-08 00:01:27.547131
3924	2026-01-28 05:30:00	7	1.71	220	665.2	t	2026-05-08 00:01:27.547131
3925	2026-01-28 06:00:00	1	1.39	220	425.9	t	2026-05-08 00:01:27.547131
3926	2026-01-28 06:00:00	4	2.82	220	770.1	t	2026-05-08 00:01:27.547131
3927	2026-01-28 06:00:00	7	1.69	220	432.7	t	2026-05-08 00:01:27.547131
3928	2026-01-28 06:30:00	1	2.49	220	565.5	t	2026-05-08 00:01:27.547131
3929	2026-01-28 06:30:00	4	2.47	220	684.6	t	2026-05-08 00:01:27.547131
3930	2026-01-28 06:30:00	7	1.27	220	737.3	t	2026-05-08 00:01:27.547131
3931	2026-01-28 07:00:00	1	20.52	220	4065.2	t	2026-05-08 00:01:27.547131
3932	2026-01-28 07:00:00	4	23.37	220	4631.4	t	2026-05-08 00:01:27.547131
3933	2026-01-28 07:00:00	7	25.15	220	5240.2	t	2026-05-08 00:01:27.547131
3934	2026-01-28 07:30:00	1	12.87	220	3863.3	t	2026-05-08 00:01:27.547131
3935	2026-01-28 07:30:00	4	19.99	220	3568.5	t	2026-05-08 00:01:27.547131
3936	2026-01-28 07:30:00	7	28.14	220	6126.1	t	2026-05-08 00:01:27.547131
3937	2026-01-28 08:00:00	1	14.91	220	2659.4	t	2026-05-08 00:01:27.547131
3938	2026-01-28 08:00:00	4	18.13	220	4143.9	t	2026-05-08 00:01:27.547131
3939	2026-01-28 08:00:00	7	30.23	220	5110.7	t	2026-05-08 00:01:27.547131
3940	2026-01-28 08:30:00	1	16.96	220	2892.6	t	2026-05-08 00:01:27.547131
3941	2026-01-28 08:30:00	4	20.14	220	5375.8	t	2026-05-08 00:01:27.547131
3942	2026-01-28 08:30:00	7	25.57	220	5755.1	t	2026-05-08 00:01:27.547131
3943	2026-01-28 09:00:00	1	17.58	220	3947.8	t	2026-05-08 00:01:27.547131
3944	2026-01-28 09:00:00	4	16.39	220	5118.9	t	2026-05-08 00:01:27.547131
3945	2026-01-28 09:00:00	7	29.03	220	5871.8	t	2026-05-08 00:01:27.547131
3946	2026-01-28 09:30:00	1	13.48	220	4001.1	t	2026-05-08 00:01:27.547131
3947	2026-01-28 09:30:00	4	20.19	220	4574.5	t	2026-05-08 00:01:27.547131
3948	2026-01-28 09:30:00	7	24.92	220	6230.1	t	2026-05-08 00:01:27.547131
3949	2026-01-28 10:00:00	1	20.66	220	3178	t	2026-05-08 00:01:27.547131
3950	2026-01-28 10:00:00	4	23.55	220	3948.4	t	2026-05-08 00:01:27.547131
3951	2026-01-28 10:00:00	7	27.66	220	6328.2	t	2026-05-08 00:01:27.547131
3952	2026-01-28 10:30:00	1	19.39	220	3255.8	t	2026-05-08 00:01:27.547131
3953	2026-01-28 10:30:00	4	17.43	220	5454.3	t	2026-05-08 00:01:27.547131
3954	2026-01-28 10:30:00	7	24.2	220	6334.4	t	2026-05-08 00:01:27.547131
3955	2026-01-28 11:00:00	1	16.49	220	3151.1	t	2026-05-08 00:01:27.547131
3956	2026-01-28 11:00:00	4	17.46	220	5416	t	2026-05-08 00:01:27.547131
3957	2026-01-28 11:00:00	7	29.09	220	5857.5	t	2026-05-08 00:01:27.547131
3958	2026-01-28 11:30:00	1	12.91	220	4549.7	t	2026-05-08 00:01:27.547131
3959	2026-01-28 11:30:00	4	24.78	220	4675.3	t	2026-05-08 00:01:27.547131
3960	2026-01-28 11:30:00	7	21.78	220	5984.6	t	2026-05-08 00:01:27.547131
3961	2026-01-28 12:00:00	1	13.18	220	3268.2	t	2026-05-08 00:01:27.547131
3962	2026-01-28 12:00:00	4	21.79	220	5594.2	t	2026-05-08 00:01:27.547131
3963	2026-01-28 12:00:00	7	22.56	220	6102.6	t	2026-05-08 00:01:27.547131
3964	2026-01-28 12:30:00	1	17.29	220	4588.1	t	2026-05-08 00:01:27.547131
3965	2026-01-28 12:30:00	4	21.51	220	4125.9	t	2026-05-08 00:01:27.547131
3966	2026-01-28 12:30:00	7	23.23	220	5294.3	t	2026-05-08 00:01:27.547131
3967	2026-01-28 13:00:00	1	12.09	220	3481.3	t	2026-05-08 00:01:27.547131
3968	2026-01-28 13:00:00	4	23.95	220	4453.1	t	2026-05-08 00:01:27.547131
3969	2026-01-28 13:00:00	7	21.19	220	6482.3	t	2026-05-08 00:01:27.547131
3970	2026-01-28 13:30:00	1	16.1	220	3208.3	t	2026-05-08 00:01:27.547131
3971	2026-01-28 13:30:00	4	18.56	220	5419.9	t	2026-05-08 00:01:27.547131
3972	2026-01-28 13:30:00	7	25.05	220	4696.8	t	2026-05-08 00:01:27.547131
3973	2026-01-28 14:00:00	1	15.62	220	4479.7	t	2026-05-08 00:01:27.547131
3974	2026-01-28 14:00:00	4	20.91	220	4999.6	t	2026-05-08 00:01:27.547131
3975	2026-01-28 14:00:00	7	28.03	220	5391.9	t	2026-05-08 00:01:27.547131
3976	2026-01-28 14:30:00	1	19.07	220	2712.2	t	2026-05-08 00:01:27.547131
3977	2026-01-28 14:30:00	4	22.18	220	3758.5	t	2026-05-08 00:01:27.547131
3978	2026-01-28 14:30:00	7	22.47	220	6182.8	t	2026-05-08 00:01:27.547131
3979	2026-01-28 15:00:00	1	16.33	220	4083.1	t	2026-05-08 00:01:27.547131
3980	2026-01-28 15:00:00	4	22.26	220	4463	t	2026-05-08 00:01:27.547131
3981	2026-01-28 15:00:00	7	30.22	220	5278.9	t	2026-05-08 00:01:27.547131
3982	2026-01-28 15:30:00	1	17.01	220	2807.5	t	2026-05-08 00:01:27.547131
3983	2026-01-28 15:30:00	4	20.09	220	5232.6	t	2026-05-08 00:01:27.547131
3984	2026-01-28 15:30:00	7	24.84	220	5602.7	t	2026-05-08 00:01:27.547131
3985	2026-01-28 16:00:00	1	18.04	220	3964.2	t	2026-05-08 00:01:27.547131
3986	2026-01-28 16:00:00	4	22.49	220	3758.6	t	2026-05-08 00:01:27.547131
3987	2026-01-28 16:00:00	7	26.29	220	4775.2	t	2026-05-08 00:01:27.547131
3988	2026-01-28 16:30:00	1	16.46	220	4197.5	t	2026-05-08 00:01:27.547131
3989	2026-01-28 16:30:00	4	20.27	220	5372.3	t	2026-05-08 00:01:27.547131
3990	2026-01-28 16:30:00	7	26.48	220	5440.8	t	2026-05-08 00:01:27.547131
3991	2026-01-28 17:00:00	1	14.53	220	3083.4	t	2026-05-08 00:01:27.547131
3992	2026-01-28 17:00:00	4	19.39	220	4976.2	t	2026-05-08 00:01:27.547131
3993	2026-01-28 17:00:00	7	23.52	220	6512.5	t	2026-05-08 00:01:27.547131
3994	2026-01-28 17:30:00	1	18.49	220	4116.3	t	2026-05-08 00:01:27.547131
3995	2026-01-28 17:30:00	4	17.2	220	5503.7	t	2026-05-08 00:01:27.547131
3996	2026-01-28 17:30:00	7	20.94	220	5748.3	t	2026-05-08 00:01:27.547131
3997	2026-01-28 18:00:00	1	19.64	220	4535.9	t	2026-05-08 00:01:27.547131
3998	2026-01-28 18:00:00	4	19.86	220	4301	t	2026-05-08 00:01:27.547131
3999	2026-01-28 18:00:00	7	20.81	220	6378.8	t	2026-05-08 00:01:27.547131
4000	2026-01-28 18:30:00	1	20.53	220	4173.8	t	2026-05-08 00:01:27.547131
4001	2026-01-28 18:30:00	4	19.33	220	4534.9	t	2026-05-08 00:01:27.547131
4002	2026-01-28 18:30:00	7	28.21	220	6257.6	t	2026-05-08 00:01:27.547131
4003	2026-01-28 19:00:00	1	17.14	220	3212.5	t	2026-05-08 00:01:27.547131
4004	2026-01-28 19:00:00	4	20.59	220	4764.1	t	2026-05-08 00:01:27.547131
4005	2026-01-28 19:00:00	7	21.18	220	5444.6	t	2026-05-08 00:01:27.547131
4006	2026-01-28 19:30:00	1	13.11	220	3344.4	t	2026-05-08 00:01:27.547131
4007	2026-01-28 19:30:00	4	17.17	220	3841.8	t	2026-05-08 00:01:27.547131
4008	2026-01-28 19:30:00	7	20.87	220	6639.3	t	2026-05-08 00:01:27.547131
4009	2026-01-28 20:00:00	1	3.4	220	335.6	t	2026-05-08 00:01:27.547131
4010	2026-01-28 20:00:00	4	2.64	220	732.4	t	2026-05-08 00:01:27.547131
4011	2026-01-28 20:00:00	7	1.62	220	683.4	t	2026-05-08 00:01:27.547131
4012	2026-01-28 20:30:00	1	1.28	220	373.6	t	2026-05-08 00:01:27.547131
4013	2026-01-28 20:30:00	4	2.85	220	602.2	t	2026-05-08 00:01:27.547131
4014	2026-01-28 20:30:00	7	3.33	220	523.5	t	2026-05-08 00:01:27.547131
4015	2026-01-28 21:00:00	1	3.16	220	393.1	t	2026-05-08 00:01:27.547131
4016	2026-01-28 21:00:00	4	1.54	220	616.1	t	2026-05-08 00:01:27.547131
4017	2026-01-28 21:00:00	7	2.13	220	451.5	t	2026-05-08 00:01:27.547131
4018	2026-01-28 21:30:00	1	3.17	220	775.4	t	2026-05-08 00:01:27.547131
4019	2026-01-28 21:30:00	4	2.95	220	790.2	t	2026-05-08 00:01:27.547131
4020	2026-01-28 21:30:00	7	1.49	220	355.8	t	2026-05-08 00:01:27.547131
4021	2026-01-28 22:00:00	1	3.23	220	347.2	t	2026-05-08 00:01:27.547131
4022	2026-01-28 22:00:00	4	1.31	220	366.5	t	2026-05-08 00:01:27.547131
4023	2026-01-28 22:00:00	7	3.53	220	484.6	t	2026-05-08 00:01:27.547131
4024	2026-01-28 22:30:00	1	1.37	220	685.9	t	2026-05-08 00:01:27.547131
4025	2026-01-28 22:30:00	4	2.39	220	806.4	t	2026-05-08 00:01:27.547131
4026	2026-01-28 22:30:00	7	3.39	220	492.8	t	2026-05-08 00:01:27.547131
4027	2026-01-28 23:00:00	1	1.36	220	385.1	t	2026-05-08 00:01:27.547131
4028	2026-01-28 23:00:00	4	2.08	220	633.6	t	2026-05-08 00:01:27.547131
4029	2026-01-28 23:00:00	7	3.64	220	280.8	t	2026-05-08 00:01:27.547131
4030	2026-01-28 23:30:00	1	3.05	220	419.7	t	2026-05-08 00:01:27.547131
4031	2026-01-28 23:30:00	4	2.82	220	273.9	t	2026-05-08 00:01:27.547131
4032	2026-01-28 23:30:00	7	1.94	220	593.3	t	2026-05-08 00:01:27.547131
4033	2026-01-29 00:00:00	1	2.36	220	450.8	t	2026-05-08 00:01:27.547131
4034	2026-01-29 00:00:00	4	1.24	220	375.1	t	2026-05-08 00:01:27.547131
4035	2026-01-29 00:00:00	7	3.66	220	508.9	t	2026-05-08 00:01:27.547131
4036	2026-01-29 00:30:00	1	2.67	220	328.7	t	2026-05-08 00:01:27.547131
4037	2026-01-29 00:30:00	4	1.78	220	611	t	2026-05-08 00:01:27.547131
4038	2026-01-29 00:30:00	7	1.3	220	550.2	t	2026-05-08 00:01:27.547131
4039	2026-01-29 01:00:00	1	2.95	220	708.5	t	2026-05-08 00:01:27.547131
4040	2026-01-29 01:00:00	4	2.5	220	544.7	t	2026-05-08 00:01:27.547131
4041	2026-01-29 01:00:00	7	2.4	220	751.3	t	2026-05-08 00:01:27.547131
4042	2026-01-29 01:30:00	1	2.79	220	699.3	t	2026-05-08 00:01:27.547131
4043	2026-01-29 01:30:00	4	1.48	220	546.8	t	2026-05-08 00:01:27.547131
4044	2026-01-29 01:30:00	7	2.87	220	405.4	t	2026-05-08 00:01:27.547131
4045	2026-01-29 02:00:00	1	1.76	220	471.9	t	2026-05-08 00:01:27.547131
4046	2026-01-29 02:00:00	4	3.66	220	357.7	t	2026-05-08 00:01:27.547131
4047	2026-01-29 02:00:00	7	3.15	220	618.3	t	2026-05-08 00:01:27.547131
4048	2026-01-29 02:30:00	1	2.32	220	484	t	2026-05-08 00:01:27.547131
4049	2026-01-29 02:30:00	4	2.91	220	373.2	t	2026-05-08 00:01:27.547131
4050	2026-01-29 02:30:00	7	1.5	220	358.2	t	2026-05-08 00:01:27.547131
4051	2026-01-29 03:00:00	1	1.54	220	711.5	t	2026-05-08 00:01:27.547131
4052	2026-01-29 03:00:00	4	3.44	220	337.2	t	2026-05-08 00:01:27.547131
4053	2026-01-29 03:00:00	7	1.53	220	549.8	t	2026-05-08 00:01:27.547131
4054	2026-01-29 03:30:00	1	2.34	220	655.4	t	2026-05-08 00:01:27.547131
4055	2026-01-29 03:30:00	4	2.31	220	725.9	t	2026-05-08 00:01:27.547131
4056	2026-01-29 03:30:00	7	2.27	220	547.5	t	2026-05-08 00:01:27.547131
4057	2026-01-29 04:00:00	1	1.64	220	322.5	t	2026-05-08 00:01:27.547131
4058	2026-01-29 04:00:00	4	3.31	220	787.4	t	2026-05-08 00:01:27.547131
4059	2026-01-29 04:00:00	7	2.01	220	468.6	t	2026-05-08 00:01:27.547131
4060	2026-01-29 04:30:00	1	3.21	220	718.8	t	2026-05-08 00:01:27.547131
4061	2026-01-29 04:30:00	4	2.98	220	405	t	2026-05-08 00:01:27.547131
4062	2026-01-29 04:30:00	7	3.41	220	492.7	t	2026-05-08 00:01:27.547131
4063	2026-01-29 05:00:00	1	2.03	220	583.2	t	2026-05-08 00:01:27.547131
4064	2026-01-29 05:00:00	4	3.04	220	386	t	2026-05-08 00:01:27.547131
4065	2026-01-29 05:00:00	7	2.83	220	274.5	t	2026-05-08 00:01:27.547131
4066	2026-01-29 05:30:00	1	3.43	220	759	t	2026-05-08 00:01:27.547131
4067	2026-01-29 05:30:00	4	1.92	220	486.2	t	2026-05-08 00:01:27.547131
4068	2026-01-29 05:30:00	7	3.51	220	447.2	t	2026-05-08 00:01:27.547131
4069	2026-01-29 06:00:00	1	1.22	220	697.3	t	2026-05-08 00:01:27.547131
4070	2026-01-29 06:00:00	4	2.16	220	482.5	t	2026-05-08 00:01:27.547131
4071	2026-01-29 06:00:00	7	1.61	220	412.5	t	2026-05-08 00:01:27.547131
4072	2026-01-29 06:30:00	1	3.48	220	610.1	t	2026-05-08 00:01:27.547131
4073	2026-01-29 06:30:00	4	1.39	220	789	t	2026-05-08 00:01:27.547131
4074	2026-01-29 06:30:00	7	1.37	220	709.8	t	2026-05-08 00:01:27.547131
4075	2026-01-29 07:00:00	1	19.35	220	3766.4	t	2026-05-08 00:01:27.547131
4076	2026-01-29 07:00:00	4	17.29	220	3752.8	t	2026-05-08 00:01:27.547131
4077	2026-01-29 07:00:00	7	27.94	220	5459.5	t	2026-05-08 00:01:27.547131
4078	2026-01-29 07:30:00	1	18.13	220	4484.4	t	2026-05-08 00:01:27.547131
4079	2026-01-29 07:30:00	4	22.4	220	5682.1	t	2026-05-08 00:01:27.547131
4080	2026-01-29 07:30:00	7	25.7	220	5091.9	t	2026-05-08 00:01:27.547131
4081	2026-01-29 08:00:00	1	15.88	220	3614.6	t	2026-05-08 00:01:27.547131
4082	2026-01-29 08:00:00	4	19.25	220	5469	t	2026-05-08 00:01:27.547131
4083	2026-01-29 08:00:00	7	25.5	220	4989.2	t	2026-05-08 00:01:27.547131
4084	2026-01-29 08:30:00	1	13.25	220	3947	t	2026-05-08 00:01:27.547131
4085	2026-01-29 08:30:00	4	24.08	220	4295.8	t	2026-05-08 00:01:27.547131
4086	2026-01-29 08:30:00	7	25.58	220	6209.7	t	2026-05-08 00:01:27.547131
4087	2026-01-29 09:00:00	1	15.69	220	3611.7	t	2026-05-08 00:01:27.547131
4088	2026-01-29 09:00:00	4	18.47	220	5557.3	t	2026-05-08 00:01:27.547131
4089	2026-01-29 09:00:00	7	23.73	220	6120.2	t	2026-05-08 00:01:27.547131
4090	2026-01-29 09:30:00	1	14.51	220	4000.6	t	2026-05-08 00:01:27.547131
4091	2026-01-29 09:30:00	4	24.27	220	4382.1	t	2026-05-08 00:01:27.547131
4092	2026-01-29 09:30:00	7	22.95	220	6499.6	t	2026-05-08 00:01:27.547131
4093	2026-01-29 10:00:00	1	13.74	220	2686.4	t	2026-05-08 00:01:27.547131
4094	2026-01-29 10:00:00	4	23.87	220	4768.5	t	2026-05-08 00:01:27.547131
4095	2026-01-29 10:00:00	7	25.22	220	6050.3	t	2026-05-08 00:01:27.547131
4096	2026-01-29 10:30:00	1	20.95	220	3603	t	2026-05-08 00:01:27.547131
4097	2026-01-29 10:30:00	4	24.03	220	5372.3	t	2026-05-08 00:01:27.547131
4098	2026-01-29 10:30:00	7	24.22	220	4689.8	t	2026-05-08 00:01:27.547131
4099	2026-01-29 11:00:00	1	17	220	4502.6	t	2026-05-08 00:01:27.547131
4100	2026-01-29 11:00:00	4	19.86	220	4371.8	t	2026-05-08 00:01:27.547131
4101	2026-01-29 11:00:00	7	29.61	220	5956	t	2026-05-08 00:01:27.547131
4102	2026-01-29 11:30:00	1	11.93	220	3466.6	t	2026-05-08 00:01:27.547131
4103	2026-01-29 11:30:00	4	17.58	220	5617.4	t	2026-05-08 00:01:27.547131
4104	2026-01-29 11:30:00	7	24.04	220	5799	t	2026-05-08 00:01:27.547131
4105	2026-01-29 12:00:00	1	13.42	220	3244.6	t	2026-05-08 00:01:27.547131
4106	2026-01-29 12:00:00	4	21.6	220	4413.8	t	2026-05-08 00:01:27.547131
4107	2026-01-29 12:00:00	7	26.91	220	5605.4	t	2026-05-08 00:01:27.547131
4108	2026-01-29 12:30:00	1	17.31	220	2910.5	t	2026-05-08 00:01:27.547131
4109	2026-01-29 12:30:00	4	23.72	220	3676.8	t	2026-05-08 00:01:27.547131
4110	2026-01-29 12:30:00	7	29.07	220	5322.7	t	2026-05-08 00:01:27.547131
4111	2026-01-29 13:00:00	1	17.57	220	3749.4	t	2026-05-08 00:01:27.547131
4112	2026-01-29 13:00:00	4	16.47	220	5200.9	t	2026-05-08 00:01:27.547131
4113	2026-01-29 13:00:00	7	29.23	220	6666.5	t	2026-05-08 00:01:27.547131
4114	2026-01-29 13:30:00	1	16.75	220	4665.4	t	2026-05-08 00:01:27.547131
4115	2026-01-29 13:30:00	4	21.69	220	3792.9	t	2026-05-08 00:01:27.547131
4116	2026-01-29 13:30:00	7	25.81	220	4585.2	t	2026-05-08 00:01:27.547131
4117	2026-01-29 14:00:00	1	12.62	220	4155.4	t	2026-05-08 00:01:27.547131
4118	2026-01-29 14:00:00	4	16.39	220	4660.2	t	2026-05-08 00:01:27.547131
4119	2026-01-29 14:00:00	7	24.84	220	5772	t	2026-05-08 00:01:27.547131
4120	2026-01-29 14:30:00	1	13.05	220	2947.4	t	2026-05-08 00:01:27.547131
4121	2026-01-29 14:30:00	4	22.51	220	3594.5	t	2026-05-08 00:01:27.547131
4122	2026-01-29 14:30:00	7	20.62	220	4568.4	t	2026-05-08 00:01:27.547131
4123	2026-01-29 15:00:00	1	20.5	220	2542.2	t	2026-05-08 00:01:27.547131
4124	2026-01-29 15:00:00	4	19.63	220	5144.5	t	2026-05-08 00:01:27.547131
4125	2026-01-29 15:00:00	7	22.48	220	4682.7	t	2026-05-08 00:01:27.547131
4126	2026-01-29 15:30:00	1	18.66	220	4225.2	t	2026-05-08 00:01:27.547131
4127	2026-01-29 15:30:00	4	22.67	220	4161	t	2026-05-08 00:01:27.547131
4128	2026-01-29 15:30:00	7	29.46	220	6584.5	t	2026-05-08 00:01:27.547131
4129	2026-01-29 16:00:00	1	20.12	220	4267	t	2026-05-08 00:01:27.547131
4130	2026-01-29 16:00:00	4	21.19	220	4537.9	t	2026-05-08 00:01:27.547131
4131	2026-01-29 16:00:00	7	28.6	220	5097.9	t	2026-05-08 00:01:27.547131
4132	2026-01-29 16:30:00	1	16.67	220	4570.6	t	2026-05-08 00:01:27.547131
4133	2026-01-29 16:30:00	4	21.05	220	3803.7	t	2026-05-08 00:01:27.547131
4134	2026-01-29 16:30:00	7	27.77	220	6193.5	t	2026-05-08 00:01:27.547131
4135	2026-01-29 17:00:00	1	19.43	220	3064.6	t	2026-05-08 00:01:27.547131
4136	2026-01-29 17:00:00	4	23.56	220	4460.8	t	2026-05-08 00:01:27.547131
4137	2026-01-29 17:00:00	7	22.86	220	5697.4	t	2026-05-08 00:01:27.547131
4138	2026-01-29 17:30:00	1	12.09	220	4191.4	t	2026-05-08 00:01:27.547131
4139	2026-01-29 17:30:00	4	25.5	220	4801.4	t	2026-05-08 00:01:27.547131
4140	2026-01-29 17:30:00	7	22.32	220	4936.6	t	2026-05-08 00:01:27.547131
4141	2026-01-29 18:00:00	1	12.79	220	3143.5	t	2026-05-08 00:01:27.547131
4142	2026-01-29 18:00:00	4	18.92	220	4107.2	t	2026-05-08 00:01:27.547131
4143	2026-01-29 18:00:00	7	30.01	220	4786.7	t	2026-05-08 00:01:27.547131
4144	2026-01-29 18:30:00	1	16.39	220	4338.6	t	2026-05-08 00:01:27.547131
4145	2026-01-29 18:30:00	4	23.12	220	5274	t	2026-05-08 00:01:27.547131
4146	2026-01-29 18:30:00	7	24.93	220	6630.1	t	2026-05-08 00:01:27.547131
4147	2026-01-29 19:00:00	1	14.5	220	3728.2	t	2026-05-08 00:01:27.547131
4148	2026-01-29 19:00:00	4	20.81	220	4947.1	t	2026-05-08 00:01:27.547131
4149	2026-01-29 19:00:00	7	27.93	220	6291	t	2026-05-08 00:01:27.547131
4150	2026-01-29 19:30:00	1	18.72	220	4529.9	t	2026-05-08 00:01:27.547131
4151	2026-01-29 19:30:00	4	24.36	220	5555.8	t	2026-05-08 00:01:27.547131
4152	2026-01-29 19:30:00	7	26.27	220	5417.2	t	2026-05-08 00:01:27.547131
4153	2026-01-29 20:00:00	1	2.21	220	771.3	t	2026-05-08 00:01:27.547131
4154	2026-01-29 20:00:00	4	3.42	220	737.6	t	2026-05-08 00:01:27.547131
4155	2026-01-29 20:00:00	7	1.49	220	401.9	t	2026-05-08 00:01:27.547131
4156	2026-01-29 20:30:00	1	2.01	220	407.8	t	2026-05-08 00:01:27.547131
4157	2026-01-29 20:30:00	4	1.7	220	613	t	2026-05-08 00:01:27.547131
4158	2026-01-29 20:30:00	7	1.76	220	656.6	t	2026-05-08 00:01:27.547131
4159	2026-01-29 21:00:00	1	1.24	220	715	t	2026-05-08 00:01:27.547131
4160	2026-01-29 21:00:00	4	2.62	220	313.3	t	2026-05-08 00:01:27.547131
4161	2026-01-29 21:00:00	7	2.46	220	494.7	t	2026-05-08 00:01:27.547131
4162	2026-01-29 21:30:00	1	2.37	220	346.3	t	2026-05-08 00:01:27.547131
4163	2026-01-29 21:30:00	4	3.17	220	304.3	t	2026-05-08 00:01:27.547131
4164	2026-01-29 21:30:00	7	1.29	220	351.6	t	2026-05-08 00:01:27.547131
4165	2026-01-29 22:00:00	1	2.23	220	434.8	t	2026-05-08 00:01:27.547131
4166	2026-01-29 22:00:00	4	2.54	220	436.4	t	2026-05-08 00:01:27.547131
4167	2026-01-29 22:00:00	7	1.36	220	321.1	t	2026-05-08 00:01:27.547131
4168	2026-01-29 22:30:00	1	2.06	220	736.1	t	2026-05-08 00:01:27.547131
4169	2026-01-29 22:30:00	4	3.22	220	574.4	t	2026-05-08 00:01:27.547131
4170	2026-01-29 22:30:00	7	1.3	220	342.1	t	2026-05-08 00:01:27.547131
4171	2026-01-29 23:00:00	1	1.33	220	441.4	t	2026-05-08 00:01:27.547131
4172	2026-01-29 23:00:00	4	1.65	220	566.9	t	2026-05-08 00:01:27.547131
4173	2026-01-29 23:00:00	7	2.02	220	631.4	t	2026-05-08 00:01:27.547131
4174	2026-01-29 23:30:00	1	2.91	220	442.2	t	2026-05-08 00:01:27.547131
4175	2026-01-29 23:30:00	4	3.04	220	535.2	t	2026-05-08 00:01:27.547131
4176	2026-01-29 23:30:00	7	3.66	220	336.8	t	2026-05-08 00:01:27.547131
4177	2026-01-30 00:00:00	1	1.57	220	279.3	t	2026-05-08 00:01:27.547131
4178	2026-01-30 00:00:00	4	2.43	220	497.1	t	2026-05-08 00:01:27.547131
4179	2026-01-30 00:00:00	7	1.6	220	371.6	t	2026-05-08 00:01:27.547131
4180	2026-01-30 00:30:00	1	2.33	220	490.6	t	2026-05-08 00:01:27.547131
4181	2026-01-30 00:30:00	4	1.31	220	415.7	t	2026-05-08 00:01:27.547131
4182	2026-01-30 00:30:00	7	2.18	220	670.2	t	2026-05-08 00:01:27.547131
4183	2026-01-30 01:00:00	1	1.56	220	622.5	t	2026-05-08 00:01:27.547131
4184	2026-01-30 01:00:00	4	1.95	220	537.8	t	2026-05-08 00:01:27.547131
4185	2026-01-30 01:00:00	7	1.9	220	446	t	2026-05-08 00:01:27.547131
4186	2026-01-30 01:30:00	1	2.74	220	741.9	t	2026-05-08 00:01:27.547131
4187	2026-01-30 01:30:00	4	3.17	220	293.8	t	2026-05-08 00:01:27.547131
4188	2026-01-30 01:30:00	7	2.65	220	775.8	t	2026-05-08 00:01:27.547131
4189	2026-01-30 02:00:00	1	1.29	220	742.4	t	2026-05-08 00:01:27.547131
4190	2026-01-30 02:00:00	4	2.13	220	664.7	t	2026-05-08 00:01:27.547131
4191	2026-01-30 02:00:00	7	2.46	220	585	t	2026-05-08 00:01:27.547131
4192	2026-01-30 02:30:00	1	1.69	220	411.7	t	2026-05-08 00:01:27.547131
4193	2026-01-30 02:30:00	4	2.64	220	713.1	t	2026-05-08 00:01:27.547131
4194	2026-01-30 02:30:00	7	1.69	220	396.4	t	2026-05-08 00:01:27.547131
4195	2026-01-30 03:00:00	1	1.22	220	599.2	t	2026-05-08 00:01:27.547131
4196	2026-01-30 03:00:00	4	3.42	220	375.6	t	2026-05-08 00:01:27.547131
4197	2026-01-30 03:00:00	7	3.05	220	656.6	t	2026-05-08 00:01:27.547131
4198	2026-01-30 03:30:00	1	1.85	220	334.4	t	2026-05-08 00:01:27.547131
4199	2026-01-30 03:30:00	4	2.88	220	503	t	2026-05-08 00:01:27.547131
4200	2026-01-30 03:30:00	7	1.3	220	708	t	2026-05-08 00:01:27.547131
4201	2026-01-30 04:00:00	1	2.01	220	416.6	t	2026-05-08 00:01:27.547131
4202	2026-01-30 04:00:00	4	3.08	220	498.8	t	2026-05-08 00:01:27.547131
4203	2026-01-30 04:00:00	7	2.31	220	265.6	t	2026-05-08 00:01:27.547131
4204	2026-01-30 04:30:00	1	1.94	220	453.2	t	2026-05-08 00:01:27.547131
4205	2026-01-30 04:30:00	4	2.1	220	649.1	t	2026-05-08 00:01:27.547131
4206	2026-01-30 04:30:00	7	2.45	220	337.5	t	2026-05-08 00:01:27.547131
4207	2026-01-30 05:00:00	1	3.02	220	279.5	t	2026-05-08 00:01:27.547131
4208	2026-01-30 05:00:00	4	1.8	220	449.7	t	2026-05-08 00:01:27.547131
4209	2026-01-30 05:00:00	7	2.74	220	779.9	t	2026-05-08 00:01:27.547131
4210	2026-01-30 05:30:00	1	3.5	220	527.9	t	2026-05-08 00:01:27.547131
4211	2026-01-30 05:30:00	4	1.48	220	342.9	t	2026-05-08 00:01:27.547131
4212	2026-01-30 05:30:00	7	2.53	220	313.6	t	2026-05-08 00:01:27.547131
4213	2026-01-30 06:00:00	1	1.74	220	808.9	t	2026-05-08 00:01:27.547131
4214	2026-01-30 06:00:00	4	3.16	220	390.8	t	2026-05-08 00:01:27.547131
4215	2026-01-30 06:00:00	7	1.63	220	312	t	2026-05-08 00:01:27.547131
4216	2026-01-30 06:30:00	1	2.9	220	605	t	2026-05-08 00:01:27.547131
4217	2026-01-30 06:30:00	4	2.26	220	696.3	t	2026-05-08 00:01:27.547131
4218	2026-01-30 06:30:00	7	2.35	220	471	t	2026-05-08 00:01:27.547131
4219	2026-01-30 07:00:00	1	13.24	220	3558.4	t	2026-05-08 00:01:27.547131
4220	2026-01-30 07:00:00	4	21.08	220	4227	t	2026-05-08 00:01:27.547131
4221	2026-01-30 07:00:00	7	26.03	220	5251.6	t	2026-05-08 00:01:27.547131
4222	2026-01-30 07:30:00	1	14.63	220	3857.4	t	2026-05-08 00:01:27.547131
4223	2026-01-30 07:30:00	4	24.69	220	5574.3	t	2026-05-08 00:01:27.547131
4224	2026-01-30 07:30:00	7	29.66	220	6093	t	2026-05-08 00:01:27.547131
4225	2026-01-30 08:00:00	1	16.36	220	4390.8	t	2026-05-08 00:01:27.547131
4226	2026-01-30 08:00:00	4	25.66	220	3969.9	t	2026-05-08 00:01:27.547131
4227	2026-01-30 08:00:00	7	29.27	220	5174.7	t	2026-05-08 00:01:27.547131
4228	2026-01-30 08:30:00	1	13.38	220	4257.7	t	2026-05-08 00:01:27.547131
4229	2026-01-30 08:30:00	4	19.48	220	4349.5	t	2026-05-08 00:01:27.547131
4230	2026-01-30 08:30:00	7	23.65	220	6596.2	t	2026-05-08 00:01:27.547131
4231	2026-01-30 09:00:00	1	20.91	220	4025.2	t	2026-05-08 00:01:27.547131
4232	2026-01-30 09:00:00	4	18.53	220	4614.1	t	2026-05-08 00:01:27.547131
4233	2026-01-30 09:00:00	7	28.64	220	4552.1	t	2026-05-08 00:01:27.547131
4234	2026-01-30 09:30:00	1	12.99	220	3608.7	t	2026-05-08 00:01:27.547131
4235	2026-01-30 09:30:00	4	23.78	220	3590.4	t	2026-05-08 00:01:27.547131
4236	2026-01-30 09:30:00	7	21.02	220	5271.8	t	2026-05-08 00:01:27.547131
4237	2026-01-30 10:00:00	1	15.92	220	2865.1	t	2026-05-08 00:01:27.547131
4238	2026-01-30 10:00:00	4	25.41	220	4618	t	2026-05-08 00:01:27.547131
4239	2026-01-30 10:00:00	7	29.05	220	6155.2	t	2026-05-08 00:01:27.547131
4240	2026-01-30 10:30:00	1	20.53	220	3891.3	t	2026-05-08 00:01:27.547131
4241	2026-01-30 10:30:00	4	19.81	220	4620.1	t	2026-05-08 00:01:27.547131
4242	2026-01-30 10:30:00	7	29.1	220	4767.2	t	2026-05-08 00:01:27.547131
4243	2026-01-30 11:00:00	1	17.32	220	3425.7	t	2026-05-08 00:01:27.547131
4244	2026-01-30 11:00:00	4	17.09	220	3545.9	t	2026-05-08 00:01:27.547131
4245	2026-01-30 11:00:00	7	28.17	220	5750.9	t	2026-05-08 00:01:27.547131
4246	2026-01-30 11:30:00	1	13.55	220	4418.8	t	2026-05-08 00:01:27.547131
4247	2026-01-30 11:30:00	4	24.34	220	4218.5	t	2026-05-08 00:01:27.547131
4248	2026-01-30 11:30:00	7	23.15	220	6365.5	t	2026-05-08 00:01:27.547131
4249	2026-01-30 12:00:00	1	13.85	220	2851.5	t	2026-05-08 00:01:27.547131
4250	2026-01-30 12:00:00	4	22.31	220	4064.1	t	2026-05-08 00:01:27.547131
4251	2026-01-30 12:00:00	7	28.49	220	6396.2	t	2026-05-08 00:01:27.547131
4252	2026-01-30 12:30:00	1	17.75	220	2591.8	t	2026-05-08 00:01:27.547131
4253	2026-01-30 12:30:00	4	24.97	220	4345.7	t	2026-05-08 00:01:27.547131
4254	2026-01-30 12:30:00	7	24.18	220	5535.9	t	2026-05-08 00:01:27.547131
4255	2026-01-30 13:00:00	1	14.8	220	4115.9	t	2026-05-08 00:01:27.547131
4256	2026-01-30 13:00:00	4	19.13	220	3800	t	2026-05-08 00:01:27.547131
4257	2026-01-30 13:00:00	7	21.57	220	5739.8	t	2026-05-08 00:01:27.547131
4258	2026-01-30 13:30:00	1	19.79	220	2829.9	t	2026-05-08 00:01:27.547131
4259	2026-01-30 13:30:00	4	20.64	220	5463.6	t	2026-05-08 00:01:27.547131
4260	2026-01-30 13:30:00	7	25.8	220	4813.3	t	2026-05-08 00:01:27.547131
4261	2026-01-30 14:00:00	1	20.84	220	2615.9	t	2026-05-08 00:01:27.547131
4262	2026-01-30 14:00:00	4	19.72	220	4407.3	t	2026-05-08 00:01:27.547131
4263	2026-01-30 14:00:00	7	22.62	220	5328.9	t	2026-05-08 00:01:27.547131
4264	2026-01-30 14:30:00	1	21.29	220	4237.9	t	2026-05-08 00:01:27.547131
4265	2026-01-30 14:30:00	4	20.93	220	5553.7	t	2026-05-08 00:01:27.547131
4266	2026-01-30 14:30:00	7	21.21	220	5698.2	t	2026-05-08 00:01:27.547131
4267	2026-01-30 15:00:00	1	18.52	220	2949.5	t	2026-05-08 00:01:27.547131
4268	2026-01-30 15:00:00	4	21.06	220	5178.8	t	2026-05-08 00:01:27.547131
4269	2026-01-30 15:00:00	7	25.9	220	5822.2	t	2026-05-08 00:01:27.547131
4270	2026-01-30 15:30:00	1	20.53	220	3679.1	t	2026-05-08 00:01:27.547131
4271	2026-01-30 15:30:00	4	18.96	220	5025.8	t	2026-05-08 00:01:27.547131
4272	2026-01-30 15:30:00	7	20.57	220	4707.2	t	2026-05-08 00:01:27.547131
4273	2026-01-30 16:00:00	1	18.62	220	4462.3	t	2026-05-08 00:01:27.547131
4274	2026-01-30 16:00:00	4	23.79	220	4009.2	t	2026-05-08 00:01:27.547131
4275	2026-01-30 16:00:00	7	21.05	220	5753.6	t	2026-05-08 00:01:27.547131
4276	2026-01-30 16:30:00	1	15.81	220	3891.6	t	2026-05-08 00:01:27.547131
4277	2026-01-30 16:30:00	4	19.86	220	4911.1	t	2026-05-08 00:01:27.547131
4278	2026-01-30 16:30:00	7	26.27	220	5066.6	t	2026-05-08 00:01:27.547131
4279	2026-01-30 17:00:00	1	12.74	220	3112.4	t	2026-05-08 00:01:27.547131
4280	2026-01-30 17:00:00	4	16.53	220	5028	t	2026-05-08 00:01:27.547131
4281	2026-01-30 17:00:00	7	30.19	220	5510.8	t	2026-05-08 00:01:27.547131
4282	2026-01-30 17:30:00	1	20.45	220	2870.2	t	2026-05-08 00:01:27.547131
4283	2026-01-30 17:30:00	4	17.39	220	4104.1	t	2026-05-08 00:01:27.547131
4284	2026-01-30 17:30:00	7	25.97	220	6414.7	t	2026-05-08 00:01:27.547131
4285	2026-01-30 18:00:00	1	13.19	220	4641	t	2026-05-08 00:01:27.547131
4286	2026-01-30 18:00:00	4	25.38	220	5388.3	t	2026-05-08 00:01:27.547131
4287	2026-01-30 18:00:00	7	22.7	220	6614.6	t	2026-05-08 00:01:27.547131
4288	2026-01-30 18:30:00	1	20.19	220	4245.5	t	2026-05-08 00:01:27.547131
4289	2026-01-30 18:30:00	4	18.81	220	4320.7	t	2026-05-08 00:01:27.547131
4290	2026-01-30 18:30:00	7	23.19	220	6459.5	t	2026-05-08 00:01:27.547131
4291	2026-01-30 19:00:00	1	15.21	220	3275.4	t	2026-05-08 00:01:27.547131
4292	2026-01-30 19:00:00	4	25.28	220	5569.6	t	2026-05-08 00:01:27.547131
4293	2026-01-30 19:00:00	7	29.2	220	4819.5	t	2026-05-08 00:01:27.547131
4294	2026-01-30 19:30:00	1	12.48	220	3230.7	t	2026-05-08 00:01:27.547131
4295	2026-01-30 19:30:00	4	19.93	220	3768	t	2026-05-08 00:01:27.547131
4296	2026-01-30 19:30:00	7	23.36	220	5629.2	t	2026-05-08 00:01:27.547131
4297	2026-01-30 20:00:00	1	2.05	220	561.3	t	2026-05-08 00:01:27.547131
4298	2026-01-30 20:00:00	4	2.22	220	672.5	t	2026-05-08 00:01:27.547131
4299	2026-01-30 20:00:00	7	2.15	220	559.7	t	2026-05-08 00:01:27.547131
4300	2026-01-30 20:30:00	1	1.53	220	713.1	t	2026-05-08 00:01:27.547131
4301	2026-01-30 20:30:00	4	3.19	220	520.5	t	2026-05-08 00:01:27.547131
4302	2026-01-30 20:30:00	7	1.47	220	489.6	t	2026-05-08 00:01:27.547131
4303	2026-01-30 21:00:00	1	3.7	220	400.3	t	2026-05-08 00:01:27.547131
4304	2026-01-30 21:00:00	4	3.66	220	754.5	t	2026-05-08 00:01:27.547131
4305	2026-01-30 21:00:00	7	2.19	220	303.8	t	2026-05-08 00:01:27.547131
4306	2026-01-30 21:30:00	1	1.23	220	377.7	t	2026-05-08 00:01:27.547131
4307	2026-01-30 21:30:00	4	1.87	220	478.3	t	2026-05-08 00:01:27.547131
4308	2026-01-30 21:30:00	7	2.36	220	810.9	t	2026-05-08 00:01:27.547131
4309	2026-01-30 22:00:00	1	3.26	220	415.3	t	2026-05-08 00:01:27.547131
4310	2026-01-30 22:00:00	4	1.85	220	396.1	t	2026-05-08 00:01:27.547131
4311	2026-01-30 22:00:00	7	2.37	220	711.8	t	2026-05-08 00:01:27.547131
4312	2026-01-30 22:30:00	1	1.61	220	387.2	t	2026-05-08 00:01:27.547131
4313	2026-01-30 22:30:00	4	2.26	220	570.7	t	2026-05-08 00:01:27.547131
4314	2026-01-30 22:30:00	7	1.75	220	722.3	t	2026-05-08 00:01:27.547131
4315	2026-01-30 23:00:00	1	2.65	220	594.5	t	2026-05-08 00:01:27.547131
4316	2026-01-30 23:00:00	4	2.19	220	783.4	t	2026-05-08 00:01:27.547131
4317	2026-01-30 23:00:00	7	2.75	220	454	t	2026-05-08 00:01:27.547131
4318	2026-01-30 23:30:00	1	2.55	220	406	t	2026-05-08 00:01:27.547131
4319	2026-01-30 23:30:00	4	1.21	220	759.5	t	2026-05-08 00:01:27.547131
4320	2026-01-30 23:30:00	7	3.65	220	520.4	t	2026-05-08 00:01:27.547131
4321	2026-01-31 00:00:00	1	2.1	220	654.1	t	2026-05-08 00:01:27.547131
4322	2026-01-31 00:00:00	4	1.78	220	634.7	t	2026-05-08 00:01:27.547131
4323	2026-01-31 00:00:00	7	1.07	220	223	t	2026-05-08 00:01:27.547131
4324	2026-01-31 00:30:00	1	1.94	220	538.9	t	2026-05-08 00:01:27.547131
4325	2026-01-31 00:30:00	4	1.38	220	596.9	t	2026-05-08 00:01:27.547131
4326	2026-01-31 00:30:00	7	1.96	220	391.3	t	2026-05-08 00:01:27.547131
4327	2026-01-31 01:00:00	1	2.73	220	286	t	2026-05-08 00:01:27.547131
4328	2026-01-31 01:00:00	4	1.6	220	505.1	t	2026-05-08 00:01:27.547131
4329	2026-01-31 01:00:00	7	2.94	220	452	t	2026-05-08 00:01:27.547131
4330	2026-01-31 01:30:00	1	1.53	220	347.5	t	2026-05-08 00:01:27.547131
4331	2026-01-31 01:30:00	4	2.59	220	450.2	t	2026-05-08 00:01:27.547131
4332	2026-01-31 01:30:00	7	1.17	220	547.9	t	2026-05-08 00:01:27.547131
4333	2026-01-31 02:00:00	1	1.76	220	416.8	t	2026-05-08 00:01:27.547131
4334	2026-01-31 02:00:00	4	1.34	220	270	t	2026-05-08 00:01:27.547131
4335	2026-01-31 02:00:00	7	1.43	220	556.5	t	2026-05-08 00:01:27.547131
4336	2026-01-31 02:30:00	1	2.23	220	297.1	t	2026-05-08 00:01:27.547131
4337	2026-01-31 02:30:00	4	1.87	220	615.4	t	2026-05-08 00:01:27.547131
4338	2026-01-31 02:30:00	7	1.46	220	488	t	2026-05-08 00:01:27.547131
4339	2026-01-31 03:00:00	1	1.21	220	300.2	t	2026-05-08 00:01:27.547131
4340	2026-01-31 03:00:00	4	1.72	220	485.1	t	2026-05-08 00:01:27.547131
4341	2026-01-31 03:00:00	7	1.3	220	398	t	2026-05-08 00:01:27.547131
4342	2026-01-31 03:30:00	1	2.63	220	544.5	t	2026-05-08 00:01:27.547131
4343	2026-01-31 03:30:00	4	2.45	220	642.8	t	2026-05-08 00:01:27.547131
4344	2026-01-31 03:30:00	7	1.16	220	552.5	t	2026-05-08 00:01:27.547131
4345	2026-01-31 04:00:00	1	1.72	220	478.8	t	2026-05-08 00:01:27.547131
4346	2026-01-31 04:00:00	4	2.06	220	607.9	t	2026-05-08 00:01:27.547131
4347	2026-01-31 04:00:00	7	1.4	220	252.3	t	2026-05-08 00:01:27.547131
4348	2026-01-31 04:30:00	1	2.36	220	397.3	t	2026-05-08 00:01:27.547131
4349	2026-01-31 04:30:00	4	2.88	220	300.4	t	2026-05-08 00:01:27.547131
4350	2026-01-31 04:30:00	7	1.92	220	639	t	2026-05-08 00:01:27.547131
4351	2026-01-31 05:00:00	1	2	220	400.5	t	2026-05-08 00:01:27.547131
4352	2026-01-31 05:00:00	4	2.14	220	487.1	t	2026-05-08 00:01:27.547131
4353	2026-01-31 05:00:00	7	3	220	451.5	t	2026-05-08 00:01:27.547131
4354	2026-01-31 05:30:00	1	2.25	220	506.6	t	2026-05-08 00:01:27.547131
4355	2026-01-31 05:30:00	4	1.94	220	286.6	t	2026-05-08 00:01:27.547131
4356	2026-01-31 05:30:00	7	1.68	220	602.3	t	2026-05-08 00:01:27.547131
4357	2026-01-31 06:00:00	1	1.06	220	469.5	t	2026-05-08 00:01:27.547131
4358	2026-01-31 06:00:00	4	1.43	220	355.9	t	2026-05-08 00:01:27.547131
4359	2026-01-31 06:00:00	7	2.79	220	494.9	t	2026-05-08 00:01:27.547131
4360	2026-01-31 06:30:00	1	2.15	220	482.5	t	2026-05-08 00:01:27.547131
4361	2026-01-31 06:30:00	4	2.83	220	539.5	t	2026-05-08 00:01:27.547131
4362	2026-01-31 06:30:00	7	1.95	220	620.7	t	2026-05-08 00:01:27.547131
4363	2026-01-31 07:00:00	1	2.61	220	462.4	t	2026-05-08 00:01:27.547131
4364	2026-01-31 07:00:00	4	2.88	220	440.3	t	2026-05-08 00:01:27.547131
4365	2026-01-31 07:00:00	7	2.03	220	353	t	2026-05-08 00:01:27.547131
4366	2026-01-31 07:30:00	1	1.32	220	220.2	t	2026-05-08 00:01:27.547131
4367	2026-01-31 07:30:00	4	2.08	220	602.5	t	2026-05-08 00:01:27.547131
4368	2026-01-31 07:30:00	7	2.89	220	558.1	t	2026-05-08 00:01:27.547131
4369	2026-01-31 08:00:00	1	2.89	220	432.2	t	2026-05-08 00:01:27.547131
4370	2026-01-31 08:00:00	4	2.02	220	584.4	t	2026-05-08 00:01:27.547131
4371	2026-01-31 08:00:00	7	2.91	220	644.7	t	2026-05-08 00:01:27.547131
4372	2026-01-31 08:30:00	1	2.01	220	381.6	t	2026-05-08 00:01:27.547131
4373	2026-01-31 08:30:00	4	1.12	220	267.2	t	2026-05-08 00:01:27.547131
4374	2026-01-31 08:30:00	7	1.37	220	381.3	t	2026-05-08 00:01:27.547131
4375	2026-01-31 09:00:00	1	1.84	220	237.2	t	2026-05-08 00:01:27.547131
4376	2026-01-31 09:00:00	4	2.09	220	541.9	t	2026-05-08 00:01:27.547131
4377	2026-01-31 09:00:00	7	2.49	220	270.7	t	2026-05-08 00:01:27.547131
4378	2026-01-31 09:30:00	1	1.68	220	397.4	t	2026-05-08 00:01:27.547131
4379	2026-01-31 09:30:00	4	2.24	220	620.1	t	2026-05-08 00:01:27.547131
4380	2026-01-31 09:30:00	7	1.17	220	480.2	t	2026-05-08 00:01:27.547131
4381	2026-01-31 10:00:00	1	2.6	220	434.6	t	2026-05-08 00:01:27.547131
4382	2026-01-31 10:00:00	4	2.42	220	266	t	2026-05-08 00:01:27.547131
4383	2026-01-31 10:00:00	7	2.85	220	386	t	2026-05-08 00:01:27.547131
4384	2026-01-31 10:30:00	1	2.56	220	600.8	t	2026-05-08 00:01:27.547131
4385	2026-01-31 10:30:00	4	1.75	220	327.8	t	2026-05-08 00:01:27.547131
4386	2026-01-31 10:30:00	7	2.76	220	521.1	t	2026-05-08 00:01:27.547131
4387	2026-01-31 11:00:00	1	1.68	220	273.3	t	2026-05-08 00:01:27.547131
4388	2026-01-31 11:00:00	4	2.23	220	535.4	t	2026-05-08 00:01:27.547131
4389	2026-01-31 11:00:00	7	1.84	220	387.4	t	2026-05-08 00:01:27.547131
4390	2026-01-31 11:30:00	1	2.82	220	287.2	t	2026-05-08 00:01:27.547131
4391	2026-01-31 11:30:00	4	2.08	220	418.8	t	2026-05-08 00:01:27.547131
4392	2026-01-31 11:30:00	7	1.04	220	480.4	t	2026-05-08 00:01:27.547131
4393	2026-01-31 12:00:00	1	2.36	220	629	t	2026-05-08 00:01:27.547131
4394	2026-01-31 12:00:00	4	2.33	220	262.7	t	2026-05-08 00:01:27.547131
4395	2026-01-31 12:00:00	7	1.82	220	550.6	t	2026-05-08 00:01:27.547131
4396	2026-01-31 12:30:00	1	2.66	220	656.6	t	2026-05-08 00:01:27.547131
4397	2026-01-31 12:30:00	4	2.58	220	263.2	t	2026-05-08 00:01:27.547131
4398	2026-01-31 12:30:00	7	2.55	220	550	t	2026-05-08 00:01:27.547131
4399	2026-01-31 13:00:00	1	2.19	220	252.4	t	2026-05-08 00:01:27.547131
4400	2026-01-31 13:00:00	4	2.69	220	546.6	t	2026-05-08 00:01:27.547131
4401	2026-01-31 13:00:00	7	2.5	220	303.5	t	2026-05-08 00:01:27.547131
4402	2026-01-31 13:30:00	1	1.45	220	401.3	t	2026-05-08 00:01:27.547131
4403	2026-01-31 13:30:00	4	1.26	220	420.8	t	2026-05-08 00:01:27.547131
4404	2026-01-31 13:30:00	7	2.98	220	530.5	t	2026-05-08 00:01:27.547131
4405	2026-01-31 14:00:00	1	1.37	220	249.8	t	2026-05-08 00:01:27.547131
4406	2026-01-31 14:00:00	4	1.86	220	603.7	t	2026-05-08 00:01:27.547131
4407	2026-01-31 14:00:00	7	2.44	220	240.7	t	2026-05-08 00:01:27.547131
4408	2026-01-31 14:30:00	1	1.06	220	631.8	t	2026-05-08 00:01:27.547131
4409	2026-01-31 14:30:00	4	1.24	220	477.6	t	2026-05-08 00:01:27.547131
4410	2026-01-31 14:30:00	7	1.21	220	416.4	t	2026-05-08 00:01:27.547131
4411	2026-01-31 15:00:00	1	2.27	220	582.9	t	2026-05-08 00:01:27.547131
4412	2026-01-31 15:00:00	4	1.45	220	371.6	t	2026-05-08 00:01:27.547131
4413	2026-01-31 15:00:00	7	2.83	220	440.9	t	2026-05-08 00:01:27.547131
4414	2026-01-31 15:30:00	1	2.04	220	641.7	t	2026-05-08 00:01:27.547131
4415	2026-01-31 15:30:00	4	1.45	220	285.7	t	2026-05-08 00:01:27.547131
4416	2026-01-31 15:30:00	7	2.46	220	351.2	t	2026-05-08 00:01:27.547131
4417	2026-01-31 16:00:00	1	2.17	220	460.8	t	2026-05-08 00:01:27.547131
4418	2026-01-31 16:00:00	4	1.41	220	307.1	t	2026-05-08 00:01:27.547131
4419	2026-01-31 16:00:00	7	2.79	220	627.7	t	2026-05-08 00:01:27.547131
4420	2026-01-31 16:30:00	1	2.96	220	358.4	t	2026-05-08 00:01:27.547131
4421	2026-01-31 16:30:00	4	1.97	220	351.9	t	2026-05-08 00:01:27.547131
4422	2026-01-31 16:30:00	7	2.58	220	504.1	t	2026-05-08 00:01:27.547131
4423	2026-01-31 17:00:00	1	1.41	220	621.5	t	2026-05-08 00:01:27.547131
4424	2026-01-31 17:00:00	4	2.45	220	653.8	t	2026-05-08 00:01:27.547131
4425	2026-01-31 17:00:00	7	1.49	220	638.2	t	2026-05-08 00:01:27.547131
4426	2026-01-31 17:30:00	1	1.67	220	528.2	t	2026-05-08 00:01:27.547131
4427	2026-01-31 17:30:00	4	1.2	220	376.5	t	2026-05-08 00:01:27.547131
4428	2026-01-31 17:30:00	7	2.72	220	350.6	t	2026-05-08 00:01:27.547131
4429	2026-01-31 18:00:00	1	1.56	220	422	t	2026-05-08 00:01:27.547131
4430	2026-01-31 18:00:00	4	1.27	220	291.2	t	2026-05-08 00:01:27.547131
4431	2026-01-31 18:00:00	7	1.61	220	427.9	t	2026-05-08 00:01:27.547131
4432	2026-01-31 18:30:00	1	2.17	220	571.3	t	2026-05-08 00:01:27.547131
4433	2026-01-31 18:30:00	4	1.52	220	457.5	t	2026-05-08 00:01:27.547131
4434	2026-01-31 18:30:00	7	1.29	220	320.6	t	2026-05-08 00:01:27.547131
4435	2026-01-31 19:00:00	1	2.02	220	540	t	2026-05-08 00:01:27.547131
4436	2026-01-31 19:00:00	4	2.23	220	545.5	t	2026-05-08 00:01:27.547131
4437	2026-01-31 19:00:00	7	2.95	220	652.6	t	2026-05-08 00:01:27.547131
4438	2026-01-31 19:30:00	1	1.35	220	415.6	t	2026-05-08 00:01:27.547131
4439	2026-01-31 19:30:00	4	1.73	220	609.8	t	2026-05-08 00:01:27.547131
4440	2026-01-31 19:30:00	7	1.76	220	555.5	t	2026-05-08 00:01:27.547131
4441	2026-01-31 20:00:00	1	1.52	220	553.5	t	2026-05-08 00:01:27.547131
4442	2026-01-31 20:00:00	4	2.35	220	517.1	t	2026-05-08 00:01:27.547131
4443	2026-01-31 20:00:00	7	2.58	220	633.5	t	2026-05-08 00:01:27.547131
4444	2026-01-31 20:30:00	1	2.39	220	305.2	t	2026-05-08 00:01:27.547131
4445	2026-01-31 20:30:00	4	1.28	220	613.7	t	2026-05-08 00:01:27.547131
4446	2026-01-31 20:30:00	7	1.58	220	411.2	t	2026-05-08 00:01:27.547131
4447	2026-01-31 21:00:00	1	2.74	220	260.5	t	2026-05-08 00:01:27.547131
4448	2026-01-31 21:00:00	4	2.5	220	267.5	t	2026-05-08 00:01:27.547131
4449	2026-01-31 21:00:00	7	2.36	220	478.3	t	2026-05-08 00:01:27.547131
4450	2026-01-31 21:30:00	1	1.89	220	315.3	t	2026-05-08 00:01:27.547131
4451	2026-01-31 21:30:00	4	1.37	220	380	t	2026-05-08 00:01:27.547131
4452	2026-01-31 21:30:00	7	1.69	220	286.9	t	2026-05-08 00:01:27.547131
4453	2026-01-31 22:00:00	1	2.49	220	608.3	t	2026-05-08 00:01:27.547131
4454	2026-01-31 22:00:00	4	1.8	220	474.5	t	2026-05-08 00:01:27.547131
4455	2026-01-31 22:00:00	7	2.97	220	617	t	2026-05-08 00:01:27.547131
4456	2026-01-31 22:30:00	1	1.46	220	514	t	2026-05-08 00:01:27.547131
4457	2026-01-31 22:30:00	4	2.42	220	307	t	2026-05-08 00:01:27.547131
4458	2026-01-31 22:30:00	7	2.12	220	345.3	t	2026-05-08 00:01:27.547131
4459	2026-01-31 23:00:00	1	2.15	220	521.2	t	2026-05-08 00:01:27.547131
4460	2026-01-31 23:00:00	4	2.02	220	645.6	t	2026-05-08 00:01:27.547131
4461	2026-01-31 23:00:00	7	1.57	220	544.6	t	2026-05-08 00:01:27.547131
4462	2026-01-31 23:30:00	1	1.89	220	612.1	t	2026-05-08 00:01:27.547131
4463	2026-01-31 23:30:00	4	2.97	220	516.5	t	2026-05-08 00:01:27.547131
4464	2026-01-31 23:30:00	7	2.82	220	330.4	t	2026-05-08 00:01:27.547131
4465	2026-02-01 00:00:00	1	2.47	220	567	t	2026-05-08 00:01:27.547131
4466	2026-02-01 00:00:00	4	1.46	220	239.1	t	2026-05-08 00:01:27.547131
4467	2026-02-01 00:00:00	7	2.64	220	273.1	t	2026-05-08 00:01:27.547131
4468	2026-02-01 00:30:00	1	1.21	220	471.9	t	2026-05-08 00:01:27.547131
4469	2026-02-01 00:30:00	4	1.82	220	280.3	t	2026-05-08 00:01:27.547131
4470	2026-02-01 00:30:00	7	1.93	220	329.1	t	2026-05-08 00:01:27.547131
4471	2026-02-01 01:00:00	1	2.77	220	384.9	t	2026-05-08 00:01:27.547131
4472	2026-02-01 01:00:00	4	2.01	220	445.6	t	2026-05-08 00:01:27.547131
4473	2026-02-01 01:00:00	7	1.66	220	416.2	t	2026-05-08 00:01:27.547131
4474	2026-02-01 01:30:00	1	2.43	220	406	t	2026-05-08 00:01:27.547131
4475	2026-02-01 01:30:00	4	1.13	220	343.4	t	2026-05-08 00:01:27.547131
4476	2026-02-01 01:30:00	7	1.39	220	558.9	t	2026-05-08 00:01:27.547131
4477	2026-02-01 02:00:00	1	1.76	220	653.5	t	2026-05-08 00:01:27.547131
4478	2026-02-01 02:00:00	4	2.94	220	657.7	t	2026-05-08 00:01:27.547131
4479	2026-02-01 02:00:00	7	1.51	220	279	t	2026-05-08 00:01:27.547131
4480	2026-02-01 02:30:00	1	2.02	220	313.6	t	2026-05-08 00:01:27.547131
4481	2026-02-01 02:30:00	4	2.11	220	565.5	t	2026-05-08 00:01:27.547131
4482	2026-02-01 02:30:00	7	1.28	220	290.7	t	2026-05-08 00:01:27.547131
4483	2026-02-01 03:00:00	1	1.48	220	495.5	t	2026-05-08 00:01:27.547131
4484	2026-02-01 03:00:00	4	1.85	220	450.1	t	2026-05-08 00:01:27.547131
4485	2026-02-01 03:00:00	7	1.19	220	590.4	t	2026-05-08 00:01:27.547131
4486	2026-02-01 03:30:00	1	1.46	220	341.6	t	2026-05-08 00:01:27.547131
4487	2026-02-01 03:30:00	4	1.21	220	463	t	2026-05-08 00:01:27.547131
4488	2026-02-01 03:30:00	7	1.7	220	492.9	t	2026-05-08 00:01:27.547131
4489	2026-02-01 04:00:00	1	2.5	220	417.2	t	2026-05-08 00:01:27.547131
4490	2026-02-01 04:00:00	4	2.1	220	411.9	t	2026-05-08 00:01:27.547131
4491	2026-02-01 04:00:00	7	1.62	220	597.2	t	2026-05-08 00:01:27.547131
4492	2026-02-01 04:30:00	1	1.71	220	580.7	t	2026-05-08 00:01:27.547131
4493	2026-02-01 04:30:00	4	1.53	220	290.7	t	2026-05-08 00:01:27.547131
4494	2026-02-01 04:30:00	7	1.45	220	372.6	t	2026-05-08 00:01:27.547131
4495	2026-02-01 05:00:00	1	1.04	220	469	t	2026-05-08 00:01:27.547131
4496	2026-02-01 05:00:00	4	2.34	220	546.9	t	2026-05-08 00:01:27.547131
4497	2026-02-01 05:00:00	7	2.59	220	540.3	t	2026-05-08 00:01:27.547131
4498	2026-02-01 05:30:00	1	2.22	220	527.5	t	2026-05-08 00:01:27.547131
4499	2026-02-01 05:30:00	4	1.56	220	625.8	t	2026-05-08 00:01:27.547131
4500	2026-02-01 05:30:00	7	1.1	220	593.8	t	2026-05-08 00:01:27.547131
4501	2026-02-01 06:00:00	1	1.23	220	642.8	t	2026-05-08 00:01:27.547131
4502	2026-02-01 06:00:00	4	2.84	220	412.6	t	2026-05-08 00:01:27.547131
4503	2026-02-01 06:00:00	7	2	220	259.8	t	2026-05-08 00:01:27.547131
4504	2026-02-01 06:30:00	1	1.33	220	619.8	t	2026-05-08 00:01:27.547131
4505	2026-02-01 06:30:00	4	1.43	220	299.9	t	2026-05-08 00:01:27.547131
4506	2026-02-01 06:30:00	7	1.92	220	623.1	t	2026-05-08 00:01:27.547131
4507	2026-02-01 07:00:00	1	1.31	220	560.2	t	2026-05-08 00:01:27.547131
4508	2026-02-01 07:00:00	4	1.31	220	525.9	t	2026-05-08 00:01:27.547131
4509	2026-02-01 07:00:00	7	1.22	220	224.3	t	2026-05-08 00:01:27.547131
4510	2026-02-01 07:30:00	1	1.18	220	543.3	t	2026-05-08 00:01:27.547131
4511	2026-02-01 07:30:00	4	2.86	220	364.3	t	2026-05-08 00:01:27.547131
4512	2026-02-01 07:30:00	7	1.6	220	596.7	t	2026-05-08 00:01:27.547131
4513	2026-02-01 08:00:00	1	1.51	220	644.9	t	2026-05-08 00:01:27.547131
4514	2026-02-01 08:00:00	4	2.36	220	401.2	t	2026-05-08 00:01:27.547131
4515	2026-02-01 08:00:00	7	1.87	220	313	t	2026-05-08 00:01:27.547131
4516	2026-02-01 08:30:00	1	2.25	220	601.2	t	2026-05-08 00:01:27.547131
4517	2026-02-01 08:30:00	4	2.22	220	448.8	t	2026-05-08 00:01:27.547131
4518	2026-02-01 08:30:00	7	2.85	220	495.6	t	2026-05-08 00:01:27.547131
4519	2026-02-01 09:00:00	1	1.79	220	371	t	2026-05-08 00:01:27.547131
4520	2026-02-01 09:00:00	4	2.89	220	333	t	2026-05-08 00:01:27.547131
4521	2026-02-01 09:00:00	7	2.18	220	617.2	t	2026-05-08 00:01:27.547131
4522	2026-02-01 09:30:00	1	1.95	220	565.7	t	2026-05-08 00:01:27.547131
4523	2026-02-01 09:30:00	4	1.81	220	228.8	t	2026-05-08 00:01:27.547131
4524	2026-02-01 09:30:00	7	1.88	220	380.8	t	2026-05-08 00:01:27.547131
4525	2026-02-01 10:00:00	1	1.35	220	659.5	t	2026-05-08 00:01:27.547131
4526	2026-02-01 10:00:00	4	1.57	220	397.1	t	2026-05-08 00:01:27.547131
4527	2026-02-01 10:00:00	7	2.54	220	235.3	t	2026-05-08 00:01:27.547131
4528	2026-02-01 10:30:00	1	1.66	220	302	t	2026-05-08 00:01:27.547131
4529	2026-02-01 10:30:00	4	1.18	220	426.3	t	2026-05-08 00:01:27.547131
4530	2026-02-01 10:30:00	7	1.33	220	536.7	t	2026-05-08 00:01:27.547131
4531	2026-02-01 11:00:00	1	2.83	220	446.3	t	2026-05-08 00:01:27.547131
4532	2026-02-01 11:00:00	4	1.12	220	312.9	t	2026-05-08 00:01:27.547131
4533	2026-02-01 11:00:00	7	1.63	220	553.7	t	2026-05-08 00:01:27.547131
4534	2026-02-01 11:30:00	1	1.05	220	408.9	t	2026-05-08 00:01:27.547131
4535	2026-02-01 11:30:00	4	2.43	220	512.7	t	2026-05-08 00:01:27.547131
4536	2026-02-01 11:30:00	7	2.06	220	521.7	t	2026-05-08 00:01:27.547131
4537	2026-02-01 12:00:00	1	2.58	220	259.1	t	2026-05-08 00:01:27.547131
4538	2026-02-01 12:00:00	4	1.09	220	586.6	t	2026-05-08 00:01:27.547131
4539	2026-02-01 12:00:00	7	2.61	220	637.8	t	2026-05-08 00:01:27.547131
4540	2026-02-01 12:30:00	1	2.99	220	513.7	t	2026-05-08 00:01:27.547131
4541	2026-02-01 12:30:00	4	1.08	220	571.3	t	2026-05-08 00:01:27.547131
4542	2026-02-01 12:30:00	7	1.23	220	262.4	t	2026-05-08 00:01:27.547131
4543	2026-02-01 13:00:00	1	1.52	220	329.1	t	2026-05-08 00:01:27.547131
4544	2026-02-01 13:00:00	4	2.62	220	620.7	t	2026-05-08 00:01:27.547131
4545	2026-02-01 13:00:00	7	2.86	220	297.2	t	2026-05-08 00:01:27.547131
4546	2026-02-01 13:30:00	1	3	220	476	t	2026-05-08 00:01:27.547131
4547	2026-02-01 13:30:00	4	1.66	220	603.5	t	2026-05-08 00:01:27.547131
4548	2026-02-01 13:30:00	7	1.35	220	522.7	t	2026-05-08 00:01:27.547131
4549	2026-02-01 14:00:00	1	2.77	220	236.6	t	2026-05-08 00:01:27.547131
4550	2026-02-01 14:00:00	4	1.98	220	357.6	t	2026-05-08 00:01:27.547131
4551	2026-02-01 14:00:00	7	1.23	220	479.8	t	2026-05-08 00:01:27.547131
4552	2026-02-01 14:30:00	1	1.06	220	226.4	t	2026-05-08 00:01:27.547131
4553	2026-02-01 14:30:00	4	1.61	220	299.9	t	2026-05-08 00:01:27.547131
4554	2026-02-01 14:30:00	7	1.45	220	550.8	t	2026-05-08 00:01:27.547131
4555	2026-02-01 15:00:00	1	1.62	220	432.3	t	2026-05-08 00:01:27.547131
4556	2026-02-01 15:00:00	4	2.43	220	571.6	t	2026-05-08 00:01:27.547131
4557	2026-02-01 15:00:00	7	1.01	220	645.9	t	2026-05-08 00:01:27.547131
4558	2026-02-01 15:30:00	1	2.2	220	270.6	t	2026-05-08 00:01:27.547131
4559	2026-02-01 15:30:00	4	1.09	220	460.6	t	2026-05-08 00:01:27.547131
4560	2026-02-01 15:30:00	7	2.5	220	289.6	t	2026-05-08 00:01:27.547131
4561	2026-02-01 16:00:00	1	2.47	220	353.6	t	2026-05-08 00:01:27.547131
4562	2026-02-01 16:00:00	4	1.99	220	308.9	t	2026-05-08 00:01:27.547131
4563	2026-02-01 16:00:00	7	2.27	220	592.7	t	2026-05-08 00:01:27.547131
4564	2026-02-01 16:30:00	1	2.97	220	573.2	t	2026-05-08 00:01:27.547131
4565	2026-02-01 16:30:00	4	1.41	220	485.6	t	2026-05-08 00:01:27.547131
4566	2026-02-01 16:30:00	7	1.28	220	392.3	t	2026-05-08 00:01:27.547131
4567	2026-02-01 17:00:00	1	1.71	220	507.6	t	2026-05-08 00:01:27.547131
4568	2026-02-01 17:00:00	4	2.66	220	322	t	2026-05-08 00:01:27.547131
4569	2026-02-01 17:00:00	7	2.46	220	535.9	t	2026-05-08 00:01:27.547131
4570	2026-02-01 17:30:00	1	2.3	220	248.3	t	2026-05-08 00:01:27.547131
4571	2026-02-01 17:30:00	4	1.47	220	414.8	t	2026-05-08 00:01:27.547131
4572	2026-02-01 17:30:00	7	2.53	220	576.6	t	2026-05-08 00:01:27.547131
4573	2026-02-01 18:00:00	1	1.05	220	618.4	t	2026-05-08 00:01:27.547131
4574	2026-02-01 18:00:00	4	1.76	220	367.6	t	2026-05-08 00:01:27.547131
4575	2026-02-01 18:00:00	7	1.32	220	366.5	t	2026-05-08 00:01:27.547131
4576	2026-02-01 18:30:00	1	2.56	220	638.2	t	2026-05-08 00:01:27.547131
4577	2026-02-01 18:30:00	4	1.54	220	415.2	t	2026-05-08 00:01:27.547131
4578	2026-02-01 18:30:00	7	1.39	220	418.7	t	2026-05-08 00:01:27.547131
4579	2026-02-01 19:00:00	1	2.94	220	361.2	t	2026-05-08 00:01:27.547131
4580	2026-02-01 19:00:00	4	2.56	220	437.9	t	2026-05-08 00:01:27.547131
4581	2026-02-01 19:00:00	7	2.94	220	225.1	t	2026-05-08 00:01:27.547131
4582	2026-02-01 19:30:00	1	2.12	220	337.2	t	2026-05-08 00:01:27.547131
4583	2026-02-01 19:30:00	4	2.48	220	590.8	t	2026-05-08 00:01:27.547131
4584	2026-02-01 19:30:00	7	1.93	220	407.9	t	2026-05-08 00:01:27.547131
4585	2026-02-01 20:00:00	1	1.84	220	505.4	t	2026-05-08 00:01:27.547131
4586	2026-02-01 20:00:00	4	1.29	220	394.1	t	2026-05-08 00:01:27.547131
4587	2026-02-01 20:00:00	7	2.18	220	593.1	t	2026-05-08 00:01:27.547131
4588	2026-02-01 20:30:00	1	2.06	220	594.1	t	2026-05-08 00:01:27.547131
4589	2026-02-01 20:30:00	4	2.67	220	402.4	t	2026-05-08 00:01:27.547131
4590	2026-02-01 20:30:00	7	1.85	220	331.8	t	2026-05-08 00:01:27.547131
4591	2026-02-01 21:00:00	1	1.12	220	245.7	t	2026-05-08 00:01:27.547131
4592	2026-02-01 21:00:00	4	2.5	220	575.3	t	2026-05-08 00:01:27.547131
4593	2026-02-01 21:00:00	7	1.64	220	437.5	t	2026-05-08 00:01:27.547131
4594	2026-02-01 21:30:00	1	1.93	220	656.2	t	2026-05-08 00:01:27.547131
4595	2026-02-01 21:30:00	4	1.26	220	404.3	t	2026-05-08 00:01:27.547131
4596	2026-02-01 21:30:00	7	1.57	220	415.3	t	2026-05-08 00:01:27.547131
4597	2026-02-01 22:00:00	1	2.9	220	491.9	t	2026-05-08 00:01:27.547131
4598	2026-02-01 22:00:00	4	1.34	220	412.9	t	2026-05-08 00:01:27.547131
4599	2026-02-01 22:00:00	7	1.46	220	604.4	t	2026-05-08 00:01:27.547131
4600	2026-02-01 22:30:00	1	1.35	220	648.3	t	2026-05-08 00:01:27.547131
4601	2026-02-01 22:30:00	4	1.59	220	598.9	t	2026-05-08 00:01:27.547131
4602	2026-02-01 22:30:00	7	1.73	220	297	t	2026-05-08 00:01:27.547131
4603	2026-02-01 23:00:00	1	1.04	220	451	t	2026-05-08 00:01:27.547131
4604	2026-02-01 23:00:00	4	2.35	220	548.4	t	2026-05-08 00:01:27.547131
4605	2026-02-01 23:00:00	7	1.11	220	303.2	t	2026-05-08 00:01:27.547131
4606	2026-02-01 23:30:00	1	1.68	220	458.7	t	2026-05-08 00:01:27.547131
4607	2026-02-01 23:30:00	4	2.71	220	646	t	2026-05-08 00:01:27.547131
4608	2026-02-01 23:30:00	7	2.08	220	432.5	t	2026-05-08 00:01:27.547131
4609	2026-02-02 00:00:00	1	2.64	220	670.6	t	2026-05-08 00:01:27.547131
4610	2026-02-02 00:00:00	4	2.85	220	535.1	t	2026-05-08 00:01:27.547131
4611	2026-02-02 00:00:00	7	2.17	220	803.5	t	2026-05-08 00:01:27.547131
4612	2026-02-02 00:30:00	1	1.77	220	732.3	t	2026-05-08 00:01:27.547131
4613	2026-02-02 00:30:00	4	2.94	220	604.7	t	2026-05-08 00:01:27.547131
4614	2026-02-02 00:30:00	7	2.31	220	687.4	t	2026-05-08 00:01:27.547131
4615	2026-02-02 01:00:00	1	3.44	220	659.7	t	2026-05-08 00:01:27.547131
4616	2026-02-02 01:00:00	4	1.97	220	533	t	2026-05-08 00:01:27.547131
4617	2026-02-02 01:00:00	7	2.69	220	556	t	2026-05-08 00:01:27.547131
4618	2026-02-02 01:30:00	1	3.35	220	622.9	t	2026-05-08 00:01:27.547131
4619	2026-02-02 01:30:00	4	3.55	220	360.1	t	2026-05-08 00:01:27.547131
4620	2026-02-02 01:30:00	7	2.73	220	508.2	t	2026-05-08 00:01:27.547131
4621	2026-02-02 02:00:00	1	2.75	220	343	t	2026-05-08 00:01:27.547131
4622	2026-02-02 02:00:00	4	2.92	220	557.5	t	2026-05-08 00:01:27.547131
4623	2026-02-02 02:00:00	7	2.62	220	654.1	t	2026-05-08 00:01:27.547131
4624	2026-02-02 02:30:00	1	2.5	220	319.8	t	2026-05-08 00:01:27.547131
4625	2026-02-02 02:30:00	4	3.64	220	633.2	t	2026-05-08 00:01:27.547131
4626	2026-02-02 02:30:00	7	2.87	220	639.2	t	2026-05-08 00:01:27.547131
4627	2026-02-02 03:00:00	1	2.91	220	629.2	t	2026-05-08 00:01:27.547131
4628	2026-02-02 03:00:00	4	1.21	220	549.7	t	2026-05-08 00:01:27.547131
4629	2026-02-02 03:00:00	7	2.03	220	486.5	t	2026-05-08 00:01:27.547131
4630	2026-02-02 03:30:00	1	3.61	220	676.9	t	2026-05-08 00:01:27.547131
4631	2026-02-02 03:30:00	4	1.29	220	526.5	t	2026-05-08 00:01:27.547131
4632	2026-02-02 03:30:00	7	2.95	220	404.3	t	2026-05-08 00:01:27.547131
4633	2026-02-02 04:00:00	1	1.52	220	594.9	t	2026-05-08 00:01:27.547131
4634	2026-02-02 04:00:00	4	1.52	220	535.7	t	2026-05-08 00:01:27.547131
4635	2026-02-02 04:00:00	7	3.33	220	741.5	t	2026-05-08 00:01:27.547131
4636	2026-02-02 04:30:00	1	3.42	220	518.6	t	2026-05-08 00:01:27.547131
4637	2026-02-02 04:30:00	4	3.22	220	314.6	t	2026-05-08 00:01:27.547131
4638	2026-02-02 04:30:00	7	1.79	220	739.7	t	2026-05-08 00:01:27.547131
4639	2026-02-02 05:00:00	1	2.09	220	679.7	t	2026-05-08 00:01:27.547131
4640	2026-02-02 05:00:00	4	2.92	220	315.4	t	2026-05-08 00:01:27.547131
4641	2026-02-02 05:00:00	7	3.33	220	681.9	t	2026-05-08 00:01:27.547131
4642	2026-02-02 05:30:00	1	2.68	220	427.6	t	2026-05-08 00:01:27.547131
4643	2026-02-02 05:30:00	4	3.34	220	742.9	t	2026-05-08 00:01:27.547131
4644	2026-02-02 05:30:00	7	2.21	220	579.6	t	2026-05-08 00:01:27.547131
4645	2026-02-02 06:00:00	1	3.67	220	551.8	t	2026-05-08 00:01:27.547131
4646	2026-02-02 06:00:00	4	3.3	220	291.3	t	2026-05-08 00:01:27.547131
4647	2026-02-02 06:00:00	7	1.25	220	549.1	t	2026-05-08 00:01:27.547131
4648	2026-02-02 06:30:00	1	3.52	220	491	t	2026-05-08 00:01:27.547131
4649	2026-02-02 06:30:00	4	1.61	220	511.5	t	2026-05-08 00:01:27.547131
4650	2026-02-02 06:30:00	7	1.39	220	329.8	t	2026-05-08 00:01:27.547131
4651	2026-02-02 07:00:00	1	16.29	220	2984.3	t	2026-05-08 00:01:27.547131
4652	2026-02-02 07:00:00	4	22.34	220	3708.8	t	2026-05-08 00:01:27.547131
4653	2026-02-02 07:00:00	7	29.48	220	6407.9	t	2026-05-08 00:01:27.547131
4654	2026-02-02 07:30:00	1	20.74	220	3749.4	t	2026-05-08 00:01:27.547131
4655	2026-02-02 07:30:00	4	21.74	220	3981	t	2026-05-08 00:01:27.547131
4656	2026-02-02 07:30:00	7	24.44	220	6626.8	t	2026-05-08 00:01:27.547131
4657	2026-02-02 08:00:00	1	17.87	220	4016.7	t	2026-05-08 00:01:27.547131
4658	2026-02-02 08:00:00	4	19.58	220	5098.5	t	2026-05-08 00:01:27.547131
4659	2026-02-02 08:00:00	7	26.21	220	4715	t	2026-05-08 00:01:27.547131
4660	2026-02-02 08:30:00	1	14.67	220	4683.6	t	2026-05-08 00:01:27.547131
4661	2026-02-02 08:30:00	4	17.09	220	4028.8	t	2026-05-08 00:01:27.547131
4662	2026-02-02 08:30:00	7	21.55	220	5272.7	t	2026-05-08 00:01:27.547131
4663	2026-02-02 09:00:00	1	18.2	220	3935.8	t	2026-05-08 00:01:27.547131
4664	2026-02-02 09:00:00	4	24.95	220	4577.5	t	2026-05-08 00:01:27.547131
4665	2026-02-02 09:00:00	7	22.38	220	5065.9	t	2026-05-08 00:01:27.547131
4666	2026-02-02 09:30:00	1	18.15	220	3811	t	2026-05-08 00:01:27.547131
4667	2026-02-02 09:30:00	4	20.5	220	5538	t	2026-05-08 00:01:27.547131
4668	2026-02-02 09:30:00	7	23.36	220	5075.6	t	2026-05-08 00:01:27.547131
4669	2026-02-02 10:00:00	1	13.33	220	3582.2	t	2026-05-08 00:01:27.547131
4670	2026-02-02 10:00:00	4	25.68	220	4432.8	t	2026-05-08 00:01:27.547131
4671	2026-02-02 10:00:00	7	23.8	220	6607.3	t	2026-05-08 00:01:27.547131
4672	2026-02-02 10:30:00	1	18.66	220	3263.4	t	2026-05-08 00:01:27.547131
4673	2026-02-02 10:30:00	4	17.6	220	5479.5	t	2026-05-08 00:01:27.547131
4674	2026-02-02 10:30:00	7	28.62	220	5725.9	t	2026-05-08 00:01:27.547131
4675	2026-02-02 11:00:00	1	19.91	220	3722.9	t	2026-05-08 00:01:27.547131
4676	2026-02-02 11:00:00	4	19.44	220	4148.4	t	2026-05-08 00:01:27.547131
4677	2026-02-02 11:00:00	7	24.52	220	6193.2	t	2026-05-08 00:01:27.547131
4678	2026-02-02 11:30:00	1	12.57	220	4663.9	t	2026-05-08 00:01:27.547131
4679	2026-02-02 11:30:00	4	23.2	220	4323.4	t	2026-05-08 00:01:27.547131
4680	2026-02-02 11:30:00	7	29.58	220	4939.4	t	2026-05-08 00:01:27.547131
4681	2026-02-02 12:00:00	1	15.5	220	3095.3	t	2026-05-08 00:01:27.547131
4682	2026-02-02 12:00:00	4	19.74	220	5410.9	t	2026-05-08 00:01:27.547131
4683	2026-02-02 12:00:00	7	30.48	220	5792.9	t	2026-05-08 00:01:27.547131
4684	2026-02-02 12:30:00	1	20.46	220	2801	t	2026-05-08 00:01:27.547131
4685	2026-02-02 12:30:00	4	21.27	220	3946.6	t	2026-05-08 00:01:27.547131
4686	2026-02-02 12:30:00	7	22.55	220	6588	t	2026-05-08 00:01:27.547131
4687	2026-02-02 13:00:00	1	16.56	220	2727.7	t	2026-05-08 00:01:27.547131
4688	2026-02-02 13:00:00	4	25.37	220	3599.3	t	2026-05-08 00:01:27.547131
4689	2026-02-02 13:00:00	7	24.06	220	6189.4	t	2026-05-08 00:01:27.547131
4690	2026-02-02 13:30:00	1	17.77	220	4123.1	t	2026-05-08 00:01:27.547131
4691	2026-02-02 13:30:00	4	19.97	220	4021	t	2026-05-08 00:01:27.547131
4692	2026-02-02 13:30:00	7	22.67	220	6355.5	t	2026-05-08 00:01:27.547131
4693	2026-02-02 14:00:00	1	11.54	220	2661.5	t	2026-05-08 00:01:27.547131
4694	2026-02-02 14:00:00	4	16.2	220	3983.6	t	2026-05-08 00:01:27.547131
4695	2026-02-02 14:00:00	7	27.04	220	5476.3	t	2026-05-08 00:01:27.547131
4696	2026-02-02 14:30:00	1	13.88	220	4245.8	t	2026-05-08 00:01:27.547131
4697	2026-02-02 14:30:00	4	17.23	220	4495.5	t	2026-05-08 00:01:27.547131
4698	2026-02-02 14:30:00	7	23.92	220	4628	t	2026-05-08 00:01:27.547131
4699	2026-02-02 15:00:00	1	12.99	220	3710.4	t	2026-05-08 00:01:27.547131
4700	2026-02-02 15:00:00	4	19.85	220	3613.1	t	2026-05-08 00:01:27.547131
4701	2026-02-02 15:00:00	7	27.98	220	4727.9	t	2026-05-08 00:01:27.547131
4702	2026-02-02 15:30:00	1	12.69	220	4511.3	t	2026-05-08 00:01:27.547131
4703	2026-02-02 15:30:00	4	17.76	220	3834.7	t	2026-05-08 00:01:27.547131
4704	2026-02-02 15:30:00	7	26.48	220	5300.2	t	2026-05-08 00:01:27.547131
4705	2026-02-02 16:00:00	1	18.52	220	2601.4	t	2026-05-08 00:01:27.547131
4706	2026-02-02 16:00:00	4	25.69	220	4636.2	t	2026-05-08 00:01:27.547131
4707	2026-02-02 16:00:00	7	23.55	220	5913.8	t	2026-05-08 00:01:27.547131
4708	2026-02-02 16:30:00	1	17.97	220	3066.7	t	2026-05-08 00:01:27.547131
4709	2026-02-02 16:30:00	4	23.46	220	3858.4	t	2026-05-08 00:01:27.547131
4710	2026-02-02 16:30:00	7	25.74	220	4629.2	t	2026-05-08 00:01:27.547131
4711	2026-02-02 17:00:00	1	13.93	220	3088.8	t	2026-05-08 00:01:27.547131
4712	2026-02-02 17:00:00	4	16.69	220	4484.8	t	2026-05-08 00:01:27.547131
4713	2026-02-02 17:00:00	7	29.8	220	5079	t	2026-05-08 00:01:27.547131
4714	2026-02-02 17:30:00	1	11.65	220	4002.3	t	2026-05-08 00:01:27.547131
4715	2026-02-02 17:30:00	4	22.73	220	5164.9	t	2026-05-08 00:01:27.547131
4716	2026-02-02 17:30:00	7	20.98	220	6422.1	t	2026-05-08 00:01:27.547131
4717	2026-02-02 18:00:00	1	11.73	220	4030.1	t	2026-05-08 00:01:27.547131
4718	2026-02-02 18:00:00	4	22.18	220	4015.3	t	2026-05-08 00:01:27.547131
4719	2026-02-02 18:00:00	7	22.29	220	5244.3	t	2026-05-08 00:01:27.547131
4720	2026-02-02 18:30:00	1	16.95	220	2757.6	t	2026-05-08 00:01:27.547131
4721	2026-02-02 18:30:00	4	18.24	220	4316.9	t	2026-05-08 00:01:27.547131
4722	2026-02-02 18:30:00	7	30.28	220	5242.5	t	2026-05-08 00:01:27.547131
4723	2026-02-02 19:00:00	1	18.54	220	3448.2	t	2026-05-08 00:01:27.547131
4724	2026-02-02 19:00:00	4	21.02	220	3683	t	2026-05-08 00:01:27.547131
4725	2026-02-02 19:00:00	7	23.46	220	6673.7	t	2026-05-08 00:01:27.547131
4726	2026-02-02 19:30:00	1	16.51	220	3785.3	t	2026-05-08 00:01:27.547131
4727	2026-02-02 19:30:00	4	25.06	220	5224.6	t	2026-05-08 00:01:27.547131
4728	2026-02-02 19:30:00	7	26.79	220	5694.4	t	2026-05-08 00:01:27.547131
4729	2026-02-02 20:00:00	1	1.31	220	683.9	t	2026-05-08 00:01:27.547131
4730	2026-02-02 20:00:00	4	1.99	220	272.9	t	2026-05-08 00:01:27.547131
4731	2026-02-02 20:00:00	7	3.56	220	608.8	t	2026-05-08 00:01:27.547131
4732	2026-02-02 20:30:00	1	1.59	220	550.1	t	2026-05-08 00:01:27.547131
4733	2026-02-02 20:30:00	4	2.28	220	702.5	t	2026-05-08 00:01:27.547131
4734	2026-02-02 20:30:00	7	3.46	220	514.7	t	2026-05-08 00:01:27.547131
4735	2026-02-02 21:00:00	1	2.38	220	603.1	t	2026-05-08 00:01:27.547131
4736	2026-02-02 21:00:00	4	2.06	220	342.3	t	2026-05-08 00:01:27.547131
4737	2026-02-02 21:00:00	7	1.47	220	697.6	t	2026-05-08 00:01:27.547131
4738	2026-02-02 21:30:00	1	1.45	220	281.8	t	2026-05-08 00:01:27.547131
4739	2026-02-02 21:30:00	4	2.75	220	597.5	t	2026-05-08 00:01:27.547131
4740	2026-02-02 21:30:00	7	1.87	220	796.6	t	2026-05-08 00:01:27.547131
4741	2026-02-02 22:00:00	1	1.54	220	268.3	t	2026-05-08 00:01:27.547131
4742	2026-02-02 22:00:00	4	2.19	220	709.6	t	2026-05-08 00:01:27.547131
4743	2026-02-02 22:00:00	7	1.44	220	723.7	t	2026-05-08 00:01:27.547131
4744	2026-02-02 22:30:00	1	1.76	220	382.3	t	2026-05-08 00:01:27.547131
4745	2026-02-02 22:30:00	4	1.22	220	777.5	t	2026-05-08 00:01:27.547131
4746	2026-02-02 22:30:00	7	3.3	220	554	t	2026-05-08 00:01:27.547131
4747	2026-02-02 23:00:00	1	2.48	220	760.8	t	2026-05-08 00:01:27.547131
4748	2026-02-02 23:00:00	4	3.44	220	656.3	t	2026-05-08 00:01:27.547131
4749	2026-02-02 23:00:00	7	1.65	220	556.9	t	2026-05-08 00:01:27.547131
4750	2026-02-02 23:30:00	1	2.39	220	381.6	t	2026-05-08 00:01:27.547131
4751	2026-02-02 23:30:00	4	3.36	220	365.5	t	2026-05-08 00:01:27.547131
4752	2026-02-02 23:30:00	7	2.12	220	527.6	t	2026-05-08 00:01:27.547131
4753	2026-02-03 00:00:00	1	2.2	220	392.6	t	2026-05-08 00:01:27.547131
4754	2026-02-03 00:00:00	4	3.4	220	634.2	t	2026-05-08 00:01:27.547131
4755	2026-02-03 00:00:00	7	2.59	220	742.1	t	2026-05-08 00:01:27.547131
4756	2026-02-03 00:30:00	1	1.58	220	294.3	t	2026-05-08 00:01:27.547131
4757	2026-02-03 00:30:00	4	3.19	220	517.1	t	2026-05-08 00:01:27.547131
4758	2026-02-03 00:30:00	7	2.6	220	483.5	t	2026-05-08 00:01:27.547131
4759	2026-02-03 01:00:00	1	2.88	220	360.1	t	2026-05-08 00:01:27.547131
4760	2026-02-03 01:00:00	4	3.63	220	499.6	t	2026-05-08 00:01:27.547131
4761	2026-02-03 01:00:00	7	3.62	220	694.5	t	2026-05-08 00:01:27.547131
4762	2026-02-03 01:30:00	1	2.2	220	580.2	t	2026-05-08 00:01:27.547131
4763	2026-02-03 01:30:00	4	1.95	220	331.8	t	2026-05-08 00:01:27.547131
4764	2026-02-03 01:30:00	7	3.16	220	328.8	t	2026-05-08 00:01:27.547131
4765	2026-02-03 02:00:00	1	3.49	220	575.7	t	2026-05-08 00:01:27.547131
4766	2026-02-03 02:00:00	4	2.74	220	761	t	2026-05-08 00:01:27.547131
4767	2026-02-03 02:00:00	7	1.27	220	284.2	t	2026-05-08 00:01:27.547131
4768	2026-02-03 02:30:00	1	2.57	220	672.1	t	2026-05-08 00:01:27.547131
4769	2026-02-03 02:30:00	4	1.99	220	433	t	2026-05-08 00:01:27.547131
4770	2026-02-03 02:30:00	7	1.96	220	436.9	t	2026-05-08 00:01:27.547131
4771	2026-02-03 03:00:00	1	2	220	660	t	2026-05-08 00:01:27.547131
4772	2026-02-03 03:00:00	4	2.09	220	468.7	t	2026-05-08 00:01:27.547131
4773	2026-02-03 03:00:00	7	3.04	220	652.2	t	2026-05-08 00:01:27.547131
4774	2026-02-03 03:30:00	1	3.46	220	405.2	t	2026-05-08 00:01:27.547131
4775	2026-02-03 03:30:00	4	1.25	220	611.9	t	2026-05-08 00:01:27.547131
4776	2026-02-03 03:30:00	7	2.2	220	687.8	t	2026-05-08 00:01:27.547131
4777	2026-02-03 04:00:00	1	3.01	220	735.9	t	2026-05-08 00:01:27.547131
4778	2026-02-03 04:00:00	4	2.84	220	766.5	t	2026-05-08 00:01:27.547131
4779	2026-02-03 04:00:00	7	2.83	220	484.1	t	2026-05-08 00:01:27.547131
4780	2026-02-03 04:30:00	1	2.28	220	637.2	t	2026-05-08 00:01:27.547131
4781	2026-02-03 04:30:00	4	2.61	220	492.4	t	2026-05-08 00:01:27.547131
4782	2026-02-03 04:30:00	7	2.15	220	442.6	t	2026-05-08 00:01:27.547131
4783	2026-02-03 05:00:00	1	2.93	220	470.9	t	2026-05-08 00:01:27.547131
4784	2026-02-03 05:00:00	4	2.04	220	597	t	2026-05-08 00:01:27.547131
4785	2026-02-03 05:00:00	7	1.75	220	522.8	t	2026-05-08 00:01:27.547131
4786	2026-02-03 05:30:00	1	1.48	220	496.1	t	2026-05-08 00:01:27.547131
4787	2026-02-03 05:30:00	4	2.4	220	787.7	t	2026-05-08 00:01:27.547131
4788	2026-02-03 05:30:00	7	3.53	220	392.1	t	2026-05-08 00:01:27.547131
4789	2026-02-03 06:00:00	1	1.36	220	296	t	2026-05-08 00:01:27.547131
4790	2026-02-03 06:00:00	4	2.61	220	535.9	t	2026-05-08 00:01:27.547131
4791	2026-02-03 06:00:00	7	1.91	220	455.9	t	2026-05-08 00:01:27.547131
4792	2026-02-03 06:30:00	1	3.16	220	708.3	t	2026-05-08 00:01:27.547131
4793	2026-02-03 06:30:00	4	1.27	220	731.8	t	2026-05-08 00:01:27.547131
4794	2026-02-03 06:30:00	7	1.84	220	762	t	2026-05-08 00:01:27.547131
4795	2026-02-03 07:00:00	1	18.07	220	2873.8	t	2026-05-08 00:01:27.547131
4796	2026-02-03 07:00:00	4	22.82	220	4894.3	t	2026-05-08 00:01:27.547131
4797	2026-02-03 07:00:00	7	29.59	220	6664.5	t	2026-05-08 00:01:27.547131
4798	2026-02-03 07:30:00	1	17.81	220	2718.2	t	2026-05-08 00:01:27.547131
4799	2026-02-03 07:30:00	4	20.72	220	3588.7	t	2026-05-08 00:01:27.547131
4800	2026-02-03 07:30:00	7	20.66	220	6475.4	t	2026-05-08 00:01:27.547131
4801	2026-02-03 08:00:00	1	11.6	220	2810.3	t	2026-05-08 00:01:27.547131
4802	2026-02-03 08:00:00	4	20.84	220	5096.8	t	2026-05-08 00:01:27.547131
4803	2026-02-03 08:00:00	7	25.21	220	6262.6	t	2026-05-08 00:01:27.547131
4804	2026-02-03 08:30:00	1	21.02	220	3613	t	2026-05-08 00:01:27.547131
4805	2026-02-03 08:30:00	4	18.31	220	4670.1	t	2026-05-08 00:01:27.547131
4806	2026-02-03 08:30:00	7	29.18	220	6588.8	t	2026-05-08 00:01:27.547131
4807	2026-02-03 09:00:00	1	19	220	3687.9	t	2026-05-08 00:01:27.547131
4808	2026-02-03 09:00:00	4	17.18	220	5619.8	t	2026-05-08 00:01:27.547131
4809	2026-02-03 09:00:00	7	25.5	220	5494.8	t	2026-05-08 00:01:27.547131
4810	2026-02-03 09:30:00	1	20.87	220	4005.1	t	2026-05-08 00:01:27.547131
4811	2026-02-03 09:30:00	4	24.05	220	3688.5	t	2026-05-08 00:01:27.547131
4812	2026-02-03 09:30:00	7	22.37	220	5519.4	t	2026-05-08 00:01:27.547131
4813	2026-02-03 10:00:00	1	18.57	220	4457.3	t	2026-05-08 00:01:27.547131
4814	2026-02-03 10:00:00	4	24.3	220	4957.2	t	2026-05-08 00:01:27.547131
4815	2026-02-03 10:00:00	7	28.62	220	4681.5	t	2026-05-08 00:01:27.547131
4816	2026-02-03 10:30:00	1	17.26	220	3291.7	t	2026-05-08 00:01:27.547131
4817	2026-02-03 10:30:00	4	25.73	220	4353.1	t	2026-05-08 00:01:27.547131
4818	2026-02-03 10:30:00	7	20.68	220	5720.9	t	2026-05-08 00:01:27.547131
4819	2026-02-03 11:00:00	1	12	220	4289.6	t	2026-05-08 00:01:27.547131
4820	2026-02-03 11:00:00	4	17.5	220	4612	t	2026-05-08 00:01:27.547131
4821	2026-02-03 11:00:00	7	28.34	220	4955	t	2026-05-08 00:01:27.547131
4822	2026-02-03 11:30:00	1	21.08	220	3171.8	t	2026-05-08 00:01:27.547131
4823	2026-02-03 11:30:00	4	25.45	220	5346.6	t	2026-05-08 00:01:27.547131
4824	2026-02-03 11:30:00	7	27.12	220	4878	t	2026-05-08 00:01:27.547131
4825	2026-02-03 12:00:00	1	21.4	220	3828.8	t	2026-05-08 00:01:27.547131
4826	2026-02-03 12:00:00	4	16.84	220	4475.4	t	2026-05-08 00:01:27.547131
4827	2026-02-03 12:00:00	7	27.36	220	5143.9	t	2026-05-08 00:01:27.547131
4828	2026-02-03 12:30:00	1	19.21	220	4217	t	2026-05-08 00:01:27.547131
4829	2026-02-03 12:30:00	4	24.19	220	4237.2	t	2026-05-08 00:01:27.547131
4830	2026-02-03 12:30:00	7	26.54	220	5218	t	2026-05-08 00:01:27.547131
4831	2026-02-03 13:00:00	1	20.06	220	3992.2	t	2026-05-08 00:01:27.547131
4832	2026-02-03 13:00:00	4	16.99	220	3790.9	t	2026-05-08 00:01:27.547131
4833	2026-02-03 13:00:00	7	26.05	220	4734.5	t	2026-05-08 00:01:27.547131
4834	2026-02-03 13:30:00	1	12.91	220	4173.5	t	2026-05-08 00:01:27.547131
4835	2026-02-03 13:30:00	4	25.4	220	5131.7	t	2026-05-08 00:01:27.547131
4836	2026-02-03 13:30:00	7	20.92	220	6263.9	t	2026-05-08 00:01:27.547131
4837	2026-02-03 14:00:00	1	18.13	220	4667.6	t	2026-05-08 00:01:27.547131
4838	2026-02-03 14:00:00	4	22.46	220	4918.4	t	2026-05-08 00:01:27.547131
4839	2026-02-03 14:00:00	7	27.99	220	5598.5	t	2026-05-08 00:01:27.547131
4840	2026-02-03 14:30:00	1	17.78	220	3901.6	t	2026-05-08 00:01:27.547131
4841	2026-02-03 14:30:00	4	16.13	220	3601.4	t	2026-05-08 00:01:27.547131
4842	2026-02-03 14:30:00	7	23.81	220	5036.1	t	2026-05-08 00:01:27.547131
4843	2026-02-03 15:00:00	1	16.21	220	3879	t	2026-05-08 00:01:27.547131
4844	2026-02-03 15:00:00	4	20.29	220	4721	t	2026-05-08 00:01:27.547131
4845	2026-02-03 15:00:00	7	27.99	220	5856.3	t	2026-05-08 00:01:27.547131
4846	2026-02-03 15:30:00	1	16.4	220	3312.5	t	2026-05-08 00:01:27.547131
4847	2026-02-03 15:30:00	4	23.22	220	4758.3	t	2026-05-08 00:01:27.547131
4848	2026-02-03 15:30:00	7	27.55	220	6700.9	t	2026-05-08 00:01:27.547131
4849	2026-02-03 16:00:00	1	15.89	220	3419.3	t	2026-05-08 00:01:27.547131
4850	2026-02-03 16:00:00	4	17.07	220	4875.4	t	2026-05-08 00:01:27.547131
4851	2026-02-03 16:00:00	7	29.76	220	5074.6	t	2026-05-08 00:01:27.547131
4852	2026-02-03 16:30:00	1	12.41	220	3644.4	t	2026-05-08 00:01:27.547131
4853	2026-02-03 16:30:00	4	17.5	220	4567.8	t	2026-05-08 00:01:27.547131
4854	2026-02-03 16:30:00	7	27	220	4959.3	t	2026-05-08 00:01:27.547131
4855	2026-02-03 17:00:00	1	15.08	220	2569.3	t	2026-05-08 00:01:27.547131
4856	2026-02-03 17:00:00	4	24.31	220	4690.3	t	2026-05-08 00:01:27.547131
4857	2026-02-03 17:00:00	7	30.48	220	5103.9	t	2026-05-08 00:01:27.547131
4858	2026-02-03 17:30:00	1	13.97	220	4663.4	t	2026-05-08 00:01:27.547131
4859	2026-02-03 17:30:00	4	16.09	220	5404.1	t	2026-05-08 00:01:27.547131
4860	2026-02-03 17:30:00	7	23.08	220	5815	t	2026-05-08 00:01:27.547131
4861	2026-02-03 18:00:00	1	18.68	220	3655	t	2026-05-08 00:01:27.547131
4862	2026-02-03 18:00:00	4	25.37	220	5140.9	t	2026-05-08 00:01:27.547131
4863	2026-02-03 18:00:00	7	21.32	220	6070.7	t	2026-05-08 00:01:27.547131
4864	2026-02-03 18:30:00	1	13.25	220	3706.8	t	2026-05-08 00:01:27.547131
4865	2026-02-03 18:30:00	4	25.28	220	3931.7	t	2026-05-08 00:01:27.547131
4866	2026-02-03 18:30:00	7	28.83	220	5308.8	t	2026-05-08 00:01:27.547131
4867	2026-02-03 19:00:00	1	11.68	220	4142.2	t	2026-05-08 00:01:27.547131
4868	2026-02-03 19:00:00	4	22.54	220	4601.5	t	2026-05-08 00:01:27.547131
4869	2026-02-03 19:00:00	7	29.99	220	5018.2	t	2026-05-08 00:01:27.547131
4870	2026-02-03 19:30:00	1	14.97	220	3865	t	2026-05-08 00:01:27.547131
4871	2026-02-03 19:30:00	4	17.42	220	4155.6	t	2026-05-08 00:01:27.547131
4872	2026-02-03 19:30:00	7	25.79	220	5691.1	t	2026-05-08 00:01:27.547131
4873	2026-02-03 20:00:00	1	3.16	220	774.8	t	2026-05-08 00:01:27.547131
4874	2026-02-03 20:00:00	4	3.22	220	570.5	t	2026-05-08 00:01:27.547131
4875	2026-02-03 20:00:00	7	1.55	220	301.7	t	2026-05-08 00:01:27.547131
4876	2026-02-03 20:30:00	1	2.72	220	537.3	t	2026-05-08 00:01:27.547131
4877	2026-02-03 20:30:00	4	1.72	220	306.4	t	2026-05-08 00:01:27.547131
4878	2026-02-03 20:30:00	7	2.59	220	360	t	2026-05-08 00:01:27.547131
4879	2026-02-03 21:00:00	1	3.26	220	654.9	t	2026-05-08 00:01:27.547131
4880	2026-02-03 21:00:00	4	1.55	220	714.2	t	2026-05-08 00:01:27.547131
4881	2026-02-03 21:00:00	7	2.4	220	309.1	t	2026-05-08 00:01:27.547131
4882	2026-02-03 21:30:00	1	3.09	220	805.4	t	2026-05-08 00:01:27.547131
4883	2026-02-03 21:30:00	4	1.49	220	593.3	t	2026-05-08 00:01:27.547131
4884	2026-02-03 21:30:00	7	1.93	220	701.4	t	2026-05-08 00:01:27.547131
4885	2026-02-03 22:00:00	1	1.98	220	677.7	t	2026-05-08 00:01:27.547131
4886	2026-02-03 22:00:00	4	3.52	220	774.1	t	2026-05-08 00:01:27.547131
4887	2026-02-03 22:00:00	7	3.21	220	761.6	t	2026-05-08 00:01:27.547131
4888	2026-02-03 22:30:00	1	1.61	220	266.3	t	2026-05-08 00:01:27.547131
4889	2026-02-03 22:30:00	4	3.53	220	578.7	t	2026-05-08 00:01:27.547131
4890	2026-02-03 22:30:00	7	2.91	220	619.1	t	2026-05-08 00:01:27.547131
4891	2026-02-03 23:00:00	1	3.05	220	525.7	t	2026-05-08 00:01:27.547131
4892	2026-02-03 23:00:00	4	2.07	220	271.7	t	2026-05-08 00:01:27.547131
4893	2026-02-03 23:00:00	7	3.45	220	750.8	t	2026-05-08 00:01:27.547131
4894	2026-02-03 23:30:00	1	1.76	220	474.9	t	2026-05-08 00:01:27.547131
4895	2026-02-03 23:30:00	4	2.02	220	476.1	t	2026-05-08 00:01:27.547131
4896	2026-02-03 23:30:00	7	2.7	220	571.3	t	2026-05-08 00:01:27.547131
4897	2026-02-04 00:00:00	1	1.42	220	749.8	t	2026-05-08 00:01:27.547131
4898	2026-02-04 00:00:00	4	3.58	220	794.1	t	2026-05-08 00:01:27.547131
4899	2026-02-04 00:00:00	7	1.97	220	295.7	t	2026-05-08 00:01:27.547131
4900	2026-02-04 00:30:00	1	2.38	220	615.7	t	2026-05-08 00:01:27.547131
4901	2026-02-04 00:30:00	4	2.62	220	753.4	t	2026-05-08 00:01:27.547131
4902	2026-02-04 00:30:00	7	3.12	220	555.7	t	2026-05-08 00:01:27.547131
4903	2026-02-04 01:00:00	1	1.56	220	552.8	t	2026-05-08 00:01:27.547131
4904	2026-02-04 01:00:00	4	2.25	220	318.6	t	2026-05-08 00:01:27.547131
4905	2026-02-04 01:00:00	7	3.35	220	696.1	t	2026-05-08 00:01:27.547131
4906	2026-02-04 01:30:00	1	3.66	220	788.4	t	2026-05-08 00:01:27.547131
4907	2026-02-04 01:30:00	4	1.28	220	632.6	t	2026-05-08 00:01:27.547131
4908	2026-02-04 01:30:00	7	2.34	220	454.7	t	2026-05-08 00:01:27.547131
4909	2026-02-04 02:00:00	1	2.24	220	586.3	t	2026-05-08 00:01:27.547131
4910	2026-02-04 02:00:00	4	1.4	220	638.8	t	2026-05-08 00:01:27.547131
4911	2026-02-04 02:00:00	7	2.67	220	802.8	t	2026-05-08 00:01:27.547131
4912	2026-02-04 02:30:00	1	1.71	220	614.3	t	2026-05-08 00:01:27.547131
4913	2026-02-04 02:30:00	4	2.17	220	386.5	t	2026-05-08 00:01:27.547131
4914	2026-02-04 02:30:00	7	2.03	220	449.3	t	2026-05-08 00:01:27.547131
4915	2026-02-04 03:00:00	1	2.83	220	445.3	t	2026-05-08 00:01:27.547131
4916	2026-02-04 03:00:00	4	3.24	220	362.5	t	2026-05-08 00:01:27.547131
4917	2026-02-04 03:00:00	7	2.13	220	638.9	t	2026-05-08 00:01:27.547131
4918	2026-02-04 03:30:00	1	2.45	220	570.9	t	2026-05-08 00:01:27.547131
4919	2026-02-04 03:30:00	4	1.92	220	378.2	t	2026-05-08 00:01:27.547131
4920	2026-02-04 03:30:00	7	3.17	220	781.2	t	2026-05-08 00:01:27.547131
4921	2026-02-04 04:00:00	1	3.64	220	410.8	t	2026-05-08 00:01:27.547131
4922	2026-02-04 04:00:00	4	2.35	220	757.9	t	2026-05-08 00:01:27.547131
4923	2026-02-04 04:00:00	7	1.46	220	583.5	t	2026-05-08 00:01:27.547131
4924	2026-02-04 04:30:00	1	1.84	220	701	t	2026-05-08 00:01:27.547131
4925	2026-02-04 04:30:00	4	2.84	220	419.3	t	2026-05-08 00:01:27.547131
4926	2026-02-04 04:30:00	7	1.62	220	634.5	t	2026-05-08 00:01:27.547131
4927	2026-02-04 05:00:00	1	1.5	220	536.2	t	2026-05-08 00:01:27.547131
4928	2026-02-04 05:00:00	4	2.89	220	686.8	t	2026-05-08 00:01:27.547131
4929	2026-02-04 05:00:00	7	2.38	220	719.9	t	2026-05-08 00:01:27.547131
4930	2026-02-04 05:30:00	1	3.66	220	325.3	t	2026-05-08 00:01:27.547131
4931	2026-02-04 05:30:00	4	1.95	220	751.7	t	2026-05-08 00:01:27.547131
4932	2026-02-04 05:30:00	7	3.31	220	422.6	t	2026-05-08 00:01:27.547131
4933	2026-02-04 06:00:00	1	1.88	220	450.9	t	2026-05-08 00:01:27.547131
4934	2026-02-04 06:00:00	4	1.86	220	705.8	t	2026-05-08 00:01:27.547131
4935	2026-02-04 06:00:00	7	2.35	220	469.3	t	2026-05-08 00:01:27.547131
4936	2026-02-04 06:30:00	1	2.25	220	662.7	t	2026-05-08 00:01:27.547131
4937	2026-02-04 06:30:00	4	1.34	220	734.9	t	2026-05-08 00:01:27.547131
4938	2026-02-04 06:30:00	7	1.48	220	458.6	t	2026-05-08 00:01:27.547131
4939	2026-02-04 07:00:00	1	20.44	220	3037	t	2026-05-08 00:01:27.547131
4940	2026-02-04 07:00:00	4	23.52	220	5040.1	t	2026-05-08 00:01:27.547131
4941	2026-02-04 07:00:00	7	25.1	220	5999.9	t	2026-05-08 00:01:27.547131
4942	2026-02-04 07:30:00	1	18.69	220	3793	t	2026-05-08 00:01:27.547131
4943	2026-02-04 07:30:00	4	16.56	220	4697.9	t	2026-05-08 00:01:27.547131
4944	2026-02-04 07:30:00	7	25.78	220	6259.5	t	2026-05-08 00:01:27.547131
4945	2026-02-04 08:00:00	1	21.48	220	2754.1	t	2026-05-08 00:01:27.547131
4946	2026-02-04 08:00:00	4	23.79	220	4394.5	t	2026-05-08 00:01:27.547131
4947	2026-02-04 08:00:00	7	24.63	220	5237.8	t	2026-05-08 00:01:27.547131
4948	2026-02-04 08:30:00	1	13.71	220	3019.6	t	2026-05-08 00:01:27.547131
4949	2026-02-04 08:30:00	4	18.82	220	3851.4	t	2026-05-08 00:01:27.547131
4950	2026-02-04 08:30:00	7	29.07	220	4750	t	2026-05-08 00:01:27.547131
4951	2026-02-04 09:00:00	1	15.23	220	3874.9	t	2026-05-08 00:01:27.547131
4952	2026-02-04 09:00:00	4	24.37	220	3626.1	t	2026-05-08 00:01:27.547131
4953	2026-02-04 09:00:00	7	25.16	220	6192.2	t	2026-05-08 00:01:27.547131
4954	2026-02-04 09:30:00	1	18.54	220	4285.9	t	2026-05-08 00:01:27.547131
4955	2026-02-04 09:30:00	4	20.09	220	4375.7	t	2026-05-08 00:01:27.547131
4956	2026-02-04 09:30:00	7	25.59	220	6617.6	t	2026-05-08 00:01:27.547131
4957	2026-02-04 10:00:00	1	20.21	220	2708.2	t	2026-05-08 00:01:27.547131
4958	2026-02-04 10:00:00	4	16.34	220	4925.9	t	2026-05-08 00:01:27.547131
4959	2026-02-04 10:00:00	7	21	220	4753.5	t	2026-05-08 00:01:27.547131
4960	2026-02-04 10:30:00	1	19.96	220	3395.7	t	2026-05-08 00:01:27.547131
4961	2026-02-04 10:30:00	4	22.32	220	4402.1	t	2026-05-08 00:01:27.547131
4962	2026-02-04 10:30:00	7	23.98	220	5526	t	2026-05-08 00:01:27.547131
4963	2026-02-04 11:00:00	1	13.86	220	2816.6	t	2026-05-08 00:01:27.547131
4964	2026-02-04 11:00:00	4	18.09	220	4741.2	t	2026-05-08 00:01:27.547131
4965	2026-02-04 11:00:00	7	22.03	220	6097.1	t	2026-05-08 00:01:27.547131
4966	2026-02-04 11:30:00	1	21.16	220	4436	t	2026-05-08 00:01:27.547131
4967	2026-02-04 11:30:00	4	19.98	220	3797.3	t	2026-05-08 00:01:27.547131
4968	2026-02-04 11:30:00	7	24.88	220	4836	t	2026-05-08 00:01:27.547131
4969	2026-02-04 12:00:00	1	19.01	220	2843.6	t	2026-05-08 00:01:27.547131
4970	2026-02-04 12:00:00	4	20.56	220	3575.5	t	2026-05-08 00:01:27.547131
4971	2026-02-04 12:00:00	7	24.84	220	5233.4	t	2026-05-08 00:01:27.547131
4972	2026-02-04 12:30:00	1	13.38	220	4521.3	t	2026-05-08 00:01:27.547131
4973	2026-02-04 12:30:00	4	22.9	220	4153.7	t	2026-05-08 00:01:27.547131
4974	2026-02-04 12:30:00	7	28.75	220	4560.2	t	2026-05-08 00:01:27.547131
4975	2026-02-04 13:00:00	1	20.25	220	2909.7	t	2026-05-08 00:01:27.547131
4976	2026-02-04 13:00:00	4	21.84	220	5461.9	t	2026-05-08 00:01:27.547131
4977	2026-02-04 13:00:00	7	21.13	220	6116.4	t	2026-05-08 00:01:27.547131
4978	2026-02-04 13:30:00	1	13.38	220	4617.9	t	2026-05-08 00:01:27.547131
4979	2026-02-04 13:30:00	4	17.62	220	5453	t	2026-05-08 00:01:27.547131
4980	2026-02-04 13:30:00	7	28.8	220	5582.8	t	2026-05-08 00:01:27.547131
4981	2026-02-04 14:00:00	1	13.38	220	2621.9	t	2026-05-08 00:01:27.547131
4982	2026-02-04 14:00:00	4	23.69	220	5460.1	t	2026-05-08 00:01:27.547131
4983	2026-02-04 14:00:00	7	25.03	220	5513.3	t	2026-05-08 00:01:27.547131
4984	2026-02-04 14:30:00	1	14.69	220	4283.2	t	2026-05-08 00:01:27.547131
4985	2026-02-04 14:30:00	4	24.41	220	4851.7	t	2026-05-08 00:01:27.547131
4986	2026-02-04 14:30:00	7	29.65	220	6705	t	2026-05-08 00:01:27.547131
4987	2026-02-04 15:00:00	1	14.03	220	3801.6	t	2026-05-08 00:01:27.547131
4988	2026-02-04 15:00:00	4	20.9	220	3574.6	t	2026-05-08 00:01:27.547131
4989	2026-02-04 15:00:00	7	24.92	220	6013.9	t	2026-05-08 00:01:27.547131
4990	2026-02-04 15:30:00	1	21.46	220	3507.3	t	2026-05-08 00:01:27.547131
4991	2026-02-04 15:30:00	4	20.77	220	5614.4	t	2026-05-08 00:01:27.547131
4992	2026-02-04 15:30:00	7	25.41	220	6249.8	t	2026-05-08 00:01:27.547131
4993	2026-02-04 16:00:00	1	15.95	220	2540.3	t	2026-05-08 00:01:27.547131
4994	2026-02-04 16:00:00	4	20.32	220	4491	t	2026-05-08 00:01:27.547131
4995	2026-02-04 16:00:00	7	24.52	220	4978.6	t	2026-05-08 00:01:27.547131
4996	2026-02-04 16:30:00	1	15.65	220	3344.9	t	2026-05-08 00:01:27.547131
4997	2026-02-04 16:30:00	4	18.49	220	4940.9	t	2026-05-08 00:01:27.547131
4998	2026-02-04 16:30:00	7	25.11	220	5250.9	t	2026-05-08 00:01:27.547131
4999	2026-02-04 17:00:00	1	20.62	220	4074	t	2026-05-08 00:01:27.547131
5000	2026-02-04 17:00:00	4	17.33	220	5668.3	t	2026-05-08 00:01:27.547131
5001	2026-02-04 17:00:00	7	20.55	220	6322.6	t	2026-05-08 00:01:27.547131
5002	2026-02-04 17:30:00	1	20.55	220	3053.3	t	2026-05-08 00:01:27.547131
5003	2026-02-04 17:30:00	4	18.99	220	4820.5	t	2026-05-08 00:01:27.547131
5004	2026-02-04 17:30:00	7	24.76	220	5290.1	t	2026-05-08 00:01:27.547131
5005	2026-02-04 18:00:00	1	12.12	220	3017.3	t	2026-05-08 00:01:27.547131
5006	2026-02-04 18:00:00	4	21.71	220	4375.2	t	2026-05-08 00:01:27.547131
5007	2026-02-04 18:00:00	7	28.5	220	6000.3	t	2026-05-08 00:01:27.547131
5008	2026-02-04 18:30:00	1	20.27	220	4495.3	t	2026-05-08 00:01:27.547131
5009	2026-02-04 18:30:00	4	18.76	220	5284.4	t	2026-05-08 00:01:27.547131
5010	2026-02-04 18:30:00	7	21.02	220	5895.4	t	2026-05-08 00:01:27.547131
5011	2026-02-04 19:00:00	1	14.18	220	3317	t	2026-05-08 00:01:27.547131
5012	2026-02-04 19:00:00	4	17.99	220	3643.6	t	2026-05-08 00:01:27.547131
5013	2026-02-04 19:00:00	7	26.3	220	5404.6	t	2026-05-08 00:01:27.547131
5014	2026-02-04 19:30:00	1	18.05	220	3802.1	t	2026-05-08 00:01:27.547131
5015	2026-02-04 19:30:00	4	17.3	220	4670.5	t	2026-05-08 00:01:27.547131
5016	2026-02-04 19:30:00	7	29.61	220	4866.4	t	2026-05-08 00:01:27.547131
5017	2026-02-04 20:00:00	1	1.52	220	662.4	t	2026-05-08 00:01:27.547131
5018	2026-02-04 20:00:00	4	3.46	220	362.5	t	2026-05-08 00:01:27.547131
5019	2026-02-04 20:00:00	7	3	220	587.4	t	2026-05-08 00:01:27.547131
5020	2026-02-04 20:30:00	1	3.33	220	557.9	t	2026-05-08 00:01:27.547131
5021	2026-02-04 20:30:00	4	1.49	220	415.6	t	2026-05-08 00:01:27.547131
5022	2026-02-04 20:30:00	7	2.56	220	760.2	t	2026-05-08 00:01:27.547131
5023	2026-02-04 21:00:00	1	1.35	220	712.1	t	2026-05-08 00:01:27.547131
5024	2026-02-04 21:00:00	4	1.71	220	792.2	t	2026-05-08 00:01:27.547131
5025	2026-02-04 21:00:00	7	3.02	220	380	t	2026-05-08 00:01:27.547131
5026	2026-02-04 21:30:00	1	1.47	220	517.7	t	2026-05-08 00:01:27.547131
5027	2026-02-04 21:30:00	4	2.11	220	546.9	t	2026-05-08 00:01:27.547131
5028	2026-02-04 21:30:00	7	2.02	220	509.1	t	2026-05-08 00:01:27.547131
5029	2026-02-04 22:00:00	1	1.51	220	488	t	2026-05-08 00:01:27.547131
5030	2026-02-04 22:00:00	4	2.2	220	734.1	t	2026-05-08 00:01:27.547131
5031	2026-02-04 22:00:00	7	1.73	220	765	t	2026-05-08 00:01:27.547131
5032	2026-02-04 22:30:00	1	1.21	220	326.3	t	2026-05-08 00:01:27.547131
5033	2026-02-04 22:30:00	4	2.04	220	490.5	t	2026-05-08 00:01:27.547131
5034	2026-02-04 22:30:00	7	2.65	220	739	t	2026-05-08 00:01:27.547131
5035	2026-02-04 23:00:00	1	2.05	220	381.5	t	2026-05-08 00:01:27.547131
5036	2026-02-04 23:00:00	4	2.04	220	334.2	t	2026-05-08 00:01:27.547131
5037	2026-02-04 23:00:00	7	2.92	220	440.1	t	2026-05-08 00:01:27.547131
5038	2026-02-04 23:30:00	1	2.58	220	379.9	t	2026-05-08 00:01:27.547131
5039	2026-02-04 23:30:00	4	3.56	220	755.3	t	2026-05-08 00:01:27.547131
5040	2026-02-04 23:30:00	7	3.23	220	665.5	t	2026-05-08 00:01:27.547131
5041	2026-02-05 00:00:00	1	3.03	220	456.3	t	2026-05-08 00:01:27.547131
5042	2026-02-05 00:00:00	4	2.83	220	735	t	2026-05-08 00:01:27.547131
5043	2026-02-05 00:00:00	7	1.87	220	284.5	t	2026-05-08 00:01:27.547131
5044	2026-02-05 00:30:00	1	3.19	220	386.7	t	2026-05-08 00:01:27.547131
5045	2026-02-05 00:30:00	4	1.45	220	322.2	t	2026-05-08 00:01:27.547131
5046	2026-02-05 00:30:00	7	2.1	220	754.8	t	2026-05-08 00:01:27.547131
5047	2026-02-05 01:00:00	1	2.77	220	693.8	t	2026-05-08 00:01:27.547131
5048	2026-02-05 01:00:00	4	3	220	522.1	t	2026-05-08 00:01:27.547131
5049	2026-02-05 01:00:00	7	3.14	220	366	t	2026-05-08 00:01:27.547131
5050	2026-02-05 01:30:00	1	1.9	220	591	t	2026-05-08 00:01:27.547131
5051	2026-02-05 01:30:00	4	3.43	220	357	t	2026-05-08 00:01:27.547131
5052	2026-02-05 01:30:00	7	2.93	220	473.1	t	2026-05-08 00:01:27.547131
5053	2026-02-05 02:00:00	1	2.56	220	284.1	t	2026-05-08 00:01:27.547131
5054	2026-02-05 02:00:00	4	3.24	220	472.3	t	2026-05-08 00:01:27.547131
5055	2026-02-05 02:00:00	7	1.39	220	365	t	2026-05-08 00:01:27.547131
5056	2026-02-05 02:30:00	1	2.73	220	657.9	t	2026-05-08 00:01:27.547131
5057	2026-02-05 02:30:00	4	2.55	220	532.1	t	2026-05-08 00:01:27.547131
5058	2026-02-05 02:30:00	7	2.8	220	791.9	t	2026-05-08 00:01:27.547131
5059	2026-02-05 03:00:00	1	2.27	220	766.1	t	2026-05-08 00:01:27.547131
5060	2026-02-05 03:00:00	4	2.16	220	542.3	t	2026-05-08 00:01:27.547131
5061	2026-02-05 03:00:00	7	2.27	220	389	t	2026-05-08 00:01:27.547131
5062	2026-02-05 03:30:00	1	3	220	554	t	2026-05-08 00:01:27.547131
5063	2026-02-05 03:30:00	4	1.51	220	272	t	2026-05-08 00:01:27.547131
5064	2026-02-05 03:30:00	7	3	220	478	t	2026-05-08 00:01:27.547131
5065	2026-02-05 04:00:00	1	1.54	220	739.5	t	2026-05-08 00:01:27.547131
5066	2026-02-05 04:00:00	4	3.08	220	665.8	t	2026-05-08 00:01:27.547131
5067	2026-02-05 04:00:00	7	3.18	220	636.3	t	2026-05-08 00:01:27.547131
5068	2026-02-05 04:30:00	1	3.13	220	317.3	t	2026-05-08 00:01:27.547131
5069	2026-02-05 04:30:00	4	2.46	220	477.3	t	2026-05-08 00:01:27.547131
5070	2026-02-05 04:30:00	7	1.48	220	763.7	t	2026-05-08 00:01:27.547131
5071	2026-02-05 05:00:00	1	3.31	220	596.6	t	2026-05-08 00:01:27.547131
5072	2026-02-05 05:00:00	4	1.29	220	558.8	t	2026-05-08 00:01:27.547131
5073	2026-02-05 05:00:00	7	2.59	220	772.8	t	2026-05-08 00:01:27.547131
5074	2026-02-05 05:30:00	1	2.18	220	268	t	2026-05-08 00:01:27.547131
5075	2026-02-05 05:30:00	4	1.37	220	593.9	t	2026-05-08 00:01:27.547131
5076	2026-02-05 05:30:00	7	3.3	220	672.8	t	2026-05-08 00:01:27.547131
5077	2026-02-05 06:00:00	1	1.56	220	484.6	t	2026-05-08 00:01:27.547131
5078	2026-02-05 06:00:00	4	2.39	220	709.4	t	2026-05-08 00:01:27.547131
5079	2026-02-05 06:00:00	7	2.58	220	769.1	t	2026-05-08 00:01:27.547131
5080	2026-02-05 06:30:00	1	1.71	220	494.8	t	2026-05-08 00:01:27.547131
5081	2026-02-05 06:30:00	4	2.17	220	788.3	t	2026-05-08 00:01:27.547131
5082	2026-02-05 06:30:00	7	2.95	220	561	t	2026-05-08 00:01:27.547131
5083	2026-02-05 07:00:00	1	21.09	220	3373.6	t	2026-05-08 00:01:27.547131
5084	2026-02-05 07:00:00	4	16.86	220	3832.2	t	2026-05-08 00:01:27.547131
5085	2026-02-05 07:00:00	7	24.5	220	6077	t	2026-05-08 00:01:27.547131
5086	2026-02-05 07:30:00	1	15.58	220	4518.1	t	2026-05-08 00:01:27.547131
5087	2026-02-05 07:30:00	4	20.81	220	4206.7	t	2026-05-08 00:01:27.547131
5088	2026-02-05 07:30:00	7	23.4	220	6445.1	t	2026-05-08 00:01:27.547131
5089	2026-02-05 08:00:00	1	18.37	220	4176.4	t	2026-05-08 00:01:27.547131
5090	2026-02-05 08:00:00	4	18.5	220	5708.8	t	2026-05-08 00:01:27.547131
5091	2026-02-05 08:00:00	7	26.32	220	6143.4	t	2026-05-08 00:01:27.547131
5092	2026-02-05 08:30:00	1	17.09	220	4016.1	t	2026-05-08 00:01:27.547131
5093	2026-02-05 08:30:00	4	17.2	220	5336.2	t	2026-05-08 00:01:27.547131
5094	2026-02-05 08:30:00	7	26.91	220	5205.4	t	2026-05-08 00:01:27.547131
5095	2026-02-05 09:00:00	1	21.31	220	4641	t	2026-05-08 00:01:27.547131
5096	2026-02-05 09:00:00	4	17.97	220	4802.3	t	2026-05-08 00:01:27.547131
5097	2026-02-05 09:00:00	7	30.35	220	5880.4	t	2026-05-08 00:01:27.547131
5098	2026-02-05 09:30:00	1	19.72	220	3674.2	t	2026-05-08 00:01:27.547131
5099	2026-02-05 09:30:00	4	20.91	220	5051.7	t	2026-05-08 00:01:27.547131
5100	2026-02-05 09:30:00	7	21.68	220	6255	t	2026-05-08 00:01:27.547131
5101	2026-02-05 10:00:00	1	17.43	220	3902.2	t	2026-05-08 00:01:27.547131
5102	2026-02-05 10:00:00	4	25.19	220	5050.8	t	2026-05-08 00:01:27.547131
5103	2026-02-05 10:00:00	7	25.36	220	5607.3	t	2026-05-08 00:01:27.547131
5104	2026-02-05 10:30:00	1	19.84	220	4399.4	t	2026-05-08 00:01:27.547131
5105	2026-02-05 10:30:00	4	20.04	220	4848	t	2026-05-08 00:01:27.547131
5106	2026-02-05 10:30:00	7	21.47	220	6088.9	t	2026-05-08 00:01:27.547131
5107	2026-02-05 11:00:00	1	16.38	220	3311.4	t	2026-05-08 00:01:27.547131
5108	2026-02-05 11:00:00	4	21.87	220	3736.1	t	2026-05-08 00:01:27.547131
5109	2026-02-05 11:00:00	7	30.4	220	6081.4	t	2026-05-08 00:01:27.547131
5110	2026-02-05 11:30:00	1	21.01	220	3027	t	2026-05-08 00:01:27.547131
5111	2026-02-05 11:30:00	4	17.38	220	5562.7	t	2026-05-08 00:01:27.547131
5112	2026-02-05 11:30:00	7	25.56	220	5749.5	t	2026-05-08 00:01:27.547131
5113	2026-02-05 12:00:00	1	16.1	220	4620.9	t	2026-05-08 00:01:27.547131
5114	2026-02-05 12:00:00	4	24.79	220	4611.6	t	2026-05-08 00:01:27.547131
5115	2026-02-05 12:00:00	7	22.77	220	6051.3	t	2026-05-08 00:01:27.547131
5116	2026-02-05 12:30:00	1	17.81	220	2996.2	t	2026-05-08 00:01:27.547131
5117	2026-02-05 12:30:00	4	20.25	220	5428	t	2026-05-08 00:01:27.547131
5118	2026-02-05 12:30:00	7	24.32	220	5383.8	t	2026-05-08 00:01:27.547131
5119	2026-02-05 13:00:00	1	14.62	220	3644.6	t	2026-05-08 00:01:27.547131
5120	2026-02-05 13:00:00	4	18.75	220	3592.2	t	2026-05-08 00:01:27.547131
5121	2026-02-05 13:00:00	7	28.89	220	6618.8	t	2026-05-08 00:01:27.547131
5122	2026-02-05 13:30:00	1	16.09	220	3925.4	t	2026-05-08 00:01:27.547131
5123	2026-02-05 13:30:00	4	16.52	220	5664	t	2026-05-08 00:01:27.547131
5124	2026-02-05 13:30:00	7	21.53	220	6211.5	t	2026-05-08 00:01:27.547131
5125	2026-02-05 14:00:00	1	16.86	220	3392.5	t	2026-05-08 00:01:27.547131
5126	2026-02-05 14:00:00	4	22.69	220	4706.2	t	2026-05-08 00:01:27.547131
5127	2026-02-05 14:00:00	7	28.05	220	6638	t	2026-05-08 00:01:27.547131
5128	2026-02-05 14:30:00	1	15.71	220	3625.9	t	2026-05-08 00:01:27.547131
5129	2026-02-05 14:30:00	4	25.05	220	5376.7	t	2026-05-08 00:01:27.547131
5130	2026-02-05 14:30:00	7	27.64	220	6593.2	t	2026-05-08 00:01:27.547131
5131	2026-02-05 15:00:00	1	16.68	220	2592.7	t	2026-05-08 00:01:27.547131
5132	2026-02-05 15:00:00	4	16.11	220	4103	t	2026-05-08 00:01:27.547131
5133	2026-02-05 15:00:00	7	27.71	220	5670.9	t	2026-05-08 00:01:27.547131
5134	2026-02-05 15:30:00	1	14.8	220	3436	t	2026-05-08 00:01:27.547131
5135	2026-02-05 15:30:00	4	18.53	220	4900.5	t	2026-05-08 00:01:27.547131
5136	2026-02-05 15:30:00	7	22.08	220	5259.1	t	2026-05-08 00:01:27.547131
5137	2026-02-05 16:00:00	1	18.25	220	3639.8	t	2026-05-08 00:01:27.547131
5138	2026-02-05 16:00:00	4	18.73	220	4406.6	t	2026-05-08 00:01:27.547131
5139	2026-02-05 16:00:00	7	26.16	220	5917	t	2026-05-08 00:01:27.547131
5140	2026-02-05 16:30:00	1	20.3	220	4506	t	2026-05-08 00:01:27.547131
5141	2026-02-05 16:30:00	4	19.65	220	5103.5	t	2026-05-08 00:01:27.547131
5142	2026-02-05 16:30:00	7	29.67	220	5710.5	t	2026-05-08 00:01:27.547131
5143	2026-02-05 17:00:00	1	16.81	220	2703.8	t	2026-05-08 00:01:27.547131
5144	2026-02-05 17:00:00	4	21.57	220	4487.4	t	2026-05-08 00:01:27.547131
5145	2026-02-05 17:00:00	7	22.37	220	5547.8	t	2026-05-08 00:01:27.547131
5146	2026-02-05 17:30:00	1	17.61	220	3146.2	t	2026-05-08 00:01:27.547131
5147	2026-02-05 17:30:00	4	24.42	220	5359.9	t	2026-05-08 00:01:27.547131
5148	2026-02-05 17:30:00	7	24.08	220	6456.9	t	2026-05-08 00:01:27.547131
5149	2026-02-05 18:00:00	1	20.72	220	4687.6	t	2026-05-08 00:01:27.547131
5150	2026-02-05 18:00:00	4	23.03	220	4576.8	t	2026-05-08 00:01:27.547131
5151	2026-02-05 18:00:00	7	21.59	220	6526.7	t	2026-05-08 00:01:27.547131
5152	2026-02-05 18:30:00	1	18.91	220	3421	t	2026-05-08 00:01:27.547131
5153	2026-02-05 18:30:00	4	20.95	220	3983.6	t	2026-05-08 00:01:27.547131
5154	2026-02-05 18:30:00	7	24.56	220	4554.2	t	2026-05-08 00:01:27.547131
5155	2026-02-05 19:00:00	1	20.08	220	3265.2	t	2026-05-08 00:01:27.547131
5156	2026-02-05 19:00:00	4	17.19	220	3988	t	2026-05-08 00:01:27.547131
5157	2026-02-05 19:00:00	7	27.33	220	6572.3	t	2026-05-08 00:01:27.547131
5158	2026-02-05 19:30:00	1	19.69	220	2790.7	t	2026-05-08 00:01:27.547131
5159	2026-02-05 19:30:00	4	20.91	220	3607.6	t	2026-05-08 00:01:27.547131
5160	2026-02-05 19:30:00	7	25.74	220	6573.6	t	2026-05-08 00:01:27.547131
5161	2026-02-05 20:00:00	1	1.49	220	801.6	t	2026-05-08 00:01:27.547131
5162	2026-02-05 20:00:00	4	2.94	220	640.7	t	2026-05-08 00:01:27.547131
5163	2026-02-05 20:00:00	7	2.4	220	649.9	t	2026-05-08 00:01:27.547131
5164	2026-02-05 20:30:00	1	1.82	220	806.9	t	2026-05-08 00:01:27.547131
5165	2026-02-05 20:30:00	4	2.19	220	584.6	t	2026-05-08 00:01:27.547131
5166	2026-02-05 20:30:00	7	2.51	220	700.6	t	2026-05-08 00:01:27.547131
5167	2026-02-05 21:00:00	1	3.67	220	728.4	t	2026-05-08 00:01:27.547131
5168	2026-02-05 21:00:00	4	3.32	220	623.7	t	2026-05-08 00:01:27.547131
5169	2026-02-05 21:00:00	7	3.48	220	425.3	t	2026-05-08 00:01:27.547131
5170	2026-02-05 21:30:00	1	3.39	220	476.4	t	2026-05-08 00:01:27.547131
5171	2026-02-05 21:30:00	4	1.99	220	522.1	t	2026-05-08 00:01:27.547131
5172	2026-02-05 21:30:00	7	1.83	220	270.9	t	2026-05-08 00:01:27.547131
5173	2026-02-05 22:00:00	1	1.28	220	623.2	t	2026-05-08 00:01:27.547131
5174	2026-02-05 22:00:00	4	2.62	220	783.2	t	2026-05-08 00:01:27.547131
5175	2026-02-05 22:00:00	7	2.11	220	598.3	t	2026-05-08 00:01:27.547131
5176	2026-02-05 22:30:00	1	3.34	220	627.6	t	2026-05-08 00:01:27.547131
5177	2026-02-05 22:30:00	4	1.41	220	752.6	t	2026-05-08 00:01:27.547131
5178	2026-02-05 22:30:00	7	3.39	220	782.8	t	2026-05-08 00:01:27.547131
5179	2026-02-05 23:00:00	1	1.2	220	570.3	t	2026-05-08 00:01:27.547131
5180	2026-02-05 23:00:00	4	2.95	220	660.1	t	2026-05-08 00:01:27.547131
5181	2026-02-05 23:00:00	7	1.47	220	540.2	t	2026-05-08 00:01:27.547131
5182	2026-02-05 23:30:00	1	2.58	220	643.5	t	2026-05-08 00:01:27.547131
5183	2026-02-05 23:30:00	4	2.01	220	283.7	t	2026-05-08 00:01:27.547131
5184	2026-02-05 23:30:00	7	2.99	220	618.8	t	2026-05-08 00:01:27.547131
5185	2026-02-06 00:00:00	1	2.01	220	459	t	2026-05-08 00:01:27.547131
5186	2026-02-06 00:00:00	4	1.68	220	360.8	t	2026-05-08 00:01:27.547131
5187	2026-02-06 00:00:00	7	2.34	220	363.3	t	2026-05-08 00:01:27.547131
5188	2026-02-06 00:30:00	1	2.88	220	289.1	t	2026-05-08 00:01:27.547131
5189	2026-02-06 00:30:00	4	2.36	220	299.7	t	2026-05-08 00:01:27.547131
5190	2026-02-06 00:30:00	7	2.74	220	632.5	t	2026-05-08 00:01:27.547131
5191	2026-02-06 01:00:00	1	2.43	220	343.3	t	2026-05-08 00:01:27.547131
5192	2026-02-06 01:00:00	4	2.47	220	587.6	t	2026-05-08 00:01:27.547131
5193	2026-02-06 01:00:00	7	1.66	220	765.3	t	2026-05-08 00:01:27.547131
5194	2026-02-06 01:30:00	1	2.97	220	806.3	t	2026-05-08 00:01:27.547131
5195	2026-02-06 01:30:00	4	3.36	220	376.9	t	2026-05-08 00:01:27.547131
5196	2026-02-06 01:30:00	7	2.93	220	668.9	t	2026-05-08 00:01:27.547131
5197	2026-02-06 02:00:00	1	1.78	220	604.1	t	2026-05-08 00:01:27.547131
5198	2026-02-06 02:00:00	4	1.52	220	610.1	t	2026-05-08 00:01:27.547131
5199	2026-02-06 02:00:00	7	1.81	220	768.5	t	2026-05-08 00:01:27.547131
5200	2026-02-06 02:30:00	1	3.5	220	592.1	t	2026-05-08 00:01:27.547131
5201	2026-02-06 02:30:00	4	3.16	220	686.4	t	2026-05-08 00:01:27.547131
5202	2026-02-06 02:30:00	7	1.84	220	710.2	t	2026-05-08 00:01:27.547131
5203	2026-02-06 03:00:00	1	1.55	220	265	t	2026-05-08 00:01:27.547131
5204	2026-02-06 03:00:00	4	2.83	220	813.4	t	2026-05-08 00:01:27.547131
5205	2026-02-06 03:00:00	7	1.77	220	408.5	t	2026-05-08 00:01:27.547131
5206	2026-02-06 03:30:00	1	3.37	220	312.2	t	2026-05-08 00:01:27.547131
5207	2026-02-06 03:30:00	4	2.32	220	519.5	t	2026-05-08 00:01:27.547131
5208	2026-02-06 03:30:00	7	2.87	220	644.7	t	2026-05-08 00:01:27.547131
5209	2026-02-06 04:00:00	1	2.28	220	657.7	t	2026-05-08 00:01:27.547131
5210	2026-02-06 04:00:00	4	2.59	220	754.1	t	2026-05-08 00:01:27.547131
5211	2026-02-06 04:00:00	7	2.87	220	389.3	t	2026-05-08 00:01:27.547131
5212	2026-02-06 04:30:00	1	3.06	220	571.9	t	2026-05-08 00:01:27.547131
5213	2026-02-06 04:30:00	4	3.44	220	602.2	t	2026-05-08 00:01:27.547131
5214	2026-02-06 04:30:00	7	1.75	220	675.5	t	2026-05-08 00:01:27.547131
5215	2026-02-06 05:00:00	1	2.39	220	680.7	t	2026-05-08 00:01:27.547131
5216	2026-02-06 05:00:00	4	1.85	220	580.4	t	2026-05-08 00:01:27.547131
5217	2026-02-06 05:00:00	7	1.79	220	538.6	t	2026-05-08 00:01:27.547131
5218	2026-02-06 05:30:00	1	1.9	220	799.3	t	2026-05-08 00:01:27.547131
5219	2026-02-06 05:30:00	4	2.28	220	563.4	t	2026-05-08 00:01:27.547131
5220	2026-02-06 05:30:00	7	2.67	220	770.8	t	2026-05-08 00:01:27.547131
5221	2026-02-06 06:00:00	1	3.48	220	696.2	t	2026-05-08 00:01:27.547131
5222	2026-02-06 06:00:00	4	2.77	220	368.6	t	2026-05-08 00:01:27.547131
5223	2026-02-06 06:00:00	7	1.75	220	705.6	t	2026-05-08 00:01:27.547131
5224	2026-02-06 06:30:00	1	3.24	220	792.4	t	2026-05-08 00:01:27.547131
5225	2026-02-06 06:30:00	4	1.89	220	308.9	t	2026-05-08 00:01:27.547131
5226	2026-02-06 06:30:00	7	3.22	220	417	t	2026-05-08 00:01:27.547131
5227	2026-02-06 07:00:00	1	19.28	220	2671.9	t	2026-05-08 00:01:27.547131
5228	2026-02-06 07:00:00	4	25.98	220	4397.5	t	2026-05-08 00:01:27.547131
5229	2026-02-06 07:00:00	7	23.35	220	4943.4	t	2026-05-08 00:01:27.547131
5230	2026-02-06 07:30:00	1	17.98	220	3652.8	t	2026-05-08 00:01:27.547131
5231	2026-02-06 07:30:00	4	18.88	220	4425.5	t	2026-05-08 00:01:27.547131
5232	2026-02-06 07:30:00	7	29.78	220	4934.3	t	2026-05-08 00:01:27.547131
5233	2026-02-06 08:00:00	1	16.81	220	3653.5	t	2026-05-08 00:01:27.547131
5234	2026-02-06 08:00:00	4	25.28	220	4005.2	t	2026-05-08 00:01:27.547131
5235	2026-02-06 08:00:00	7	22.38	220	5114.4	t	2026-05-08 00:01:27.547131
5236	2026-02-06 08:30:00	1	14.07	220	2869.6	t	2026-05-08 00:01:27.547131
5237	2026-02-06 08:30:00	4	18.25	220	5269.2	t	2026-05-08 00:01:27.547131
5238	2026-02-06 08:30:00	7	28.24	220	6129.7	t	2026-05-08 00:01:27.547131
5239	2026-02-06 09:00:00	1	19.57	220	3815.1	t	2026-05-08 00:01:27.547131
5240	2026-02-06 09:00:00	4	16.38	220	3621	t	2026-05-08 00:01:27.547131
5241	2026-02-06 09:00:00	7	24.66	220	6240.4	t	2026-05-08 00:01:27.547131
5242	2026-02-06 09:30:00	1	13.8	220	4063.5	t	2026-05-08 00:01:27.547131
5243	2026-02-06 09:30:00	4	17.12	220	5616.5	t	2026-05-08 00:01:27.547131
5244	2026-02-06 09:30:00	7	25.54	220	5620.6	t	2026-05-08 00:01:27.547131
5245	2026-02-06 10:00:00	1	17.64	220	4077.6	t	2026-05-08 00:01:27.547131
5246	2026-02-06 10:00:00	4	18.78	220	4198.3	t	2026-05-08 00:01:27.547131
5247	2026-02-06 10:00:00	7	24.29	220	5051.6	t	2026-05-08 00:01:27.547131
5248	2026-02-06 10:30:00	1	11.72	220	4020.5	t	2026-05-08 00:01:27.547131
5249	2026-02-06 10:30:00	4	17.4	220	3929	t	2026-05-08 00:01:27.547131
5250	2026-02-06 10:30:00	7	29.73	220	4715.9	t	2026-05-08 00:01:27.547131
5251	2026-02-06 11:00:00	1	15.38	220	2988.3	t	2026-05-08 00:01:27.547131
5252	2026-02-06 11:00:00	4	22.73	220	4407	t	2026-05-08 00:01:27.547131
5253	2026-02-06 11:00:00	7	23.77	220	5246.2	t	2026-05-08 00:01:27.547131
5254	2026-02-06 11:30:00	1	13.62	220	3812.7	t	2026-05-08 00:01:27.547131
5255	2026-02-06 11:30:00	4	25.68	220	5220.6	t	2026-05-08 00:01:27.547131
5256	2026-02-06 11:30:00	7	27.26	220	6413.3	t	2026-05-08 00:01:27.547131
5257	2026-02-06 12:00:00	1	15.3	220	4679.6	t	2026-05-08 00:01:27.547131
5258	2026-02-06 12:00:00	4	24.57	220	4426.5	t	2026-05-08 00:01:27.547131
5259	2026-02-06 12:00:00	7	22.6	220	6467.2	t	2026-05-08 00:01:27.547131
5260	2026-02-06 12:30:00	1	20.83	220	3104.5	t	2026-05-08 00:01:27.547131
5261	2026-02-06 12:30:00	4	21.25	220	4337.5	t	2026-05-08 00:01:27.547131
5262	2026-02-06 12:30:00	7	30.19	220	5429.8	t	2026-05-08 00:01:27.547131
5263	2026-02-06 13:00:00	1	14.87	220	4662.6	t	2026-05-08 00:01:27.547131
5264	2026-02-06 13:00:00	4	23.92	220	5374.9	t	2026-05-08 00:01:27.547131
5265	2026-02-06 13:00:00	7	24.9	220	6208.5	t	2026-05-08 00:01:27.547131
5266	2026-02-06 13:30:00	1	14.05	220	3895.2	t	2026-05-08 00:01:27.547131
5267	2026-02-06 13:30:00	4	23	220	3689.5	t	2026-05-08 00:01:27.547131
5268	2026-02-06 13:30:00	7	26.32	220	5226.7	t	2026-05-08 00:01:27.547131
5269	2026-02-06 14:00:00	1	15.83	220	3616.5	t	2026-05-08 00:01:27.547131
5270	2026-02-06 14:00:00	4	23.96	220	4939.7	t	2026-05-08 00:01:27.547131
5271	2026-02-06 14:00:00	7	30.21	220	5750.8	t	2026-05-08 00:01:27.547131
5272	2026-02-06 14:30:00	1	17.42	220	4075.6	t	2026-05-08 00:01:27.547131
5273	2026-02-06 14:30:00	4	16.58	220	3977	t	2026-05-08 00:01:27.547131
5274	2026-02-06 14:30:00	7	24.69	220	5900.6	t	2026-05-08 00:01:27.547131
5275	2026-02-06 15:00:00	1	21.36	220	4219.4	t	2026-05-08 00:01:27.547131
5276	2026-02-06 15:00:00	4	17.39	220	4860.6	t	2026-05-08 00:01:27.547131
5277	2026-02-06 15:00:00	7	28.98	220	6271.8	t	2026-05-08 00:01:27.547131
5278	2026-02-06 15:30:00	1	14	220	4505	t	2026-05-08 00:01:27.547131
5279	2026-02-06 15:30:00	4	16.66	220	3791.4	t	2026-05-08 00:01:27.547131
5280	2026-02-06 15:30:00	7	29.37	220	5124.3	t	2026-05-08 00:01:27.547131
5281	2026-02-06 16:00:00	1	14.12	220	3316.4	t	2026-05-08 00:01:27.547131
5282	2026-02-06 16:00:00	4	25.82	220	3917.4	t	2026-05-08 00:01:27.547131
5283	2026-02-06 16:00:00	7	28.44	220	6268.5	t	2026-05-08 00:01:27.547131
5284	2026-02-06 16:30:00	1	13.04	220	2808.2	t	2026-05-08 00:01:27.547131
5285	2026-02-06 16:30:00	4	25.25	220	3553.7	t	2026-05-08 00:01:27.547131
5286	2026-02-06 16:30:00	7	21.94	220	5788.4	t	2026-05-08 00:01:27.547131
5287	2026-02-06 17:00:00	1	18.29	220	3505.7	t	2026-05-08 00:01:27.547131
5288	2026-02-06 17:00:00	4	16.68	220	3558.6	t	2026-05-08 00:01:27.547131
5289	2026-02-06 17:00:00	7	30.29	220	4688.7	t	2026-05-08 00:01:27.547131
5290	2026-02-06 17:30:00	1	20.6	220	4708.2	t	2026-05-08 00:01:27.547131
5291	2026-02-06 17:30:00	4	20.86	220	4581.3	t	2026-05-08 00:01:27.547131
5292	2026-02-06 17:30:00	7	29.19	220	5180.2	t	2026-05-08 00:01:27.547131
5293	2026-02-06 18:00:00	1	19.95	220	4267	t	2026-05-08 00:01:27.547131
5294	2026-02-06 18:00:00	4	24.82	220	5115.1	t	2026-05-08 00:01:27.547131
5295	2026-02-06 18:00:00	7	28.24	220	6572.5	t	2026-05-08 00:01:27.547131
5296	2026-02-06 18:30:00	1	11.58	220	4154	t	2026-05-08 00:01:27.547131
5297	2026-02-06 18:30:00	4	17.77	220	5039	t	2026-05-08 00:01:27.547131
5298	2026-02-06 18:30:00	7	20.97	220	6318.8	t	2026-05-08 00:01:27.547131
5299	2026-02-06 19:00:00	1	20.79	220	4117.7	t	2026-05-08 00:01:27.547131
5300	2026-02-06 19:00:00	4	25.85	220	5627.3	t	2026-05-08 00:01:27.547131
5301	2026-02-06 19:00:00	7	30.42	220	4540.2	t	2026-05-08 00:01:27.547131
5302	2026-02-06 19:30:00	1	19.01	220	2815	t	2026-05-08 00:01:27.547131
5303	2026-02-06 19:30:00	4	22.14	220	5467.6	t	2026-05-08 00:01:27.547131
5304	2026-02-06 19:30:00	7	22.98	220	5484.3	t	2026-05-08 00:01:27.547131
5305	2026-02-06 20:00:00	1	2.78	220	688.3	t	2026-05-08 00:01:27.547131
5306	2026-02-06 20:00:00	4	2.57	220	574.7	t	2026-05-08 00:01:27.547131
5307	2026-02-06 20:00:00	7	2.74	220	437.2	t	2026-05-08 00:01:27.547131
5308	2026-02-06 20:30:00	1	2.07	220	658.8	t	2026-05-08 00:01:27.547131
5309	2026-02-06 20:30:00	4	2.45	220	534.6	t	2026-05-08 00:01:27.547131
5310	2026-02-06 20:30:00	7	3.37	220	300.9	t	2026-05-08 00:01:27.547131
5311	2026-02-06 21:00:00	1	2.54	220	476.9	t	2026-05-08 00:01:27.547131
5312	2026-02-06 21:00:00	4	1.61	220	575.1	t	2026-05-08 00:01:27.547131
5313	2026-02-06 21:00:00	7	2	220	769	t	2026-05-08 00:01:27.547131
5314	2026-02-06 21:30:00	1	1.5	220	652.2	t	2026-05-08 00:01:27.547131
5315	2026-02-06 21:30:00	4	2.3	220	706.1	t	2026-05-08 00:01:27.547131
5316	2026-02-06 21:30:00	7	2.42	220	443.1	t	2026-05-08 00:01:27.547131
5317	2026-02-06 22:00:00	1	1.52	220	525	t	2026-05-08 00:01:27.547131
5318	2026-02-06 22:00:00	4	1.98	220	805.2	t	2026-05-08 00:01:27.547131
5319	2026-02-06 22:00:00	7	2.9	220	782.6	t	2026-05-08 00:01:27.547131
5320	2026-02-06 22:30:00	1	2.44	220	805.1	t	2026-05-08 00:01:27.547131
5321	2026-02-06 22:30:00	4	3	220	275.3	t	2026-05-08 00:01:27.547131
5322	2026-02-06 22:30:00	7	2.01	220	688.9	t	2026-05-08 00:01:27.547131
5323	2026-02-06 23:00:00	1	1.92	220	759.5	t	2026-05-08 00:01:27.547131
5324	2026-02-06 23:00:00	4	1.87	220	414.7	t	2026-05-08 00:01:27.547131
5325	2026-02-06 23:00:00	7	1.78	220	493.3	t	2026-05-08 00:01:27.547131
5326	2026-02-06 23:30:00	1	2.27	220	305.7	t	2026-05-08 00:01:27.547131
5327	2026-02-06 23:30:00	4	2.58	220	692.4	t	2026-05-08 00:01:27.547131
5328	2026-02-06 23:30:00	7	2.87	220	809.7	t	2026-05-08 00:01:27.547131
5329	2026-02-07 00:00:00	1	1.18	220	321.1	t	2026-05-08 00:01:27.547131
5330	2026-02-07 00:00:00	4	2.89	220	652.4	t	2026-05-08 00:01:27.547131
5331	2026-02-07 00:00:00	7	2.77	220	457.3	t	2026-05-08 00:01:27.547131
5332	2026-02-07 00:30:00	1	1.61	220	489.6	t	2026-05-08 00:01:27.547131
5333	2026-02-07 00:30:00	4	1.51	220	498.8	t	2026-05-08 00:01:27.547131
5334	2026-02-07 00:30:00	7	2.68	220	431.2	t	2026-05-08 00:01:27.547131
5335	2026-02-07 01:00:00	1	1.06	220	558.1	t	2026-05-08 00:01:27.547131
5336	2026-02-07 01:00:00	4	1.54	220	393.7	t	2026-05-08 00:01:27.547131
5337	2026-02-07 01:00:00	7	1.09	220	567.5	t	2026-05-08 00:01:27.547131
5338	2026-02-07 01:30:00	1	1.39	220	277	t	2026-05-08 00:01:27.547131
5339	2026-02-07 01:30:00	4	2.06	220	238.3	t	2026-05-08 00:01:27.547131
5340	2026-02-07 01:30:00	7	2.99	220	644.5	t	2026-05-08 00:01:27.547131
5341	2026-02-07 02:00:00	1	1.33	220	356.8	t	2026-05-08 00:01:27.547131
5342	2026-02-07 02:00:00	4	1.85	220	636.5	t	2026-05-08 00:01:27.547131
5343	2026-02-07 02:00:00	7	1.45	220	533.4	t	2026-05-08 00:01:27.547131
5344	2026-02-07 02:30:00	1	2.8	220	530.3	t	2026-05-08 00:01:27.547131
5345	2026-02-07 02:30:00	4	1.64	220	584.6	t	2026-05-08 00:01:27.547131
5346	2026-02-07 02:30:00	7	2.39	220	533.8	t	2026-05-08 00:01:27.547131
5347	2026-02-07 03:00:00	1	1.25	220	366.7	t	2026-05-08 00:01:27.547131
5348	2026-02-07 03:00:00	4	1.81	220	346.4	t	2026-05-08 00:01:27.547131
5349	2026-02-07 03:00:00	7	1.94	220	360.2	t	2026-05-08 00:01:27.547131
5350	2026-02-07 03:30:00	1	2.91	220	578.6	t	2026-05-08 00:01:27.547131
5351	2026-02-07 03:30:00	4	2.62	220	521.7	t	2026-05-08 00:01:27.547131
5352	2026-02-07 03:30:00	7	2.48	220	387.3	t	2026-05-08 00:01:27.547131
5353	2026-02-07 04:00:00	1	2.18	220	490.8	t	2026-05-08 00:01:27.547131
5354	2026-02-07 04:00:00	4	2.4	220	540.7	t	2026-05-08 00:01:27.547131
5355	2026-02-07 04:00:00	7	1.82	220	499.6	t	2026-05-08 00:01:27.547131
5356	2026-02-07 04:30:00	1	2.79	220	636.7	t	2026-05-08 00:01:27.547131
5357	2026-02-07 04:30:00	4	1.69	220	619.5	t	2026-05-08 00:01:27.547131
5358	2026-02-07 04:30:00	7	1.38	220	244.3	t	2026-05-08 00:01:27.547131
5359	2026-02-07 05:00:00	1	1.02	220	459.6	t	2026-05-08 00:01:27.547131
5360	2026-02-07 05:00:00	4	2.54	220	393.6	t	2026-05-08 00:01:27.547131
5361	2026-02-07 05:00:00	7	1.64	220	245.5	t	2026-05-08 00:01:27.547131
5362	2026-02-07 05:30:00	1	2.13	220	474.5	t	2026-05-08 00:01:27.547131
5363	2026-02-07 05:30:00	4	1.84	220	380.9	t	2026-05-08 00:01:27.547131
5364	2026-02-07 05:30:00	7	1.79	220	482.9	t	2026-05-08 00:01:27.547131
5365	2026-02-07 06:00:00	1	1.47	220	298.2	t	2026-05-08 00:01:27.547131
5366	2026-02-07 06:00:00	4	1.56	220	488.8	t	2026-05-08 00:01:27.547131
5367	2026-02-07 06:00:00	7	1.88	220	626.7	t	2026-05-08 00:01:27.547131
5368	2026-02-07 06:30:00	1	1.88	220	599.7	t	2026-05-08 00:01:27.547131
5369	2026-02-07 06:30:00	4	2.72	220	568	t	2026-05-08 00:01:27.547131
5370	2026-02-07 06:30:00	7	2.56	220	561.3	t	2026-05-08 00:01:27.547131
5371	2026-02-07 07:00:00	1	1.5	220	277.2	t	2026-05-08 00:01:27.547131
5372	2026-02-07 07:00:00	4	2.3	220	391.8	t	2026-05-08 00:01:27.547131
5373	2026-02-07 07:00:00	7	1.47	220	450.2	t	2026-05-08 00:01:27.547131
5374	2026-02-07 07:30:00	1	2.76	220	268.8	t	2026-05-08 00:01:27.547131
5375	2026-02-07 07:30:00	4	2.48	220	479.4	t	2026-05-08 00:01:27.547131
5376	2026-02-07 07:30:00	7	2.01	220	420.5	t	2026-05-08 00:01:27.547131
5377	2026-02-07 08:00:00	1	1.44	220	394.9	t	2026-05-08 00:01:27.547131
5378	2026-02-07 08:00:00	4	2.3	220	386	t	2026-05-08 00:01:27.547131
5379	2026-02-07 08:00:00	7	2.91	220	338.6	t	2026-05-08 00:01:27.547131
5380	2026-02-07 08:30:00	1	1.67	220	236.3	t	2026-05-08 00:01:27.547131
5381	2026-02-07 08:30:00	4	1.15	220	309.1	t	2026-05-08 00:01:27.547131
5382	2026-02-07 08:30:00	7	1.1	220	524.7	t	2026-05-08 00:01:27.547131
5383	2026-02-07 09:00:00	1	1.43	220	582.4	t	2026-05-08 00:01:27.547131
5384	2026-02-07 09:00:00	4	1.91	220	578.2	t	2026-05-08 00:01:27.547131
5385	2026-02-07 09:00:00	7	1.59	220	243.8	t	2026-05-08 00:01:27.547131
5386	2026-02-07 09:30:00	1	2.52	220	358.5	t	2026-05-08 00:01:27.547131
5387	2026-02-07 09:30:00	4	2.03	220	278.9	t	2026-05-08 00:01:27.547131
5388	2026-02-07 09:30:00	7	2.48	220	397.7	t	2026-05-08 00:01:27.547131
5389	2026-02-07 10:00:00	1	2.95	220	583.4	t	2026-05-08 00:01:27.547131
5390	2026-02-07 10:00:00	4	1.98	220	587.6	t	2026-05-08 00:01:27.547131
5391	2026-02-07 10:00:00	7	1.92	220	658.2	t	2026-05-08 00:01:27.547131
5392	2026-02-07 10:30:00	1	2.46	220	557.1	t	2026-05-08 00:01:27.547131
5393	2026-02-07 10:30:00	4	2.51	220	657.5	t	2026-05-08 00:01:27.547131
5394	2026-02-07 10:30:00	7	1.92	220	651.5	t	2026-05-08 00:01:27.547131
5395	2026-02-07 11:00:00	1	2.52	220	244.3	t	2026-05-08 00:01:27.547131
5396	2026-02-07 11:00:00	4	2.26	220	455.3	t	2026-05-08 00:01:27.547131
5397	2026-02-07 11:00:00	7	1.9	220	266.7	t	2026-05-08 00:01:27.547131
5398	2026-02-07 11:30:00	1	2.35	220	394.4	t	2026-05-08 00:01:27.547131
5399	2026-02-07 11:30:00	4	1.83	220	264.7	t	2026-05-08 00:01:27.547131
5400	2026-02-07 11:30:00	7	1.18	220	258.4	t	2026-05-08 00:01:27.547131
5401	2026-02-07 12:00:00	1	1.44	220	249.2	t	2026-05-08 00:01:27.547131
5402	2026-02-07 12:00:00	4	1.9	220	554.3	t	2026-05-08 00:01:27.547131
5403	2026-02-07 12:00:00	7	1.35	220	269.2	t	2026-05-08 00:01:27.547131
5404	2026-02-07 12:30:00	1	2.33	220	617.1	t	2026-05-08 00:01:27.547131
5405	2026-02-07 12:30:00	4	1.3	220	329.5	t	2026-05-08 00:01:27.547131
5406	2026-02-07 12:30:00	7	2.47	220	335.7	t	2026-05-08 00:01:27.547131
5407	2026-02-07 13:00:00	1	1.51	220	342.1	t	2026-05-08 00:01:27.547131
5408	2026-02-07 13:00:00	4	1.75	220	278.6	t	2026-05-08 00:01:27.547131
5409	2026-02-07 13:00:00	7	2.91	220	229.8	t	2026-05-08 00:01:27.547131
5410	2026-02-07 13:30:00	1	1.45	220	505.1	t	2026-05-08 00:01:27.547131
5411	2026-02-07 13:30:00	4	2.84	220	523	t	2026-05-08 00:01:27.547131
5412	2026-02-07 13:30:00	7	1.74	220	371.2	t	2026-05-08 00:01:27.547131
5413	2026-02-07 14:00:00	1	1.21	220	496.2	t	2026-05-08 00:01:27.547131
5414	2026-02-07 14:00:00	4	1.05	220	252.7	t	2026-05-08 00:01:27.547131
5415	2026-02-07 14:00:00	7	2.54	220	318.9	t	2026-05-08 00:01:27.547131
5416	2026-02-07 14:30:00	1	2.66	220	277.7	t	2026-05-08 00:01:27.547131
5417	2026-02-07 14:30:00	4	2.63	220	281.3	t	2026-05-08 00:01:27.547131
5418	2026-02-07 14:30:00	7	1.83	220	282	t	2026-05-08 00:01:27.547131
5419	2026-02-07 15:00:00	1	2.84	220	496.2	t	2026-05-08 00:01:27.547131
5420	2026-02-07 15:00:00	4	1.92	220	278.1	t	2026-05-08 00:01:27.547131
5421	2026-02-07 15:00:00	7	1.71	220	512.7	t	2026-05-08 00:01:27.547131
5422	2026-02-07 15:30:00	1	2.58	220	493.9	t	2026-05-08 00:01:27.547131
5423	2026-02-07 15:30:00	4	2.73	220	576	t	2026-05-08 00:01:27.547131
5424	2026-02-07 15:30:00	7	2.06	220	392.7	t	2026-05-08 00:01:27.547131
5425	2026-02-07 16:00:00	1	2.32	220	496.4	t	2026-05-08 00:01:27.547131
5426	2026-02-07 16:00:00	4	2.81	220	411	t	2026-05-08 00:01:27.547131
5427	2026-02-07 16:00:00	7	2.27	220	637.9	t	2026-05-08 00:01:27.547131
5428	2026-02-07 16:30:00	1	1.85	220	451	t	2026-05-08 00:01:27.547131
5429	2026-02-07 16:30:00	4	1.87	220	459.7	t	2026-05-08 00:01:27.547131
5430	2026-02-07 16:30:00	7	2.72	220	613.1	t	2026-05-08 00:01:27.547131
5431	2026-02-07 17:00:00	1	1.93	220	321	t	2026-05-08 00:01:27.547131
5432	2026-02-07 17:00:00	4	2.11	220	633.2	t	2026-05-08 00:01:27.547131
5433	2026-02-07 17:00:00	7	1.4	220	364.3	t	2026-05-08 00:01:27.547131
5434	2026-02-07 17:30:00	1	1.16	220	518	t	2026-05-08 00:01:27.547131
5435	2026-02-07 17:30:00	4	1.58	220	437	t	2026-05-08 00:01:27.547131
5436	2026-02-07 17:30:00	7	2.78	220	611	t	2026-05-08 00:01:27.547131
5437	2026-02-07 18:00:00	1	2.78	220	638.4	t	2026-05-08 00:01:27.547131
5438	2026-02-07 18:00:00	4	1.55	220	561.3	t	2026-05-08 00:01:27.547131
5439	2026-02-07 18:00:00	7	2.62	220	230.5	t	2026-05-08 00:01:27.547131
5440	2026-02-07 18:30:00	1	2.81	220	416.1	t	2026-05-08 00:01:27.547131
5441	2026-02-07 18:30:00	4	2.11	220	458.8	t	2026-05-08 00:01:27.547131
5442	2026-02-07 18:30:00	7	2.99	220	320	t	2026-05-08 00:01:27.547131
5443	2026-02-07 19:00:00	1	2.48	220	513	t	2026-05-08 00:01:27.547131
5444	2026-02-07 19:00:00	4	1.8	220	381.8	t	2026-05-08 00:01:27.547131
5445	2026-02-07 19:00:00	7	1.55	220	295.9	t	2026-05-08 00:01:27.547131
5446	2026-02-07 19:30:00	1	2.61	220	568.8	t	2026-05-08 00:01:27.547131
5447	2026-02-07 19:30:00	4	2.36	220	422.7	t	2026-05-08 00:01:27.547131
5448	2026-02-07 19:30:00	7	2.39	220	430.1	t	2026-05-08 00:01:27.547131
5449	2026-02-07 20:00:00	1	2.96	220	318.4	t	2026-05-08 00:01:27.547131
5450	2026-02-07 20:00:00	4	1.64	220	284.9	t	2026-05-08 00:01:27.547131
5451	2026-02-07 20:00:00	7	1.55	220	485.5	t	2026-05-08 00:01:27.547131
5452	2026-02-07 20:30:00	1	2.51	220	268.3	t	2026-05-08 00:01:27.547131
5453	2026-02-07 20:30:00	4	2.35	220	608.8	t	2026-05-08 00:01:27.547131
5454	2026-02-07 20:30:00	7	1.29	220	284.4	t	2026-05-08 00:01:27.547131
5455	2026-02-07 21:00:00	1	1.35	220	395.5	t	2026-05-08 00:01:27.547131
5456	2026-02-07 21:00:00	4	1.22	220	338.2	t	2026-05-08 00:01:27.547131
5457	2026-02-07 21:00:00	7	2.82	220	517.6	t	2026-05-08 00:01:27.547131
5458	2026-02-07 21:30:00	1	1.85	220	587.7	t	2026-05-08 00:01:27.547131
5459	2026-02-07 21:30:00	4	2.69	220	591.2	t	2026-05-08 00:01:27.547131
5460	2026-02-07 21:30:00	7	1.22	220	550.7	t	2026-05-08 00:01:27.547131
5461	2026-02-07 22:00:00	1	2.23	220	657.4	t	2026-05-08 00:01:27.547131
5462	2026-02-07 22:00:00	4	1.2	220	577.7	t	2026-05-08 00:01:27.547131
5463	2026-02-07 22:00:00	7	1.91	220	642.4	t	2026-05-08 00:01:27.547131
5464	2026-02-07 22:30:00	1	2.1	220	651.4	t	2026-05-08 00:01:27.547131
5465	2026-02-07 22:30:00	4	2.06	220	331	t	2026-05-08 00:01:27.547131
5466	2026-02-07 22:30:00	7	2.21	220	308.2	t	2026-05-08 00:01:27.547131
5467	2026-02-07 23:00:00	1	2.12	220	415	t	2026-05-08 00:01:27.547131
5468	2026-02-07 23:00:00	4	2.55	220	524.3	t	2026-05-08 00:01:27.547131
5469	2026-02-07 23:00:00	7	2.87	220	244.1	t	2026-05-08 00:01:27.547131
5470	2026-02-07 23:30:00	1	1.74	220	512.5	t	2026-05-08 00:01:27.547131
5471	2026-02-07 23:30:00	4	2.57	220	544	t	2026-05-08 00:01:27.547131
5472	2026-02-07 23:30:00	7	1.22	220	366.1	t	2026-05-08 00:01:27.547131
5473	2026-02-08 00:00:00	1	1.24	220	464.7	t	2026-05-08 00:01:27.547131
5474	2026-02-08 00:00:00	4	1.83	220	306.8	t	2026-05-08 00:01:27.547131
5475	2026-02-08 00:00:00	7	1.93	220	442.8	t	2026-05-08 00:01:27.547131
5476	2026-02-08 00:30:00	1	1.85	220	353.8	t	2026-05-08 00:01:27.547131
5477	2026-02-08 00:30:00	4	1.77	220	535.9	t	2026-05-08 00:01:27.547131
5478	2026-02-08 00:30:00	7	2.18	220	437.7	t	2026-05-08 00:01:27.547131
5479	2026-02-08 01:00:00	1	1.67	220	497.6	t	2026-05-08 00:01:27.547131
5480	2026-02-08 01:00:00	4	1.66	220	394.6	t	2026-05-08 00:01:27.547131
5481	2026-02-08 01:00:00	7	2.64	220	433.9	t	2026-05-08 00:01:27.547131
5482	2026-02-08 01:30:00	1	1.97	220	406.1	t	2026-05-08 00:01:27.547131
5483	2026-02-08 01:30:00	4	1.4	220	598.3	t	2026-05-08 00:01:27.547131
5484	2026-02-08 01:30:00	7	1.65	220	412	t	2026-05-08 00:01:27.547131
5485	2026-02-08 02:00:00	1	2.34	220	273.9	t	2026-05-08 00:01:27.547131
5486	2026-02-08 02:00:00	4	1.84	220	351.9	t	2026-05-08 00:01:27.547131
5487	2026-02-08 02:00:00	7	1.5	220	272.6	t	2026-05-08 00:01:27.547131
5488	2026-02-08 02:30:00	1	1.47	220	421.1	t	2026-05-08 00:01:27.547131
5489	2026-02-08 02:30:00	4	1.4	220	413.9	t	2026-05-08 00:01:27.547131
5490	2026-02-08 02:30:00	7	1.35	220	229.9	t	2026-05-08 00:01:27.547131
5491	2026-02-08 03:00:00	1	1.39	220	509.5	t	2026-05-08 00:01:27.547131
5492	2026-02-08 03:00:00	4	1.76	220	578.1	t	2026-05-08 00:01:27.547131
5493	2026-02-08 03:00:00	7	1.85	220	485.6	t	2026-05-08 00:01:27.547131
5494	2026-02-08 03:30:00	1	2.17	220	283.1	t	2026-05-08 00:01:27.547131
5495	2026-02-08 03:30:00	4	1.48	220	420.7	t	2026-05-08 00:01:27.547131
5496	2026-02-08 03:30:00	7	2	220	513.8	t	2026-05-08 00:01:27.547131
5497	2026-02-08 04:00:00	1	2.17	220	544	t	2026-05-08 00:01:27.547131
5498	2026-02-08 04:00:00	4	2.1	220	635.1	t	2026-05-08 00:01:27.547131
5499	2026-02-08 04:00:00	7	1.58	220	330.1	t	2026-05-08 00:01:27.547131
5500	2026-02-08 04:30:00	1	2.37	220	386.4	t	2026-05-08 00:01:27.547131
5501	2026-02-08 04:30:00	4	2.57	220	316.5	t	2026-05-08 00:01:27.547131
5502	2026-02-08 04:30:00	7	1.2	220	454.4	t	2026-05-08 00:01:27.547131
5503	2026-02-08 05:00:00	1	2.66	220	368.2	t	2026-05-08 00:01:27.547131
5504	2026-02-08 05:00:00	4	2.59	220	424.2	t	2026-05-08 00:01:27.547131
5505	2026-02-08 05:00:00	7	1.1	220	224.8	t	2026-05-08 00:01:27.547131
5506	2026-02-08 05:30:00	1	1.66	220	306.2	t	2026-05-08 00:01:27.547131
5507	2026-02-08 05:30:00	4	1.11	220	520.1	t	2026-05-08 00:01:27.547131
5508	2026-02-08 05:30:00	7	1.7	220	458	t	2026-05-08 00:01:27.547131
5509	2026-02-08 06:00:00	1	2.59	220	579.9	t	2026-05-08 00:01:27.547131
5510	2026-02-08 06:00:00	4	1.01	220	361.6	t	2026-05-08 00:01:27.547131
5511	2026-02-08 06:00:00	7	1.6	220	388.3	t	2026-05-08 00:01:27.547131
5512	2026-02-08 06:30:00	1	2.92	220	541.7	t	2026-05-08 00:01:27.547131
5513	2026-02-08 06:30:00	4	1.91	220	558.5	t	2026-05-08 00:01:27.547131
5514	2026-02-08 06:30:00	7	1.86	220	374.1	t	2026-05-08 00:01:27.547131
5515	2026-02-08 07:00:00	1	1.51	220	488.6	t	2026-05-08 00:01:27.547131
5516	2026-02-08 07:00:00	4	1.59	220	550.6	t	2026-05-08 00:01:27.547131
5517	2026-02-08 07:00:00	7	2.89	220	268	t	2026-05-08 00:01:27.547131
5518	2026-02-08 07:30:00	1	2.46	220	615.4	t	2026-05-08 00:01:27.547131
5519	2026-02-08 07:30:00	4	2.4	220	226.6	t	2026-05-08 00:01:27.547131
5520	2026-02-08 07:30:00	7	1.01	220	472.9	t	2026-05-08 00:01:27.547131
5521	2026-02-08 08:00:00	1	2.89	220	420.3	t	2026-05-08 00:01:27.547131
5522	2026-02-08 08:00:00	4	2.21	220	509.2	t	2026-05-08 00:01:27.547131
5523	2026-02-08 08:00:00	7	1.75	220	548.3	t	2026-05-08 00:01:27.547131
5524	2026-02-08 08:30:00	1	1.56	220	472.8	t	2026-05-08 00:01:27.547131
5525	2026-02-08 08:30:00	4	2.98	220	446.9	t	2026-05-08 00:01:27.547131
5526	2026-02-08 08:30:00	7	1.15	220	660	t	2026-05-08 00:01:27.547131
5527	2026-02-08 09:00:00	1	2.95	220	474.4	t	2026-05-08 00:01:27.547131
5528	2026-02-08 09:00:00	4	1.11	220	365.1	t	2026-05-08 00:01:27.547131
5529	2026-02-08 09:00:00	7	1.8	220	556.7	t	2026-05-08 00:01:27.547131
5530	2026-02-08 09:30:00	1	1.14	220	604.5	t	2026-05-08 00:01:27.547131
5531	2026-02-08 09:30:00	4	1.79	220	614	t	2026-05-08 00:01:27.547131
5532	2026-02-08 09:30:00	7	2.17	220	656.7	t	2026-05-08 00:01:27.547131
5533	2026-02-08 10:00:00	1	1.87	220	644.5	t	2026-05-08 00:01:27.547131
5534	2026-02-08 10:00:00	4	1.15	220	605.9	t	2026-05-08 00:01:27.547131
5535	2026-02-08 10:00:00	7	2.81	220	602.5	t	2026-05-08 00:01:27.547131
5536	2026-02-08 10:30:00	1	2.59	220	289.4	t	2026-05-08 00:01:27.547131
5537	2026-02-08 10:30:00	4	1.11	220	284.2	t	2026-05-08 00:01:27.547131
5538	2026-02-08 10:30:00	7	2.75	220	621.6	t	2026-05-08 00:01:27.547131
5539	2026-02-08 11:00:00	1	2.59	220	359.5	t	2026-05-08 00:01:27.547131
5540	2026-02-08 11:00:00	4	2.6	220	296.9	t	2026-05-08 00:01:27.547131
5541	2026-02-08 11:00:00	7	2.44	220	520.5	t	2026-05-08 00:01:27.547131
5542	2026-02-08 11:30:00	1	1.67	220	535.7	t	2026-05-08 00:01:27.547131
5543	2026-02-08 11:30:00	4	2.24	220	653.6	t	2026-05-08 00:01:27.547131
5544	2026-02-08 11:30:00	7	1.39	220	562.5	t	2026-05-08 00:01:27.547131
5545	2026-02-08 12:00:00	1	1.73	220	399	t	2026-05-08 00:01:27.547131
5546	2026-02-08 12:00:00	4	2.48	220	521	t	2026-05-08 00:01:27.547131
5547	2026-02-08 12:00:00	7	2.7	220	656	t	2026-05-08 00:01:27.547131
5548	2026-02-08 12:30:00	1	1.06	220	388.1	t	2026-05-08 00:01:27.547131
5549	2026-02-08 12:30:00	4	1.55	220	232.4	t	2026-05-08 00:01:27.547131
5550	2026-02-08 12:30:00	7	2.98	220	266.4	t	2026-05-08 00:01:27.547131
5551	2026-02-08 13:00:00	1	2.94	220	458.1	t	2026-05-08 00:01:27.547131
5552	2026-02-08 13:00:00	4	2.83	220	626	t	2026-05-08 00:01:27.547131
5553	2026-02-08 13:00:00	7	1.68	220	586.2	t	2026-05-08 00:01:27.547131
5554	2026-02-08 13:30:00	1	1.35	220	656.3	t	2026-05-08 00:01:27.547131
5555	2026-02-08 13:30:00	4	1.66	220	221.8	t	2026-05-08 00:01:27.547131
5556	2026-02-08 13:30:00	7	2.34	220	489.4	t	2026-05-08 00:01:27.547131
5557	2026-02-08 14:00:00	1	2.24	220	315.4	t	2026-05-08 00:01:27.547131
5558	2026-02-08 14:00:00	4	1.93	220	479	t	2026-05-08 00:01:27.547131
5559	2026-02-08 14:00:00	7	1.74	220	519.9	t	2026-05-08 00:01:27.547131
5560	2026-02-08 14:30:00	1	1.89	220	637	t	2026-05-08 00:01:27.547131
5561	2026-02-08 14:30:00	4	1.79	220	426.5	t	2026-05-08 00:01:27.547131
5562	2026-02-08 14:30:00	7	1.85	220	411.6	t	2026-05-08 00:01:27.547131
5563	2026-02-08 15:00:00	1	2.55	220	469.9	t	2026-05-08 00:01:27.547131
5564	2026-02-08 15:00:00	4	2.04	220	384.6	t	2026-05-08 00:01:27.547131
5565	2026-02-08 15:00:00	7	2.85	220	331.2	t	2026-05-08 00:01:27.547131
5566	2026-02-08 15:30:00	1	1.44	220	279.2	t	2026-05-08 00:01:27.547131
5567	2026-02-08 15:30:00	4	1.46	220	231.4	t	2026-05-08 00:01:27.547131
5568	2026-02-08 15:30:00	7	2.51	220	562.5	t	2026-05-08 00:01:27.547131
5569	2026-02-08 16:00:00	1	1.97	220	376.8	t	2026-05-08 00:01:27.547131
5570	2026-02-08 16:00:00	4	2.45	220	385.8	t	2026-05-08 00:01:27.547131
5571	2026-02-08 16:00:00	7	1.18	220	533.2	t	2026-05-08 00:01:27.547131
5572	2026-02-08 16:30:00	1	1.7	220	483	t	2026-05-08 00:01:27.547131
5573	2026-02-08 16:30:00	4	2.01	220	304.9	t	2026-05-08 00:01:27.547131
5574	2026-02-08 16:30:00	7	1.17	220	491.3	t	2026-05-08 00:01:27.547131
5575	2026-02-08 17:00:00	1	2.93	220	242.1	t	2026-05-08 00:01:27.547131
5576	2026-02-08 17:00:00	4	1.14	220	290.3	t	2026-05-08 00:01:27.547131
5577	2026-02-08 17:00:00	7	2.15	220	282.4	t	2026-05-08 00:01:27.547131
5578	2026-02-08 17:30:00	1	1.99	220	452.6	t	2026-05-08 00:01:27.547131
5579	2026-02-08 17:30:00	4	1.29	220	303.9	t	2026-05-08 00:01:27.547131
5580	2026-02-08 17:30:00	7	1.85	220	424.1	t	2026-05-08 00:01:27.547131
5581	2026-02-08 18:00:00	1	2.68	220	422.5	t	2026-05-08 00:01:27.547131
5582	2026-02-08 18:00:00	4	1.13	220	614.8	t	2026-05-08 00:01:27.547131
5583	2026-02-08 18:00:00	7	1.23	220	460.1	t	2026-05-08 00:01:27.547131
5584	2026-02-08 18:30:00	1	2.03	220	404.7	t	2026-05-08 00:01:27.547131
5585	2026-02-08 18:30:00	4	2.11	220	523.4	t	2026-05-08 00:01:27.547131
5586	2026-02-08 18:30:00	7	1.05	220	538.8	t	2026-05-08 00:01:27.547131
5587	2026-02-08 19:00:00	1	2.2	220	516.7	t	2026-05-08 00:01:27.547131
5588	2026-02-08 19:00:00	4	2.94	220	246.7	t	2026-05-08 00:01:27.547131
5589	2026-02-08 19:00:00	7	2.57	220	633.3	t	2026-05-08 00:01:27.547131
5590	2026-02-08 19:30:00	1	2.64	220	399.9	t	2026-05-08 00:01:27.547131
5591	2026-02-08 19:30:00	4	2.03	220	582.2	t	2026-05-08 00:01:27.547131
5592	2026-02-08 19:30:00	7	1.36	220	641.7	t	2026-05-08 00:01:27.547131
5593	2026-02-08 20:00:00	1	1.9	220	599.2	t	2026-05-08 00:01:27.547131
5594	2026-02-08 20:00:00	4	2.97	220	503.8	t	2026-05-08 00:01:27.547131
5595	2026-02-08 20:00:00	7	1.69	220	351	t	2026-05-08 00:01:27.547131
5596	2026-02-08 20:30:00	1	1.83	220	385.8	t	2026-05-08 00:01:27.547131
5597	2026-02-08 20:30:00	4	1.99	220	598.6	t	2026-05-08 00:01:27.547131
5598	2026-02-08 20:30:00	7	2.81	220	490.1	t	2026-05-08 00:01:27.547131
5599	2026-02-08 21:00:00	1	1.49	220	266.6	t	2026-05-08 00:01:27.547131
5600	2026-02-08 21:00:00	4	2.04	220	306.7	t	2026-05-08 00:01:27.547131
5601	2026-02-08 21:00:00	7	2.4	220	527.6	t	2026-05-08 00:01:27.547131
5602	2026-02-08 21:30:00	1	1.84	220	460.1	t	2026-05-08 00:01:27.547131
5603	2026-02-08 21:30:00	4	2.96	220	543.3	t	2026-05-08 00:01:27.547131
5604	2026-02-08 21:30:00	7	2.03	220	518.9	t	2026-05-08 00:01:27.547131
5605	2026-02-08 22:00:00	1	2.42	220	458.7	t	2026-05-08 00:01:27.547131
5606	2026-02-08 22:00:00	4	2.36	220	417.7	t	2026-05-08 00:01:27.547131
5607	2026-02-08 22:00:00	7	1.99	220	522.1	t	2026-05-08 00:01:27.547131
5608	2026-02-08 22:30:00	1	2.44	220	634.3	t	2026-05-08 00:01:27.547131
5609	2026-02-08 22:30:00	4	1.46	220	537.6	t	2026-05-08 00:01:27.547131
5610	2026-02-08 22:30:00	7	1.57	220	548.8	t	2026-05-08 00:01:27.547131
5611	2026-02-08 23:00:00	1	1.14	220	361	t	2026-05-08 00:01:27.547131
5612	2026-02-08 23:00:00	4	2.12	220	532.7	t	2026-05-08 00:01:27.547131
5613	2026-02-08 23:00:00	7	2.78	220	616	t	2026-05-08 00:01:27.547131
5614	2026-02-08 23:30:00	1	1.15	220	630.2	t	2026-05-08 00:01:27.547131
5615	2026-02-08 23:30:00	4	2.98	220	254.2	t	2026-05-08 00:01:27.547131
5616	2026-02-08 23:30:00	7	1.23	220	228.6	t	2026-05-08 00:01:27.547131
5617	2026-02-09 00:00:00	1	3.57	220	616.8	t	2026-05-08 00:01:27.547131
5618	2026-02-09 00:00:00	4	3.05	220	765.8	t	2026-05-08 00:01:27.547131
5619	2026-02-09 00:00:00	7	3.54	220	554.8	t	2026-05-08 00:01:27.547131
5620	2026-02-09 00:30:00	1	3.17	220	494.9	t	2026-05-08 00:01:27.547131
5621	2026-02-09 00:30:00	4	3.41	220	367.1	t	2026-05-08 00:01:27.547131
5622	2026-02-09 00:30:00	7	3.29	220	660.6	t	2026-05-08 00:01:27.547131
5623	2026-02-09 01:00:00	1	3.27	220	599.8	t	2026-05-08 00:01:27.547131
5624	2026-02-09 01:00:00	4	3.13	220	711.4	t	2026-05-08 00:01:27.547131
5625	2026-02-09 01:00:00	7	2.99	220	720	t	2026-05-08 00:01:27.547131
5626	2026-02-09 01:30:00	1	1.48	220	491.5	t	2026-05-08 00:01:27.547131
5627	2026-02-09 01:30:00	4	2.88	220	714.2	t	2026-05-08 00:01:27.547131
5628	2026-02-09 01:30:00	7	2.33	220	503	t	2026-05-08 00:01:27.547131
5629	2026-02-09 02:00:00	1	1.82	220	510.4	t	2026-05-08 00:01:27.547131
5630	2026-02-09 02:00:00	4	2.78	220	282.8	t	2026-05-08 00:01:27.547131
5631	2026-02-09 02:00:00	7	2.21	220	287.4	t	2026-05-08 00:01:27.547131
5632	2026-02-09 02:30:00	1	1.7	220	400	t	2026-05-08 00:01:27.547131
5633	2026-02-09 02:30:00	4	3.67	220	390.8	t	2026-05-08 00:01:27.547131
5634	2026-02-09 02:30:00	7	2.11	220	460.6	t	2026-05-08 00:01:27.547131
5635	2026-02-09 03:00:00	1	1.33	220	694.6	t	2026-05-08 00:01:27.547131
5636	2026-02-09 03:00:00	4	1.59	220	295	t	2026-05-08 00:01:27.547131
5637	2026-02-09 03:00:00	7	1.23	220	389.5	t	2026-05-08 00:01:27.547131
5638	2026-02-09 03:30:00	1	2.1	220	428.7	t	2026-05-08 00:01:27.547131
5639	2026-02-09 03:30:00	4	1.78	220	751.3	t	2026-05-08 00:01:27.547131
5640	2026-02-09 03:30:00	7	2.77	220	579.5	t	2026-05-08 00:01:27.547131
5641	2026-02-09 04:00:00	1	3.67	220	389	t	2026-05-08 00:01:27.547131
5642	2026-02-09 04:00:00	4	2.66	220	310.4	t	2026-05-08 00:01:27.547131
5643	2026-02-09 04:00:00	7	2.27	220	660.9	t	2026-05-08 00:01:27.547131
5644	2026-02-09 04:30:00	1	2.27	220	508.3	t	2026-05-08 00:01:27.547131
5645	2026-02-09 04:30:00	4	2.91	220	716.2	t	2026-05-08 00:01:27.547131
5646	2026-02-09 04:30:00	7	2.49	220	448.9	t	2026-05-08 00:01:27.547131
5647	2026-02-09 05:00:00	1	3.07	220	740	t	2026-05-08 00:01:27.547131
5648	2026-02-09 05:00:00	4	3.02	220	367	t	2026-05-08 00:01:27.547131
5649	2026-02-09 05:00:00	7	3.42	220	638.1	t	2026-05-08 00:01:27.547131
5650	2026-02-09 05:30:00	1	2.08	220	564.1	t	2026-05-08 00:01:27.547131
5651	2026-02-09 05:30:00	4	3.43	220	579.2	t	2026-05-08 00:01:27.547131
5652	2026-02-09 05:30:00	7	2.8	220	487.4	t	2026-05-08 00:01:27.547131
5653	2026-02-09 06:00:00	1	1.29	220	456.6	t	2026-05-08 00:01:27.547131
5654	2026-02-09 06:00:00	4	1.74	220	317.6	t	2026-05-08 00:01:27.547131
5655	2026-02-09 06:00:00	7	3.18	220	321.3	t	2026-05-08 00:01:27.547131
5656	2026-02-09 06:30:00	1	2.41	220	764.4	t	2026-05-08 00:01:27.547131
5657	2026-02-09 06:30:00	4	1.92	220	701	t	2026-05-08 00:01:27.547131
5658	2026-02-09 06:30:00	7	1.44	220	695.6	t	2026-05-08 00:01:27.547131
5659	2026-02-09 07:00:00	1	19.21	220	2653.8	t	2026-05-08 00:01:27.547131
5660	2026-02-09 07:00:00	4	24.61	220	4427	t	2026-05-08 00:01:27.547131
5661	2026-02-09 07:00:00	7	24.37	220	4725.7	t	2026-05-08 00:01:27.547131
5662	2026-02-09 07:30:00	1	15.93	220	3470.3	t	2026-05-08 00:01:27.547131
5663	2026-02-09 07:30:00	4	24.54	220	3541.6	t	2026-05-08 00:01:27.547131
5664	2026-02-09 07:30:00	7	26.54	220	6302.9	t	2026-05-08 00:01:27.547131
5665	2026-02-09 08:00:00	1	16.37	220	3134.8	t	2026-05-08 00:01:27.547131
5666	2026-02-09 08:00:00	4	23.14	220	5006.9	t	2026-05-08 00:01:27.547131
5667	2026-02-09 08:00:00	7	21.85	220	4923.6	t	2026-05-08 00:01:27.547131
5668	2026-02-09 08:30:00	1	18.07	220	2661	t	2026-05-08 00:01:27.547131
5669	2026-02-09 08:30:00	4	24.79	220	5499.3	t	2026-05-08 00:01:27.547131
5670	2026-02-09 08:30:00	7	29.08	220	6273.2	t	2026-05-08 00:01:27.547131
5671	2026-02-09 09:00:00	1	21.29	220	4407.8	t	2026-05-08 00:01:27.547131
5672	2026-02-09 09:00:00	4	21.94	220	5229.7	t	2026-05-08 00:01:27.547131
5673	2026-02-09 09:00:00	7	21.9	220	5836.8	t	2026-05-08 00:01:27.547131
5674	2026-02-09 09:30:00	1	14.52	220	4631.9	t	2026-05-08 00:01:27.547131
5675	2026-02-09 09:30:00	4	21.57	220	3621.2	t	2026-05-08 00:01:27.547131
5676	2026-02-09 09:30:00	7	22.87	220	5812	t	2026-05-08 00:01:27.547131
5677	2026-02-09 10:00:00	1	19.77	220	3033.2	t	2026-05-08 00:01:27.547131
5678	2026-02-09 10:00:00	4	18.94	220	3802.7	t	2026-05-08 00:01:27.547131
5679	2026-02-09 10:00:00	7	30.43	220	6275.8	t	2026-05-08 00:01:27.547131
5680	2026-02-09 10:30:00	1	18.23	220	2855.3	t	2026-05-08 00:01:27.547131
5681	2026-02-09 10:30:00	4	19.87	220	4478.1	t	2026-05-08 00:01:27.547131
5682	2026-02-09 10:30:00	7	20.8	220	4983.2	t	2026-05-08 00:01:27.547131
5683	2026-02-09 11:00:00	1	20.52	220	3641.4	t	2026-05-08 00:01:27.547131
5684	2026-02-09 11:00:00	4	24.75	220	5081.8	t	2026-05-08 00:01:27.547131
5685	2026-02-09 11:00:00	7	23.62	220	6087.6	t	2026-05-08 00:01:27.547131
5686	2026-02-09 11:30:00	1	18.14	220	3192.4	t	2026-05-08 00:01:27.547131
5687	2026-02-09 11:30:00	4	19.41	220	3869.1	t	2026-05-08 00:01:27.547131
5688	2026-02-09 11:30:00	7	23.54	220	6531.3	t	2026-05-08 00:01:27.547131
5689	2026-02-09 12:00:00	1	15.25	220	3331.8	t	2026-05-08 00:01:27.547131
5690	2026-02-09 12:00:00	4	18.73	220	5640.1	t	2026-05-08 00:01:27.547131
5691	2026-02-09 12:00:00	7	26.45	220	5527.4	t	2026-05-08 00:01:27.547131
5692	2026-02-09 12:30:00	1	14.11	220	4429.6	t	2026-05-08 00:01:27.547131
5693	2026-02-09 12:30:00	4	22.16	220	3957.7	t	2026-05-08 00:01:27.547131
5694	2026-02-09 12:30:00	7	25	220	5835.4	t	2026-05-08 00:01:27.547131
5695	2026-02-09 13:00:00	1	19.3	220	3693.9	t	2026-05-08 00:01:27.547131
5696	2026-02-09 13:00:00	4	25.75	220	3743.9	t	2026-05-08 00:01:27.547131
5697	2026-02-09 13:00:00	7	27.78	220	5790.8	t	2026-05-08 00:01:27.547131
5698	2026-02-09 13:30:00	1	20.63	220	3551.5	t	2026-05-08 00:01:27.547131
5699	2026-02-09 13:30:00	4	17.69	220	4746	t	2026-05-08 00:01:27.547131
5700	2026-02-09 13:30:00	7	21.86	220	6538.3	t	2026-05-08 00:01:27.547131
5701	2026-02-09 14:00:00	1	17.73	220	4037.4	t	2026-05-08 00:01:27.547131
5702	2026-02-09 14:00:00	4	19.28	220	4456.7	t	2026-05-08 00:01:27.547131
5703	2026-02-09 14:00:00	7	20.98	220	5276.3	t	2026-05-08 00:01:27.547131
5704	2026-02-09 14:30:00	1	11.57	220	2655.6	t	2026-05-08 00:01:27.547131
5705	2026-02-09 14:30:00	4	20.26	220	5247.6	t	2026-05-08 00:01:27.547131
5706	2026-02-09 14:30:00	7	22.25	220	6482	t	2026-05-08 00:01:27.547131
5707	2026-02-09 15:00:00	1	14.63	220	3943.3	t	2026-05-08 00:01:27.547131
5708	2026-02-09 15:00:00	4	23.98	220	4800.2	t	2026-05-08 00:01:27.547131
5709	2026-02-09 15:00:00	7	28.39	220	5071.8	t	2026-05-08 00:01:27.547131
5710	2026-02-09 15:30:00	1	13.35	220	3860.5	t	2026-05-08 00:01:27.547131
5711	2026-02-09 15:30:00	4	19.96	220	4299.2	t	2026-05-08 00:01:27.547131
5712	2026-02-09 15:30:00	7	26.2	220	4593.3	t	2026-05-08 00:01:27.547131
5713	2026-02-09 16:00:00	1	11.73	220	3555.3	t	2026-05-08 00:01:27.547131
5714	2026-02-09 16:00:00	4	21.03	220	4812.1	t	2026-05-08 00:01:27.547131
5715	2026-02-09 16:00:00	7	22.46	220	4807.1	t	2026-05-08 00:01:27.547131
5716	2026-02-09 16:30:00	1	20.71	220	3942.1	t	2026-05-08 00:01:27.547131
5717	2026-02-09 16:30:00	4	20.8	220	3723.5	t	2026-05-08 00:01:27.547131
5718	2026-02-09 16:30:00	7	21	220	6395.8	t	2026-05-08 00:01:27.547131
5719	2026-02-09 17:00:00	1	14.62	220	2555.9	t	2026-05-08 00:01:27.547131
5720	2026-02-09 17:00:00	4	25.34	220	4729.8	t	2026-05-08 00:01:27.547131
5721	2026-02-09 17:00:00	7	29.84	220	6697.5	t	2026-05-08 00:01:27.547131
5722	2026-02-09 17:30:00	1	18.71	220	3706.2	t	2026-05-08 00:01:27.547131
5723	2026-02-09 17:30:00	4	18.22	220	5454.5	t	2026-05-08 00:01:27.547131
5724	2026-02-09 17:30:00	7	24.15	220	4620.9	t	2026-05-08 00:01:27.547131
5725	2026-02-09 18:00:00	1	20.13	220	2591.4	t	2026-05-08 00:01:27.547131
5726	2026-02-09 18:00:00	4	22.74	220	3786.4	t	2026-05-08 00:01:27.547131
5727	2026-02-09 18:00:00	7	21.57	220	4862.8	t	2026-05-08 00:01:27.547131
5728	2026-02-09 18:30:00	1	17.64	220	3977	t	2026-05-08 00:01:27.547131
5729	2026-02-09 18:30:00	4	23.06	220	4257.8	t	2026-05-08 00:01:27.547131
5730	2026-02-09 18:30:00	7	25.47	220	5213.5	t	2026-05-08 00:01:27.547131
5731	2026-02-09 19:00:00	1	16.05	220	2650.6	t	2026-05-08 00:01:27.547131
5732	2026-02-09 19:00:00	4	19.09	220	5582.3	t	2026-05-08 00:01:27.547131
5733	2026-02-09 19:00:00	7	20.97	220	5001.7	t	2026-05-08 00:01:27.547131
5734	2026-02-09 19:30:00	1	17.76	220	3041.7	t	2026-05-08 00:01:27.547131
5735	2026-02-09 19:30:00	4	20.73	220	5714.1	t	2026-05-08 00:01:27.547131
5736	2026-02-09 19:30:00	7	26.36	220	5308.3	t	2026-05-08 00:01:27.547131
5737	2026-02-09 20:00:00	1	1.78	220	405	t	2026-05-08 00:01:27.547131
5738	2026-02-09 20:00:00	4	2.37	220	472.2	t	2026-05-08 00:01:27.547131
5739	2026-02-09 20:00:00	7	2.15	220	471	t	2026-05-08 00:01:27.547131
5740	2026-02-09 20:30:00	1	1.47	220	662.3	t	2026-05-08 00:01:27.547131
5741	2026-02-09 20:30:00	4	3.2	220	525	t	2026-05-08 00:01:27.547131
5742	2026-02-09 20:30:00	7	2.87	220	361.6	t	2026-05-08 00:01:27.547131
5743	2026-02-09 21:00:00	1	3.2	220	339.4	t	2026-05-08 00:01:27.547131
5744	2026-02-09 21:00:00	4	2.57	220	604.9	t	2026-05-08 00:01:27.547131
5745	2026-02-09 21:00:00	7	2.58	220	370.2	t	2026-05-08 00:01:27.547131
5746	2026-02-09 21:30:00	1	2.11	220	325	t	2026-05-08 00:01:27.547131
5747	2026-02-09 21:30:00	4	3.7	220	403.7	t	2026-05-08 00:01:27.547131
5748	2026-02-09 21:30:00	7	3.31	220	333.2	t	2026-05-08 00:01:27.547131
5749	2026-02-09 22:00:00	1	2.27	220	357.3	t	2026-05-08 00:01:27.547131
5750	2026-02-09 22:00:00	4	1.68	220	298.1	t	2026-05-08 00:01:27.547131
5751	2026-02-09 22:00:00	7	1.92	220	644.4	t	2026-05-08 00:01:27.547131
5752	2026-02-09 22:30:00	1	3.39	220	777.7	t	2026-05-08 00:01:27.547131
5753	2026-02-09 22:30:00	4	2.66	220	274.4	t	2026-05-08 00:01:27.547131
5754	2026-02-09 22:30:00	7	2.51	220	528.4	t	2026-05-08 00:01:27.547131
5755	2026-02-09 23:00:00	1	1.68	220	681	t	2026-05-08 00:01:27.547131
5756	2026-02-09 23:00:00	4	2.37	220	595	t	2026-05-08 00:01:27.547131
5757	2026-02-09 23:00:00	7	3.46	220	501.9	t	2026-05-08 00:01:27.547131
5758	2026-02-09 23:30:00	1	2.74	220	546.5	t	2026-05-08 00:01:27.547131
5759	2026-02-09 23:30:00	4	3.58	220	349	t	2026-05-08 00:01:27.547131
5760	2026-02-09 23:30:00	7	1.61	220	677.1	t	2026-05-08 00:01:27.547131
5761	2026-02-10 00:00:00	1	2.05	220	510.7	t	2026-05-08 00:01:27.547131
5762	2026-02-10 00:00:00	4	3.57	220	440	t	2026-05-08 00:01:27.547131
5763	2026-02-10 00:00:00	7	3.53	220	792.4	t	2026-05-08 00:01:27.547131
5764	2026-02-10 00:30:00	1	3.34	220	471.4	t	2026-05-08 00:01:27.547131
5765	2026-02-10 00:30:00	4	2.03	220	640.4	t	2026-05-08 00:01:27.547131
5766	2026-02-10 00:30:00	7	2.05	220	776.3	t	2026-05-08 00:01:27.547131
5767	2026-02-10 01:00:00	1	2.36	220	401.5	t	2026-05-08 00:01:27.547131
5768	2026-02-10 01:00:00	4	3.37	220	592.6	t	2026-05-08 00:01:27.547131
5769	2026-02-10 01:00:00	7	2.55	220	610.5	t	2026-05-08 00:01:27.547131
5770	2026-02-10 01:30:00	1	2.54	220	360.1	t	2026-05-08 00:01:27.547131
5771	2026-02-10 01:30:00	4	3.51	220	351.4	t	2026-05-08 00:01:27.547131
5772	2026-02-10 01:30:00	7	1.94	220	586.8	t	2026-05-08 00:01:27.547131
5773	2026-02-10 02:00:00	1	1.8	220	710.7	t	2026-05-08 00:01:27.547131
5774	2026-02-10 02:00:00	4	2.7	220	672.3	t	2026-05-08 00:01:27.547131
5775	2026-02-10 02:00:00	7	1.75	220	782.7	t	2026-05-08 00:01:27.547131
5776	2026-02-10 02:30:00	1	2.64	220	593.8	t	2026-05-08 00:01:27.547131
5777	2026-02-10 02:30:00	4	2.21	220	543.4	t	2026-05-08 00:01:27.547131
5778	2026-02-10 02:30:00	7	1.57	220	575.4	t	2026-05-08 00:01:27.547131
5779	2026-02-10 03:00:00	1	2.91	220	672.9	t	2026-05-08 00:01:27.547131
5780	2026-02-10 03:00:00	4	3.47	220	534	t	2026-05-08 00:01:27.547131
5781	2026-02-10 03:00:00	7	2.45	220	331.1	t	2026-05-08 00:01:27.547131
5782	2026-02-10 03:30:00	1	3	220	597.8	t	2026-05-08 00:01:27.547131
5783	2026-02-10 03:30:00	4	2.87	220	264.6	t	2026-05-08 00:01:27.547131
5784	2026-02-10 03:30:00	7	1.87	220	616.8	t	2026-05-08 00:01:27.547131
5785	2026-02-10 04:00:00	1	2.35	220	707.8	t	2026-05-08 00:01:27.547131
5786	2026-02-10 04:00:00	4	1.86	220	709.2	t	2026-05-08 00:01:27.547131
5787	2026-02-10 04:00:00	7	3.56	220	788.4	t	2026-05-08 00:01:27.547131
5788	2026-02-10 04:30:00	1	3.14	220	741.9	t	2026-05-08 00:01:27.547131
5789	2026-02-10 04:30:00	4	1.63	220	534.2	t	2026-05-08 00:01:27.547131
5790	2026-02-10 04:30:00	7	1.25	220	557.8	t	2026-05-08 00:01:27.547131
5791	2026-02-10 05:00:00	1	2.19	220	747.5	t	2026-05-08 00:01:27.547131
5792	2026-02-10 05:00:00	4	3.41	220	550.9	t	2026-05-08 00:01:27.547131
5793	2026-02-10 05:00:00	7	1.3	220	603.4	t	2026-05-08 00:01:27.547131
5794	2026-02-10 05:30:00	1	1.76	220	554.2	t	2026-05-08 00:01:27.547131
5795	2026-02-10 05:30:00	4	2	220	307.2	t	2026-05-08 00:01:27.547131
5796	2026-02-10 05:30:00	7	2.72	220	323.7	t	2026-05-08 00:01:27.547131
5797	2026-02-10 06:00:00	1	2.27	220	484.2	t	2026-05-08 00:01:27.547131
5798	2026-02-10 06:00:00	4	2.18	220	388.6	t	2026-05-08 00:01:27.547131
5799	2026-02-10 06:00:00	7	3.67	220	681.9	t	2026-05-08 00:01:27.547131
5800	2026-02-10 06:30:00	1	1.82	220	562.2	t	2026-05-08 00:01:27.547131
5801	2026-02-10 06:30:00	4	3.1	220	503.6	t	2026-05-08 00:01:27.547131
5802	2026-02-10 06:30:00	7	1.77	220	396.3	t	2026-05-08 00:01:27.547131
5803	2026-02-10 07:00:00	1	11.64	220	4449.9	t	2026-05-08 00:01:27.547131
5804	2026-02-10 07:00:00	4	18.99	220	5031.9	t	2026-05-08 00:01:27.547131
5805	2026-02-10 07:00:00	7	28.22	220	5489.4	t	2026-05-08 00:01:27.547131
5806	2026-02-10 07:30:00	1	19.94	220	4614.5	t	2026-05-08 00:01:27.547131
5807	2026-02-10 07:30:00	4	24.67	220	4146.7	t	2026-05-08 00:01:27.547131
5808	2026-02-10 07:30:00	7	28.05	220	5500.3	t	2026-05-08 00:01:27.547131
5809	2026-02-10 08:00:00	1	17.56	220	3319.3	t	2026-05-08 00:01:27.547131
5810	2026-02-10 08:00:00	4	20.92	220	3719.2	t	2026-05-08 00:01:27.547131
5811	2026-02-10 08:00:00	7	29.7	220	4894.2	t	2026-05-08 00:01:27.547131
5812	2026-02-10 08:30:00	1	12.74	220	2958.6	t	2026-05-08 00:01:27.547131
5813	2026-02-10 08:30:00	4	24.94	220	4998.4	t	2026-05-08 00:01:27.547131
5814	2026-02-10 08:30:00	7	22.02	220	4686.5	t	2026-05-08 00:01:27.547131
5815	2026-02-10 09:00:00	1	14.95	220	2562.4	t	2026-05-08 00:01:27.547131
5816	2026-02-10 09:00:00	4	16.26	220	5189.6	t	2026-05-08 00:01:27.547131
5817	2026-02-10 09:00:00	7	30.06	220	5831.4	t	2026-05-08 00:01:27.547131
5818	2026-02-10 09:30:00	1	21.49	220	2920.2	t	2026-05-08 00:01:27.547131
5819	2026-02-10 09:30:00	4	23.02	220	4480.4	t	2026-05-08 00:01:27.547131
5820	2026-02-10 09:30:00	7	27.99	220	5212.8	t	2026-05-08 00:01:27.547131
5821	2026-02-10 10:00:00	1	16.19	220	3919.9	t	2026-05-08 00:01:27.547131
5822	2026-02-10 10:00:00	4	18.73	220	3694.6	t	2026-05-08 00:01:27.547131
5823	2026-02-10 10:00:00	7	25.45	220	6565.6	t	2026-05-08 00:01:27.547131
5824	2026-02-10 10:30:00	1	17.87	220	3632.8	t	2026-05-08 00:01:27.547131
5825	2026-02-10 10:30:00	4	18.18	220	5237.8	t	2026-05-08 00:01:27.547131
5826	2026-02-10 10:30:00	7	28.09	220	4721.2	t	2026-05-08 00:01:27.547131
5827	2026-02-10 11:00:00	1	19.4	220	2646.7	t	2026-05-08 00:01:27.547131
5828	2026-02-10 11:00:00	4	23.56	220	3667.5	t	2026-05-08 00:01:27.547131
5829	2026-02-10 11:00:00	7	23.42	220	4561.5	t	2026-05-08 00:01:27.547131
5830	2026-02-10 11:30:00	1	15.31	220	2729.9	t	2026-05-08 00:01:27.547131
5831	2026-02-10 11:30:00	4	23.84	220	4272	t	2026-05-08 00:01:27.547131
5832	2026-02-10 11:30:00	7	23.42	220	5930.4	t	2026-05-08 00:01:27.547131
5833	2026-02-10 12:00:00	1	12.57	220	3732.9	t	2026-05-08 00:01:27.547131
5834	2026-02-10 12:00:00	4	19.89	220	4851.2	t	2026-05-08 00:01:27.547131
5835	2026-02-10 12:00:00	7	27.65	220	6441.7	t	2026-05-08 00:01:27.547131
5836	2026-02-10 12:30:00	1	15.02	220	2852.7	t	2026-05-08 00:01:27.547131
5837	2026-02-10 12:30:00	4	25.59	220	4925.3	t	2026-05-08 00:01:27.547131
5838	2026-02-10 12:30:00	7	29.31	220	6611.6	t	2026-05-08 00:01:27.547131
5839	2026-02-10 13:00:00	1	18.24	220	3876.5	t	2026-05-08 00:01:27.547131
5840	2026-02-10 13:00:00	4	21.25	220	5490.4	t	2026-05-08 00:01:27.547131
5841	2026-02-10 13:00:00	7	29.69	220	5859.6	t	2026-05-08 00:01:27.547131
5842	2026-02-10 13:30:00	1	15.26	220	3756.2	t	2026-05-08 00:01:27.547131
5843	2026-02-10 13:30:00	4	21.33	220	4431.7	t	2026-05-08 00:01:27.547131
5844	2026-02-10 13:30:00	7	22.64	220	5246.2	t	2026-05-08 00:01:27.547131
5845	2026-02-10 14:00:00	1	13.63	220	3660.8	t	2026-05-08 00:01:27.547131
5846	2026-02-10 14:00:00	4	18.98	220	3872.3	t	2026-05-08 00:01:27.547131
5847	2026-02-10 14:00:00	7	26.38	220	5478.5	t	2026-05-08 00:01:27.547131
5848	2026-02-10 14:30:00	1	16.81	220	3773.6	t	2026-05-08 00:01:27.547131
5849	2026-02-10 14:30:00	4	23.47	220	4755.8	t	2026-05-08 00:01:27.547131
5850	2026-02-10 14:30:00	7	22.62	220	5858.5	t	2026-05-08 00:01:27.547131
5851	2026-02-10 15:00:00	1	12.92	220	3785.9	t	2026-05-08 00:01:27.547131
5852	2026-02-10 15:00:00	4	17.07	220	5226.6	t	2026-05-08 00:01:27.547131
5853	2026-02-10 15:00:00	7	24.95	220	5680.9	t	2026-05-08 00:01:27.547131
5854	2026-02-10 15:30:00	1	16.2	220	2746	t	2026-05-08 00:01:27.547131
5855	2026-02-10 15:30:00	4	18.92	220	5576.1	t	2026-05-08 00:01:27.547131
5856	2026-02-10 15:30:00	7	21.72	220	5254.8	t	2026-05-08 00:01:27.547131
5857	2026-02-10 16:00:00	1	15.69	220	2892.6	t	2026-05-08 00:01:27.547131
5858	2026-02-10 16:00:00	4	17.12	220	3895.5	t	2026-05-08 00:01:27.547131
5859	2026-02-10 16:00:00	7	20.99	220	6490.2	t	2026-05-08 00:01:27.547131
5860	2026-02-10 16:30:00	1	12.13	220	2959.7	t	2026-05-08 00:01:27.547131
5861	2026-02-10 16:30:00	4	24.99	220	3979.7	t	2026-05-08 00:01:27.547131
5862	2026-02-10 16:30:00	7	26.28	220	4730.8	t	2026-05-08 00:01:27.547131
5863	2026-02-10 17:00:00	1	20.73	220	3536.1	t	2026-05-08 00:01:27.547131
5864	2026-02-10 17:00:00	4	21.35	220	5243.5	t	2026-05-08 00:01:27.547131
5865	2026-02-10 17:00:00	7	25.1	220	5438.8	t	2026-05-08 00:01:27.547131
5866	2026-02-10 17:30:00	1	18.81	220	3958.4	t	2026-05-08 00:01:27.547131
5867	2026-02-10 17:30:00	4	24.35	220	3857.7	t	2026-05-08 00:01:27.547131
5868	2026-02-10 17:30:00	7	27.4	220	5972.9	t	2026-05-08 00:01:27.547131
5869	2026-02-10 18:00:00	1	16.53	220	4675.8	t	2026-05-08 00:01:27.547131
5870	2026-02-10 18:00:00	4	25.43	220	5037.3	t	2026-05-08 00:01:27.547131
5871	2026-02-10 18:00:00	7	29.46	220	6136.9	t	2026-05-08 00:01:27.547131
5872	2026-02-10 18:30:00	1	16.74	220	4294.6	t	2026-05-08 00:01:27.547131
5873	2026-02-10 18:30:00	4	24.47	220	4077.4	t	2026-05-08 00:01:27.547131
5874	2026-02-10 18:30:00	7	26.9	220	6201	t	2026-05-08 00:01:27.547131
5875	2026-02-10 19:00:00	1	18.36	220	3842.5	t	2026-05-08 00:01:27.547131
5876	2026-02-10 19:00:00	4	24.75	220	3732.5	t	2026-05-08 00:01:27.547131
5877	2026-02-10 19:00:00	7	29.08	220	4516.6	t	2026-05-08 00:01:27.547131
5878	2026-02-10 19:30:00	1	17.32	220	4093.3	t	2026-05-08 00:01:27.547131
5879	2026-02-10 19:30:00	4	18.32	220	4851.4	t	2026-05-08 00:01:27.547131
5880	2026-02-10 19:30:00	7	22.09	220	5863	t	2026-05-08 00:01:27.547131
5881	2026-02-10 20:00:00	1	2.09	220	520.2	t	2026-05-08 00:01:27.547131
5882	2026-02-10 20:00:00	4	2.18	220	664.3	t	2026-05-08 00:01:27.547131
5883	2026-02-10 20:00:00	7	2.8	220	690.3	t	2026-05-08 00:01:27.547131
5884	2026-02-10 20:30:00	1	2.35	220	289.2	t	2026-05-08 00:01:27.547131
5885	2026-02-10 20:30:00	4	2.19	220	468.4	t	2026-05-08 00:01:27.547131
5886	2026-02-10 20:30:00	7	2.44	220	378	t	2026-05-08 00:01:27.547131
5887	2026-02-10 21:00:00	1	1.83	220	708.7	t	2026-05-08 00:01:27.547131
5888	2026-02-10 21:00:00	4	2.26	220	413.5	t	2026-05-08 00:01:27.547131
5889	2026-02-10 21:00:00	7	3.5	220	450.2	t	2026-05-08 00:01:27.547131
5890	2026-02-10 21:30:00	1	2.28	220	427.5	t	2026-05-08 00:01:27.547131
5891	2026-02-10 21:30:00	4	3.6	220	429.7	t	2026-05-08 00:01:27.547131
5892	2026-02-10 21:30:00	7	1.38	220	532.8	t	2026-05-08 00:01:27.547131
5893	2026-02-10 22:00:00	1	2.22	220	413.6	t	2026-05-08 00:01:27.547131
5894	2026-02-10 22:00:00	4	2.96	220	265.5	t	2026-05-08 00:01:27.547131
5895	2026-02-10 22:00:00	7	1.45	220	693.8	t	2026-05-08 00:01:27.547131
5896	2026-02-10 22:30:00	1	3.41	220	712.5	t	2026-05-08 00:01:27.547131
5897	2026-02-10 22:30:00	4	1.28	220	311.8	t	2026-05-08 00:01:27.547131
5898	2026-02-10 22:30:00	7	2.83	220	410.2	t	2026-05-08 00:01:27.547131
5899	2026-02-10 23:00:00	1	1.79	220	777.1	t	2026-05-08 00:01:27.547131
5900	2026-02-10 23:00:00	4	2.23	220	651.9	t	2026-05-08 00:01:27.547131
5901	2026-02-10 23:00:00	7	2.43	220	653.8	t	2026-05-08 00:01:27.547131
5902	2026-02-10 23:30:00	1	3.01	220	584.8	t	2026-05-08 00:01:27.547131
5903	2026-02-10 23:30:00	4	3.49	220	336	t	2026-05-08 00:01:27.547131
5904	2026-02-10 23:30:00	7	2.23	220	316.9	t	2026-05-08 00:01:27.547131
5905	2026-02-11 00:00:00	1	1.46	220	265.7	t	2026-05-08 00:01:27.547131
5906	2026-02-11 00:00:00	4	3.39	220	353.1	t	2026-05-08 00:01:27.547131
5907	2026-02-11 00:00:00	7	1.64	220	747.6	t	2026-05-08 00:01:27.547131
5908	2026-02-11 00:30:00	1	3.32	220	727.3	t	2026-05-08 00:01:27.547131
5909	2026-02-11 00:30:00	4	2.17	220	596.7	t	2026-05-08 00:01:27.547131
5910	2026-02-11 00:30:00	7	2.2	220	643.3	t	2026-05-08 00:01:27.547131
5911	2026-02-11 01:00:00	1	2.99	220	265.2	t	2026-05-08 00:01:27.547131
5912	2026-02-11 01:00:00	4	3.13	220	678.2	t	2026-05-08 00:01:27.547131
5913	2026-02-11 01:00:00	7	3.36	220	680.5	t	2026-05-08 00:01:27.547131
5914	2026-02-11 01:30:00	1	2.71	220	812.6	t	2026-05-08 00:01:27.547131
5915	2026-02-11 01:30:00	4	1.57	220	290.4	t	2026-05-08 00:01:27.547131
5916	2026-02-11 01:30:00	7	2.73	220	651.1	t	2026-05-08 00:01:27.547131
5917	2026-02-11 02:00:00	1	1.23	220	423.2	t	2026-05-08 00:01:27.547131
5918	2026-02-11 02:00:00	4	2.54	220	609.8	t	2026-05-08 00:01:27.547131
5919	2026-02-11 02:00:00	7	3.03	220	545.2	t	2026-05-08 00:01:27.547131
5920	2026-02-11 02:30:00	1	2.63	220	600.4	t	2026-05-08 00:01:27.547131
5921	2026-02-11 02:30:00	4	1.38	220	354.9	t	2026-05-08 00:01:27.547131
5922	2026-02-11 02:30:00	7	1.61	220	682.5	t	2026-05-08 00:01:27.547131
5923	2026-02-11 03:00:00	1	2.43	220	525.4	t	2026-05-08 00:01:27.547131
5924	2026-02-11 03:00:00	4	2.14	220	799.3	t	2026-05-08 00:01:27.547131
5925	2026-02-11 03:00:00	7	1.28	220	702.9	t	2026-05-08 00:01:27.547131
5926	2026-02-11 03:30:00	1	2.45	220	705.4	t	2026-05-08 00:01:27.547131
5927	2026-02-11 03:30:00	4	1.96	220	379.8	t	2026-05-08 00:01:27.547131
5928	2026-02-11 03:30:00	7	1.53	220	693.9	t	2026-05-08 00:01:27.547131
5929	2026-02-11 04:00:00	1	2.89	220	697.5	t	2026-05-08 00:01:27.547131
5930	2026-02-11 04:00:00	4	3.23	220	529.9	t	2026-05-08 00:01:27.547131
5931	2026-02-11 04:00:00	7	3.5	220	350	t	2026-05-08 00:01:27.547131
5932	2026-02-11 04:30:00	1	1.58	220	599.7	t	2026-05-08 00:01:27.547131
5933	2026-02-11 04:30:00	4	3.67	220	613.5	t	2026-05-08 00:01:27.547131
5934	2026-02-11 04:30:00	7	1.68	220	792.8	t	2026-05-08 00:01:27.547131
5935	2026-02-11 05:00:00	1	2.38	220	499.5	t	2026-05-08 00:01:27.547131
5936	2026-02-11 05:00:00	4	3.34	220	783.4	t	2026-05-08 00:01:27.547131
5937	2026-02-11 05:00:00	7	3.37	220	490.5	t	2026-05-08 00:01:27.547131
5938	2026-02-11 05:30:00	1	3.2	220	381.1	t	2026-05-08 00:01:27.547131
5939	2026-02-11 05:30:00	4	1.31	220	563.4	t	2026-05-08 00:01:27.547131
5940	2026-02-11 05:30:00	7	2.4	220	368.5	t	2026-05-08 00:01:27.547131
5941	2026-02-11 06:00:00	1	3.63	220	288.1	t	2026-05-08 00:01:27.547131
5942	2026-02-11 06:00:00	4	2.06	220	567.1	t	2026-05-08 00:01:27.547131
5943	2026-02-11 06:00:00	7	3.64	220	777.7	t	2026-05-08 00:01:27.547131
5944	2026-02-11 06:30:00	1	3.39	220	756.7	t	2026-05-08 00:01:27.547131
5945	2026-02-11 06:30:00	4	2.46	220	731.7	t	2026-05-08 00:01:27.547131
5946	2026-02-11 06:30:00	7	2.13	220	642.9	t	2026-05-08 00:01:27.547131
5947	2026-02-11 07:00:00	1	12.21	220	2731.9	t	2026-05-08 00:01:27.547131
5948	2026-02-11 07:00:00	4	20.59	220	4195.8	t	2026-05-08 00:01:27.547131
5949	2026-02-11 07:00:00	7	21	220	6359.2	t	2026-05-08 00:01:27.547131
5950	2026-02-11 07:30:00	1	21.41	220	3221.5	t	2026-05-08 00:01:27.547131
5951	2026-02-11 07:30:00	4	19.25	220	3739.8	t	2026-05-08 00:01:27.547131
5952	2026-02-11 07:30:00	7	26.21	220	4878.8	t	2026-05-08 00:01:27.547131
5953	2026-02-11 08:00:00	1	13.24	220	2928.8	t	2026-05-08 00:01:27.547131
5954	2026-02-11 08:00:00	4	18.75	220	3544	t	2026-05-08 00:01:27.547131
5955	2026-02-11 08:00:00	7	23.88	220	6106.5	t	2026-05-08 00:01:27.547131
5956	2026-02-11 08:30:00	1	20.6	220	2687.8	t	2026-05-08 00:01:27.547131
5957	2026-02-11 08:30:00	4	23.02	220	4226.1	t	2026-05-08 00:01:27.547131
5958	2026-02-11 08:30:00	7	29.65	220	5648.7	t	2026-05-08 00:01:27.547131
5959	2026-02-11 09:00:00	1	20.67	220	3865.8	t	2026-05-08 00:01:27.547131
5960	2026-02-11 09:00:00	4	25.94	220	4998.7	t	2026-05-08 00:01:27.547131
5961	2026-02-11 09:00:00	7	21.67	220	5870.6	t	2026-05-08 00:01:27.547131
5962	2026-02-11 09:30:00	1	17.3	220	3051	t	2026-05-08 00:01:27.547131
5963	2026-02-11 09:30:00	4	18.34	220	5528.5	t	2026-05-08 00:01:27.547131
5964	2026-02-11 09:30:00	7	29.53	220	5181.6	t	2026-05-08 00:01:27.547131
5965	2026-02-11 10:00:00	1	17.78	220	3011.9	t	2026-05-08 00:01:27.547131
5966	2026-02-11 10:00:00	4	22.11	220	5197.1	t	2026-05-08 00:01:27.547131
5967	2026-02-11 10:00:00	7	25.46	220	6409.4	t	2026-05-08 00:01:27.547131
5968	2026-02-11 10:30:00	1	17.88	220	4430.8	t	2026-05-08 00:01:27.547131
5969	2026-02-11 10:30:00	4	21.8	220	3853.6	t	2026-05-08 00:01:27.547131
5970	2026-02-11 10:30:00	7	25.09	220	6071.8	t	2026-05-08 00:01:27.547131
5971	2026-02-11 11:00:00	1	16.27	220	4054.1	t	2026-05-08 00:01:27.547131
5972	2026-02-11 11:00:00	4	25.4	220	4481.2	t	2026-05-08 00:01:27.547131
5973	2026-02-11 11:00:00	7	26.26	220	5589.4	t	2026-05-08 00:01:27.547131
5974	2026-02-11 11:30:00	1	20.96	220	4450.8	t	2026-05-08 00:01:27.547131
5975	2026-02-11 11:30:00	4	19.82	220	4626	t	2026-05-08 00:01:27.547131
5976	2026-02-11 11:30:00	7	24.1	220	6251.7	t	2026-05-08 00:01:27.547131
5977	2026-02-11 12:00:00	1	17.9	220	4671.1	t	2026-05-08 00:01:27.547131
5978	2026-02-11 12:00:00	4	23.15	220	4894.4	t	2026-05-08 00:01:27.547131
5979	2026-02-11 12:00:00	7	28.04	220	5075.6	t	2026-05-08 00:01:27.547131
5980	2026-02-11 12:30:00	1	18.06	220	3185.1	t	2026-05-08 00:01:27.547131
5981	2026-02-11 12:30:00	4	24.71	220	3884.5	t	2026-05-08 00:01:27.547131
5982	2026-02-11 12:30:00	7	21.7	220	5802.8	t	2026-05-08 00:01:27.547131
5983	2026-02-11 13:00:00	1	12.81	220	2854.7	t	2026-05-08 00:01:27.547131
5984	2026-02-11 13:00:00	4	23.32	220	4998.3	t	2026-05-08 00:01:27.547131
5985	2026-02-11 13:00:00	7	23.31	220	5786.3	t	2026-05-08 00:01:27.547131
5986	2026-02-11 13:30:00	1	17	220	3835.4	t	2026-05-08 00:01:27.547131
5987	2026-02-11 13:30:00	4	21.78	220	5023.7	t	2026-05-08 00:01:27.547131
5988	2026-02-11 13:30:00	7	24.15	220	5996.7	t	2026-05-08 00:01:27.547131
5989	2026-02-11 14:00:00	1	12.15	220	2819.7	t	2026-05-08 00:01:27.547131
5990	2026-02-11 14:00:00	4	23.1	220	4487.2	t	2026-05-08 00:01:27.547131
5991	2026-02-11 14:00:00	7	24.07	220	5152.2	t	2026-05-08 00:01:27.547131
5992	2026-02-11 14:30:00	1	13.33	220	3798.7	t	2026-05-08 00:01:27.547131
5993	2026-02-11 14:30:00	4	16.33	220	3656.8	t	2026-05-08 00:01:27.547131
5994	2026-02-11 14:30:00	7	28.2	220	5677.8	t	2026-05-08 00:01:27.547131
5995	2026-02-11 15:00:00	1	17.79	220	3765.9	t	2026-05-08 00:01:27.547131
5996	2026-02-11 15:00:00	4	18.91	220	5471.5	t	2026-05-08 00:01:27.547131
5997	2026-02-11 15:00:00	7	24.47	220	5211.7	t	2026-05-08 00:01:27.547131
5998	2026-02-11 15:30:00	1	15.35	220	4200.9	t	2026-05-08 00:01:27.547131
5999	2026-02-11 15:30:00	4	24.67	220	3574.5	t	2026-05-08 00:01:27.547131
6000	2026-02-11 15:30:00	7	29.94	220	5016.1	t	2026-05-08 00:01:27.547131
6001	2026-02-11 16:00:00	1	16.61	220	3067.8	t	2026-05-08 00:01:27.547131
6002	2026-02-11 16:00:00	4	24.72	220	3521.8	t	2026-05-08 00:01:27.547131
6003	2026-02-11 16:00:00	7	21.92	220	5781.8	t	2026-05-08 00:01:27.547131
6004	2026-02-11 16:30:00	1	20.11	220	3474.5	t	2026-05-08 00:01:27.547131
6005	2026-02-11 16:30:00	4	16.78	220	3758.4	t	2026-05-08 00:01:27.547131
6006	2026-02-11 16:30:00	7	29.52	220	5731.5	t	2026-05-08 00:01:27.547131
6007	2026-02-11 17:00:00	1	12.66	220	4391.6	t	2026-05-08 00:01:27.547131
6008	2026-02-11 17:00:00	4	25.43	220	3903.2	t	2026-05-08 00:01:27.547131
6009	2026-02-11 17:00:00	7	25.04	220	5310	t	2026-05-08 00:01:27.547131
6010	2026-02-11 17:30:00	1	20.58	220	2626.2	t	2026-05-08 00:01:27.547131
6011	2026-02-11 17:30:00	4	23.78	220	4834.2	t	2026-05-08 00:01:27.547131
6012	2026-02-11 17:30:00	7	22.74	220	6325.8	t	2026-05-08 00:01:27.547131
6013	2026-02-11 18:00:00	1	19.68	220	2544.2	t	2026-05-08 00:01:27.547131
6014	2026-02-11 18:00:00	4	20.4	220	4890.6	t	2026-05-08 00:01:27.547131
6015	2026-02-11 18:00:00	7	24.52	220	5237.8	t	2026-05-08 00:01:27.547131
6016	2026-02-11 18:30:00	1	11.59	220	3621.1	t	2026-05-08 00:01:27.547131
6017	2026-02-11 18:30:00	4	18.01	220	5631.3	t	2026-05-08 00:01:27.547131
6018	2026-02-11 18:30:00	7	24.25	220	6336.3	t	2026-05-08 00:01:27.547131
6019	2026-02-11 19:00:00	1	21.49	220	3979.2	t	2026-05-08 00:01:27.547131
6020	2026-02-11 19:00:00	4	20.12	220	5253.8	t	2026-05-08 00:01:27.547131
6021	2026-02-11 19:00:00	7	23.57	220	5793.7	t	2026-05-08 00:01:27.547131
6022	2026-02-11 19:30:00	1	17.53	220	4293.9	t	2026-05-08 00:01:27.547131
6023	2026-02-11 19:30:00	4	22.57	220	3925.5	t	2026-05-08 00:01:27.547131
6024	2026-02-11 19:30:00	7	21.11	220	5410.6	t	2026-05-08 00:01:27.547131
6025	2026-02-11 20:00:00	1	1.45	220	352	t	2026-05-08 00:01:27.547131
6026	2026-02-11 20:00:00	4	1.43	220	610.2	t	2026-05-08 00:01:27.547131
6027	2026-02-11 20:00:00	7	2.36	220	438.5	t	2026-05-08 00:01:27.547131
6028	2026-02-11 20:30:00	1	2	220	277.5	t	2026-05-08 00:01:27.547131
6029	2026-02-11 20:30:00	4	2.13	220	335.8	t	2026-05-08 00:01:27.547131
6030	2026-02-11 20:30:00	7	1.46	220	444.6	t	2026-05-08 00:01:27.547131
6031	2026-02-11 21:00:00	1	2.45	220	536.9	t	2026-05-08 00:01:27.547131
6032	2026-02-11 21:00:00	4	3.52	220	809.6	t	2026-05-08 00:01:27.547131
6033	2026-02-11 21:00:00	7	2.36	220	414.7	t	2026-05-08 00:01:27.547131
6034	2026-02-11 21:30:00	1	2.18	220	632.4	t	2026-05-08 00:01:27.547131
6035	2026-02-11 21:30:00	4	2.49	220	389.6	t	2026-05-08 00:01:27.547131
6036	2026-02-11 21:30:00	7	2.27	220	736.4	t	2026-05-08 00:01:27.547131
6037	2026-02-11 22:00:00	1	1.51	220	396.7	t	2026-05-08 00:01:27.547131
6038	2026-02-11 22:00:00	4	1.25	220	343.2	t	2026-05-08 00:01:27.547131
6039	2026-02-11 22:00:00	7	3.56	220	667.4	t	2026-05-08 00:01:27.547131
6040	2026-02-11 22:30:00	1	1.43	220	650.6	t	2026-05-08 00:01:27.547131
6041	2026-02-11 22:30:00	4	1.22	220	371	t	2026-05-08 00:01:27.547131
6042	2026-02-11 22:30:00	7	2.38	220	409.3	t	2026-05-08 00:01:27.547131
6043	2026-02-11 23:00:00	1	2.35	220	281.1	t	2026-05-08 00:01:27.547131
6044	2026-02-11 23:00:00	4	2.12	220	588.3	t	2026-05-08 00:01:27.547131
6045	2026-02-11 23:00:00	7	2.39	220	724.9	t	2026-05-08 00:01:27.547131
6046	2026-02-11 23:30:00	1	2.05	220	378.5	t	2026-05-08 00:01:27.547131
6047	2026-02-11 23:30:00	4	3.16	220	480	t	2026-05-08 00:01:27.547131
6048	2026-02-11 23:30:00	7	1.88	220	588.2	t	2026-05-08 00:01:27.547131
6049	2026-02-12 00:00:00	1	1.31	220	339.9	t	2026-05-08 00:01:27.547131
6050	2026-02-12 00:00:00	4	1.22	220	434.8	t	2026-05-08 00:01:27.547131
6051	2026-02-12 00:00:00	7	2.02	220	462	t	2026-05-08 00:01:27.547131
6052	2026-02-12 00:30:00	1	1.24	220	647.7	t	2026-05-08 00:01:27.547131
6053	2026-02-12 00:30:00	4	1.99	220	283.4	t	2026-05-08 00:01:27.547131
6054	2026-02-12 00:30:00	7	1.95	220	538	t	2026-05-08 00:01:27.547131
6055	2026-02-12 01:00:00	1	2.93	220	519.5	t	2026-05-08 00:01:27.547131
6056	2026-02-12 01:00:00	4	2.94	220	490.6	t	2026-05-08 00:01:27.547131
6057	2026-02-12 01:00:00	7	2.6	220	626.4	t	2026-05-08 00:01:27.547131
6058	2026-02-12 01:30:00	1	2.02	220	385.1	t	2026-05-08 00:01:27.547131
6059	2026-02-12 01:30:00	4	2.01	220	461	t	2026-05-08 00:01:27.547131
6060	2026-02-12 01:30:00	7	2.24	220	683.4	t	2026-05-08 00:01:27.547131
6061	2026-02-12 02:00:00	1	2.89	220	672.2	t	2026-05-08 00:01:27.547131
6062	2026-02-12 02:00:00	4	1.75	220	670.5	t	2026-05-08 00:01:27.547131
6063	2026-02-12 02:00:00	7	2.43	220	448.2	t	2026-05-08 00:01:27.547131
6064	2026-02-12 02:30:00	1	1.99	220	318.4	t	2026-05-08 00:01:27.547131
6065	2026-02-12 02:30:00	4	1.94	220	755.3	t	2026-05-08 00:01:27.547131
6066	2026-02-12 02:30:00	7	2.6	220	524.9	t	2026-05-08 00:01:27.547131
6067	2026-02-12 03:00:00	1	3.23	220	423.1	t	2026-05-08 00:01:27.547131
6068	2026-02-12 03:00:00	4	3.41	220	467.8	t	2026-05-08 00:01:27.547131
6069	2026-02-12 03:00:00	7	1.23	220	772.4	t	2026-05-08 00:01:27.547131
6070	2026-02-12 03:30:00	1	2.78	220	365	t	2026-05-08 00:01:27.547131
6071	2026-02-12 03:30:00	4	1.83	220	389.3	t	2026-05-08 00:01:27.547131
6072	2026-02-12 03:30:00	7	3.05	220	308	t	2026-05-08 00:01:27.547131
6073	2026-02-12 04:00:00	1	3.61	220	612.3	t	2026-05-08 00:01:27.547131
6074	2026-02-12 04:00:00	4	1.68	220	550.4	t	2026-05-08 00:01:27.547131
6075	2026-02-12 04:00:00	7	2.58	220	441	t	2026-05-08 00:01:27.547131
6076	2026-02-12 04:30:00	1	3.63	220	317.7	t	2026-05-08 00:01:27.547131
6077	2026-02-12 04:30:00	4	2.45	220	626.3	t	2026-05-08 00:01:27.547131
6078	2026-02-12 04:30:00	7	1.23	220	606	t	2026-05-08 00:01:27.547131
6079	2026-02-12 05:00:00	1	3.28	220	290.6	t	2026-05-08 00:01:27.547131
6080	2026-02-12 05:00:00	4	1.57	220	431.2	t	2026-05-08 00:01:27.547131
6081	2026-02-12 05:00:00	7	3.26	220	684.5	t	2026-05-08 00:01:27.547131
6082	2026-02-12 05:30:00	1	2.09	220	656.1	t	2026-05-08 00:01:27.547131
6083	2026-02-12 05:30:00	4	2.93	220	401.8	t	2026-05-08 00:01:27.547131
6084	2026-02-12 05:30:00	7	1.55	220	772.7	t	2026-05-08 00:01:27.547131
6085	2026-02-12 06:00:00	1	2.96	220	664.7	t	2026-05-08 00:01:27.547131
6086	2026-02-12 06:00:00	4	2.08	220	536.8	t	2026-05-08 00:01:27.547131
6087	2026-02-12 06:00:00	7	2.93	220	555.6	t	2026-05-08 00:01:27.547131
6088	2026-02-12 06:30:00	1	1.49	220	548.8	t	2026-05-08 00:01:27.547131
6089	2026-02-12 06:30:00	4	1.87	220	499.1	t	2026-05-08 00:01:27.547131
6090	2026-02-12 06:30:00	7	2.07	220	438.5	t	2026-05-08 00:01:27.547131
6091	2026-02-12 07:00:00	1	19.09	220	4606.2	t	2026-05-08 00:01:27.547131
6092	2026-02-12 07:00:00	4	17.17	220	5697.6	t	2026-05-08 00:01:27.547131
6093	2026-02-12 07:00:00	7	23.73	220	5375.1	t	2026-05-08 00:01:27.547131
6094	2026-02-12 07:30:00	1	19.44	220	3114	t	2026-05-08 00:01:27.547131
6095	2026-02-12 07:30:00	4	23.16	220	4784.3	t	2026-05-08 00:01:27.547131
6096	2026-02-12 07:30:00	7	29.66	220	5529.3	t	2026-05-08 00:01:27.547131
6097	2026-02-12 08:00:00	1	19.01	220	2891.5	t	2026-05-08 00:01:27.547131
6098	2026-02-12 08:00:00	4	23.8	220	3795.4	t	2026-05-08 00:01:27.547131
6099	2026-02-12 08:00:00	7	24.03	220	5229.3	t	2026-05-08 00:01:27.547131
6100	2026-02-12 08:30:00	1	11.84	220	3823.6	t	2026-05-08 00:01:27.547131
6101	2026-02-12 08:30:00	4	17.2	220	3649.8	t	2026-05-08 00:01:27.547131
6102	2026-02-12 08:30:00	7	25.68	220	4978.5	t	2026-05-08 00:01:27.547131
6103	2026-02-12 09:00:00	1	12.7	220	4434.1	t	2026-05-08 00:01:27.547131
6104	2026-02-12 09:00:00	4	21.36	220	5308.4	t	2026-05-08 00:01:27.547131
6105	2026-02-12 09:00:00	7	22.89	220	6374.3	t	2026-05-08 00:01:27.547131
6106	2026-02-12 09:30:00	1	20.92	220	3964.5	t	2026-05-08 00:01:27.547131
6107	2026-02-12 09:30:00	4	16.3	220	4750.3	t	2026-05-08 00:01:27.547131
6108	2026-02-12 09:30:00	7	26.01	220	5541.6	t	2026-05-08 00:01:27.547131
6109	2026-02-12 10:00:00	1	17.3	220	3752.3	t	2026-05-08 00:01:27.547131
6110	2026-02-12 10:00:00	4	22.86	220	5202.3	t	2026-05-08 00:01:27.547131
6111	2026-02-12 10:00:00	7	24.46	220	6062.4	t	2026-05-08 00:01:27.547131
6112	2026-02-12 10:30:00	1	12.87	220	4239.9	t	2026-05-08 00:01:27.547131
6113	2026-02-12 10:30:00	4	24.81	220	4661.2	t	2026-05-08 00:01:27.547131
6114	2026-02-12 10:30:00	7	27.15	220	4921.4	t	2026-05-08 00:01:27.547131
6115	2026-02-12 11:00:00	1	12.51	220	4403	t	2026-05-08 00:01:27.547131
6116	2026-02-12 11:00:00	4	18.09	220	5344.8	t	2026-05-08 00:01:27.547131
6117	2026-02-12 11:00:00	7	27.46	220	4640	t	2026-05-08 00:01:27.547131
6118	2026-02-12 11:30:00	1	19.24	220	3122.9	t	2026-05-08 00:01:27.547131
6119	2026-02-12 11:30:00	4	20.05	220	4771.2	t	2026-05-08 00:01:27.547131
6120	2026-02-12 11:30:00	7	23.11	220	6523.9	t	2026-05-08 00:01:27.547131
6121	2026-02-12 12:00:00	1	21.44	220	4662.1	t	2026-05-08 00:01:27.547131
6122	2026-02-12 12:00:00	4	18.32	220	4124.9	t	2026-05-08 00:01:27.547131
6123	2026-02-12 12:00:00	7	22.07	220	4925.7	t	2026-05-08 00:01:27.547131
6124	2026-02-12 12:30:00	1	14.39	220	3695.6	t	2026-05-08 00:01:27.547131
6125	2026-02-12 12:30:00	4	24.34	220	5532.1	t	2026-05-08 00:01:27.547131
6126	2026-02-12 12:30:00	7	23.9	220	4589.7	t	2026-05-08 00:01:27.547131
6127	2026-02-12 13:00:00	1	17.43	220	3409.3	t	2026-05-08 00:01:27.547131
6128	2026-02-12 13:00:00	4	16.29	220	5367.7	t	2026-05-08 00:01:27.547131
6129	2026-02-12 13:00:00	7	25.01	220	6252.9	t	2026-05-08 00:01:27.547131
6130	2026-02-12 13:30:00	1	20.4	220	4165.1	t	2026-05-08 00:01:27.547131
6131	2026-02-12 13:30:00	4	24.59	220	4901.7	t	2026-05-08 00:01:27.547131
6132	2026-02-12 13:30:00	7	24.25	220	5898.4	t	2026-05-08 00:01:27.547131
6133	2026-02-12 14:00:00	1	15.61	220	2764.5	t	2026-05-08 00:01:27.547131
6134	2026-02-12 14:00:00	4	24.26	220	4621.4	t	2026-05-08 00:01:27.547131
6135	2026-02-12 14:00:00	7	24.84	220	6035.1	t	2026-05-08 00:01:27.547131
6136	2026-02-12 14:30:00	1	12.75	220	4180.3	t	2026-05-08 00:01:27.547131
6137	2026-02-12 14:30:00	4	17.34	220	5079.4	t	2026-05-08 00:01:27.547131
6138	2026-02-12 14:30:00	7	26.1	220	5283.3	t	2026-05-08 00:01:27.547131
6139	2026-02-12 15:00:00	1	15.81	220	3632.6	t	2026-05-08 00:01:27.547131
6140	2026-02-12 15:00:00	4	23.22	220	4017.6	t	2026-05-08 00:01:27.547131
6141	2026-02-12 15:00:00	7	23.95	220	5774.6	t	2026-05-08 00:01:27.547131
6142	2026-02-12 15:30:00	1	17.72	220	3053.7	t	2026-05-08 00:01:27.547131
6143	2026-02-12 15:30:00	4	17	220	5161.7	t	2026-05-08 00:01:27.547131
6144	2026-02-12 15:30:00	7	29.29	220	5834.8	t	2026-05-08 00:01:27.547131
6145	2026-02-12 16:00:00	1	16.87	220	3649.9	t	2026-05-08 00:01:27.547131
6146	2026-02-12 16:00:00	4	24.87	220	4793.1	t	2026-05-08 00:01:27.547131
6147	2026-02-12 16:00:00	7	30.26	220	5115	t	2026-05-08 00:01:27.547131
6148	2026-02-12 16:30:00	1	13.46	220	3742.3	t	2026-05-08 00:01:27.547131
6149	2026-02-12 16:30:00	4	17.56	220	3588	t	2026-05-08 00:01:27.547131
6150	2026-02-12 16:30:00	7	24.04	220	5412.4	t	2026-05-08 00:01:27.547131
6151	2026-02-12 17:00:00	1	12.88	220	3280	t	2026-05-08 00:01:27.547131
6152	2026-02-12 17:00:00	4	25.34	220	5524.2	t	2026-05-08 00:01:27.547131
6153	2026-02-12 17:00:00	7	28.93	220	6426.8	t	2026-05-08 00:01:27.547131
6154	2026-02-12 17:30:00	1	19.61	220	3633.7	t	2026-05-08 00:01:27.547131
6155	2026-02-12 17:30:00	4	20.06	220	3541.7	t	2026-05-08 00:01:27.547131
6156	2026-02-12 17:30:00	7	24.04	220	5514.9	t	2026-05-08 00:01:27.547131
6157	2026-02-12 18:00:00	1	18.62	220	3080.5	t	2026-05-08 00:01:27.547131
6158	2026-02-12 18:00:00	4	23.04	220	5671.2	t	2026-05-08 00:01:27.547131
6159	2026-02-12 18:00:00	7	23.14	220	5240.3	t	2026-05-08 00:01:27.547131
6160	2026-02-12 18:30:00	1	20.76	220	3875.3	t	2026-05-08 00:01:27.547131
6161	2026-02-12 18:30:00	4	24.2	220	3852.1	t	2026-05-08 00:01:27.547131
6162	2026-02-12 18:30:00	7	21.51	220	4864.4	t	2026-05-08 00:01:27.547131
6163	2026-02-12 19:00:00	1	14.15	220	2878.1	t	2026-05-08 00:01:27.547131
6164	2026-02-12 19:00:00	4	21.08	220	4691.8	t	2026-05-08 00:01:27.547131
6165	2026-02-12 19:00:00	7	22.76	220	6210	t	2026-05-08 00:01:27.547131
6166	2026-02-12 19:30:00	1	12.6	220	2755.3	t	2026-05-08 00:01:27.547131
6167	2026-02-12 19:30:00	4	25.02	220	4530.2	t	2026-05-08 00:01:27.547131
6168	2026-02-12 19:30:00	7	28.36	220	6664.8	t	2026-05-08 00:01:27.547131
6169	2026-02-12 20:00:00	1	2.85	220	653.8	t	2026-05-08 00:01:27.547131
6170	2026-02-12 20:00:00	4	1.98	220	553.1	t	2026-05-08 00:01:27.547131
6171	2026-02-12 20:00:00	7	1.98	220	663.9	t	2026-05-08 00:01:27.547131
6172	2026-02-12 20:30:00	1	2.36	220	733.5	t	2026-05-08 00:01:27.547131
6173	2026-02-12 20:30:00	4	2.81	220	581.6	t	2026-05-08 00:01:27.547131
6174	2026-02-12 20:30:00	7	1.58	220	607.9	t	2026-05-08 00:01:27.547131
6175	2026-02-12 21:00:00	1	2.4	220	630.9	t	2026-05-08 00:01:27.547131
6176	2026-02-12 21:00:00	4	3.33	220	320.1	t	2026-05-08 00:01:27.547131
6177	2026-02-12 21:00:00	7	1.27	220	319.9	t	2026-05-08 00:01:27.547131
6178	2026-02-12 21:30:00	1	2.85	220	660.8	t	2026-05-08 00:01:27.547131
6179	2026-02-12 21:30:00	4	1.34	220	566.7	t	2026-05-08 00:01:27.547131
6180	2026-02-12 21:30:00	7	1.54	220	602.5	t	2026-05-08 00:01:27.547131
6181	2026-02-12 22:00:00	1	2.9	220	383.1	t	2026-05-08 00:01:27.547131
6182	2026-02-12 22:00:00	4	2.24	220	635.6	t	2026-05-08 00:01:27.547131
6183	2026-02-12 22:00:00	7	2.31	220	761.4	t	2026-05-08 00:01:27.547131
6184	2026-02-12 22:30:00	1	2.72	220	534.8	t	2026-05-08 00:01:27.547131
6185	2026-02-12 22:30:00	4	3.51	220	353.8	t	2026-05-08 00:01:27.547131
6186	2026-02-12 22:30:00	7	2.36	220	356	t	2026-05-08 00:01:27.547131
6187	2026-02-12 23:00:00	1	3.01	220	383	t	2026-05-08 00:01:27.547131
6188	2026-02-12 23:00:00	4	1.6	220	413.2	t	2026-05-08 00:01:27.547131
6189	2026-02-12 23:00:00	7	2.34	220	509	t	2026-05-08 00:01:27.547131
6190	2026-02-12 23:30:00	1	2.78	220	610.2	t	2026-05-08 00:01:27.547131
6191	2026-02-12 23:30:00	4	3.53	220	398.2	t	2026-05-08 00:01:27.547131
6192	2026-02-12 23:30:00	7	3.26	220	553.7	t	2026-05-08 00:01:27.547131
6193	2026-02-13 00:00:00	1	2.09	220	707.5	t	2026-05-08 00:01:27.547131
6194	2026-02-13 00:00:00	4	3.16	220	415	t	2026-05-08 00:01:27.547131
6195	2026-02-13 00:00:00	7	1.88	220	715.5	t	2026-05-08 00:01:27.547131
6196	2026-02-13 00:30:00	1	1.82	220	662.8	t	2026-05-08 00:01:27.547131
6197	2026-02-13 00:30:00	4	2.15	220	667.1	t	2026-05-08 00:01:27.547131
6198	2026-02-13 00:30:00	7	1.78	220	742.1	t	2026-05-08 00:01:27.547131
6199	2026-02-13 01:00:00	1	1.6	220	363.1	t	2026-05-08 00:01:27.547131
6200	2026-02-13 01:00:00	4	3.42	220	804.2	t	2026-05-08 00:01:27.547131
6201	2026-02-13 01:00:00	7	3.25	220	775.9	t	2026-05-08 00:01:27.547131
6202	2026-02-13 01:30:00	1	3.06	220	326.5	t	2026-05-08 00:01:27.547131
6203	2026-02-13 01:30:00	4	3.33	220	528.4	t	2026-05-08 00:01:27.547131
6204	2026-02-13 01:30:00	7	3.37	220	786.1	t	2026-05-08 00:01:27.547131
6205	2026-02-13 02:00:00	1	2.08	220	411.8	t	2026-05-08 00:01:27.547131
6206	2026-02-13 02:00:00	4	3.06	220	448.1	t	2026-05-08 00:01:27.547131
6207	2026-02-13 02:00:00	7	2.35	220	661.3	t	2026-05-08 00:01:27.547131
6208	2026-02-13 02:30:00	1	2.15	220	734.1	t	2026-05-08 00:01:27.547131
6209	2026-02-13 02:30:00	4	1.56	220	557.3	t	2026-05-08 00:01:27.547131
6210	2026-02-13 02:30:00	7	2.53	220	664.1	t	2026-05-08 00:01:27.547131
6211	2026-02-13 03:00:00	1	1.47	220	379.2	t	2026-05-08 00:01:27.547131
6212	2026-02-13 03:00:00	4	1.24	220	312.7	t	2026-05-08 00:01:27.547131
6213	2026-02-13 03:00:00	7	1.82	220	302.9	t	2026-05-08 00:01:27.547131
6214	2026-02-13 03:30:00	1	1.93	220	596.1	t	2026-05-08 00:01:27.547131
6215	2026-02-13 03:30:00	4	1.26	220	406.9	t	2026-05-08 00:01:27.547131
6216	2026-02-13 03:30:00	7	3.2	220	464.6	t	2026-05-08 00:01:27.547131
6217	2026-02-13 04:00:00	1	2.44	220	482	t	2026-05-08 00:01:27.547131
6218	2026-02-13 04:00:00	4	3.65	220	485.1	t	2026-05-08 00:01:27.547131
6219	2026-02-13 04:00:00	7	2.84	220	407.1	t	2026-05-08 00:01:27.547131
6220	2026-02-13 04:30:00	1	2.16	220	631	t	2026-05-08 00:01:27.547131
6221	2026-02-13 04:30:00	4	1.64	220	690.1	t	2026-05-08 00:01:27.547131
6222	2026-02-13 04:30:00	7	3.18	220	483.4	t	2026-05-08 00:01:27.547131
6223	2026-02-13 05:00:00	1	2.79	220	804.2	t	2026-05-08 00:01:27.547131
6224	2026-02-13 05:00:00	4	2.12	220	577.1	t	2026-05-08 00:01:27.547131
6225	2026-02-13 05:00:00	7	1.75	220	392.9	t	2026-05-08 00:01:27.547131
6226	2026-02-13 05:30:00	1	3.11	220	741.3	t	2026-05-08 00:01:27.547131
6227	2026-02-13 05:30:00	4	3.48	220	276.2	t	2026-05-08 00:01:27.547131
6228	2026-02-13 05:30:00	7	2.31	220	399.8	t	2026-05-08 00:01:27.547131
6229	2026-02-13 06:00:00	1	1.63	220	296.4	t	2026-05-08 00:01:27.547131
6230	2026-02-13 06:00:00	4	3.27	220	480.6	t	2026-05-08 00:01:27.547131
6231	2026-02-13 06:00:00	7	1.57	220	273.5	t	2026-05-08 00:01:27.547131
6232	2026-02-13 06:30:00	1	1.78	220	593.3	t	2026-05-08 00:01:27.547131
6233	2026-02-13 06:30:00	4	1.87	220	370.2	t	2026-05-08 00:01:27.547131
6234	2026-02-13 06:30:00	7	3.3	220	569.2	t	2026-05-08 00:01:27.547131
6235	2026-02-13 07:00:00	1	20.07	220	4293.5	t	2026-05-08 00:01:27.547131
6236	2026-02-13 07:00:00	4	23.59	220	4841.1	t	2026-05-08 00:01:27.547131
6237	2026-02-13 07:00:00	7	24.21	220	4685	t	2026-05-08 00:01:27.547131
6238	2026-02-13 07:30:00	1	15.02	220	3523.5	t	2026-05-08 00:01:27.547131
6239	2026-02-13 07:30:00	4	16.39	220	4003.7	t	2026-05-08 00:01:27.547131
6240	2026-02-13 07:30:00	7	21.08	220	4953.7	t	2026-05-08 00:01:27.547131
6241	2026-02-13 08:00:00	1	19.7	220	2686.7	t	2026-05-08 00:01:27.547131
6242	2026-02-13 08:00:00	4	18.58	220	5525.2	t	2026-05-08 00:01:27.547131
6243	2026-02-13 08:00:00	7	30.13	220	6052.9	t	2026-05-08 00:01:27.547131
6244	2026-02-13 08:30:00	1	11.53	220	3676.4	t	2026-05-08 00:01:27.547131
6245	2026-02-13 08:30:00	4	25.75	220	5611.1	t	2026-05-08 00:01:27.547131
6246	2026-02-13 08:30:00	7	26.28	220	5259.9	t	2026-05-08 00:01:27.547131
6247	2026-02-13 09:00:00	1	14.88	220	4048.9	t	2026-05-08 00:01:27.547131
6248	2026-02-13 09:00:00	4	18.42	220	4568.6	t	2026-05-08 00:01:27.547131
6249	2026-02-13 09:00:00	7	26.87	220	6622.9	t	2026-05-08 00:01:27.547131
6250	2026-02-13 09:30:00	1	14.31	220	3252.1	t	2026-05-08 00:01:27.547131
6251	2026-02-13 09:30:00	4	16.48	220	4801.7	t	2026-05-08 00:01:27.547131
6252	2026-02-13 09:30:00	7	28.89	220	6335	t	2026-05-08 00:01:27.547131
6253	2026-02-13 10:00:00	1	14.39	220	3871.5	t	2026-05-08 00:01:27.547131
6254	2026-02-13 10:00:00	4	25.14	220	3909.9	t	2026-05-08 00:01:27.547131
6255	2026-02-13 10:00:00	7	22.27	220	6687.9	t	2026-05-08 00:01:27.547131
6256	2026-02-13 10:30:00	1	17.9	220	4071.8	t	2026-05-08 00:01:27.547131
6257	2026-02-13 10:30:00	4	22.36	220	4990.7	t	2026-05-08 00:01:27.547131
6258	2026-02-13 10:30:00	7	20.74	220	5838.9	t	2026-05-08 00:01:27.547131
6259	2026-02-13 11:00:00	1	14.16	220	4455	t	2026-05-08 00:01:27.547131
6260	2026-02-13 11:00:00	4	20.12	220	3754.5	t	2026-05-08 00:01:27.547131
6261	2026-02-13 11:00:00	7	30.42	220	5342.9	t	2026-05-08 00:01:27.547131
6262	2026-02-13 11:30:00	1	19.99	220	3001.8	t	2026-05-08 00:01:27.547131
6263	2026-02-13 11:30:00	4	21.9	220	3983.4	t	2026-05-08 00:01:27.547131
6264	2026-02-13 11:30:00	7	28.01	220	4527.6	t	2026-05-08 00:01:27.547131
6265	2026-02-13 12:00:00	1	16.16	220	2642	t	2026-05-08 00:01:27.547131
6266	2026-02-13 12:00:00	4	17.55	220	4643.2	t	2026-05-08 00:01:27.547131
6267	2026-02-13 12:00:00	7	29.92	220	4549.6	t	2026-05-08 00:01:27.547131
6268	2026-02-13 12:30:00	1	14.63	220	4160.7	t	2026-05-08 00:01:27.547131
6269	2026-02-13 12:30:00	4	19.93	220	5215.8	t	2026-05-08 00:01:27.547131
6270	2026-02-13 12:30:00	7	26.63	220	5593.4	t	2026-05-08 00:01:27.547131
6271	2026-02-13 13:00:00	1	19.55	220	4430.2	t	2026-05-08 00:01:27.547131
6272	2026-02-13 13:00:00	4	25.06	220	4137.4	t	2026-05-08 00:01:27.547131
6273	2026-02-13 13:00:00	7	21.84	220	4883.9	t	2026-05-08 00:01:27.547131
6274	2026-02-13 13:30:00	1	15.77	220	3800.5	t	2026-05-08 00:01:27.547131
6275	2026-02-13 13:30:00	4	25.69	220	5087.8	t	2026-05-08 00:01:27.547131
6276	2026-02-13 13:30:00	7	30.15	220	4764.2	t	2026-05-08 00:01:27.547131
6277	2026-02-13 14:00:00	1	12.57	220	4605.5	t	2026-05-08 00:01:27.547131
6278	2026-02-13 14:00:00	4	20.73	220	5681.8	t	2026-05-08 00:01:27.547131
6279	2026-02-13 14:00:00	7	29.99	220	6671.7	t	2026-05-08 00:01:27.547131
6280	2026-02-13 14:30:00	1	13.06	220	4220.1	t	2026-05-08 00:01:27.547131
6281	2026-02-13 14:30:00	4	24.38	220	3580.8	t	2026-05-08 00:01:27.547131
6282	2026-02-13 14:30:00	7	24.84	220	5032.2	t	2026-05-08 00:01:27.547131
6283	2026-02-13 15:00:00	1	19.79	220	3885.8	t	2026-05-08 00:01:27.547131
6284	2026-02-13 15:00:00	4	19.3	220	5037.4	t	2026-05-08 00:01:27.547131
6285	2026-02-13 15:00:00	7	26.4	220	4941.2	t	2026-05-08 00:01:27.547131
6286	2026-02-13 15:30:00	1	12.59	220	3336.3	t	2026-05-08 00:01:27.547131
6287	2026-02-13 15:30:00	4	19.27	220	4395.6	t	2026-05-08 00:01:27.547131
6288	2026-02-13 15:30:00	7	20.52	220	5801.1	t	2026-05-08 00:01:27.547131
6289	2026-02-13 16:00:00	1	12.64	220	3658.4	t	2026-05-08 00:01:27.547131
6290	2026-02-13 16:00:00	4	20.34	220	4570.9	t	2026-05-08 00:01:27.547131
6291	2026-02-13 16:00:00	7	28.68	220	5679.3	t	2026-05-08 00:01:27.547131
6292	2026-02-13 16:30:00	1	14.21	220	4521.7	t	2026-05-08 00:01:27.547131
6293	2026-02-13 16:30:00	4	21.89	220	4336.4	t	2026-05-08 00:01:27.547131
6294	2026-02-13 16:30:00	7	25.36	220	4650.3	t	2026-05-08 00:01:27.547131
6295	2026-02-13 17:00:00	1	16.5	220	3346.1	t	2026-05-08 00:01:27.547131
6296	2026-02-13 17:00:00	4	24.24	220	4044.2	t	2026-05-08 00:01:27.547131
6297	2026-02-13 17:00:00	7	20.57	220	5194.6	t	2026-05-08 00:01:27.547131
6298	2026-02-13 17:30:00	1	12.44	220	3508.8	t	2026-05-08 00:01:27.547131
6299	2026-02-13 17:30:00	4	17.51	220	4227.8	t	2026-05-08 00:01:27.547131
6300	2026-02-13 17:30:00	7	26.6	220	4907.4	t	2026-05-08 00:01:27.547131
6301	2026-02-13 18:00:00	1	11.62	220	3879.7	t	2026-05-08 00:01:27.547131
6302	2026-02-13 18:00:00	4	24.54	220	3825.6	t	2026-05-08 00:01:27.547131
6303	2026-02-13 18:00:00	7	28.23	220	6149	t	2026-05-08 00:01:27.547131
6304	2026-02-13 18:30:00	1	20.1	220	4020.7	t	2026-05-08 00:01:27.547131
6305	2026-02-13 18:30:00	4	18.06	220	4085.5	t	2026-05-08 00:01:27.547131
6306	2026-02-13 18:30:00	7	26.42	220	4794.1	t	2026-05-08 00:01:27.547131
6307	2026-02-13 19:00:00	1	20.09	220	2818	t	2026-05-08 00:01:27.547131
6308	2026-02-13 19:00:00	4	22.91	220	4333.6	t	2026-05-08 00:01:27.547131
6309	2026-02-13 19:00:00	7	22.73	220	5510.5	t	2026-05-08 00:01:27.547131
6310	2026-02-13 19:30:00	1	16.19	220	4085.4	t	2026-05-08 00:01:27.547131
6311	2026-02-13 19:30:00	4	22.41	220	5591.8	t	2026-05-08 00:01:27.547131
6312	2026-02-13 19:30:00	7	30.24	220	6487.8	t	2026-05-08 00:01:27.547131
6313	2026-02-13 20:00:00	1	3.34	220	351.5	t	2026-05-08 00:01:27.547131
6314	2026-02-13 20:00:00	4	3.33	220	667.6	t	2026-05-08 00:01:27.547131
6315	2026-02-13 20:00:00	7	2.21	220	579.2	t	2026-05-08 00:01:27.547131
6316	2026-02-13 20:30:00	1	2.42	220	436.2	t	2026-05-08 00:01:27.547131
6317	2026-02-13 20:30:00	4	1.45	220	489	t	2026-05-08 00:01:27.547131
6318	2026-02-13 20:30:00	7	1.76	220	331.3	t	2026-05-08 00:01:27.547131
6319	2026-02-13 21:00:00	1	2.01	220	560.7	t	2026-05-08 00:01:27.547131
6320	2026-02-13 21:00:00	4	1.61	220	346.8	t	2026-05-08 00:01:27.547131
6321	2026-02-13 21:00:00	7	2.17	220	774.3	t	2026-05-08 00:01:27.547131
6322	2026-02-13 21:30:00	1	1.38	220	479.6	t	2026-05-08 00:01:27.547131
6323	2026-02-13 21:30:00	4	2.63	220	691.2	t	2026-05-08 00:01:27.547131
6324	2026-02-13 21:30:00	7	2.76	220	511.1	t	2026-05-08 00:01:27.547131
6325	2026-02-13 22:00:00	1	2.42	220	567.7	t	2026-05-08 00:01:27.547131
6326	2026-02-13 22:00:00	4	2.8	220	466.6	t	2026-05-08 00:01:27.547131
6327	2026-02-13 22:00:00	7	2.63	220	711.1	t	2026-05-08 00:01:27.547131
6328	2026-02-13 22:30:00	1	1.38	220	319.9	t	2026-05-08 00:01:27.547131
6329	2026-02-13 22:30:00	4	2.9	220	394.6	t	2026-05-08 00:01:27.547131
6330	2026-02-13 22:30:00	7	2.32	220	731.5	t	2026-05-08 00:01:27.547131
6331	2026-02-13 23:00:00	1	2.27	220	724.9	t	2026-05-08 00:01:27.547131
6332	2026-02-13 23:00:00	4	2.95	220	517.3	t	2026-05-08 00:01:27.547131
6333	2026-02-13 23:00:00	7	1.54	220	397.6	t	2026-05-08 00:01:27.547131
6334	2026-02-13 23:30:00	1	2.5	220	747.9	t	2026-05-08 00:01:27.547131
6335	2026-02-13 23:30:00	4	2.67	220	721.8	t	2026-05-08 00:01:27.547131
6336	2026-02-13 23:30:00	7	1.95	220	809.8	t	2026-05-08 00:01:27.547131
6337	2026-02-14 00:00:00	1	2	220	488.9	t	2026-05-08 00:01:27.547131
6338	2026-02-14 00:00:00	4	1.31	220	596.6	t	2026-05-08 00:01:27.547131
6339	2026-02-14 00:00:00	7	1.45	220	583.1	t	2026-05-08 00:01:27.547131
6340	2026-02-14 00:30:00	1	1.81	220	238	t	2026-05-08 00:01:27.547131
6341	2026-02-14 00:30:00	4	2.2	220	404.2	t	2026-05-08 00:01:27.547131
6342	2026-02-14 00:30:00	7	1.44	220	473.4	t	2026-05-08 00:01:27.547131
6343	2026-02-14 01:00:00	1	2.72	220	440.9	t	2026-05-08 00:01:27.547131
6344	2026-02-14 01:00:00	4	2.96	220	546.6	t	2026-05-08 00:01:27.547131
6345	2026-02-14 01:00:00	7	2.61	220	264.2	t	2026-05-08 00:01:27.547131
6346	2026-02-14 01:30:00	1	1.71	220	481.2	t	2026-05-08 00:01:27.547131
6347	2026-02-14 01:30:00	4	1.6	220	508.8	t	2026-05-08 00:01:27.547131
6348	2026-02-14 01:30:00	7	1.2	220	597.5	t	2026-05-08 00:01:27.547131
6349	2026-02-14 02:00:00	1	1.07	220	477	t	2026-05-08 00:01:27.547131
6350	2026-02-14 02:00:00	4	2.61	220	550.9	t	2026-05-08 00:01:27.547131
6351	2026-02-14 02:00:00	7	2.37	220	536.5	t	2026-05-08 00:01:27.547131
6352	2026-02-14 02:30:00	1	2.9	220	480.3	t	2026-05-08 00:01:27.547131
6353	2026-02-14 02:30:00	4	2.9	220	420.6	t	2026-05-08 00:01:27.547131
6354	2026-02-14 02:30:00	7	1.51	220	287.2	t	2026-05-08 00:01:27.547131
6355	2026-02-14 03:00:00	1	2.07	220	633.3	t	2026-05-08 00:01:27.547131
6356	2026-02-14 03:00:00	4	2.44	220	449	t	2026-05-08 00:01:27.547131
6357	2026-02-14 03:00:00	7	1.88	220	588.1	t	2026-05-08 00:01:27.547131
6358	2026-02-14 03:30:00	1	2.43	220	631.8	t	2026-05-08 00:01:27.547131
6359	2026-02-14 03:30:00	4	2.71	220	233.7	t	2026-05-08 00:01:27.547131
6360	2026-02-14 03:30:00	7	1.4	220	573.6	t	2026-05-08 00:01:27.547131
6361	2026-02-14 04:00:00	1	2.27	220	549.6	t	2026-05-08 00:01:27.547131
6362	2026-02-14 04:00:00	4	2.58	220	423.8	t	2026-05-08 00:01:27.547131
6363	2026-02-14 04:00:00	7	1.54	220	359.7	t	2026-05-08 00:01:27.547131
6364	2026-02-14 04:30:00	1	1.08	220	437	t	2026-05-08 00:01:27.547131
6365	2026-02-14 04:30:00	4	1.57	220	403.7	t	2026-05-08 00:01:27.547131
6366	2026-02-14 04:30:00	7	1.8	220	401	t	2026-05-08 00:01:27.547131
6367	2026-02-14 05:00:00	1	2.39	220	568.1	t	2026-05-08 00:01:27.547131
6368	2026-02-14 05:00:00	4	1.1	220	422.4	t	2026-05-08 00:01:27.547131
6369	2026-02-14 05:00:00	7	2.77	220	250.3	t	2026-05-08 00:01:27.547131
6370	2026-02-14 05:30:00	1	2.07	220	298.1	t	2026-05-08 00:01:27.547131
6371	2026-02-14 05:30:00	4	2.61	220	355.6	t	2026-05-08 00:01:27.547131
6372	2026-02-14 05:30:00	7	2.16	220	481.9	t	2026-05-08 00:01:27.547131
6373	2026-02-14 06:00:00	1	2.45	220	461.4	t	2026-05-08 00:01:27.547131
6374	2026-02-14 06:00:00	4	1.78	220	361.8	t	2026-05-08 00:01:27.547131
6375	2026-02-14 06:00:00	7	2.32	220	414.9	t	2026-05-08 00:01:27.547131
6376	2026-02-14 06:30:00	1	2.85	220	383.8	t	2026-05-08 00:01:27.547131
6377	2026-02-14 06:30:00	4	1.82	220	504.6	t	2026-05-08 00:01:27.547131
6378	2026-02-14 06:30:00	7	1.58	220	636.4	t	2026-05-08 00:01:27.547131
6379	2026-02-14 07:00:00	1	1.12	220	495.4	t	2026-05-08 00:01:27.547131
6380	2026-02-14 07:00:00	4	2.25	220	448.2	t	2026-05-08 00:01:27.547131
6381	2026-02-14 07:00:00	7	2.5	220	538.3	t	2026-05-08 00:01:27.547131
6382	2026-02-14 07:30:00	1	1.25	220	277.7	t	2026-05-08 00:01:27.547131
6383	2026-02-14 07:30:00	4	1.38	220	459.2	t	2026-05-08 00:01:27.547131
6384	2026-02-14 07:30:00	7	1.26	220	404.8	t	2026-05-08 00:01:27.547131
6385	2026-02-14 08:00:00	1	1.14	220	401.4	t	2026-05-08 00:01:27.547131
6386	2026-02-14 08:00:00	4	1.1	220	232.5	t	2026-05-08 00:01:27.547131
6387	2026-02-14 08:00:00	7	2.91	220	557.5	t	2026-05-08 00:01:27.547131
6388	2026-02-14 08:30:00	1	2.64	220	512	t	2026-05-08 00:01:27.547131
6389	2026-02-14 08:30:00	4	1.58	220	472.5	t	2026-05-08 00:01:27.547131
6390	2026-02-14 08:30:00	7	1.08	220	265.9	t	2026-05-08 00:01:27.547131
6391	2026-02-14 09:00:00	1	2.72	220	259.9	t	2026-05-08 00:01:27.547131
6392	2026-02-14 09:00:00	4	1.04	220	528.7	t	2026-05-08 00:01:27.547131
6393	2026-02-14 09:00:00	7	1.19	220	558.1	t	2026-05-08 00:01:27.547131
6394	2026-02-14 09:30:00	1	2.73	220	266.2	t	2026-05-08 00:01:27.547131
6395	2026-02-14 09:30:00	4	2.93	220	322	t	2026-05-08 00:01:27.547131
6396	2026-02-14 09:30:00	7	1.56	220	565.7	t	2026-05-08 00:01:27.547131
6397	2026-02-14 10:00:00	1	2.08	220	354.7	t	2026-05-08 00:01:27.547131
6398	2026-02-14 10:00:00	4	1.58	220	332.4	t	2026-05-08 00:01:27.547131
6399	2026-02-14 10:00:00	7	2.73	220	220.4	t	2026-05-08 00:01:27.547131
6400	2026-02-14 10:30:00	1	2.22	220	543.6	t	2026-05-08 00:01:27.547131
6401	2026-02-14 10:30:00	4	2.75	220	292.6	t	2026-05-08 00:01:27.547131
6402	2026-02-14 10:30:00	7	2.06	220	653.7	t	2026-05-08 00:01:27.547131
6403	2026-02-14 11:00:00	1	1.24	220	506.2	t	2026-05-08 00:01:27.547131
6404	2026-02-14 11:00:00	4	1.71	220	444.8	t	2026-05-08 00:01:27.547131
6405	2026-02-14 11:00:00	7	2.67	220	526.5	t	2026-05-08 00:01:27.547131
6406	2026-02-14 11:30:00	1	2.33	220	318.4	t	2026-05-08 00:01:27.547131
6407	2026-02-14 11:30:00	4	2.39	220	654.2	t	2026-05-08 00:01:27.547131
6408	2026-02-14 11:30:00	7	1.84	220	286.7	t	2026-05-08 00:01:27.547131
6409	2026-02-14 12:00:00	1	1.31	220	420.3	t	2026-05-08 00:01:27.547131
6410	2026-02-14 12:00:00	4	2.64	220	615.9	t	2026-05-08 00:01:27.547131
6411	2026-02-14 12:00:00	7	2.32	220	370.3	t	2026-05-08 00:01:27.547131
6412	2026-02-14 12:30:00	1	1.28	220	347.2	t	2026-05-08 00:01:27.547131
6413	2026-02-14 12:30:00	4	2.77	220	306.5	t	2026-05-08 00:01:27.547131
6414	2026-02-14 12:30:00	7	1.15	220	580.6	t	2026-05-08 00:01:27.547131
6415	2026-02-14 13:00:00	1	1.95	220	486	t	2026-05-08 00:01:27.547131
6416	2026-02-14 13:00:00	4	1.99	220	465.1	t	2026-05-08 00:01:27.547131
6417	2026-02-14 13:00:00	7	1.38	220	506.1	t	2026-05-08 00:01:27.547131
6418	2026-02-14 13:30:00	1	2.07	220	594.3	t	2026-05-08 00:01:27.547131
6419	2026-02-14 13:30:00	4	2.86	220	285	t	2026-05-08 00:01:27.547131
6420	2026-02-14 13:30:00	7	2	220	515.9	t	2026-05-08 00:01:27.547131
6421	2026-02-14 14:00:00	1	2.2	220	330.9	t	2026-05-08 00:01:27.547131
6422	2026-02-14 14:00:00	4	1.28	220	581.7	t	2026-05-08 00:01:27.547131
6423	2026-02-14 14:00:00	7	2.91	220	472.7	t	2026-05-08 00:01:27.547131
6424	2026-02-14 14:30:00	1	1.66	220	465.4	t	2026-05-08 00:01:27.547131
6425	2026-02-14 14:30:00	4	1.09	220	444.8	t	2026-05-08 00:01:27.547131
6426	2026-02-14 14:30:00	7	2.46	220	633.8	t	2026-05-08 00:01:27.547131
6427	2026-02-14 15:00:00	1	1.65	220	631.4	t	2026-05-08 00:01:27.547131
6428	2026-02-14 15:00:00	4	1.31	220	484.3	t	2026-05-08 00:01:27.547131
6429	2026-02-14 15:00:00	7	1.44	220	474.4	t	2026-05-08 00:01:27.547131
6430	2026-02-14 15:30:00	1	1.94	220	372.4	t	2026-05-08 00:01:27.547131
6431	2026-02-14 15:30:00	4	2.65	220	298.2	t	2026-05-08 00:01:27.547131
6432	2026-02-14 15:30:00	7	1.44	220	514.5	t	2026-05-08 00:01:27.547131
6433	2026-02-14 16:00:00	1	2.76	220	259.5	t	2026-05-08 00:01:27.547131
6434	2026-02-14 16:00:00	4	2.17	220	293.9	t	2026-05-08 00:01:27.547131
6435	2026-02-14 16:00:00	7	2.1	220	595.2	t	2026-05-08 00:01:27.547131
6436	2026-02-14 16:30:00	1	2.15	220	318.4	t	2026-05-08 00:01:27.547131
6437	2026-02-14 16:30:00	4	2.42	220	639.7	t	2026-05-08 00:01:27.547131
6438	2026-02-14 16:30:00	7	1.63	220	620.7	t	2026-05-08 00:01:27.547131
6439	2026-02-14 17:00:00	1	1.44	220	539.4	t	2026-05-08 00:01:27.547131
6440	2026-02-14 17:00:00	4	1.59	220	356.5	t	2026-05-08 00:01:27.547131
6441	2026-02-14 17:00:00	7	1.62	220	605	t	2026-05-08 00:01:27.547131
6442	2026-02-14 17:30:00	1	1.95	220	266.8	t	2026-05-08 00:01:27.547131
6443	2026-02-14 17:30:00	4	1.55	220	383	t	2026-05-08 00:01:27.547131
6444	2026-02-14 17:30:00	7	2.09	220	390.7	t	2026-05-08 00:01:27.547131
6445	2026-02-14 18:00:00	1	1.67	220	491.3	t	2026-05-08 00:01:27.547131
6446	2026-02-14 18:00:00	4	2.7	220	430.1	t	2026-05-08 00:01:27.547131
6447	2026-02-14 18:00:00	7	2.37	220	600.7	t	2026-05-08 00:01:27.547131
6448	2026-02-14 18:30:00	1	2.19	220	585	t	2026-05-08 00:01:27.547131
6449	2026-02-14 18:30:00	4	1.02	220	612.2	t	2026-05-08 00:01:27.547131
6450	2026-02-14 18:30:00	7	2.8	220	528.2	t	2026-05-08 00:01:27.547131
6451	2026-02-14 19:00:00	1	1.3	220	355.3	t	2026-05-08 00:01:27.547131
6452	2026-02-14 19:00:00	4	2.62	220	468.8	t	2026-05-08 00:01:27.547131
6453	2026-02-14 19:00:00	7	2.47	220	366	t	2026-05-08 00:01:27.547131
6454	2026-02-14 19:30:00	1	2.93	220	295.6	t	2026-05-08 00:01:27.547131
6455	2026-02-14 19:30:00	4	2.96	220	531.9	t	2026-05-08 00:01:27.547131
6456	2026-02-14 19:30:00	7	2.21	220	234.6	t	2026-05-08 00:01:27.547131
6457	2026-02-14 20:00:00	1	2.86	220	522.8	t	2026-05-08 00:01:27.547131
6458	2026-02-14 20:00:00	4	1.99	220	576.6	t	2026-05-08 00:01:27.547131
6459	2026-02-14 20:00:00	7	1.71	220	260.6	t	2026-05-08 00:01:27.547131
6460	2026-02-14 20:30:00	1	2.43	220	542.7	t	2026-05-08 00:01:27.547131
6461	2026-02-14 20:30:00	4	2.38	220	584.6	t	2026-05-08 00:01:27.547131
6462	2026-02-14 20:30:00	7	1.65	220	475.7	t	2026-05-08 00:01:27.547131
6463	2026-02-14 21:00:00	1	2.53	220	567.2	t	2026-05-08 00:01:27.547131
6464	2026-02-14 21:00:00	4	2.06	220	288.8	t	2026-05-08 00:01:27.547131
6465	2026-02-14 21:00:00	7	2.43	220	632	t	2026-05-08 00:01:27.547131
6466	2026-02-14 21:30:00	1	1.98	220	589	t	2026-05-08 00:01:27.547131
6467	2026-02-14 21:30:00	4	1.4	220	311.9	t	2026-05-08 00:01:27.547131
6468	2026-02-14 21:30:00	7	1.66	220	311.4	t	2026-05-08 00:01:27.547131
6469	2026-02-14 22:00:00	1	1.83	220	533.9	t	2026-05-08 00:01:27.547131
6470	2026-02-14 22:00:00	4	1.08	220	506.4	t	2026-05-08 00:01:27.547131
6471	2026-02-14 22:00:00	7	2.05	220	286.8	t	2026-05-08 00:01:27.547131
6472	2026-02-14 22:30:00	1	1.35	220	479.2	t	2026-05-08 00:01:27.547131
6473	2026-02-14 22:30:00	4	2.1	220	417	t	2026-05-08 00:01:27.547131
6474	2026-02-14 22:30:00	7	2.28	220	534.6	t	2026-05-08 00:01:27.547131
6475	2026-02-14 23:00:00	1	2.04	220	621.6	t	2026-05-08 00:01:27.547131
6476	2026-02-14 23:00:00	4	2.33	220	455.1	t	2026-05-08 00:01:27.547131
6477	2026-02-14 23:00:00	7	2.17	220	324.3	t	2026-05-08 00:01:27.547131
6478	2026-02-14 23:30:00	1	2.05	220	377.3	t	2026-05-08 00:01:27.547131
6479	2026-02-14 23:30:00	4	2.55	220	326.3	t	2026-05-08 00:01:27.547131
6480	2026-02-14 23:30:00	7	2.25	220	345.7	t	2026-05-08 00:01:27.547131
6481	2026-02-15 00:00:00	1	2.19	220	309.5	t	2026-05-08 00:01:27.547131
6482	2026-02-15 00:00:00	4	1.41	220	597.6	t	2026-05-08 00:01:27.547131
6483	2026-02-15 00:00:00	7	1.88	220	574.7	t	2026-05-08 00:01:27.547131
6484	2026-02-15 00:30:00	1	1.53	220	609.6	t	2026-05-08 00:01:27.547131
6485	2026-02-15 00:30:00	4	2.34	220	415.7	t	2026-05-08 00:01:27.547131
6486	2026-02-15 00:30:00	7	2.21	220	524.1	t	2026-05-08 00:01:27.547131
6487	2026-02-15 01:00:00	1	2.63	220	613.2	t	2026-05-08 00:01:27.547131
6488	2026-02-15 01:00:00	4	1.88	220	593.9	t	2026-05-08 00:01:27.547131
6489	2026-02-15 01:00:00	7	2.5	220	283.3	t	2026-05-08 00:01:27.547131
6490	2026-02-15 01:30:00	1	1.3	220	519.4	t	2026-05-08 00:01:27.547131
6491	2026-02-15 01:30:00	4	2.83	220	572.4	t	2026-05-08 00:01:27.547131
6492	2026-02-15 01:30:00	7	2.09	220	632.7	t	2026-05-08 00:01:27.547131
6493	2026-02-15 02:00:00	1	2.57	220	427.9	t	2026-05-08 00:01:27.547131
6494	2026-02-15 02:00:00	4	1.06	220	376.9	t	2026-05-08 00:01:27.547131
6495	2026-02-15 02:00:00	7	2.14	220	400.5	t	2026-05-08 00:01:27.547131
6496	2026-02-15 02:30:00	1	3	220	388.6	t	2026-05-08 00:01:27.547131
6497	2026-02-15 02:30:00	4	1.11	220	234.4	t	2026-05-08 00:01:27.547131
6498	2026-02-15 02:30:00	7	1.23	220	615.8	t	2026-05-08 00:01:27.547131
6499	2026-02-15 03:00:00	1	1.67	220	342.5	t	2026-05-08 00:01:27.547131
6500	2026-02-15 03:00:00	4	2.97	220	500.1	t	2026-05-08 00:01:27.547131
6501	2026-02-15 03:00:00	7	1.64	220	546.7	t	2026-05-08 00:01:27.547131
6502	2026-02-15 03:30:00	1	1.97	220	469.9	t	2026-05-08 00:01:27.547131
6503	2026-02-15 03:30:00	4	2.62	220	609.3	t	2026-05-08 00:01:27.547131
6504	2026-02-15 03:30:00	7	2.98	220	257.3	t	2026-05-08 00:01:27.547131
6505	2026-02-15 04:00:00	1	1.22	220	513.2	t	2026-05-08 00:01:27.547131
6506	2026-02-15 04:00:00	4	1.02	220	647.1	t	2026-05-08 00:01:27.547131
6507	2026-02-15 04:00:00	7	1.64	220	301.3	t	2026-05-08 00:01:27.547131
6508	2026-02-15 04:30:00	1	2.93	220	626.9	t	2026-05-08 00:01:27.547131
6509	2026-02-15 04:30:00	4	1.34	220	394.5	t	2026-05-08 00:01:27.547131
6510	2026-02-15 04:30:00	7	2.54	220	594.3	t	2026-05-08 00:01:27.547131
6511	2026-02-15 05:00:00	1	1.88	220	448.7	t	2026-05-08 00:01:27.547131
6512	2026-02-15 05:00:00	4	2.02	220	354.9	t	2026-05-08 00:01:27.547131
6513	2026-02-15 05:00:00	7	2.58	220	282.6	t	2026-05-08 00:01:27.547131
6514	2026-02-15 05:30:00	1	1.82	220	590	t	2026-05-08 00:01:27.547131
6515	2026-02-15 05:30:00	4	2.58	220	559.7	t	2026-05-08 00:01:27.547131
6516	2026-02-15 05:30:00	7	2.25	220	633.8	t	2026-05-08 00:01:27.547131
6517	2026-02-15 06:00:00	1	1.43	220	483.1	t	2026-05-08 00:01:27.547131
6518	2026-02-15 06:00:00	4	2.23	220	256.1	t	2026-05-08 00:01:27.547131
6519	2026-02-15 06:00:00	7	1.51	220	463.2	t	2026-05-08 00:01:27.547131
6520	2026-02-15 06:30:00	1	1.19	220	239.5	t	2026-05-08 00:01:27.547131
6521	2026-02-15 06:30:00	4	1.72	220	536.4	t	2026-05-08 00:01:27.547131
6522	2026-02-15 06:30:00	7	1.38	220	518.1	t	2026-05-08 00:01:27.547131
6523	2026-02-15 07:00:00	1	1.74	220	252.2	t	2026-05-08 00:01:27.547131
6524	2026-02-15 07:00:00	4	2.72	220	495.8	t	2026-05-08 00:01:27.547131
6525	2026-02-15 07:00:00	7	2.73	220	427.4	t	2026-05-08 00:01:27.547131
6526	2026-02-15 07:30:00	1	1.66	220	526.6	t	2026-05-08 00:01:27.547131
6527	2026-02-15 07:30:00	4	2.48	220	501.9	t	2026-05-08 00:01:27.547131
6528	2026-02-15 07:30:00	7	1.43	220	496.9	t	2026-05-08 00:01:27.547131
6529	2026-02-15 08:00:00	1	1.88	220	658.6	t	2026-05-08 00:01:27.547131
6530	2026-02-15 08:00:00	4	2.37	220	571.9	t	2026-05-08 00:01:27.547131
6531	2026-02-15 08:00:00	7	1.75	220	278.6	t	2026-05-08 00:01:27.547131
6532	2026-02-15 08:30:00	1	2.33	220	586.9	t	2026-05-08 00:01:27.547131
6533	2026-02-15 08:30:00	4	2.89	220	638.4	t	2026-05-08 00:01:27.547131
6534	2026-02-15 08:30:00	7	1.12	220	291.3	t	2026-05-08 00:01:27.547131
6535	2026-02-15 09:00:00	1	1.52	220	433.5	t	2026-05-08 00:01:27.547131
6536	2026-02-15 09:00:00	4	2.62	220	586.9	t	2026-05-08 00:01:27.547131
6537	2026-02-15 09:00:00	7	1.02	220	365.7	t	2026-05-08 00:01:27.547131
6538	2026-02-15 09:30:00	1	2.96	220	492	t	2026-05-08 00:01:27.547131
6539	2026-02-15 09:30:00	4	1.92	220	516.6	t	2026-05-08 00:01:27.547131
6540	2026-02-15 09:30:00	7	1.98	220	428.5	t	2026-05-08 00:01:27.547131
6541	2026-02-15 10:00:00	1	1.4	220	298	t	2026-05-08 00:01:27.547131
6542	2026-02-15 10:00:00	4	1.24	220	533.9	t	2026-05-08 00:01:27.547131
6543	2026-02-15 10:00:00	7	1.75	220	356.3	t	2026-05-08 00:01:27.547131
6544	2026-02-15 10:30:00	1	1.35	220	491	t	2026-05-08 00:01:27.547131
6545	2026-02-15 10:30:00	4	2.99	220	625.1	t	2026-05-08 00:01:27.547131
6546	2026-02-15 10:30:00	7	2.29	220	304.8	t	2026-05-08 00:01:27.547131
6547	2026-02-15 11:00:00	1	2.87	220	484.3	t	2026-05-08 00:01:27.547131
6548	2026-02-15 11:00:00	4	1.8	220	326.9	t	2026-05-08 00:01:27.547131
6549	2026-02-15 11:00:00	7	2.28	220	647.7	t	2026-05-08 00:01:27.547131
6550	2026-02-15 11:30:00	1	1.75	220	604.5	t	2026-05-08 00:01:27.547131
6551	2026-02-15 11:30:00	4	1.51	220	450.5	t	2026-05-08 00:01:27.547131
6552	2026-02-15 11:30:00	7	1.57	220	381.7	t	2026-05-08 00:01:27.547131
6553	2026-02-15 12:00:00	1	1.59	220	305.3	t	2026-05-08 00:01:27.547131
6554	2026-02-15 12:00:00	4	1.41	220	550.3	t	2026-05-08 00:01:27.547131
6555	2026-02-15 12:00:00	7	2.31	220	259.2	t	2026-05-08 00:01:27.547131
6556	2026-02-15 12:30:00	1	2.42	220	585.8	t	2026-05-08 00:01:27.547131
6557	2026-02-15 12:30:00	4	2.01	220	241.2	t	2026-05-08 00:01:27.547131
6558	2026-02-15 12:30:00	7	2.56	220	477.3	t	2026-05-08 00:01:27.547131
6559	2026-02-15 13:00:00	1	2.84	220	443.9	t	2026-05-08 00:01:27.547131
6560	2026-02-15 13:00:00	4	2	220	399.6	t	2026-05-08 00:01:27.547131
6561	2026-02-15 13:00:00	7	2.7	220	382.3	t	2026-05-08 00:01:27.547131
6562	2026-02-15 13:30:00	1	1.2	220	320.2	t	2026-05-08 00:01:27.547131
6563	2026-02-15 13:30:00	4	1.19	220	401.8	t	2026-05-08 00:01:27.547131
6564	2026-02-15 13:30:00	7	2.26	220	220.8	t	2026-05-08 00:01:27.547131
6565	2026-02-15 14:00:00	1	2.29	220	576.7	t	2026-05-08 00:01:27.547131
6566	2026-02-15 14:00:00	4	2.82	220	603.7	t	2026-05-08 00:01:27.547131
6567	2026-02-15 14:00:00	7	1.88	220	579.4	t	2026-05-08 00:01:27.547131
6568	2026-02-15 14:30:00	1	1.62	220	567.5	t	2026-05-08 00:01:27.547131
6569	2026-02-15 14:30:00	4	1.84	220	271.3	t	2026-05-08 00:01:27.547131
6570	2026-02-15 14:30:00	7	1.34	220	535.7	t	2026-05-08 00:01:27.547131
6571	2026-02-15 15:00:00	1	1.41	220	324	t	2026-05-08 00:01:27.547131
6572	2026-02-15 15:00:00	4	1.84	220	437	t	2026-05-08 00:01:27.547131
6573	2026-02-15 15:00:00	7	1.97	220	318	t	2026-05-08 00:01:27.547131
6574	2026-02-15 15:30:00	1	1.08	220	400.1	t	2026-05-08 00:01:27.547131
6575	2026-02-15 15:30:00	4	2.26	220	264.1	t	2026-05-08 00:01:27.547131
6576	2026-02-15 15:30:00	7	1.6	220	625.9	t	2026-05-08 00:01:27.547131
6577	2026-02-15 16:00:00	1	2.29	220	222.8	t	2026-05-08 00:01:27.547131
6578	2026-02-15 16:00:00	4	2.03	220	276.4	t	2026-05-08 00:01:27.547131
6579	2026-02-15 16:00:00	7	2.28	220	501.5	t	2026-05-08 00:01:27.547131
6580	2026-02-15 16:30:00	1	2.64	220	380.2	t	2026-05-08 00:01:27.547131
6581	2026-02-15 16:30:00	4	1.2	220	342	t	2026-05-08 00:01:27.547131
6582	2026-02-15 16:30:00	7	1.87	220	345	t	2026-05-08 00:01:27.547131
6583	2026-02-15 17:00:00	1	1.18	220	582.5	t	2026-05-08 00:01:27.547131
6584	2026-02-15 17:00:00	4	1.24	220	525.5	t	2026-05-08 00:01:27.547131
6585	2026-02-15 17:00:00	7	1.22	220	541.9	t	2026-05-08 00:01:27.547131
6586	2026-02-15 17:30:00	1	1.98	220	443.5	t	2026-05-08 00:01:27.547131
6587	2026-02-15 17:30:00	4	2.85	220	274.4	t	2026-05-08 00:01:27.547131
6588	2026-02-15 17:30:00	7	1.25	220	484.1	t	2026-05-08 00:01:27.547131
6589	2026-02-15 18:00:00	1	2.6	220	548.8	t	2026-05-08 00:01:27.547131
6590	2026-02-15 18:00:00	4	2.47	220	437.5	t	2026-05-08 00:01:27.547131
6591	2026-02-15 18:00:00	7	1.2	220	355.1	t	2026-05-08 00:01:27.547131
6592	2026-02-15 18:30:00	1	2.34	220	421.9	t	2026-05-08 00:01:27.547131
6593	2026-02-15 18:30:00	4	2.88	220	330.6	t	2026-05-08 00:01:27.547131
6594	2026-02-15 18:30:00	7	1.33	220	646	t	2026-05-08 00:01:27.547131
6595	2026-02-15 19:00:00	1	2.36	220	445.2	t	2026-05-08 00:01:27.547131
6596	2026-02-15 19:00:00	4	2.5	220	230.3	t	2026-05-08 00:01:27.547131
6597	2026-02-15 19:00:00	7	2.28	220	231.1	t	2026-05-08 00:01:27.547131
6598	2026-02-15 19:30:00	1	1.23	220	454.3	t	2026-05-08 00:01:27.547131
6599	2026-02-15 19:30:00	4	1.19	220	603.8	t	2026-05-08 00:01:27.547131
6600	2026-02-15 19:30:00	7	2.59	220	569.1	t	2026-05-08 00:01:27.547131
6601	2026-02-15 20:00:00	1	1.82	220	296.7	t	2026-05-08 00:01:27.547131
6602	2026-02-15 20:00:00	4	3	220	417.1	t	2026-05-08 00:01:27.547131
6603	2026-02-15 20:00:00	7	2.55	220	649.4	t	2026-05-08 00:01:27.547131
6604	2026-02-15 20:30:00	1	2.57	220	412.5	t	2026-05-08 00:01:27.547131
6605	2026-02-15 20:30:00	4	1.03	220	458.3	t	2026-05-08 00:01:27.547131
6606	2026-02-15 20:30:00	7	1.82	220	323.6	t	2026-05-08 00:01:27.547131
6607	2026-02-15 21:00:00	1	2.62	220	324	t	2026-05-08 00:01:27.547131
6608	2026-02-15 21:00:00	4	1.95	220	289.4	t	2026-05-08 00:01:27.547131
6609	2026-02-15 21:00:00	7	2.72	220	505.5	t	2026-05-08 00:01:27.547131
6610	2026-02-15 21:30:00	1	2.84	220	653.8	t	2026-05-08 00:01:27.547131
6611	2026-02-15 21:30:00	4	1.12	220	632	t	2026-05-08 00:01:27.547131
6612	2026-02-15 21:30:00	7	2.27	220	281.7	t	2026-05-08 00:01:27.547131
6613	2026-02-15 22:00:00	1	2.75	220	658.1	t	2026-05-08 00:01:27.547131
6614	2026-02-15 22:00:00	4	2.76	220	632.2	t	2026-05-08 00:01:27.547131
6615	2026-02-15 22:00:00	7	1.58	220	321.6	t	2026-05-08 00:01:27.547131
6616	2026-02-15 22:30:00	1	2.66	220	604.9	t	2026-05-08 00:01:27.547131
6617	2026-02-15 22:30:00	4	1.23	220	593.1	t	2026-05-08 00:01:27.547131
6618	2026-02-15 22:30:00	7	1.24	220	541.3	t	2026-05-08 00:01:27.547131
6619	2026-02-15 23:00:00	1	1	220	507.1	t	2026-05-08 00:01:27.547131
6620	2026-02-15 23:00:00	4	2.85	220	659.3	t	2026-05-08 00:01:27.547131
6621	2026-02-15 23:00:00	7	2.05	220	260.5	t	2026-05-08 00:01:27.547131
6622	2026-02-15 23:30:00	1	2.03	220	267.9	t	2026-05-08 00:01:27.547131
6623	2026-02-15 23:30:00	4	1.5	220	466.2	t	2026-05-08 00:01:27.547131
6624	2026-02-15 23:30:00	7	2.91	220	280.4	t	2026-05-08 00:01:27.547131
6625	2026-02-16 00:00:00	1	2.08	220	572.1	t	2026-05-08 00:01:27.547131
6626	2026-02-16 00:00:00	4	2.93	220	647.8	t	2026-05-08 00:01:27.547131
6627	2026-02-16 00:00:00	7	2.24	220	276.4	t	2026-05-08 00:01:27.547131
6628	2026-02-16 00:30:00	1	2.77	220	634.1	t	2026-05-08 00:01:27.547131
6629	2026-02-16 00:30:00	4	2.58	220	592.9	t	2026-05-08 00:01:27.547131
6630	2026-02-16 00:30:00	7	3.58	220	609.9	t	2026-05-08 00:01:27.547131
6631	2026-02-16 01:00:00	1	2.72	220	338.8	t	2026-05-08 00:01:27.547131
6632	2026-02-16 01:00:00	4	3.28	220	608.3	t	2026-05-08 00:01:27.547131
6633	2026-02-16 01:00:00	7	3.14	220	572.3	t	2026-05-08 00:01:27.547131
6634	2026-02-16 01:30:00	1	1.46	220	786.5	t	2026-05-08 00:01:27.547131
6635	2026-02-16 01:30:00	4	3.67	220	264.8	t	2026-05-08 00:01:27.547131
6636	2026-02-16 01:30:00	7	2.49	220	579.8	t	2026-05-08 00:01:27.547131
6637	2026-02-16 02:00:00	1	3.09	220	436.5	t	2026-05-08 00:01:27.547131
6638	2026-02-16 02:00:00	4	3.58	220	494.1	t	2026-05-08 00:01:27.547131
6639	2026-02-16 02:00:00	7	2.06	220	406.4	t	2026-05-08 00:01:27.547131
6640	2026-02-16 02:30:00	1	3.07	220	704.8	t	2026-05-08 00:01:27.547131
6641	2026-02-16 02:30:00	4	1.93	220	405.7	t	2026-05-08 00:01:27.547131
6642	2026-02-16 02:30:00	7	2.46	220	330.5	t	2026-05-08 00:01:27.547131
6643	2026-02-16 03:00:00	1	2.45	220	752.8	t	2026-05-08 00:01:27.547131
6644	2026-02-16 03:00:00	4	2.84	220	644	t	2026-05-08 00:01:27.547131
6645	2026-02-16 03:00:00	7	3.21	220	432.1	t	2026-05-08 00:01:27.547131
6646	2026-02-16 03:30:00	1	1.71	220	352.2	t	2026-05-08 00:01:27.547131
6647	2026-02-16 03:30:00	4	1.89	220	648.6	t	2026-05-08 00:01:27.547131
6648	2026-02-16 03:30:00	7	2.8	220	429.6	t	2026-05-08 00:01:27.547131
6649	2026-02-16 04:00:00	1	3	220	792.1	t	2026-05-08 00:01:27.547131
6650	2026-02-16 04:00:00	4	2.94	220	752.8	t	2026-05-08 00:01:27.547131
6651	2026-02-16 04:00:00	7	2.56	220	756.2	t	2026-05-08 00:01:27.547131
6652	2026-02-16 04:30:00	1	3.19	220	691.1	t	2026-05-08 00:01:27.547131
6653	2026-02-16 04:30:00	4	1.58	220	560.5	t	2026-05-08 00:01:27.547131
6654	2026-02-16 04:30:00	7	1.83	220	730.4	t	2026-05-08 00:01:27.547131
6655	2026-02-16 05:00:00	1	3.19	220	727.3	t	2026-05-08 00:01:27.547131
6656	2026-02-16 05:00:00	4	1.53	220	412.7	t	2026-05-08 00:01:27.547131
6657	2026-02-16 05:00:00	7	2.33	220	458.8	t	2026-05-08 00:01:27.547131
6658	2026-02-16 05:30:00	1	1.97	220	700.3	t	2026-05-08 00:01:27.547131
6659	2026-02-16 05:30:00	4	3.2	220	645.8	t	2026-05-08 00:01:27.547131
6660	2026-02-16 05:30:00	7	1.98	220	344.2	t	2026-05-08 00:01:27.547131
6661	2026-02-16 06:00:00	1	1.23	220	529.7	t	2026-05-08 00:01:27.547131
6662	2026-02-16 06:00:00	4	2.37	220	624.3	t	2026-05-08 00:01:27.547131
6663	2026-02-16 06:00:00	7	3.59	220	439.4	t	2026-05-08 00:01:27.547131
6664	2026-02-16 06:30:00	1	2.67	220	492.2	t	2026-05-08 00:01:27.547131
6665	2026-02-16 06:30:00	4	2.55	220	421.6	t	2026-05-08 00:01:27.547131
6666	2026-02-16 06:30:00	7	1.88	220	643.6	t	2026-05-08 00:01:27.547131
6667	2026-02-16 07:00:00	1	15.46	220	3284.2	t	2026-05-08 00:01:27.547131
6668	2026-02-16 07:00:00	4	22.08	220	3902.1	t	2026-05-08 00:01:27.547131
6669	2026-02-16 07:00:00	7	29.56	220	5146.7	t	2026-05-08 00:01:27.547131
6670	2026-02-16 07:30:00	1	20.88	220	2614.3	t	2026-05-08 00:01:27.547131
6671	2026-02-16 07:30:00	4	17.5	220	5436.4	t	2026-05-08 00:01:27.547131
6672	2026-02-16 07:30:00	7	22.37	220	4700.1	t	2026-05-08 00:01:27.547131
6673	2026-02-16 08:00:00	1	20.66	220	3816	t	2026-05-08 00:01:27.547131
6674	2026-02-16 08:00:00	4	18.56	220	5095.2	t	2026-05-08 00:01:27.547131
6675	2026-02-16 08:00:00	7	25.35	220	5999	t	2026-05-08 00:01:27.547131
6676	2026-02-16 08:30:00	1	20.76	220	4514.7	t	2026-05-08 00:01:27.547131
6677	2026-02-16 08:30:00	4	21.35	220	5088.8	t	2026-05-08 00:01:27.547131
6678	2026-02-16 08:30:00	7	25.87	220	6634.1	t	2026-05-08 00:01:27.547131
6679	2026-02-16 09:00:00	1	12.98	220	3907	t	2026-05-08 00:01:27.547131
6680	2026-02-16 09:00:00	4	24.11	220	3666.1	t	2026-05-08 00:01:27.547131
6681	2026-02-16 09:00:00	7	27.3	220	5616.6	t	2026-05-08 00:01:27.547131
6682	2026-02-16 09:30:00	1	21.22	220	3815.2	t	2026-05-08 00:01:27.547131
6683	2026-02-16 09:30:00	4	17.46	220	4966.5	t	2026-05-08 00:01:27.547131
6684	2026-02-16 09:30:00	7	22.88	220	5899.8	t	2026-05-08 00:01:27.547131
6685	2026-02-16 10:00:00	1	16.28	220	3880.7	t	2026-05-08 00:01:27.547131
6686	2026-02-16 10:00:00	4	25.94	220	5130	t	2026-05-08 00:01:27.547131
6687	2026-02-16 10:00:00	7	28.03	220	5621.9	t	2026-05-08 00:01:27.547131
6688	2026-02-16 10:30:00	1	13.07	220	3813.4	t	2026-05-08 00:01:27.547131
6689	2026-02-16 10:30:00	4	17.55	220	4321.9	t	2026-05-08 00:01:27.547131
6690	2026-02-16 10:30:00	7	26.53	220	5707.7	t	2026-05-08 00:01:27.547131
6691	2026-02-16 11:00:00	1	12.93	220	2627.3	t	2026-05-08 00:01:27.547131
6692	2026-02-16 11:00:00	4	20.1	220	5172	t	2026-05-08 00:01:27.547131
6693	2026-02-16 11:00:00	7	24.37	220	5581.8	t	2026-05-08 00:01:27.547131
6694	2026-02-16 11:30:00	1	14.04	220	2967.5	t	2026-05-08 00:01:27.547131
6695	2026-02-16 11:30:00	4	21.62	220	4278.5	t	2026-05-08 00:01:27.547131
6696	2026-02-16 11:30:00	7	29.02	220	4600.4	t	2026-05-08 00:01:27.547131
6697	2026-02-16 12:00:00	1	11.97	220	4310.9	t	2026-05-08 00:01:27.547131
6698	2026-02-16 12:00:00	4	19.99	220	5374.6	t	2026-05-08 00:01:27.547131
6699	2026-02-16 12:00:00	7	21.88	220	5479.4	t	2026-05-08 00:01:27.547131
6700	2026-02-16 12:30:00	1	16.68	220	3328.8	t	2026-05-08 00:01:27.547131
6701	2026-02-16 12:30:00	4	19.16	220	5684.8	t	2026-05-08 00:01:27.547131
6702	2026-02-16 12:30:00	7	22.81	220	5549.4	t	2026-05-08 00:01:27.547131
6703	2026-02-16 13:00:00	1	15.47	220	2748.8	t	2026-05-08 00:01:27.547131
6704	2026-02-16 13:00:00	4	22.54	220	4686.9	t	2026-05-08 00:01:27.547131
6705	2026-02-16 13:00:00	7	26.45	220	6146.4	t	2026-05-08 00:01:27.547131
6706	2026-02-16 13:30:00	1	20.49	220	3837.4	t	2026-05-08 00:01:27.547131
6707	2026-02-16 13:30:00	4	19.35	220	4160.2	t	2026-05-08 00:01:27.547131
6708	2026-02-16 13:30:00	7	28.13	220	6324.4	t	2026-05-08 00:01:27.547131
6709	2026-02-16 14:00:00	1	16.55	220	4562.4	t	2026-05-08 00:01:27.547131
6710	2026-02-16 14:00:00	4	17.46	220	4398	t	2026-05-08 00:01:27.547131
6711	2026-02-16 14:00:00	7	22.72	220	6447.4	t	2026-05-08 00:01:27.547131
6712	2026-02-16 14:30:00	1	17.76	220	3705.6	t	2026-05-08 00:01:27.547131
6713	2026-02-16 14:30:00	4	22.89	220	5111	t	2026-05-08 00:01:27.547131
6714	2026-02-16 14:30:00	7	25.02	220	4779.7	t	2026-05-08 00:01:27.547131
6715	2026-02-16 15:00:00	1	15.47	220	3586	t	2026-05-08 00:01:27.547131
6716	2026-02-16 15:00:00	4	23.5	220	5173.1	t	2026-05-08 00:01:27.547131
6717	2026-02-16 15:00:00	7	28.84	220	5449.4	t	2026-05-08 00:01:27.547131
6718	2026-02-16 15:30:00	1	16.59	220	4475.6	t	2026-05-08 00:01:27.547131
6719	2026-02-16 15:30:00	4	24.28	220	5698.9	t	2026-05-08 00:01:27.547131
6720	2026-02-16 15:30:00	7	26.68	220	6266	t	2026-05-08 00:01:27.547131
6721	2026-02-16 16:00:00	1	16.03	220	4031.3	t	2026-05-08 00:01:27.547131
6722	2026-02-16 16:00:00	4	19.52	220	4523.8	t	2026-05-08 00:01:27.547131
6723	2026-02-16 16:00:00	7	20.82	220	5849.3	t	2026-05-08 00:01:27.547131
6724	2026-02-16 16:30:00	1	16.6	220	3882.3	t	2026-05-08 00:01:27.547131
6725	2026-02-16 16:30:00	4	19.63	220	4942.1	t	2026-05-08 00:01:27.547131
6726	2026-02-16 16:30:00	7	27.17	220	6413.3	t	2026-05-08 00:01:27.547131
6727	2026-02-16 17:00:00	1	12.31	220	4423	t	2026-05-08 00:01:27.547131
6728	2026-02-16 17:00:00	4	20.43	220	3883.1	t	2026-05-08 00:01:27.547131
6729	2026-02-16 17:00:00	7	21.15	220	6545.3	t	2026-05-08 00:01:27.547131
6730	2026-02-16 17:30:00	1	13.68	220	4567.3	t	2026-05-08 00:01:27.547131
6731	2026-02-16 17:30:00	4	25.35	220	3620.1	t	2026-05-08 00:01:27.547131
6732	2026-02-16 17:30:00	7	21.7	220	4929.9	t	2026-05-08 00:01:27.547131
6733	2026-02-16 18:00:00	1	20.68	220	2581.8	t	2026-05-08 00:01:27.547131
6734	2026-02-16 18:00:00	4	25.07	220	5464.4	t	2026-05-08 00:01:27.547131
6735	2026-02-16 18:00:00	7	22.74	220	5962.3	t	2026-05-08 00:01:27.547131
6736	2026-02-16 18:30:00	1	15.32	220	3534.5	t	2026-05-08 00:01:27.547131
6737	2026-02-16 18:30:00	4	23.77	220	4680.7	t	2026-05-08 00:01:27.547131
6738	2026-02-16 18:30:00	7	23.24	220	5127.9	t	2026-05-08 00:01:27.547131
6739	2026-02-16 19:00:00	1	19.68	220	3760.3	t	2026-05-08 00:01:27.547131
6740	2026-02-16 19:00:00	4	23.5	220	5699.3	t	2026-05-08 00:01:27.547131
6741	2026-02-16 19:00:00	7	28.26	220	5681.1	t	2026-05-08 00:01:27.547131
6742	2026-02-16 19:30:00	1	20.79	220	4353.8	t	2026-05-08 00:01:27.547131
6743	2026-02-16 19:30:00	4	21.34	220	4437.6	t	2026-05-08 00:01:27.547131
6744	2026-02-16 19:30:00	7	26.06	220	5485.4	t	2026-05-08 00:01:27.547131
6745	2026-02-16 20:00:00	1	2.58	220	460	t	2026-05-08 00:01:27.547131
6746	2026-02-16 20:00:00	4	1.96	220	600.5	t	2026-05-08 00:01:27.547131
6747	2026-02-16 20:00:00	7	2.21	220	755.3	t	2026-05-08 00:01:27.547131
6748	2026-02-16 20:30:00	1	1.28	220	669.5	t	2026-05-08 00:01:27.547131
6749	2026-02-16 20:30:00	4	1.77	220	311.6	t	2026-05-08 00:01:27.547131
6750	2026-02-16 20:30:00	7	1.7	220	520.4	t	2026-05-08 00:01:27.547131
6751	2026-02-16 21:00:00	1	2.15	220	752.8	t	2026-05-08 00:01:27.547131
6752	2026-02-16 21:00:00	4	2.72	220	598.4	t	2026-05-08 00:01:27.547131
6753	2026-02-16 21:00:00	7	3.19	220	762.1	t	2026-05-08 00:01:27.547131
6754	2026-02-16 21:30:00	1	2.3	220	754.8	t	2026-05-08 00:01:27.547131
6755	2026-02-16 21:30:00	4	3.25	220	685.4	t	2026-05-08 00:01:27.547131
6756	2026-02-16 21:30:00	7	2.37	220	314.5	t	2026-05-08 00:01:27.547131
6757	2026-02-16 22:00:00	1	3.07	220	741.1	t	2026-05-08 00:01:27.547131
6758	2026-02-16 22:00:00	4	2.82	220	275.7	t	2026-05-08 00:01:27.547131
6759	2026-02-16 22:00:00	7	2.97	220	353.5	t	2026-05-08 00:01:27.547131
6760	2026-02-16 22:30:00	1	3.32	220	687.9	t	2026-05-08 00:01:27.547131
6761	2026-02-16 22:30:00	4	2.11	220	416.4	t	2026-05-08 00:01:27.547131
6762	2026-02-16 22:30:00	7	2.95	220	740	t	2026-05-08 00:01:27.547131
6763	2026-02-16 23:00:00	1	1.71	220	335	t	2026-05-08 00:01:27.547131
6764	2026-02-16 23:00:00	4	1.23	220	764.2	t	2026-05-08 00:01:27.547131
6765	2026-02-16 23:00:00	7	3.56	220	777.2	t	2026-05-08 00:01:27.547131
6766	2026-02-16 23:30:00	1	2	220	496.3	t	2026-05-08 00:01:27.547131
6767	2026-02-16 23:30:00	4	3.66	220	400	t	2026-05-08 00:01:27.547131
6768	2026-02-16 23:30:00	7	2.54	220	603.4	t	2026-05-08 00:01:27.547131
6769	2026-02-17 00:00:00	1	3.63	220	332.8	t	2026-05-08 00:01:27.547131
6770	2026-02-17 00:00:00	4	2.58	220	716	t	2026-05-08 00:01:27.547131
6771	2026-02-17 00:00:00	7	3.55	220	766.4	t	2026-05-08 00:01:27.547131
6772	2026-02-17 00:30:00	1	3.31	220	715	t	2026-05-08 00:01:27.547131
6773	2026-02-17 00:30:00	4	3.68	220	354.1	t	2026-05-08 00:01:27.547131
6774	2026-02-17 00:30:00	7	1.66	220	743.7	t	2026-05-08 00:01:27.547131
6775	2026-02-17 01:00:00	1	3.58	220	712.3	t	2026-05-08 00:01:27.547131
6776	2026-02-17 01:00:00	4	3.23	220	525.1	t	2026-05-08 00:01:27.547131
6777	2026-02-17 01:00:00	7	2.99	220	312.9	t	2026-05-08 00:01:27.547131
6778	2026-02-17 01:30:00	1	2.58	220	337	t	2026-05-08 00:01:27.547131
6779	2026-02-17 01:30:00	4	1.59	220	529.6	t	2026-05-08 00:01:27.547131
6780	2026-02-17 01:30:00	7	3.61	220	500.2	t	2026-05-08 00:01:27.547131
6781	2026-02-17 02:00:00	1	2.13	220	410.4	t	2026-05-08 00:01:27.547131
6782	2026-02-17 02:00:00	4	1.92	220	691.2	t	2026-05-08 00:01:27.547131
6783	2026-02-17 02:00:00	7	1.84	220	722.8	t	2026-05-08 00:01:27.547131
6784	2026-02-17 02:30:00	1	2.91	220	735.6	t	2026-05-08 00:01:27.547131
6785	2026-02-17 02:30:00	4	1.61	220	766.7	t	2026-05-08 00:01:27.547131
6786	2026-02-17 02:30:00	7	2.86	220	274.4	t	2026-05-08 00:01:27.547131
6787	2026-02-17 03:00:00	1	3.21	220	699.2	t	2026-05-08 00:01:27.547131
6788	2026-02-17 03:00:00	4	2.46	220	524.1	t	2026-05-08 00:01:27.547131
6789	2026-02-17 03:00:00	7	3	220	466.3	t	2026-05-08 00:01:27.547131
6790	2026-02-17 03:30:00	1	1.61	220	540.4	t	2026-05-08 00:01:27.547131
6791	2026-02-17 03:30:00	4	2.54	220	703.5	t	2026-05-08 00:01:27.547131
6792	2026-02-17 03:30:00	7	3.46	220	364.2	t	2026-05-08 00:01:27.547131
6793	2026-02-17 04:00:00	1	3	220	279.4	t	2026-05-08 00:01:27.547131
6794	2026-02-17 04:00:00	4	2.98	220	442	t	2026-05-08 00:01:27.547131
6795	2026-02-17 04:00:00	7	2.8	220	412.9	t	2026-05-08 00:01:27.547131
6796	2026-02-17 04:30:00	1	1.96	220	730.1	t	2026-05-08 00:01:27.547131
6797	2026-02-17 04:30:00	4	2.38	220	459.8	t	2026-05-08 00:01:27.547131
6798	2026-02-17 04:30:00	7	1.67	220	442.8	t	2026-05-08 00:01:27.547131
6799	2026-02-17 05:00:00	1	3.08	220	301	t	2026-05-08 00:01:27.547131
6800	2026-02-17 05:00:00	4	1.44	220	339.3	t	2026-05-08 00:01:27.547131
6801	2026-02-17 05:00:00	7	1.26	220	550	t	2026-05-08 00:01:27.547131
6802	2026-02-17 05:30:00	1	2.65	220	441	t	2026-05-08 00:01:27.547131
6803	2026-02-17 05:30:00	4	1.98	220	487.4	t	2026-05-08 00:01:27.547131
6804	2026-02-17 05:30:00	7	3.14	220	689	t	2026-05-08 00:01:27.547131
6805	2026-02-17 06:00:00	1	2.37	220	283.5	t	2026-05-08 00:01:27.547131
6806	2026-02-17 06:00:00	4	1.91	220	542.5	t	2026-05-08 00:01:27.547131
6807	2026-02-17 06:00:00	7	2.72	220	674	t	2026-05-08 00:01:27.547131
6808	2026-02-17 06:30:00	1	2.49	220	368.2	t	2026-05-08 00:01:27.547131
6809	2026-02-17 06:30:00	4	1.55	220	422	t	2026-05-08 00:01:27.547131
6810	2026-02-17 06:30:00	7	3.35	220	309.3	t	2026-05-08 00:01:27.547131
6811	2026-02-17 07:00:00	1	16.79	220	2901.4	t	2026-05-08 00:01:27.547131
6812	2026-02-17 07:00:00	4	17.63	220	5194.9	t	2026-05-08 00:01:27.547131
6813	2026-02-17 07:00:00	7	30.08	220	6044.3	t	2026-05-08 00:01:27.547131
6814	2026-02-17 07:30:00	1	12.82	220	2879.1	t	2026-05-08 00:01:27.547131
6815	2026-02-17 07:30:00	4	20.11	220	4573.8	t	2026-05-08 00:01:27.547131
6816	2026-02-17 07:30:00	7	25.85	220	5499	t	2026-05-08 00:01:27.547131
6817	2026-02-17 08:00:00	1	14.7	220	3379.5	t	2026-05-08 00:01:27.547131
6818	2026-02-17 08:00:00	4	16.97	220	5122.5	t	2026-05-08 00:01:27.547131
6819	2026-02-17 08:00:00	7	23.52	220	6469.1	t	2026-05-08 00:01:27.547131
6820	2026-02-17 08:30:00	1	21.4	220	3195.5	t	2026-05-08 00:01:27.547131
6821	2026-02-17 08:30:00	4	18.08	220	3901.6	t	2026-05-08 00:01:27.547131
6822	2026-02-17 08:30:00	7	22.84	220	5738.5	t	2026-05-08 00:01:27.547131
6823	2026-02-17 09:00:00	1	15.37	220	4663	t	2026-05-08 00:01:27.547131
6824	2026-02-17 09:00:00	4	19.94	220	4119.9	t	2026-05-08 00:01:27.547131
6825	2026-02-17 09:00:00	7	29.85	220	6486.6	t	2026-05-08 00:01:27.547131
6826	2026-02-17 09:30:00	1	17.52	220	3631	t	2026-05-08 00:01:27.547131
6827	2026-02-17 09:30:00	4	21.32	220	4774.1	t	2026-05-08 00:01:27.547131
6828	2026-02-17 09:30:00	7	29.88	220	5662.5	t	2026-05-08 00:01:27.547131
6829	2026-02-17 10:00:00	1	13.82	220	4105.6	t	2026-05-08 00:01:27.547131
6830	2026-02-17 10:00:00	4	17.78	220	3859.5	t	2026-05-08 00:01:27.547131
6831	2026-02-17 10:00:00	7	28.29	220	4519.5	t	2026-05-08 00:01:27.547131
6832	2026-02-17 10:30:00	1	15.35	220	4233.1	t	2026-05-08 00:01:27.547131
6833	2026-02-17 10:30:00	4	24.99	220	3814.6	t	2026-05-08 00:01:27.547131
6834	2026-02-17 10:30:00	7	23.21	220	4850.7	t	2026-05-08 00:01:27.547131
6835	2026-02-17 11:00:00	1	14.61	220	2692.2	t	2026-05-08 00:01:27.547131
6836	2026-02-17 11:00:00	4	18.02	220	4667.8	t	2026-05-08 00:01:27.547131
6837	2026-02-17 11:00:00	7	23.81	220	6256.8	t	2026-05-08 00:01:27.547131
6838	2026-02-17 11:30:00	1	17.77	220	2929.1	t	2026-05-08 00:01:27.547131
6839	2026-02-17 11:30:00	4	22.89	220	5322	t	2026-05-08 00:01:27.547131
6840	2026-02-17 11:30:00	7	24.55	220	4726.4	t	2026-05-08 00:01:27.547131
6841	2026-02-17 12:00:00	1	19.83	220	4051.6	t	2026-05-08 00:01:27.547131
6842	2026-02-17 12:00:00	4	25.42	220	5019.1	t	2026-05-08 00:01:27.547131
6843	2026-02-17 12:00:00	7	21.49	220	4788.5	t	2026-05-08 00:01:27.547131
6844	2026-02-17 12:30:00	1	13.49	220	3603.1	t	2026-05-08 00:01:27.547131
6845	2026-02-17 12:30:00	4	25.36	220	5202.4	t	2026-05-08 00:01:27.547131
6846	2026-02-17 12:30:00	7	22.16	220	4691.2	t	2026-05-08 00:01:27.547131
6847	2026-02-17 13:00:00	1	19.09	220	2775.9	t	2026-05-08 00:01:27.547131
6848	2026-02-17 13:00:00	4	23.3	220	4032.6	t	2026-05-08 00:01:27.547131
6849	2026-02-17 13:00:00	7	28.97	220	4672.1	t	2026-05-08 00:01:27.547131
6850	2026-02-17 13:30:00	1	16.69	220	4402	t	2026-05-08 00:01:27.547131
6851	2026-02-17 13:30:00	4	22.27	220	3847	t	2026-05-08 00:01:27.547131
6852	2026-02-17 13:30:00	7	20.73	220	6178	t	2026-05-08 00:01:27.547131
6853	2026-02-17 14:00:00	1	18.39	220	4024.2	t	2026-05-08 00:01:27.547131
6854	2026-02-17 14:00:00	4	24.77	220	5202.7	t	2026-05-08 00:01:27.547131
6855	2026-02-17 14:00:00	7	30.03	220	6638	t	2026-05-08 00:01:27.547131
6856	2026-02-17 14:30:00	1	15.13	220	3519.9	t	2026-05-08 00:01:27.547131
6857	2026-02-17 14:30:00	4	16.22	220	5003.1	t	2026-05-08 00:01:27.547131
6858	2026-02-17 14:30:00	7	21.18	220	5960.9	t	2026-05-08 00:01:27.547131
6859	2026-02-17 15:00:00	1	17.44	220	2907.4	t	2026-05-08 00:01:27.547131
6860	2026-02-17 15:00:00	4	16.59	220	4375.6	t	2026-05-08 00:01:27.547131
6861	2026-02-17 15:00:00	7	26.01	220	4562.7	t	2026-05-08 00:01:27.547131
6862	2026-02-17 15:30:00	1	18.56	220	3644.2	t	2026-05-08 00:01:27.547131
6863	2026-02-17 15:30:00	4	20.63	220	4149.8	t	2026-05-08 00:01:27.547131
6864	2026-02-17 15:30:00	7	26.74	220	5344.7	t	2026-05-08 00:01:27.547131
6865	2026-02-17 16:00:00	1	20.62	220	4154.8	t	2026-05-08 00:01:27.547131
6866	2026-02-17 16:00:00	4	22	220	4024.9	t	2026-05-08 00:01:27.547131
6867	2026-02-17 16:00:00	7	22.93	220	5665.3	t	2026-05-08 00:01:27.547131
6868	2026-02-17 16:30:00	1	18.02	220	4587.4	t	2026-05-08 00:01:27.547131
6869	2026-02-17 16:30:00	4	20.91	220	5558	t	2026-05-08 00:01:27.547131
6870	2026-02-17 16:30:00	7	26.11	220	4852.3	t	2026-05-08 00:01:27.547131
6871	2026-02-17 17:00:00	1	19.55	220	3739.2	t	2026-05-08 00:01:27.547131
6872	2026-02-17 17:00:00	4	24.31	220	5242.1	t	2026-05-08 00:01:27.547131
6873	2026-02-17 17:00:00	7	26.48	220	5939.3	t	2026-05-08 00:01:27.547131
6874	2026-02-17 17:30:00	1	18.8	220	4119.5	t	2026-05-08 00:01:27.547131
6875	2026-02-17 17:30:00	4	21.57	220	5158.4	t	2026-05-08 00:01:27.547131
6876	2026-02-17 17:30:00	7	24.92	220	6228.8	t	2026-05-08 00:01:27.547131
6877	2026-02-17 18:00:00	1	15.47	220	3721.9	t	2026-05-08 00:01:27.547131
6878	2026-02-17 18:00:00	4	25.79	220	5684.1	t	2026-05-08 00:01:27.547131
6879	2026-02-17 18:00:00	7	26.53	220	6292.4	t	2026-05-08 00:01:27.547131
6880	2026-02-17 18:30:00	1	18.14	220	3947.1	t	2026-05-08 00:01:27.547131
6881	2026-02-17 18:30:00	4	22.05	220	5225.2	t	2026-05-08 00:01:27.547131
6882	2026-02-17 18:30:00	7	27.29	220	6307.8	t	2026-05-08 00:01:27.547131
6883	2026-02-17 19:00:00	1	11.86	220	4223	t	2026-05-08 00:01:27.547131
6884	2026-02-17 19:00:00	4	23.57	220	5058.8	t	2026-05-08 00:01:27.547131
6885	2026-02-17 19:00:00	7	28.66	220	6424.2	t	2026-05-08 00:01:27.547131
6886	2026-02-17 19:30:00	1	12.35	220	4338.1	t	2026-05-08 00:01:27.547131
6887	2026-02-17 19:30:00	4	25.7	220	5369.4	t	2026-05-08 00:01:27.547131
6888	2026-02-17 19:30:00	7	23.53	220	5137.8	t	2026-05-08 00:01:27.547131
6889	2026-02-17 20:00:00	1	3.55	220	650.1	t	2026-05-08 00:01:27.547131
6890	2026-02-17 20:00:00	4	2.86	220	558.6	t	2026-05-08 00:01:27.547131
6891	2026-02-17 20:00:00	7	1.36	220	496.8	t	2026-05-08 00:01:27.547131
6892	2026-02-17 20:30:00	1	3.15	220	728.5	t	2026-05-08 00:01:27.547131
6893	2026-02-17 20:30:00	4	1.36	220	594.5	t	2026-05-08 00:01:27.547131
6894	2026-02-17 20:30:00	7	2.88	220	573.8	t	2026-05-08 00:01:27.547131
6895	2026-02-17 21:00:00	1	2.15	220	695.9	t	2026-05-08 00:01:27.547131
6896	2026-02-17 21:00:00	4	2.4	220	545.1	t	2026-05-08 00:01:27.547131
6897	2026-02-17 21:00:00	7	1.85	220	343.6	t	2026-05-08 00:01:27.547131
6898	2026-02-17 21:30:00	1	2.55	220	510	t	2026-05-08 00:01:27.547131
6899	2026-02-17 21:30:00	4	2.72	220	760.6	t	2026-05-08 00:01:27.547131
6900	2026-02-17 21:30:00	7	2.49	220	750.8	t	2026-05-08 00:01:27.547131
6901	2026-02-17 22:00:00	1	2.88	220	631.6	t	2026-05-08 00:01:27.547131
6902	2026-02-17 22:00:00	4	1.93	220	322.5	t	2026-05-08 00:01:27.547131
6903	2026-02-17 22:00:00	7	1.55	220	350.9	t	2026-05-08 00:01:27.547131
6904	2026-02-17 22:30:00	1	2.93	220	686.8	t	2026-05-08 00:01:27.547131
6905	2026-02-17 22:30:00	4	3.19	220	304.6	t	2026-05-08 00:01:27.547131
6906	2026-02-17 22:30:00	7	3.27	220	689.5	t	2026-05-08 00:01:27.547131
6907	2026-02-17 23:00:00	1	3.2	220	454	t	2026-05-08 00:01:27.547131
6908	2026-02-17 23:00:00	4	1.46	220	614.4	t	2026-05-08 00:01:27.547131
6909	2026-02-17 23:00:00	7	2.49	220	737.9	t	2026-05-08 00:01:27.547131
6910	2026-02-17 23:30:00	1	2.05	220	326.5	t	2026-05-08 00:01:27.547131
6911	2026-02-17 23:30:00	4	2.12	220	781.3	t	2026-05-08 00:01:27.547131
6912	2026-02-17 23:30:00	7	1.68	220	460.4	t	2026-05-08 00:01:27.547131
6913	2026-02-18 00:00:00	1	2.84	220	723.5	t	2026-05-08 00:01:27.547131
6914	2026-02-18 00:00:00	4	1.4	220	461.7	t	2026-05-08 00:01:27.547131
6915	2026-02-18 00:00:00	7	3.4	220	429.1	t	2026-05-08 00:01:27.547131
6916	2026-02-18 00:30:00	1	2.33	220	728.2	t	2026-05-08 00:01:27.547131
6917	2026-02-18 00:30:00	4	3.26	220	508.2	t	2026-05-08 00:01:27.547131
6918	2026-02-18 00:30:00	7	2.87	220	453.5	t	2026-05-08 00:01:27.547131
6919	2026-02-18 01:00:00	1	2.15	220	445.6	t	2026-05-08 00:01:27.547131
6920	2026-02-18 01:00:00	4	1.91	220	771.2	t	2026-05-08 00:01:27.547131
6921	2026-02-18 01:00:00	7	3.05	220	752.7	t	2026-05-08 00:01:27.547131
6922	2026-02-18 01:30:00	1	2.49	220	696.7	t	2026-05-08 00:01:27.547131
6923	2026-02-18 01:30:00	4	2.48	220	286.2	t	2026-05-08 00:01:27.547131
6924	2026-02-18 01:30:00	7	2.48	220	768.8	t	2026-05-08 00:01:27.547131
6925	2026-02-18 02:00:00	1	1.36	220	680.5	t	2026-05-08 00:01:27.547131
6926	2026-02-18 02:00:00	4	2.15	220	580.6	t	2026-05-08 00:01:27.547131
6927	2026-02-18 02:00:00	7	3.62	220	627.9	t	2026-05-08 00:01:27.547131
6928	2026-02-18 02:30:00	1	3.24	220	499.4	t	2026-05-08 00:01:27.547131
6929	2026-02-18 02:30:00	4	1.6	220	600.1	t	2026-05-08 00:01:27.547131
6930	2026-02-18 02:30:00	7	1.93	220	645.6	t	2026-05-08 00:01:27.547131
6931	2026-02-18 03:00:00	1	2.31	220	468.7	t	2026-05-08 00:01:27.547131
6932	2026-02-18 03:00:00	4	2.05	220	515.5	t	2026-05-08 00:01:27.547131
6933	2026-02-18 03:00:00	7	2.81	220	795.8	t	2026-05-08 00:01:27.547131
6934	2026-02-18 03:30:00	1	1.81	220	292.9	t	2026-05-08 00:01:27.547131
6935	2026-02-18 03:30:00	4	2.25	220	710.4	t	2026-05-08 00:01:27.547131
6936	2026-02-18 03:30:00	7	2.56	220	675.3	t	2026-05-08 00:01:27.547131
6937	2026-02-18 04:00:00	1	2.77	220	721.3	t	2026-05-08 00:01:27.547131
6938	2026-02-18 04:00:00	4	2.27	220	465.8	t	2026-05-08 00:01:27.547131
6939	2026-02-18 04:00:00	7	2.58	220	464.3	t	2026-05-08 00:01:27.547131
6940	2026-02-18 04:30:00	1	3.08	220	448	t	2026-05-08 00:01:27.547131
6941	2026-02-18 04:30:00	4	2.67	220	346.3	t	2026-05-08 00:01:27.547131
6942	2026-02-18 04:30:00	7	2.38	220	276.9	t	2026-05-08 00:01:27.547131
6943	2026-02-18 05:00:00	1	2.01	220	768.4	t	2026-05-08 00:01:27.547131
6944	2026-02-18 05:00:00	4	2.23	220	423	t	2026-05-08 00:01:27.547131
6945	2026-02-18 05:00:00	7	1.48	220	519.4	t	2026-05-08 00:01:27.547131
6946	2026-02-18 05:30:00	1	1.69	220	591.2	t	2026-05-08 00:01:27.547131
6947	2026-02-18 05:30:00	4	2.45	220	528.6	t	2026-05-08 00:01:27.547131
6948	2026-02-18 05:30:00	7	2.75	220	401.8	t	2026-05-08 00:01:27.547131
6949	2026-02-18 06:00:00	1	2.25	220	640.1	t	2026-05-08 00:01:27.547131
6950	2026-02-18 06:00:00	4	2.51	220	587.7	t	2026-05-08 00:01:27.547131
6951	2026-02-18 06:00:00	7	1.26	220	424.5	t	2026-05-08 00:01:27.547131
6952	2026-02-18 06:30:00	1	1.76	220	318	t	2026-05-08 00:01:27.547131
6953	2026-02-18 06:30:00	4	1.64	220	552.4	t	2026-05-08 00:01:27.547131
6954	2026-02-18 06:30:00	7	2.35	220	269	t	2026-05-08 00:01:27.547131
6955	2026-02-18 07:00:00	1	12.73	220	3415.4	t	2026-05-08 00:01:27.547131
6956	2026-02-18 07:00:00	4	23.87	220	4502.7	t	2026-05-08 00:01:27.547131
6957	2026-02-18 07:00:00	7	23.18	220	6007.7	t	2026-05-08 00:01:27.547131
6958	2026-02-18 07:30:00	1	20.73	220	2792.7	t	2026-05-08 00:01:27.547131
6959	2026-02-18 07:30:00	4	25.35	220	3663.1	t	2026-05-08 00:01:27.547131
6960	2026-02-18 07:30:00	7	26.37	220	6282.8	t	2026-05-08 00:01:27.547131
6961	2026-02-18 08:00:00	1	13.12	220	3138.5	t	2026-05-08 00:01:27.547131
6962	2026-02-18 08:00:00	4	16.79	220	3740.5	t	2026-05-08 00:01:27.547131
6963	2026-02-18 08:00:00	7	24.77	220	4586	t	2026-05-08 00:01:27.547131
6964	2026-02-18 08:30:00	1	19.19	220	3703.7	t	2026-05-08 00:01:27.547131
6965	2026-02-18 08:30:00	4	25.54	220	5670.9	t	2026-05-08 00:01:27.547131
6966	2026-02-18 08:30:00	7	20.79	220	4576.9	t	2026-05-08 00:01:27.547131
6967	2026-02-18 09:00:00	1	17.07	220	2847.8	t	2026-05-08 00:01:27.547131
6968	2026-02-18 09:00:00	4	25.54	220	4521.7	t	2026-05-08 00:01:27.547131
6969	2026-02-18 09:00:00	7	27.66	220	5831.5	t	2026-05-08 00:01:27.547131
6970	2026-02-18 09:30:00	1	20.4	220	3639	t	2026-05-08 00:01:27.547131
6971	2026-02-18 09:30:00	4	20.81	220	4762.4	t	2026-05-08 00:01:27.547131
6972	2026-02-18 09:30:00	7	24.53	220	6691.6	t	2026-05-08 00:01:27.547131
6973	2026-02-18 10:00:00	1	13.45	220	3838.4	t	2026-05-08 00:01:27.547131
6974	2026-02-18 10:00:00	4	22.53	220	5522.3	t	2026-05-08 00:01:27.547131
6975	2026-02-18 10:00:00	7	29.38	220	5540.6	t	2026-05-08 00:01:27.547131
6976	2026-02-18 10:30:00	1	20.4	220	4679.1	t	2026-05-08 00:01:27.547131
6977	2026-02-18 10:30:00	4	18.81	220	5183.3	t	2026-05-08 00:01:27.547131
6978	2026-02-18 10:30:00	7	26.67	220	5897.4	t	2026-05-08 00:01:27.547131
6979	2026-02-18 11:00:00	1	17.49	220	2909	t	2026-05-08 00:01:27.547131
6980	2026-02-18 11:00:00	4	19.04	220	3659.9	t	2026-05-08 00:01:27.547131
6981	2026-02-18 11:00:00	7	24.11	220	4911.2	t	2026-05-08 00:01:27.547131
6982	2026-02-18 11:30:00	1	20.55	220	4513.7	t	2026-05-08 00:01:27.547131
6983	2026-02-18 11:30:00	4	21.12	220	4356.4	t	2026-05-08 00:01:27.547131
6984	2026-02-18 11:30:00	7	25.25	220	6383.5	t	2026-05-08 00:01:27.547131
6985	2026-02-18 12:00:00	1	15.52	220	3734.7	t	2026-05-08 00:01:27.547131
6986	2026-02-18 12:00:00	4	25.17	220	5567.5	t	2026-05-08 00:01:27.547131
6987	2026-02-18 12:00:00	7	21.78	220	6017.8	t	2026-05-08 00:01:27.547131
6988	2026-02-18 12:30:00	1	20	220	2797.5	t	2026-05-08 00:01:27.547131
6989	2026-02-18 12:30:00	4	17.82	220	5486	t	2026-05-08 00:01:27.547131
6990	2026-02-18 12:30:00	7	24.88	220	5327.8	t	2026-05-08 00:01:27.547131
6991	2026-02-18 13:00:00	1	18.25	220	4539.2	t	2026-05-08 00:01:27.547131
6992	2026-02-18 13:00:00	4	19.68	220	5573.8	t	2026-05-08 00:01:27.547131
6993	2026-02-18 13:00:00	7	23.49	220	5676.5	t	2026-05-08 00:01:27.547131
6994	2026-02-18 13:30:00	1	18.68	220	2639.7	t	2026-05-08 00:01:27.547131
6995	2026-02-18 13:30:00	4	21.82	220	4625.5	t	2026-05-08 00:01:27.547131
6996	2026-02-18 13:30:00	7	27.23	220	5962.5	t	2026-05-08 00:01:27.547131
6997	2026-02-18 14:00:00	1	13.62	220	2824.8	t	2026-05-08 00:01:27.547131
6998	2026-02-18 14:00:00	4	23.81	220	3775	t	2026-05-08 00:01:27.547131
6999	2026-02-18 14:00:00	7	24.99	220	5936.7	t	2026-05-08 00:01:27.547131
7000	2026-02-18 14:30:00	1	21.16	220	3273.6	t	2026-05-08 00:01:27.547131
7001	2026-02-18 14:30:00	4	23.13	220	5255.2	t	2026-05-08 00:01:27.547131
7002	2026-02-18 14:30:00	7	28.93	220	5369.8	t	2026-05-08 00:01:27.547131
7003	2026-02-18 15:00:00	1	14.12	220	2686	t	2026-05-08 00:01:27.547131
7004	2026-02-18 15:00:00	4	21.63	220	4332	t	2026-05-08 00:01:27.547131
7005	2026-02-18 15:00:00	7	27.45	220	5168.5	t	2026-05-08 00:01:27.547131
7006	2026-02-18 15:30:00	1	12.16	220	2892.8	t	2026-05-08 00:01:27.547131
7007	2026-02-18 15:30:00	4	18.73	220	4980	t	2026-05-08 00:01:27.547131
7008	2026-02-18 15:30:00	7	25.74	220	6187.8	t	2026-05-08 00:01:27.547131
7009	2026-02-18 16:00:00	1	11.77	220	2680.7	t	2026-05-08 00:01:27.547131
7010	2026-02-18 16:00:00	4	19.36	220	5251.9	t	2026-05-08 00:01:27.547131
7011	2026-02-18 16:00:00	7	27.01	220	4970.2	t	2026-05-08 00:01:27.547131
7012	2026-02-18 16:30:00	1	19.26	220	4423.9	t	2026-05-08 00:01:27.547131
7013	2026-02-18 16:30:00	4	20.68	220	5407.5	t	2026-05-08 00:01:27.547131
7014	2026-02-18 16:30:00	7	24.44	220	5305.5	t	2026-05-08 00:01:27.547131
7015	2026-02-18 17:00:00	1	18.38	220	3893	t	2026-05-08 00:01:27.547131
7016	2026-02-18 17:00:00	4	19.1	220	5517	t	2026-05-08 00:01:27.547131
7017	2026-02-18 17:00:00	7	30.45	220	5981.7	t	2026-05-08 00:01:27.547131
7018	2026-02-18 17:30:00	1	21.49	220	2850.6	t	2026-05-08 00:01:27.547131
7019	2026-02-18 17:30:00	4	25.64	220	3976.9	t	2026-05-08 00:01:27.547131
7020	2026-02-18 17:30:00	7	27.58	220	4967.9	t	2026-05-08 00:01:27.547131
7021	2026-02-18 18:00:00	1	18.47	220	2710.2	t	2026-05-08 00:01:27.547131
7022	2026-02-18 18:00:00	4	19.17	220	5148.4	t	2026-05-08 00:01:27.547131
7023	2026-02-18 18:00:00	7	29.96	220	4703.3	t	2026-05-08 00:01:27.547131
7024	2026-02-18 18:30:00	1	13.01	220	4671.6	t	2026-05-08 00:01:27.547131
7025	2026-02-18 18:30:00	4	17.76	220	4278.6	t	2026-05-08 00:01:27.547131
7026	2026-02-18 18:30:00	7	25.25	220	5445.9	t	2026-05-08 00:01:27.547131
7027	2026-02-18 19:00:00	1	12.76	220	3018.4	t	2026-05-08 00:01:27.547131
7028	2026-02-18 19:00:00	4	22.65	220	4704.6	t	2026-05-08 00:01:27.547131
7029	2026-02-18 19:00:00	7	26.32	220	4900.4	t	2026-05-08 00:01:27.547131
7030	2026-02-18 19:30:00	1	15.35	220	4693.5	t	2026-05-08 00:01:27.547131
7031	2026-02-18 19:30:00	4	17.53	220	5540.4	t	2026-05-08 00:01:27.547131
7032	2026-02-18 19:30:00	7	24.52	220	5861.3	t	2026-05-08 00:01:27.547131
7033	2026-02-18 20:00:00	1	3.58	220	629.8	t	2026-05-08 00:01:27.547131
7034	2026-02-18 20:00:00	4	2.23	220	804.8	t	2026-05-08 00:01:27.547131
7035	2026-02-18 20:00:00	7	2.53	220	574.3	t	2026-05-08 00:01:27.547131
7036	2026-02-18 20:30:00	1	1.66	220	586.8	t	2026-05-08 00:01:27.547131
7037	2026-02-18 20:30:00	4	3.06	220	398.2	t	2026-05-08 00:01:27.547131
7038	2026-02-18 20:30:00	7	2.87	220	770.6	t	2026-05-08 00:01:27.547131
7039	2026-02-18 21:00:00	1	2.3	220	516.4	t	2026-05-08 00:01:27.547131
7040	2026-02-18 21:00:00	4	2.51	220	690.9	t	2026-05-08 00:01:27.547131
7041	2026-02-18 21:00:00	7	2.09	220	418.9	t	2026-05-08 00:01:27.547131
7042	2026-02-18 21:30:00	1	3	220	286.1	t	2026-05-08 00:01:27.547131
7043	2026-02-18 21:30:00	4	1.63	220	662.6	t	2026-05-08 00:01:27.547131
7044	2026-02-18 21:30:00	7	2.7	220	493.6	t	2026-05-08 00:01:27.547131
7045	2026-02-18 22:00:00	1	3.41	220	581.9	t	2026-05-08 00:01:27.547131
7046	2026-02-18 22:00:00	4	3.61	220	570.4	t	2026-05-08 00:01:27.547131
7047	2026-02-18 22:00:00	7	2.73	220	712.9	t	2026-05-08 00:01:27.547131
7048	2026-02-18 22:30:00	1	3.05	220	703.5	t	2026-05-08 00:01:27.547131
7049	2026-02-18 22:30:00	4	1.29	220	520.8	t	2026-05-08 00:01:27.547131
7050	2026-02-18 22:30:00	7	1.35	220	521.7	t	2026-05-08 00:01:27.547131
7051	2026-02-18 23:00:00	1	3.09	220	448.8	t	2026-05-08 00:01:27.547131
7052	2026-02-18 23:00:00	4	2.38	220	586.6	t	2026-05-08 00:01:27.547131
7053	2026-02-18 23:00:00	7	2.98	220	580	t	2026-05-08 00:01:27.547131
7054	2026-02-18 23:30:00	1	1.36	220	309.2	t	2026-05-08 00:01:27.547131
7055	2026-02-18 23:30:00	4	2.71	220	473.2	t	2026-05-08 00:01:27.547131
7056	2026-02-18 23:30:00	7	1.22	220	350.9	t	2026-05-08 00:01:27.547131
7057	2026-02-19 00:00:00	1	2.8	220	684.8	t	2026-05-08 00:01:27.547131
7058	2026-02-19 00:00:00	4	1.97	220	443.8	t	2026-05-08 00:01:27.547131
7059	2026-02-19 00:00:00	7	2.07	220	757.4	t	2026-05-08 00:01:27.547131
7060	2026-02-19 00:30:00	1	2.02	220	793.6	t	2026-05-08 00:01:27.547131
7061	2026-02-19 00:30:00	4	3.01	220	305.6	t	2026-05-08 00:01:27.547131
7062	2026-02-19 00:30:00	7	2.45	220	689.8	t	2026-05-08 00:01:27.547131
7063	2026-02-19 01:00:00	1	3.2	220	710.5	t	2026-05-08 00:01:27.547131
7064	2026-02-19 01:00:00	4	2.43	220	716.8	t	2026-05-08 00:01:27.547131
7065	2026-02-19 01:00:00	7	1.59	220	276.1	t	2026-05-08 00:01:27.547131
7066	2026-02-19 01:30:00	1	1.28	220	443.7	t	2026-05-08 00:01:27.547131
7067	2026-02-19 01:30:00	4	1.53	220	406.5	t	2026-05-08 00:01:27.547131
7068	2026-02-19 01:30:00	7	3.05	220	531.6	t	2026-05-08 00:01:27.547131
7069	2026-02-19 02:00:00	1	2.79	220	615.3	t	2026-05-08 00:01:27.547131
7070	2026-02-19 02:00:00	4	2.88	220	672.9	t	2026-05-08 00:01:27.547131
7071	2026-02-19 02:00:00	7	1.26	220	778.5	t	2026-05-08 00:01:27.547131
7072	2026-02-19 02:30:00	1	2.7	220	356.5	t	2026-05-08 00:01:27.547131
7073	2026-02-19 02:30:00	4	3.12	220	599.6	t	2026-05-08 00:01:27.547131
7074	2026-02-19 02:30:00	7	2.3	220	549.1	t	2026-05-08 00:01:27.547131
7075	2026-02-19 03:00:00	1	1.52	220	322.8	t	2026-05-08 00:01:27.547131
7076	2026-02-19 03:00:00	4	2.24	220	498.8	t	2026-05-08 00:01:27.547131
7077	2026-02-19 03:00:00	7	1.28	220	344.1	t	2026-05-08 00:01:27.547131
7078	2026-02-19 03:30:00	1	1.99	220	463.6	t	2026-05-08 00:01:27.547131
7079	2026-02-19 03:30:00	4	3.53	220	319.6	t	2026-05-08 00:01:27.547131
7080	2026-02-19 03:30:00	7	2.22	220	719.4	t	2026-05-08 00:01:27.547131
7081	2026-02-19 04:00:00	1	2.98	220	523.6	t	2026-05-08 00:01:27.547131
7082	2026-02-19 04:00:00	4	1.52	220	376.4	t	2026-05-08 00:01:27.547131
7083	2026-02-19 04:00:00	7	2.8	220	665.2	t	2026-05-08 00:01:27.547131
7084	2026-02-19 04:30:00	1	2.18	220	693.3	t	2026-05-08 00:01:27.547131
7085	2026-02-19 04:30:00	4	2.11	220	808.7	t	2026-05-08 00:01:27.547131
7086	2026-02-19 04:30:00	7	1.41	220	585.6	t	2026-05-08 00:01:27.547131
7087	2026-02-19 05:00:00	1	2.57	220	532.2	t	2026-05-08 00:01:27.547131
7088	2026-02-19 05:00:00	4	2.58	220	686.2	t	2026-05-08 00:01:27.547131
7089	2026-02-19 05:00:00	7	2.2	220	478.3	t	2026-05-08 00:01:27.547131
7090	2026-02-19 05:30:00	1	1.91	220	657.3	t	2026-05-08 00:01:27.547131
7091	2026-02-19 05:30:00	4	2	220	731.2	t	2026-05-08 00:01:27.547131
7092	2026-02-19 05:30:00	7	1.56	220	674.9	t	2026-05-08 00:01:27.547131
7093	2026-02-19 06:00:00	1	3.59	220	279.3	t	2026-05-08 00:01:27.547131
7094	2026-02-19 06:00:00	4	1.87	220	353.6	t	2026-05-08 00:01:27.547131
7095	2026-02-19 06:00:00	7	1.23	220	266.3	t	2026-05-08 00:01:27.547131
7096	2026-02-19 06:30:00	1	3.54	220	531.3	t	2026-05-08 00:01:27.547131
7097	2026-02-19 06:30:00	4	3.2	220	670	t	2026-05-08 00:01:27.547131
7098	2026-02-19 06:30:00	7	3.58	220	575	t	2026-05-08 00:01:27.547131
7099	2026-02-19 07:00:00	1	11.61	220	4436	t	2026-05-08 00:01:27.547131
7100	2026-02-19 07:00:00	4	19.12	220	4526.5	t	2026-05-08 00:01:27.547131
7101	2026-02-19 07:00:00	7	23.15	220	4624.1	t	2026-05-08 00:01:27.547131
7102	2026-02-19 07:30:00	1	12.22	220	4630.3	t	2026-05-08 00:01:27.547131
7103	2026-02-19 07:30:00	4	20.61	220	3785.3	t	2026-05-08 00:01:27.547131
7104	2026-02-19 07:30:00	7	22.35	220	4812.3	t	2026-05-08 00:01:27.547131
7105	2026-02-19 08:00:00	1	18.74	220	3941.6	t	2026-05-08 00:01:27.547131
7106	2026-02-19 08:00:00	4	17.25	220	4499.2	t	2026-05-08 00:01:27.547131
7107	2026-02-19 08:00:00	7	29.25	220	5548.4	t	2026-05-08 00:01:27.547131
7108	2026-02-19 08:30:00	1	11.52	220	2668	t	2026-05-08 00:01:27.547131
7109	2026-02-19 08:30:00	4	23.42	220	4442.9	t	2026-05-08 00:01:27.547131
7110	2026-02-19 08:30:00	7	25.96	220	5787.6	t	2026-05-08 00:01:27.547131
7111	2026-02-19 09:00:00	1	18.3	220	4340.4	t	2026-05-08 00:01:27.547131
7112	2026-02-19 09:00:00	4	20.52	220	5166.4	t	2026-05-08 00:01:27.547131
7113	2026-02-19 09:00:00	7	21	220	5311.2	t	2026-05-08 00:01:27.547131
7114	2026-02-19 09:30:00	1	19.46	220	4282.1	t	2026-05-08 00:01:27.547131
7115	2026-02-19 09:30:00	4	22.59	220	3771.2	t	2026-05-08 00:01:27.547131
7116	2026-02-19 09:30:00	7	25	220	6568	t	2026-05-08 00:01:27.547131
7117	2026-02-19 10:00:00	1	12.38	220	3257.1	t	2026-05-08 00:01:27.547131
7118	2026-02-19 10:00:00	4	16.45	220	5706.9	t	2026-05-08 00:01:27.547131
7119	2026-02-19 10:00:00	7	21.59	220	6391.6	t	2026-05-08 00:01:27.547131
7120	2026-02-19 10:30:00	1	18.3	220	2966	t	2026-05-08 00:01:27.547131
7121	2026-02-19 10:30:00	4	20.28	220	4004.4	t	2026-05-08 00:01:27.547131
7122	2026-02-19 10:30:00	7	26.61	220	4905.9	t	2026-05-08 00:01:27.547131
7123	2026-02-19 11:00:00	1	16.19	220	3862.3	t	2026-05-08 00:01:27.547131
7124	2026-02-19 11:00:00	4	20.43	220	4636.3	t	2026-05-08 00:01:27.547131
7125	2026-02-19 11:00:00	7	25.38	220	4954.4	t	2026-05-08 00:01:27.547131
7126	2026-02-19 11:30:00	1	16.57	220	4080.4	t	2026-05-08 00:01:27.547131
7127	2026-02-19 11:30:00	4	19.32	220	3560.9	t	2026-05-08 00:01:27.547131
7128	2026-02-19 11:30:00	7	25.34	220	5846.6	t	2026-05-08 00:01:27.547131
7129	2026-02-19 12:00:00	1	12.72	220	2861.5	t	2026-05-08 00:01:27.547131
7130	2026-02-19 12:00:00	4	24.42	220	5610.8	t	2026-05-08 00:01:27.547131
7131	2026-02-19 12:00:00	7	30.31	220	6473.6	t	2026-05-08 00:01:27.547131
7132	2026-02-19 12:30:00	1	14.09	220	4256	t	2026-05-08 00:01:27.547131
7133	2026-02-19 12:30:00	4	16.41	220	4577.1	t	2026-05-08 00:01:27.547131
7134	2026-02-19 12:30:00	7	25.47	220	6289.5	t	2026-05-08 00:01:27.547131
7135	2026-02-19 13:00:00	1	17.66	220	3639.2	t	2026-05-08 00:01:27.547131
7136	2026-02-19 13:00:00	4	25.39	220	3717.7	t	2026-05-08 00:01:27.547131
7137	2026-02-19 13:00:00	7	22.42	220	5540	t	2026-05-08 00:01:27.547131
7138	2026-02-19 13:30:00	1	13.13	220	4192.3	t	2026-05-08 00:01:27.547131
7139	2026-02-19 13:30:00	4	20.77	220	5032.8	t	2026-05-08 00:01:27.547131
7140	2026-02-19 13:30:00	7	21.69	220	5145.2	t	2026-05-08 00:01:27.547131
7141	2026-02-19 14:00:00	1	15.04	220	3657.5	t	2026-05-08 00:01:27.547131
7142	2026-02-19 14:00:00	4	19.9	220	5714.1	t	2026-05-08 00:01:27.547131
7143	2026-02-19 14:00:00	7	24.88	220	5716.6	t	2026-05-08 00:01:27.547131
7144	2026-02-19 14:30:00	1	15.82	220	2971.6	t	2026-05-08 00:01:27.547131
7145	2026-02-19 14:30:00	4	16.52	220	5146.6	t	2026-05-08 00:01:27.547131
7146	2026-02-19 14:30:00	7	24.01	220	5198.5	t	2026-05-08 00:01:27.547131
7147	2026-02-19 15:00:00	1	13.6	220	3370.3	t	2026-05-08 00:01:27.547131
7148	2026-02-19 15:00:00	4	24.21	220	3711.6	t	2026-05-08 00:01:27.547131
7149	2026-02-19 15:00:00	7	26.28	220	6327.4	t	2026-05-08 00:01:27.547131
7150	2026-02-19 15:30:00	1	17.44	220	2813.8	t	2026-05-08 00:01:27.547131
7151	2026-02-19 15:30:00	4	24.17	220	5425.1	t	2026-05-08 00:01:27.547131
7152	2026-02-19 15:30:00	7	20.59	220	5775.8	t	2026-05-08 00:01:27.547131
7153	2026-02-19 16:00:00	1	15.37	220	3309.9	t	2026-05-08 00:01:27.547131
7154	2026-02-19 16:00:00	4	24.66	220	5212.5	t	2026-05-08 00:01:27.547131
7155	2026-02-19 16:00:00	7	21.27	220	5100.8	t	2026-05-08 00:01:27.547131
7156	2026-02-19 16:30:00	1	17.58	220	2869.8	t	2026-05-08 00:01:27.547131
7157	2026-02-19 16:30:00	4	22.16	220	5317.7	t	2026-05-08 00:01:27.547131
7158	2026-02-19 16:30:00	7	22.85	220	6635.8	t	2026-05-08 00:01:27.547131
7159	2026-02-19 17:00:00	1	20.36	220	3820.5	t	2026-05-08 00:01:27.547131
7160	2026-02-19 17:00:00	4	17.13	220	3522.5	t	2026-05-08 00:01:27.547131
7161	2026-02-19 17:00:00	7	21.78	220	6635.4	t	2026-05-08 00:01:27.547131
7162	2026-02-19 17:30:00	1	12.89	220	4158.5	t	2026-05-08 00:01:27.547131
7163	2026-02-19 17:30:00	4	23.74	220	4948.9	t	2026-05-08 00:01:27.547131
7164	2026-02-19 17:30:00	7	22.44	220	5770.7	t	2026-05-08 00:01:27.547131
7165	2026-02-19 18:00:00	1	17.79	220	4259.9	t	2026-05-08 00:01:27.547131
7166	2026-02-19 18:00:00	4	19.74	220	5690.8	t	2026-05-08 00:01:27.547131
7167	2026-02-19 18:00:00	7	26.87	220	6188.8	t	2026-05-08 00:01:27.547131
7168	2026-02-19 18:30:00	1	20.24	220	4620.8	t	2026-05-08 00:01:27.547131
7169	2026-02-19 18:30:00	4	20.37	220	5539.9	t	2026-05-08 00:01:27.547131
7170	2026-02-19 18:30:00	7	28.64	220	5123.6	t	2026-05-08 00:01:27.547131
7171	2026-02-19 19:00:00	1	13	220	4012.7	t	2026-05-08 00:01:27.547131
7172	2026-02-19 19:00:00	4	16.63	220	3726.4	t	2026-05-08 00:01:27.547131
7173	2026-02-19 19:00:00	7	28.14	220	5022.7	t	2026-05-08 00:01:27.547131
7174	2026-02-19 19:30:00	1	16.56	220	3988.8	t	2026-05-08 00:01:27.547131
7175	2026-02-19 19:30:00	4	25.16	220	4293.9	t	2026-05-08 00:01:27.547131
7176	2026-02-19 19:30:00	7	24.6	220	5184.6	t	2026-05-08 00:01:27.547131
7177	2026-02-19 20:00:00	1	2.83	220	274.1	t	2026-05-08 00:01:27.547131
7178	2026-02-19 20:00:00	4	3.61	220	602	t	2026-05-08 00:01:27.547131
7179	2026-02-19 20:00:00	7	1.37	220	778.1	t	2026-05-08 00:01:27.547131
7180	2026-02-19 20:30:00	1	2.08	220	787.3	t	2026-05-08 00:01:27.547131
7181	2026-02-19 20:30:00	4	2.42	220	479.6	t	2026-05-08 00:01:27.547131
7182	2026-02-19 20:30:00	7	1.92	220	636.8	t	2026-05-08 00:01:27.547131
7183	2026-02-19 21:00:00	1	3.44	220	274.1	t	2026-05-08 00:01:27.547131
7184	2026-02-19 21:00:00	4	2.69	220	549.5	t	2026-05-08 00:01:27.547131
7185	2026-02-19 21:00:00	7	3.22	220	361.8	t	2026-05-08 00:01:27.547131
7186	2026-02-19 21:30:00	1	1.26	220	431.2	t	2026-05-08 00:01:27.547131
7187	2026-02-19 21:30:00	4	2.45	220	788.5	t	2026-05-08 00:01:27.547131
7188	2026-02-19 21:30:00	7	3.52	220	750.2	t	2026-05-08 00:01:27.547131
7189	2026-02-19 22:00:00	1	2.89	220	540.3	t	2026-05-08 00:01:27.547131
7190	2026-02-19 22:00:00	4	2.9	220	476.9	t	2026-05-08 00:01:27.547131
7191	2026-02-19 22:00:00	7	3.4	220	629.3	t	2026-05-08 00:01:27.547131
7192	2026-02-19 22:30:00	1	2.98	220	576.1	t	2026-05-08 00:01:27.547131
7193	2026-02-19 22:30:00	4	1.43	220	276.4	t	2026-05-08 00:01:27.547131
7194	2026-02-19 22:30:00	7	1.46	220	599.3	t	2026-05-08 00:01:27.547131
7195	2026-02-19 23:00:00	1	3.27	220	615.5	t	2026-05-08 00:01:27.547131
7196	2026-02-19 23:00:00	4	1.71	220	708	t	2026-05-08 00:01:27.547131
7197	2026-02-19 23:00:00	7	1.69	220	474.3	t	2026-05-08 00:01:27.547131
7198	2026-02-19 23:30:00	1	1.81	220	501.1	t	2026-05-08 00:01:27.547131
7199	2026-02-19 23:30:00	4	1.5	220	697.9	t	2026-05-08 00:01:27.547131
7200	2026-02-19 23:30:00	7	1.46	220	799.9	t	2026-05-08 00:01:27.547131
7201	2026-02-20 00:00:00	1	2.2	220	476.3	t	2026-05-08 00:01:27.547131
7202	2026-02-20 00:00:00	4	3.59	220	512.9	t	2026-05-08 00:01:27.547131
7203	2026-02-20 00:00:00	7	2.41	220	793.8	t	2026-05-08 00:01:27.547131
7204	2026-02-20 00:30:00	1	1.63	220	790.7	t	2026-05-08 00:01:27.547131
7205	2026-02-20 00:30:00	4	1.77	220	362.8	t	2026-05-08 00:01:27.547131
7206	2026-02-20 00:30:00	7	2.91	220	333.8	t	2026-05-08 00:01:27.547131
7207	2026-02-20 01:00:00	1	2.73	220	554.7	t	2026-05-08 00:01:27.547131
7208	2026-02-20 01:00:00	4	2.87	220	332.4	t	2026-05-08 00:01:27.547131
7209	2026-02-20 01:00:00	7	2.05	220	419.7	t	2026-05-08 00:01:27.547131
7210	2026-02-20 01:30:00	1	2.11	220	689.4	t	2026-05-08 00:01:27.547131
7211	2026-02-20 01:30:00	4	3.41	220	805.3	t	2026-05-08 00:01:27.547131
7212	2026-02-20 01:30:00	7	2.69	220	375.1	t	2026-05-08 00:01:27.547131
7213	2026-02-20 02:00:00	1	2.15	220	775.8	t	2026-05-08 00:01:27.547131
7214	2026-02-20 02:00:00	4	3.33	220	592.1	t	2026-05-08 00:01:27.547131
7215	2026-02-20 02:00:00	7	3	220	411.1	t	2026-05-08 00:01:27.547131
7216	2026-02-20 02:30:00	1	3.69	220	776	t	2026-05-08 00:01:27.547131
7217	2026-02-20 02:30:00	4	3.69	220	611.5	t	2026-05-08 00:01:27.547131
7218	2026-02-20 02:30:00	7	1.33	220	498.2	t	2026-05-08 00:01:27.547131
7219	2026-02-20 03:00:00	1	3.28	220	649.2	t	2026-05-08 00:01:27.547131
7220	2026-02-20 03:00:00	4	1.55	220	753.9	t	2026-05-08 00:01:27.547131
7221	2026-02-20 03:00:00	7	1.97	220	681.8	t	2026-05-08 00:01:27.547131
7222	2026-02-20 03:30:00	1	2.31	220	274.3	t	2026-05-08 00:01:27.547131
7223	2026-02-20 03:30:00	4	1.82	220	467.2	t	2026-05-08 00:01:27.547131
7224	2026-02-20 03:30:00	7	1.41	220	280.4	t	2026-05-08 00:01:27.547131
7225	2026-02-20 04:00:00	1	3.12	220	620.2	t	2026-05-08 00:01:27.547131
7226	2026-02-20 04:00:00	4	2.94	220	508.5	t	2026-05-08 00:01:27.547131
7227	2026-02-20 04:00:00	7	1.49	220	614.4	t	2026-05-08 00:01:27.547131
7228	2026-02-20 04:30:00	1	2.23	220	510.6	t	2026-05-08 00:01:27.547131
7229	2026-02-20 04:30:00	4	3.61	220	281.9	t	2026-05-08 00:01:27.547131
7230	2026-02-20 04:30:00	7	1.58	220	504.9	t	2026-05-08 00:01:27.547131
7231	2026-02-20 05:00:00	1	2.44	220	767.3	t	2026-05-08 00:01:27.547131
7232	2026-02-20 05:00:00	4	2.38	220	712.8	t	2026-05-08 00:01:27.547131
7233	2026-02-20 05:00:00	7	3.65	220	468.5	t	2026-05-08 00:01:27.547131
7234	2026-02-20 05:30:00	1	2.47	220	631.3	t	2026-05-08 00:01:27.547131
7235	2026-02-20 05:30:00	4	2.82	220	755.4	t	2026-05-08 00:01:27.547131
7236	2026-02-20 05:30:00	7	2.55	220	540.9	t	2026-05-08 00:01:27.547131
7237	2026-02-20 06:00:00	1	2.5	220	364.3	t	2026-05-08 00:01:27.547131
7238	2026-02-20 06:00:00	4	3.07	220	555.8	t	2026-05-08 00:01:27.547131
7239	2026-02-20 06:00:00	7	2.23	220	367.9	t	2026-05-08 00:01:27.547131
7240	2026-02-20 06:30:00	1	2.27	220	362.5	t	2026-05-08 00:01:27.547131
7241	2026-02-20 06:30:00	4	3.65	220	614.2	t	2026-05-08 00:01:27.547131
7242	2026-02-20 06:30:00	7	2.3	220	414.6	t	2026-05-08 00:01:27.547131
7243	2026-02-20 07:00:00	1	15.37	220	2921.5	t	2026-05-08 00:01:27.547131
7244	2026-02-20 07:00:00	4	21.23	220	4349.6	t	2026-05-08 00:01:27.547131
7245	2026-02-20 07:00:00	7	20.85	220	5606.1	t	2026-05-08 00:01:27.547131
7246	2026-02-20 07:30:00	1	20.57	220	3960.6	t	2026-05-08 00:01:27.547131
7247	2026-02-20 07:30:00	4	22.2	220	4518.4	t	2026-05-08 00:01:27.547131
7248	2026-02-20 07:30:00	7	26.35	220	6404.2	t	2026-05-08 00:01:27.547131
7249	2026-02-20 08:00:00	1	12.05	220	3692.3	t	2026-05-08 00:01:27.547131
7250	2026-02-20 08:00:00	4	19.09	220	5561.5	t	2026-05-08 00:01:27.547131
7251	2026-02-20 08:00:00	7	25.91	220	5750.8	t	2026-05-08 00:01:27.547131
7252	2026-02-20 08:30:00	1	12.93	220	4186.9	t	2026-05-08 00:01:27.547131
7253	2026-02-20 08:30:00	4	18.37	220	4817.3	t	2026-05-08 00:01:27.547131
7254	2026-02-20 08:30:00	7	29.52	220	4592.8	t	2026-05-08 00:01:27.547131
7255	2026-02-20 09:00:00	1	14.6	220	3935.6	t	2026-05-08 00:01:27.547131
7256	2026-02-20 09:00:00	4	22.72	220	5142.3	t	2026-05-08 00:01:27.547131
7257	2026-02-20 09:00:00	7	28.41	220	4687.8	t	2026-05-08 00:01:27.547131
7258	2026-02-20 09:30:00	1	11.97	220	4602.7	t	2026-05-08 00:01:27.547131
7259	2026-02-20 09:30:00	4	23.56	220	4165.6	t	2026-05-08 00:01:27.547131
7260	2026-02-20 09:30:00	7	28.85	220	6150.9	t	2026-05-08 00:01:27.547131
7261	2026-02-20 10:00:00	1	13.01	220	4461.4	t	2026-05-08 00:01:27.547131
7262	2026-02-20 10:00:00	4	18.91	220	3693.8	t	2026-05-08 00:01:27.547131
7263	2026-02-20 10:00:00	7	23.66	220	6520.4	t	2026-05-08 00:01:27.547131
7264	2026-02-20 10:30:00	1	13.72	220	2983.4	t	2026-05-08 00:01:27.547131
7265	2026-02-20 10:30:00	4	19.16	220	5530.1	t	2026-05-08 00:01:27.547131
7266	2026-02-20 10:30:00	7	28.39	220	5670.7	t	2026-05-08 00:01:27.547131
7267	2026-02-20 11:00:00	1	19.79	220	4280.6	t	2026-05-08 00:01:27.547131
7268	2026-02-20 11:00:00	4	17.97	220	3716.9	t	2026-05-08 00:01:27.547131
7269	2026-02-20 11:00:00	7	28.41	220	5232.3	t	2026-05-08 00:01:27.547131
7270	2026-02-20 11:30:00	1	18.39	220	3535.2	t	2026-05-08 00:01:27.547131
7271	2026-02-20 11:30:00	4	21.94	220	5688	t	2026-05-08 00:01:27.547131
7272	2026-02-20 11:30:00	7	30.33	220	5276.3	t	2026-05-08 00:01:27.547131
7273	2026-02-20 12:00:00	1	14.68	220	2562.1	t	2026-05-08 00:01:27.547131
7274	2026-02-20 12:00:00	4	19.13	220	5517.3	t	2026-05-08 00:01:27.547131
7275	2026-02-20 12:00:00	7	22.41	220	5101	t	2026-05-08 00:01:27.547131
7276	2026-02-20 12:30:00	1	16.48	220	4215.2	t	2026-05-08 00:01:27.547131
7277	2026-02-20 12:30:00	4	19.8	220	4825.6	t	2026-05-08 00:01:27.547131
7278	2026-02-20 12:30:00	7	21.08	220	5940.3	t	2026-05-08 00:01:27.547131
7279	2026-02-20 13:00:00	1	18.48	220	4384.7	t	2026-05-08 00:01:27.547131
7280	2026-02-20 13:00:00	4	16.73	220	4097.9	t	2026-05-08 00:01:27.547131
7281	2026-02-20 13:00:00	7	29.04	220	5633.9	t	2026-05-08 00:01:27.547131
7282	2026-02-20 13:30:00	1	17.25	220	4215.2	t	2026-05-08 00:01:27.547131
7283	2026-02-20 13:30:00	4	22.37	220	4540.5	t	2026-05-08 00:01:27.547131
7284	2026-02-20 13:30:00	7	29.61	220	5620.7	t	2026-05-08 00:01:27.547131
7285	2026-02-20 14:00:00	1	20.45	220	4487.8	t	2026-05-08 00:01:27.547131
7286	2026-02-20 14:00:00	4	20.92	220	5591.7	t	2026-05-08 00:01:27.547131
7287	2026-02-20 14:00:00	7	24.95	220	4612.8	t	2026-05-08 00:01:27.547131
7288	2026-02-20 14:30:00	1	14.96	220	4703.5	t	2026-05-08 00:01:27.547131
7289	2026-02-20 14:30:00	4	22.61	220	3758.4	t	2026-05-08 00:01:27.547131
7290	2026-02-20 14:30:00	7	24.93	220	5684.8	t	2026-05-08 00:01:27.547131
7291	2026-02-20 15:00:00	1	16.87	220	4687	t	2026-05-08 00:01:27.547131
7292	2026-02-20 15:00:00	4	20.58	220	4330.9	t	2026-05-08 00:01:27.547131
7293	2026-02-20 15:00:00	7	22.48	220	5491.9	t	2026-05-08 00:01:27.547131
7294	2026-02-20 15:30:00	1	14.04	220	3588.8	t	2026-05-08 00:01:27.547131
7295	2026-02-20 15:30:00	4	21.99	220	3748.5	t	2026-05-08 00:01:27.547131
7296	2026-02-20 15:30:00	7	28.33	220	5478	t	2026-05-08 00:01:27.547131
7297	2026-02-20 16:00:00	1	11.78	220	4377.8	t	2026-05-08 00:01:27.547131
7298	2026-02-20 16:00:00	4	18.36	220	4097.5	t	2026-05-08 00:01:27.547131
7299	2026-02-20 16:00:00	7	21.3	220	6431.5	t	2026-05-08 00:01:27.547131
7300	2026-02-20 16:30:00	1	12.69	220	3002.2	t	2026-05-08 00:01:27.547131
7301	2026-02-20 16:30:00	4	24.56	220	4798.8	t	2026-05-08 00:01:27.547131
7302	2026-02-20 16:30:00	7	29.71	220	4990.3	t	2026-05-08 00:01:27.547131
7303	2026-02-20 17:00:00	1	19.98	220	3401.9	t	2026-05-08 00:01:27.547131
7304	2026-02-20 17:00:00	4	25.62	220	4462.1	t	2026-05-08 00:01:27.547131
7305	2026-02-20 17:00:00	7	24.83	220	6533.2	t	2026-05-08 00:01:27.547131
7306	2026-02-20 17:30:00	1	15.08	220	3800.9	t	2026-05-08 00:01:27.547131
7307	2026-02-20 17:30:00	4	18.22	220	4420.9	t	2026-05-08 00:01:27.547131
7308	2026-02-20 17:30:00	7	21.87	220	5367.5	t	2026-05-08 00:01:27.547131
7309	2026-02-20 18:00:00	1	19.67	220	4197.3	t	2026-05-08 00:01:27.547131
7310	2026-02-20 18:00:00	4	17.63	220	4398.3	t	2026-05-08 00:01:27.547131
7311	2026-02-20 18:00:00	7	26.09	220	5416.8	t	2026-05-08 00:01:27.547131
7312	2026-02-20 18:30:00	1	19.36	220	3486.1	t	2026-05-08 00:01:27.547131
7313	2026-02-20 18:30:00	4	22.26	220	4060.2	t	2026-05-08 00:01:27.547131
7314	2026-02-20 18:30:00	7	23.34	220	5729.2	t	2026-05-08 00:01:27.547131
7315	2026-02-20 19:00:00	1	12.88	220	2644.5	t	2026-05-08 00:01:27.547131
7316	2026-02-20 19:00:00	4	18.18	220	4073.4	t	2026-05-08 00:01:27.547131
7317	2026-02-20 19:00:00	7	27.89	220	6322.8	t	2026-05-08 00:01:27.547131
7318	2026-02-20 19:30:00	1	15.59	220	3782.2	t	2026-05-08 00:01:27.547131
7319	2026-02-20 19:30:00	4	23.33	220	5218.9	t	2026-05-08 00:01:27.547131
7320	2026-02-20 19:30:00	7	24.56	220	5234.3	t	2026-05-08 00:01:27.547131
7321	2026-02-20 20:00:00	1	3.68	220	353.3	t	2026-05-08 00:01:27.547131
7322	2026-02-20 20:00:00	4	1.77	220	273.2	t	2026-05-08 00:01:27.547131
7323	2026-02-20 20:00:00	7	1.63	220	538.8	t	2026-05-08 00:01:27.547131
7324	2026-02-20 20:30:00	1	1.9	220	720	t	2026-05-08 00:01:27.547131
7325	2026-02-20 20:30:00	4	2.47	220	801	t	2026-05-08 00:01:27.547131
7326	2026-02-20 20:30:00	7	2.51	220	735.7	t	2026-05-08 00:01:27.547131
7327	2026-02-20 21:00:00	1	1.42	220	411	t	2026-05-08 00:01:27.547131
7328	2026-02-20 21:00:00	4	3.68	220	543.5	t	2026-05-08 00:01:27.547131
7329	2026-02-20 21:00:00	7	2.05	220	276.7	t	2026-05-08 00:01:27.547131
7330	2026-02-20 21:30:00	1	2.95	220	740.6	t	2026-05-08 00:01:27.547131
7331	2026-02-20 21:30:00	4	1.4	220	565.5	t	2026-05-08 00:01:27.547131
7332	2026-02-20 21:30:00	7	1.85	220	329.8	t	2026-05-08 00:01:27.547131
7333	2026-02-20 22:00:00	1	2.15	220	708.5	t	2026-05-08 00:01:27.547131
7334	2026-02-20 22:00:00	4	2.37	220	778.1	t	2026-05-08 00:01:27.547131
7335	2026-02-20 22:00:00	7	1.46	220	321.6	t	2026-05-08 00:01:27.547131
7336	2026-02-20 22:30:00	1	1.39	220	338	t	2026-05-08 00:01:27.547131
7337	2026-02-20 22:30:00	4	3.3	220	776.2	t	2026-05-08 00:01:27.547131
7338	2026-02-20 22:30:00	7	1.97	220	428.8	t	2026-05-08 00:01:27.547131
7339	2026-02-20 23:00:00	1	1.8	220	565.2	t	2026-05-08 00:01:27.547131
7340	2026-02-20 23:00:00	4	3.23	220	373.5	t	2026-05-08 00:01:27.547131
7341	2026-02-20 23:00:00	7	2.84	220	642.4	t	2026-05-08 00:01:27.547131
7342	2026-02-20 23:30:00	1	2.89	220	440.8	t	2026-05-08 00:01:27.547131
7343	2026-02-20 23:30:00	4	3.59	220	776.7	t	2026-05-08 00:01:27.547131
7344	2026-02-20 23:30:00	7	1.5	220	396.6	t	2026-05-08 00:01:27.547131
7345	2026-02-21 00:00:00	1	1.54	220	258	t	2026-05-08 00:01:27.547131
7346	2026-02-21 00:00:00	4	2.31	220	283.2	t	2026-05-08 00:01:27.547131
7347	2026-02-21 00:00:00	7	1.82	220	343.1	t	2026-05-08 00:01:27.547131
7348	2026-02-21 00:30:00	1	1.22	220	413.2	t	2026-05-08 00:01:27.547131
7349	2026-02-21 00:30:00	4	2.88	220	457.7	t	2026-05-08 00:01:27.547131
7350	2026-02-21 00:30:00	7	2.49	220	313.4	t	2026-05-08 00:01:27.547131
7351	2026-02-21 01:00:00	1	2.77	220	591.6	t	2026-05-08 00:01:27.547131
7352	2026-02-21 01:00:00	4	2.74	220	555.7	t	2026-05-08 00:01:27.547131
7353	2026-02-21 01:00:00	7	1.73	220	655.7	t	2026-05-08 00:01:27.547131
7354	2026-02-21 01:30:00	1	2.99	220	534.5	t	2026-05-08 00:01:27.547131
7355	2026-02-21 01:30:00	4	2.07	220	552.5	t	2026-05-08 00:01:27.547131
7356	2026-02-21 01:30:00	7	1.41	220	369.7	t	2026-05-08 00:01:27.547131
7357	2026-02-21 02:00:00	1	2.76	220	384.2	t	2026-05-08 00:01:27.547131
7358	2026-02-21 02:00:00	4	1.16	220	490.4	t	2026-05-08 00:01:27.547131
7359	2026-02-21 02:00:00	7	2.44	220	394	t	2026-05-08 00:01:27.547131
7360	2026-02-21 02:30:00	1	2	220	460.3	t	2026-05-08 00:01:27.547131
7361	2026-02-21 02:30:00	4	2.19	220	618.9	t	2026-05-08 00:01:27.547131
7362	2026-02-21 02:30:00	7	2.26	220	407.8	t	2026-05-08 00:01:27.547131
7363	2026-02-21 03:00:00	1	1.6	220	536	t	2026-05-08 00:01:27.547131
7364	2026-02-21 03:00:00	4	1.04	220	284.4	t	2026-05-08 00:01:27.547131
7365	2026-02-21 03:00:00	7	1.48	220	279.7	t	2026-05-08 00:01:27.547131
7366	2026-02-21 03:30:00	1	1.38	220	396	t	2026-05-08 00:01:27.547131
7367	2026-02-21 03:30:00	4	1.99	220	382.2	t	2026-05-08 00:01:27.547131
7368	2026-02-21 03:30:00	7	1.53	220	256.8	t	2026-05-08 00:01:27.547131
7369	2026-02-21 04:00:00	1	1.14	220	574.8	t	2026-05-08 00:01:27.547131
7370	2026-02-21 04:00:00	4	2.37	220	649.8	t	2026-05-08 00:01:27.547131
7371	2026-02-21 04:00:00	7	2.83	220	356.7	t	2026-05-08 00:01:27.547131
7372	2026-02-21 04:30:00	1	2.32	220	309.7	t	2026-05-08 00:01:27.547131
7373	2026-02-21 04:30:00	4	2.84	220	539	t	2026-05-08 00:01:27.547131
7374	2026-02-21 04:30:00	7	1.08	220	225.2	t	2026-05-08 00:01:27.547131
7375	2026-02-21 05:00:00	1	1.82	220	274.6	t	2026-05-08 00:01:27.547131
7376	2026-02-21 05:00:00	4	2.02	220	255.3	t	2026-05-08 00:01:27.547131
7377	2026-02-21 05:00:00	7	1.24	220	338.8	t	2026-05-08 00:01:27.547131
7378	2026-02-21 05:30:00	1	1.62	220	505.2	t	2026-05-08 00:01:27.547131
7379	2026-02-21 05:30:00	4	2.3	220	228.9	t	2026-05-08 00:01:27.547131
7380	2026-02-21 05:30:00	7	1.63	220	562.2	t	2026-05-08 00:01:27.547131
7381	2026-02-21 06:00:00	1	1.46	220	369.9	t	2026-05-08 00:01:27.547131
7382	2026-02-21 06:00:00	4	1.5	220	463	t	2026-05-08 00:01:27.547131
7383	2026-02-21 06:00:00	7	1.12	220	447.5	t	2026-05-08 00:01:27.547131
7384	2026-02-21 06:30:00	1	1.74	220	367.7	t	2026-05-08 00:01:27.547131
7385	2026-02-21 06:30:00	4	2.77	220	645.6	t	2026-05-08 00:01:27.547131
7386	2026-02-21 06:30:00	7	1.84	220	526.9	t	2026-05-08 00:01:27.547131
7387	2026-02-21 07:00:00	1	1.75	220	515.8	t	2026-05-08 00:01:27.547131
7388	2026-02-21 07:00:00	4	1.64	220	644.2	t	2026-05-08 00:01:27.547131
7389	2026-02-21 07:00:00	7	2.22	220	311	t	2026-05-08 00:01:27.547131
7390	2026-02-21 07:30:00	1	1.51	220	370.7	t	2026-05-08 00:01:27.547131
7391	2026-02-21 07:30:00	4	1.52	220	500	t	2026-05-08 00:01:27.547131
7392	2026-02-21 07:30:00	7	2.96	220	247	t	2026-05-08 00:01:27.547131
7393	2026-02-21 08:00:00	1	1.69	220	471.5	t	2026-05-08 00:01:27.547131
7394	2026-02-21 08:00:00	4	1.47	220	297	t	2026-05-08 00:01:27.547131
7395	2026-02-21 08:00:00	7	2.71	220	249.5	t	2026-05-08 00:01:27.547131
7396	2026-02-21 08:30:00	1	1.73	220	225.3	t	2026-05-08 00:01:27.547131
7397	2026-02-21 08:30:00	4	1.61	220	537.2	t	2026-05-08 00:01:27.547131
7398	2026-02-21 08:30:00	7	2.94	220	474	t	2026-05-08 00:01:27.547131
7399	2026-02-21 09:00:00	1	1.86	220	265.8	t	2026-05-08 00:01:27.547131
7400	2026-02-21 09:00:00	4	1.19	220	534.9	t	2026-05-08 00:01:27.547131
7401	2026-02-21 09:00:00	7	2.7	220	320.7	t	2026-05-08 00:01:27.547131
7402	2026-02-21 09:30:00	1	2.45	220	436.6	t	2026-05-08 00:01:27.547131
7403	2026-02-21 09:30:00	4	2.97	220	306.7	t	2026-05-08 00:01:27.547131
7404	2026-02-21 09:30:00	7	2.58	220	449.8	t	2026-05-08 00:01:27.547131
7405	2026-02-21 10:00:00	1	1.96	220	582.8	t	2026-05-08 00:01:27.547131
7406	2026-02-21 10:00:00	4	1.84	220	595.3	t	2026-05-08 00:01:27.547131
7407	2026-02-21 10:00:00	7	2.57	220	506.4	t	2026-05-08 00:01:27.547131
7408	2026-02-21 10:30:00	1	2.2	220	281.4	t	2026-05-08 00:01:27.547131
7409	2026-02-21 10:30:00	4	2.69	220	355.6	t	2026-05-08 00:01:27.547131
7410	2026-02-21 10:30:00	7	2.19	220	243.5	t	2026-05-08 00:01:27.547131
7411	2026-02-21 11:00:00	1	2.06	220	331.3	t	2026-05-08 00:01:27.547131
7412	2026-02-21 11:00:00	4	1.88	220	369.5	t	2026-05-08 00:01:27.547131
7413	2026-02-21 11:00:00	7	1.16	220	620.4	t	2026-05-08 00:01:27.547131
7414	2026-02-21 11:30:00	1	1.67	220	517.3	t	2026-05-08 00:01:27.547131
7415	2026-02-21 11:30:00	4	1.17	220	581.6	t	2026-05-08 00:01:27.547131
7416	2026-02-21 11:30:00	7	1.66	220	357.4	t	2026-05-08 00:01:27.547131
7417	2026-02-21 12:00:00	1	3	220	422.4	t	2026-05-08 00:01:27.547131
7418	2026-02-21 12:00:00	4	2.23	220	599.9	t	2026-05-08 00:01:27.547131
7419	2026-02-21 12:00:00	7	1.44	220	321.5	t	2026-05-08 00:01:27.547131
7420	2026-02-21 12:30:00	1	1.01	220	541	t	2026-05-08 00:01:27.547131
7421	2026-02-21 12:30:00	4	2.35	220	500.6	t	2026-05-08 00:01:27.547131
7422	2026-02-21 12:30:00	7	1.39	220	596.4	t	2026-05-08 00:01:27.547131
7423	2026-02-21 13:00:00	1	1.17	220	393.7	t	2026-05-08 00:01:27.547131
7424	2026-02-21 13:00:00	4	1.45	220	455.8	t	2026-05-08 00:01:27.547131
7425	2026-02-21 13:00:00	7	2.27	220	436	t	2026-05-08 00:01:27.547131
7426	2026-02-21 13:30:00	1	2.4	220	499.5	t	2026-05-08 00:01:27.547131
7427	2026-02-21 13:30:00	4	2.55	220	646.7	t	2026-05-08 00:01:27.547131
7428	2026-02-21 13:30:00	7	2.54	220	425.5	t	2026-05-08 00:01:27.547131
7429	2026-02-21 14:00:00	1	1.78	220	597.1	t	2026-05-08 00:01:27.547131
7430	2026-02-21 14:00:00	4	1.98	220	548.3	t	2026-05-08 00:01:27.547131
7431	2026-02-21 14:00:00	7	2.01	220	576.5	t	2026-05-08 00:01:27.547131
7432	2026-02-21 14:30:00	1	1.56	220	559.6	t	2026-05-08 00:01:27.547131
7433	2026-02-21 14:30:00	4	2.98	220	462.4	t	2026-05-08 00:01:27.547131
7434	2026-02-21 14:30:00	7	1.11	220	342.3	t	2026-05-08 00:01:27.547131
7435	2026-02-21 15:00:00	1	1.34	220	427.8	t	2026-05-08 00:01:27.547131
7436	2026-02-21 15:00:00	4	2.57	220	634.2	t	2026-05-08 00:01:27.547131
7437	2026-02-21 15:00:00	7	2.18	220	334.4	t	2026-05-08 00:01:27.547131
7438	2026-02-21 15:30:00	1	1.49	220	233.7	t	2026-05-08 00:01:27.547131
7439	2026-02-21 15:30:00	4	1.67	220	245.7	t	2026-05-08 00:01:27.547131
7440	2026-02-21 15:30:00	7	1.87	220	409.4	t	2026-05-08 00:01:27.547131
7441	2026-02-21 16:00:00	1	2.5	220	286.6	t	2026-05-08 00:01:27.547131
7442	2026-02-21 16:00:00	4	2.7	220	585.7	t	2026-05-08 00:01:27.547131
7443	2026-02-21 16:00:00	7	1.95	220	312	t	2026-05-08 00:01:27.547131
7444	2026-02-21 16:30:00	1	2.62	220	585.6	t	2026-05-08 00:01:27.547131
7445	2026-02-21 16:30:00	4	1.22	220	536	t	2026-05-08 00:01:27.547131
7446	2026-02-21 16:30:00	7	1.11	220	637.6	t	2026-05-08 00:01:27.547131
7447	2026-02-21 17:00:00	1	2.87	220	499.8	t	2026-05-08 00:01:27.547131
7448	2026-02-21 17:00:00	4	2.66	220	647.7	t	2026-05-08 00:01:27.547131
7449	2026-02-21 17:00:00	7	2.75	220	597.6	t	2026-05-08 00:01:27.547131
7450	2026-02-21 17:30:00	1	2.56	220	621.4	t	2026-05-08 00:01:27.547131
7451	2026-02-21 17:30:00	4	1.98	220	291.4	t	2026-05-08 00:01:27.547131
7452	2026-02-21 17:30:00	7	1.54	220	545.2	t	2026-05-08 00:01:27.547131
7453	2026-02-21 18:00:00	1	1.83	220	512.6	t	2026-05-08 00:01:27.547131
7454	2026-02-21 18:00:00	4	2.83	220	632.9	t	2026-05-08 00:01:27.547131
7455	2026-02-21 18:00:00	7	2.42	220	453.1	t	2026-05-08 00:01:27.547131
7456	2026-02-21 18:30:00	1	2.88	220	429.7	t	2026-05-08 00:01:27.547131
7457	2026-02-21 18:30:00	4	2.39	220	513.5	t	2026-05-08 00:01:27.547131
7458	2026-02-21 18:30:00	7	1.22	220	513.4	t	2026-05-08 00:01:27.547131
7459	2026-02-21 19:00:00	1	2.57	220	355.1	t	2026-05-08 00:01:27.547131
7460	2026-02-21 19:00:00	4	2	220	650	t	2026-05-08 00:01:27.547131
7461	2026-02-21 19:00:00	7	1.26	220	504.9	t	2026-05-08 00:01:27.547131
7462	2026-02-21 19:30:00	1	2.06	220	393.1	t	2026-05-08 00:01:27.547131
7463	2026-02-21 19:30:00	4	1.43	220	633.9	t	2026-05-08 00:01:27.547131
7464	2026-02-21 19:30:00	7	2.33	220	602.8	t	2026-05-08 00:01:27.547131
7465	2026-02-21 20:00:00	1	1.38	220	542.1	t	2026-05-08 00:01:27.547131
7466	2026-02-21 20:00:00	4	2.88	220	452	t	2026-05-08 00:01:27.547131
7467	2026-02-21 20:00:00	7	2.82	220	415.3	t	2026-05-08 00:01:27.547131
7468	2026-02-21 20:30:00	1	1.42	220	525.1	t	2026-05-08 00:01:27.547131
7469	2026-02-21 20:30:00	4	2.87	220	408.2	t	2026-05-08 00:01:27.547131
7470	2026-02-21 20:30:00	7	1.49	220	556.8	t	2026-05-08 00:01:27.547131
7471	2026-02-21 21:00:00	1	2.17	220	620.5	t	2026-05-08 00:01:27.547131
7472	2026-02-21 21:00:00	4	2.33	220	482	t	2026-05-08 00:01:27.547131
7473	2026-02-21 21:00:00	7	2.23	220	397.1	t	2026-05-08 00:01:27.547131
7474	2026-02-21 21:30:00	1	2.71	220	466.4	t	2026-05-08 00:01:27.547131
7475	2026-02-21 21:30:00	4	2.44	220	641.5	t	2026-05-08 00:01:27.547131
7476	2026-02-21 21:30:00	7	1.73	220	553.3	t	2026-05-08 00:01:27.547131
7477	2026-02-21 22:00:00	1	2.86	220	608.3	t	2026-05-08 00:01:27.547131
7478	2026-02-21 22:00:00	4	2.24	220	324.1	t	2026-05-08 00:01:27.547131
7479	2026-02-21 22:00:00	7	1.12	220	504	t	2026-05-08 00:01:27.547131
7480	2026-02-21 22:30:00	1	1.93	220	328.8	t	2026-05-08 00:01:27.547131
7481	2026-02-21 22:30:00	4	1.66	220	273.9	t	2026-05-08 00:01:27.547131
7482	2026-02-21 22:30:00	7	2.63	220	434.9	t	2026-05-08 00:01:27.547131
7483	2026-02-21 23:00:00	1	1.37	220	388.4	t	2026-05-08 00:01:27.547131
7484	2026-02-21 23:00:00	4	1.03	220	250.2	t	2026-05-08 00:01:27.547131
7485	2026-02-21 23:00:00	7	2.74	220	410.7	t	2026-05-08 00:01:27.547131
7486	2026-02-21 23:30:00	1	2.04	220	333.8	t	2026-05-08 00:01:27.547131
7487	2026-02-21 23:30:00	4	1.24	220	536.3	t	2026-05-08 00:01:27.547131
7488	2026-02-21 23:30:00	7	2.26	220	585.6	t	2026-05-08 00:01:27.547131
7489	2026-02-22 00:00:00	1	1.31	220	462.1	t	2026-05-08 00:01:27.547131
7490	2026-02-22 00:00:00	4	1.91	220	465.3	t	2026-05-08 00:01:27.547131
7491	2026-02-22 00:00:00	7	2.71	220	641.4	t	2026-05-08 00:01:27.547131
7492	2026-02-22 00:30:00	1	2.88	220	541.1	t	2026-05-08 00:01:27.547131
7493	2026-02-22 00:30:00	4	1.88	220	230.2	t	2026-05-08 00:01:27.547131
7494	2026-02-22 00:30:00	7	2.11	220	324.6	t	2026-05-08 00:01:27.547131
7495	2026-02-22 01:00:00	1	2.6	220	605.9	t	2026-05-08 00:01:27.547131
7496	2026-02-22 01:00:00	4	1.88	220	503.3	t	2026-05-08 00:01:27.547131
7497	2026-02-22 01:00:00	7	2.78	220	540.3	t	2026-05-08 00:01:27.547131
7498	2026-02-22 01:30:00	1	2.88	220	471.2	t	2026-05-08 00:01:27.547131
7499	2026-02-22 01:30:00	4	2.37	220	393.1	t	2026-05-08 00:01:27.547131
7500	2026-02-22 01:30:00	7	1.1	220	259.9	t	2026-05-08 00:01:27.547131
7501	2026-02-22 02:00:00	1	1.51	220	602.1	t	2026-05-08 00:01:27.547131
7502	2026-02-22 02:00:00	4	2.42	220	541.6	t	2026-05-08 00:01:27.547131
7503	2026-02-22 02:00:00	7	2.85	220	505.3	t	2026-05-08 00:01:27.547131
7504	2026-02-22 02:30:00	1	1.78	220	271.7	t	2026-05-08 00:01:27.547131
7505	2026-02-22 02:30:00	4	2.08	220	616.1	t	2026-05-08 00:01:27.547131
7506	2026-02-22 02:30:00	7	2.18	220	233.6	t	2026-05-08 00:01:27.547131
7507	2026-02-22 03:00:00	1	2.93	220	517.1	t	2026-05-08 00:01:27.547131
7508	2026-02-22 03:00:00	4	2.86	220	577.5	t	2026-05-08 00:01:27.547131
7509	2026-02-22 03:00:00	7	2.96	220	553.9	t	2026-05-08 00:01:27.547131
7510	2026-02-22 03:30:00	1	2.86	220	328.6	t	2026-05-08 00:01:27.547131
7511	2026-02-22 03:30:00	4	2.7	220	511.7	t	2026-05-08 00:01:27.547131
7512	2026-02-22 03:30:00	7	1.89	220	358.6	t	2026-05-08 00:01:27.547131
7513	2026-02-22 04:00:00	1	1.44	220	540.7	t	2026-05-08 00:01:27.547131
7514	2026-02-22 04:00:00	4	2.32	220	517.8	t	2026-05-08 00:01:27.547131
7515	2026-02-22 04:00:00	7	2.95	220	408.6	t	2026-05-08 00:01:27.547131
7516	2026-02-22 04:30:00	1	2.14	220	439.9	t	2026-05-08 00:01:27.547131
7517	2026-02-22 04:30:00	4	1.43	220	598.1	t	2026-05-08 00:01:27.547131
7518	2026-02-22 04:30:00	7	1.32	220	598.8	t	2026-05-08 00:01:27.547131
7519	2026-02-22 05:00:00	1	1.1	220	584.1	t	2026-05-08 00:01:27.547131
7520	2026-02-22 05:00:00	4	1.37	220	421.9	t	2026-05-08 00:01:27.547131
7521	2026-02-22 05:00:00	7	1.16	220	553.5	t	2026-05-08 00:01:27.547131
7522	2026-02-22 05:30:00	1	2.13	220	596.7	t	2026-05-08 00:01:27.547131
7523	2026-02-22 05:30:00	4	2.7	220	370.9	t	2026-05-08 00:01:27.547131
7524	2026-02-22 05:30:00	7	1.13	220	458.8	t	2026-05-08 00:01:27.547131
7525	2026-02-22 06:00:00	1	2.45	220	443	t	2026-05-08 00:01:27.547131
7526	2026-02-22 06:00:00	4	1.87	220	523	t	2026-05-08 00:01:27.547131
7527	2026-02-22 06:00:00	7	2.65	220	630.3	t	2026-05-08 00:01:27.547131
7528	2026-02-22 06:30:00	1	1.72	220	458.8	t	2026-05-08 00:01:27.547131
7529	2026-02-22 06:30:00	4	1.27	220	629	t	2026-05-08 00:01:27.547131
7530	2026-02-22 06:30:00	7	2.13	220	500.8	t	2026-05-08 00:01:27.547131
7531	2026-02-22 07:00:00	1	1.11	220	432.6	t	2026-05-08 00:01:27.547131
7532	2026-02-22 07:00:00	4	1.08	220	243.5	t	2026-05-08 00:01:27.547131
7533	2026-02-22 07:00:00	7	2.27	220	361	t	2026-05-08 00:01:27.547131
7534	2026-02-22 07:30:00	1	2.31	220	372.9	t	2026-05-08 00:01:27.547131
7535	2026-02-22 07:30:00	4	2.66	220	624.6	t	2026-05-08 00:01:27.547131
7536	2026-02-22 07:30:00	7	2.04	220	504.9	t	2026-05-08 00:01:27.547131
7537	2026-02-22 08:00:00	1	1.44	220	526.1	t	2026-05-08 00:01:27.547131
7538	2026-02-22 08:00:00	4	2.24	220	538	t	2026-05-08 00:01:27.547131
7539	2026-02-22 08:00:00	7	1.67	220	605.7	t	2026-05-08 00:01:27.547131
7540	2026-02-22 08:30:00	1	1.09	220	456	t	2026-05-08 00:01:27.547131
7541	2026-02-22 08:30:00	4	1.17	220	268.9	t	2026-05-08 00:01:27.547131
7542	2026-02-22 08:30:00	7	1.33	220	311.9	t	2026-05-08 00:01:27.547131
7543	2026-02-22 09:00:00	1	2.82	220	524.1	t	2026-05-08 00:01:27.547131
7544	2026-02-22 09:00:00	4	1.34	220	351.8	t	2026-05-08 00:01:27.547131
7545	2026-02-22 09:00:00	7	2.32	220	233.7	t	2026-05-08 00:01:27.547131
7546	2026-02-22 09:30:00	1	1.25	220	318.5	t	2026-05-08 00:01:27.547131
7547	2026-02-22 09:30:00	4	2.29	220	267	t	2026-05-08 00:01:27.547131
7548	2026-02-22 09:30:00	7	1.08	220	256.5	t	2026-05-08 00:01:27.547131
7549	2026-02-22 10:00:00	1	1.53	220	319.2	t	2026-05-08 00:01:27.547131
7550	2026-02-22 10:00:00	4	1.79	220	342.9	t	2026-05-08 00:01:27.547131
7551	2026-02-22 10:00:00	7	2.19	220	435.9	t	2026-05-08 00:01:27.547131
7552	2026-02-22 10:30:00	1	2.99	220	364.6	t	2026-05-08 00:01:27.547131
7553	2026-02-22 10:30:00	4	2.95	220	508.2	t	2026-05-08 00:01:27.547131
7554	2026-02-22 10:30:00	7	1.6	220	422.7	t	2026-05-08 00:01:27.547131
7555	2026-02-22 11:00:00	1	1.33	220	362.8	t	2026-05-08 00:01:27.547131
7556	2026-02-22 11:00:00	4	1.03	220	451.4	t	2026-05-08 00:01:27.547131
7557	2026-02-22 11:00:00	7	1.06	220	656.1	t	2026-05-08 00:01:27.547131
7558	2026-02-22 11:30:00	1	2.18	220	615.2	t	2026-05-08 00:01:27.547131
7559	2026-02-22 11:30:00	4	1.75	220	480	t	2026-05-08 00:01:27.547131
7560	2026-02-22 11:30:00	7	2.69	220	624.6	t	2026-05-08 00:01:27.547131
7561	2026-02-22 12:00:00	1	1.95	220	326.1	t	2026-05-08 00:01:27.547131
7562	2026-02-22 12:00:00	4	1.23	220	222.1	t	2026-05-08 00:01:27.547131
7563	2026-02-22 12:00:00	7	1.27	220	423.7	t	2026-05-08 00:01:27.547131
7564	2026-02-22 12:30:00	1	2.54	220	493.8	t	2026-05-08 00:01:27.547131
7565	2026-02-22 12:30:00	4	1.14	220	250.6	t	2026-05-08 00:01:27.547131
7566	2026-02-22 12:30:00	7	2.18	220	440.4	t	2026-05-08 00:01:27.547131
7567	2026-02-22 13:00:00	1	1.89	220	447.7	t	2026-05-08 00:01:27.547131
7568	2026-02-22 13:00:00	4	2.91	220	659.4	t	2026-05-08 00:01:27.547131
7569	2026-02-22 13:00:00	7	1.21	220	374.3	t	2026-05-08 00:01:27.547131
7570	2026-02-22 13:30:00	1	1.47	220	600.4	t	2026-05-08 00:01:27.547131
7571	2026-02-22 13:30:00	4	2.09	220	435	t	2026-05-08 00:01:27.547131
7572	2026-02-22 13:30:00	7	1.13	220	388.2	t	2026-05-08 00:01:27.547131
7573	2026-02-22 14:00:00	1	2.29	220	390	t	2026-05-08 00:01:27.547131
7574	2026-02-22 14:00:00	4	1.52	220	444.2	t	2026-05-08 00:01:27.547131
7575	2026-02-22 14:00:00	7	2.91	220	467.2	t	2026-05-08 00:01:27.547131
7576	2026-02-22 14:30:00	1	2.94	220	644.6	t	2026-05-08 00:01:27.547131
7577	2026-02-22 14:30:00	4	1.39	220	265.8	t	2026-05-08 00:01:27.547131
7578	2026-02-22 14:30:00	7	2.99	220	475.3	t	2026-05-08 00:01:27.547131
7579	2026-02-22 15:00:00	1	1.39	220	591.6	t	2026-05-08 00:01:27.547131
7580	2026-02-22 15:00:00	4	1.88	220	247.9	t	2026-05-08 00:01:27.547131
7581	2026-02-22 15:00:00	7	1.24	220	328.1	t	2026-05-08 00:01:27.547131
7582	2026-02-22 15:30:00	1	1.05	220	245.6	t	2026-05-08 00:01:27.547131
7583	2026-02-22 15:30:00	4	2.07	220	450.5	t	2026-05-08 00:01:27.547131
7584	2026-02-22 15:30:00	7	1.11	220	325.2	t	2026-05-08 00:01:27.547131
7585	2026-02-22 16:00:00	1	2.06	220	367.9	t	2026-05-08 00:01:27.547131
7586	2026-02-22 16:00:00	4	1.19	220	341.5	t	2026-05-08 00:01:27.547131
7587	2026-02-22 16:00:00	7	1.35	220	474.1	t	2026-05-08 00:01:27.547131
7588	2026-02-22 16:30:00	1	1.82	220	644.7	t	2026-05-08 00:01:27.547131
7589	2026-02-22 16:30:00	4	2.18	220	479.2	t	2026-05-08 00:01:27.547131
7590	2026-02-22 16:30:00	7	1.12	220	332.3	t	2026-05-08 00:01:27.547131
7591	2026-02-22 17:00:00	1	1.42	220	486.8	t	2026-05-08 00:01:27.547131
7592	2026-02-22 17:00:00	4	2.11	220	410.1	t	2026-05-08 00:01:27.547131
7593	2026-02-22 17:00:00	7	2.42	220	433.3	t	2026-05-08 00:01:27.547131
7594	2026-02-22 17:30:00	1	2.11	220	243.6	t	2026-05-08 00:01:27.547131
7595	2026-02-22 17:30:00	4	1.61	220	491.9	t	2026-05-08 00:01:27.547131
7596	2026-02-22 17:30:00	7	1.11	220	510.6	t	2026-05-08 00:01:27.547131
7597	2026-02-22 18:00:00	1	2.52	220	289	t	2026-05-08 00:01:27.547131
7598	2026-02-22 18:00:00	4	1.76	220	432.4	t	2026-05-08 00:01:27.547131
7599	2026-02-22 18:00:00	7	2.52	220	411.8	t	2026-05-08 00:01:27.547131
7600	2026-02-22 18:30:00	1	2.07	220	275.7	t	2026-05-08 00:01:27.547131
7601	2026-02-22 18:30:00	4	1.13	220	602.7	t	2026-05-08 00:01:27.547131
7602	2026-02-22 18:30:00	7	1.39	220	291.3	t	2026-05-08 00:01:27.547131
7603	2026-02-22 19:00:00	1	1.89	220	312.7	t	2026-05-08 00:01:27.547131
7604	2026-02-22 19:00:00	4	1.31	220	586.8	t	2026-05-08 00:01:27.547131
7605	2026-02-22 19:00:00	7	1.3	220	402.3	t	2026-05-08 00:01:27.547131
7606	2026-02-22 19:30:00	1	2.06	220	518.1	t	2026-05-08 00:01:27.547131
7607	2026-02-22 19:30:00	4	2.32	220	557.3	t	2026-05-08 00:01:27.547131
7608	2026-02-22 19:30:00	7	2.27	220	397	t	2026-05-08 00:01:27.547131
7609	2026-02-22 20:00:00	1	1.62	220	266.1	t	2026-05-08 00:01:27.547131
7610	2026-02-22 20:00:00	4	2.12	220	360.7	t	2026-05-08 00:01:27.547131
7611	2026-02-22 20:00:00	7	1.28	220	537.7	t	2026-05-08 00:01:27.547131
7612	2026-02-22 20:30:00	1	1.5	220	510.1	t	2026-05-08 00:01:27.547131
7613	2026-02-22 20:30:00	4	1.03	220	477.7	t	2026-05-08 00:01:27.547131
7614	2026-02-22 20:30:00	7	2.07	220	418.1	t	2026-05-08 00:01:27.547131
7615	2026-02-22 21:00:00	1	1.63	220	257.7	t	2026-05-08 00:01:27.547131
7616	2026-02-22 21:00:00	4	1.73	220	484.7	t	2026-05-08 00:01:27.547131
7617	2026-02-22 21:00:00	7	1.41	220	609.5	t	2026-05-08 00:01:27.547131
7618	2026-02-22 21:30:00	1	1.81	220	621.4	t	2026-05-08 00:01:27.547131
7619	2026-02-22 21:30:00	4	2.67	220	516	t	2026-05-08 00:01:27.547131
7620	2026-02-22 21:30:00	7	1.36	220	282.5	t	2026-05-08 00:01:27.547131
7621	2026-02-22 22:00:00	1	2.84	220	366	t	2026-05-08 00:01:27.547131
7622	2026-02-22 22:00:00	4	1.01	220	638.5	t	2026-05-08 00:01:27.547131
7623	2026-02-22 22:00:00	7	1.13	220	338.2	t	2026-05-08 00:01:27.547131
7624	2026-02-22 22:30:00	1	1.66	220	638.4	t	2026-05-08 00:01:27.547131
7625	2026-02-22 22:30:00	4	1.48	220	403.1	t	2026-05-08 00:01:27.547131
7626	2026-02-22 22:30:00	7	1.21	220	310	t	2026-05-08 00:01:27.547131
7627	2026-02-22 23:00:00	1	1.16	220	371	t	2026-05-08 00:01:27.547131
7628	2026-02-22 23:00:00	4	1.71	220	422.3	t	2026-05-08 00:01:27.547131
7629	2026-02-22 23:00:00	7	1.04	220	494.6	t	2026-05-08 00:01:27.547131
7630	2026-02-22 23:30:00	1	2.11	220	397.4	t	2026-05-08 00:01:27.547131
7631	2026-02-22 23:30:00	4	2.55	220	319.4	t	2026-05-08 00:01:27.547131
7632	2026-02-22 23:30:00	7	2.82	220	372.3	t	2026-05-08 00:01:27.547131
7633	2026-02-23 00:00:00	1	2.36	220	369.6	t	2026-05-08 00:01:27.547131
7634	2026-02-23 00:00:00	4	2.65	220	548.1	t	2026-05-08 00:01:27.547131
7635	2026-02-23 00:00:00	7	3.06	220	286	t	2026-05-08 00:01:27.547131
7636	2026-02-23 00:30:00	1	2.65	220	327.9	t	2026-05-08 00:01:27.547131
7637	2026-02-23 00:30:00	4	1.5	220	439.3	t	2026-05-08 00:01:27.547131
7638	2026-02-23 00:30:00	7	2.55	220	520.8	t	2026-05-08 00:01:27.547131
7639	2026-02-23 01:00:00	1	1.59	220	481.2	t	2026-05-08 00:01:27.547131
7640	2026-02-23 01:00:00	4	2.95	220	609.8	t	2026-05-08 00:01:27.547131
7641	2026-02-23 01:00:00	7	2.69	220	518.6	t	2026-05-08 00:01:27.547131
7642	2026-02-23 01:30:00	1	2.46	220	435.5	t	2026-05-08 00:01:27.547131
7643	2026-02-23 01:30:00	4	3.57	220	390.8	t	2026-05-08 00:01:27.547131
7644	2026-02-23 01:30:00	7	2.75	220	297.3	t	2026-05-08 00:01:27.547131
7645	2026-02-23 02:00:00	1	1.49	220	692.9	t	2026-05-08 00:01:27.547131
7646	2026-02-23 02:00:00	4	2.39	220	479.2	t	2026-05-08 00:01:27.547131
7647	2026-02-23 02:00:00	7	1.49	220	711.5	t	2026-05-08 00:01:27.547131
7648	2026-02-23 02:30:00	1	2.11	220	322.5	t	2026-05-08 00:01:27.547131
7649	2026-02-23 02:30:00	4	2.8	220	305.5	t	2026-05-08 00:01:27.547131
7650	2026-02-23 02:30:00	7	3.17	220	371.2	t	2026-05-08 00:01:27.547131
7651	2026-02-23 03:00:00	1	2.84	220	765.2	t	2026-05-08 00:01:27.547131
7652	2026-02-23 03:00:00	4	3.21	220	779.3	t	2026-05-08 00:01:27.547131
7653	2026-02-23 03:00:00	7	3.12	220	317.2	t	2026-05-08 00:01:27.547131
7654	2026-02-23 03:30:00	1	3.49	220	427.9	t	2026-05-08 00:01:27.547131
7655	2026-02-23 03:30:00	4	2.59	220	328.5	t	2026-05-08 00:01:27.547131
7656	2026-02-23 03:30:00	7	2.37	220	526.3	t	2026-05-08 00:01:27.547131
7657	2026-02-23 04:00:00	1	1.76	220	544.3	t	2026-05-08 00:01:27.547131
7658	2026-02-23 04:00:00	4	1.26	220	763	t	2026-05-08 00:01:27.547131
7659	2026-02-23 04:00:00	7	1.3	220	429.8	t	2026-05-08 00:01:27.547131
7660	2026-02-23 04:30:00	1	2.75	220	796.7	t	2026-05-08 00:01:27.547131
7661	2026-02-23 04:30:00	4	2.13	220	482.7	t	2026-05-08 00:01:27.547131
7662	2026-02-23 04:30:00	7	2.83	220	720.7	t	2026-05-08 00:01:27.547131
7663	2026-02-23 05:00:00	1	3.25	220	426.3	t	2026-05-08 00:01:27.547131
7664	2026-02-23 05:00:00	4	1.43	220	629	t	2026-05-08 00:01:27.547131
7665	2026-02-23 05:00:00	7	1.91	220	617.3	t	2026-05-08 00:01:27.547131
7666	2026-02-23 05:30:00	1	2.42	220	384.1	t	2026-05-08 00:01:27.547131
7667	2026-02-23 05:30:00	4	1.45	220	663.2	t	2026-05-08 00:01:27.547131
7668	2026-02-23 05:30:00	7	3.24	220	775.8	t	2026-05-08 00:01:27.547131
7669	2026-02-23 06:00:00	1	1.48	220	295.3	t	2026-05-08 00:01:27.547131
7670	2026-02-23 06:00:00	4	3.47	220	687.3	t	2026-05-08 00:01:27.547131
7671	2026-02-23 06:00:00	7	2.49	220	609.6	t	2026-05-08 00:01:27.547131
7672	2026-02-23 06:30:00	1	2.66	220	689.5	t	2026-05-08 00:01:27.547131
7673	2026-02-23 06:30:00	4	1.73	220	518	t	2026-05-08 00:01:27.547131
7674	2026-02-23 06:30:00	7	1.78	220	521.3	t	2026-05-08 00:01:27.547131
7675	2026-02-23 07:00:00	1	18.18	220	3245.7	t	2026-05-08 00:01:27.547131
7676	2026-02-23 07:00:00	4	24.43	220	5679	t	2026-05-08 00:01:27.547131
7677	2026-02-23 07:00:00	7	29.12	220	6084.2	t	2026-05-08 00:01:27.547131
7678	2026-02-23 07:30:00	1	12.4	220	2970.2	t	2026-05-08 00:01:27.547131
7679	2026-02-23 07:30:00	4	22.9	220	5660.7	t	2026-05-08 00:01:27.547131
7680	2026-02-23 07:30:00	7	25.82	220	6510.9	t	2026-05-08 00:01:27.547131
7681	2026-02-23 08:00:00	1	11.8	220	3199	t	2026-05-08 00:01:27.547131
7682	2026-02-23 08:00:00	4	23.92	220	3647.2	t	2026-05-08 00:01:27.547131
7683	2026-02-23 08:00:00	7	24.54	220	5967	t	2026-05-08 00:01:27.547131
7684	2026-02-23 08:30:00	1	17.21	220	3839.3	t	2026-05-08 00:01:27.547131
7685	2026-02-23 08:30:00	4	16.56	220	5155.6	t	2026-05-08 00:01:27.547131
7686	2026-02-23 08:30:00	7	27.05	220	4878.9	t	2026-05-08 00:01:27.547131
7687	2026-02-23 09:00:00	1	15.6	220	3448.6	t	2026-05-08 00:01:27.547131
7688	2026-02-23 09:00:00	4	17.93	220	5634	t	2026-05-08 00:01:27.547131
7689	2026-02-23 09:00:00	7	23.88	220	6060.3	t	2026-05-08 00:01:27.547131
7690	2026-02-23 09:30:00	1	14.55	220	4442.7	t	2026-05-08 00:01:27.547131
7691	2026-02-23 09:30:00	4	24.04	220	3620.1	t	2026-05-08 00:01:27.547131
7692	2026-02-23 09:30:00	7	23.93	220	4871.6	t	2026-05-08 00:01:27.547131
7693	2026-02-23 10:00:00	1	20.13	220	4301.1	t	2026-05-08 00:01:27.547131
7694	2026-02-23 10:00:00	4	20.89	220	4275.6	t	2026-05-08 00:01:27.547131
7695	2026-02-23 10:00:00	7	20.82	220	5699.3	t	2026-05-08 00:01:27.547131
7696	2026-02-23 10:30:00	1	14.19	220	2800.4	t	2026-05-08 00:01:27.547131
7697	2026-02-23 10:30:00	4	22.56	220	4982.7	t	2026-05-08 00:01:27.547131
7698	2026-02-23 10:30:00	7	26.69	220	4608.7	t	2026-05-08 00:01:27.547131
7699	2026-02-23 11:00:00	1	13.71	220	4621.4	t	2026-05-08 00:01:27.547131
7700	2026-02-23 11:00:00	4	25.4	220	3692.1	t	2026-05-08 00:01:27.547131
7701	2026-02-23 11:00:00	7	25.19	220	6569.2	t	2026-05-08 00:01:27.547131
7702	2026-02-23 11:30:00	1	14.94	220	2936.2	t	2026-05-08 00:01:27.547131
7703	2026-02-23 11:30:00	4	20.75	220	5046.8	t	2026-05-08 00:01:27.547131
7704	2026-02-23 11:30:00	7	25.73	220	5774.6	t	2026-05-08 00:01:27.547131
7705	2026-02-23 12:00:00	1	13.67	220	2804.9	t	2026-05-08 00:01:27.547131
7706	2026-02-23 12:00:00	4	25.79	220	3696.2	t	2026-05-08 00:01:27.547131
7707	2026-02-23 12:00:00	7	21.99	220	6633	t	2026-05-08 00:01:27.547131
7708	2026-02-23 12:30:00	1	17.3	220	3910.2	t	2026-05-08 00:01:27.547131
7709	2026-02-23 12:30:00	4	21.36	220	4183.5	t	2026-05-08 00:01:27.547131
7710	2026-02-23 12:30:00	7	22.57	220	6077.4	t	2026-05-08 00:01:27.547131
7711	2026-02-23 13:00:00	1	19.89	220	4182.7	t	2026-05-08 00:01:27.547131
7712	2026-02-23 13:00:00	4	24.4	220	4644.9	t	2026-05-08 00:01:27.547131
7713	2026-02-23 13:00:00	7	21.65	220	5986.9	t	2026-05-08 00:01:27.547131
7714	2026-02-23 13:30:00	1	15.72	220	3258	t	2026-05-08 00:01:27.547131
7715	2026-02-23 13:30:00	4	19.68	220	5507.5	t	2026-05-08 00:01:27.547131
7716	2026-02-23 13:30:00	7	26.9	220	5314.6	t	2026-05-08 00:01:27.547131
7717	2026-02-23 14:00:00	1	15.73	220	2775.1	t	2026-05-08 00:01:27.547131
7718	2026-02-23 14:00:00	4	16.32	220	5611	t	2026-05-08 00:01:27.547131
7719	2026-02-23 14:00:00	7	24.12	220	5003.6	t	2026-05-08 00:01:27.547131
7720	2026-02-23 14:30:00	1	19.58	220	3170.2	t	2026-05-08 00:01:27.547131
7721	2026-02-23 14:30:00	4	20.01	220	4059	t	2026-05-08 00:01:27.547131
7722	2026-02-23 14:30:00	7	30.3	220	5387	t	2026-05-08 00:01:27.547131
7723	2026-02-23 15:00:00	1	14.12	220	2633.2	t	2026-05-08 00:01:27.547131
7724	2026-02-23 15:00:00	4	17.1	220	4208.9	t	2026-05-08 00:01:27.547131
7725	2026-02-23 15:00:00	7	29.08	220	5818	t	2026-05-08 00:01:27.547131
7726	2026-02-23 15:30:00	1	16.53	220	2852.8	t	2026-05-08 00:01:27.547131
7727	2026-02-23 15:30:00	4	20.84	220	4183.1	t	2026-05-08 00:01:27.547131
7728	2026-02-23 15:30:00	7	25.39	220	6152.9	t	2026-05-08 00:01:27.547131
7729	2026-02-23 16:00:00	1	21.32	220	2919.6	t	2026-05-08 00:01:27.547131
7730	2026-02-23 16:00:00	4	18.98	220	4410.1	t	2026-05-08 00:01:27.547131
7731	2026-02-23 16:00:00	7	29.34	220	6295.7	t	2026-05-08 00:01:27.547131
7732	2026-02-23 16:30:00	1	15.13	220	3077.5	t	2026-05-08 00:01:27.547131
7733	2026-02-23 16:30:00	4	18.53	220	3574.2	t	2026-05-08 00:01:27.547131
7734	2026-02-23 16:30:00	7	26.99	220	6658.2	t	2026-05-08 00:01:27.547131
7735	2026-02-23 17:00:00	1	18.33	220	3544.8	t	2026-05-08 00:01:27.547131
7736	2026-02-23 17:00:00	4	20.59	220	4722.4	t	2026-05-08 00:01:27.547131
7737	2026-02-23 17:00:00	7	29.59	220	6310.8	t	2026-05-08 00:01:27.547131
7738	2026-02-23 17:30:00	1	18.14	220	3623	t	2026-05-08 00:01:27.547131
7739	2026-02-23 17:30:00	4	17.48	220	3690	t	2026-05-08 00:01:27.547131
7740	2026-02-23 17:30:00	7	24.25	220	6555.8	t	2026-05-08 00:01:27.547131
7741	2026-02-23 18:00:00	1	21.33	220	4718.5	t	2026-05-08 00:01:27.547131
7742	2026-02-23 18:00:00	4	21.08	220	3972.5	t	2026-05-08 00:01:27.547131
7743	2026-02-23 18:00:00	7	27.18	220	5156.6	t	2026-05-08 00:01:27.547131
7744	2026-02-23 18:30:00	1	19.46	220	2843.5	t	2026-05-08 00:01:27.547131
7745	2026-02-23 18:30:00	4	21.65	220	4235.6	t	2026-05-08 00:01:27.547131
7746	2026-02-23 18:30:00	7	29.1	220	6532.2	t	2026-05-08 00:01:27.547131
7747	2026-02-23 19:00:00	1	18.86	220	4410.4	t	2026-05-08 00:01:27.547131
7748	2026-02-23 19:00:00	4	18.61	220	3849.2	t	2026-05-08 00:01:27.547131
7749	2026-02-23 19:00:00	7	25.9	220	4909.1	t	2026-05-08 00:01:27.547131
7750	2026-02-23 19:30:00	1	16.29	220	4020.7	t	2026-05-08 00:01:27.547131
7751	2026-02-23 19:30:00	4	21.96	220	5615.8	t	2026-05-08 00:01:27.547131
7752	2026-02-23 19:30:00	7	21.35	220	6252.9	t	2026-05-08 00:01:27.547131
7753	2026-02-23 20:00:00	1	2.29	220	609.3	t	2026-05-08 00:01:27.547131
7754	2026-02-23 20:00:00	4	2.39	220	471	t	2026-05-08 00:01:27.547131
7755	2026-02-23 20:00:00	7	2.53	220	290.6	t	2026-05-08 00:01:27.547131
7756	2026-02-23 20:30:00	1	1.75	220	456.8	t	2026-05-08 00:01:27.547131
7757	2026-02-23 20:30:00	4	3.38	220	324.8	t	2026-05-08 00:01:27.547131
7758	2026-02-23 20:30:00	7	3.27	220	556.7	t	2026-05-08 00:01:27.547131
7759	2026-02-23 21:00:00	1	3.51	220	365.2	t	2026-05-08 00:01:27.547131
7760	2026-02-23 21:00:00	4	2.09	220	667.3	t	2026-05-08 00:01:27.547131
7761	2026-02-23 21:00:00	7	1.83	220	376.5	t	2026-05-08 00:01:27.547131
7762	2026-02-23 21:30:00	1	1.46	220	600.5	t	2026-05-08 00:01:27.547131
7763	2026-02-23 21:30:00	4	2.27	220	600.5	t	2026-05-08 00:01:27.547131
7764	2026-02-23 21:30:00	7	1.39	220	538.5	t	2026-05-08 00:01:27.547131
7765	2026-02-23 22:00:00	1	3.04	220	520.8	t	2026-05-08 00:01:27.547131
7766	2026-02-23 22:00:00	4	2.79	220	770.8	t	2026-05-08 00:01:27.547131
7767	2026-02-23 22:00:00	7	3.13	220	439.5	t	2026-05-08 00:01:27.547131
7768	2026-02-23 22:30:00	1	2.8	220	780.9	t	2026-05-08 00:01:27.547131
7769	2026-02-23 22:30:00	4	2.48	220	347.5	t	2026-05-08 00:01:27.547131
7770	2026-02-23 22:30:00	7	1.99	220	688.8	t	2026-05-08 00:01:27.547131
7771	2026-02-23 23:00:00	1	2.18	220	630.2	t	2026-05-08 00:01:27.547131
7772	2026-02-23 23:00:00	4	2.06	220	713.8	t	2026-05-08 00:01:27.547131
7773	2026-02-23 23:00:00	7	3.25	220	340.9	t	2026-05-08 00:01:27.547131
7774	2026-02-23 23:30:00	1	3.24	220	445.3	t	2026-05-08 00:01:27.547131
7775	2026-02-23 23:30:00	4	2.1	220	421.8	t	2026-05-08 00:01:27.547131
7776	2026-02-23 23:30:00	7	1.65	220	614	t	2026-05-08 00:01:27.547131
7777	2026-02-24 00:00:00	1	3.3	220	441.6	t	2026-05-08 00:01:27.547131
7778	2026-02-24 00:00:00	4	2.66	220	462.9	t	2026-05-08 00:01:27.547131
7779	2026-02-24 00:00:00	7	2.53	220	335.5	t	2026-05-08 00:01:27.547131
7780	2026-02-24 00:30:00	1	2.15	220	683.3	t	2026-05-08 00:01:27.547131
7781	2026-02-24 00:30:00	4	3.17	220	539.3	t	2026-05-08 00:01:27.547131
7782	2026-02-24 00:30:00	7	3.41	220	645.2	t	2026-05-08 00:01:27.547131
7783	2026-02-24 01:00:00	1	2.7	220	322.9	t	2026-05-08 00:01:27.547131
7784	2026-02-24 01:00:00	4	2.37	220	795.4	t	2026-05-08 00:01:27.547131
7785	2026-02-24 01:00:00	7	1.62	220	426.6	t	2026-05-08 00:01:27.547131
7786	2026-02-24 01:30:00	1	2.39	220	674.6	t	2026-05-08 00:01:27.547131
7787	2026-02-24 01:30:00	4	2.5	220	636.2	t	2026-05-08 00:01:27.547131
7788	2026-02-24 01:30:00	7	2.59	220	767.7	t	2026-05-08 00:01:27.547131
7789	2026-02-24 02:00:00	1	1.89	220	765.9	t	2026-05-08 00:01:27.547131
7790	2026-02-24 02:00:00	4	1.4	220	658.7	t	2026-05-08 00:01:27.547131
7791	2026-02-24 02:00:00	7	3.27	220	618.7	t	2026-05-08 00:01:27.547131
7792	2026-02-24 02:30:00	1	2.61	220	539.6	t	2026-05-08 00:01:27.547131
7793	2026-02-24 02:30:00	4	1.61	220	576.3	t	2026-05-08 00:01:27.547131
7794	2026-02-24 02:30:00	7	1.73	220	587.8	t	2026-05-08 00:01:27.547131
7795	2026-02-24 03:00:00	1	1.81	220	507.3	t	2026-05-08 00:01:27.547131
7796	2026-02-24 03:00:00	4	1.73	220	647.2	t	2026-05-08 00:01:27.547131
7797	2026-02-24 03:00:00	7	1.29	220	738.1	t	2026-05-08 00:01:27.547131
7798	2026-02-24 03:30:00	1	3.04	220	475.6	t	2026-05-08 00:01:27.547131
7799	2026-02-24 03:30:00	4	2.74	220	383.5	t	2026-05-08 00:01:27.547131
7800	2026-02-24 03:30:00	7	1.54	220	626.9	t	2026-05-08 00:01:27.547131
7801	2026-02-24 04:00:00	1	3.13	220	542	t	2026-05-08 00:01:27.547131
7802	2026-02-24 04:00:00	4	2.69	220	320.8	t	2026-05-08 00:01:27.547131
7803	2026-02-24 04:00:00	7	1.79	220	724.5	t	2026-05-08 00:01:27.547131
7804	2026-02-24 04:30:00	1	2.04	220	707.8	t	2026-05-08 00:01:27.547131
7805	2026-02-24 04:30:00	4	2.39	220	379.6	t	2026-05-08 00:01:27.547131
7806	2026-02-24 04:30:00	7	3.03	220	660.6	t	2026-05-08 00:01:27.547131
7807	2026-02-24 05:00:00	1	1.52	220	470.1	t	2026-05-08 00:01:27.547131
7808	2026-02-24 05:00:00	4	1.83	220	710.3	t	2026-05-08 00:01:27.547131
7809	2026-02-24 05:00:00	7	2.13	220	279	t	2026-05-08 00:01:27.547131
7810	2026-02-24 05:30:00	1	3.15	220	376	t	2026-05-08 00:01:27.547131
7811	2026-02-24 05:30:00	4	1.74	220	285.8	t	2026-05-08 00:01:27.547131
7812	2026-02-24 05:30:00	7	1.31	220	519.6	t	2026-05-08 00:01:27.547131
7813	2026-02-24 06:00:00	1	3.49	220	592.6	t	2026-05-08 00:01:27.547131
7814	2026-02-24 06:00:00	4	1.58	220	660.9	t	2026-05-08 00:01:27.547131
7815	2026-02-24 06:00:00	7	1.22	220	320.1	t	2026-05-08 00:01:27.547131
7816	2026-02-24 06:30:00	1	3.08	220	406.6	t	2026-05-08 00:01:27.547131
7817	2026-02-24 06:30:00	4	3.62	220	599.5	t	2026-05-08 00:01:27.547131
7818	2026-02-24 06:30:00	7	3.4	220	358.4	t	2026-05-08 00:01:27.547131
7819	2026-02-24 07:00:00	1	15.42	220	3476.5	t	2026-05-08 00:01:27.547131
7820	2026-02-24 07:00:00	4	25.6	220	4573.8	t	2026-05-08 00:01:27.547131
7821	2026-02-24 07:00:00	7	28.7	220	6514.4	t	2026-05-08 00:01:27.547131
7822	2026-02-24 07:30:00	1	14.17	220	4625.2	t	2026-05-08 00:01:27.547131
7823	2026-02-24 07:30:00	4	20.22	220	5454.5	t	2026-05-08 00:01:27.547131
7824	2026-02-24 07:30:00	7	24.09	220	4788.2	t	2026-05-08 00:01:27.547131
7825	2026-02-24 08:00:00	1	12.92	220	2744.5	t	2026-05-08 00:01:27.547131
7826	2026-02-24 08:00:00	4	25.84	220	3558.4	t	2026-05-08 00:01:27.547131
7827	2026-02-24 08:00:00	7	22.72	220	5185.8	t	2026-05-08 00:01:27.547131
7828	2026-02-24 08:30:00	1	18.74	220	4396.1	t	2026-05-08 00:01:27.547131
7829	2026-02-24 08:30:00	4	20.77	220	5390.1	t	2026-05-08 00:01:27.547131
7830	2026-02-24 08:30:00	7	22.78	220	4707	t	2026-05-08 00:01:27.547131
7831	2026-02-24 09:00:00	1	19.5	220	2702.1	t	2026-05-08 00:01:27.547131
7832	2026-02-24 09:00:00	4	20.42	220	3881.3	t	2026-05-08 00:01:27.547131
7833	2026-02-24 09:00:00	7	23.56	220	5341.7	t	2026-05-08 00:01:27.547131
7834	2026-02-24 09:30:00	1	17.4	220	4584.3	t	2026-05-08 00:01:27.547131
7835	2026-02-24 09:30:00	4	20.53	220	4457.4	t	2026-05-08 00:01:27.547131
7836	2026-02-24 09:30:00	7	21.49	220	4580.2	t	2026-05-08 00:01:27.547131
7837	2026-02-24 10:00:00	1	17.19	220	4241.4	t	2026-05-08 00:01:27.547131
7838	2026-02-24 10:00:00	4	24.19	220	5575.8	t	2026-05-08 00:01:27.547131
7839	2026-02-24 10:00:00	7	29.61	220	5478.4	t	2026-05-08 00:01:27.547131
7840	2026-02-24 10:30:00	1	12.59	220	3851.5	t	2026-05-08 00:01:27.547131
7841	2026-02-24 10:30:00	4	16.7	220	3797.6	t	2026-05-08 00:01:27.547131
7842	2026-02-24 10:30:00	7	27.01	220	4779.1	t	2026-05-08 00:01:27.547131
7843	2026-02-24 11:00:00	1	20.63	220	3783.4	t	2026-05-08 00:01:27.547131
7844	2026-02-24 11:00:00	4	16.13	220	4727.9	t	2026-05-08 00:01:27.547131
7845	2026-02-24 11:00:00	7	21.69	220	6157	t	2026-05-08 00:01:27.547131
7846	2026-02-24 11:30:00	1	19.08	220	4209.7	t	2026-05-08 00:01:27.547131
7847	2026-02-24 11:30:00	4	20.7	220	4518.6	t	2026-05-08 00:01:27.547131
7848	2026-02-24 11:30:00	7	22.15	220	6275	t	2026-05-08 00:01:27.547131
7849	2026-02-24 12:00:00	1	12.87	220	2876.2	t	2026-05-08 00:01:27.547131
7850	2026-02-24 12:00:00	4	17.62	220	4652.2	t	2026-05-08 00:01:27.547131
7851	2026-02-24 12:00:00	7	26.69	220	5611.7	t	2026-05-08 00:01:27.547131
7852	2026-02-24 12:30:00	1	19.78	220	4148.3	t	2026-05-08 00:01:27.547131
7853	2026-02-24 12:30:00	4	18.05	220	4574.1	t	2026-05-08 00:01:27.547131
7854	2026-02-24 12:30:00	7	24.88	220	4729	t	2026-05-08 00:01:27.547131
7855	2026-02-24 13:00:00	1	20.78	220	4237.3	t	2026-05-08 00:01:27.547131
7856	2026-02-24 13:00:00	4	24.26	220	4795.8	t	2026-05-08 00:01:27.547131
7857	2026-02-24 13:00:00	7	28.35	220	6149.5	t	2026-05-08 00:01:27.547131
7858	2026-02-24 13:30:00	1	14.49	220	4659.2	t	2026-05-08 00:01:27.547131
7859	2026-02-24 13:30:00	4	17.24	220	3676.8	t	2026-05-08 00:01:27.547131
7860	2026-02-24 13:30:00	7	28.01	220	4534.1	t	2026-05-08 00:01:27.547131
7861	2026-02-24 14:00:00	1	19.64	220	4004.1	t	2026-05-08 00:01:27.547131
7862	2026-02-24 14:00:00	4	23.36	220	5070.9	t	2026-05-08 00:01:27.547131
7863	2026-02-24 14:00:00	7	24.15	220	5429.3	t	2026-05-08 00:01:27.547131
7864	2026-02-24 14:30:00	1	14.33	220	2786.3	t	2026-05-08 00:01:27.547131
7865	2026-02-24 14:30:00	4	17.09	220	3681.2	t	2026-05-08 00:01:27.547131
7866	2026-02-24 14:30:00	7	27.27	220	4925.6	t	2026-05-08 00:01:27.547131
7867	2026-02-24 15:00:00	1	19.37	220	4140.5	t	2026-05-08 00:01:27.547131
7868	2026-02-24 15:00:00	4	19.58	220	4061.8	t	2026-05-08 00:01:27.547131
7869	2026-02-24 15:00:00	7	30.24	220	5586.9	t	2026-05-08 00:01:27.547131
7870	2026-02-24 15:30:00	1	20.51	220	4183.7	t	2026-05-08 00:01:27.547131
7871	2026-02-24 15:30:00	4	20.85	220	5318.5	t	2026-05-08 00:01:27.547131
7872	2026-02-24 15:30:00	7	30.46	220	5133.9	t	2026-05-08 00:01:27.547131
7873	2026-02-24 16:00:00	1	18.77	220	4662	t	2026-05-08 00:01:27.547131
7874	2026-02-24 16:00:00	4	18.73	220	4412.7	t	2026-05-08 00:01:27.547131
7875	2026-02-24 16:00:00	7	24.86	220	4859.8	t	2026-05-08 00:01:27.547131
7876	2026-02-24 16:30:00	1	19.95	220	3217.6	t	2026-05-08 00:01:27.547131
7877	2026-02-24 16:30:00	4	20.62	220	5518.4	t	2026-05-08 00:01:27.547131
7878	2026-02-24 16:30:00	7	21.75	220	6366.4	t	2026-05-08 00:01:27.547131
7879	2026-02-24 17:00:00	1	18.95	220	4161.9	t	2026-05-08 00:01:27.547131
7880	2026-02-24 17:00:00	4	17.22	220	3881.4	t	2026-05-08 00:01:27.547131
7881	2026-02-24 17:00:00	7	30.36	220	5746	t	2026-05-08 00:01:27.547131
7882	2026-02-24 17:30:00	1	20.49	220	3422.3	t	2026-05-08 00:01:27.547131
7883	2026-02-24 17:30:00	4	19.5	220	5320.6	t	2026-05-08 00:01:27.547131
7884	2026-02-24 17:30:00	7	24.32	220	5660.7	t	2026-05-08 00:01:27.547131
7885	2026-02-24 18:00:00	1	20.78	220	3800	t	2026-05-08 00:01:27.547131
7886	2026-02-24 18:00:00	4	25.01	220	4932.1	t	2026-05-08 00:01:27.547131
7887	2026-02-24 18:00:00	7	26.45	220	4630.1	t	2026-05-08 00:01:27.547131
7888	2026-02-24 18:30:00	1	13.84	220	3577.5	t	2026-05-08 00:01:27.547131
7889	2026-02-24 18:30:00	4	19.85	220	3725.3	t	2026-05-08 00:01:27.547131
7890	2026-02-24 18:30:00	7	21.1	220	5361	t	2026-05-08 00:01:27.547131
7891	2026-02-24 19:00:00	1	20.24	220	3419	t	2026-05-08 00:01:27.547131
7892	2026-02-24 19:00:00	4	19.19	220	4687.2	t	2026-05-08 00:01:27.547131
7893	2026-02-24 19:00:00	7	30.08	220	4775	t	2026-05-08 00:01:27.547131
7894	2026-02-24 19:30:00	1	17.56	220	4267.2	t	2026-05-08 00:01:27.547131
7895	2026-02-24 19:30:00	4	24.37	220	4416.1	t	2026-05-08 00:01:27.547131
7896	2026-02-24 19:30:00	7	22.96	220	6497.7	t	2026-05-08 00:01:27.547131
7897	2026-02-24 20:00:00	1	2.8	220	681.7	t	2026-05-08 00:01:27.547131
7898	2026-02-24 20:00:00	4	3.09	220	484.1	t	2026-05-08 00:01:27.547131
7899	2026-02-24 20:00:00	7	2.17	220	436.4	t	2026-05-08 00:01:27.547131
7900	2026-02-24 20:30:00	1	2.45	220	376.5	t	2026-05-08 00:01:27.547131
7901	2026-02-24 20:30:00	4	2.9	220	565.1	t	2026-05-08 00:01:27.547131
7902	2026-02-24 20:30:00	7	3.62	220	466.8	t	2026-05-08 00:01:27.547131
7903	2026-02-24 21:00:00	1	2.89	220	555.4	t	2026-05-08 00:01:27.547131
7904	2026-02-24 21:00:00	4	2.73	220	713.4	t	2026-05-08 00:01:27.547131
7905	2026-02-24 21:00:00	7	2.32	220	409.7	t	2026-05-08 00:01:27.547131
7906	2026-02-24 21:30:00	1	3.41	220	394.3	t	2026-05-08 00:01:27.547131
7907	2026-02-24 21:30:00	4	1.64	220	697.5	t	2026-05-08 00:01:27.547131
7908	2026-02-24 21:30:00	7	1.67	220	584.9	t	2026-05-08 00:01:27.547131
7909	2026-02-24 22:00:00	1	1.91	220	728	t	2026-05-08 00:01:27.547131
7910	2026-02-24 22:00:00	4	1.85	220	536.1	t	2026-05-08 00:01:27.547131
7911	2026-02-24 22:00:00	7	1.92	220	616	t	2026-05-08 00:01:27.547131
7912	2026-02-24 22:30:00	1	2.44	220	469.1	t	2026-05-08 00:01:27.547131
7913	2026-02-24 22:30:00	4	2.33	220	363.6	t	2026-05-08 00:01:27.547131
7914	2026-02-24 22:30:00	7	1.61	220	340.7	t	2026-05-08 00:01:27.547131
7915	2026-02-24 23:00:00	1	2.37	220	560.2	t	2026-05-08 00:01:27.547131
7916	2026-02-24 23:00:00	4	2.43	220	620.3	t	2026-05-08 00:01:27.547131
7917	2026-02-24 23:00:00	7	2.9	220	437.7	t	2026-05-08 00:01:27.547131
7918	2026-02-24 23:30:00	1	2.14	220	295.2	t	2026-05-08 00:01:27.547131
7919	2026-02-24 23:30:00	4	2.88	220	735.9	t	2026-05-08 00:01:27.547131
7920	2026-02-24 23:30:00	7	2.3	220	572.1	t	2026-05-08 00:01:27.547131
7921	2026-02-25 00:00:00	1	1.61	220	630.7	t	2026-05-08 00:01:27.547131
7922	2026-02-25 00:00:00	4	1.65	220	462.1	t	2026-05-08 00:01:27.547131
7923	2026-02-25 00:00:00	7	1.77	220	463.7	t	2026-05-08 00:01:27.547131
7924	2026-02-25 00:30:00	1	2.04	220	576.8	t	2026-05-08 00:01:27.547131
7925	2026-02-25 00:30:00	4	3.36	220	694.3	t	2026-05-08 00:01:27.547131
7926	2026-02-25 00:30:00	7	3.35	220	719.7	t	2026-05-08 00:01:27.547131
7927	2026-02-25 01:00:00	1	1.47	220	397.1	t	2026-05-08 00:01:27.547131
7928	2026-02-25 01:00:00	4	1.98	220	608.9	t	2026-05-08 00:01:27.547131
7929	2026-02-25 01:00:00	7	2.89	220	717.1	t	2026-05-08 00:01:27.547131
7930	2026-02-25 01:30:00	1	2.28	220	619.5	t	2026-05-08 00:01:27.547131
7931	2026-02-25 01:30:00	4	2.97	220	619.4	t	2026-05-08 00:01:27.547131
7932	2026-02-25 01:30:00	7	1.79	220	647	t	2026-05-08 00:01:27.547131
7933	2026-02-25 02:00:00	1	2.93	220	749.8	t	2026-05-08 00:01:27.547131
7934	2026-02-25 02:00:00	4	2.25	220	442.8	t	2026-05-08 00:01:27.547131
7935	2026-02-25 02:00:00	7	2.18	220	795.3	t	2026-05-08 00:01:27.547131
7936	2026-02-25 02:30:00	1	3.1	220	724.2	t	2026-05-08 00:01:27.547131
7937	2026-02-25 02:30:00	4	1.48	220	630.4	t	2026-05-08 00:01:27.547131
7938	2026-02-25 02:30:00	7	1.33	220	536.7	t	2026-05-08 00:01:27.547131
7939	2026-02-25 03:00:00	1	2.27	220	358.1	t	2026-05-08 00:01:27.547131
7940	2026-02-25 03:00:00	4	2.59	220	309.2	t	2026-05-08 00:01:27.547131
7941	2026-02-25 03:00:00	7	1.68	220	349.8	t	2026-05-08 00:01:27.547131
7942	2026-02-25 03:30:00	1	1.53	220	710.9	t	2026-05-08 00:01:27.547131
7943	2026-02-25 03:30:00	4	2.37	220	739.6	t	2026-05-08 00:01:27.547131
7944	2026-02-25 03:30:00	7	2.9	220	281.7	t	2026-05-08 00:01:27.547131
7945	2026-02-25 04:00:00	1	2.59	220	587.4	t	2026-05-08 00:01:27.547131
7946	2026-02-25 04:00:00	4	3.26	220	397.3	t	2026-05-08 00:01:27.547131
7947	2026-02-25 04:00:00	7	2.42	220	758.5	t	2026-05-08 00:01:27.547131
7948	2026-02-25 04:30:00	1	2.34	220	328.4	t	2026-05-08 00:01:27.547131
7949	2026-02-25 04:30:00	4	2.83	220	454.7	t	2026-05-08 00:01:27.547131
7950	2026-02-25 04:30:00	7	1.95	220	468.9	t	2026-05-08 00:01:27.547131
7951	2026-02-25 05:00:00	1	3.69	220	344.7	t	2026-05-08 00:01:27.547131
7952	2026-02-25 05:00:00	4	1.6	220	483.1	t	2026-05-08 00:01:27.547131
7953	2026-02-25 05:00:00	7	2.99	220	747.5	t	2026-05-08 00:01:27.547131
7954	2026-02-25 05:30:00	1	1.99	220	379	t	2026-05-08 00:01:27.547131
7955	2026-02-25 05:30:00	4	2.93	220	637.9	t	2026-05-08 00:01:27.547131
7956	2026-02-25 05:30:00	7	3.36	220	358.6	t	2026-05-08 00:01:27.547131
7957	2026-02-25 06:00:00	1	1.89	220	504.1	t	2026-05-08 00:01:27.547131
7958	2026-02-25 06:00:00	4	2.16	220	685.8	t	2026-05-08 00:01:27.547131
7959	2026-02-25 06:00:00	7	3.66	220	295.6	t	2026-05-08 00:01:27.547131
7960	2026-02-25 06:30:00	1	3.64	220	599.7	t	2026-05-08 00:01:27.547131
7961	2026-02-25 06:30:00	4	3.67	220	643.2	t	2026-05-08 00:01:27.547131
7962	2026-02-25 06:30:00	7	3.4	220	792.8	t	2026-05-08 00:01:27.547131
7963	2026-02-25 07:00:00	1	12.49	220	4228.9	t	2026-05-08 00:01:27.547131
7964	2026-02-25 07:00:00	4	19.52	220	4709.5	t	2026-05-08 00:01:27.547131
7965	2026-02-25 07:00:00	7	22.35	220	4779.5	t	2026-05-08 00:01:27.547131
7966	2026-02-25 07:30:00	1	16.21	220	4277.3	t	2026-05-08 00:01:27.547131
7967	2026-02-25 07:30:00	4	23.86	220	4413.3	t	2026-05-08 00:01:27.547131
7968	2026-02-25 07:30:00	7	22.12	220	5886.8	t	2026-05-08 00:01:27.547131
7969	2026-02-25 08:00:00	1	15.73	220	4671.3	t	2026-05-08 00:01:27.547131
7970	2026-02-25 08:00:00	4	19.26	220	3635.8	t	2026-05-08 00:01:27.547131
7971	2026-02-25 08:00:00	7	25.83	220	5326.8	t	2026-05-08 00:01:27.547131
7972	2026-02-25 08:30:00	1	13.98	220	3635	t	2026-05-08 00:01:27.547131
7973	2026-02-25 08:30:00	4	21.14	220	3597.7	t	2026-05-08 00:01:27.547131
7974	2026-02-25 08:30:00	7	20.99	220	5289.9	t	2026-05-08 00:01:27.547131
7975	2026-02-25 09:00:00	1	20.6	220	3705.2	t	2026-05-08 00:01:27.547131
7976	2026-02-25 09:00:00	4	18.66	220	5282	t	2026-05-08 00:01:27.547131
7977	2026-02-25 09:00:00	7	24.86	220	5485.5	t	2026-05-08 00:01:27.547131
7978	2026-02-25 09:30:00	1	18.53	220	4455.9	t	2026-05-08 00:01:27.547131
7979	2026-02-25 09:30:00	4	22.36	220	4509.5	t	2026-05-08 00:01:27.547131
7980	2026-02-25 09:30:00	7	22.57	220	6632.8	t	2026-05-08 00:01:27.547131
7981	2026-02-25 10:00:00	1	11.95	220	2567.8	t	2026-05-08 00:01:27.547131
7982	2026-02-25 10:00:00	4	19.71	220	4811.2	t	2026-05-08 00:01:27.547131
7983	2026-02-25 10:00:00	7	22.14	220	5843.9	t	2026-05-08 00:01:27.547131
7984	2026-02-25 10:30:00	1	11.6	220	4300.2	t	2026-05-08 00:01:27.547131
7985	2026-02-25 10:30:00	4	23.41	220	4486.9	t	2026-05-08 00:01:27.547131
7986	2026-02-25 10:30:00	7	23.96	220	4550.4	t	2026-05-08 00:01:27.547131
7987	2026-02-25 11:00:00	1	18.74	220	3282.4	t	2026-05-08 00:01:27.547131
7988	2026-02-25 11:00:00	4	25.1	220	3715	t	2026-05-08 00:01:27.547131
7989	2026-02-25 11:00:00	7	27.2	220	4592.6	t	2026-05-08 00:01:27.547131
7990	2026-02-25 11:30:00	1	13.78	220	2835.5	t	2026-05-08 00:01:27.547131
7991	2026-02-25 11:30:00	4	17.73	220	4318.9	t	2026-05-08 00:01:27.547131
7992	2026-02-25 11:30:00	7	30.11	220	5505.6	t	2026-05-08 00:01:27.547131
7993	2026-02-25 12:00:00	1	20.17	220	3378.3	t	2026-05-08 00:01:27.547131
7994	2026-02-25 12:00:00	4	24.86	220	5488.1	t	2026-05-08 00:01:27.547131
7995	2026-02-25 12:00:00	7	23.68	220	6607.4	t	2026-05-08 00:01:27.547131
7996	2026-02-25 12:30:00	1	16.54	220	3518.2	t	2026-05-08 00:01:27.547131
7997	2026-02-25 12:30:00	4	23.62	220	5520.2	t	2026-05-08 00:01:27.547131
7998	2026-02-25 12:30:00	7	23.96	220	5379.8	t	2026-05-08 00:01:27.547131
7999	2026-02-25 13:00:00	1	15.49	220	4624.4	t	2026-05-08 00:01:27.547131
8000	2026-02-25 13:00:00	4	20.17	220	4652.5	t	2026-05-08 00:01:27.547131
8001	2026-02-25 13:00:00	7	23.73	220	5259	t	2026-05-08 00:01:27.547131
8002	2026-02-25 13:30:00	1	14.53	220	3611.2	t	2026-05-08 00:01:27.547131
8003	2026-02-25 13:30:00	4	25.56	220	5637.7	t	2026-05-08 00:01:27.547131
8004	2026-02-25 13:30:00	7	26.69	220	6618	t	2026-05-08 00:01:27.547131
8005	2026-02-25 14:00:00	1	11.65	220	4524.9	t	2026-05-08 00:01:27.547131
8006	2026-02-25 14:00:00	4	16.63	220	4226.1	t	2026-05-08 00:01:27.547131
8007	2026-02-25 14:00:00	7	26.17	220	5526	t	2026-05-08 00:01:27.547131
8008	2026-02-25 14:30:00	1	14.15	220	3588.3	t	2026-05-08 00:01:27.547131
8009	2026-02-25 14:30:00	4	23.22	220	3922.2	t	2026-05-08 00:01:27.547131
8010	2026-02-25 14:30:00	7	29.93	220	4721.5	t	2026-05-08 00:01:27.547131
8011	2026-02-25 15:00:00	1	13.8	220	3623.5	t	2026-05-08 00:01:27.547131
8012	2026-02-25 15:00:00	4	19.43	220	4417.6	t	2026-05-08 00:01:27.547131
8013	2026-02-25 15:00:00	7	29.37	220	6189.2	t	2026-05-08 00:01:27.547131
8014	2026-02-25 15:30:00	1	19.81	220	4020	t	2026-05-08 00:01:27.547131
8015	2026-02-25 15:30:00	4	19.56	220	3621.4	t	2026-05-08 00:01:27.547131
8016	2026-02-25 15:30:00	7	23.86	220	6345.9	t	2026-05-08 00:01:27.547131
8017	2026-02-25 16:00:00	1	12.61	220	4029.1	t	2026-05-08 00:01:27.547131
8018	2026-02-25 16:00:00	4	22.23	220	4196.3	t	2026-05-08 00:01:27.547131
8019	2026-02-25 16:00:00	7	29.13	220	5618.8	t	2026-05-08 00:01:27.547131
8020	2026-02-25 16:30:00	1	19.42	220	3580.1	t	2026-05-08 00:01:27.547131
8021	2026-02-25 16:30:00	4	24.44	220	5052.2	t	2026-05-08 00:01:27.547131
8022	2026-02-25 16:30:00	7	28.09	220	6438.6	t	2026-05-08 00:01:27.547131
8023	2026-02-25 17:00:00	1	17.22	220	3889.6	t	2026-05-08 00:01:27.547131
8024	2026-02-25 17:00:00	4	23.49	220	3917.8	t	2026-05-08 00:01:27.547131
8025	2026-02-25 17:00:00	7	27.52	220	5883.7	t	2026-05-08 00:01:27.547131
8026	2026-02-25 17:30:00	1	18.46	220	4133.2	t	2026-05-08 00:01:27.547131
8027	2026-02-25 17:30:00	4	25.32	220	5597.1	t	2026-05-08 00:01:27.547131
8028	2026-02-25 17:30:00	7	22.32	220	5724.6	t	2026-05-08 00:01:27.547131
8029	2026-02-25 18:00:00	1	21.39	220	3268.4	t	2026-05-08 00:01:27.547131
8030	2026-02-25 18:00:00	4	21.61	220	4720.1	t	2026-05-08 00:01:27.547131
8031	2026-02-25 18:00:00	7	27.33	220	6273.8	t	2026-05-08 00:01:27.547131
8032	2026-02-25 18:30:00	1	12.11	220	3775.8	t	2026-05-08 00:01:27.547131
8033	2026-02-25 18:30:00	4	21.81	220	5065	t	2026-05-08 00:01:27.547131
8034	2026-02-25 18:30:00	7	29.04	220	5407.4	t	2026-05-08 00:01:27.547131
8035	2026-02-25 19:00:00	1	11.67	220	3676.1	t	2026-05-08 00:01:27.547131
8036	2026-02-25 19:00:00	4	22.39	220	4190.3	t	2026-05-08 00:01:27.547131
8037	2026-02-25 19:00:00	7	29.19	220	5697.3	t	2026-05-08 00:01:27.547131
8038	2026-02-25 19:30:00	1	16.96	220	2877.4	t	2026-05-08 00:01:27.547131
8039	2026-02-25 19:30:00	4	21.89	220	3550.4	t	2026-05-08 00:01:27.547131
8040	2026-02-25 19:30:00	7	30.34	220	5327	t	2026-05-08 00:01:27.547131
8041	2026-02-25 20:00:00	1	2.7	220	319.3	t	2026-05-08 00:01:27.547131
8042	2026-02-25 20:00:00	4	2.23	220	374.5	t	2026-05-08 00:01:27.547131
8043	2026-02-25 20:00:00	7	1.68	220	391.5	t	2026-05-08 00:01:27.547131
8044	2026-02-25 20:30:00	1	1.58	220	431.3	t	2026-05-08 00:01:27.547131
8045	2026-02-25 20:30:00	4	3.22	220	384.2	t	2026-05-08 00:01:27.547131
8046	2026-02-25 20:30:00	7	1.54	220	661.3	t	2026-05-08 00:01:27.547131
8047	2026-02-25 21:00:00	1	3.47	220	504.2	t	2026-05-08 00:01:27.547131
8048	2026-02-25 21:00:00	4	3.64	220	332.4	t	2026-05-08 00:01:27.547131
8049	2026-02-25 21:00:00	7	3.41	220	780.1	t	2026-05-08 00:01:27.547131
8050	2026-02-25 21:30:00	1	2.39	220	401.7	t	2026-05-08 00:01:27.547131
8051	2026-02-25 21:30:00	4	2.09	220	528.2	t	2026-05-08 00:01:27.547131
8052	2026-02-25 21:30:00	7	2.42	220	653.6	t	2026-05-08 00:01:27.547131
8053	2026-02-25 22:00:00	1	1.23	220	658.1	t	2026-05-08 00:01:27.547131
8054	2026-02-25 22:00:00	4	1.41	220	642.6	t	2026-05-08 00:01:27.547131
8055	2026-02-25 22:00:00	7	1.87	220	777.5	t	2026-05-08 00:01:27.547131
8056	2026-02-25 22:30:00	1	2.48	220	352.3	t	2026-05-08 00:01:27.547131
8057	2026-02-25 22:30:00	4	3.04	220	802.1	t	2026-05-08 00:01:27.547131
8058	2026-02-25 22:30:00	7	1.27	220	397.1	t	2026-05-08 00:01:27.547131
8059	2026-02-25 23:00:00	1	2.93	220	354.8	t	2026-05-08 00:01:27.547131
8060	2026-02-25 23:00:00	4	2.76	220	590.3	t	2026-05-08 00:01:27.547131
8061	2026-02-25 23:00:00	7	2.55	220	732.6	t	2026-05-08 00:01:27.547131
8062	2026-02-25 23:30:00	1	1.76	220	699.6	t	2026-05-08 00:01:27.547131
8063	2026-02-25 23:30:00	4	3.68	220	730.7	t	2026-05-08 00:01:27.547131
8064	2026-02-25 23:30:00	7	2.86	220	762.9	t	2026-05-08 00:01:27.547131
8065	2026-02-26 00:00:00	1	1.81	220	515.8	t	2026-05-08 00:01:27.547131
8066	2026-02-26 00:00:00	4	2.63	220	537.4	t	2026-05-08 00:01:27.547131
8067	2026-02-26 00:00:00	7	2.97	220	413.3	t	2026-05-08 00:01:27.547131
8068	2026-02-26 00:30:00	1	2.63	220	632.1	t	2026-05-08 00:01:27.547131
8069	2026-02-26 00:30:00	4	1.55	220	766.8	t	2026-05-08 00:01:27.547131
8070	2026-02-26 00:30:00	7	3.62	220	642.1	t	2026-05-08 00:01:27.547131
8071	2026-02-26 01:00:00	1	1.46	220	466.7	t	2026-05-08 00:01:27.547131
8072	2026-02-26 01:00:00	4	3.6	220	289.5	t	2026-05-08 00:01:27.547131
8073	2026-02-26 01:00:00	7	2.41	220	698.4	t	2026-05-08 00:01:27.547131
8074	2026-02-26 01:30:00	1	3.59	220	653.2	t	2026-05-08 00:01:27.547131
8075	2026-02-26 01:30:00	4	2.13	220	451.3	t	2026-05-08 00:01:27.547131
8076	2026-02-26 01:30:00	7	2.99	220	411.8	t	2026-05-08 00:01:27.547131
8077	2026-02-26 02:00:00	1	2.66	220	560.4	t	2026-05-08 00:01:27.547131
8078	2026-02-26 02:00:00	4	2.49	220	455.4	t	2026-05-08 00:01:27.547131
8079	2026-02-26 02:00:00	7	2.68	220	439.3	t	2026-05-08 00:01:27.547131
8080	2026-02-26 02:30:00	1	3.17	220	473	t	2026-05-08 00:01:27.547131
8081	2026-02-26 02:30:00	4	3.26	220	470.3	t	2026-05-08 00:01:27.547131
8082	2026-02-26 02:30:00	7	3.32	220	636.8	t	2026-05-08 00:01:27.547131
8083	2026-02-26 03:00:00	1	1.59	220	331.8	t	2026-05-08 00:01:27.547131
8084	2026-02-26 03:00:00	4	1.86	220	281.6	t	2026-05-08 00:01:27.547131
8085	2026-02-26 03:00:00	7	2.6	220	768.6	t	2026-05-08 00:01:27.547131
8086	2026-02-26 03:30:00	1	2.3	220	287.1	t	2026-05-08 00:01:27.547131
8087	2026-02-26 03:30:00	4	1.32	220	279.7	t	2026-05-08 00:01:27.547131
8088	2026-02-26 03:30:00	7	1.92	220	517.9	t	2026-05-08 00:01:27.547131
8089	2026-02-26 04:00:00	1	3.19	220	447.3	t	2026-05-08 00:01:27.547131
8090	2026-02-26 04:00:00	4	2.79	220	493.1	t	2026-05-08 00:01:27.547131
8091	2026-02-26 04:00:00	7	3.43	220	399.1	t	2026-05-08 00:01:27.547131
8092	2026-02-26 04:30:00	1	2.02	220	344.7	t	2026-05-08 00:01:27.547131
8093	2026-02-26 04:30:00	4	2.47	220	304.6	t	2026-05-08 00:01:27.547131
8094	2026-02-26 04:30:00	7	1.66	220	658.8	t	2026-05-08 00:01:27.547131
8095	2026-02-26 05:00:00	1	1.7	220	441.2	t	2026-05-08 00:01:27.547131
8096	2026-02-26 05:00:00	4	3.38	220	750.7	t	2026-05-08 00:01:27.547131
8097	2026-02-26 05:00:00	7	1.65	220	622.3	t	2026-05-08 00:01:27.547131
8098	2026-02-26 05:30:00	1	2.9	220	528.6	t	2026-05-08 00:01:27.547131
8099	2026-02-26 05:30:00	4	3.49	220	318.9	t	2026-05-08 00:01:27.547131
8100	2026-02-26 05:30:00	7	2.08	220	326.6	t	2026-05-08 00:01:27.547131
8101	2026-02-26 06:00:00	1	2.67	220	414.1	t	2026-05-08 00:01:27.547131
8102	2026-02-26 06:00:00	4	2.78	220	482.7	t	2026-05-08 00:01:27.547131
8103	2026-02-26 06:00:00	7	3.32	220	473.3	t	2026-05-08 00:01:27.547131
8104	2026-02-26 06:30:00	1	1.46	220	346.4	t	2026-05-08 00:01:27.547131
8105	2026-02-26 06:30:00	4	3.03	220	645.2	t	2026-05-08 00:01:27.547131
8106	2026-02-26 06:30:00	7	2.4	220	399.1	t	2026-05-08 00:01:27.547131
8107	2026-02-26 07:00:00	1	12.77	220	4066.2	t	2026-05-08 00:01:27.547131
8108	2026-02-26 07:00:00	4	23.05	220	4469.9	t	2026-05-08 00:01:27.547131
8109	2026-02-26 07:00:00	7	25.99	220	6487	t	2026-05-08 00:01:27.547131
8110	2026-02-26 07:30:00	1	14.16	220	4180.9	t	2026-05-08 00:01:27.547131
8111	2026-02-26 07:30:00	4	16.44	220	4458.7	t	2026-05-08 00:01:27.547131
8112	2026-02-26 07:30:00	7	26.78	220	6050.3	t	2026-05-08 00:01:27.547131
8113	2026-02-26 08:00:00	1	20.97	220	2863.8	t	2026-05-08 00:01:27.547131
8114	2026-02-26 08:00:00	4	18.26	220	3544.4	t	2026-05-08 00:01:27.547131
8115	2026-02-26 08:00:00	7	25.69	220	5339.9	t	2026-05-08 00:01:27.547131
8116	2026-02-26 08:30:00	1	14.86	220	3853.8	t	2026-05-08 00:01:27.547131
8117	2026-02-26 08:30:00	4	24.87	220	4718.3	t	2026-05-08 00:01:27.547131
8118	2026-02-26 08:30:00	7	21.25	220	4670.1	t	2026-05-08 00:01:27.547131
8119	2026-02-26 09:00:00	1	12.08	220	3467.8	t	2026-05-08 00:01:27.547131
8120	2026-02-26 09:00:00	4	16.09	220	4387.5	t	2026-05-08 00:01:27.547131
8121	2026-02-26 09:00:00	7	20.79	220	5179.7	t	2026-05-08 00:01:27.547131
8122	2026-02-26 09:30:00	1	12.9	220	4710.8	t	2026-05-08 00:01:27.547131
8123	2026-02-26 09:30:00	4	20.01	220	4032.2	t	2026-05-08 00:01:27.547131
8124	2026-02-26 09:30:00	7	29.86	220	4887.7	t	2026-05-08 00:01:27.547131
8125	2026-02-26 10:00:00	1	12.03	220	3474.7	t	2026-05-08 00:01:27.547131
8126	2026-02-26 10:00:00	4	17.89	220	4147.2	t	2026-05-08 00:01:27.547131
8127	2026-02-26 10:00:00	7	25.08	220	6209.6	t	2026-05-08 00:01:27.547131
8128	2026-02-26 10:30:00	1	19.99	220	4691.2	t	2026-05-08 00:01:27.547131
8129	2026-02-26 10:30:00	4	17.46	220	3947	t	2026-05-08 00:01:27.547131
8130	2026-02-26 10:30:00	7	26.61	220	5380.3	t	2026-05-08 00:01:27.547131
8131	2026-02-26 11:00:00	1	18.65	220	4194.9	t	2026-05-08 00:01:27.547131
8132	2026-02-26 11:00:00	4	17.98	220	4599.1	t	2026-05-08 00:01:27.547131
8133	2026-02-26 11:00:00	7	24.82	220	5680.9	t	2026-05-08 00:01:27.547131
8134	2026-02-26 11:30:00	1	18.86	220	4551.9	t	2026-05-08 00:01:27.547131
8135	2026-02-26 11:30:00	4	23.07	220	3914.8	t	2026-05-08 00:01:27.547131
8136	2026-02-26 11:30:00	7	29.54	220	5106.6	t	2026-05-08 00:01:27.547131
8137	2026-02-26 12:00:00	1	14.18	220	4593.6	t	2026-05-08 00:01:27.547131
8138	2026-02-26 12:00:00	4	25.67	220	3874.9	t	2026-05-08 00:01:27.547131
8139	2026-02-26 12:00:00	7	25.02	220	5516.9	t	2026-05-08 00:01:27.547131
8140	2026-02-26 12:30:00	1	18.31	220	3476.3	t	2026-05-08 00:01:27.547131
8141	2026-02-26 12:30:00	4	21.48	220	4671	t	2026-05-08 00:01:27.547131
8142	2026-02-26 12:30:00	7	22.95	220	6151.6	t	2026-05-08 00:01:27.547131
8143	2026-02-26 13:00:00	1	14.27	220	4009.4	t	2026-05-08 00:01:27.547131
8144	2026-02-26 13:00:00	4	24.65	220	4295.9	t	2026-05-08 00:01:27.547131
8145	2026-02-26 13:00:00	7	28.05	220	5235.9	t	2026-05-08 00:01:27.547131
8146	2026-02-26 13:30:00	1	14.68	220	4071.2	t	2026-05-08 00:01:27.547131
8147	2026-02-26 13:30:00	4	21.9	220	4070.5	t	2026-05-08 00:01:27.547131
8148	2026-02-26 13:30:00	7	27.21	220	6334.5	t	2026-05-08 00:01:27.547131
8149	2026-02-26 14:00:00	1	17.91	220	4204.3	t	2026-05-08 00:01:27.547131
8150	2026-02-26 14:00:00	4	22.49	220	3623.8	t	2026-05-08 00:01:27.547131
8151	2026-02-26 14:00:00	7	29.48	220	5100.2	t	2026-05-08 00:01:27.547131
8152	2026-02-26 14:30:00	1	16.93	220	2979.8	t	2026-05-08 00:01:27.547131
8153	2026-02-26 14:30:00	4	19.95	220	5362.4	t	2026-05-08 00:01:27.547131
8154	2026-02-26 14:30:00	7	21.51	220	6348.6	t	2026-05-08 00:01:27.547131
8155	2026-02-26 15:00:00	1	16.42	220	4306.3	t	2026-05-08 00:01:27.547131
8156	2026-02-26 15:00:00	4	20.44	220	4098.1	t	2026-05-08 00:01:27.547131
8157	2026-02-26 15:00:00	7	24.28	220	4940.1	t	2026-05-08 00:01:27.547131
8158	2026-02-26 15:30:00	1	13.4	220	2937.1	t	2026-05-08 00:01:27.547131
8159	2026-02-26 15:30:00	4	25.75	220	5377.2	t	2026-05-08 00:01:27.547131
8160	2026-02-26 15:30:00	7	25.99	220	6374	t	2026-05-08 00:01:27.547131
8161	2026-02-26 16:00:00	1	17.03	220	4580.2	t	2026-05-08 00:01:27.547131
8162	2026-02-26 16:00:00	4	20.85	220	5660.5	t	2026-05-08 00:01:27.547131
8163	2026-02-26 16:00:00	7	27.8	220	4750.9	t	2026-05-08 00:01:27.547131
8164	2026-02-26 16:30:00	1	21.29	220	3596.9	t	2026-05-08 00:01:27.547131
8165	2026-02-26 16:30:00	4	17.51	220	4341.8	t	2026-05-08 00:01:27.547131
8166	2026-02-26 16:30:00	7	28.72	220	4761.9	t	2026-05-08 00:01:27.547131
8167	2026-02-26 17:00:00	1	18.63	220	3251	t	2026-05-08 00:01:27.547131
8168	2026-02-26 17:00:00	4	20.47	220	5135.4	t	2026-05-08 00:01:27.547131
8169	2026-02-26 17:00:00	7	28.87	220	4657.3	t	2026-05-08 00:01:27.547131
8170	2026-02-26 17:30:00	1	13.99	220	3585	t	2026-05-08 00:01:27.547131
8171	2026-02-26 17:30:00	4	20.88	220	4136.3	t	2026-05-08 00:01:27.547131
8172	2026-02-26 17:30:00	7	26.22	220	6629.8	t	2026-05-08 00:01:27.547131
8173	2026-02-26 18:00:00	1	21	220	3005.8	t	2026-05-08 00:01:27.547131
8174	2026-02-26 18:00:00	4	19.85	220	5156.4	t	2026-05-08 00:01:27.547131
8175	2026-02-26 18:00:00	7	30.1	220	5569.3	t	2026-05-08 00:01:27.547131
8176	2026-02-26 18:30:00	1	19.11	220	3199.5	t	2026-05-08 00:01:27.547131
8177	2026-02-26 18:30:00	4	16.85	220	3829.4	t	2026-05-08 00:01:27.547131
8178	2026-02-26 18:30:00	7	22.5	220	5300	t	2026-05-08 00:01:27.547131
8179	2026-02-26 19:00:00	1	19.76	220	3347.7	t	2026-05-08 00:01:27.547131
8180	2026-02-26 19:00:00	4	18.64	220	3974.4	t	2026-05-08 00:01:27.547131
8181	2026-02-26 19:00:00	7	30.02	220	5040.8	t	2026-05-08 00:01:27.547131
8182	2026-02-26 19:30:00	1	16.44	220	4666	t	2026-05-08 00:01:27.547131
8183	2026-02-26 19:30:00	4	16.61	220	4124.9	t	2026-05-08 00:01:27.547131
8184	2026-02-26 19:30:00	7	23.56	220	4780.5	t	2026-05-08 00:01:27.547131
8185	2026-02-26 20:00:00	1	2.55	220	515.8	t	2026-05-08 00:01:27.547131
8186	2026-02-26 20:00:00	4	2.48	220	280.6	t	2026-05-08 00:01:27.547131
8187	2026-02-26 20:00:00	7	3.5	220	312.8	t	2026-05-08 00:01:27.547131
8188	2026-02-26 20:30:00	1	1.89	220	600	t	2026-05-08 00:01:27.547131
8189	2026-02-26 20:30:00	4	1.6	220	704.1	t	2026-05-08 00:01:27.547131
8190	2026-02-26 20:30:00	7	2.88	220	683.1	t	2026-05-08 00:01:27.547131
8191	2026-02-26 21:00:00	1	2.82	220	311.5	t	2026-05-08 00:01:27.547131
8192	2026-02-26 21:00:00	4	2.44	220	554	t	2026-05-08 00:01:27.547131
8193	2026-02-26 21:00:00	7	2.7	220	464.3	t	2026-05-08 00:01:27.547131
8194	2026-02-26 21:30:00	1	1.59	220	337	t	2026-05-08 00:01:27.547131
8195	2026-02-26 21:30:00	4	3.5	220	270.6	t	2026-05-08 00:01:27.547131
8196	2026-02-26 21:30:00	7	1.71	220	541.2	t	2026-05-08 00:01:27.547131
8197	2026-02-26 22:00:00	1	2.03	220	734.7	t	2026-05-08 00:01:27.547131
8198	2026-02-26 22:00:00	4	2.99	220	639.4	t	2026-05-08 00:01:27.547131
8199	2026-02-26 22:00:00	7	1.56	220	620.6	t	2026-05-08 00:01:27.547131
8200	2026-02-26 22:30:00	1	3.26	220	649.5	t	2026-05-08 00:01:27.547131
8201	2026-02-26 22:30:00	4	1.58	220	522.4	t	2026-05-08 00:01:27.547131
8202	2026-02-26 22:30:00	7	2.45	220	419.1	t	2026-05-08 00:01:27.547131
8203	2026-02-26 23:00:00	1	3.08	220	413.1	t	2026-05-08 00:01:27.547131
8204	2026-02-26 23:00:00	4	1.97	220	671.3	t	2026-05-08 00:01:27.547131
8205	2026-02-26 23:00:00	7	2.88	220	476.9	t	2026-05-08 00:01:27.547131
8206	2026-02-26 23:30:00	1	2.86	220	764.3	t	2026-05-08 00:01:27.547131
8207	2026-02-26 23:30:00	4	3.46	220	281	t	2026-05-08 00:01:27.547131
8208	2026-02-26 23:30:00	7	3.19	220	777.7	t	2026-05-08 00:01:27.547131
8209	2026-02-27 00:00:00	1	1.62	220	748.3	t	2026-05-08 00:01:27.547131
8210	2026-02-27 00:00:00	4	3.55	220	272.4	t	2026-05-08 00:01:27.547131
8211	2026-02-27 00:00:00	7	2.62	220	799.8	t	2026-05-08 00:01:27.547131
8212	2026-02-27 00:30:00	1	2.2	220	652	t	2026-05-08 00:01:27.547131
8213	2026-02-27 00:30:00	4	3.3	220	729.3	t	2026-05-08 00:01:27.547131
8214	2026-02-27 00:30:00	7	3.2	220	441.1	t	2026-05-08 00:01:27.547131
8215	2026-02-27 01:00:00	1	1.35	220	458	t	2026-05-08 00:01:27.547131
8216	2026-02-27 01:00:00	4	2.02	220	340.9	t	2026-05-08 00:01:27.547131
8217	2026-02-27 01:00:00	7	3.59	220	779	t	2026-05-08 00:01:27.547131
8218	2026-02-27 01:30:00	1	2.12	220	605	t	2026-05-08 00:01:27.547131
8219	2026-02-27 01:30:00	4	2.3	220	305.6	t	2026-05-08 00:01:27.547131
8220	2026-02-27 01:30:00	7	2.12	220	655.1	t	2026-05-08 00:01:27.547131
8221	2026-02-27 02:00:00	1	2.59	220	389.1	t	2026-05-08 00:01:27.547131
8222	2026-02-27 02:00:00	4	2.06	220	393.3	t	2026-05-08 00:01:27.547131
8223	2026-02-27 02:00:00	7	1.89	220	780	t	2026-05-08 00:01:27.547131
8224	2026-02-27 02:30:00	1	2.7	220	444.9	t	2026-05-08 00:01:27.547131
8225	2026-02-27 02:30:00	4	2.33	220	330.9	t	2026-05-08 00:01:27.547131
8226	2026-02-27 02:30:00	7	1.84	220	703.3	t	2026-05-08 00:01:27.547131
8227	2026-02-27 03:00:00	1	2.22	220	322.9	t	2026-05-08 00:01:27.547131
8228	2026-02-27 03:00:00	4	2.57	220	365	t	2026-05-08 00:01:27.547131
8229	2026-02-27 03:00:00	7	3.56	220	784.2	t	2026-05-08 00:01:27.547131
8230	2026-02-27 03:30:00	1	1.21	220	629.8	t	2026-05-08 00:01:27.547131
8231	2026-02-27 03:30:00	4	2.1	220	505.9	t	2026-05-08 00:01:27.547131
8232	2026-02-27 03:30:00	7	3.35	220	663.9	t	2026-05-08 00:01:27.547131
8233	2026-02-27 04:00:00	1	1.53	220	578	t	2026-05-08 00:01:27.547131
8234	2026-02-27 04:00:00	4	2.48	220	516.2	t	2026-05-08 00:01:27.547131
8235	2026-02-27 04:00:00	7	2.7	220	641.6	t	2026-05-08 00:01:27.547131
8236	2026-02-27 04:30:00	1	2.11	220	803.9	t	2026-05-08 00:01:27.547131
8237	2026-02-27 04:30:00	4	1.26	220	608.7	t	2026-05-08 00:01:27.547131
8238	2026-02-27 04:30:00	7	2.04	220	500.9	t	2026-05-08 00:01:27.547131
8239	2026-02-27 05:00:00	1	2.01	220	272.9	t	2026-05-08 00:01:27.547131
8240	2026-02-27 05:00:00	4	2.73	220	566.8	t	2026-05-08 00:01:27.547131
8241	2026-02-27 05:00:00	7	1.52	220	644.7	t	2026-05-08 00:01:27.547131
8242	2026-02-27 05:30:00	1	2.64	220	498.8	t	2026-05-08 00:01:27.547131
8243	2026-02-27 05:30:00	4	3.65	220	418	t	2026-05-08 00:01:27.547131
8244	2026-02-27 05:30:00	7	1.86	220	685.8	t	2026-05-08 00:01:27.547131
8245	2026-02-27 06:00:00	1	3.43	220	577.4	t	2026-05-08 00:01:27.547131
8246	2026-02-27 06:00:00	4	3.64	220	501.8	t	2026-05-08 00:01:27.547131
8247	2026-02-27 06:00:00	7	3.13	220	432.3	t	2026-05-08 00:01:27.547131
8248	2026-02-27 06:30:00	1	1.24	220	596	t	2026-05-08 00:01:27.547131
8249	2026-02-27 06:30:00	4	2.83	220	718	t	2026-05-08 00:01:27.547131
8250	2026-02-27 06:30:00	7	2.21	220	684.5	t	2026-05-08 00:01:27.547131
8251	2026-02-27 07:00:00	1	20.46	220	3345.9	t	2026-05-08 00:01:27.547131
8252	2026-02-27 07:00:00	4	19.19	220	4021.8	t	2026-05-08 00:01:27.547131
8253	2026-02-27 07:00:00	7	22.9	220	5333.9	t	2026-05-08 00:01:27.547131
8254	2026-02-27 07:30:00	1	19.08	220	4623.9	t	2026-05-08 00:01:27.547131
8255	2026-02-27 07:30:00	4	17.77	220	3661.1	t	2026-05-08 00:01:27.547131
8256	2026-02-27 07:30:00	7	20.59	220	6539	t	2026-05-08 00:01:27.547131
8257	2026-02-27 08:00:00	1	12.4	220	4222.5	t	2026-05-08 00:01:27.547131
8258	2026-02-27 08:00:00	4	20.43	220	5672.5	t	2026-05-08 00:01:27.547131
8259	2026-02-27 08:00:00	7	28.87	220	6356	t	2026-05-08 00:01:27.547131
8260	2026-02-27 08:30:00	1	14.41	220	3470	t	2026-05-08 00:01:27.547131
8261	2026-02-27 08:30:00	4	24.14	220	4488	t	2026-05-08 00:01:27.547131
8262	2026-02-27 08:30:00	7	29.78	220	6662.5	t	2026-05-08 00:01:27.547131
8263	2026-02-27 09:00:00	1	11.74	220	3247	t	2026-05-08 00:01:27.547131
8264	2026-02-27 09:00:00	4	18.05	220	5129.4	t	2026-05-08 00:01:27.547131
8265	2026-02-27 09:00:00	7	29.03	220	6106.8	t	2026-05-08 00:01:27.547131
8266	2026-02-27 09:30:00	1	14.52	220	3389.9	t	2026-05-08 00:01:27.547131
8267	2026-02-27 09:30:00	4	21.27	220	4364.2	t	2026-05-08 00:01:27.547131
8268	2026-02-27 09:30:00	7	21.39	220	5960.7	t	2026-05-08 00:01:27.547131
8269	2026-02-27 10:00:00	1	11.78	220	4646.7	t	2026-05-08 00:01:27.547131
8270	2026-02-27 10:00:00	4	21.34	220	5646.4	t	2026-05-08 00:01:27.547131
8271	2026-02-27 10:00:00	7	29.36	220	6003.1	t	2026-05-08 00:01:27.547131
8272	2026-02-27 10:30:00	1	12.66	220	3649.8	t	2026-05-08 00:01:27.547131
8273	2026-02-27 10:30:00	4	20.17	220	4841.2	t	2026-05-08 00:01:27.547131
8274	2026-02-27 10:30:00	7	21.87	220	5860.5	t	2026-05-08 00:01:27.547131
8275	2026-02-27 11:00:00	1	18.16	220	2914.5	t	2026-05-08 00:01:27.547131
8276	2026-02-27 11:00:00	4	16.07	220	5305	t	2026-05-08 00:01:27.547131
8277	2026-02-27 11:00:00	7	20.87	220	4858.9	t	2026-05-08 00:01:27.547131
8278	2026-02-27 11:30:00	1	19.4	220	2588.1	t	2026-05-08 00:01:27.547131
8279	2026-02-27 11:30:00	4	21.42	220	4173.5	t	2026-05-08 00:01:27.547131
8280	2026-02-27 11:30:00	7	21.98	220	5634.1	t	2026-05-08 00:01:27.547131
8281	2026-02-27 12:00:00	1	15.58	220	3079.5	t	2026-05-08 00:01:27.547131
8282	2026-02-27 12:00:00	4	18.96	220	4304.1	t	2026-05-08 00:01:27.547131
8283	2026-02-27 12:00:00	7	30.07	220	6701.7	t	2026-05-08 00:01:27.547131
8284	2026-02-27 12:30:00	1	16.66	220	4191	t	2026-05-08 00:01:27.547131
8285	2026-02-27 12:30:00	4	18.26	220	4739.5	t	2026-05-08 00:01:27.547131
8286	2026-02-27 12:30:00	7	25.48	220	5386	t	2026-05-08 00:01:27.547131
8287	2026-02-27 13:00:00	1	17.36	220	4521.9	t	2026-05-08 00:01:27.547131
8288	2026-02-27 13:00:00	4	23.45	220	4484	t	2026-05-08 00:01:27.547131
8289	2026-02-27 13:00:00	7	22.13	220	6120.4	t	2026-05-08 00:01:27.547131
8290	2026-02-27 13:30:00	1	18.67	220	3703	t	2026-05-08 00:01:27.547131
8291	2026-02-27 13:30:00	4	18.37	220	4602.2	t	2026-05-08 00:01:27.547131
8292	2026-02-27 13:30:00	7	21.85	220	6327.2	t	2026-05-08 00:01:27.547131
8293	2026-02-27 14:00:00	1	20.31	220	3614.4	t	2026-05-08 00:01:27.547131
8294	2026-02-27 14:00:00	4	23.54	220	4469.8	t	2026-05-08 00:01:27.547131
8295	2026-02-27 14:00:00	7	24.6	220	5105.1	t	2026-05-08 00:01:27.547131
8296	2026-02-27 14:30:00	1	14.19	220	3447.2	t	2026-05-08 00:01:27.547131
8297	2026-02-27 14:30:00	4	22.89	220	3625.5	t	2026-05-08 00:01:27.547131
8298	2026-02-27 14:30:00	7	24.5	220	6116.3	t	2026-05-08 00:01:27.547131
8299	2026-02-27 15:00:00	1	12.11	220	4376.4	t	2026-05-08 00:01:27.547131
8300	2026-02-27 15:00:00	4	23.76	220	3969	t	2026-05-08 00:01:27.547131
8301	2026-02-27 15:00:00	7	29.37	220	4618.8	t	2026-05-08 00:01:27.547131
8302	2026-02-27 15:30:00	1	16.52	220	3491.1	t	2026-05-08 00:01:27.547131
8303	2026-02-27 15:30:00	4	22.15	220	3872.3	t	2026-05-08 00:01:27.547131
8304	2026-02-27 15:30:00	7	28.73	220	4760.5	t	2026-05-08 00:01:27.547131
8305	2026-02-27 16:00:00	1	14.33	220	3445	t	2026-05-08 00:01:27.547131
8306	2026-02-27 16:00:00	4	24.18	220	3876.4	t	2026-05-08 00:01:27.547131
8307	2026-02-27 16:00:00	7	23.88	220	6438.4	t	2026-05-08 00:01:27.547131
8308	2026-02-27 16:30:00	1	19.65	220	4180.2	t	2026-05-08 00:01:27.547131
8309	2026-02-27 16:30:00	4	22.28	220	4536.8	t	2026-05-08 00:01:27.547131
8310	2026-02-27 16:30:00	7	20.72	220	6530.9	t	2026-05-08 00:01:27.547131
8311	2026-02-27 17:00:00	1	11.7	220	3497.2	t	2026-05-08 00:01:27.547131
8312	2026-02-27 17:00:00	4	18.14	220	3819.2	t	2026-05-08 00:01:27.547131
8313	2026-02-27 17:00:00	7	22.77	220	5400.3	t	2026-05-08 00:01:27.547131
8314	2026-02-27 17:30:00	1	13.43	220	3827.2	t	2026-05-08 00:01:27.547131
8315	2026-02-27 17:30:00	4	17.01	220	5668.9	t	2026-05-08 00:01:27.547131
8316	2026-02-27 17:30:00	7	27.56	220	5199	t	2026-05-08 00:01:27.547131
8317	2026-02-27 18:00:00	1	17.88	220	3830.6	t	2026-05-08 00:01:27.547131
8318	2026-02-27 18:00:00	4	24.39	220	4154.4	t	2026-05-08 00:01:27.547131
8319	2026-02-27 18:00:00	7	21.48	220	4863	t	2026-05-08 00:01:27.547131
8320	2026-02-27 18:30:00	1	15.97	220	4290.2	t	2026-05-08 00:01:27.547131
8321	2026-02-27 18:30:00	4	21.33	220	3604.7	t	2026-05-08 00:01:27.547131
8322	2026-02-27 18:30:00	7	21.25	220	6125.1	t	2026-05-08 00:01:27.547131
8323	2026-02-27 19:00:00	1	17.53	220	3952.3	t	2026-05-08 00:01:27.547131
8324	2026-02-27 19:00:00	4	16.76	220	5351.7	t	2026-05-08 00:01:27.547131
8325	2026-02-27 19:00:00	7	23.23	220	5880.8	t	2026-05-08 00:01:27.547131
8326	2026-02-27 19:30:00	1	19.12	220	3380.4	t	2026-05-08 00:01:27.547131
8327	2026-02-27 19:30:00	4	17.38	220	5651	t	2026-05-08 00:01:27.547131
8328	2026-02-27 19:30:00	7	28.61	220	5224.5	t	2026-05-08 00:01:27.547131
8329	2026-02-27 20:00:00	1	1.38	220	618	t	2026-05-08 00:01:27.547131
8330	2026-02-27 20:00:00	4	2.7	220	542.7	t	2026-05-08 00:01:27.547131
8331	2026-02-27 20:00:00	7	2.42	220	430.5	t	2026-05-08 00:01:27.547131
8332	2026-02-27 20:30:00	1	2.84	220	440.2	t	2026-05-08 00:01:27.547131
8333	2026-02-27 20:30:00	4	3.6	220	398.8	t	2026-05-08 00:01:27.547131
8334	2026-02-27 20:30:00	7	1.92	220	574.1	t	2026-05-08 00:01:27.547131
8335	2026-02-27 21:00:00	1	1.55	220	801	t	2026-05-08 00:01:27.547131
8336	2026-02-27 21:00:00	4	3.54	220	453.6	t	2026-05-08 00:01:27.547131
8337	2026-02-27 21:00:00	7	2.58	220	683.5	t	2026-05-08 00:01:27.547131
8338	2026-02-27 21:30:00	1	2.05	220	299	t	2026-05-08 00:01:27.547131
8339	2026-02-27 21:30:00	4	2	220	428.7	t	2026-05-08 00:01:27.547131
8340	2026-02-27 21:30:00	7	1.42	220	571.7	t	2026-05-08 00:01:27.547131
8341	2026-02-27 22:00:00	1	2.28	220	367.2	t	2026-05-08 00:01:27.547131
8342	2026-02-27 22:00:00	4	2.18	220	788	t	2026-05-08 00:01:27.547131
8343	2026-02-27 22:00:00	7	3.14	220	442.9	t	2026-05-08 00:01:27.547131
8344	2026-02-27 22:30:00	1	3.12	220	305.7	t	2026-05-08 00:01:27.547131
8345	2026-02-27 22:30:00	4	1.75	220	324.7	t	2026-05-08 00:01:27.547131
8346	2026-02-27 22:30:00	7	3.52	220	791.5	t	2026-05-08 00:01:27.547131
8347	2026-02-27 23:00:00	1	1.22	220	403.8	t	2026-05-08 00:01:27.547131
8348	2026-02-27 23:00:00	4	3.38	220	518.3	t	2026-05-08 00:01:27.547131
8349	2026-02-27 23:00:00	7	3.29	220	404.1	t	2026-05-08 00:01:27.547131
8350	2026-02-27 23:30:00	1	2.6	220	740.2	t	2026-05-08 00:01:27.547131
8351	2026-02-27 23:30:00	4	2.96	220	447.9	t	2026-05-08 00:01:27.547131
8352	2026-02-27 23:30:00	7	3.39	220	497.5	t	2026-05-08 00:01:27.547131
8353	2026-02-28 00:00:00	1	1.44	220	255.1	t	2026-05-08 00:01:27.547131
8354	2026-02-28 00:00:00	4	2.22	220	618.9	t	2026-05-08 00:01:27.547131
8355	2026-02-28 00:00:00	7	2.61	220	560	t	2026-05-08 00:01:27.547131
8356	2026-02-28 00:30:00	1	2.53	220	438.5	t	2026-05-08 00:01:27.547131
8357	2026-02-28 00:30:00	4	1.05	220	236.3	t	2026-05-08 00:01:27.547131
8358	2026-02-28 00:30:00	7	2.5	220	486.5	t	2026-05-08 00:01:27.547131
8359	2026-02-28 01:00:00	1	2.12	220	491.1	t	2026-05-08 00:01:27.547131
8360	2026-02-28 01:00:00	4	2.51	220	514.9	t	2026-05-08 00:01:27.547131
8361	2026-02-28 01:00:00	7	2.96	220	431.9	t	2026-05-08 00:01:27.547131
8362	2026-02-28 01:30:00	1	2.79	220	605.3	t	2026-05-08 00:01:27.547131
8363	2026-02-28 01:30:00	4	2.24	220	281.9	t	2026-05-08 00:01:27.547131
8364	2026-02-28 01:30:00	7	2.99	220	303.7	t	2026-05-08 00:01:27.547131
8365	2026-02-28 02:00:00	1	2.17	220	464.3	t	2026-05-08 00:01:27.547131
8366	2026-02-28 02:00:00	4	1.71	220	226.2	t	2026-05-08 00:01:27.547131
8367	2026-02-28 02:00:00	7	2.68	220	497.3	t	2026-05-08 00:01:27.547131
8368	2026-02-28 02:30:00	1	1.81	220	422.1	t	2026-05-08 00:01:27.547131
8369	2026-02-28 02:30:00	4	2.19	220	246.1	t	2026-05-08 00:01:27.547131
8370	2026-02-28 02:30:00	7	2.23	220	625.6	t	2026-05-08 00:01:27.547131
8371	2026-02-28 03:00:00	1	1.32	220	607.3	t	2026-05-08 00:01:27.547131
8372	2026-02-28 03:00:00	4	2.28	220	307.6	t	2026-05-08 00:01:27.547131
8373	2026-02-28 03:00:00	7	2.18	220	620.5	t	2026-05-08 00:01:27.547131
8374	2026-02-28 03:30:00	1	1.12	220	476.6	t	2026-05-08 00:01:27.547131
8375	2026-02-28 03:30:00	4	1.49	220	220.9	t	2026-05-08 00:01:27.547131
8376	2026-02-28 03:30:00	7	2.5	220	446.4	t	2026-05-08 00:01:27.547131
8377	2026-02-28 04:00:00	1	1.95	220	373.5	t	2026-05-08 00:01:27.547131
8378	2026-02-28 04:00:00	4	1.87	220	498.3	t	2026-05-08 00:01:27.547131
8379	2026-02-28 04:00:00	7	2.22	220	634.2	t	2026-05-08 00:01:27.547131
8380	2026-02-28 04:30:00	1	1.89	220	318.8	t	2026-05-08 00:01:27.547131
8381	2026-02-28 04:30:00	4	1.53	220	523	t	2026-05-08 00:01:27.547131
8382	2026-02-28 04:30:00	7	2.57	220	301.3	t	2026-05-08 00:01:27.547131
8383	2026-02-28 05:00:00	1	1.58	220	568.9	t	2026-05-08 00:01:27.547131
8384	2026-02-28 05:00:00	4	2.35	220	451.5	t	2026-05-08 00:01:27.547131
8385	2026-02-28 05:00:00	7	2.19	220	645	t	2026-05-08 00:01:27.547131
8386	2026-02-28 05:30:00	1	2.94	220	433.9	t	2026-05-08 00:01:27.547131
8387	2026-02-28 05:30:00	4	1.84	220	583.6	t	2026-05-08 00:01:27.547131
8388	2026-02-28 05:30:00	7	1.24	220	225	t	2026-05-08 00:01:27.547131
8389	2026-02-28 06:00:00	1	1.52	220	284	t	2026-05-08 00:01:27.547131
8390	2026-02-28 06:00:00	4	3	220	419.9	t	2026-05-08 00:01:27.547131
8391	2026-02-28 06:00:00	7	2.59	220	473	t	2026-05-08 00:01:27.547131
8392	2026-02-28 06:30:00	1	1.96	220	438.5	t	2026-05-08 00:01:27.547131
8393	2026-02-28 06:30:00	4	1.74	220	255.1	t	2026-05-08 00:01:27.547131
8394	2026-02-28 06:30:00	7	2.66	220	328.7	t	2026-05-08 00:01:27.547131
8395	2026-02-28 07:00:00	1	2.27	220	580.8	t	2026-05-08 00:01:27.547131
8396	2026-02-28 07:00:00	4	1.34	220	505.5	t	2026-05-08 00:01:27.547131
8397	2026-02-28 07:00:00	7	2.32	220	550.3	t	2026-05-08 00:01:27.547131
8398	2026-02-28 07:30:00	1	1.1	220	292.4	t	2026-05-08 00:01:27.547131
8399	2026-02-28 07:30:00	4	2.57	220	462.6	t	2026-05-08 00:01:27.547131
8400	2026-02-28 07:30:00	7	1.74	220	350.3	t	2026-05-08 00:01:27.547131
8401	2026-02-28 08:00:00	1	1.29	220	495.5	t	2026-05-08 00:01:27.547131
8402	2026-02-28 08:00:00	4	2.33	220	632.5	t	2026-05-08 00:01:27.547131
8403	2026-02-28 08:00:00	7	2.52	220	570.5	t	2026-05-08 00:01:27.547131
8404	2026-02-28 08:30:00	1	2.03	220	635.5	t	2026-05-08 00:01:27.547131
8405	2026-02-28 08:30:00	4	2.32	220	483.7	t	2026-05-08 00:01:27.547131
8406	2026-02-28 08:30:00	7	2.61	220	225.4	t	2026-05-08 00:01:27.547131
8407	2026-02-28 09:00:00	1	2.19	220	447.9	t	2026-05-08 00:01:27.547131
8408	2026-02-28 09:00:00	4	1.38	220	516.9	t	2026-05-08 00:01:27.547131
8409	2026-02-28 09:00:00	7	1.04	220	526.7	t	2026-05-08 00:01:27.547131
8410	2026-02-28 09:30:00	1	2.64	220	370.3	t	2026-05-08 00:01:27.547131
8411	2026-02-28 09:30:00	4	1.82	220	492.9	t	2026-05-08 00:01:27.547131
8412	2026-02-28 09:30:00	7	2.7	220	280.2	t	2026-05-08 00:01:27.547131
8413	2026-02-28 10:00:00	1	1.15	220	530.2	t	2026-05-08 00:01:27.547131
8414	2026-02-28 10:00:00	4	1.28	220	502.4	t	2026-05-08 00:01:27.547131
8415	2026-02-28 10:00:00	7	2.16	220	255.8	t	2026-05-08 00:01:27.547131
8416	2026-02-28 10:30:00	1	2.75	220	477.9	t	2026-05-08 00:01:27.547131
8417	2026-02-28 10:30:00	4	1.33	220	278.1	t	2026-05-08 00:01:27.547131
8418	2026-02-28 10:30:00	7	1.83	220	601.7	t	2026-05-08 00:01:27.547131
8419	2026-02-28 11:00:00	1	1.59	220	622.9	t	2026-05-08 00:01:27.547131
8420	2026-02-28 11:00:00	4	2.55	220	438.7	t	2026-05-08 00:01:27.547131
8421	2026-02-28 11:00:00	7	2.55	220	603	t	2026-05-08 00:01:27.547131
8422	2026-02-28 11:30:00	1	1.86	220	436.9	t	2026-05-08 00:01:27.547131
8423	2026-02-28 11:30:00	4	2.51	220	444.8	t	2026-05-08 00:01:27.547131
8424	2026-02-28 11:30:00	7	1.23	220	412.1	t	2026-05-08 00:01:27.547131
8425	2026-02-28 12:00:00	1	1.24	220	348.1	t	2026-05-08 00:01:27.547131
8426	2026-02-28 12:00:00	4	2.39	220	485.4	t	2026-05-08 00:01:27.547131
8427	2026-02-28 12:00:00	7	1.09	220	226.4	t	2026-05-08 00:01:27.547131
8428	2026-02-28 12:30:00	1	2.09	220	363.9	t	2026-05-08 00:01:27.547131
8429	2026-02-28 12:30:00	4	2.81	220	509.8	t	2026-05-08 00:01:27.547131
8430	2026-02-28 12:30:00	7	2.38	220	430	t	2026-05-08 00:01:27.547131
8431	2026-02-28 13:00:00	1	1.76	220	332.1	t	2026-05-08 00:01:27.547131
8432	2026-02-28 13:00:00	4	2.17	220	385.3	t	2026-05-08 00:01:27.547131
8433	2026-02-28 13:00:00	7	1.58	220	467.8	t	2026-05-08 00:01:27.547131
8434	2026-02-28 13:30:00	1	2.23	220	410.6	t	2026-05-08 00:01:27.547131
8435	2026-02-28 13:30:00	4	1.11	220	579.1	t	2026-05-08 00:01:27.547131
8436	2026-02-28 13:30:00	7	2.24	220	483.2	t	2026-05-08 00:01:27.547131
8437	2026-02-28 14:00:00	1	1.2	220	574.1	t	2026-05-08 00:01:27.547131
8438	2026-02-28 14:00:00	4	1.38	220	294.4	t	2026-05-08 00:01:27.547131
8439	2026-02-28 14:00:00	7	2.68	220	304.7	t	2026-05-08 00:01:27.547131
8440	2026-02-28 14:30:00	1	1.73	220	364.3	t	2026-05-08 00:01:27.547131
8441	2026-02-28 14:30:00	4	2.98	220	426.5	t	2026-05-08 00:01:27.547131
8442	2026-02-28 14:30:00	7	2.85	220	524.3	t	2026-05-08 00:01:27.547131
8443	2026-02-28 15:00:00	1	2.47	220	562.9	t	2026-05-08 00:01:27.547131
8444	2026-02-28 15:00:00	4	2.44	220	391.1	t	2026-05-08 00:01:27.547131
8445	2026-02-28 15:00:00	7	1.35	220	375.5	t	2026-05-08 00:01:27.547131
8446	2026-02-28 15:30:00	1	1.1	220	562.2	t	2026-05-08 00:01:27.547131
8447	2026-02-28 15:30:00	4	1.14	220	405	t	2026-05-08 00:01:27.547131
8448	2026-02-28 15:30:00	7	2.11	220	222.7	t	2026-05-08 00:01:27.547131
8449	2026-02-28 16:00:00	1	2.26	220	241.8	t	2026-05-08 00:01:27.547131
8450	2026-02-28 16:00:00	4	2.93	220	491.7	t	2026-05-08 00:01:27.547131
8451	2026-02-28 16:00:00	7	1.54	220	262.7	t	2026-05-08 00:01:27.547131
8452	2026-02-28 16:30:00	1	2.52	220	502.2	t	2026-05-08 00:01:27.547131
8453	2026-02-28 16:30:00	4	1.84	220	657.4	t	2026-05-08 00:01:27.547131
8454	2026-02-28 16:30:00	7	2.13	220	460.6	t	2026-05-08 00:01:27.547131
8455	2026-02-28 17:00:00	1	2.59	220	446	t	2026-05-08 00:01:27.547131
8456	2026-02-28 17:00:00	4	2.85	220	256.2	t	2026-05-08 00:01:27.547131
8457	2026-02-28 17:00:00	7	2.25	220	361.7	t	2026-05-08 00:01:27.547131
8458	2026-02-28 17:30:00	1	1.26	220	505.4	t	2026-05-08 00:01:27.547131
8459	2026-02-28 17:30:00	4	1.98	220	632.5	t	2026-05-08 00:01:27.547131
8460	2026-02-28 17:30:00	7	1.76	220	241.3	t	2026-05-08 00:01:27.547131
8461	2026-02-28 18:00:00	1	2.61	220	508.1	t	2026-05-08 00:01:27.547131
8462	2026-02-28 18:00:00	4	1.52	220	221.7	t	2026-05-08 00:01:27.547131
8463	2026-02-28 18:00:00	7	2.81	220	261.6	t	2026-05-08 00:01:27.547131
8464	2026-02-28 18:30:00	1	2.18	220	621.5	t	2026-05-08 00:01:27.547131
8465	2026-02-28 18:30:00	4	2.53	220	479.1	t	2026-05-08 00:01:27.547131
8466	2026-02-28 18:30:00	7	2.87	220	630.3	t	2026-05-08 00:01:27.547131
8467	2026-02-28 19:00:00	1	2.11	220	570	t	2026-05-08 00:01:27.547131
8468	2026-02-28 19:00:00	4	2.81	220	512	t	2026-05-08 00:01:27.547131
8469	2026-02-28 19:00:00	7	1.93	220	312.6	t	2026-05-08 00:01:27.547131
8470	2026-02-28 19:30:00	1	1.83	220	229.1	t	2026-05-08 00:01:27.547131
8471	2026-02-28 19:30:00	4	1.33	220	598.5	t	2026-05-08 00:01:27.547131
8472	2026-02-28 19:30:00	7	2.06	220	304	t	2026-05-08 00:01:27.547131
8473	2026-02-28 20:00:00	1	2.31	220	380.1	t	2026-05-08 00:01:27.547131
8474	2026-02-28 20:00:00	4	2.31	220	637.7	t	2026-05-08 00:01:27.547131
8475	2026-02-28 20:00:00	7	2.66	220	304.5	t	2026-05-08 00:01:27.547131
8476	2026-02-28 20:30:00	1	1.1	220	276	t	2026-05-08 00:01:27.547131
8477	2026-02-28 20:30:00	4	2.29	220	270.8	t	2026-05-08 00:01:27.547131
8478	2026-02-28 20:30:00	7	2.47	220	376.5	t	2026-05-08 00:01:27.547131
8479	2026-02-28 21:00:00	1	2.98	220	375	t	2026-05-08 00:01:27.547131
8480	2026-02-28 21:00:00	4	1.44	220	286.6	t	2026-05-08 00:01:27.547131
8481	2026-02-28 21:00:00	7	2.94	220	288	t	2026-05-08 00:01:27.547131
8482	2026-02-28 21:30:00	1	2.2	220	511	t	2026-05-08 00:01:27.547131
8483	2026-02-28 21:30:00	4	1.15	220	606.7	t	2026-05-08 00:01:27.547131
8484	2026-02-28 21:30:00	7	1.11	220	512.3	t	2026-05-08 00:01:27.547131
8485	2026-02-28 22:00:00	1	2.47	220	618	t	2026-05-08 00:01:27.547131
8486	2026-02-28 22:00:00	4	1.67	220	545.5	t	2026-05-08 00:01:27.547131
8487	2026-02-28 22:00:00	7	1.47	220	541.7	t	2026-05-08 00:01:27.547131
8488	2026-02-28 22:30:00	1	1.17	220	316.2	t	2026-05-08 00:01:27.547131
8489	2026-02-28 22:30:00	4	2.7	220	435.3	t	2026-05-08 00:01:27.547131
8490	2026-02-28 22:30:00	7	1.6	220	644.1	t	2026-05-08 00:01:27.547131
8491	2026-02-28 23:00:00	1	2.39	220	301.3	t	2026-05-08 00:01:27.547131
8492	2026-02-28 23:00:00	4	1.49	220	319.4	t	2026-05-08 00:01:27.547131
8493	2026-02-28 23:00:00	7	2.51	220	545.8	t	2026-05-08 00:01:27.547131
8494	2026-02-28 23:30:00	1	2.26	220	615.3	t	2026-05-08 00:01:27.547131
8495	2026-02-28 23:30:00	4	1.27	220	422.4	t	2026-05-08 00:01:27.547131
8496	2026-02-28 23:30:00	7	2.56	220	600.8	t	2026-05-08 00:01:27.547131
8497	2026-03-01 00:00:00	1	1.44	220	586.7	t	2026-05-08 00:01:27.547131
8498	2026-03-01 00:00:00	4	2.74	220	593.8	t	2026-05-08 00:01:27.547131
8499	2026-03-01 00:00:00	7	2.79	220	229.6	t	2026-05-08 00:01:27.547131
8500	2026-03-01 00:30:00	1	1.41	220	285.2	t	2026-05-08 00:01:27.547131
8501	2026-03-01 00:30:00	4	2.83	220	617.4	t	2026-05-08 00:01:27.547131
8502	2026-03-01 00:30:00	7	2.64	220	391.9	t	2026-05-08 00:01:27.547131
8503	2026-03-01 01:00:00	1	2.93	220	594.4	t	2026-05-08 00:01:27.547131
8504	2026-03-01 01:00:00	4	2.93	220	401.9	t	2026-05-08 00:01:27.547131
8505	2026-03-01 01:00:00	7	1.99	220	519.3	t	2026-05-08 00:01:27.547131
8506	2026-03-01 01:30:00	1	2.37	220	542.5	t	2026-05-08 00:01:27.547131
8507	2026-03-01 01:30:00	4	2.1	220	538.9	t	2026-05-08 00:01:27.547131
8508	2026-03-01 01:30:00	7	1.8	220	271.8	t	2026-05-08 00:01:27.547131
8509	2026-03-01 02:00:00	1	1.4	220	341	t	2026-05-08 00:01:27.547131
8510	2026-03-01 02:00:00	4	2.26	220	318.2	t	2026-05-08 00:01:27.547131
8511	2026-03-01 02:00:00	7	1.21	220	394.6	t	2026-05-08 00:01:27.547131
8512	2026-03-01 02:30:00	1	1.48	220	340.1	t	2026-05-08 00:01:27.547131
8513	2026-03-01 02:30:00	4	2.73	220	374.7	t	2026-05-08 00:01:27.547131
8514	2026-03-01 02:30:00	7	1.38	220	516.9	t	2026-05-08 00:01:27.547131
8515	2026-03-01 03:00:00	1	2.15	220	582.8	t	2026-05-08 00:01:27.547131
8516	2026-03-01 03:00:00	4	2.18	220	477.3	t	2026-05-08 00:01:27.547131
8517	2026-03-01 03:00:00	7	1.59	220	327.3	t	2026-05-08 00:01:27.547131
8518	2026-03-01 03:30:00	1	2.79	220	320.3	t	2026-05-08 00:01:27.547131
8519	2026-03-01 03:30:00	4	1.12	220	461.9	t	2026-05-08 00:01:27.547131
8520	2026-03-01 03:30:00	7	1.67	220	509.8	t	2026-05-08 00:01:27.547131
8521	2026-03-01 04:00:00	1	1.39	220	329.8	t	2026-05-08 00:01:27.547131
8522	2026-03-01 04:00:00	4	2.77	220	369.6	t	2026-05-08 00:01:27.547131
8523	2026-03-01 04:00:00	7	2.14	220	513.7	t	2026-05-08 00:01:27.547131
8524	2026-03-01 04:30:00	1	1.34	220	656.1	t	2026-05-08 00:01:27.547131
8525	2026-03-01 04:30:00	4	1.25	220	459.5	t	2026-05-08 00:01:27.547131
8526	2026-03-01 04:30:00	7	1.11	220	404.3	t	2026-05-08 00:01:27.547131
8527	2026-03-01 05:00:00	1	1.64	220	359.8	t	2026-05-08 00:01:27.547131
8528	2026-03-01 05:00:00	4	2.9	220	640.1	t	2026-05-08 00:01:27.547131
8529	2026-03-01 05:00:00	7	1.71	220	602.8	t	2026-05-08 00:01:27.547131
8530	2026-03-01 05:30:00	1	1.69	220	241.7	t	2026-05-08 00:01:27.547131
8531	2026-03-01 05:30:00	4	2.67	220	512.6	t	2026-05-08 00:01:27.547131
8532	2026-03-01 05:30:00	7	1.01	220	418.2	t	2026-05-08 00:01:27.547131
8533	2026-03-01 06:00:00	1	2.07	220	389.9	t	2026-05-08 00:01:27.547131
8534	2026-03-01 06:00:00	4	1.67	220	330.8	t	2026-05-08 00:01:27.547131
8535	2026-03-01 06:00:00	7	2.22	220	351.5	t	2026-05-08 00:01:27.547131
8536	2026-03-01 06:30:00	1	1.82	220	550.3	t	2026-05-08 00:01:27.547131
8537	2026-03-01 06:30:00	4	1.39	220	535	t	2026-05-08 00:01:27.547131
8538	2026-03-01 06:30:00	7	1.43	220	492.1	t	2026-05-08 00:01:27.547131
8539	2026-03-01 07:00:00	1	1.45	220	269.6	t	2026-05-08 00:01:27.547131
8540	2026-03-01 07:00:00	4	1.39	220	563.8	t	2026-05-08 00:01:27.547131
8541	2026-03-01 07:00:00	7	2.03	220	358	t	2026-05-08 00:01:27.547131
8542	2026-03-01 07:30:00	1	2.49	220	555.3	t	2026-05-08 00:01:27.547131
8543	2026-03-01 07:30:00	4	2.21	220	447.1	t	2026-05-08 00:01:27.547131
8544	2026-03-01 07:30:00	7	1.86	220	345.2	t	2026-05-08 00:01:27.547131
8545	2026-03-01 08:00:00	1	2.04	220	347.3	t	2026-05-08 00:01:27.547131
8546	2026-03-01 08:00:00	4	1.55	220	553.3	t	2026-05-08 00:01:27.547131
8547	2026-03-01 08:00:00	7	2.03	220	308.4	t	2026-05-08 00:01:27.547131
8548	2026-03-01 08:30:00	1	2.9	220	489.3	t	2026-05-08 00:01:27.547131
8549	2026-03-01 08:30:00	4	2.34	220	292.4	t	2026-05-08 00:01:27.547131
8550	2026-03-01 08:30:00	7	2.53	220	301.3	t	2026-05-08 00:01:27.547131
8551	2026-03-01 09:00:00	1	1.64	220	402	t	2026-05-08 00:01:27.547131
8552	2026-03-01 09:00:00	4	2.94	220	370.1	t	2026-05-08 00:01:27.547131
8553	2026-03-01 09:00:00	7	1.29	220	573.9	t	2026-05-08 00:01:27.547131
8554	2026-03-01 09:30:00	1	2.64	220	274	t	2026-05-08 00:01:27.547131
8555	2026-03-01 09:30:00	4	2.76	220	498.2	t	2026-05-08 00:01:27.547131
8556	2026-03-01 09:30:00	7	2.41	220	459.8	t	2026-05-08 00:01:27.547131
8557	2026-03-01 10:00:00	1	1.05	220	421.2	t	2026-05-08 00:01:27.547131
8558	2026-03-01 10:00:00	4	2.14	220	600.3	t	2026-05-08 00:01:27.547131
8559	2026-03-01 10:00:00	7	1.66	220	395	t	2026-05-08 00:01:27.547131
8560	2026-03-01 10:30:00	1	2.24	220	291	t	2026-05-08 00:01:27.547131
8561	2026-03-01 10:30:00	4	2.39	220	375.1	t	2026-05-08 00:01:27.547131
8562	2026-03-01 10:30:00	7	1.49	220	639.6	t	2026-05-08 00:01:27.547131
8563	2026-03-01 11:00:00	1	1.11	220	345.5	t	2026-05-08 00:01:27.547131
8564	2026-03-01 11:00:00	4	1.75	220	654.1	t	2026-05-08 00:01:27.547131
8565	2026-03-01 11:00:00	7	1.34	220	518.8	t	2026-05-08 00:01:27.547131
8566	2026-03-01 11:30:00	1	2.11	220	432.7	t	2026-05-08 00:01:27.547131
8567	2026-03-01 11:30:00	4	1.31	220	271	t	2026-05-08 00:01:27.547131
8568	2026-03-01 11:30:00	7	2.82	220	387.1	t	2026-05-08 00:01:27.547131
8569	2026-03-01 12:00:00	1	1.34	220	349.1	t	2026-05-08 00:01:27.547131
8570	2026-03-01 12:00:00	4	2.05	220	378.7	t	2026-05-08 00:01:27.547131
8571	2026-03-01 12:00:00	7	2.75	220	452.1	t	2026-05-08 00:01:27.547131
8572	2026-03-01 12:30:00	1	1.63	220	443.4	t	2026-05-08 00:01:27.547131
8573	2026-03-01 12:30:00	4	2.23	220	574.4	t	2026-05-08 00:01:27.547131
8574	2026-03-01 12:30:00	7	2.82	220	611.5	t	2026-05-08 00:01:27.547131
8575	2026-03-01 13:00:00	1	2.67	220	378.2	t	2026-05-08 00:01:27.547131
8576	2026-03-01 13:00:00	4	2.93	220	221.6	t	2026-05-08 00:01:27.547131
8577	2026-03-01 13:00:00	7	2.51	220	551.8	t	2026-05-08 00:01:27.547131
8578	2026-03-01 13:30:00	1	3	220	489	t	2026-05-08 00:01:27.547131
8579	2026-03-01 13:30:00	4	2.85	220	297.6	t	2026-05-08 00:01:27.547131
8580	2026-03-01 13:30:00	7	1.42	220	323	t	2026-05-08 00:01:27.547131
8581	2026-03-01 14:00:00	1	1.87	220	574.3	t	2026-05-08 00:01:27.547131
8582	2026-03-01 14:00:00	4	2.68	220	431.3	t	2026-05-08 00:01:27.547131
8583	2026-03-01 14:00:00	7	1.16	220	573.6	t	2026-05-08 00:01:27.547131
8584	2026-03-01 14:30:00	1	1.48	220	649.1	t	2026-05-08 00:01:27.547131
8585	2026-03-01 14:30:00	4	2.43	220	243.9	t	2026-05-08 00:01:27.547131
8586	2026-03-01 14:30:00	7	3	220	337.8	t	2026-05-08 00:01:27.547131
8587	2026-03-01 15:00:00	1	2.65	220	539.6	t	2026-05-08 00:01:27.547131
8588	2026-03-01 15:00:00	4	1.54	220	222.7	t	2026-05-08 00:01:27.547131
8589	2026-03-01 15:00:00	7	2.58	220	583.5	t	2026-05-08 00:01:27.547131
8590	2026-03-01 15:30:00	1	2.92	220	424.7	t	2026-05-08 00:01:27.547131
8591	2026-03-01 15:30:00	4	2.44	220	394.1	t	2026-05-08 00:01:27.547131
8592	2026-03-01 15:30:00	7	1.37	220	225	t	2026-05-08 00:01:27.547131
8593	2026-03-01 16:00:00	1	1.34	220	571.4	t	2026-05-08 00:01:27.547131
8594	2026-03-01 16:00:00	4	1.04	220	607.5	t	2026-05-08 00:01:27.547131
8595	2026-03-01 16:00:00	7	1.61	220	373.6	t	2026-05-08 00:01:27.547131
8596	2026-03-01 16:30:00	1	1.62	220	318.1	t	2026-05-08 00:01:27.547131
8597	2026-03-01 16:30:00	4	1.58	220	578	t	2026-05-08 00:01:27.547131
8598	2026-03-01 16:30:00	7	2.68	220	312.9	t	2026-05-08 00:01:27.547131
8599	2026-03-01 17:00:00	1	1.31	220	619.5	t	2026-05-08 00:01:27.547131
8600	2026-03-01 17:00:00	4	1.72	220	372.6	t	2026-05-08 00:01:27.547131
8601	2026-03-01 17:00:00	7	2.83	220	453.7	t	2026-05-08 00:01:27.547131
8602	2026-03-01 17:30:00	1	1.23	220	502.7	t	2026-05-08 00:01:27.547131
8603	2026-03-01 17:30:00	4	1.96	220	264.5	t	2026-05-08 00:01:27.547131
8604	2026-03-01 17:30:00	7	2.42	220	221.9	t	2026-05-08 00:01:27.547131
8605	2026-03-01 18:00:00	1	2.38	220	640.4	t	2026-05-08 00:01:27.547131
8606	2026-03-01 18:00:00	4	1.48	220	370.3	t	2026-05-08 00:01:27.547131
8607	2026-03-01 18:00:00	7	1.08	220	538.4	t	2026-05-08 00:01:27.547131
8608	2026-03-01 18:30:00	1	2.79	220	360.5	t	2026-05-08 00:01:27.547131
8609	2026-03-01 18:30:00	4	1.79	220	574.5	t	2026-05-08 00:01:27.547131
8610	2026-03-01 18:30:00	7	1.46	220	360.6	t	2026-05-08 00:01:27.547131
8611	2026-03-01 19:00:00	1	2.5	220	512.4	t	2026-05-08 00:01:27.547131
8612	2026-03-01 19:00:00	4	1.67	220	634.2	t	2026-05-08 00:01:27.547131
8613	2026-03-01 19:00:00	7	2.09	220	374.1	t	2026-05-08 00:01:27.547131
8614	2026-03-01 19:30:00	1	1.7	220	501.6	t	2026-05-08 00:01:27.547131
8615	2026-03-01 19:30:00	4	1.02	220	547.2	t	2026-05-08 00:01:27.547131
8616	2026-03-01 19:30:00	7	1.61	220	360.5	t	2026-05-08 00:01:27.547131
8617	2026-03-01 20:00:00	1	2.85	220	254.5	t	2026-05-08 00:01:27.547131
8618	2026-03-01 20:00:00	4	1.54	220	420.6	t	2026-05-08 00:01:27.547131
8619	2026-03-01 20:00:00	7	1.39	220	518.4	t	2026-05-08 00:01:27.547131
8620	2026-03-01 20:30:00	1	2.47	220	659.2	t	2026-05-08 00:01:27.547131
8621	2026-03-01 20:30:00	4	1.54	220	310.9	t	2026-05-08 00:01:27.547131
8622	2026-03-01 20:30:00	7	1.33	220	573.3	t	2026-05-08 00:01:27.547131
8623	2026-03-01 21:00:00	1	2.14	220	653.4	t	2026-05-08 00:01:27.547131
8624	2026-03-01 21:00:00	4	1.77	220	260.2	t	2026-05-08 00:01:27.547131
8625	2026-03-01 21:00:00	7	2.77	220	496.7	t	2026-05-08 00:01:27.547131
8626	2026-03-01 21:30:00	1	2.29	220	453.8	t	2026-05-08 00:01:27.547131
8627	2026-03-01 21:30:00	4	1.74	220	412.2	t	2026-05-08 00:01:27.547131
8628	2026-03-01 21:30:00	7	2.73	220	239.1	t	2026-05-08 00:01:27.547131
8629	2026-03-01 22:00:00	1	1.32	220	449.7	t	2026-05-08 00:01:27.547131
8630	2026-03-01 22:00:00	4	1.41	220	623.1	t	2026-05-08 00:01:27.547131
8631	2026-03-01 22:00:00	7	2.41	220	569.7	t	2026-05-08 00:01:27.547131
8632	2026-03-01 22:30:00	1	2.68	220	268.1	t	2026-05-08 00:01:27.547131
8633	2026-03-01 22:30:00	4	1.81	220	403.9	t	2026-05-08 00:01:27.547131
8634	2026-03-01 22:30:00	7	1.63	220	291.5	t	2026-05-08 00:01:27.547131
8635	2026-03-01 23:00:00	1	1.04	220	350.7	t	2026-05-08 00:01:27.547131
8636	2026-03-01 23:00:00	4	1.63	220	598.9	t	2026-05-08 00:01:27.547131
8637	2026-03-01 23:00:00	7	1.78	220	532.5	t	2026-05-08 00:01:27.547131
8638	2026-03-01 23:30:00	1	2.05	220	459.6	t	2026-05-08 00:01:27.547131
8639	2026-03-01 23:30:00	4	1.37	220	420.1	t	2026-05-08 00:01:27.547131
8640	2026-03-01 23:30:00	7	2.26	220	606.3	t	2026-05-08 00:01:27.547131
8641	2026-03-02 00:00:00	1	2.14	220	569.1	t	2026-05-08 00:01:27.547131
8642	2026-03-02 00:00:00	4	2.48	220	338.8	t	2026-05-08 00:01:27.547131
8643	2026-03-02 00:00:00	7	1.89	220	286.7	t	2026-05-08 00:01:27.547131
8644	2026-03-02 00:30:00	1	1.25	220	518.3	t	2026-05-08 00:01:27.547131
8645	2026-03-02 00:30:00	4	3.15	220	324.6	t	2026-05-08 00:01:27.547131
8646	2026-03-02 00:30:00	7	3.52	220	365.2	t	2026-05-08 00:01:27.547131
8647	2026-03-02 01:00:00	1	2.27	220	289.8	t	2026-05-08 00:01:27.547131
8648	2026-03-02 01:00:00	4	1.22	220	681.8	t	2026-05-08 00:01:27.547131
8649	2026-03-02 01:00:00	7	3	220	588.8	t	2026-05-08 00:01:27.547131
8650	2026-03-02 01:30:00	1	2.73	220	807	t	2026-05-08 00:01:27.547131
8651	2026-03-02 01:30:00	4	2.86	220	665.5	t	2026-05-08 00:01:27.547131
8652	2026-03-02 01:30:00	7	3.3	220	355.8	t	2026-05-08 00:01:27.547131
8653	2026-03-02 02:00:00	1	1.48	220	714.3	t	2026-05-08 00:01:27.547131
8654	2026-03-02 02:00:00	4	1.79	220	443.5	t	2026-05-08 00:01:27.547131
8655	2026-03-02 02:00:00	7	2.81	220	646.4	t	2026-05-08 00:01:27.547131
8656	2026-03-02 02:30:00	1	2.29	220	327.8	t	2026-05-08 00:01:27.547131
8657	2026-03-02 02:30:00	4	1.83	220	399.4	t	2026-05-08 00:01:27.547131
8658	2026-03-02 02:30:00	7	3.66	220	367.9	t	2026-05-08 00:01:27.547131
8659	2026-03-02 03:00:00	1	2.97	220	416.3	t	2026-05-08 00:01:27.547131
8660	2026-03-02 03:00:00	4	2.27	220	419	t	2026-05-08 00:01:27.547131
8661	2026-03-02 03:00:00	7	2.56	220	454.1	t	2026-05-08 00:01:27.547131
8662	2026-03-02 03:30:00	1	1.54	220	386.8	t	2026-05-08 00:01:27.547131
8663	2026-03-02 03:30:00	4	1.5	220	794.9	t	2026-05-08 00:01:27.547131
8664	2026-03-02 03:30:00	7	3.59	220	811.1	t	2026-05-08 00:01:27.547131
8665	2026-03-02 04:00:00	1	3.05	220	809.6	t	2026-05-08 00:01:27.547131
8666	2026-03-02 04:00:00	4	3.35	220	267.9	t	2026-05-08 00:01:27.547131
8667	2026-03-02 04:00:00	7	1.97	220	782.3	t	2026-05-08 00:01:27.547131
8668	2026-03-02 04:30:00	1	1.43	220	493.6	t	2026-05-08 00:01:27.547131
8669	2026-03-02 04:30:00	4	3.62	220	594.9	t	2026-05-08 00:01:27.547131
8670	2026-03-02 04:30:00	7	1.69	220	490.9	t	2026-05-08 00:01:27.547131
8671	2026-03-02 05:00:00	1	2.11	220	490.1	t	2026-05-08 00:01:27.547131
8672	2026-03-02 05:00:00	4	3.58	220	388.6	t	2026-05-08 00:01:27.547131
8673	2026-03-02 05:00:00	7	3.3	220	409	t	2026-05-08 00:01:27.547131
8674	2026-03-02 05:30:00	1	1.6	220	540.9	t	2026-05-08 00:01:27.547131
8675	2026-03-02 05:30:00	4	2.16	220	563.1	t	2026-05-08 00:01:27.547131
8676	2026-03-02 05:30:00	7	1.74	220	371.3	t	2026-05-08 00:01:27.547131
8677	2026-03-02 06:00:00	1	3.17	220	377	t	2026-05-08 00:01:27.547131
8678	2026-03-02 06:00:00	4	2.87	220	502.5	t	2026-05-08 00:01:27.547131
8679	2026-03-02 06:00:00	7	2.33	220	583	t	2026-05-08 00:01:27.547131
8680	2026-03-02 06:30:00	1	3.14	220	762	t	2026-05-08 00:01:27.547131
8681	2026-03-02 06:30:00	4	1.51	220	462.3	t	2026-05-08 00:01:27.547131
8682	2026-03-02 06:30:00	7	2.45	220	328.6	t	2026-05-08 00:01:27.547131
8683	2026-03-02 07:00:00	1	19.57	220	4694.5	t	2026-05-08 00:01:27.547131
8684	2026-03-02 07:00:00	4	22.55	220	4631.7	t	2026-05-08 00:01:27.547131
8685	2026-03-02 07:00:00	7	26.84	220	6428.4	t	2026-05-08 00:01:27.547131
8686	2026-03-02 07:30:00	1	16.78	220	3638.9	t	2026-05-08 00:01:27.547131
8687	2026-03-02 07:30:00	4	16.66	220	4635.1	t	2026-05-08 00:01:27.547131
8688	2026-03-02 07:30:00	7	21.86	220	4663.3	t	2026-05-08 00:01:27.547131
8689	2026-03-02 08:00:00	1	18.99	220	3467.1	t	2026-05-08 00:01:27.547131
8690	2026-03-02 08:00:00	4	22.16	220	5071	t	2026-05-08 00:01:27.547131
8691	2026-03-02 08:00:00	7	28.72	220	6260.1	t	2026-05-08 00:01:27.547131
8692	2026-03-02 08:30:00	1	19.11	220	2687.7	t	2026-05-08 00:01:27.547131
8693	2026-03-02 08:30:00	4	19.26	220	5117.6	t	2026-05-08 00:01:27.547131
8694	2026-03-02 08:30:00	7	23.24	220	4734.2	t	2026-05-08 00:01:27.547131
8695	2026-03-02 09:00:00	1	17.84	220	3827.4	t	2026-05-08 00:01:27.547131
8696	2026-03-02 09:00:00	4	24.34	220	5142.3	t	2026-05-08 00:01:27.547131
8697	2026-03-02 09:00:00	7	28.35	220	5418	t	2026-05-08 00:01:27.547131
8698	2026-03-02 09:30:00	1	21.39	220	4431.1	t	2026-05-08 00:01:27.547131
8699	2026-03-02 09:30:00	4	22.59	220	4605	t	2026-05-08 00:01:27.547131
8700	2026-03-02 09:30:00	7	28.69	220	4648.4	t	2026-05-08 00:01:27.547131
8701	2026-03-02 10:00:00	1	12.55	220	3316.3	t	2026-05-08 00:01:27.547131
8702	2026-03-02 10:00:00	4	22.8	220	4589.2	t	2026-05-08 00:01:27.547131
8703	2026-03-02 10:00:00	7	26.43	220	6144.8	t	2026-05-08 00:01:27.547131
8704	2026-03-02 10:30:00	1	20.36	220	2811.4	t	2026-05-08 00:01:27.547131
8705	2026-03-02 10:30:00	4	16.66	220	4663.2	t	2026-05-08 00:01:27.547131
8706	2026-03-02 10:30:00	7	26.08	220	5403.9	t	2026-05-08 00:01:27.547131
8707	2026-03-02 11:00:00	1	20.17	220	4527.1	t	2026-05-08 00:01:27.547131
8708	2026-03-02 11:00:00	4	25.31	220	4689.9	t	2026-05-08 00:01:27.547131
8709	2026-03-02 11:00:00	7	27.55	220	5380.6	t	2026-05-08 00:01:27.547131
8710	2026-03-02 11:30:00	1	20.16	220	3855.5	t	2026-05-08 00:01:27.547131
8711	2026-03-02 11:30:00	4	16.23	220	4540.8	t	2026-05-08 00:01:27.547131
8712	2026-03-02 11:30:00	7	23.2	220	4899.8	t	2026-05-08 00:01:27.547131
8713	2026-03-02 12:00:00	1	18.31	220	2803.9	t	2026-05-08 00:01:27.547131
8714	2026-03-02 12:00:00	4	22.77	220	4240.2	t	2026-05-08 00:01:27.547131
8715	2026-03-02 12:00:00	7	26.82	220	4569	t	2026-05-08 00:01:27.547131
8716	2026-03-02 12:30:00	1	17.68	220	2585.5	t	2026-05-08 00:01:27.547131
8717	2026-03-02 12:30:00	4	25.18	220	4084.3	t	2026-05-08 00:01:27.547131
8718	2026-03-02 12:30:00	7	23.07	220	6004.6	t	2026-05-08 00:01:27.547131
8719	2026-03-02 13:00:00	1	21.1	220	3878.3	t	2026-05-08 00:01:27.547131
8720	2026-03-02 13:00:00	4	21.48	220	4616.6	t	2026-05-08 00:01:27.547131
8721	2026-03-02 13:00:00	7	21.21	220	4812.1	t	2026-05-08 00:01:27.547131
8722	2026-03-02 13:30:00	1	21.12	220	3582.9	t	2026-05-08 00:01:27.547131
8723	2026-03-02 13:30:00	4	20.26	220	5087.4	t	2026-05-08 00:01:27.547131
8724	2026-03-02 13:30:00	7	23.78	220	5943.3	t	2026-05-08 00:01:27.547131
8725	2026-03-02 14:00:00	1	18.99	220	4681.7	t	2026-05-08 00:01:27.547131
8726	2026-03-02 14:00:00	4	22.08	220	5026.9	t	2026-05-08 00:01:27.547131
8727	2026-03-02 14:00:00	7	23.99	220	5257.2	t	2026-05-08 00:01:27.547131
8728	2026-03-02 14:30:00	1	11.61	220	3335.4	t	2026-05-08 00:01:27.547131
8729	2026-03-02 14:30:00	4	22.93	220	5117.3	t	2026-05-08 00:01:27.547131
8730	2026-03-02 14:30:00	7	25.99	220	4708.7	t	2026-05-08 00:01:27.547131
8731	2026-03-02 15:00:00	1	12.18	220	4098	t	2026-05-08 00:01:27.547131
8732	2026-03-02 15:00:00	4	16.57	220	4098.5	t	2026-05-08 00:01:27.547131
8733	2026-03-02 15:00:00	7	30.42	220	4974.7	t	2026-05-08 00:01:27.547131
8734	2026-03-02 15:30:00	1	11.77	220	3344.1	t	2026-05-08 00:01:27.547131
8735	2026-03-02 15:30:00	4	24.09	220	3862.1	t	2026-05-08 00:01:27.547131
8736	2026-03-02 15:30:00	7	26.63	220	6434.7	t	2026-05-08 00:01:27.547131
8737	2026-03-02 16:00:00	1	17.99	220	4278.1	t	2026-05-08 00:01:27.547131
8738	2026-03-02 16:00:00	4	17.81	220	3730	t	2026-05-08 00:01:27.547131
8739	2026-03-02 16:00:00	7	23.22	220	6284.3	t	2026-05-08 00:01:27.547131
8740	2026-03-02 16:30:00	1	11.61	220	4618.5	t	2026-05-08 00:01:27.547131
8741	2026-03-02 16:30:00	4	23.09	220	5466.8	t	2026-05-08 00:01:27.547131
8742	2026-03-02 16:30:00	7	24.68	220	4870.7	t	2026-05-08 00:01:27.547131
8743	2026-03-02 17:00:00	1	19.05	220	3591.6	t	2026-05-08 00:01:27.547131
8744	2026-03-02 17:00:00	4	17.89	220	5002	t	2026-05-08 00:01:27.547131
8745	2026-03-02 17:00:00	7	28.13	220	6341	t	2026-05-08 00:01:27.547131
8746	2026-03-02 17:30:00	1	15.56	220	4553.2	t	2026-05-08 00:01:27.547131
8747	2026-03-02 17:30:00	4	25.75	220	5184.6	t	2026-05-08 00:01:27.547131
8748	2026-03-02 17:30:00	7	30.4	220	4553.4	t	2026-05-08 00:01:27.547131
8749	2026-03-02 18:00:00	1	17.52	220	3673.4	t	2026-05-08 00:01:27.547131
8750	2026-03-02 18:00:00	4	16.68	220	3613.6	t	2026-05-08 00:01:27.547131
8751	2026-03-02 18:00:00	7	26.94	220	5288.5	t	2026-05-08 00:01:27.547131
8752	2026-03-02 18:30:00	1	13.57	220	2943	t	2026-05-08 00:01:27.547131
8753	2026-03-02 18:30:00	4	24.2	220	5291.8	t	2026-05-08 00:01:27.547131
8754	2026-03-02 18:30:00	7	23.95	220	6183.2	t	2026-05-08 00:01:27.547131
8755	2026-03-02 19:00:00	1	19.61	220	3844.7	t	2026-05-08 00:01:27.547131
8756	2026-03-02 19:00:00	4	23.44	220	5326.3	t	2026-05-08 00:01:27.547131
8757	2026-03-02 19:00:00	7	26.26	220	6098.5	t	2026-05-08 00:01:27.547131
8758	2026-03-02 19:30:00	1	15.13	220	4351.8	t	2026-05-08 00:01:27.547131
8759	2026-03-02 19:30:00	4	23.26	220	4688.3	t	2026-05-08 00:01:27.547131
8760	2026-03-02 19:30:00	7	22.94	220	4740.3	t	2026-05-08 00:01:27.547131
8761	2026-03-02 20:00:00	1	1.56	220	517	t	2026-05-08 00:01:27.547131
8762	2026-03-02 20:00:00	4	3.32	220	601.2	t	2026-05-08 00:01:27.547131
8763	2026-03-02 20:00:00	7	3.43	220	709.6	t	2026-05-08 00:01:27.547131
8764	2026-03-02 20:30:00	1	3.45	220	612.1	t	2026-05-08 00:01:27.547131
8765	2026-03-02 20:30:00	4	3.28	220	773.3	t	2026-05-08 00:01:27.547131
8766	2026-03-02 20:30:00	7	2.18	220	446.9	t	2026-05-08 00:01:27.547131
8767	2026-03-02 21:00:00	1	2.81	220	264.5	t	2026-05-08 00:01:27.547131
8768	2026-03-02 21:00:00	4	2.74	220	267.3	t	2026-05-08 00:01:27.547131
8769	2026-03-02 21:00:00	7	3.39	220	645.8	t	2026-05-08 00:01:27.547131
8770	2026-03-02 21:30:00	1	2.57	220	599.5	t	2026-05-08 00:01:27.547131
8771	2026-03-02 21:30:00	4	1.99	220	637.3	t	2026-05-08 00:01:27.547131
8772	2026-03-02 21:30:00	7	2.54	220	799.3	t	2026-05-08 00:01:27.547131
8773	2026-03-02 22:00:00	1	1.74	220	580.6	t	2026-05-08 00:01:27.547131
8774	2026-03-02 22:00:00	4	3.39	220	786.8	t	2026-05-08 00:01:27.547131
8775	2026-03-02 22:00:00	7	1.29	220	803.3	t	2026-05-08 00:01:27.547131
8776	2026-03-02 22:30:00	1	3.67	220	608.7	t	2026-05-08 00:01:27.547131
8777	2026-03-02 22:30:00	4	3.02	220	436	t	2026-05-08 00:01:27.547131
8778	2026-03-02 22:30:00	7	2.84	220	678.6	t	2026-05-08 00:01:27.547131
8779	2026-03-02 23:00:00	1	3.62	220	312.1	t	2026-05-08 00:01:27.547131
8780	2026-03-02 23:00:00	4	2.15	220	363.7	t	2026-05-08 00:01:27.547131
8781	2026-03-02 23:00:00	7	3.67	220	355	t	2026-05-08 00:01:27.547131
8782	2026-03-02 23:30:00	1	1.57	220	395.7	t	2026-05-08 00:01:27.547131
8783	2026-03-02 23:30:00	4	2.12	220	445.8	t	2026-05-08 00:01:27.547131
8784	2026-03-02 23:30:00	7	2.64	220	679.1	t	2026-05-08 00:01:27.547131
8785	2026-03-03 00:00:00	1	1.97	220	382.6	t	2026-05-08 00:01:27.547131
8786	2026-03-03 00:00:00	4	2.99	220	309	t	2026-05-08 00:01:27.547131
8787	2026-03-03 00:00:00	7	2.97	220	627.3	t	2026-05-08 00:01:27.547131
8788	2026-03-03 00:30:00	1	1.47	220	533.8	t	2026-05-08 00:01:27.547131
8789	2026-03-03 00:30:00	4	2.31	220	804.8	t	2026-05-08 00:01:27.547131
8790	2026-03-03 00:30:00	7	3.7	220	511.3	t	2026-05-08 00:01:27.547131
8791	2026-03-03 01:00:00	1	2.96	220	548.8	t	2026-05-08 00:01:27.547131
8792	2026-03-03 01:00:00	4	3.25	220	675	t	2026-05-08 00:01:27.547131
8793	2026-03-03 01:00:00	7	3.47	220	337.9	t	2026-05-08 00:01:27.547131
8794	2026-03-03 01:30:00	1	3.14	220	492.5	t	2026-05-08 00:01:27.547131
8795	2026-03-03 01:30:00	4	2.21	220	727.3	t	2026-05-08 00:01:27.547131
8796	2026-03-03 01:30:00	7	2.7	220	346.5	t	2026-05-08 00:01:27.547131
8797	2026-03-03 02:00:00	1	3.23	220	633.1	t	2026-05-08 00:01:27.547131
8798	2026-03-03 02:00:00	4	2.76	220	526.1	t	2026-05-08 00:01:27.547131
8799	2026-03-03 02:00:00	7	2.38	220	356.2	t	2026-05-08 00:01:27.547131
8800	2026-03-03 02:30:00	1	2.19	220	402.8	t	2026-05-08 00:01:27.547131
8801	2026-03-03 02:30:00	4	2.37	220	728.6	t	2026-05-08 00:01:27.547131
8802	2026-03-03 02:30:00	7	2.7	220	285	t	2026-05-08 00:01:27.547131
8803	2026-03-03 03:00:00	1	2.54	220	502.3	t	2026-05-08 00:01:27.547131
8804	2026-03-03 03:00:00	4	1.46	220	545.1	t	2026-05-08 00:01:27.547131
8805	2026-03-03 03:00:00	7	1.24	220	264.3	t	2026-05-08 00:01:27.547131
8806	2026-03-03 03:30:00	1	3.33	220	363.8	t	2026-05-08 00:01:27.547131
8807	2026-03-03 03:30:00	4	2.34	220	354.7	t	2026-05-08 00:01:27.547131
8808	2026-03-03 03:30:00	7	2.53	220	781.7	t	2026-05-08 00:01:27.547131
8809	2026-03-03 04:00:00	1	2.41	220	604.8	t	2026-05-08 00:01:27.547131
8810	2026-03-03 04:00:00	4	3.53	220	642.3	t	2026-05-08 00:01:27.547131
8811	2026-03-03 04:00:00	7	2.39	220	723.5	t	2026-05-08 00:01:27.547131
8812	2026-03-03 04:30:00	1	1.34	220	729.1	t	2026-05-08 00:01:27.547131
8813	2026-03-03 04:30:00	4	3.2	220	676.7	t	2026-05-08 00:01:27.547131
8814	2026-03-03 04:30:00	7	2.63	220	774.3	t	2026-05-08 00:01:27.547131
8815	2026-03-03 05:00:00	1	2.41	220	690.1	t	2026-05-08 00:01:27.547131
8816	2026-03-03 05:00:00	4	2.96	220	797	t	2026-05-08 00:01:27.547131
8817	2026-03-03 05:00:00	7	3.68	220	692.2	t	2026-05-08 00:01:27.547131
8818	2026-03-03 05:30:00	1	3.47	220	520.3	t	2026-05-08 00:01:27.547131
8819	2026-03-03 05:30:00	4	2.08	220	481.9	t	2026-05-08 00:01:27.547131
8820	2026-03-03 05:30:00	7	1.67	220	469.3	t	2026-05-08 00:01:27.547131
8821	2026-03-03 06:00:00	1	2.05	220	350.1	t	2026-05-08 00:01:27.547131
8822	2026-03-03 06:00:00	4	2.91	220	606	t	2026-05-08 00:01:27.547131
8823	2026-03-03 06:00:00	7	1.6	220	735.1	t	2026-05-08 00:01:27.547131
8824	2026-03-03 06:30:00	1	2.76	220	321.3	t	2026-05-08 00:01:27.547131
8825	2026-03-03 06:30:00	4	2.97	220	390.5	t	2026-05-08 00:01:27.547131
8826	2026-03-03 06:30:00	7	2.72	220	609.1	t	2026-05-08 00:01:27.547131
8827	2026-03-03 07:00:00	1	17.09	220	3312.9	t	2026-05-08 00:01:27.547131
8828	2026-03-03 07:00:00	4	20.13	220	5173.4	t	2026-05-08 00:01:27.547131
8829	2026-03-03 07:00:00	7	29.15	220	5499.3	t	2026-05-08 00:01:27.547131
8830	2026-03-03 07:30:00	1	12.22	220	4008.8	t	2026-05-08 00:01:27.547131
8831	2026-03-03 07:30:00	4	23.87	220	4086.8	t	2026-05-08 00:01:27.547131
8832	2026-03-03 07:30:00	7	26.69	220	5477.2	t	2026-05-08 00:01:27.547131
8833	2026-03-03 08:00:00	1	19.14	220	3591.7	t	2026-05-08 00:01:27.547131
8834	2026-03-03 08:00:00	4	20.78	220	5273.8	t	2026-05-08 00:01:27.547131
8835	2026-03-03 08:00:00	7	29.27	220	5117.7	t	2026-05-08 00:01:27.547131
8836	2026-03-03 08:30:00	1	20.56	220	4039.2	t	2026-05-08 00:01:27.547131
8837	2026-03-03 08:30:00	4	23.18	220	4487.1	t	2026-05-08 00:01:27.547131
8838	2026-03-03 08:30:00	7	23.19	220	5930.6	t	2026-05-08 00:01:27.547131
8839	2026-03-03 09:00:00	1	12.63	220	3321.2	t	2026-05-08 00:01:27.547131
8840	2026-03-03 09:00:00	4	17.7	220	5281.5	t	2026-05-08 00:01:27.547131
8841	2026-03-03 09:00:00	7	26.6	220	5242	t	2026-05-08 00:01:27.547131
8842	2026-03-03 09:30:00	1	12.96	220	3602.8	t	2026-05-08 00:01:27.547131
8843	2026-03-03 09:30:00	4	21.62	220	5001.1	t	2026-05-08 00:01:27.547131
8844	2026-03-03 09:30:00	7	30.35	220	6197.3	t	2026-05-08 00:01:27.547131
8845	2026-03-03 10:00:00	1	16.15	220	4069.3	t	2026-05-08 00:01:27.547131
8846	2026-03-03 10:00:00	4	19	220	5234	t	2026-05-08 00:01:27.547131
8847	2026-03-03 10:00:00	7	28.13	220	6169.6	t	2026-05-08 00:01:27.547131
8848	2026-03-03 10:30:00	1	12.69	220	3885.8	t	2026-05-08 00:01:27.547131
8849	2026-03-03 10:30:00	4	21.32	220	3541	t	2026-05-08 00:01:27.547131
8850	2026-03-03 10:30:00	7	24.39	220	4573.9	t	2026-05-08 00:01:27.547131
8851	2026-03-03 11:00:00	1	19.36	220	3099.6	t	2026-05-08 00:01:27.547131
8852	2026-03-03 11:00:00	4	25.16	220	5546.4	t	2026-05-08 00:01:27.547131
8853	2026-03-03 11:00:00	7	20.72	220	5849.6	t	2026-05-08 00:01:27.547131
8854	2026-03-03 11:30:00	1	15.13	220	4425.2	t	2026-05-08 00:01:27.547131
8855	2026-03-03 11:30:00	4	22.33	220	4507.5	t	2026-05-08 00:01:27.547131
8856	2026-03-03 11:30:00	7	23.23	220	5331.5	t	2026-05-08 00:01:27.547131
8857	2026-03-03 12:00:00	1	16.13	220	3803.8	t	2026-05-08 00:01:27.547131
8858	2026-03-03 12:00:00	4	24.8	220	4590.7	t	2026-05-08 00:01:27.547131
8859	2026-03-03 12:00:00	7	30.14	220	5205.2	t	2026-05-08 00:01:27.547131
8860	2026-03-03 12:30:00	1	19.85	220	3558.8	t	2026-05-08 00:01:27.547131
8861	2026-03-03 12:30:00	4	23.84	220	5016.9	t	2026-05-08 00:01:27.547131
8862	2026-03-03 12:30:00	7	30.32	220	6497.7	t	2026-05-08 00:01:27.547131
8863	2026-03-03 13:00:00	1	14.37	220	3181.3	t	2026-05-08 00:01:27.547131
8864	2026-03-03 13:00:00	4	23.57	220	4971.6	t	2026-05-08 00:01:27.547131
8865	2026-03-03 13:00:00	7	24.54	220	5767.4	t	2026-05-08 00:01:27.547131
8866	2026-03-03 13:30:00	1	13.58	220	3077.3	t	2026-05-08 00:01:27.547131
8867	2026-03-03 13:30:00	4	18.66	220	4267.5	t	2026-05-08 00:01:27.547131
8868	2026-03-03 13:30:00	7	25.45	220	5375.5	t	2026-05-08 00:01:27.547131
8869	2026-03-03 14:00:00	1	14.61	220	3885	t	2026-05-08 00:01:27.547131
8870	2026-03-03 14:00:00	4	18.54	220	4646	t	2026-05-08 00:01:27.547131
8871	2026-03-03 14:00:00	7	30.39	220	5973.8	t	2026-05-08 00:01:27.547131
8872	2026-03-03 14:30:00	1	13.65	220	2537.6	t	2026-05-08 00:01:27.547131
8873	2026-03-03 14:30:00	4	16.96	220	5701.3	t	2026-05-08 00:01:27.547131
8874	2026-03-03 14:30:00	7	28.68	220	4689.7	t	2026-05-08 00:01:27.547131
8875	2026-03-03 15:00:00	1	13.43	220	2797.5	t	2026-05-08 00:01:27.547131
8876	2026-03-03 15:00:00	4	21.32	220	4283.9	t	2026-05-08 00:01:27.547131
8877	2026-03-03 15:00:00	7	30.47	220	4632.8	t	2026-05-08 00:01:27.547131
8878	2026-03-03 15:30:00	1	14.94	220	4360.6	t	2026-05-08 00:01:27.547131
8879	2026-03-03 15:30:00	4	20.12	220	3944.2	t	2026-05-08 00:01:27.547131
8880	2026-03-03 15:30:00	7	25.75	220	5916.5	t	2026-05-08 00:01:27.547131
8881	2026-03-03 16:00:00	1	19.04	220	3358.9	t	2026-05-08 00:01:27.547131
8882	2026-03-03 16:00:00	4	16.03	220	4459.2	t	2026-05-08 00:01:27.547131
8883	2026-03-03 16:00:00	7	23.71	220	5018.6	t	2026-05-08 00:01:27.547131
8884	2026-03-03 16:30:00	1	15.81	220	3166.8	t	2026-05-08 00:01:27.547131
8885	2026-03-03 16:30:00	4	23.79	220	3612.2	t	2026-05-08 00:01:27.547131
8886	2026-03-03 16:30:00	7	26.7	220	6475.6	t	2026-05-08 00:01:27.547131
8887	2026-03-03 17:00:00	1	16.17	220	3137.1	t	2026-05-08 00:01:27.547131
8888	2026-03-03 17:00:00	4	18.06	220	5621.8	t	2026-05-08 00:01:27.547131
8889	2026-03-03 17:00:00	7	23.16	220	5579.9	t	2026-05-08 00:01:27.547131
8890	2026-03-03 17:30:00	1	16.67	220	3898.6	t	2026-05-08 00:01:27.547131
8891	2026-03-03 17:30:00	4	18.29	220	4427.4	t	2026-05-08 00:01:27.547131
8892	2026-03-03 17:30:00	7	25.2	220	6237.5	t	2026-05-08 00:01:27.547131
8893	2026-03-03 18:00:00	1	13.76	220	3930.3	t	2026-05-08 00:01:27.547131
8894	2026-03-03 18:00:00	4	17.26	220	4769.4	t	2026-05-08 00:01:27.547131
8895	2026-03-03 18:00:00	7	27.99	220	6498	t	2026-05-08 00:01:27.547131
8896	2026-03-03 18:30:00	1	18.7	220	3033.8	t	2026-05-08 00:01:27.547131
8897	2026-03-03 18:30:00	4	22.7	220	4957.8	t	2026-05-08 00:01:27.547131
8898	2026-03-03 18:30:00	7	23.28	220	4673.1	t	2026-05-08 00:01:27.547131
8899	2026-03-03 19:00:00	1	11.62	220	3172.6	t	2026-05-08 00:01:27.547131
8900	2026-03-03 19:00:00	4	17.16	220	5331.5	t	2026-05-08 00:01:27.547131
8901	2026-03-03 19:00:00	7	30.1	220	6662.3	t	2026-05-08 00:01:27.547131
8902	2026-03-03 19:30:00	1	21.38	220	4514	t	2026-05-08 00:01:27.547131
8903	2026-03-03 19:30:00	4	25.37	220	4798.9	t	2026-05-08 00:01:27.547131
8904	2026-03-03 19:30:00	7	22.25	220	6553	t	2026-05-08 00:01:27.547131
8905	2026-03-03 20:00:00	1	2.83	220	558.2	t	2026-05-08 00:01:27.547131
8906	2026-03-03 20:00:00	4	3.14	220	723.7	t	2026-05-08 00:01:27.547131
8907	2026-03-03 20:00:00	7	2.84	220	578.5	t	2026-05-08 00:01:27.547131
8908	2026-03-03 20:30:00	1	2.21	220	652.5	t	2026-05-08 00:01:27.547131
8909	2026-03-03 20:30:00	4	3.28	220	778.2	t	2026-05-08 00:01:27.547131
8910	2026-03-03 20:30:00	7	2.76	220	703.8	t	2026-05-08 00:01:27.547131
8911	2026-03-03 21:00:00	1	2.76	220	374.5	t	2026-05-08 00:01:27.547131
8912	2026-03-03 21:00:00	4	3.19	220	548.9	t	2026-05-08 00:01:27.547131
8913	2026-03-03 21:00:00	7	2.36	220	382.6	t	2026-05-08 00:01:27.547131
8914	2026-03-03 21:30:00	1	1.22	220	472.9	t	2026-05-08 00:01:27.547131
8915	2026-03-03 21:30:00	4	2.48	220	664.5	t	2026-05-08 00:01:27.547131
8916	2026-03-03 21:30:00	7	1.54	220	505.8	t	2026-05-08 00:01:27.547131
8917	2026-03-03 22:00:00	1	3.21	220	588.3	t	2026-05-08 00:01:27.547131
8918	2026-03-03 22:00:00	4	1.99	220	460.2	t	2026-05-08 00:01:27.547131
8919	2026-03-03 22:00:00	7	2.44	220	409.9	t	2026-05-08 00:01:27.547131
8920	2026-03-03 22:30:00	1	1.35	220	388.5	t	2026-05-08 00:01:27.547131
8921	2026-03-03 22:30:00	4	3.52	220	318.4	t	2026-05-08 00:01:27.547131
8922	2026-03-03 22:30:00	7	3.23	220	535.7	t	2026-05-08 00:01:27.547131
8923	2026-03-03 23:00:00	1	3.16	220	277.9	t	2026-05-08 00:01:27.547131
8924	2026-03-03 23:00:00	4	2.63	220	610.2	t	2026-05-08 00:01:27.547131
8925	2026-03-03 23:00:00	7	3.27	220	399.6	t	2026-05-08 00:01:27.547131
8926	2026-03-03 23:30:00	1	1.24	220	565.6	t	2026-05-08 00:01:27.547131
8927	2026-03-03 23:30:00	4	3.61	220	312.4	t	2026-05-08 00:01:27.547131
8928	2026-03-03 23:30:00	7	1.91	220	406.3	t	2026-05-08 00:01:27.547131
8929	2026-03-04 00:00:00	1	3.62	220	434.1	t	2026-05-08 00:01:27.547131
8930	2026-03-04 00:00:00	4	2.85	220	786.3	t	2026-05-08 00:01:27.547131
8931	2026-03-04 00:00:00	7	2.01	220	783.9	t	2026-05-08 00:01:27.547131
8932	2026-03-04 00:30:00	1	1.49	220	789.8	t	2026-05-08 00:01:27.547131
8933	2026-03-04 00:30:00	4	3.22	220	671.2	t	2026-05-08 00:01:27.547131
8934	2026-03-04 00:30:00	7	3.14	220	559.6	t	2026-05-08 00:01:27.547131
8935	2026-03-04 01:00:00	1	2.33	220	563.1	t	2026-05-08 00:01:27.547131
8936	2026-03-04 01:00:00	4	2.25	220	703.1	t	2026-05-08 00:01:27.547131
8937	2026-03-04 01:00:00	7	1.24	220	448	t	2026-05-08 00:01:27.547131
8938	2026-03-04 01:30:00	1	2.76	220	504.2	t	2026-05-08 00:01:27.547131
8939	2026-03-04 01:30:00	4	2.17	220	775.5	t	2026-05-08 00:01:27.547131
8940	2026-03-04 01:30:00	7	2.55	220	341.5	t	2026-05-08 00:01:27.547131
8941	2026-03-04 02:00:00	1	2.78	220	399.5	t	2026-05-08 00:01:27.547131
8942	2026-03-04 02:00:00	4	3.54	220	731.1	t	2026-05-08 00:01:27.547131
8943	2026-03-04 02:00:00	7	1.58	220	755.9	t	2026-05-08 00:01:27.547131
8944	2026-03-04 02:30:00	1	2.95	220	592.7	t	2026-05-08 00:01:27.547131
8945	2026-03-04 02:30:00	4	2.75	220	632.6	t	2026-05-08 00:01:27.547131
8946	2026-03-04 02:30:00	7	3.11	220	275.2	t	2026-05-08 00:01:27.547131
8947	2026-03-04 03:00:00	1	1.33	220	389.3	t	2026-05-08 00:01:27.547131
8948	2026-03-04 03:00:00	4	3.42	220	712.5	t	2026-05-08 00:01:27.547131
8949	2026-03-04 03:00:00	7	3.33	220	519	t	2026-05-08 00:01:27.547131
8950	2026-03-04 03:30:00	1	2.47	220	558.9	t	2026-05-08 00:01:27.547131
8951	2026-03-04 03:30:00	4	1.43	220	644.1	t	2026-05-08 00:01:27.547131
8952	2026-03-04 03:30:00	7	2.72	220	347.1	t	2026-05-08 00:01:27.547131
8953	2026-03-04 04:00:00	1	3.66	220	417.3	t	2026-05-08 00:01:27.547131
8954	2026-03-04 04:00:00	4	3.15	220	628.3	t	2026-05-08 00:01:27.547131
8955	2026-03-04 04:00:00	7	2.86	220	612	t	2026-05-08 00:01:27.547131
8956	2026-03-04 04:30:00	1	1.99	220	632.4	t	2026-05-08 00:01:27.547131
8957	2026-03-04 04:30:00	4	1.23	220	507.2	t	2026-05-08 00:01:27.547131
8958	2026-03-04 04:30:00	7	3.62	220	575.4	t	2026-05-08 00:01:27.547131
8959	2026-03-04 05:00:00	1	3.44	220	589.9	t	2026-05-08 00:01:27.547131
8960	2026-03-04 05:00:00	4	2.66	220	602.1	t	2026-05-08 00:01:27.547131
8961	2026-03-04 05:00:00	7	2.25	220	377.7	t	2026-05-08 00:01:27.547131
8962	2026-03-04 05:30:00	1	1.81	220	397.4	t	2026-05-08 00:01:27.547131
8963	2026-03-04 05:30:00	4	3.29	220	683.5	t	2026-05-08 00:01:27.547131
8964	2026-03-04 05:30:00	7	2.54	220	490.3	t	2026-05-08 00:01:27.547131
8965	2026-03-04 06:00:00	1	2.82	220	692.2	t	2026-05-08 00:01:27.547131
8966	2026-03-04 06:00:00	4	2.72	220	308.3	t	2026-05-08 00:01:27.547131
8967	2026-03-04 06:00:00	7	1.35	220	633.4	t	2026-05-08 00:01:27.547131
8968	2026-03-04 06:30:00	1	2.67	220	732.2	t	2026-05-08 00:01:27.547131
8969	2026-03-04 06:30:00	4	3.63	220	350.9	t	2026-05-08 00:01:27.547131
8970	2026-03-04 06:30:00	7	1.99	220	586.6	t	2026-05-08 00:01:27.547131
8971	2026-03-04 07:00:00	1	12.99	220	3230.5	t	2026-05-08 00:01:27.547131
8972	2026-03-04 07:00:00	4	24.51	220	5310.3	t	2026-05-08 00:01:27.547131
8973	2026-03-04 07:00:00	7	29.3	220	6174.6	t	2026-05-08 00:01:27.547131
8974	2026-03-04 07:30:00	1	12.04	220	3169.5	t	2026-05-08 00:01:27.547131
8975	2026-03-04 07:30:00	4	21.27	220	4993.4	t	2026-05-08 00:01:27.547131
8976	2026-03-04 07:30:00	7	28.91	220	5289.9	t	2026-05-08 00:01:27.547131
8977	2026-03-04 08:00:00	1	16.29	220	3049.8	t	2026-05-08 00:01:27.547131
8978	2026-03-04 08:00:00	4	25.23	220	5021.9	t	2026-05-08 00:01:27.547131
8979	2026-03-04 08:00:00	7	28.67	220	4738.6	t	2026-05-08 00:01:27.547131
8980	2026-03-04 08:30:00	1	15.75	220	2735.4	t	2026-05-08 00:01:27.547131
8981	2026-03-04 08:30:00	4	23.1	220	5563.8	t	2026-05-08 00:01:27.547131
8982	2026-03-04 08:30:00	7	24.84	220	6058	t	2026-05-08 00:01:27.547131
8983	2026-03-04 09:00:00	1	13.37	220	3927.3	t	2026-05-08 00:01:27.547131
8984	2026-03-04 09:00:00	4	24.32	220	4284.5	t	2026-05-08 00:01:27.547131
8985	2026-03-04 09:00:00	7	21.73	220	5829.6	t	2026-05-08 00:01:27.547131
8986	2026-03-04 09:30:00	1	18.2	220	3825.9	t	2026-05-08 00:01:27.547131
8987	2026-03-04 09:30:00	4	25.78	220	5190.5	t	2026-05-08 00:01:27.547131
8988	2026-03-04 09:30:00	7	22.19	220	4919.3	t	2026-05-08 00:01:27.547131
8989	2026-03-04 10:00:00	1	20.7	220	3649.3	t	2026-05-08 00:01:27.547131
8990	2026-03-04 10:00:00	4	16.44	220	4772.6	t	2026-05-08 00:01:27.547131
8991	2026-03-04 10:00:00	7	26.32	220	5926.6	t	2026-05-08 00:01:27.547131
8992	2026-03-04 10:30:00	1	11.86	220	3178.7	t	2026-05-08 00:01:27.547131
8993	2026-03-04 10:30:00	4	20.8	220	5060.4	t	2026-05-08 00:01:27.547131
8994	2026-03-04 10:30:00	7	21.97	220	5938.3	t	2026-05-08 00:01:27.547131
8995	2026-03-04 11:00:00	1	17.12	220	3969.5	t	2026-05-08 00:01:27.547131
8996	2026-03-04 11:00:00	4	23.98	220	5481.3	t	2026-05-08 00:01:27.547131
8997	2026-03-04 11:00:00	7	27.62	220	6370.5	t	2026-05-08 00:01:27.547131
8998	2026-03-04 11:30:00	1	14.27	220	4228.7	t	2026-05-08 00:01:27.547131
8999	2026-03-04 11:30:00	4	25.11	220	4891.9	t	2026-05-08 00:01:27.547131
9000	2026-03-04 11:30:00	7	22.66	220	5443.1	t	2026-05-08 00:01:27.547131
9001	2026-03-04 12:00:00	1	16.46	220	3147.2	t	2026-05-08 00:01:27.547131
9002	2026-03-04 12:00:00	4	18.86	220	3612.3	t	2026-05-08 00:01:27.547131
9003	2026-03-04 12:00:00	7	27.99	220	6041.4	t	2026-05-08 00:01:27.547131
9004	2026-03-04 12:30:00	1	12.03	220	3790.3	t	2026-05-08 00:01:27.547131
9005	2026-03-04 12:30:00	4	21.56	220	5053.7	t	2026-05-08 00:01:27.547131
9006	2026-03-04 12:30:00	7	26.41	220	4843.3	t	2026-05-08 00:01:27.547131
9007	2026-03-04 13:00:00	1	18.7	220	3620.6	t	2026-05-08 00:01:27.547131
9008	2026-03-04 13:00:00	4	22.4	220	5244.6	t	2026-05-08 00:01:27.547131
9009	2026-03-04 13:00:00	7	25.68	220	5770.5	t	2026-05-08 00:01:27.547131
9010	2026-03-04 13:30:00	1	15.76	220	3648.7	t	2026-05-08 00:01:27.547131
9011	2026-03-04 13:30:00	4	16.26	220	4257.7	t	2026-05-08 00:01:27.547131
9012	2026-03-04 13:30:00	7	20.65	220	6380.3	t	2026-05-08 00:01:27.547131
9013	2026-03-04 14:00:00	1	19.16	220	3205.6	t	2026-05-08 00:01:27.547131
9014	2026-03-04 14:00:00	4	21.23	220	4887.1	t	2026-05-08 00:01:27.547131
9015	2026-03-04 14:00:00	7	22.64	220	6420.8	t	2026-05-08 00:01:27.547131
9016	2026-03-04 14:30:00	1	18.3	220	4399.8	t	2026-05-08 00:01:27.547131
9017	2026-03-04 14:30:00	4	23.4	220	4410.2	t	2026-05-08 00:01:27.547131
9018	2026-03-04 14:30:00	7	25.48	220	5550.9	t	2026-05-08 00:01:27.547131
9019	2026-03-04 15:00:00	1	16.07	220	3651.2	t	2026-05-08 00:01:27.547131
9020	2026-03-04 15:00:00	4	20.13	220	4164.2	t	2026-05-08 00:01:27.547131
9021	2026-03-04 15:00:00	7	24.14	220	5434	t	2026-05-08 00:01:27.547131
9022	2026-03-04 15:30:00	1	14.62	220	3773.4	t	2026-05-08 00:01:27.547131
9023	2026-03-04 15:30:00	4	22.44	220	3753.9	t	2026-05-08 00:01:27.547131
9024	2026-03-04 15:30:00	7	27.91	220	4541.8	t	2026-05-08 00:01:27.547131
9025	2026-03-04 16:00:00	1	13.88	220	2605.2	t	2026-05-08 00:01:27.547131
9026	2026-03-04 16:00:00	4	18.09	220	4797.4	t	2026-05-08 00:01:27.547131
9027	2026-03-04 16:00:00	7	28.18	220	6553.8	t	2026-05-08 00:01:27.547131
9028	2026-03-04 16:30:00	1	18.28	220	3649.6	t	2026-05-08 00:01:27.547131
9029	2026-03-04 16:30:00	4	21.48	220	4582.8	t	2026-05-08 00:01:27.547131
9030	2026-03-04 16:30:00	7	23.67	220	6200.4	t	2026-05-08 00:01:27.547131
9031	2026-03-04 17:00:00	1	20.99	220	4089.4	t	2026-05-08 00:01:27.547131
9032	2026-03-04 17:00:00	4	23.95	220	3689.3	t	2026-05-08 00:01:27.547131
9033	2026-03-04 17:00:00	7	29.99	220	5510.3	t	2026-05-08 00:01:27.547131
9034	2026-03-04 17:30:00	1	15.01	220	4501	t	2026-05-08 00:01:27.547131
9035	2026-03-04 17:30:00	4	17.2	220	3947.2	t	2026-05-08 00:01:27.547131
9036	2026-03-04 17:30:00	7	29.76	220	5215.2	t	2026-05-08 00:01:27.547131
9037	2026-03-04 18:00:00	1	17.85	220	3731.1	t	2026-05-08 00:01:27.547131
9038	2026-03-04 18:00:00	4	19.3	220	4928.5	t	2026-05-08 00:01:27.547131
9039	2026-03-04 18:00:00	7	28.26	220	6468.4	t	2026-05-08 00:01:27.547131
9040	2026-03-04 18:30:00	1	15.24	220	2624.8	t	2026-05-08 00:01:27.547131
9041	2026-03-04 18:30:00	4	18.95	220	4041.4	t	2026-05-08 00:01:27.547131
9042	2026-03-04 18:30:00	7	23.27	220	4693.9	t	2026-05-08 00:01:27.547131
9043	2026-03-04 19:00:00	1	21.11	220	3190.5	t	2026-05-08 00:01:27.547131
9044	2026-03-04 19:00:00	4	18.64	220	4647.3	t	2026-05-08 00:01:27.547131
9045	2026-03-04 19:00:00	7	28.11	220	4543.5	t	2026-05-08 00:01:27.547131
9046	2026-03-04 19:30:00	1	18.27	220	3171.2	t	2026-05-08 00:01:27.547131
9047	2026-03-04 19:30:00	4	22.78	220	3883.5	t	2026-05-08 00:01:27.547131
9048	2026-03-04 19:30:00	7	26.97	220	6486.2	t	2026-05-08 00:01:27.547131
9049	2026-03-04 20:00:00	1	2.15	220	492.5	t	2026-05-08 00:01:27.547131
9050	2026-03-04 20:00:00	4	2.19	220	505.4	t	2026-05-08 00:01:27.547131
9051	2026-03-04 20:00:00	7	1.7	220	320.4	t	2026-05-08 00:01:27.547131
9052	2026-03-04 20:30:00	1	3.13	220	285.5	t	2026-05-08 00:01:27.547131
9053	2026-03-04 20:30:00	4	3.15	220	769.4	t	2026-05-08 00:01:27.547131
9054	2026-03-04 20:30:00	7	2.22	220	574.9	t	2026-05-08 00:01:27.547131
9055	2026-03-04 21:00:00	1	2.85	220	265.5	t	2026-05-08 00:01:27.547131
9056	2026-03-04 21:00:00	4	3.69	220	813.9	t	2026-05-08 00:01:27.547131
9057	2026-03-04 21:00:00	7	3.14	220	767.9	t	2026-05-08 00:01:27.547131
9058	2026-03-04 21:30:00	1	3.13	220	549.7	t	2026-05-08 00:01:27.547131
9059	2026-03-04 21:30:00	4	1.98	220	629.3	t	2026-05-08 00:01:27.547131
9060	2026-03-04 21:30:00	7	2	220	783.3	t	2026-05-08 00:01:27.547131
9061	2026-03-04 22:00:00	1	1.55	220	627	t	2026-05-08 00:01:27.547131
9062	2026-03-04 22:00:00	4	2.71	220	625.6	t	2026-05-08 00:01:27.547131
9063	2026-03-04 22:00:00	7	2.35	220	577.7	t	2026-05-08 00:01:27.547131
9064	2026-03-04 22:30:00	1	2.07	220	808.8	t	2026-05-08 00:01:27.547131
9065	2026-03-04 22:30:00	4	3.65	220	709.4	t	2026-05-08 00:01:27.547131
9066	2026-03-04 22:30:00	7	1.66	220	484.9	t	2026-05-08 00:01:27.547131
9067	2026-03-04 23:00:00	1	1.21	220	554.3	t	2026-05-08 00:01:27.547131
9068	2026-03-04 23:00:00	4	3.14	220	507.7	t	2026-05-08 00:01:27.547131
9069	2026-03-04 23:00:00	7	1.27	220	461.5	t	2026-05-08 00:01:27.547131
9070	2026-03-04 23:30:00	1	2.39	220	495.1	t	2026-05-08 00:01:27.547131
9071	2026-03-04 23:30:00	4	3.54	220	544.1	t	2026-05-08 00:01:27.547131
9072	2026-03-04 23:30:00	7	1.91	220	749.7	t	2026-05-08 00:01:27.547131
9073	2026-03-05 00:00:00	1	3.1	220	489.9	t	2026-05-08 00:01:27.547131
9074	2026-03-05 00:00:00	4	1.28	220	545.1	t	2026-05-08 00:01:27.547131
9075	2026-03-05 00:00:00	7	1.4	220	729.8	t	2026-05-08 00:01:27.547131
9076	2026-03-05 00:30:00	1	2.34	220	425.2	t	2026-05-08 00:01:27.547131
9077	2026-03-05 00:30:00	4	3.05	220	351.3	t	2026-05-08 00:01:27.547131
9078	2026-03-05 00:30:00	7	1.8	220	372.5	t	2026-05-08 00:01:27.547131
9079	2026-03-05 01:00:00	1	3.59	220	378.8	t	2026-05-08 00:01:27.547131
9080	2026-03-05 01:00:00	4	2.63	220	344.1	t	2026-05-08 00:01:27.547131
9081	2026-03-05 01:00:00	7	1.33	220	680.7	t	2026-05-08 00:01:27.547131
9082	2026-03-05 01:30:00	1	1.91	220	448.3	t	2026-05-08 00:01:27.547131
9083	2026-03-05 01:30:00	4	1.71	220	333.5	t	2026-05-08 00:01:27.547131
9084	2026-03-05 01:30:00	7	3.35	220	484.4	t	2026-05-08 00:01:27.547131
9085	2026-03-05 02:00:00	1	1.36	220	446.1	t	2026-05-08 00:01:27.547131
9086	2026-03-05 02:00:00	4	3.07	220	549.6	t	2026-05-08 00:01:27.547131
9087	2026-03-05 02:00:00	7	1.71	220	284.1	t	2026-05-08 00:01:27.547131
9088	2026-03-05 02:30:00	1	2.5	220	278.1	t	2026-05-08 00:01:27.547131
9089	2026-03-05 02:30:00	4	2.3	220	784.2	t	2026-05-08 00:01:27.547131
9090	2026-03-05 02:30:00	7	2.18	220	590.9	t	2026-05-08 00:01:27.547131
9091	2026-03-05 03:00:00	1	3.23	220	595.1	t	2026-05-08 00:01:27.547131
9092	2026-03-05 03:00:00	4	1.39	220	620.5	t	2026-05-08 00:01:27.547131
9093	2026-03-05 03:00:00	7	3.54	220	493.8	t	2026-05-08 00:01:27.547131
9094	2026-03-05 03:30:00	1	2.43	220	532.4	t	2026-05-08 00:01:27.547131
9095	2026-03-05 03:30:00	4	3.26	220	596.1	t	2026-05-08 00:01:27.547131
9096	2026-03-05 03:30:00	7	1.74	220	294.7	t	2026-05-08 00:01:27.547131
9097	2026-03-05 04:00:00	1	2.59	220	445.4	t	2026-05-08 00:01:27.547131
9098	2026-03-05 04:00:00	4	3.2	220	667.4	t	2026-05-08 00:01:27.547131
9099	2026-03-05 04:00:00	7	2.23	220	804.1	t	2026-05-08 00:01:27.547131
9100	2026-03-05 04:30:00	1	2.74	220	407.9	t	2026-05-08 00:01:27.547131
9101	2026-03-05 04:30:00	4	3.23	220	486.1	t	2026-05-08 00:01:27.547131
9102	2026-03-05 04:30:00	7	2.77	220	348.1	t	2026-05-08 00:01:27.547131
9103	2026-03-05 05:00:00	1	1.77	220	308.4	t	2026-05-08 00:01:27.547131
9104	2026-03-05 05:00:00	4	2.95	220	342.9	t	2026-05-08 00:01:27.547131
9105	2026-03-05 05:00:00	7	3.29	220	714.4	t	2026-05-08 00:01:27.547131
9106	2026-03-05 05:30:00	1	2.49	220	790.7	t	2026-05-08 00:01:27.547131
9107	2026-03-05 05:30:00	4	1.55	220	639.7	t	2026-05-08 00:01:27.547131
9108	2026-03-05 05:30:00	7	1.56	220	672.5	t	2026-05-08 00:01:27.547131
9109	2026-03-05 06:00:00	1	2.32	220	282.3	t	2026-05-08 00:01:27.547131
9110	2026-03-05 06:00:00	4	2.22	220	804.6	t	2026-05-08 00:01:27.547131
9111	2026-03-05 06:00:00	7	1.96	220	322.6	t	2026-05-08 00:01:27.547131
9112	2026-03-05 06:30:00	1	1.94	220	275.2	t	2026-05-08 00:01:27.547131
9113	2026-03-05 06:30:00	4	2.8	220	796.2	t	2026-05-08 00:01:27.547131
9114	2026-03-05 06:30:00	7	1.64	220	771.2	t	2026-05-08 00:01:27.547131
9115	2026-03-05 07:00:00	1	21.13	220	2654.3	t	2026-05-08 00:01:27.547131
9116	2026-03-05 07:00:00	4	22.27	220	5260.3	t	2026-05-08 00:01:27.547131
9117	2026-03-05 07:00:00	7	22.47	220	4529.2	t	2026-05-08 00:01:27.547131
9118	2026-03-05 07:30:00	1	12.83	220	2710.3	t	2026-05-08 00:01:27.547131
9119	2026-03-05 07:30:00	4	24.41	220	3562.6	t	2026-05-08 00:01:27.547131
9120	2026-03-05 07:30:00	7	27.96	220	4537.1	t	2026-05-08 00:01:27.547131
9121	2026-03-05 08:00:00	1	21.26	220	4016.6	t	2026-05-08 00:01:27.547131
9122	2026-03-05 08:00:00	4	22.37	220	4101.6	t	2026-05-08 00:01:27.547131
9123	2026-03-05 08:00:00	7	21.56	220	5169.6	t	2026-05-08 00:01:27.547131
9124	2026-03-05 08:30:00	1	15.33	220	4525.6	t	2026-05-08 00:01:27.547131
9125	2026-03-05 08:30:00	4	21.34	220	5151.4	t	2026-05-08 00:01:27.547131
9126	2026-03-05 08:30:00	7	20.57	220	6441.8	t	2026-05-08 00:01:27.547131
9127	2026-03-05 09:00:00	1	15.12	220	3476.2	t	2026-05-08 00:01:27.547131
9128	2026-03-05 09:00:00	4	25.13	220	4747.6	t	2026-05-08 00:01:27.547131
9129	2026-03-05 09:00:00	7	27.14	220	5814.4	t	2026-05-08 00:01:27.547131
9130	2026-03-05 09:30:00	1	17.19	220	2786.6	t	2026-05-08 00:01:27.547131
9131	2026-03-05 09:30:00	4	25.98	220	4197.9	t	2026-05-08 00:01:27.547131
9132	2026-03-05 09:30:00	7	23	220	6350.2	t	2026-05-08 00:01:27.547131
9133	2026-03-05 10:00:00	1	21.35	220	4322.7	t	2026-05-08 00:01:27.547131
9134	2026-03-05 10:00:00	4	18.82	220	4874.6	t	2026-05-08 00:01:27.547131
9135	2026-03-05 10:00:00	7	21.73	220	5782.1	t	2026-05-08 00:01:27.547131
9136	2026-03-05 10:30:00	1	12.79	220	4691.5	t	2026-05-08 00:01:27.547131
9137	2026-03-05 10:30:00	4	16.42	220	3685.6	t	2026-05-08 00:01:27.547131
9138	2026-03-05 10:30:00	7	28.47	220	5704.6	t	2026-05-08 00:01:27.547131
9139	2026-03-05 11:00:00	1	13.39	220	4307.8	t	2026-05-08 00:01:27.547131
9140	2026-03-05 11:00:00	4	24.05	220	3859.6	t	2026-05-08 00:01:27.547131
9141	2026-03-05 11:00:00	7	30.42	220	5780.6	t	2026-05-08 00:01:27.547131
9142	2026-03-05 11:30:00	1	18.38	220	3101.9	t	2026-05-08 00:01:27.547131
9143	2026-03-05 11:30:00	4	18.99	220	5066.3	t	2026-05-08 00:01:27.547131
9144	2026-03-05 11:30:00	7	21.55	220	5818.6	t	2026-05-08 00:01:27.547131
9145	2026-03-05 12:00:00	1	16.81	220	3868.5	t	2026-05-08 00:01:27.547131
9146	2026-03-05 12:00:00	4	19	220	4505.4	t	2026-05-08 00:01:27.547131
9147	2026-03-05 12:00:00	7	26.12	220	6576.6	t	2026-05-08 00:01:27.547131
9148	2026-03-05 12:30:00	1	12.37	220	4203.5	t	2026-05-08 00:01:27.547131
9149	2026-03-05 12:30:00	4	24.55	220	4908.6	t	2026-05-08 00:01:27.547131
9150	2026-03-05 12:30:00	7	26	220	6290.6	t	2026-05-08 00:01:27.547131
9151	2026-03-05 13:00:00	1	12.93	220	3388.8	t	2026-05-08 00:01:27.547131
9152	2026-03-05 13:00:00	4	22.92	220	4879.5	t	2026-05-08 00:01:27.547131
9153	2026-03-05 13:00:00	7	21.54	220	4974.2	t	2026-05-08 00:01:27.547131
9154	2026-03-05 13:30:00	1	21.43	220	3602.7	t	2026-05-08 00:01:27.547131
9155	2026-03-05 13:30:00	4	21.96	220	5409.1	t	2026-05-08 00:01:27.547131
9156	2026-03-05 13:30:00	7	25.3	220	5251.8	t	2026-05-08 00:01:27.547131
9157	2026-03-05 14:00:00	1	16.89	220	3427.6	t	2026-05-08 00:01:27.547131
9158	2026-03-05 14:00:00	4	16.35	220	4646.8	t	2026-05-08 00:01:27.547131
9159	2026-03-05 14:00:00	7	29.23	220	6411.4	t	2026-05-08 00:01:27.547131
9160	2026-03-05 14:30:00	1	19.19	220	3725.3	t	2026-05-08 00:01:27.547131
9161	2026-03-05 14:30:00	4	23.12	220	5122.6	t	2026-05-08 00:01:27.547131
9162	2026-03-05 14:30:00	7	24.41	220	4517.6	t	2026-05-08 00:01:27.547131
9163	2026-03-05 15:00:00	1	17.23	220	3978.6	t	2026-05-08 00:01:27.547131
9164	2026-03-05 15:00:00	4	23.81	220	4526.6	t	2026-05-08 00:01:27.547131
9165	2026-03-05 15:00:00	7	27.22	220	5642.6	t	2026-05-08 00:01:27.547131
9166	2026-03-05 15:30:00	1	18.75	220	3094.7	t	2026-05-08 00:01:27.547131
9167	2026-03-05 15:30:00	4	24.84	220	4683.7	t	2026-05-08 00:01:27.547131
9168	2026-03-05 15:30:00	7	29.49	220	4961.3	t	2026-05-08 00:01:27.547131
9169	2026-03-05 16:00:00	1	17.46	220	2970	t	2026-05-08 00:01:27.547131
9170	2026-03-05 16:00:00	4	21.21	220	5553.6	t	2026-05-08 00:01:27.547131
9171	2026-03-05 16:00:00	7	28.74	220	4542.9	t	2026-05-08 00:01:27.547131
9172	2026-03-05 16:30:00	1	11.9	220	3421.3	t	2026-05-08 00:01:27.547131
9173	2026-03-05 16:30:00	4	22.11	220	4114.5	t	2026-05-08 00:01:27.547131
9174	2026-03-05 16:30:00	7	20.58	220	4567.8	t	2026-05-08 00:01:27.547131
9175	2026-03-05 17:00:00	1	12.25	220	3373.4	t	2026-05-08 00:01:27.547131
9176	2026-03-05 17:00:00	4	19.01	220	3746.6	t	2026-05-08 00:01:27.547131
9177	2026-03-05 17:00:00	7	21.07	220	5649.6	t	2026-05-08 00:01:27.547131
9178	2026-03-05 17:30:00	1	20.64	220	3509.2	t	2026-05-08 00:01:27.547131
9179	2026-03-05 17:30:00	4	21.01	220	4421.5	t	2026-05-08 00:01:27.547131
9180	2026-03-05 17:30:00	7	30.06	220	5073	t	2026-05-08 00:01:27.547131
9181	2026-03-05 18:00:00	1	14.53	220	4557.3	t	2026-05-08 00:01:27.547131
9182	2026-03-05 18:00:00	4	19.26	220	3583	t	2026-05-08 00:01:27.547131
9183	2026-03-05 18:00:00	7	23.02	220	5730.7	t	2026-05-08 00:01:27.547131
9184	2026-03-05 18:30:00	1	16.33	220	2588.6	t	2026-05-08 00:01:27.547131
9185	2026-03-05 18:30:00	4	19.33	220	5623.6	t	2026-05-08 00:01:27.547131
9186	2026-03-05 18:30:00	7	26.12	220	5853.4	t	2026-05-08 00:01:27.547131
9187	2026-03-05 19:00:00	1	13.34	220	2954.6	t	2026-05-08 00:01:27.547131
9188	2026-03-05 19:00:00	4	22.16	220	3674.6	t	2026-05-08 00:01:27.547131
9189	2026-03-05 19:00:00	7	25.12	220	5424.9	t	2026-05-08 00:01:27.547131
9190	2026-03-05 19:30:00	1	12.65	220	2731.3	t	2026-05-08 00:01:27.547131
9191	2026-03-05 19:30:00	4	25.16	220	5182.7	t	2026-05-08 00:01:27.547131
9192	2026-03-05 19:30:00	7	21.92	220	5568.4	t	2026-05-08 00:01:27.547131
9193	2026-03-05 20:00:00	1	3.17	220	268.3	t	2026-05-08 00:01:27.547131
9194	2026-03-05 20:00:00	4	2.52	220	680.5	t	2026-05-08 00:01:27.547131
9195	2026-03-05 20:00:00	7	1.51	220	587.2	t	2026-05-08 00:01:27.547131
9196	2026-03-05 20:30:00	1	1.93	220	431.2	t	2026-05-08 00:01:27.547131
9197	2026-03-05 20:30:00	4	1.53	220	433.7	t	2026-05-08 00:01:27.547131
9198	2026-03-05 20:30:00	7	3.32	220	349.4	t	2026-05-08 00:01:27.547131
9199	2026-03-05 21:00:00	1	3.27	220	436.9	t	2026-05-08 00:01:27.547131
9200	2026-03-05 21:00:00	4	2.33	220	414.9	t	2026-05-08 00:01:27.547131
9201	2026-03-05 21:00:00	7	1.38	220	641.5	t	2026-05-08 00:01:27.547131
9202	2026-03-05 21:30:00	1	2.94	220	468	t	2026-05-08 00:01:27.547131
9203	2026-03-05 21:30:00	4	1.25	220	481.7	t	2026-05-08 00:01:27.547131
9204	2026-03-05 21:30:00	7	1.41	220	303.8	t	2026-05-08 00:01:27.547131
9205	2026-03-05 22:00:00	1	2.68	220	362.4	t	2026-05-08 00:01:27.547131
9206	2026-03-05 22:00:00	4	3.01	220	520.8	t	2026-05-08 00:01:27.547131
9207	2026-03-05 22:00:00	7	2.81	220	504	t	2026-05-08 00:01:27.547131
9208	2026-03-05 22:30:00	1	1.86	220	441.6	t	2026-05-08 00:01:27.547131
9209	2026-03-05 22:30:00	4	3.58	220	272.6	t	2026-05-08 00:01:27.547131
9210	2026-03-05 22:30:00	7	1.76	220	333.8	t	2026-05-08 00:01:27.547131
9211	2026-03-05 23:00:00	1	1.4	220	376.2	t	2026-05-08 00:01:27.547131
9212	2026-03-05 23:00:00	4	3.37	220	283.8	t	2026-05-08 00:01:27.547131
9213	2026-03-05 23:00:00	7	2.1	220	780.2	t	2026-05-08 00:01:27.547131
9214	2026-03-05 23:30:00	1	1.41	220	297.2	t	2026-05-08 00:01:27.547131
9215	2026-03-05 23:30:00	4	3.47	220	374.7	t	2026-05-08 00:01:27.547131
9216	2026-03-05 23:30:00	7	2.97	220	660.8	t	2026-05-08 00:01:27.547131
9217	2026-03-06 00:00:00	1	2.99	220	344.2	t	2026-05-08 00:01:27.547131
9218	2026-03-06 00:00:00	4	3.34	220	719.4	t	2026-05-08 00:01:27.547131
9219	2026-03-06 00:00:00	7	3.38	220	555.4	t	2026-05-08 00:01:27.547131
9220	2026-03-06 00:30:00	1	2.11	220	748.5	t	2026-05-08 00:01:27.547131
9221	2026-03-06 00:30:00	4	1.65	220	494.2	t	2026-05-08 00:01:27.547131
9222	2026-03-06 00:30:00	7	2.9	220	400.5	t	2026-05-08 00:01:27.547131
9223	2026-03-06 01:00:00	1	3.57	220	714	t	2026-05-08 00:01:27.547131
9224	2026-03-06 01:00:00	4	1.49	220	327.6	t	2026-05-08 00:01:27.547131
9225	2026-03-06 01:00:00	7	2.99	220	778.7	t	2026-05-08 00:01:27.547131
9226	2026-03-06 01:30:00	1	1.35	220	681.1	t	2026-05-08 00:01:27.547131
9227	2026-03-06 01:30:00	4	3.1	220	269.9	t	2026-05-08 00:01:27.547131
9228	2026-03-06 01:30:00	7	3.49	220	588.1	t	2026-05-08 00:01:27.547131
9229	2026-03-06 02:00:00	1	1.76	220	386.2	t	2026-05-08 00:01:27.547131
9230	2026-03-06 02:00:00	4	1.48	220	654.2	t	2026-05-08 00:01:27.547131
9231	2026-03-06 02:00:00	7	1.21	220	495.4	t	2026-05-08 00:01:27.547131
9232	2026-03-06 02:30:00	1	2.8	220	806.4	t	2026-05-08 00:01:27.547131
9233	2026-03-06 02:30:00	4	2.4	220	758.7	t	2026-05-08 00:01:27.547131
9234	2026-03-06 02:30:00	7	3.33	220	334	t	2026-05-08 00:01:27.547131
9235	2026-03-06 03:00:00	1	1.57	220	436.4	t	2026-05-08 00:01:27.547131
9236	2026-03-06 03:00:00	4	1.73	220	348.4	t	2026-05-08 00:01:27.547131
9237	2026-03-06 03:00:00	7	3.51	220	795.6	t	2026-05-08 00:01:27.547131
9238	2026-03-06 03:30:00	1	1.64	220	628.9	t	2026-05-08 00:01:27.547131
9239	2026-03-06 03:30:00	4	1.34	220	656.5	t	2026-05-08 00:01:27.547131
9240	2026-03-06 03:30:00	7	1.81	220	737.7	t	2026-05-08 00:01:27.547131
9241	2026-03-06 04:00:00	1	3.68	220	408.7	t	2026-05-08 00:01:27.547131
9242	2026-03-06 04:00:00	4	2.65	220	450.7	t	2026-05-08 00:01:27.547131
9243	2026-03-06 04:00:00	7	1.78	220	344	t	2026-05-08 00:01:27.547131
9244	2026-03-06 04:30:00	1	1.99	220	553.4	t	2026-05-08 00:01:27.547131
9245	2026-03-06 04:30:00	4	2.86	220	547.2	t	2026-05-08 00:01:27.547131
9246	2026-03-06 04:30:00	7	3.22	220	583.1	t	2026-05-08 00:01:27.547131
9247	2026-03-06 05:00:00	1	1.73	220	281.8	t	2026-05-08 00:01:27.547131
9248	2026-03-06 05:00:00	4	3.37	220	513	t	2026-05-08 00:01:27.547131
9249	2026-03-06 05:00:00	7	1.29	220	646.5	t	2026-05-08 00:01:27.547131
9250	2026-03-06 05:30:00	1	1.2	220	626.9	t	2026-05-08 00:01:27.547131
9251	2026-03-06 05:30:00	4	1.25	220	369.5	t	2026-05-08 00:01:27.547131
9252	2026-03-06 05:30:00	7	2.88	220	418.8	t	2026-05-08 00:01:27.547131
9253	2026-03-06 06:00:00	1	2.27	220	469.5	t	2026-05-08 00:01:27.547131
9254	2026-03-06 06:00:00	4	2.25	220	416.3	t	2026-05-08 00:01:27.547131
9255	2026-03-06 06:00:00	7	1.85	220	526.6	t	2026-05-08 00:01:27.547131
9256	2026-03-06 06:30:00	1	1.97	220	646.9	t	2026-05-08 00:01:27.547131
9257	2026-03-06 06:30:00	4	2.57	220	649.2	t	2026-05-08 00:01:27.547131
9258	2026-03-06 06:30:00	7	1.41	220	737.1	t	2026-05-08 00:01:27.547131
9259	2026-03-06 07:00:00	1	21.02	220	2704.7	t	2026-05-08 00:01:27.547131
9260	2026-03-06 07:00:00	4	25.61	220	4973	t	2026-05-08 00:01:27.547131
9261	2026-03-06 07:00:00	7	23.98	220	4646.2	t	2026-05-08 00:01:27.547131
9262	2026-03-06 07:30:00	1	11.53	220	3331.3	t	2026-05-08 00:01:27.547131
9263	2026-03-06 07:30:00	4	17.9	220	4446.9	t	2026-05-08 00:01:27.547131
9264	2026-03-06 07:30:00	7	25.68	220	5784.2	t	2026-05-08 00:01:27.547131
9265	2026-03-06 08:00:00	1	17.93	220	2701.7	t	2026-05-08 00:01:27.547131
9266	2026-03-06 08:00:00	4	21.17	220	3695.1	t	2026-05-08 00:01:27.547131
9267	2026-03-06 08:00:00	7	21.77	220	4796.2	t	2026-05-08 00:01:27.547131
9268	2026-03-06 08:30:00	1	13.98	220	4618.5	t	2026-05-08 00:01:27.547131
9269	2026-03-06 08:30:00	4	16.2	220	4561.5	t	2026-05-08 00:01:27.547131
9270	2026-03-06 08:30:00	7	24.04	220	5533.9	t	2026-05-08 00:01:27.547131
9271	2026-03-06 09:00:00	1	21.37	220	4204	t	2026-05-08 00:01:27.547131
9272	2026-03-06 09:00:00	4	22.29	220	5044.1	t	2026-05-08 00:01:27.547131
9273	2026-03-06 09:00:00	7	22.08	220	4607.8	t	2026-05-08 00:01:27.547131
9274	2026-03-06 09:30:00	1	12.77	220	3741.4	t	2026-05-08 00:01:27.547131
9275	2026-03-06 09:30:00	4	17.04	220	4341.8	t	2026-05-08 00:01:27.547131
9276	2026-03-06 09:30:00	7	30.41	220	4816.8	t	2026-05-08 00:01:27.547131
9277	2026-03-06 10:00:00	1	16.36	220	3324.8	t	2026-05-08 00:01:27.547131
9278	2026-03-06 10:00:00	4	25.42	220	5179.6	t	2026-05-08 00:01:27.547131
9279	2026-03-06 10:00:00	7	20.66	220	4623.1	t	2026-05-08 00:01:27.547131
9280	2026-03-06 10:30:00	1	15.79	220	2920.6	t	2026-05-08 00:01:27.547131
9281	2026-03-06 10:30:00	4	20.3	220	4634.7	t	2026-05-08 00:01:27.547131
9282	2026-03-06 10:30:00	7	25.51	220	6513.1	t	2026-05-08 00:01:27.547131
9283	2026-03-06 11:00:00	1	16.09	220	4654.9	t	2026-05-08 00:01:27.547131
9284	2026-03-06 11:00:00	4	24.41	220	5195.6	t	2026-05-08 00:01:27.547131
9285	2026-03-06 11:00:00	7	24.42	220	5636.4	t	2026-05-08 00:01:27.547131
9286	2026-03-06 11:30:00	1	13.93	220	2702.8	t	2026-05-08 00:01:27.547131
9287	2026-03-06 11:30:00	4	18.12	220	3607.6	t	2026-05-08 00:01:27.547131
9288	2026-03-06 11:30:00	7	26.13	220	4696	t	2026-05-08 00:01:27.547131
9289	2026-03-06 12:00:00	1	12.17	220	4606.3	t	2026-05-08 00:01:27.547131
9290	2026-03-06 12:00:00	4	21.08	220	3728.7	t	2026-05-08 00:01:27.547131
9291	2026-03-06 12:00:00	7	22.18	220	5097.1	t	2026-05-08 00:01:27.547131
9292	2026-03-06 12:30:00	1	14.5	220	2767.8	t	2026-05-08 00:01:27.547131
9293	2026-03-06 12:30:00	4	24.15	220	5078.9	t	2026-05-08 00:01:27.547131
9294	2026-03-06 12:30:00	7	23.89	220	4771.9	t	2026-05-08 00:01:27.547131
9295	2026-03-06 13:00:00	1	18.3	220	3681.8	t	2026-05-08 00:01:27.547131
9296	2026-03-06 13:00:00	4	18.36	220	3966.7	t	2026-05-08 00:01:27.547131
9297	2026-03-06 13:00:00	7	23.33	220	5463.7	t	2026-05-08 00:01:27.547131
9298	2026-03-06 13:30:00	1	21.05	220	4363.1	t	2026-05-08 00:01:27.547131
9299	2026-03-06 13:30:00	4	24.96	220	4336.5	t	2026-05-08 00:01:27.547131
9300	2026-03-06 13:30:00	7	26.36	220	4637.5	t	2026-05-08 00:01:27.547131
9301	2026-03-06 14:00:00	1	13.24	220	3429	t	2026-05-08 00:01:27.547131
9302	2026-03-06 14:00:00	4	23.46	220	4147.4	t	2026-05-08 00:01:27.547131
9303	2026-03-06 14:00:00	7	29.44	220	4730.2	t	2026-05-08 00:01:27.547131
9304	2026-03-06 14:30:00	1	13.77	220	3187	t	2026-05-08 00:01:27.547131
9305	2026-03-06 14:30:00	4	21.34	220	4855.7	t	2026-05-08 00:01:27.547131
9306	2026-03-06 14:30:00	7	23.67	220	4817.1	t	2026-05-08 00:01:27.547131
9307	2026-03-06 15:00:00	1	17.32	220	3757	t	2026-05-08 00:01:27.547131
9308	2026-03-06 15:00:00	4	24.82	220	5575.2	t	2026-05-08 00:01:27.547131
9309	2026-03-06 15:00:00	7	24.31	220	6425	t	2026-05-08 00:01:27.547131
9310	2026-03-06 15:30:00	1	20.07	220	4275.2	t	2026-05-08 00:01:27.547131
9311	2026-03-06 15:30:00	4	16.11	220	3643.1	t	2026-05-08 00:01:27.547131
9312	2026-03-06 15:30:00	7	30.03	220	6624.9	t	2026-05-08 00:01:27.547131
9313	2026-03-06 16:00:00	1	15.72	220	3184.2	t	2026-05-08 00:01:27.547131
9314	2026-03-06 16:00:00	4	24.18	220	5448.3	t	2026-05-08 00:01:27.547131
9315	2026-03-06 16:00:00	7	20.8	220	6630.9	t	2026-05-08 00:01:27.547131
9316	2026-03-06 16:30:00	1	20.84	220	2829.4	t	2026-05-08 00:01:27.547131
9317	2026-03-06 16:30:00	4	18.73	220	3926.1	t	2026-05-08 00:01:27.547131
9318	2026-03-06 16:30:00	7	26.33	220	4994.5	t	2026-05-08 00:01:27.547131
9319	2026-03-06 17:00:00	1	20.05	220	3937.7	t	2026-05-08 00:01:27.547131
9320	2026-03-06 17:00:00	4	19.8	220	4599	t	2026-05-08 00:01:27.547131
9321	2026-03-06 17:00:00	7	23.83	220	4972	t	2026-05-08 00:01:27.547131
9322	2026-03-06 17:30:00	1	15.69	220	3172.4	t	2026-05-08 00:01:27.547131
9323	2026-03-06 17:30:00	4	25.95	220	4092.5	t	2026-05-08 00:01:27.547131
9324	2026-03-06 17:30:00	7	23.82	220	6265.7	t	2026-05-08 00:01:27.547131
9325	2026-03-06 18:00:00	1	16.86	220	3801.1	t	2026-05-08 00:01:27.547131
9326	2026-03-06 18:00:00	4	25.5	220	3764.6	t	2026-05-08 00:01:27.547131
9327	2026-03-06 18:00:00	7	22.66	220	5629.2	t	2026-05-08 00:01:27.547131
9328	2026-03-06 18:30:00	1	18.53	220	2705.4	t	2026-05-08 00:01:27.547131
9329	2026-03-06 18:30:00	4	24.13	220	3563.1	t	2026-05-08 00:01:27.547131
9330	2026-03-06 18:30:00	7	26.57	220	5512	t	2026-05-08 00:01:27.547131
9331	2026-03-06 19:00:00	1	14.16	220	4229.5	t	2026-05-08 00:01:27.547131
9332	2026-03-06 19:00:00	4	18.15	220	5007	t	2026-05-08 00:01:27.547131
9333	2026-03-06 19:00:00	7	28.66	220	4887.7	t	2026-05-08 00:01:27.547131
9334	2026-03-06 19:30:00	1	21.01	220	3967.8	t	2026-05-08 00:01:27.547131
9335	2026-03-06 19:30:00	4	22.69	220	4777.7	t	2026-05-08 00:01:27.547131
9336	2026-03-06 19:30:00	7	21.4	220	6363.9	t	2026-05-08 00:01:27.547131
9337	2026-03-06 20:00:00	1	1.94	220	658.7	t	2026-05-08 00:01:27.547131
9338	2026-03-06 20:00:00	4	1.35	220	451.3	t	2026-05-08 00:01:27.547131
9339	2026-03-06 20:00:00	7	1.56	220	722.3	t	2026-05-08 00:01:27.547131
9340	2026-03-06 20:30:00	1	1.76	220	497.5	t	2026-05-08 00:01:27.547131
9341	2026-03-06 20:30:00	4	1.79	220	295.6	t	2026-05-08 00:01:27.547131
9342	2026-03-06 20:30:00	7	2.99	220	483.7	t	2026-05-08 00:01:27.547131
9343	2026-03-06 21:00:00	1	1.99	220	706	t	2026-05-08 00:01:27.547131
9344	2026-03-06 21:00:00	4	2.93	220	803.8	t	2026-05-08 00:01:27.547131
9345	2026-03-06 21:00:00	7	2.58	220	639.7	t	2026-05-08 00:01:27.547131
9346	2026-03-06 21:30:00	1	3.13	220	358.6	t	2026-05-08 00:01:27.547131
9347	2026-03-06 21:30:00	4	2.39	220	468.1	t	2026-05-08 00:01:27.547131
9348	2026-03-06 21:30:00	7	1.98	220	769.4	t	2026-05-08 00:01:27.547131
9349	2026-03-06 22:00:00	1	2.79	220	767.8	t	2026-05-08 00:01:27.547131
9350	2026-03-06 22:00:00	4	1.35	220	790	t	2026-05-08 00:01:27.547131
9351	2026-03-06 22:00:00	7	1.67	220	718.6	t	2026-05-08 00:01:27.547131
9352	2026-03-06 22:30:00	1	2.02	220	640.8	t	2026-05-08 00:01:27.547131
9353	2026-03-06 22:30:00	4	2.1	220	457.7	t	2026-05-08 00:01:27.547131
9354	2026-03-06 22:30:00	7	1.77	220	484.7	t	2026-05-08 00:01:27.547131
9355	2026-03-06 23:00:00	1	1.65	220	720.9	t	2026-05-08 00:01:27.547131
9356	2026-03-06 23:00:00	4	2.64	220	716.7	t	2026-05-08 00:01:27.547131
9357	2026-03-06 23:00:00	7	1.94	220	552.2	t	2026-05-08 00:01:27.547131
9358	2026-03-06 23:30:00	1	3.3	220	656.4	t	2026-05-08 00:01:27.547131
9359	2026-03-06 23:30:00	4	1.23	220	404	t	2026-05-08 00:01:27.547131
9360	2026-03-06 23:30:00	7	2.35	220	542.4	t	2026-05-08 00:01:27.547131
9361	2026-03-07 00:00:00	1	2.98	220	479.9	t	2026-05-08 00:01:27.547131
9362	2026-03-07 00:00:00	4	1.33	220	312.1	t	2026-05-08 00:01:27.547131
9363	2026-03-07 00:00:00	7	1.21	220	324.2	t	2026-05-08 00:01:27.547131
9364	2026-03-07 00:30:00	1	2.06	220	542.1	t	2026-05-08 00:01:27.547131
9365	2026-03-07 00:30:00	4	2.3	220	487.5	t	2026-05-08 00:01:27.547131
9366	2026-03-07 00:30:00	7	1.96	220	293.3	t	2026-05-08 00:01:27.547131
9367	2026-03-07 01:00:00	1	1.85	220	582.3	t	2026-05-08 00:01:27.547131
9368	2026-03-07 01:00:00	4	2.28	220	430.8	t	2026-05-08 00:01:27.547131
9369	2026-03-07 01:00:00	7	2.21	220	284.4	t	2026-05-08 00:01:27.547131
9370	2026-03-07 01:30:00	1	2.84	220	371.2	t	2026-05-08 00:01:27.547131
9371	2026-03-07 01:30:00	4	2.12	220	287	t	2026-05-08 00:01:27.547131
9372	2026-03-07 01:30:00	7	2.48	220	632.6	t	2026-05-08 00:01:27.547131
9373	2026-03-07 02:00:00	1	1.24	220	476.8	t	2026-05-08 00:01:27.547131
9374	2026-03-07 02:00:00	4	2.33	220	413	t	2026-05-08 00:01:27.547131
9375	2026-03-07 02:00:00	7	1.74	220	606.3	t	2026-05-08 00:01:27.547131
9376	2026-03-07 02:30:00	1	1.37	220	240.5	t	2026-05-08 00:01:27.547131
9377	2026-03-07 02:30:00	4	1.07	220	433.4	t	2026-05-08 00:01:27.547131
9378	2026-03-07 02:30:00	7	1.64	220	559.1	t	2026-05-08 00:01:27.547131
9379	2026-03-07 03:00:00	1	2.78	220	423.6	t	2026-05-08 00:01:27.547131
9380	2026-03-07 03:00:00	4	1.02	220	591.3	t	2026-05-08 00:01:27.547131
9381	2026-03-07 03:00:00	7	2.21	220	368.9	t	2026-05-08 00:01:27.547131
9382	2026-03-07 03:30:00	1	2.2	220	338.2	t	2026-05-08 00:01:27.547131
9383	2026-03-07 03:30:00	4	2.5	220	555	t	2026-05-08 00:01:27.547131
9384	2026-03-07 03:30:00	7	1.5	220	382	t	2026-05-08 00:01:27.547131
9385	2026-03-07 04:00:00	1	2.11	220	513.7	t	2026-05-08 00:01:27.547131
9386	2026-03-07 04:00:00	4	1.59	220	475.4	t	2026-05-08 00:01:27.547131
9387	2026-03-07 04:00:00	7	2.51	220	590.2	t	2026-05-08 00:01:27.547131
9388	2026-03-07 04:30:00	1	2.94	220	225.2	t	2026-05-08 00:01:27.547131
9389	2026-03-07 04:30:00	4	1.87	220	326.9	t	2026-05-08 00:01:27.547131
9390	2026-03-07 04:30:00	7	2.56	220	474.1	t	2026-05-08 00:01:27.547131
9391	2026-03-07 05:00:00	1	2.81	220	525.1	t	2026-05-08 00:01:27.547131
9392	2026-03-07 05:00:00	4	1.42	220	268.3	t	2026-05-08 00:01:27.547131
9393	2026-03-07 05:00:00	7	2.36	220	392	t	2026-05-08 00:01:27.547131
9394	2026-03-07 05:30:00	1	2.49	220	395	t	2026-05-08 00:01:27.547131
9395	2026-03-07 05:30:00	4	2.9	220	646.3	t	2026-05-08 00:01:27.547131
9396	2026-03-07 05:30:00	7	1.08	220	634.5	t	2026-05-08 00:01:27.547131
9397	2026-03-07 06:00:00	1	2.94	220	468.9	t	2026-05-08 00:01:27.547131
9398	2026-03-07 06:00:00	4	2.93	220	616.7	t	2026-05-08 00:01:27.547131
9399	2026-03-07 06:00:00	7	1.23	220	651.1	t	2026-05-08 00:01:27.547131
9400	2026-03-07 06:30:00	1	1.67	220	600.1	t	2026-05-08 00:01:27.547131
9401	2026-03-07 06:30:00	4	2.91	220	608.5	t	2026-05-08 00:01:27.547131
9402	2026-03-07 06:30:00	7	1.48	220	348	t	2026-05-08 00:01:27.547131
9403	2026-03-07 07:00:00	1	1.12	220	654.8	t	2026-05-08 00:01:27.547131
9404	2026-03-07 07:00:00	4	1.74	220	316.9	t	2026-05-08 00:01:27.547131
9405	2026-03-07 07:00:00	7	1.39	220	434.2	t	2026-05-08 00:01:27.547131
9406	2026-03-07 07:30:00	1	1.3	220	385.6	t	2026-05-08 00:01:27.547131
9407	2026-03-07 07:30:00	4	2.59	220	319.3	t	2026-05-08 00:01:27.547131
9408	2026-03-07 07:30:00	7	2.82	220	412.3	t	2026-05-08 00:01:27.547131
9409	2026-03-07 08:00:00	1	2.35	220	457	t	2026-05-08 00:01:27.547131
9410	2026-03-07 08:00:00	4	1.66	220	395.6	t	2026-05-08 00:01:27.547131
9411	2026-03-07 08:00:00	7	1.24	220	370.7	t	2026-05-08 00:01:27.547131
9412	2026-03-07 08:30:00	1	1.75	220	571.2	t	2026-05-08 00:01:27.547131
9413	2026-03-07 08:30:00	4	1.58	220	646.9	t	2026-05-08 00:01:27.547131
9414	2026-03-07 08:30:00	7	1.93	220	395.8	t	2026-05-08 00:01:27.547131
9415	2026-03-07 09:00:00	1	2.45	220	501.2	t	2026-05-08 00:01:27.547131
9416	2026-03-07 09:00:00	4	2.63	220	267.8	t	2026-05-08 00:01:27.547131
9417	2026-03-07 09:00:00	7	2.59	220	526.4	t	2026-05-08 00:01:27.547131
9418	2026-03-07 09:30:00	1	1.8	220	224.7	t	2026-05-08 00:01:27.547131
9419	2026-03-07 09:30:00	4	2.82	220	270.6	t	2026-05-08 00:01:27.547131
9420	2026-03-07 09:30:00	7	1.59	220	550	t	2026-05-08 00:01:27.547131
9421	2026-03-07 10:00:00	1	2.43	220	567.5	t	2026-05-08 00:01:27.547131
9422	2026-03-07 10:00:00	4	1.66	220	510.6	t	2026-05-08 00:01:27.547131
9423	2026-03-07 10:00:00	7	1.98	220	307.7	t	2026-05-08 00:01:27.547131
9424	2026-03-07 10:30:00	1	1.43	220	225.9	t	2026-05-08 00:01:27.547131
9425	2026-03-07 10:30:00	4	2.33	220	500.9	t	2026-05-08 00:01:27.547131
9426	2026-03-07 10:30:00	7	2.7	220	480.2	t	2026-05-08 00:01:27.547131
9427	2026-03-07 11:00:00	1	1.62	220	648.7	t	2026-05-08 00:01:27.547131
9428	2026-03-07 11:00:00	4	2.47	220	510.2	t	2026-05-08 00:01:27.547131
9429	2026-03-07 11:00:00	7	1.78	220	534.3	t	2026-05-08 00:01:27.547131
9430	2026-03-07 11:30:00	1	1.56	220	277.4	t	2026-05-08 00:01:27.547131
9431	2026-03-07 11:30:00	4	1.31	220	368.8	t	2026-05-08 00:01:27.547131
9432	2026-03-07 11:30:00	7	2.05	220	586.6	t	2026-05-08 00:01:27.547131
9433	2026-03-07 12:00:00	1	2.7	220	250.1	t	2026-05-08 00:01:27.547131
9434	2026-03-07 12:00:00	4	1.08	220	406.7	t	2026-05-08 00:01:27.547131
9435	2026-03-07 12:00:00	7	2.57	220	414.2	t	2026-05-08 00:01:27.547131
9436	2026-03-07 12:30:00	1	1.63	220	613.8	t	2026-05-08 00:01:27.547131
9437	2026-03-07 12:30:00	4	2.28	220	544.7	t	2026-05-08 00:01:27.547131
9438	2026-03-07 12:30:00	7	2.54	220	526.3	t	2026-05-08 00:01:27.547131
9439	2026-03-07 13:00:00	1	1.26	220	523.9	t	2026-05-08 00:01:27.547131
9440	2026-03-07 13:00:00	4	1.14	220	593.9	t	2026-05-08 00:01:27.547131
9441	2026-03-07 13:00:00	7	1.85	220	581.9	t	2026-05-08 00:01:27.547131
9442	2026-03-07 13:30:00	1	2.39	220	486.4	t	2026-05-08 00:01:27.547131
9443	2026-03-07 13:30:00	4	2.4	220	404.9	t	2026-05-08 00:01:27.547131
9444	2026-03-07 13:30:00	7	1.34	220	350.6	t	2026-05-08 00:01:27.547131
9445	2026-03-07 14:00:00	1	2.02	220	510.3	t	2026-05-08 00:01:27.547131
9446	2026-03-07 14:00:00	4	2.7	220	290.5	t	2026-05-08 00:01:27.547131
9447	2026-03-07 14:00:00	7	1.72	220	614.1	t	2026-05-08 00:01:27.547131
9448	2026-03-07 14:30:00	1	1.69	220	559.8	t	2026-05-08 00:01:27.547131
9449	2026-03-07 14:30:00	4	2.88	220	276.8	t	2026-05-08 00:01:27.547131
9450	2026-03-07 14:30:00	7	1.93	220	295.1	t	2026-05-08 00:01:27.547131
9451	2026-03-07 15:00:00	1	1.44	220	604.1	t	2026-05-08 00:01:27.547131
9452	2026-03-07 15:00:00	4	1.15	220	592.6	t	2026-05-08 00:01:27.547131
9453	2026-03-07 15:00:00	7	1.89	220	436.8	t	2026-05-08 00:01:27.547131
9454	2026-03-07 15:30:00	1	2.16	220	618.6	t	2026-05-08 00:01:27.547131
9455	2026-03-07 15:30:00	4	1.8	220	434	t	2026-05-08 00:01:27.547131
9456	2026-03-07 15:30:00	7	1.68	220	531.5	t	2026-05-08 00:01:27.547131
9457	2026-03-07 16:00:00	1	1.57	220	643.4	t	2026-05-08 00:01:27.547131
9458	2026-03-07 16:00:00	4	1.57	220	233	t	2026-05-08 00:01:27.547131
9459	2026-03-07 16:00:00	7	2.15	220	476.9	t	2026-05-08 00:01:27.547131
9460	2026-03-07 16:30:00	1	2.22	220	276.7	t	2026-05-08 00:01:27.547131
9461	2026-03-07 16:30:00	4	1.57	220	599.5	t	2026-05-08 00:01:27.547131
9462	2026-03-07 16:30:00	7	1.68	220	326.8	t	2026-05-08 00:01:27.547131
9463	2026-03-07 17:00:00	1	1.19	220	328.6	t	2026-05-08 00:01:27.547131
9464	2026-03-07 17:00:00	4	1.49	220	637.1	t	2026-05-08 00:01:27.547131
9465	2026-03-07 17:00:00	7	1.73	220	296.6	t	2026-05-08 00:01:27.547131
9466	2026-03-07 17:30:00	1	1.68	220	458.4	t	2026-05-08 00:01:27.547131
9467	2026-03-07 17:30:00	4	2.77	220	431.4	t	2026-05-08 00:01:27.547131
9468	2026-03-07 17:30:00	7	1.29	220	432.1	t	2026-05-08 00:01:27.547131
9469	2026-03-07 18:00:00	1	2.13	220	508.6	t	2026-05-08 00:01:27.547131
9470	2026-03-07 18:00:00	4	1.4	220	221	t	2026-05-08 00:01:27.547131
9471	2026-03-07 18:00:00	7	2.92	220	238	t	2026-05-08 00:01:27.547131
9472	2026-03-07 18:30:00	1	1.02	220	388.1	t	2026-05-08 00:01:27.547131
9473	2026-03-07 18:30:00	4	2.04	220	454	t	2026-05-08 00:01:27.547131
9474	2026-03-07 18:30:00	7	2.25	220	445.7	t	2026-05-08 00:01:27.547131
9475	2026-03-07 19:00:00	1	2.01	220	505.4	t	2026-05-08 00:01:27.547131
9476	2026-03-07 19:00:00	4	2.46	220	474.4	t	2026-05-08 00:01:27.547131
9477	2026-03-07 19:00:00	7	2.35	220	657.2	t	2026-05-08 00:01:27.547131
9478	2026-03-07 19:30:00	1	2.46	220	483.3	t	2026-05-08 00:01:27.547131
9479	2026-03-07 19:30:00	4	2.67	220	461.8	t	2026-05-08 00:01:27.547131
9480	2026-03-07 19:30:00	7	2.61	220	444.4	t	2026-05-08 00:01:27.547131
9481	2026-03-07 20:00:00	1	2.16	220	625.5	t	2026-05-08 00:01:27.547131
9482	2026-03-07 20:00:00	4	1.58	220	421.2	t	2026-05-08 00:01:27.547131
9483	2026-03-07 20:00:00	7	1.29	220	350.1	t	2026-05-08 00:01:27.547131
9484	2026-03-07 20:30:00	1	1.31	220	395.2	t	2026-05-08 00:01:27.547131
9485	2026-03-07 20:30:00	4	2.68	220	381.9	t	2026-05-08 00:01:27.547131
9486	2026-03-07 20:30:00	7	2.92	220	389.2	t	2026-05-08 00:01:27.547131
9487	2026-03-07 21:00:00	1	2.08	220	338.9	t	2026-05-08 00:01:27.547131
9488	2026-03-07 21:00:00	4	2.51	220	577.8	t	2026-05-08 00:01:27.547131
9489	2026-03-07 21:00:00	7	2.63	220	223.3	t	2026-05-08 00:01:27.547131
9490	2026-03-07 21:30:00	1	1.67	220	362.5	t	2026-05-08 00:01:27.547131
9491	2026-03-07 21:30:00	4	2.02	220	315.3	t	2026-05-08 00:01:27.547131
9492	2026-03-07 21:30:00	7	1.5	220	614.7	t	2026-05-08 00:01:27.547131
9493	2026-03-07 22:00:00	1	2.56	220	430.9	t	2026-05-08 00:01:27.547131
9494	2026-03-07 22:00:00	4	2.52	220	485.7	t	2026-05-08 00:01:27.547131
9495	2026-03-07 22:00:00	7	1.44	220	429.6	t	2026-05-08 00:01:27.547131
9496	2026-03-07 22:30:00	1	1.97	220	455.1	t	2026-05-08 00:01:27.547131
9497	2026-03-07 22:30:00	4	1.57	220	392.8	t	2026-05-08 00:01:27.547131
9498	2026-03-07 22:30:00	7	2.48	220	255.8	t	2026-05-08 00:01:27.547131
9499	2026-03-07 23:00:00	1	1.83	220	341.2	t	2026-05-08 00:01:27.547131
9500	2026-03-07 23:00:00	4	1.04	220	620.6	t	2026-05-08 00:01:27.547131
9501	2026-03-07 23:00:00	7	2.68	220	223.3	t	2026-05-08 00:01:27.547131
9502	2026-03-07 23:30:00	1	2.15	220	285.7	t	2026-05-08 00:01:27.547131
9503	2026-03-07 23:30:00	4	1.41	220	221.6	t	2026-05-08 00:01:27.547131
9504	2026-03-07 23:30:00	7	1.18	220	486.7	t	2026-05-08 00:01:27.547131
9505	2026-03-08 00:00:00	1	2.81	220	341.6	t	2026-05-08 00:01:27.547131
9506	2026-03-08 00:00:00	4	2.08	220	463.1	t	2026-05-08 00:01:27.547131
9507	2026-03-08 00:00:00	7	2.24	220	317.2	t	2026-05-08 00:01:27.547131
9508	2026-03-08 00:30:00	1	2.82	220	327.6	t	2026-05-08 00:01:27.547131
9509	2026-03-08 00:30:00	4	1.41	220	466.4	t	2026-05-08 00:01:27.547131
9510	2026-03-08 00:30:00	7	2.92	220	261.2	t	2026-05-08 00:01:27.547131
9511	2026-03-08 01:00:00	1	1.96	220	249.3	t	2026-05-08 00:01:27.547131
9512	2026-03-08 01:00:00	4	1.06	220	336.5	t	2026-05-08 00:01:27.547131
9513	2026-03-08 01:00:00	7	2.66	220	491.9	t	2026-05-08 00:01:27.547131
9514	2026-03-08 01:30:00	1	1.43	220	324.2	t	2026-05-08 00:01:27.547131
9515	2026-03-08 01:30:00	4	1.4	220	608.6	t	2026-05-08 00:01:27.547131
9516	2026-03-08 01:30:00	7	2.73	220	248.3	t	2026-05-08 00:01:27.547131
9517	2026-03-08 02:00:00	1	1.41	220	591	t	2026-05-08 00:01:27.547131
9518	2026-03-08 02:00:00	4	2.94	220	402.9	t	2026-05-08 00:01:27.547131
9519	2026-03-08 02:00:00	7	1.22	220	289.4	t	2026-05-08 00:01:27.547131
9520	2026-03-08 02:30:00	1	2.52	220	323.1	t	2026-05-08 00:01:27.547131
9521	2026-03-08 02:30:00	4	2.07	220	539	t	2026-05-08 00:01:27.547131
9522	2026-03-08 02:30:00	7	1.59	220	568.7	t	2026-05-08 00:01:27.547131
9523	2026-03-08 03:00:00	1	2.62	220	345	t	2026-05-08 00:01:27.547131
9524	2026-03-08 03:00:00	4	1.63	220	377.8	t	2026-05-08 00:01:27.547131
9525	2026-03-08 03:00:00	7	1.72	220	579.2	t	2026-05-08 00:01:27.547131
9526	2026-03-08 03:30:00	1	2.99	220	613.1	t	2026-05-08 00:01:27.547131
9527	2026-03-08 03:30:00	4	2.89	220	499.2	t	2026-05-08 00:01:27.547131
9528	2026-03-08 03:30:00	7	1.78	220	472.4	t	2026-05-08 00:01:27.547131
9529	2026-03-08 04:00:00	1	2.19	220	522.7	t	2026-05-08 00:01:27.547131
9530	2026-03-08 04:00:00	4	2.68	220	256.6	t	2026-05-08 00:01:27.547131
9531	2026-03-08 04:00:00	7	2.29	220	603.7	t	2026-05-08 00:01:27.547131
9532	2026-03-08 04:30:00	1	1.95	220	309.2	t	2026-05-08 00:01:27.547131
9533	2026-03-08 04:30:00	4	2.06	220	363.6	t	2026-05-08 00:01:27.547131
9534	2026-03-08 04:30:00	7	2.7	220	455.1	t	2026-05-08 00:01:27.547131
9535	2026-03-08 05:00:00	1	1.21	220	643.5	t	2026-05-08 00:01:27.547131
9536	2026-03-08 05:00:00	4	2.08	220	608.5	t	2026-05-08 00:01:27.547131
9537	2026-03-08 05:00:00	7	1.22	220	308	t	2026-05-08 00:01:27.547131
9538	2026-03-08 05:30:00	1	1.69	220	359.9	t	2026-05-08 00:01:27.547131
9539	2026-03-08 05:30:00	4	1.44	220	386.1	t	2026-05-08 00:01:27.547131
9540	2026-03-08 05:30:00	7	2.71	220	420.8	t	2026-05-08 00:01:27.547131
9541	2026-03-08 06:00:00	1	1.06	220	491.7	t	2026-05-08 00:01:27.547131
9542	2026-03-08 06:00:00	4	1.05	220	302.3	t	2026-05-08 00:01:27.547131
9543	2026-03-08 06:00:00	7	1.82	220	324.7	t	2026-05-08 00:01:27.547131
9544	2026-03-08 06:30:00	1	1.83	220	226.9	t	2026-05-08 00:01:27.547131
9545	2026-03-08 06:30:00	4	2.96	220	465.7	t	2026-05-08 00:01:27.547131
9546	2026-03-08 06:30:00	7	1.01	220	563.9	t	2026-05-08 00:01:27.547131
9547	2026-03-08 07:00:00	1	2.58	220	358.8	t	2026-05-08 00:01:27.547131
9548	2026-03-08 07:00:00	4	2.86	220	358.2	t	2026-05-08 00:01:27.547131
9549	2026-03-08 07:00:00	7	2.59	220	377.7	t	2026-05-08 00:01:27.547131
9550	2026-03-08 07:30:00	1	1.9	220	497.7	t	2026-05-08 00:01:27.547131
9551	2026-03-08 07:30:00	4	1.95	220	528.4	t	2026-05-08 00:01:27.547131
9552	2026-03-08 07:30:00	7	2.95	220	535.5	t	2026-05-08 00:01:27.547131
9553	2026-03-08 08:00:00	1	2.34	220	316.5	t	2026-05-08 00:01:27.547131
9554	2026-03-08 08:00:00	4	2.46	220	316.1	t	2026-05-08 00:01:27.547131
9555	2026-03-08 08:00:00	7	1.34	220	659.6	t	2026-05-08 00:01:27.547131
9556	2026-03-08 08:30:00	1	1.03	220	301.8	t	2026-05-08 00:01:27.547131
9557	2026-03-08 08:30:00	4	1.03	220	522.6	t	2026-05-08 00:01:27.547131
9558	2026-03-08 08:30:00	7	2.9	220	294.9	t	2026-05-08 00:01:27.547131
9559	2026-03-08 09:00:00	1	2.4	220	243.4	t	2026-05-08 00:01:27.547131
9560	2026-03-08 09:00:00	4	2.16	220	390.4	t	2026-05-08 00:01:27.547131
9561	2026-03-08 09:00:00	7	1.84	220	386.8	t	2026-05-08 00:01:27.547131
9562	2026-03-08 09:30:00	1	1.84	220	223.5	t	2026-05-08 00:01:27.547131
9563	2026-03-08 09:30:00	4	2.42	220	289.8	t	2026-05-08 00:01:27.547131
9564	2026-03-08 09:30:00	7	2.51	220	242.2	t	2026-05-08 00:01:27.547131
9565	2026-03-08 10:00:00	1	2.25	220	636.8	t	2026-05-08 00:01:27.547131
9566	2026-03-08 10:00:00	4	2.41	220	460.7	t	2026-05-08 00:01:27.547131
9567	2026-03-08 10:00:00	7	2.83	220	221.3	t	2026-05-08 00:01:27.547131
9568	2026-03-08 10:30:00	1	2.76	220	286.4	t	2026-05-08 00:01:27.547131
9569	2026-03-08 10:30:00	4	2.18	220	460.7	t	2026-05-08 00:01:27.547131
9570	2026-03-08 10:30:00	7	2.15	220	391.3	t	2026-05-08 00:01:27.547131
9571	2026-03-08 11:00:00	1	1.78	220	346.6	t	2026-05-08 00:01:27.547131
9572	2026-03-08 11:00:00	4	2.86	220	380	t	2026-05-08 00:01:27.547131
9573	2026-03-08 11:00:00	7	1.62	220	478.9	t	2026-05-08 00:01:27.547131
9574	2026-03-08 11:30:00	1	1.45	220	574.3	t	2026-05-08 00:01:27.547131
9575	2026-03-08 11:30:00	4	1.06	220	370.8	t	2026-05-08 00:01:27.547131
9576	2026-03-08 11:30:00	7	2.45	220	475	t	2026-05-08 00:01:27.547131
9577	2026-03-08 12:00:00	1	1.83	220	638.9	t	2026-05-08 00:01:27.547131
9578	2026-03-08 12:00:00	4	2.03	220	343.1	t	2026-05-08 00:01:27.547131
9579	2026-03-08 12:00:00	7	1	220	293.1	t	2026-05-08 00:01:27.547131
9580	2026-03-08 12:30:00	1	2.41	220	504.3	t	2026-05-08 00:01:27.547131
9581	2026-03-08 12:30:00	4	2.35	220	359	t	2026-05-08 00:01:27.547131
9582	2026-03-08 12:30:00	7	1.57	220	645.5	t	2026-05-08 00:01:27.547131
9583	2026-03-08 13:00:00	1	1.09	220	639.5	t	2026-05-08 00:01:27.547131
9584	2026-03-08 13:00:00	4	1.85	220	497.3	t	2026-05-08 00:01:27.547131
9585	2026-03-08 13:00:00	7	1.04	220	646.8	t	2026-05-08 00:01:27.547131
9586	2026-03-08 13:30:00	1	3	220	483.9	t	2026-05-08 00:01:27.547131
9587	2026-03-08 13:30:00	4	2.36	220	578.2	t	2026-05-08 00:01:27.547131
9588	2026-03-08 13:30:00	7	1.84	220	566.7	t	2026-05-08 00:01:27.547131
9589	2026-03-08 14:00:00	1	1.06	220	639.5	t	2026-05-08 00:01:27.547131
9590	2026-03-08 14:00:00	4	1.55	220	648.2	t	2026-05-08 00:01:27.547131
9591	2026-03-08 14:00:00	7	1.18	220	292.7	t	2026-05-08 00:01:27.547131
9592	2026-03-08 14:30:00	1	2.65	220	332.3	t	2026-05-08 00:01:27.547131
9593	2026-03-08 14:30:00	4	1.65	220	284.3	t	2026-05-08 00:01:27.547131
9594	2026-03-08 14:30:00	7	1.98	220	384.2	t	2026-05-08 00:01:27.547131
9595	2026-03-08 15:00:00	1	2.27	220	287.9	t	2026-05-08 00:01:27.547131
9596	2026-03-08 15:00:00	4	2.84	220	417.1	t	2026-05-08 00:01:27.547131
9597	2026-03-08 15:00:00	7	2.63	220	513.5	t	2026-05-08 00:01:27.547131
9598	2026-03-08 15:30:00	1	1.61	220	246	t	2026-05-08 00:01:27.547131
9599	2026-03-08 15:30:00	4	1.6	220	463	t	2026-05-08 00:01:27.547131
9600	2026-03-08 15:30:00	7	1.71	220	241.6	t	2026-05-08 00:01:27.547131
9601	2026-03-08 16:00:00	1	1.77	220	360.3	t	2026-05-08 00:01:27.547131
9602	2026-03-08 16:00:00	4	1.28	220	336.9	t	2026-05-08 00:01:27.547131
9603	2026-03-08 16:00:00	7	2.91	220	464.1	t	2026-05-08 00:01:27.547131
9604	2026-03-08 16:30:00	1	2	220	270.4	t	2026-05-08 00:01:27.547131
9605	2026-03-08 16:30:00	4	1.88	220	424.4	t	2026-05-08 00:01:27.547131
9606	2026-03-08 16:30:00	7	1.16	220	344.1	t	2026-05-08 00:01:27.547131
9607	2026-03-08 17:00:00	1	2.38	220	594.2	t	2026-05-08 00:01:27.547131
9608	2026-03-08 17:00:00	4	2.64	220	448.5	t	2026-05-08 00:01:27.547131
9609	2026-03-08 17:00:00	7	1.55	220	469.4	t	2026-05-08 00:01:27.547131
9610	2026-03-08 17:30:00	1	2.96	220	526.2	t	2026-05-08 00:01:27.547131
9611	2026-03-08 17:30:00	4	1.76	220	317.6	t	2026-05-08 00:01:27.547131
9612	2026-03-08 17:30:00	7	1.03	220	559.9	t	2026-05-08 00:01:27.547131
9613	2026-03-08 18:00:00	1	1.38	220	254.2	t	2026-05-08 00:01:27.547131
9614	2026-03-08 18:00:00	4	2.49	220	456.7	t	2026-05-08 00:01:27.547131
9615	2026-03-08 18:00:00	7	1.45	220	410.5	t	2026-05-08 00:01:27.547131
9616	2026-03-08 18:30:00	1	2.83	220	525.6	t	2026-05-08 00:01:27.547131
9617	2026-03-08 18:30:00	4	1.14	220	297.1	t	2026-05-08 00:01:27.547131
9618	2026-03-08 18:30:00	7	2.14	220	248.7	t	2026-05-08 00:01:27.547131
9619	2026-03-08 19:00:00	1	2.37	220	345.1	t	2026-05-08 00:01:27.547131
9620	2026-03-08 19:00:00	4	1.83	220	658.7	t	2026-05-08 00:01:27.547131
9621	2026-03-08 19:00:00	7	2.36	220	459.7	t	2026-05-08 00:01:27.547131
9622	2026-03-08 19:30:00	1	2.78	220	658.1	t	2026-05-08 00:01:27.547131
9623	2026-03-08 19:30:00	4	1.41	220	225.5	t	2026-05-08 00:01:27.547131
9624	2026-03-08 19:30:00	7	2.97	220	398.6	t	2026-05-08 00:01:27.547131
9625	2026-03-08 20:00:00	1	2.66	220	621.3	t	2026-05-08 00:01:27.547131
9626	2026-03-08 20:00:00	4	2.1	220	287.3	t	2026-05-08 00:01:27.547131
9627	2026-03-08 20:00:00	7	2.82	220	221.1	t	2026-05-08 00:01:27.547131
9628	2026-03-08 20:30:00	1	1.66	220	471.5	t	2026-05-08 00:01:27.547131
9629	2026-03-08 20:30:00	4	1.23	220	284.2	t	2026-05-08 00:01:27.547131
9630	2026-03-08 20:30:00	7	2.94	220	358	t	2026-05-08 00:01:27.547131
9631	2026-03-08 21:00:00	1	1.34	220	332	t	2026-05-08 00:01:27.547131
9632	2026-03-08 21:00:00	4	2.94	220	628.3	t	2026-05-08 00:01:27.547131
9633	2026-03-08 21:00:00	7	2.06	220	342	t	2026-05-08 00:01:27.547131
9634	2026-03-08 21:30:00	1	2.46	220	518.6	t	2026-05-08 00:01:27.547131
9635	2026-03-08 21:30:00	4	1.17	220	464.4	t	2026-05-08 00:01:27.547131
9636	2026-03-08 21:30:00	7	2.36	220	341.9	t	2026-05-08 00:01:27.547131
9637	2026-03-08 22:00:00	1	1.47	220	617.4	t	2026-05-08 00:01:27.547131
9638	2026-03-08 22:00:00	4	2.04	220	235.2	t	2026-05-08 00:01:27.547131
9639	2026-03-08 22:00:00	7	2.52	220	280.4	t	2026-05-08 00:01:27.547131
9640	2026-03-08 22:30:00	1	2.4	220	635.9	t	2026-05-08 00:01:27.547131
9641	2026-03-08 22:30:00	4	1.41	220	653.5	t	2026-05-08 00:01:27.547131
9642	2026-03-08 22:30:00	7	1.7	220	526	t	2026-05-08 00:01:27.547131
9643	2026-03-08 23:00:00	1	1.16	220	627.4	t	2026-05-08 00:01:27.547131
9644	2026-03-08 23:00:00	4	2	220	258	t	2026-05-08 00:01:27.547131
9645	2026-03-08 23:00:00	7	2.21	220	601.2	t	2026-05-08 00:01:27.547131
9646	2026-03-08 23:30:00	1	1.44	220	442.5	t	2026-05-08 00:01:27.547131
9647	2026-03-08 23:30:00	4	2.13	220	425.3	t	2026-05-08 00:01:27.547131
9648	2026-03-08 23:30:00	7	2.64	220	605.8	t	2026-05-08 00:01:27.547131
9649	2026-03-09 00:00:00	1	2.2	220	618.9	t	2026-05-08 00:01:27.547131
9650	2026-03-09 00:00:00	4	1.57	220	789.5	t	2026-05-08 00:01:27.547131
9651	2026-03-09 00:00:00	7	2.3	220	621.5	t	2026-05-08 00:01:27.547131
9652	2026-03-09 00:30:00	1	2.17	220	410.4	t	2026-05-08 00:01:27.547131
9653	2026-03-09 00:30:00	4	1.57	220	332.1	t	2026-05-08 00:01:27.547131
9654	2026-03-09 00:30:00	7	3.01	220	331.2	t	2026-05-08 00:01:27.547131
9655	2026-03-09 01:00:00	1	2.35	220	797.8	t	2026-05-08 00:01:27.547131
9656	2026-03-09 01:00:00	4	3.64	220	664.2	t	2026-05-08 00:01:27.547131
9657	2026-03-09 01:00:00	7	1.54	220	739	t	2026-05-08 00:01:27.547131
9658	2026-03-09 01:30:00	1	1.36	220	313	t	2026-05-08 00:01:27.547131
9659	2026-03-09 01:30:00	4	3.65	220	539.8	t	2026-05-08 00:01:27.547131
9660	2026-03-09 01:30:00	7	1.54	220	412.7	t	2026-05-08 00:01:27.547131
9661	2026-03-09 02:00:00	1	3.27	220	562.6	t	2026-05-08 00:01:27.547131
9662	2026-03-09 02:00:00	4	1.65	220	304.9	t	2026-05-08 00:01:27.547131
9663	2026-03-09 02:00:00	7	2.69	220	513.1	t	2026-05-08 00:01:27.547131
9664	2026-03-09 02:30:00	1	2.05	220	271	t	2026-05-08 00:01:27.547131
9665	2026-03-09 02:30:00	4	1.8	220	649.4	t	2026-05-08 00:01:27.547131
9666	2026-03-09 02:30:00	7	2.31	220	493.9	t	2026-05-08 00:01:27.547131
9667	2026-03-09 03:00:00	1	3.65	220	696.4	t	2026-05-08 00:01:27.547131
9668	2026-03-09 03:00:00	4	2.15	220	740.6	t	2026-05-08 00:01:27.547131
9669	2026-03-09 03:00:00	7	2.91	220	673.6	t	2026-05-08 00:01:27.547131
9670	2026-03-09 03:30:00	1	2.09	220	634	t	2026-05-08 00:01:27.547131
9671	2026-03-09 03:30:00	4	2.26	220	699.1	t	2026-05-08 00:01:27.547131
9672	2026-03-09 03:30:00	7	3.35	220	300	t	2026-05-08 00:01:27.547131
9673	2026-03-09 04:00:00	1	1.39	220	457.2	t	2026-05-08 00:01:27.547131
9674	2026-03-09 04:00:00	4	1.86	220	395.6	t	2026-05-08 00:01:27.547131
9675	2026-03-09 04:00:00	7	3.26	220	546.9	t	2026-05-08 00:01:27.547131
9676	2026-03-09 04:30:00	1	3.36	220	518.1	t	2026-05-08 00:01:27.547131
9677	2026-03-09 04:30:00	4	3.18	220	717	t	2026-05-08 00:01:27.547131
9678	2026-03-09 04:30:00	7	2.66	220	400.2	t	2026-05-08 00:01:27.547131
9679	2026-03-09 05:00:00	1	2.74	220	272.9	t	2026-05-08 00:01:27.547131
9680	2026-03-09 05:00:00	4	1.81	220	283	t	2026-05-08 00:01:27.547131
9681	2026-03-09 05:00:00	7	3	220	561.2	t	2026-05-08 00:01:27.547131
9682	2026-03-09 05:30:00	1	2.93	220	766	t	2026-05-08 00:01:27.547131
9683	2026-03-09 05:30:00	4	1.7	220	623.7	t	2026-05-08 00:01:27.547131
9684	2026-03-09 05:30:00	7	1.56	220	337.3	t	2026-05-08 00:01:27.547131
9685	2026-03-09 06:00:00	1	2.22	220	636.9	t	2026-05-08 00:01:27.547131
9686	2026-03-09 06:00:00	4	2.47	220	732.1	t	2026-05-08 00:01:27.547131
9687	2026-03-09 06:00:00	7	1.99	220	612.3	t	2026-05-08 00:01:27.547131
9688	2026-03-09 06:30:00	1	2.97	220	515.6	t	2026-05-08 00:01:27.547131
9689	2026-03-09 06:30:00	4	3.05	220	334.2	t	2026-05-08 00:01:27.547131
9690	2026-03-09 06:30:00	7	2.85	220	529.8	t	2026-05-08 00:01:27.547131
9691	2026-03-09 07:00:00	1	18.22	220	3299.8	t	2026-05-08 00:01:27.547131
9692	2026-03-09 07:00:00	4	20.2	220	3855.1	t	2026-05-08 00:01:27.547131
9693	2026-03-09 07:00:00	7	28.14	220	6031.4	t	2026-05-08 00:01:27.547131
9694	2026-03-09 07:30:00	1	20.29	220	4397.3	t	2026-05-08 00:01:27.547131
9695	2026-03-09 07:30:00	4	20.49	220	4209.4	t	2026-05-08 00:01:27.547131
9696	2026-03-09 07:30:00	7	27.86	220	6533	t	2026-05-08 00:01:27.547131
9697	2026-03-09 08:00:00	1	21.39	220	3507.2	t	2026-05-08 00:01:27.547131
9698	2026-03-09 08:00:00	4	25.09	220	4278.7	t	2026-05-08 00:01:27.547131
9699	2026-03-09 08:00:00	7	28.29	220	5629.7	t	2026-05-08 00:01:27.547131
9700	2026-03-09 08:30:00	1	20.52	220	3074.6	t	2026-05-08 00:01:27.547131
9701	2026-03-09 08:30:00	4	25.33	220	5582.7	t	2026-05-08 00:01:27.547131
9702	2026-03-09 08:30:00	7	25.17	220	6130.1	t	2026-05-08 00:01:27.547131
9703	2026-03-09 09:00:00	1	16.74	220	3437.2	t	2026-05-08 00:01:27.547131
9704	2026-03-09 09:00:00	4	16.26	220	5138.3	t	2026-05-08 00:01:27.547131
9705	2026-03-09 09:00:00	7	27.49	220	5475.1	t	2026-05-08 00:01:27.547131
9706	2026-03-09 09:30:00	1	13.05	220	3315.4	t	2026-05-08 00:01:27.547131
9707	2026-03-09 09:30:00	4	25.6	220	4581.9	t	2026-05-08 00:01:27.547131
9708	2026-03-09 09:30:00	7	22.7	220	4730	t	2026-05-08 00:01:27.547131
9709	2026-03-09 10:00:00	1	14.5	220	4032.6	t	2026-05-08 00:01:27.547131
9710	2026-03-09 10:00:00	4	25.44	220	4383.4	t	2026-05-08 00:01:27.547131
9711	2026-03-09 10:00:00	7	26.91	220	5070	t	2026-05-08 00:01:27.547131
9712	2026-03-09 10:30:00	1	15.9	220	3966.1	t	2026-05-08 00:01:27.547131
9713	2026-03-09 10:30:00	4	21.72	220	5200.3	t	2026-05-08 00:01:27.547131
9714	2026-03-09 10:30:00	7	28.52	220	4592.1	t	2026-05-08 00:01:27.547131
9715	2026-03-09 11:00:00	1	13.99	220	2810.1	t	2026-05-08 00:01:27.547131
9716	2026-03-09 11:00:00	4	25.87	220	4390.8	t	2026-05-08 00:01:27.547131
9717	2026-03-09 11:00:00	7	22.59	220	5998.1	t	2026-05-08 00:01:27.547131
9718	2026-03-09 11:30:00	1	15.27	220	3022.3	t	2026-05-08 00:01:27.547131
9719	2026-03-09 11:30:00	4	19.11	220	5345.4	t	2026-05-08 00:01:27.547131
9720	2026-03-09 11:30:00	7	26.13	220	4812.8	t	2026-05-08 00:01:27.547131
9721	2026-03-09 12:00:00	1	18.62	220	4333.3	t	2026-05-08 00:01:27.547131
9722	2026-03-09 12:00:00	4	18.39	220	5470.3	t	2026-05-08 00:01:27.547131
9723	2026-03-09 12:00:00	7	26.85	220	4701.6	t	2026-05-08 00:01:27.547131
9724	2026-03-09 12:30:00	1	15.32	220	4002.9	t	2026-05-08 00:01:27.547131
9725	2026-03-09 12:30:00	4	19.96	220	4604.9	t	2026-05-08 00:01:27.547131
9726	2026-03-09 12:30:00	7	25.19	220	6088.6	t	2026-05-08 00:01:27.547131
9727	2026-03-09 13:00:00	1	18.68	220	4448.7	t	2026-05-08 00:01:27.547131
9728	2026-03-09 13:00:00	4	21.8	220	3991	t	2026-05-08 00:01:27.547131
9729	2026-03-09 13:00:00	7	26.18	220	4691.9	t	2026-05-08 00:01:27.547131
9730	2026-03-09 13:30:00	1	20.09	220	2680.6	t	2026-05-08 00:01:27.547131
9731	2026-03-09 13:30:00	4	16.28	220	5091.3	t	2026-05-08 00:01:27.547131
9732	2026-03-09 13:30:00	7	20.77	220	5891.3	t	2026-05-08 00:01:27.547131
9733	2026-03-09 14:00:00	1	13.02	220	3719	t	2026-05-08 00:01:27.547131
9734	2026-03-09 14:00:00	4	25.85	220	3914.8	t	2026-05-08 00:01:27.547131
9735	2026-03-09 14:00:00	7	27.97	220	4902.5	t	2026-05-08 00:01:27.547131
9736	2026-03-09 14:30:00	1	12.04	220	4674.6	t	2026-05-08 00:01:27.547131
9737	2026-03-09 14:30:00	4	16.74	220	5633.8	t	2026-05-08 00:01:27.547131
9738	2026-03-09 14:30:00	7	30.06	220	6669	t	2026-05-08 00:01:27.547131
9739	2026-03-09 15:00:00	1	16.35	220	4637.1	t	2026-05-08 00:01:27.547131
9740	2026-03-09 15:00:00	4	23.59	220	3943	t	2026-05-08 00:01:27.547131
9741	2026-03-09 15:00:00	7	25.48	220	5124	t	2026-05-08 00:01:27.547131
9742	2026-03-09 15:30:00	1	14.42	220	4353.9	t	2026-05-08 00:01:27.547131
9743	2026-03-09 15:30:00	4	25.6	220	3544.3	t	2026-05-08 00:01:27.547131
9744	2026-03-09 15:30:00	7	25.88	220	4555.1	t	2026-05-08 00:01:27.547131
9745	2026-03-09 16:00:00	1	19.25	220	2714.7	t	2026-05-08 00:01:27.547131
9746	2026-03-09 16:00:00	4	16.84	220	4269.7	t	2026-05-08 00:01:27.547131
9747	2026-03-09 16:00:00	7	22.62	220	5234.9	t	2026-05-08 00:01:27.547131
9748	2026-03-09 16:30:00	1	12.61	220	4287.2	t	2026-05-08 00:01:27.547131
9749	2026-03-09 16:30:00	4	17.55	220	5394	t	2026-05-08 00:01:27.547131
9750	2026-03-09 16:30:00	7	25.01	220	4946.2	t	2026-05-08 00:01:27.547131
9751	2026-03-09 17:00:00	1	13.12	220	3742.9	t	2026-05-08 00:01:27.547131
9752	2026-03-09 17:00:00	4	25.76	220	4104.8	t	2026-05-08 00:01:27.547131
9753	2026-03-09 17:00:00	7	20.93	220	6259.4	t	2026-05-08 00:01:27.547131
9754	2026-03-09 17:30:00	1	18.07	220	2963.7	t	2026-05-08 00:01:27.547131
9755	2026-03-09 17:30:00	4	22.33	220	5021.7	t	2026-05-08 00:01:27.547131
9756	2026-03-09 17:30:00	7	28.54	220	5681.9	t	2026-05-08 00:01:27.547131
9757	2026-03-09 18:00:00	1	20.02	220	4605.1	t	2026-05-08 00:01:27.547131
9758	2026-03-09 18:00:00	4	24.19	220	5038.1	t	2026-05-08 00:01:27.547131
9759	2026-03-09 18:00:00	7	22.19	220	6644.6	t	2026-05-08 00:01:27.547131
9760	2026-03-09 18:30:00	1	16.52	220	3283.2	t	2026-05-08 00:01:27.547131
9761	2026-03-09 18:30:00	4	21.57	220	3925.9	t	2026-05-08 00:01:27.547131
9762	2026-03-09 18:30:00	7	21.87	220	4869.1	t	2026-05-08 00:01:27.547131
9763	2026-03-09 19:00:00	1	20.13	220	3013.9	t	2026-05-08 00:01:27.547131
9764	2026-03-09 19:00:00	4	17.13	220	3848	t	2026-05-08 00:01:27.547131
9765	2026-03-09 19:00:00	7	25.75	220	4809.9	t	2026-05-08 00:01:27.547131
9766	2026-03-09 19:30:00	1	13.07	220	3755.4	t	2026-05-08 00:01:27.547131
9767	2026-03-09 19:30:00	4	24.72	220	3695.4	t	2026-05-08 00:01:27.547131
9768	2026-03-09 19:30:00	7	25.85	220	6484.8	t	2026-05-08 00:01:27.547131
9769	2026-03-09 20:00:00	1	3.3	220	401.4	t	2026-05-08 00:01:27.547131
9770	2026-03-09 20:00:00	4	3.59	220	523.8	t	2026-05-08 00:01:27.547131
9771	2026-03-09 20:00:00	7	2.5	220	751.6	t	2026-05-08 00:01:27.547131
9772	2026-03-09 20:30:00	1	1.59	220	725.6	t	2026-05-08 00:01:27.547131
9773	2026-03-09 20:30:00	4	2.23	220	299.5	t	2026-05-08 00:01:27.547131
9774	2026-03-09 20:30:00	7	1.48	220	568.6	t	2026-05-08 00:01:27.547131
9775	2026-03-09 21:00:00	1	2.31	220	554.5	t	2026-05-08 00:01:27.547131
9776	2026-03-09 21:00:00	4	3.26	220	482.7	t	2026-05-08 00:01:27.547131
9777	2026-03-09 21:00:00	7	1.72	220	309.7	t	2026-05-08 00:01:27.547131
9778	2026-03-09 21:30:00	1	3.67	220	386.1	t	2026-05-08 00:01:27.547131
9779	2026-03-09 21:30:00	4	2.65	220	526.4	t	2026-05-08 00:01:27.547131
9780	2026-03-09 21:30:00	7	1.42	220	432.2	t	2026-05-08 00:01:27.547131
9781	2026-03-09 22:00:00	1	2.85	220	658.7	t	2026-05-08 00:01:27.547131
9782	2026-03-09 22:00:00	4	3.35	220	466.7	t	2026-05-08 00:01:27.547131
9783	2026-03-09 22:00:00	7	1.96	220	312.1	t	2026-05-08 00:01:27.547131
9784	2026-03-09 22:30:00	1	2.67	220	710	t	2026-05-08 00:01:27.547131
9785	2026-03-09 22:30:00	4	1.53	220	603.7	t	2026-05-08 00:01:27.547131
9786	2026-03-09 22:30:00	7	1.29	220	608.4	t	2026-05-08 00:01:27.547131
9787	2026-03-09 23:00:00	1	1.97	220	427.5	t	2026-05-08 00:01:27.547131
9788	2026-03-09 23:00:00	4	2.98	220	610.5	t	2026-05-08 00:01:27.547131
9789	2026-03-09 23:00:00	7	2.16	220	690.8	t	2026-05-08 00:01:27.547131
9790	2026-03-09 23:30:00	1	1.41	220	734.9	t	2026-05-08 00:01:27.547131
9791	2026-03-09 23:30:00	4	2.53	220	647.1	t	2026-05-08 00:01:27.547131
9792	2026-03-09 23:30:00	7	1.37	220	727	t	2026-05-08 00:01:27.547131
9793	2026-03-10 00:00:00	1	3.57	220	271.7	t	2026-05-08 00:01:27.547131
9794	2026-03-10 00:00:00	4	3.4	220	492.8	t	2026-05-08 00:01:27.547131
9795	2026-03-10 00:00:00	7	1.7	220	336.4	t	2026-05-08 00:01:27.547131
9796	2026-03-10 00:30:00	1	2.67	220	442.4	t	2026-05-08 00:01:27.547131
9797	2026-03-10 00:30:00	4	3.57	220	805.3	t	2026-05-08 00:01:27.547131
9798	2026-03-10 00:30:00	7	3.68	220	504.3	t	2026-05-08 00:01:27.547131
9799	2026-03-10 01:00:00	1	1.34	220	477.9	t	2026-05-08 00:01:27.547131
9800	2026-03-10 01:00:00	4	2.47	220	535.7	t	2026-05-08 00:01:27.547131
9801	2026-03-10 01:00:00	7	1.6	220	770.9	t	2026-05-08 00:01:27.547131
9802	2026-03-10 01:30:00	1	3.19	220	468.6	t	2026-05-08 00:01:27.547131
9803	2026-03-10 01:30:00	4	3.64	220	515.3	t	2026-05-08 00:01:27.547131
9804	2026-03-10 01:30:00	7	2.53	220	428.2	t	2026-05-08 00:01:27.547131
9805	2026-03-10 02:00:00	1	2.23	220	677.1	t	2026-05-08 00:01:27.547131
9806	2026-03-10 02:00:00	4	1.89	220	636.4	t	2026-05-08 00:01:27.547131
9807	2026-03-10 02:00:00	7	2.45	220	286	t	2026-05-08 00:01:27.547131
9808	2026-03-10 02:30:00	1	2.8	220	744.8	t	2026-05-08 00:01:27.547131
9809	2026-03-10 02:30:00	4	3.55	220	368.1	t	2026-05-08 00:01:27.547131
9810	2026-03-10 02:30:00	7	3.38	220	489.8	t	2026-05-08 00:01:27.547131
9811	2026-03-10 03:00:00	1	3.23	220	384.4	t	2026-05-08 00:01:27.547131
9812	2026-03-10 03:00:00	4	1.66	220	461	t	2026-05-08 00:01:27.547131
9813	2026-03-10 03:00:00	7	2.79	220	280.5	t	2026-05-08 00:01:27.547131
9814	2026-03-10 03:30:00	1	1.84	220	302.9	t	2026-05-08 00:01:27.547131
9815	2026-03-10 03:30:00	4	3.06	220	562.7	t	2026-05-08 00:01:27.547131
9816	2026-03-10 03:30:00	7	1.22	220	353.4	t	2026-05-08 00:01:27.547131
9817	2026-03-10 04:00:00	1	3.2	220	812.5	t	2026-05-08 00:01:27.547131
9818	2026-03-10 04:00:00	4	3.61	220	291.6	t	2026-05-08 00:01:27.547131
9819	2026-03-10 04:00:00	7	2.01	220	409.9	t	2026-05-08 00:01:27.547131
9820	2026-03-10 04:30:00	1	3.3	220	610.4	t	2026-05-08 00:01:27.547131
9821	2026-03-10 04:30:00	4	3.07	220	731	t	2026-05-08 00:01:27.547131
9822	2026-03-10 04:30:00	7	2.29	220	544.7	t	2026-05-08 00:01:27.547131
9823	2026-03-10 05:00:00	1	1.79	220	800.9	t	2026-05-08 00:01:27.547131
9824	2026-03-10 05:00:00	4	2.56	220	342.8	t	2026-05-08 00:01:27.547131
9825	2026-03-10 05:00:00	7	2.54	220	455.7	t	2026-05-08 00:01:27.547131
9826	2026-03-10 05:30:00	1	1.52	220	723.9	t	2026-05-08 00:01:27.547131
9827	2026-03-10 05:30:00	4	2.56	220	372.1	t	2026-05-08 00:01:27.547131
9828	2026-03-10 05:30:00	7	1.73	220	707.1	t	2026-05-08 00:01:27.547131
9829	2026-03-10 06:00:00	1	2.52	220	453.6	t	2026-05-08 00:01:27.547131
9830	2026-03-10 06:00:00	4	1.3	220	740.9	t	2026-05-08 00:01:27.547131
9831	2026-03-10 06:00:00	7	2.26	220	279.9	t	2026-05-08 00:01:27.547131
9832	2026-03-10 06:30:00	1	2.23	220	375	t	2026-05-08 00:01:27.547131
9833	2026-03-10 06:30:00	4	1.76	220	661.7	t	2026-05-08 00:01:27.547131
9834	2026-03-10 06:30:00	7	2.39	220	428.3	t	2026-05-08 00:01:27.547131
9835	2026-03-10 07:00:00	1	21.22	220	3735.8	t	2026-05-08 00:01:27.547131
9836	2026-03-10 07:00:00	4	20.36	220	4233.7	t	2026-05-08 00:01:27.547131
9837	2026-03-10 07:00:00	7	22.95	220	6114.9	t	2026-05-08 00:01:27.547131
9838	2026-03-10 07:30:00	1	12.64	220	4028.6	t	2026-05-08 00:01:27.547131
9839	2026-03-10 07:30:00	4	20.33	220	4198.8	t	2026-05-08 00:01:27.547131
9840	2026-03-10 07:30:00	7	22.72	220	5337.3	t	2026-05-08 00:01:27.547131
9841	2026-03-10 08:00:00	1	11.6	220	2594.9	t	2026-05-08 00:01:27.547131
9842	2026-03-10 08:00:00	4	25.06	220	3947.6	t	2026-05-08 00:01:27.547131
9843	2026-03-10 08:00:00	7	22.85	220	6032.5	t	2026-05-08 00:01:27.547131
9844	2026-03-10 08:30:00	1	16.54	220	4405.4	t	2026-05-08 00:01:27.547131
9845	2026-03-10 08:30:00	4	24.54	220	5191.6	t	2026-05-08 00:01:27.547131
9846	2026-03-10 08:30:00	7	22.49	220	4879	t	2026-05-08 00:01:27.547131
9847	2026-03-10 09:00:00	1	19.35	220	4591.4	t	2026-05-08 00:01:27.547131
9848	2026-03-10 09:00:00	4	24.67	220	5002.7	t	2026-05-08 00:01:27.547131
9849	2026-03-10 09:00:00	7	21.85	220	4899.9	t	2026-05-08 00:01:27.547131
9850	2026-03-10 09:30:00	1	12.79	220	3187.6	t	2026-05-08 00:01:27.547131
9851	2026-03-10 09:30:00	4	17.18	220	5094.9	t	2026-05-08 00:01:27.547131
9852	2026-03-10 09:30:00	7	30.03	220	6328.1	t	2026-05-08 00:01:27.547131
9853	2026-03-10 10:00:00	1	13.77	220	3120	t	2026-05-08 00:01:27.547131
9854	2026-03-10 10:00:00	4	18.94	220	3523.2	t	2026-05-08 00:01:27.547131
9855	2026-03-10 10:00:00	7	25.9	220	5525.3	t	2026-05-08 00:01:27.547131
9856	2026-03-10 10:30:00	1	12.12	220	4080.2	t	2026-05-08 00:01:27.547131
9857	2026-03-10 10:30:00	4	24.44	220	5500.1	t	2026-05-08 00:01:27.547131
9858	2026-03-10 10:30:00	7	28.27	220	5965.7	t	2026-05-08 00:01:27.547131
9859	2026-03-10 11:00:00	1	13.53	220	3868.4	t	2026-05-08 00:01:27.547131
9860	2026-03-10 11:00:00	4	25.49	220	5545.1	t	2026-05-08 00:01:27.547131
9861	2026-03-10 11:00:00	7	26.08	220	6432.7	t	2026-05-08 00:01:27.547131
9862	2026-03-10 11:30:00	1	18.4	220	2543.8	t	2026-05-08 00:01:27.547131
9863	2026-03-10 11:30:00	4	20.94	220	4112	t	2026-05-08 00:01:27.547131
9864	2026-03-10 11:30:00	7	29.24	220	6283.3	t	2026-05-08 00:01:27.547131
9865	2026-03-10 12:00:00	1	20.36	220	2906.5	t	2026-05-08 00:01:27.547131
9866	2026-03-10 12:00:00	4	24.08	220	3984.7	t	2026-05-08 00:01:27.547131
9867	2026-03-10 12:00:00	7	21.55	220	5437.5	t	2026-05-08 00:01:27.547131
9868	2026-03-10 12:30:00	1	17.24	220	3719.5	t	2026-05-08 00:01:27.547131
9869	2026-03-10 12:30:00	4	23.92	220	4101.4	t	2026-05-08 00:01:27.547131
9870	2026-03-10 12:30:00	7	23.76	220	5062.7	t	2026-05-08 00:01:27.547131
9871	2026-03-10 13:00:00	1	15.13	220	2669.9	t	2026-05-08 00:01:27.547131
9872	2026-03-10 13:00:00	4	20.56	220	3769.5	t	2026-05-08 00:01:27.547131
9873	2026-03-10 13:00:00	7	26.49	220	6060.3	t	2026-05-08 00:01:27.547131
9874	2026-03-10 13:30:00	1	16.82	220	4093.7	t	2026-05-08 00:01:27.547131
9875	2026-03-10 13:30:00	4	25.59	220	5121.6	t	2026-05-08 00:01:27.547131
9876	2026-03-10 13:30:00	7	29.79	220	5620.6	t	2026-05-08 00:01:27.547131
9877	2026-03-10 14:00:00	1	16.12	220	4583.3	t	2026-05-08 00:01:27.547131
9878	2026-03-10 14:00:00	4	22.51	220	4206.7	t	2026-05-08 00:01:27.547131
9879	2026-03-10 14:00:00	7	27.93	220	5257.5	t	2026-05-08 00:01:27.547131
9880	2026-03-10 14:30:00	1	18.76	220	4280.7	t	2026-05-08 00:01:27.547131
9881	2026-03-10 14:30:00	4	24.73	220	4592.6	t	2026-05-08 00:01:27.547131
9882	2026-03-10 14:30:00	7	20.54	220	6436.9	t	2026-05-08 00:01:27.547131
9883	2026-03-10 15:00:00	1	21.16	220	4680.1	t	2026-05-08 00:01:27.547131
9884	2026-03-10 15:00:00	4	22.3	220	4065.5	t	2026-05-08 00:01:27.547131
9885	2026-03-10 15:00:00	7	22.32	220	6562.6	t	2026-05-08 00:01:27.547131
9886	2026-03-10 15:30:00	1	15.74	220	3414.2	t	2026-05-08 00:01:27.547131
9887	2026-03-10 15:30:00	4	23.26	220	4364.6	t	2026-05-08 00:01:27.547131
9888	2026-03-10 15:30:00	7	29.47	220	6134.8	t	2026-05-08 00:01:27.547131
9889	2026-03-10 16:00:00	1	17.87	220	4688.8	t	2026-05-08 00:01:27.547131
9890	2026-03-10 16:00:00	4	24.3	220	4407.7	t	2026-05-08 00:01:27.547131
9891	2026-03-10 16:00:00	7	21.48	220	4945.9	t	2026-05-08 00:01:27.547131
9892	2026-03-10 16:30:00	1	21.21	220	4239.4	t	2026-05-08 00:01:27.547131
9893	2026-03-10 16:30:00	4	20.65	220	4181.3	t	2026-05-08 00:01:27.547131
9894	2026-03-10 16:30:00	7	25.73	220	4818.4	t	2026-05-08 00:01:27.547131
9895	2026-03-10 17:00:00	1	15.37	220	2807.3	t	2026-05-08 00:01:27.547131
9896	2026-03-10 17:00:00	4	25.79	220	4459.7	t	2026-05-08 00:01:27.547131
9897	2026-03-10 17:00:00	7	27.79	220	6266.2	t	2026-05-08 00:01:27.547131
9898	2026-03-10 17:30:00	1	21.25	220	2717.2	t	2026-05-08 00:01:27.547131
9899	2026-03-10 17:30:00	4	23.5	220	4577.8	t	2026-05-08 00:01:27.547131
9900	2026-03-10 17:30:00	7	21.8	220	5841.7	t	2026-05-08 00:01:27.547131
9901	2026-03-10 18:00:00	1	14.92	220	3593.7	t	2026-05-08 00:01:27.547131
9902	2026-03-10 18:00:00	4	24.03	220	4295.1	t	2026-05-08 00:01:27.547131
9903	2026-03-10 18:00:00	7	21.29	220	5954.9	t	2026-05-08 00:01:27.547131
9904	2026-03-10 18:30:00	1	14.11	220	3354.5	t	2026-05-08 00:01:27.547131
9905	2026-03-10 18:30:00	4	22.57	220	5456	t	2026-05-08 00:01:27.547131
9906	2026-03-10 18:30:00	7	24.29	220	6332.9	t	2026-05-08 00:01:27.547131
9907	2026-03-10 19:00:00	1	16.12	220	2834.5	t	2026-05-08 00:01:27.547131
9908	2026-03-10 19:00:00	4	21.23	220	5656.4	t	2026-05-08 00:01:27.547131
9909	2026-03-10 19:00:00	7	28.07	220	6692.6	t	2026-05-08 00:01:27.547131
9910	2026-03-10 19:30:00	1	20.59	220	4683.4	t	2026-05-08 00:01:27.547131
9911	2026-03-10 19:30:00	4	17.18	220	4745.9	t	2026-05-08 00:01:27.547131
9912	2026-03-10 19:30:00	7	28.47	220	6407.3	t	2026-05-08 00:01:27.547131
9913	2026-03-10 20:00:00	1	1.37	220	315.1	t	2026-05-08 00:01:27.547131
9914	2026-03-10 20:00:00	4	1.73	220	274.7	t	2026-05-08 00:01:27.547131
9915	2026-03-10 20:00:00	7	2.71	220	437	t	2026-05-08 00:01:27.547131
9916	2026-03-10 20:30:00	1	3.22	220	340.1	t	2026-05-08 00:01:27.547131
9917	2026-03-10 20:30:00	4	3.45	220	363.1	t	2026-05-08 00:01:27.547131
9918	2026-03-10 20:30:00	7	2.53	220	439.2	t	2026-05-08 00:01:27.547131
9919	2026-03-10 21:00:00	1	3.48	220	504.7	t	2026-05-08 00:01:27.547131
9920	2026-03-10 21:00:00	4	1.87	220	560.4	t	2026-05-08 00:01:27.547131
9921	2026-03-10 21:00:00	7	3.63	220	692.9	t	2026-05-08 00:01:27.547131
9922	2026-03-10 21:30:00	1	2.71	220	783.9	t	2026-05-08 00:01:27.547131
9923	2026-03-10 21:30:00	4	2	220	530.1	t	2026-05-08 00:01:27.547131
9924	2026-03-10 21:30:00	7	1.48	220	393.2	t	2026-05-08 00:01:27.547131
9925	2026-03-10 22:00:00	1	2.68	220	693.8	t	2026-05-08 00:01:27.547131
9926	2026-03-10 22:00:00	4	2.48	220	539.4	t	2026-05-08 00:01:27.547131
9927	2026-03-10 22:00:00	7	3.06	220	351.2	t	2026-05-08 00:01:27.547131
9928	2026-03-10 22:30:00	1	2.09	220	422.9	t	2026-05-08 00:01:27.547131
9929	2026-03-10 22:30:00	4	3.58	220	800.9	t	2026-05-08 00:01:27.547131
9930	2026-03-10 22:30:00	7	3.1	220	541.3	t	2026-05-08 00:01:27.547131
9931	2026-03-10 23:00:00	1	1.98	220	727.4	t	2026-05-08 00:01:27.547131
9932	2026-03-10 23:00:00	4	2.85	220	642	t	2026-05-08 00:01:27.547131
9933	2026-03-10 23:00:00	7	3.2	220	358.3	t	2026-05-08 00:01:27.547131
9934	2026-03-10 23:30:00	1	2.27	220	374.7	t	2026-05-08 00:01:27.547131
9935	2026-03-10 23:30:00	4	3.61	220	288.5	t	2026-05-08 00:01:27.547131
9936	2026-03-10 23:30:00	7	2.58	220	710.9	t	2026-05-08 00:01:27.547131
9937	2026-03-11 00:00:00	1	2.57	220	428.6	t	2026-05-08 00:01:27.547131
9938	2026-03-11 00:00:00	4	1.59	220	422.1	t	2026-05-08 00:01:27.547131
9939	2026-03-11 00:00:00	7	1.28	220	549.4	t	2026-05-08 00:01:27.547131
9940	2026-03-11 00:30:00	1	2.86	220	392.5	t	2026-05-08 00:01:27.547131
9941	2026-03-11 00:30:00	4	3.39	220	754.4	t	2026-05-08 00:01:27.547131
9942	2026-03-11 00:30:00	7	2.41	220	381.8	t	2026-05-08 00:01:27.547131
9943	2026-03-11 01:00:00	1	1.8	220	371.3	t	2026-05-08 00:01:27.547131
9944	2026-03-11 01:00:00	4	2.05	220	415.5	t	2026-05-08 00:01:27.547131
9945	2026-03-11 01:00:00	7	3.16	220	440.6	t	2026-05-08 00:01:27.547131
9946	2026-03-11 01:30:00	1	2.77	220	433.5	t	2026-05-08 00:01:27.547131
9947	2026-03-11 01:30:00	4	3.29	220	477.7	t	2026-05-08 00:01:27.547131
9948	2026-03-11 01:30:00	7	2.17	220	430.2	t	2026-05-08 00:01:27.547131
9949	2026-03-11 02:00:00	1	2.65	220	440.9	t	2026-05-08 00:01:27.547131
9950	2026-03-11 02:00:00	4	1.23	220	750.5	t	2026-05-08 00:01:27.547131
9951	2026-03-11 02:00:00	7	1.24	220	392.7	t	2026-05-08 00:01:27.547131
9952	2026-03-11 02:30:00	1	1.25	220	679	t	2026-05-08 00:01:27.547131
9953	2026-03-11 02:30:00	4	3.24	220	456.1	t	2026-05-08 00:01:27.547131
9954	2026-03-11 02:30:00	7	2.82	220	642.6	t	2026-05-08 00:01:27.547131
9955	2026-03-11 03:00:00	1	3.37	220	426.9	t	2026-05-08 00:01:27.547131
9956	2026-03-11 03:00:00	4	2.49	220	572.6	t	2026-05-08 00:01:27.547131
9957	2026-03-11 03:00:00	7	3.08	220	435.7	t	2026-05-08 00:01:27.547131
9958	2026-03-11 03:30:00	1	2.99	220	519.4	t	2026-05-08 00:01:27.547131
9959	2026-03-11 03:30:00	4	1.91	220	287.2	t	2026-05-08 00:01:27.547131
9960	2026-03-11 03:30:00	7	2.04	220	677.3	t	2026-05-08 00:01:27.547131
9961	2026-03-11 04:00:00	1	2.05	220	479.7	t	2026-05-08 00:01:27.547131
9962	2026-03-11 04:00:00	4	1.94	220	612.9	t	2026-05-08 00:01:27.547131
9963	2026-03-11 04:00:00	7	1.47	220	576.5	t	2026-05-08 00:01:27.547131
9964	2026-03-11 04:30:00	1	1.84	220	647	t	2026-05-08 00:01:27.547131
9965	2026-03-11 04:30:00	4	3.03	220	420.6	t	2026-05-08 00:01:27.547131
9966	2026-03-11 04:30:00	7	2.39	220	291.2	t	2026-05-08 00:01:27.547131
9967	2026-03-11 05:00:00	1	1.28	220	486.9	t	2026-05-08 00:01:27.547131
9968	2026-03-11 05:00:00	4	3.23	220	295	t	2026-05-08 00:01:27.547131
9969	2026-03-11 05:00:00	7	2.12	220	758.7	t	2026-05-08 00:01:27.547131
9970	2026-03-11 05:30:00	1	1.28	220	538	t	2026-05-08 00:01:27.547131
9971	2026-03-11 05:30:00	4	2.09	220	503.5	t	2026-05-08 00:01:27.547131
9972	2026-03-11 05:30:00	7	1.57	220	514.8	t	2026-05-08 00:01:27.547131
9973	2026-03-11 06:00:00	1	1.25	220	478.6	t	2026-05-08 00:01:27.547131
9974	2026-03-11 06:00:00	4	1.28	220	756.8	t	2026-05-08 00:01:27.547131
9975	2026-03-11 06:00:00	7	3.28	220	758.1	t	2026-05-08 00:01:27.547131
9976	2026-03-11 06:30:00	1	2.66	220	404.4	t	2026-05-08 00:01:27.547131
9977	2026-03-11 06:30:00	4	3.21	220	678	t	2026-05-08 00:01:27.547131
9978	2026-03-11 06:30:00	7	2.44	220	377.5	t	2026-05-08 00:01:27.547131
9979	2026-03-11 07:00:00	1	13.73	220	3071.3	t	2026-05-08 00:01:27.547131
9980	2026-03-11 07:00:00	4	19.12	220	3834.9	t	2026-05-08 00:01:27.547131
9981	2026-03-11 07:00:00	7	27.83	220	4541.5	t	2026-05-08 00:01:27.547131
9982	2026-03-11 07:30:00	1	14.43	220	2631.7	t	2026-05-08 00:01:27.547131
9983	2026-03-11 07:30:00	4	21.63	220	4191.3	t	2026-05-08 00:01:27.547131
9984	2026-03-11 07:30:00	7	22.78	220	6313.9	t	2026-05-08 00:01:27.547131
9985	2026-03-11 08:00:00	1	17.35	220	3022	t	2026-05-08 00:01:27.547131
9986	2026-03-11 08:00:00	4	17.69	220	3573.3	t	2026-05-08 00:01:27.547131
9987	2026-03-11 08:00:00	7	27.53	220	6599.8	t	2026-05-08 00:01:27.547131
9988	2026-03-11 08:30:00	1	19.04	220	4311	t	2026-05-08 00:01:27.547131
9989	2026-03-11 08:30:00	4	18.21	220	3619.3	t	2026-05-08 00:01:27.547131
9990	2026-03-11 08:30:00	7	28.02	220	5945.2	t	2026-05-08 00:01:27.547131
9991	2026-03-11 09:00:00	1	19.51	220	2574.2	t	2026-05-08 00:01:27.547131
9992	2026-03-11 09:00:00	4	18.22	220	5493.1	t	2026-05-08 00:01:27.547131
9993	2026-03-11 09:00:00	7	28.33	220	6154.5	t	2026-05-08 00:01:27.547131
9994	2026-03-11 09:30:00	1	18.69	220	2763.1	t	2026-05-08 00:01:27.547131
9995	2026-03-11 09:30:00	4	24.05	220	4413.2	t	2026-05-08 00:01:27.547131
9996	2026-03-11 09:30:00	7	22.57	220	6122.6	t	2026-05-08 00:01:27.547131
9997	2026-03-11 10:00:00	1	13.99	220	2655	t	2026-05-08 00:01:27.547131
9998	2026-03-11 10:00:00	4	19.82	220	4970	t	2026-05-08 00:01:27.547131
9999	2026-03-11 10:00:00	7	24.21	220	6269.5	t	2026-05-08 00:01:27.547131
10000	2026-03-11 10:30:00	1	12.57	220	2759	t	2026-05-08 00:01:27.547131
10001	2026-03-11 10:30:00	4	18.93	220	5535.4	t	2026-05-08 00:01:27.547131
10002	2026-03-11 10:30:00	7	24.12	220	4660.1	t	2026-05-08 00:01:27.547131
10003	2026-03-11 11:00:00	1	17.69	220	3251.7	t	2026-05-08 00:01:27.547131
10004	2026-03-11 11:00:00	4	24.75	220	4265.9	t	2026-05-08 00:01:27.547131
10005	2026-03-11 11:00:00	7	27.48	220	5719.1	t	2026-05-08 00:01:27.547131
10006	2026-03-11 11:30:00	1	15.5	220	3738.7	t	2026-05-08 00:01:27.547131
10007	2026-03-11 11:30:00	4	24.57	220	4214.9	t	2026-05-08 00:01:27.547131
10008	2026-03-11 11:30:00	7	25.39	220	5746.7	t	2026-05-08 00:01:27.547131
10009	2026-03-11 12:00:00	1	14.01	220	3820.6	t	2026-05-08 00:01:27.547131
10010	2026-03-11 12:00:00	4	24.85	220	4035.5	t	2026-05-08 00:01:27.547131
10011	2026-03-11 12:00:00	7	30.1	220	6047.1	t	2026-05-08 00:01:27.547131
10012	2026-03-11 12:30:00	1	19.31	220	3457.1	t	2026-05-08 00:01:27.547131
10013	2026-03-11 12:30:00	4	24.55	220	3967.6	t	2026-05-08 00:01:27.547131
10014	2026-03-11 12:30:00	7	27.4	220	5586.1	t	2026-05-08 00:01:27.547131
10015	2026-03-11 13:00:00	1	15.36	220	4383.2	t	2026-05-08 00:01:27.547131
10016	2026-03-11 13:00:00	4	18.6	220	5484.8	t	2026-05-08 00:01:27.547131
10017	2026-03-11 13:00:00	7	21.78	220	6430.7	t	2026-05-08 00:01:27.547131
10018	2026-03-11 13:30:00	1	18.64	220	3081.6	t	2026-05-08 00:01:27.547131
10019	2026-03-11 13:30:00	4	19.07	220	5060.4	t	2026-05-08 00:01:27.547131
10020	2026-03-11 13:30:00	7	22.49	220	6118.6	t	2026-05-08 00:01:27.547131
10021	2026-03-11 14:00:00	1	19.75	220	3012.3	t	2026-05-08 00:01:27.547131
10022	2026-03-11 14:00:00	4	17.91	220	5013.2	t	2026-05-08 00:01:27.547131
10023	2026-03-11 14:00:00	7	25.6	220	4923.3	t	2026-05-08 00:01:27.547131
10024	2026-03-11 14:30:00	1	14.44	220	3075.1	t	2026-05-08 00:01:27.547131
10025	2026-03-11 14:30:00	4	25.16	220	3820.9	t	2026-05-08 00:01:27.547131
10026	2026-03-11 14:30:00	7	26.73	220	5114.4	t	2026-05-08 00:01:27.547131
10027	2026-03-11 15:00:00	1	20.47	220	2539.4	t	2026-05-08 00:01:27.547131
10028	2026-03-11 15:00:00	4	22.63	220	3694.2	t	2026-05-08 00:01:27.547131
10029	2026-03-11 15:00:00	7	30.05	220	6531.1	t	2026-05-08 00:01:27.547131
10030	2026-03-11 15:30:00	1	18.93	220	2882.4	t	2026-05-08 00:01:27.547131
10031	2026-03-11 15:30:00	4	18.04	220	4009.2	t	2026-05-08 00:01:27.547131
10032	2026-03-11 15:30:00	7	24.44	220	6362.7	t	2026-05-08 00:01:27.547131
10033	2026-03-11 16:00:00	1	20.62	220	4650.2	t	2026-05-08 00:01:27.547131
10034	2026-03-11 16:00:00	4	23.36	220	3557.4	t	2026-05-08 00:01:27.547131
10035	2026-03-11 16:00:00	7	25.98	220	6559.2	t	2026-05-08 00:01:27.547131
10036	2026-03-11 16:30:00	1	15.78	220	3447.8	t	2026-05-08 00:01:27.547131
10037	2026-03-11 16:30:00	4	19.82	220	5348.4	t	2026-05-08 00:01:27.547131
10038	2026-03-11 16:30:00	7	27.99	220	5053.1	t	2026-05-08 00:01:27.547131
10039	2026-03-11 17:00:00	1	20.97	220	3692.2	t	2026-05-08 00:01:27.547131
10040	2026-03-11 17:00:00	4	22.81	220	4113.6	t	2026-05-08 00:01:27.547131
10041	2026-03-11 17:00:00	7	20.7	220	5546.9	t	2026-05-08 00:01:27.547131
10042	2026-03-11 17:30:00	1	15.13	220	3630.5	t	2026-05-08 00:01:27.547131
10043	2026-03-11 17:30:00	4	20.08	220	5579.4	t	2026-05-08 00:01:27.547131
10044	2026-03-11 17:30:00	7	26.69	220	6279.6	t	2026-05-08 00:01:27.547131
10045	2026-03-11 18:00:00	1	20.58	220	4475.6	t	2026-05-08 00:01:27.547131
10046	2026-03-11 18:00:00	4	18.3	220	5578.2	t	2026-05-08 00:01:27.547131
10047	2026-03-11 18:00:00	7	25.09	220	6382	t	2026-05-08 00:01:27.547131
10048	2026-03-11 18:30:00	1	14.08	220	3629.9	t	2026-05-08 00:01:27.547131
10049	2026-03-11 18:30:00	4	21.49	220	4708.3	t	2026-05-08 00:01:27.547131
10050	2026-03-11 18:30:00	7	22.87	220	6378	t	2026-05-08 00:01:27.547131
10051	2026-03-11 19:00:00	1	17.28	220	4555.7	t	2026-05-08 00:01:27.547131
10052	2026-03-11 19:00:00	4	23.58	220	5602.3	t	2026-05-08 00:01:27.547131
10053	2026-03-11 19:00:00	7	21.77	220	4661.6	t	2026-05-08 00:01:27.547131
10054	2026-03-11 19:30:00	1	12.56	220	2568.6	t	2026-05-08 00:01:27.547131
10055	2026-03-11 19:30:00	4	24.87	220	3726.6	t	2026-05-08 00:01:27.547131
10056	2026-03-11 19:30:00	7	28.4	220	5485.3	t	2026-05-08 00:01:27.547131
10057	2026-03-11 20:00:00	1	1.73	220	286.2	t	2026-05-08 00:01:27.547131
10058	2026-03-11 20:00:00	4	2.34	220	457.1	t	2026-05-08 00:01:27.547131
10059	2026-03-11 20:00:00	7	3.37	220	696.4	t	2026-05-08 00:01:27.547131
10060	2026-03-11 20:30:00	1	2.53	220	680.1	t	2026-05-08 00:01:27.547131
10061	2026-03-11 20:30:00	4	3.65	220	697.8	t	2026-05-08 00:01:27.547131
10062	2026-03-11 20:30:00	7	3.44	220	399.6	t	2026-05-08 00:01:27.547131
10063	2026-03-11 21:00:00	1	1.21	220	302.3	t	2026-05-08 00:01:27.547131
10064	2026-03-11 21:00:00	4	3.24	220	356.5	t	2026-05-08 00:01:27.547131
10065	2026-03-11 21:00:00	7	2.31	220	749.5	t	2026-05-08 00:01:27.547131
10066	2026-03-11 21:30:00	1	1.21	220	508.1	t	2026-05-08 00:01:27.547131
10067	2026-03-11 21:30:00	4	2.06	220	288.8	t	2026-05-08 00:01:27.547131
10068	2026-03-11 21:30:00	7	3.55	220	436.7	t	2026-05-08 00:01:27.547131
10069	2026-03-11 22:00:00	1	3.4	220	638.2	t	2026-05-08 00:01:27.547131
10070	2026-03-11 22:00:00	4	3.42	220	677.3	t	2026-05-08 00:01:27.547131
10071	2026-03-11 22:00:00	7	3.49	220	564.4	t	2026-05-08 00:01:27.547131
10072	2026-03-11 22:30:00	1	1.49	220	369.7	t	2026-05-08 00:01:27.547131
10073	2026-03-11 22:30:00	4	3.16	220	589.3	t	2026-05-08 00:01:27.547131
10074	2026-03-11 22:30:00	7	2.28	220	279.8	t	2026-05-08 00:01:27.547131
10075	2026-03-11 23:00:00	1	2.64	220	790.8	t	2026-05-08 00:01:27.547131
10076	2026-03-11 23:00:00	4	3.07	220	627.5	t	2026-05-08 00:01:27.547131
10077	2026-03-11 23:00:00	7	2.48	220	709.8	t	2026-05-08 00:01:27.547131
10078	2026-03-11 23:30:00	1	2.13	220	764.4	t	2026-05-08 00:01:27.547131
10079	2026-03-11 23:30:00	4	3.35	220	481.1	t	2026-05-08 00:01:27.547131
10080	2026-03-11 23:30:00	7	1.44	220	304.8	t	2026-05-08 00:01:27.547131
10081	2026-03-12 00:00:00	1	2.15	220	605	t	2026-05-08 00:01:27.547131
10082	2026-03-12 00:00:00	4	2.02	220	264.9	t	2026-05-08 00:01:27.547131
10083	2026-03-12 00:00:00	7	3.61	220	643.8	t	2026-05-08 00:01:27.547131
10084	2026-03-12 00:30:00	1	2.51	220	342	t	2026-05-08 00:01:27.547131
10085	2026-03-12 00:30:00	4	2.5	220	465.2	t	2026-05-08 00:01:27.547131
10086	2026-03-12 00:30:00	7	1.55	220	613.6	t	2026-05-08 00:01:27.547131
10087	2026-03-12 01:00:00	1	2.37	220	672.6	t	2026-05-08 00:01:27.547131
10088	2026-03-12 01:00:00	4	3.16	220	302.6	t	2026-05-08 00:01:27.547131
10089	2026-03-12 01:00:00	7	1.38	220	566.3	t	2026-05-08 00:01:27.547131
10090	2026-03-12 01:30:00	1	1.95	220	325.4	t	2026-05-08 00:01:27.547131
10091	2026-03-12 01:30:00	4	2.76	220	574.2	t	2026-05-08 00:01:27.547131
10092	2026-03-12 01:30:00	7	2.76	220	595.9	t	2026-05-08 00:01:27.547131
10093	2026-03-12 02:00:00	1	3.45	220	665	t	2026-05-08 00:01:27.547131
10094	2026-03-12 02:00:00	4	1.37	220	657.6	t	2026-05-08 00:01:27.547131
10095	2026-03-12 02:00:00	7	2.51	220	316	t	2026-05-08 00:01:27.547131
10096	2026-03-12 02:30:00	1	3.34	220	504.7	t	2026-05-08 00:01:27.547131
10097	2026-03-12 02:30:00	4	3.12	220	462.7	t	2026-05-08 00:01:27.547131
10098	2026-03-12 02:30:00	7	2.23	220	609.6	t	2026-05-08 00:01:27.547131
10099	2026-03-12 03:00:00	1	2.03	220	543	t	2026-05-08 00:01:27.547131
10100	2026-03-12 03:00:00	4	2.7	220	608.4	t	2026-05-08 00:01:27.547131
10101	2026-03-12 03:00:00	7	2.75	220	362.4	t	2026-05-08 00:01:27.547131
10102	2026-03-12 03:30:00	1	2.59	220	345.8	t	2026-05-08 00:01:27.547131
10103	2026-03-12 03:30:00	4	2.5	220	559.6	t	2026-05-08 00:01:27.547131
10104	2026-03-12 03:30:00	7	2.52	220	529.6	t	2026-05-08 00:01:27.547131
10105	2026-03-12 04:00:00	1	1.55	220	762.4	t	2026-05-08 00:01:27.547131
10106	2026-03-12 04:00:00	4	2.32	220	374	t	2026-05-08 00:01:27.547131
10107	2026-03-12 04:00:00	7	2.42	220	560.7	t	2026-05-08 00:01:27.547131
10108	2026-03-12 04:30:00	1	3.63	220	345.5	t	2026-05-08 00:01:27.547131
10109	2026-03-12 04:30:00	4	1.66	220	377	t	2026-05-08 00:01:27.547131
10110	2026-03-12 04:30:00	7	1.55	220	813.7	t	2026-05-08 00:01:27.547131
10111	2026-03-12 05:00:00	1	3.42	220	387.4	t	2026-05-08 00:01:27.547131
10112	2026-03-12 05:00:00	4	1.58	220	367.1	t	2026-05-08 00:01:27.547131
10113	2026-03-12 05:00:00	7	3.54	220	609.9	t	2026-05-08 00:01:27.547131
10114	2026-03-12 05:30:00	1	1.55	220	502.2	t	2026-05-08 00:01:27.547131
10115	2026-03-12 05:30:00	4	1.31	220	727.2	t	2026-05-08 00:01:27.547131
10116	2026-03-12 05:30:00	7	1.41	220	369.4	t	2026-05-08 00:01:27.547131
10117	2026-03-12 06:00:00	1	2.27	220	313.1	t	2026-05-08 00:01:27.547131
10118	2026-03-12 06:00:00	4	1.98	220	793.4	t	2026-05-08 00:01:27.547131
10119	2026-03-12 06:00:00	7	3.31	220	564.5	t	2026-05-08 00:01:27.547131
10120	2026-03-12 06:30:00	1	1.37	220	392	t	2026-05-08 00:01:27.547131
10121	2026-03-12 06:30:00	4	1.64	220	755.7	t	2026-05-08 00:01:27.547131
10122	2026-03-12 06:30:00	7	2.13	220	771.8	t	2026-05-08 00:01:27.547131
10123	2026-03-12 07:00:00	1	17.49	220	4187.1	t	2026-05-08 00:01:27.547131
10124	2026-03-12 07:00:00	4	21.54	220	4014.8	t	2026-05-08 00:01:27.547131
10125	2026-03-12 07:00:00	7	22.84	220	5301.8	t	2026-05-08 00:01:27.547131
10126	2026-03-12 07:30:00	1	14.52	220	3899.9	t	2026-05-08 00:01:27.547131
10127	2026-03-12 07:30:00	4	18.87	220	3872.6	t	2026-05-08 00:01:27.547131
10128	2026-03-12 07:30:00	7	26.05	220	5764.1	t	2026-05-08 00:01:27.547131
10129	2026-03-12 08:00:00	1	13.53	220	4270.9	t	2026-05-08 00:01:27.547131
10130	2026-03-12 08:00:00	4	22.65	220	4186.9	t	2026-05-08 00:01:27.547131
10131	2026-03-12 08:00:00	7	25.45	220	6028.1	t	2026-05-08 00:01:27.547131
10132	2026-03-12 08:30:00	1	17.81	220	4723.4	t	2026-05-08 00:01:27.547131
10133	2026-03-12 08:30:00	4	19.7	220	4998	t	2026-05-08 00:01:27.547131
10134	2026-03-12 08:30:00	7	29.3	220	5054.5	t	2026-05-08 00:01:27.547131
10135	2026-03-12 09:00:00	1	12.22	220	2859.4	t	2026-05-08 00:01:27.547131
10136	2026-03-12 09:00:00	4	24.22	220	5341.6	t	2026-05-08 00:01:27.547131
10137	2026-03-12 09:00:00	7	26.92	220	6394.3	t	2026-05-08 00:01:27.547131
10138	2026-03-12 09:30:00	1	17.14	220	3292	t	2026-05-08 00:01:27.547131
10139	2026-03-12 09:30:00	4	23.27	220	5305.2	t	2026-05-08 00:01:27.547131
10140	2026-03-12 09:30:00	7	28.77	220	4606.7	t	2026-05-08 00:01:27.547131
10141	2026-03-12 10:00:00	1	14.12	220	4229.5	t	2026-05-08 00:01:27.547131
10142	2026-03-12 10:00:00	4	21.22	220	4564.2	t	2026-05-08 00:01:27.547131
10143	2026-03-12 10:00:00	7	27.3	220	4866.8	t	2026-05-08 00:01:27.547131
10144	2026-03-12 10:30:00	1	13.16	220	2710.4	t	2026-05-08 00:01:27.547131
10145	2026-03-12 10:30:00	4	17.42	220	3975.5	t	2026-05-08 00:01:27.547131
10146	2026-03-12 10:30:00	7	29.97	220	4998.2	t	2026-05-08 00:01:27.547131
10147	2026-03-12 11:00:00	1	19.59	220	2681.8	t	2026-05-08 00:01:27.547131
10148	2026-03-12 11:00:00	4	24.76	220	4076.2	t	2026-05-08 00:01:27.547131
10149	2026-03-12 11:00:00	7	24.06	220	6171.1	t	2026-05-08 00:01:27.547131
10150	2026-03-12 11:30:00	1	19.72	220	4718.3	t	2026-05-08 00:01:27.547131
10151	2026-03-12 11:30:00	4	18.78	220	5130.8	t	2026-05-08 00:01:27.547131
10152	2026-03-12 11:30:00	7	29.36	220	6612.4	t	2026-05-08 00:01:27.547131
10153	2026-03-12 12:00:00	1	12.02	220	3858.4	t	2026-05-08 00:01:27.547131
10154	2026-03-12 12:00:00	4	24.27	220	3610.7	t	2026-05-08 00:01:27.547131
10155	2026-03-12 12:00:00	7	29.5	220	5989.3	t	2026-05-08 00:01:27.547131
10156	2026-03-12 12:30:00	1	19.96	220	4722.8	t	2026-05-08 00:01:27.547131
10157	2026-03-12 12:30:00	4	20.31	220	3710.9	t	2026-05-08 00:01:27.547131
10158	2026-03-12 12:30:00	7	27.3	220	4794	t	2026-05-08 00:01:27.547131
10159	2026-03-12 13:00:00	1	13.57	220	2939.1	t	2026-05-08 00:01:27.547131
10160	2026-03-12 13:00:00	4	19.48	220	4649.2	t	2026-05-08 00:01:27.547131
10161	2026-03-12 13:00:00	7	28.91	220	6612.1	t	2026-05-08 00:01:27.547131
10162	2026-03-12 13:30:00	1	13.81	220	4579.8	t	2026-05-08 00:01:27.547131
10163	2026-03-12 13:30:00	4	19.33	220	5012.3	t	2026-05-08 00:01:27.547131
10164	2026-03-12 13:30:00	7	26.26	220	6453.7	t	2026-05-08 00:01:27.547131
10165	2026-03-12 14:00:00	1	16.67	220	4452	t	2026-05-08 00:01:27.547131
10166	2026-03-12 14:00:00	4	22	220	5198.5	t	2026-05-08 00:01:27.547131
10167	2026-03-12 14:00:00	7	23.57	220	4588.8	t	2026-05-08 00:01:27.547131
10168	2026-03-12 14:30:00	1	15.39	220	3229.1	t	2026-05-08 00:01:27.547131
10169	2026-03-12 14:30:00	4	16.46	220	4681.1	t	2026-05-08 00:01:27.547131
10170	2026-03-12 14:30:00	7	23.75	220	5825.7	t	2026-05-08 00:01:27.547131
10171	2026-03-12 15:00:00	1	15.02	220	3742.5	t	2026-05-08 00:01:27.547131
10172	2026-03-12 15:00:00	4	25.35	220	4607.7	t	2026-05-08 00:01:27.547131
10173	2026-03-12 15:00:00	7	28.13	220	4929.4	t	2026-05-08 00:01:27.547131
10174	2026-03-12 15:30:00	1	13.25	220	3184.6	t	2026-05-08 00:01:27.547131
10175	2026-03-12 15:30:00	4	22.19	220	4245.1	t	2026-05-08 00:01:27.547131
10176	2026-03-12 15:30:00	7	24.11	220	6640.3	t	2026-05-08 00:01:27.547131
10177	2026-03-12 16:00:00	1	13.52	220	3696.1	t	2026-05-08 00:01:27.547131
10178	2026-03-12 16:00:00	4	24.32	220	3836.9	t	2026-05-08 00:01:27.547131
10179	2026-03-12 16:00:00	7	23.33	220	6512.4	t	2026-05-08 00:01:27.547131
10180	2026-03-12 16:30:00	1	17.47	220	3045	t	2026-05-08 00:01:27.547131
10181	2026-03-12 16:30:00	4	18.3	220	4622.1	t	2026-05-08 00:01:27.547131
10182	2026-03-12 16:30:00	7	21.94	220	6615.1	t	2026-05-08 00:01:27.547131
10183	2026-03-12 17:00:00	1	15.98	220	2998.6	t	2026-05-08 00:01:27.547131
10184	2026-03-12 17:00:00	4	25.77	220	4324.8	t	2026-05-08 00:01:27.547131
10185	2026-03-12 17:00:00	7	29.35	220	4728.2	t	2026-05-08 00:01:27.547131
10186	2026-03-12 17:30:00	1	15.17	220	2673.2	t	2026-05-08 00:01:27.547131
10187	2026-03-12 17:30:00	4	19.44	220	4699.3	t	2026-05-08 00:01:27.547131
10188	2026-03-12 17:30:00	7	23.11	220	6406.5	t	2026-05-08 00:01:27.547131
10189	2026-03-12 18:00:00	1	18.13	220	3941.2	t	2026-05-08 00:01:27.547131
10190	2026-03-12 18:00:00	4	22.67	220	4511.1	t	2026-05-08 00:01:27.547131
10191	2026-03-12 18:00:00	7	24.34	220	4914.1	t	2026-05-08 00:01:27.547131
10192	2026-03-12 18:30:00	1	20.53	220	3459	t	2026-05-08 00:01:27.547131
10193	2026-03-12 18:30:00	4	17.87	220	5533.8	t	2026-05-08 00:01:27.547131
10194	2026-03-12 18:30:00	7	30.38	220	6371.5	t	2026-05-08 00:01:27.547131
10195	2026-03-12 19:00:00	1	18.71	220	2765.2	t	2026-05-08 00:01:27.547131
10196	2026-03-12 19:00:00	4	18.55	220	4556.6	t	2026-05-08 00:01:27.547131
10197	2026-03-12 19:00:00	7	27.42	220	6646	t	2026-05-08 00:01:27.547131
10198	2026-03-12 19:30:00	1	18.1	220	2592.6	t	2026-05-08 00:01:27.547131
10199	2026-03-12 19:30:00	4	24.95	220	4019.7	t	2026-05-08 00:01:27.547131
10200	2026-03-12 19:30:00	7	24.51	220	6586.2	t	2026-05-08 00:01:27.547131
10201	2026-03-12 20:00:00	1	2.9	220	746.7	t	2026-05-08 00:01:27.547131
10202	2026-03-12 20:00:00	4	3.24	220	309	t	2026-05-08 00:01:27.547131
10203	2026-03-12 20:00:00	7	2.36	220	357.2	t	2026-05-08 00:01:27.547131
10204	2026-03-12 20:30:00	1	3.19	220	624	t	2026-05-08 00:01:27.547131
10205	2026-03-12 20:30:00	4	3.01	220	461	t	2026-05-08 00:01:27.547131
10206	2026-03-12 20:30:00	7	2.87	220	557.8	t	2026-05-08 00:01:27.547131
10207	2026-03-12 21:00:00	1	2.32	220	799.6	t	2026-05-08 00:01:27.547131
10208	2026-03-12 21:00:00	4	3.47	220	752.6	t	2026-05-08 00:01:27.547131
10209	2026-03-12 21:00:00	7	1.92	220	541.4	t	2026-05-08 00:01:27.547131
10210	2026-03-12 21:30:00	1	2.54	220	733.6	t	2026-05-08 00:01:27.547131
10211	2026-03-12 21:30:00	4	1.53	220	571.2	t	2026-05-08 00:01:27.547131
10212	2026-03-12 21:30:00	7	1.28	220	270.5	t	2026-05-08 00:01:27.547131
10213	2026-03-12 22:00:00	1	1.28	220	632.5	t	2026-05-08 00:01:27.547131
10214	2026-03-12 22:00:00	4	1.35	220	713	t	2026-05-08 00:01:27.547131
10215	2026-03-12 22:00:00	7	1.78	220	400.5	t	2026-05-08 00:01:27.547131
10216	2026-03-12 22:30:00	1	1.39	220	293	t	2026-05-08 00:01:27.547131
10217	2026-03-12 22:30:00	4	3.25	220	333.8	t	2026-05-08 00:01:27.547131
10218	2026-03-12 22:30:00	7	1.75	220	393.9	t	2026-05-08 00:01:27.547131
10219	2026-03-12 23:00:00	1	2.88	220	425.2	t	2026-05-08 00:01:27.547131
10220	2026-03-12 23:00:00	4	1.73	220	382.8	t	2026-05-08 00:01:27.547131
10221	2026-03-12 23:00:00	7	2.53	220	787.6	t	2026-05-08 00:01:27.547131
10222	2026-03-12 23:30:00	1	1.24	220	715.6	t	2026-05-08 00:01:27.547131
10223	2026-03-12 23:30:00	4	1.34	220	751.4	t	2026-05-08 00:01:27.547131
10224	2026-03-12 23:30:00	7	2.52	220	602.4	t	2026-05-08 00:01:27.547131
10225	2026-03-13 00:00:00	1	1.87	220	788.3	t	2026-05-08 00:01:27.547131
10226	2026-03-13 00:00:00	4	3.37	220	703.2	t	2026-05-08 00:01:27.547131
10227	2026-03-13 00:00:00	7	2.18	220	329.7	t	2026-05-08 00:01:27.547131
10228	2026-03-13 00:30:00	1	1.37	220	315.4	t	2026-05-08 00:01:27.547131
10229	2026-03-13 00:30:00	4	2.8	220	601.9	t	2026-05-08 00:01:27.547131
10230	2026-03-13 00:30:00	7	2.86	220	470.4	t	2026-05-08 00:01:27.547131
10231	2026-03-13 01:00:00	1	2.92	220	586.7	t	2026-05-08 00:01:27.547131
10232	2026-03-13 01:00:00	4	2.91	220	764.2	t	2026-05-08 00:01:27.547131
10233	2026-03-13 01:00:00	7	2.96	220	519.8	t	2026-05-08 00:01:27.547131
10234	2026-03-13 01:30:00	1	1.33	220	639.4	t	2026-05-08 00:01:27.547131
10235	2026-03-13 01:30:00	4	2.93	220	394	t	2026-05-08 00:01:27.547131
10236	2026-03-13 01:30:00	7	1.98	220	341	t	2026-05-08 00:01:27.547131
10237	2026-03-13 02:00:00	1	2.54	220	762	t	2026-05-08 00:01:27.547131
10238	2026-03-13 02:00:00	4	1.76	220	766.8	t	2026-05-08 00:01:27.547131
10239	2026-03-13 02:00:00	7	2.69	220	793	t	2026-05-08 00:01:27.547131
10240	2026-03-13 02:30:00	1	3.51	220	410.7	t	2026-05-08 00:01:27.547131
10241	2026-03-13 02:30:00	4	2.61	220	356.7	t	2026-05-08 00:01:27.547131
10242	2026-03-13 02:30:00	7	3.47	220	474	t	2026-05-08 00:01:27.547131
10243	2026-03-13 03:00:00	1	3.64	220	410.6	t	2026-05-08 00:01:27.547131
10244	2026-03-13 03:00:00	4	3.49	220	658.2	t	2026-05-08 00:01:27.547131
10245	2026-03-13 03:00:00	7	3.44	220	711.8	t	2026-05-08 00:01:27.547131
10246	2026-03-13 03:30:00	1	2.16	220	556.5	t	2026-05-08 00:01:27.547131
10247	2026-03-13 03:30:00	4	2.05	220	550.9	t	2026-05-08 00:01:27.547131
10248	2026-03-13 03:30:00	7	1.27	220	670.7	t	2026-05-08 00:01:27.547131
10249	2026-03-13 04:00:00	1	3.12	220	789	t	2026-05-08 00:01:27.547131
10250	2026-03-13 04:00:00	4	1.81	220	784.4	t	2026-05-08 00:01:27.547131
10251	2026-03-13 04:00:00	7	2.36	220	403.3	t	2026-05-08 00:01:27.547131
10252	2026-03-13 04:30:00	1	3.47	220	500.3	t	2026-05-08 00:01:27.547131
10253	2026-03-13 04:30:00	4	3.18	220	445.9	t	2026-05-08 00:01:27.547131
10254	2026-03-13 04:30:00	7	3.24	220	788	t	2026-05-08 00:01:27.547131
10255	2026-03-13 05:00:00	1	3.39	220	512.1	t	2026-05-08 00:01:27.547131
10256	2026-03-13 05:00:00	4	3.17	220	682.3	t	2026-05-08 00:01:27.547131
10257	2026-03-13 05:00:00	7	3.31	220	737.3	t	2026-05-08 00:01:27.547131
10258	2026-03-13 05:30:00	1	1.54	220	449.3	t	2026-05-08 00:01:27.547131
10259	2026-03-13 05:30:00	4	2.78	220	355.5	t	2026-05-08 00:01:27.547131
10260	2026-03-13 05:30:00	7	2.52	220	701	t	2026-05-08 00:01:27.547131
10261	2026-03-13 06:00:00	1	3.62	220	760.5	t	2026-05-08 00:01:27.547131
10262	2026-03-13 06:00:00	4	3.01	220	433.1	t	2026-05-08 00:01:27.547131
10263	2026-03-13 06:00:00	7	2.27	220	612.3	t	2026-05-08 00:01:27.547131
10264	2026-03-13 06:30:00	1	1.47	220	673.2	t	2026-05-08 00:01:27.547131
10265	2026-03-13 06:30:00	4	2.83	220	335.5	t	2026-05-08 00:01:27.547131
10266	2026-03-13 06:30:00	7	2.92	220	700.2	t	2026-05-08 00:01:27.547131
10267	2026-03-13 07:00:00	1	13.79	220	2784.3	t	2026-05-08 00:01:27.547131
10268	2026-03-13 07:00:00	4	22.47	220	5400	t	2026-05-08 00:01:27.547131
10269	2026-03-13 07:00:00	7	27.83	220	6641.6	t	2026-05-08 00:01:27.547131
10270	2026-03-13 07:30:00	1	19.79	220	2887.6	t	2026-05-08 00:01:27.547131
10271	2026-03-13 07:30:00	4	23.05	220	4922.3	t	2026-05-08 00:01:27.547131
10272	2026-03-13 07:30:00	7	25.34	220	5225.5	t	2026-05-08 00:01:27.547131
10273	2026-03-13 08:00:00	1	14.51	220	3890.8	t	2026-05-08 00:01:27.547131
10274	2026-03-13 08:00:00	4	19.2	220	4139.5	t	2026-05-08 00:01:27.547131
10275	2026-03-13 08:00:00	7	27.28	220	6041.7	t	2026-05-08 00:01:27.547131
10276	2026-03-13 08:30:00	1	12.86	220	3975.4	t	2026-05-08 00:01:27.547131
10277	2026-03-13 08:30:00	4	18.82	220	3678.6	t	2026-05-08 00:01:27.547131
10278	2026-03-13 08:30:00	7	24.49	220	5733.6	t	2026-05-08 00:01:27.547131
10279	2026-03-13 09:00:00	1	17.12	220	3723.5	t	2026-05-08 00:01:27.547131
10280	2026-03-13 09:00:00	4	20.99	220	5409.1	t	2026-05-08 00:01:27.547131
10281	2026-03-13 09:00:00	7	30.24	220	4535	t	2026-05-08 00:01:27.547131
10282	2026-03-13 09:30:00	1	13	220	3103	t	2026-05-08 00:01:27.547131
10283	2026-03-13 09:30:00	4	21.21	220	5187.9	t	2026-05-08 00:01:27.547131
10284	2026-03-13 09:30:00	7	24.36	220	5120.3	t	2026-05-08 00:01:27.547131
10285	2026-03-13 10:00:00	1	19.91	220	3718.5	t	2026-05-08 00:01:27.547131
10286	2026-03-13 10:00:00	4	22.05	220	4146.7	t	2026-05-08 00:01:27.547131
10287	2026-03-13 10:00:00	7	22.34	220	5199.4	t	2026-05-08 00:01:27.547131
10288	2026-03-13 10:30:00	1	13.05	220	2967.4	t	2026-05-08 00:01:27.547131
10289	2026-03-13 10:30:00	4	21.44	220	3757.6	t	2026-05-08 00:01:27.547131
10290	2026-03-13 10:30:00	7	29.15	220	4544.9	t	2026-05-08 00:01:27.547131
10291	2026-03-13 11:00:00	1	16.21	220	4040.4	t	2026-05-08 00:01:27.547131
10292	2026-03-13 11:00:00	4	24.02	220	4814.5	t	2026-05-08 00:01:27.547131
10293	2026-03-13 11:00:00	7	21.35	220	4585	t	2026-05-08 00:01:27.547131
10294	2026-03-13 11:30:00	1	15.84	220	2986.4	t	2026-05-08 00:01:27.547131
10295	2026-03-13 11:30:00	4	17.09	220	5016.6	t	2026-05-08 00:01:27.547131
10296	2026-03-13 11:30:00	7	26.97	220	6253.4	t	2026-05-08 00:01:27.547131
10297	2026-03-13 12:00:00	1	18.17	220	3847.5	t	2026-05-08 00:01:27.547131
10298	2026-03-13 12:00:00	4	23.05	220	3593.2	t	2026-05-08 00:01:27.547131
10299	2026-03-13 12:00:00	7	26.12	220	5553.3	t	2026-05-08 00:01:27.547131
10300	2026-03-13 12:30:00	1	15.05	220	3113.4	t	2026-05-08 00:01:27.547131
10301	2026-03-13 12:30:00	4	22.35	220	5690	t	2026-05-08 00:01:27.547131
10302	2026-03-13 12:30:00	7	22.6	220	5147.8	t	2026-05-08 00:01:27.547131
10303	2026-03-13 13:00:00	1	14.67	220	4431.5	t	2026-05-08 00:01:27.547131
10304	2026-03-13 13:00:00	4	20.46	220	5707.4	t	2026-05-08 00:01:27.547131
10305	2026-03-13 13:00:00	7	21.53	220	6059	t	2026-05-08 00:01:27.547131
10306	2026-03-13 13:30:00	1	17.07	220	3898.8	t	2026-05-08 00:01:27.547131
10307	2026-03-13 13:30:00	4	19.44	220	4537.2	t	2026-05-08 00:01:27.547131
10308	2026-03-13 13:30:00	7	30.09	220	6623.7	t	2026-05-08 00:01:27.547131
10309	2026-03-13 14:00:00	1	13.85	220	3502.4	t	2026-05-08 00:01:27.547131
10310	2026-03-13 14:00:00	4	18.66	220	5582.7	t	2026-05-08 00:01:27.547131
10311	2026-03-13 14:00:00	7	21.25	220	4643.7	t	2026-05-08 00:01:27.547131
10312	2026-03-13 14:30:00	1	13.24	220	2794.7	t	2026-05-08 00:01:27.547131
10313	2026-03-13 14:30:00	4	20.84	220	3853.4	t	2026-05-08 00:01:27.547131
10314	2026-03-13 14:30:00	7	28.72	220	5221.7	t	2026-05-08 00:01:27.547131
10315	2026-03-13 15:00:00	1	20.34	220	2554.3	t	2026-05-08 00:01:27.547131
10316	2026-03-13 15:00:00	4	23.68	220	5035.9	t	2026-05-08 00:01:27.547131
10317	2026-03-13 15:00:00	7	23.52	220	4925.2	t	2026-05-08 00:01:27.547131
10318	2026-03-13 15:30:00	1	12.87	220	2692.6	t	2026-05-08 00:01:27.547131
10319	2026-03-13 15:30:00	4	20.46	220	4942.4	t	2026-05-08 00:01:27.547131
10320	2026-03-13 15:30:00	7	25.59	220	6511.8	t	2026-05-08 00:01:27.547131
10321	2026-03-13 16:00:00	1	12.07	220	4197.2	t	2026-05-08 00:01:27.547131
10322	2026-03-13 16:00:00	4	16.62	220	5091.3	t	2026-05-08 00:01:27.547131
10323	2026-03-13 16:00:00	7	22.9	220	5576.1	t	2026-05-08 00:01:27.547131
10324	2026-03-13 16:30:00	1	16.18	220	2957.7	t	2026-05-08 00:01:27.547131
10325	2026-03-13 16:30:00	4	20.12	220	4213.8	t	2026-05-08 00:01:27.547131
10326	2026-03-13 16:30:00	7	29.01	220	6584.9	t	2026-05-08 00:01:27.547131
10327	2026-03-13 17:00:00	1	19.57	220	4066.3	t	2026-05-08 00:01:27.547131
10328	2026-03-13 17:00:00	4	17.58	220	4989.2	t	2026-05-08 00:01:27.547131
10329	2026-03-13 17:00:00	7	25.24	220	6579.6	t	2026-05-08 00:01:27.547131
10330	2026-03-13 17:30:00	1	18.64	220	3065	t	2026-05-08 00:01:27.547131
10331	2026-03-13 17:30:00	4	17.8	220	4103.1	t	2026-05-08 00:01:27.547131
10332	2026-03-13 17:30:00	7	25.02	220	4752	t	2026-05-08 00:01:27.547131
10333	2026-03-13 18:00:00	1	16.85	220	3953.9	t	2026-05-08 00:01:27.547131
10334	2026-03-13 18:00:00	4	20.82	220	4853.6	t	2026-05-08 00:01:27.547131
10335	2026-03-13 18:00:00	7	23.29	220	4557.3	t	2026-05-08 00:01:27.547131
10336	2026-03-13 18:30:00	1	14.09	220	3042.7	t	2026-05-08 00:01:27.547131
10337	2026-03-13 18:30:00	4	25.5	220	4044.8	t	2026-05-08 00:01:27.547131
10338	2026-03-13 18:30:00	7	25.86	220	4990.8	t	2026-05-08 00:01:27.547131
10339	2026-03-13 19:00:00	1	18.47	220	2922.4	t	2026-05-08 00:01:27.547131
10340	2026-03-13 19:00:00	4	23.33	220	5628.8	t	2026-05-08 00:01:27.547131
10341	2026-03-13 19:00:00	7	21.36	220	6128.2	t	2026-05-08 00:01:27.547131
10342	2026-03-13 19:30:00	1	13.24	220	3192.5	t	2026-05-08 00:01:27.547131
10343	2026-03-13 19:30:00	4	16.71	220	4552.7	t	2026-05-08 00:01:27.547131
10344	2026-03-13 19:30:00	7	24.49	220	4648.5	t	2026-05-08 00:01:27.547131
10345	2026-03-13 20:00:00	1	1.3	220	495.8	t	2026-05-08 00:01:27.547131
10346	2026-03-13 20:00:00	4	1.44	220	736.4	t	2026-05-08 00:01:27.547131
10347	2026-03-13 20:00:00	7	2.09	220	444.5	t	2026-05-08 00:01:27.547131
10348	2026-03-13 20:30:00	1	2.38	220	748.8	t	2026-05-08 00:01:27.547131
10349	2026-03-13 20:30:00	4	2.91	220	704.8	t	2026-05-08 00:01:27.547131
10350	2026-03-13 20:30:00	7	1.82	220	305.6	t	2026-05-08 00:01:27.547131
10351	2026-03-13 21:00:00	1	3.16	220	374	t	2026-05-08 00:01:27.547131
10352	2026-03-13 21:00:00	4	1.57	220	367	t	2026-05-08 00:01:27.547131
10353	2026-03-13 21:00:00	7	1.49	220	437.6	t	2026-05-08 00:01:27.547131
10354	2026-03-13 21:30:00	1	2.96	220	268.8	t	2026-05-08 00:01:27.547131
10355	2026-03-13 21:30:00	4	1.44	220	437.4	t	2026-05-08 00:01:27.547131
10356	2026-03-13 21:30:00	7	1.26	220	614.7	t	2026-05-08 00:01:27.547131
10357	2026-03-13 22:00:00	1	1.87	220	485.7	t	2026-05-08 00:01:27.547131
10358	2026-03-13 22:00:00	4	2.62	220	719.7	t	2026-05-08 00:01:27.547131
10359	2026-03-13 22:00:00	7	1.6	220	779.6	t	2026-05-08 00:01:27.547131
10360	2026-03-13 22:30:00	1	1.82	220	660.1	t	2026-05-08 00:01:27.547131
10361	2026-03-13 22:30:00	4	1.71	220	351.2	t	2026-05-08 00:01:27.547131
10362	2026-03-13 22:30:00	7	3.34	220	284.4	t	2026-05-08 00:01:27.547131
10363	2026-03-13 23:00:00	1	1.52	220	796.8	t	2026-05-08 00:01:27.547131
10364	2026-03-13 23:00:00	4	1.96	220	506.3	t	2026-05-08 00:01:27.547131
10365	2026-03-13 23:00:00	7	2.67	220	604.3	t	2026-05-08 00:01:27.547131
10366	2026-03-13 23:30:00	1	1.52	220	621.5	t	2026-05-08 00:01:27.547131
10367	2026-03-13 23:30:00	4	2.47	220	426.9	t	2026-05-08 00:01:27.547131
10368	2026-03-13 23:30:00	7	2.55	220	611.6	t	2026-05-08 00:01:27.547131
10369	2026-03-14 00:00:00	1	1.23	220	226.3	t	2026-05-08 00:01:27.547131
10370	2026-03-14 00:00:00	4	2.93	220	392.1	t	2026-05-08 00:01:27.547131
10371	2026-03-14 00:00:00	7	2.71	220	237	t	2026-05-08 00:01:27.547131
10372	2026-03-14 00:30:00	1	1.19	220	471	t	2026-05-08 00:01:27.547131
10373	2026-03-14 00:30:00	4	1.05	220	507.5	t	2026-05-08 00:01:27.547131
10374	2026-03-14 00:30:00	7	2.41	220	473.3	t	2026-05-08 00:01:27.547131
10375	2026-03-14 01:00:00	1	1.2	220	286.6	t	2026-05-08 00:01:27.547131
10376	2026-03-14 01:00:00	4	2.47	220	569.9	t	2026-05-08 00:01:27.547131
10377	2026-03-14 01:00:00	7	1.66	220	487.1	t	2026-05-08 00:01:27.547131
10378	2026-03-14 01:30:00	1	2.71	220	573.6	t	2026-05-08 00:01:27.547131
10379	2026-03-14 01:30:00	4	2.97	220	623.7	t	2026-05-08 00:01:27.547131
10380	2026-03-14 01:30:00	7	2.29	220	582.1	t	2026-05-08 00:01:27.547131
10381	2026-03-14 02:00:00	1	2.67	220	515.8	t	2026-05-08 00:01:27.547131
10382	2026-03-14 02:00:00	4	2.26	220	556	t	2026-05-08 00:01:27.547131
10383	2026-03-14 02:00:00	7	2.2	220	298.6	t	2026-05-08 00:01:27.547131
10384	2026-03-14 02:30:00	1	2.71	220	635	t	2026-05-08 00:01:27.547131
10385	2026-03-14 02:30:00	4	1.66	220	587.9	t	2026-05-08 00:01:27.547131
10386	2026-03-14 02:30:00	7	2.74	220	531.8	t	2026-05-08 00:01:27.547131
10387	2026-03-14 03:00:00	1	1.58	220	621.7	t	2026-05-08 00:01:27.547131
10388	2026-03-14 03:00:00	4	2.68	220	651.2	t	2026-05-08 00:01:27.547131
10389	2026-03-14 03:00:00	7	1.37	220	426.2	t	2026-05-08 00:01:27.547131
10390	2026-03-14 03:30:00	1	2.32	220	650.7	t	2026-05-08 00:01:27.547131
10391	2026-03-14 03:30:00	4	1.16	220	541.6	t	2026-05-08 00:01:27.547131
10392	2026-03-14 03:30:00	7	1.89	220	584.8	t	2026-05-08 00:01:27.547131
10393	2026-03-14 04:00:00	1	1.65	220	560.1	t	2026-05-08 00:01:27.547131
10394	2026-03-14 04:00:00	4	2.09	220	637.1	t	2026-05-08 00:01:27.547131
10395	2026-03-14 04:00:00	7	1.02	220	410	t	2026-05-08 00:01:27.547131
10396	2026-03-14 04:30:00	1	1.38	220	361.2	t	2026-05-08 00:01:27.547131
10397	2026-03-14 04:30:00	4	1.89	220	557.3	t	2026-05-08 00:01:27.547131
10398	2026-03-14 04:30:00	7	1.43	220	318.9	t	2026-05-08 00:01:27.547131
10399	2026-03-14 05:00:00	1	2.91	220	383.9	t	2026-05-08 00:01:27.547131
10400	2026-03-14 05:00:00	4	1.8	220	531.2	t	2026-05-08 00:01:27.547131
10401	2026-03-14 05:00:00	7	1.85	220	522.5	t	2026-05-08 00:01:27.547131
10402	2026-03-14 05:30:00	1	1.06	220	303.5	t	2026-05-08 00:01:27.547131
10403	2026-03-14 05:30:00	4	1.34	220	221.3	t	2026-05-08 00:01:27.547131
10404	2026-03-14 05:30:00	7	1.8	220	341.4	t	2026-05-08 00:01:27.547131
10405	2026-03-14 06:00:00	1	1.59	220	654.5	t	2026-05-08 00:01:27.547131
10406	2026-03-14 06:00:00	4	2.84	220	584.9	t	2026-05-08 00:01:27.547131
10407	2026-03-14 06:00:00	7	2.82	220	622.9	t	2026-05-08 00:01:27.547131
10408	2026-03-14 06:30:00	1	2.53	220	624	t	2026-05-08 00:01:27.547131
10409	2026-03-14 06:30:00	4	1.27	220	423	t	2026-05-08 00:01:27.547131
10410	2026-03-14 06:30:00	7	2.78	220	249	t	2026-05-08 00:01:27.547131
10411	2026-03-14 07:00:00	1	1.19	220	524.7	t	2026-05-08 00:01:27.547131
10412	2026-03-14 07:00:00	4	1.19	220	292.3	t	2026-05-08 00:01:27.547131
10413	2026-03-14 07:00:00	7	1.65	220	282.5	t	2026-05-08 00:01:27.547131
10414	2026-03-14 07:30:00	1	1.62	220	408.3	t	2026-05-08 00:01:27.547131
10415	2026-03-14 07:30:00	4	2.6	220	329.7	t	2026-05-08 00:01:27.547131
10416	2026-03-14 07:30:00	7	2.72	220	538.6	t	2026-05-08 00:01:27.547131
10417	2026-03-14 08:00:00	1	2.91	220	658.4	t	2026-05-08 00:01:27.547131
10418	2026-03-14 08:00:00	4	2.38	220	272.6	t	2026-05-08 00:01:27.547131
10419	2026-03-14 08:00:00	7	2.15	220	570.1	t	2026-05-08 00:01:27.547131
10420	2026-03-14 08:30:00	1	1.68	220	242.4	t	2026-05-08 00:01:27.547131
10421	2026-03-14 08:30:00	4	1.15	220	483.9	t	2026-05-08 00:01:27.547131
10422	2026-03-14 08:30:00	7	1.3	220	322	t	2026-05-08 00:01:27.547131
10423	2026-03-14 09:00:00	1	1.15	220	609.9	t	2026-05-08 00:01:27.547131
10424	2026-03-14 09:00:00	4	2.13	220	561.2	t	2026-05-08 00:01:27.547131
10425	2026-03-14 09:00:00	7	1.41	220	272.6	t	2026-05-08 00:01:27.547131
10426	2026-03-14 09:30:00	1	2.64	220	262.2	t	2026-05-08 00:01:27.547131
10427	2026-03-14 09:30:00	4	1.33	220	422.4	t	2026-05-08 00:01:27.547131
10428	2026-03-14 09:30:00	7	1.41	220	262.1	t	2026-05-08 00:01:27.547131
10429	2026-03-14 10:00:00	1	1.53	220	428.9	t	2026-05-08 00:01:27.547131
10430	2026-03-14 10:00:00	4	1.98	220	484.9	t	2026-05-08 00:01:27.547131
10431	2026-03-14 10:00:00	7	2.96	220	496	t	2026-05-08 00:01:27.547131
10432	2026-03-14 10:30:00	1	1.87	220	571.7	t	2026-05-08 00:01:27.547131
10433	2026-03-14 10:30:00	4	1.54	220	652.3	t	2026-05-08 00:01:27.547131
10434	2026-03-14 10:30:00	7	1.66	220	392.9	t	2026-05-08 00:01:27.547131
10435	2026-03-14 11:00:00	1	1.08	220	608.9	t	2026-05-08 00:01:27.547131
10436	2026-03-14 11:00:00	4	2.77	220	528	t	2026-05-08 00:01:27.547131
10437	2026-03-14 11:00:00	7	2.34	220	657.9	t	2026-05-08 00:01:27.547131
10438	2026-03-14 11:30:00	1	2.71	220	607.9	t	2026-05-08 00:01:27.547131
10439	2026-03-14 11:30:00	4	2.76	220	498.2	t	2026-05-08 00:01:27.547131
10440	2026-03-14 11:30:00	7	1.59	220	640.4	t	2026-05-08 00:01:27.547131
10441	2026-03-14 12:00:00	1	1.82	220	464.8	t	2026-05-08 00:01:27.547131
10442	2026-03-14 12:00:00	4	2.81	220	418	t	2026-05-08 00:01:27.547131
10443	2026-03-14 12:00:00	7	2.6	220	220.4	t	2026-05-08 00:01:27.547131
10444	2026-03-14 12:30:00	1	3	220	253.1	t	2026-05-08 00:01:27.547131
10445	2026-03-14 12:30:00	4	2.96	220	609.3	t	2026-05-08 00:01:27.547131
10446	2026-03-14 12:30:00	7	1.24	220	358.6	t	2026-05-08 00:01:27.547131
10447	2026-03-14 13:00:00	1	2.29	220	568.7	t	2026-05-08 00:01:27.547131
10448	2026-03-14 13:00:00	4	1.79	220	409.6	t	2026-05-08 00:01:27.547131
10449	2026-03-14 13:00:00	7	1.67	220	299.7	t	2026-05-08 00:01:27.547131
10450	2026-03-14 13:30:00	1	1.51	220	268.5	t	2026-05-08 00:01:27.547131
10451	2026-03-14 13:30:00	4	1.95	220	460.2	t	2026-05-08 00:01:27.547131
10452	2026-03-14 13:30:00	7	2.15	220	224.3	t	2026-05-08 00:01:27.547131
10453	2026-03-14 14:00:00	1	1.27	220	350.6	t	2026-05-08 00:01:27.547131
10454	2026-03-14 14:00:00	4	2.57	220	555.5	t	2026-05-08 00:01:27.547131
10455	2026-03-14 14:00:00	7	1.05	220	379.2	t	2026-05-08 00:01:27.547131
10456	2026-03-14 14:30:00	1	1.63	220	567.2	t	2026-05-08 00:01:27.547131
10457	2026-03-14 14:30:00	4	2.59	220	586.8	t	2026-05-08 00:01:27.547131
10458	2026-03-14 14:30:00	7	2.4	220	245.3	t	2026-05-08 00:01:27.547131
10459	2026-03-14 15:00:00	1	2.77	220	629.6	t	2026-05-08 00:01:27.547131
10460	2026-03-14 15:00:00	4	1.13	220	498.6	t	2026-05-08 00:01:27.547131
10461	2026-03-14 15:00:00	7	2.72	220	243.2	t	2026-05-08 00:01:27.547131
10462	2026-03-14 15:30:00	1	1.85	220	321.1	t	2026-05-08 00:01:27.547131
10463	2026-03-14 15:30:00	4	1.59	220	461.4	t	2026-05-08 00:01:27.547131
10464	2026-03-14 15:30:00	7	1.34	220	259.1	t	2026-05-08 00:01:27.547131
10465	2026-03-14 16:00:00	1	1.13	220	247.2	t	2026-05-08 00:01:27.547131
10466	2026-03-14 16:00:00	4	1.28	220	644	t	2026-05-08 00:01:27.547131
10467	2026-03-14 16:00:00	7	1.29	220	329.7	t	2026-05-08 00:01:27.547131
10468	2026-03-14 16:30:00	1	2.09	220	349.9	t	2026-05-08 00:01:27.547131
10469	2026-03-14 16:30:00	4	2.14	220	417.4	t	2026-05-08 00:01:27.547131
10470	2026-03-14 16:30:00	7	2.68	220	531.7	t	2026-05-08 00:01:27.547131
10471	2026-03-14 17:00:00	1	2.48	220	283.5	t	2026-05-08 00:01:27.547131
10472	2026-03-14 17:00:00	4	1.76	220	512.8	t	2026-05-08 00:01:27.547131
10473	2026-03-14 17:00:00	7	2.71	220	382.9	t	2026-05-08 00:01:27.547131
10474	2026-03-14 17:30:00	1	1.14	220	630.7	t	2026-05-08 00:01:27.547131
10475	2026-03-14 17:30:00	4	2.54	220	487.2	t	2026-05-08 00:01:27.547131
10476	2026-03-14 17:30:00	7	2.06	220	451.2	t	2026-05-08 00:01:27.547131
10477	2026-03-14 18:00:00	1	2.87	220	506.8	t	2026-05-08 00:01:27.547131
10478	2026-03-14 18:00:00	4	2.62	220	365.6	t	2026-05-08 00:01:27.547131
10479	2026-03-14 18:00:00	7	2.98	220	242.4	t	2026-05-08 00:01:27.547131
10480	2026-03-14 18:30:00	1	2.95	220	409.3	t	2026-05-08 00:01:27.547131
10481	2026-03-14 18:30:00	4	1.22	220	556.4	t	2026-05-08 00:01:27.547131
10482	2026-03-14 18:30:00	7	2.06	220	337.3	t	2026-05-08 00:01:27.547131
10483	2026-03-14 19:00:00	1	1.44	220	358.2	t	2026-05-08 00:01:27.547131
10484	2026-03-14 19:00:00	4	1.32	220	526.2	t	2026-05-08 00:01:27.547131
10485	2026-03-14 19:00:00	7	2.15	220	468.7	t	2026-05-08 00:01:27.547131
10486	2026-03-14 19:30:00	1	2.7	220	482.5	t	2026-05-08 00:01:27.547131
10487	2026-03-14 19:30:00	4	1.85	220	529.1	t	2026-05-08 00:01:27.547131
10488	2026-03-14 19:30:00	7	1.27	220	515	t	2026-05-08 00:01:27.547131
10489	2026-03-14 20:00:00	1	2.12	220	522.9	t	2026-05-08 00:01:27.547131
10490	2026-03-14 20:00:00	4	2.16	220	469.8	t	2026-05-08 00:01:27.547131
10491	2026-03-14 20:00:00	7	1.71	220	225.5	t	2026-05-08 00:01:27.547131
10492	2026-03-14 20:30:00	1	2.33	220	305	t	2026-05-08 00:01:27.547131
10493	2026-03-14 20:30:00	4	1.79	220	579.6	t	2026-05-08 00:01:27.547131
10494	2026-03-14 20:30:00	7	1.71	220	237.8	t	2026-05-08 00:01:27.547131
10495	2026-03-14 21:00:00	1	1.4	220	562.7	t	2026-05-08 00:01:27.547131
10496	2026-03-14 21:00:00	4	1.23	220	458.6	t	2026-05-08 00:01:27.547131
10497	2026-03-14 21:00:00	7	1.93	220	634.5	t	2026-05-08 00:01:27.547131
10498	2026-03-14 21:30:00	1	2.71	220	606.9	t	2026-05-08 00:01:27.547131
10499	2026-03-14 21:30:00	4	1.4	220	605.8	t	2026-05-08 00:01:27.547131
10500	2026-03-14 21:30:00	7	2.38	220	469.6	t	2026-05-08 00:01:27.547131
10501	2026-03-14 22:00:00	1	1.86	220	626.4	t	2026-05-08 00:01:27.547131
10502	2026-03-14 22:00:00	4	2.13	220	429.1	t	2026-05-08 00:01:27.547131
10503	2026-03-14 22:00:00	7	2.47	220	612.2	t	2026-05-08 00:01:27.547131
10504	2026-03-14 22:30:00	1	1.69	220	595.2	t	2026-05-08 00:01:27.547131
10505	2026-03-14 22:30:00	4	2.69	220	531.9	t	2026-05-08 00:01:27.547131
10506	2026-03-14 22:30:00	7	2.4	220	236	t	2026-05-08 00:01:27.547131
10507	2026-03-14 23:00:00	1	2.91	220	487	t	2026-05-08 00:01:27.547131
10508	2026-03-14 23:00:00	4	2.7	220	608.5	t	2026-05-08 00:01:27.547131
10509	2026-03-14 23:00:00	7	2.51	220	640.9	t	2026-05-08 00:01:27.547131
10510	2026-03-14 23:30:00	1	2.02	220	652.7	t	2026-05-08 00:01:27.547131
10511	2026-03-14 23:30:00	4	2.18	220	361.4	t	2026-05-08 00:01:27.547131
10512	2026-03-14 23:30:00	7	2.84	220	448.1	t	2026-05-08 00:01:27.547131
10513	2026-03-15 00:00:00	1	1.01	220	277	t	2026-05-08 00:01:27.547131
10514	2026-03-15 00:00:00	4	1.57	220	230.1	t	2026-05-08 00:01:27.547131
10515	2026-03-15 00:00:00	7	2.11	220	614.2	t	2026-05-08 00:01:27.547131
10516	2026-03-15 00:30:00	1	2.35	220	644.7	t	2026-05-08 00:01:27.547131
10517	2026-03-15 00:30:00	4	2.96	220	521.5	t	2026-05-08 00:01:27.547131
10518	2026-03-15 00:30:00	7	1.75	220	333.2	t	2026-05-08 00:01:27.547131
10519	2026-03-15 01:00:00	1	1.74	220	239.3	t	2026-05-08 00:01:27.547131
10520	2026-03-15 01:00:00	4	1.74	220	227.7	t	2026-05-08 00:01:27.547131
10521	2026-03-15 01:00:00	7	1.9	220	350.2	t	2026-05-08 00:01:27.547131
10522	2026-03-15 01:30:00	1	2.61	220	273.5	t	2026-05-08 00:01:27.547131
10523	2026-03-15 01:30:00	4	1.02	220	559.6	t	2026-05-08 00:01:27.547131
10524	2026-03-15 01:30:00	7	1.98	220	343.4	t	2026-05-08 00:01:27.547131
10525	2026-03-15 02:00:00	1	2.01	220	245.5	t	2026-05-08 00:01:27.547131
10526	2026-03-15 02:00:00	4	1.91	220	434.8	t	2026-05-08 00:01:27.547131
10527	2026-03-15 02:00:00	7	1.25	220	344.3	t	2026-05-08 00:01:27.547131
10528	2026-03-15 02:30:00	1	1.42	220	314.5	t	2026-05-08 00:01:27.547131
10529	2026-03-15 02:30:00	4	1.4	220	655.1	t	2026-05-08 00:01:27.547131
10530	2026-03-15 02:30:00	7	2.43	220	368.9	t	2026-05-08 00:01:27.547131
10531	2026-03-15 03:00:00	1	1.99	220	307.9	t	2026-05-08 00:01:27.547131
10532	2026-03-15 03:00:00	4	1.34	220	523.3	t	2026-05-08 00:01:27.547131
10533	2026-03-15 03:00:00	7	1.39	220	419	t	2026-05-08 00:01:27.547131
10534	2026-03-15 03:30:00	1	2.74	220	519.6	t	2026-05-08 00:01:27.547131
10535	2026-03-15 03:30:00	4	1.9	220	395.2	t	2026-05-08 00:01:27.547131
10536	2026-03-15 03:30:00	7	1.85	220	443.9	t	2026-05-08 00:01:27.547131
10537	2026-03-15 04:00:00	1	1.88	220	288.1	t	2026-05-08 00:01:27.547131
10538	2026-03-15 04:00:00	4	2.85	220	361.8	t	2026-05-08 00:01:27.547131
10539	2026-03-15 04:00:00	7	2.72	220	505	t	2026-05-08 00:01:27.547131
10540	2026-03-15 04:30:00	1	2	220	535.6	t	2026-05-08 00:01:27.547131
10541	2026-03-15 04:30:00	4	2.93	220	629.7	t	2026-05-08 00:01:27.547131
10542	2026-03-15 04:30:00	7	1.26	220	455.7	t	2026-05-08 00:01:27.547131
10543	2026-03-15 05:00:00	1	2.98	220	638.8	t	2026-05-08 00:01:27.547131
10544	2026-03-15 05:00:00	4	1.73	220	454.2	t	2026-05-08 00:01:27.547131
10545	2026-03-15 05:00:00	7	1.53	220	256.7	t	2026-05-08 00:01:27.547131
10546	2026-03-15 05:30:00	1	1.89	220	331.7	t	2026-05-08 00:01:27.547131
10547	2026-03-15 05:30:00	4	2.62	220	381.3	t	2026-05-08 00:01:27.547131
10548	2026-03-15 05:30:00	7	1.1	220	322	t	2026-05-08 00:01:27.547131
10549	2026-03-15 06:00:00	1	2.36	220	320.6	t	2026-05-08 00:01:27.547131
10550	2026-03-15 06:00:00	4	1.18	220	497.8	t	2026-05-08 00:01:27.547131
10551	2026-03-15 06:00:00	7	2.54	220	297.2	t	2026-05-08 00:01:27.547131
10552	2026-03-15 06:30:00	1	1.59	220	448.9	t	2026-05-08 00:01:27.547131
10553	2026-03-15 06:30:00	4	2.72	220	355	t	2026-05-08 00:01:27.547131
10554	2026-03-15 06:30:00	7	2.87	220	568.3	t	2026-05-08 00:01:27.547131
10555	2026-03-15 07:00:00	1	2.43	220	387.4	t	2026-05-08 00:01:27.547131
10556	2026-03-15 07:00:00	4	2.64	220	249.6	t	2026-05-08 00:01:27.547131
10557	2026-03-15 07:00:00	7	2.87	220	558.9	t	2026-05-08 00:01:27.547131
10558	2026-03-15 07:30:00	1	2.45	220	525.4	t	2026-05-08 00:01:27.547131
10559	2026-03-15 07:30:00	4	2.02	220	600	t	2026-05-08 00:01:27.547131
10560	2026-03-15 07:30:00	7	1.82	220	326.8	t	2026-05-08 00:01:27.547131
10561	2026-03-15 08:00:00	1	2.67	220	440.7	t	2026-05-08 00:01:27.547131
10562	2026-03-15 08:00:00	4	1.49	220	295.5	t	2026-05-08 00:01:27.547131
10563	2026-03-15 08:00:00	7	2.62	220	350.6	t	2026-05-08 00:01:27.547131
10564	2026-03-15 08:30:00	1	1.76	220	307.8	t	2026-05-08 00:01:27.547131
10565	2026-03-15 08:30:00	4	2.26	220	312.3	t	2026-05-08 00:01:27.547131
10566	2026-03-15 08:30:00	7	2.83	220	600.7	t	2026-05-08 00:01:27.547131
10567	2026-03-15 09:00:00	1	2.02	220	266.3	t	2026-05-08 00:01:27.547131
10568	2026-03-15 09:00:00	4	3	220	245.2	t	2026-05-08 00:01:27.547131
10569	2026-03-15 09:00:00	7	1.77	220	291.2	t	2026-05-08 00:01:27.547131
10570	2026-03-15 09:30:00	1	2.76	220	498.9	t	2026-05-08 00:01:27.547131
10571	2026-03-15 09:30:00	4	2.94	220	613	t	2026-05-08 00:01:27.547131
10572	2026-03-15 09:30:00	7	2.9	220	554.5	t	2026-05-08 00:01:27.547131
10573	2026-03-15 10:00:00	1	1.18	220	336.6	t	2026-05-08 00:01:27.547131
10574	2026-03-15 10:00:00	4	1.56	220	511.4	t	2026-05-08 00:01:27.547131
10575	2026-03-15 10:00:00	7	2.14	220	510.4	t	2026-05-08 00:01:27.547131
10576	2026-03-15 10:30:00	1	2.43	220	359	t	2026-05-08 00:01:27.547131
10577	2026-03-15 10:30:00	4	2.31	220	613.5	t	2026-05-08 00:01:27.547131
10578	2026-03-15 10:30:00	7	2.59	220	578.3	t	2026-05-08 00:01:27.547131
10579	2026-03-15 11:00:00	1	1.35	220	593.2	t	2026-05-08 00:01:27.547131
10580	2026-03-15 11:00:00	4	1.27	220	261.9	t	2026-05-08 00:01:27.547131
10581	2026-03-15 11:00:00	7	2.98	220	278.4	t	2026-05-08 00:01:27.547131
10582	2026-03-15 11:30:00	1	2.01	220	548.5	t	2026-05-08 00:01:27.547131
10583	2026-03-15 11:30:00	4	1.47	220	547	t	2026-05-08 00:01:27.547131
10584	2026-03-15 11:30:00	7	2.33	220	236.7	t	2026-05-08 00:01:27.547131
10585	2026-03-15 12:00:00	1	2.39	220	516.2	t	2026-05-08 00:01:27.547131
10586	2026-03-15 12:00:00	4	1.49	220	225.2	t	2026-05-08 00:01:27.547131
10587	2026-03-15 12:00:00	7	2.5	220	286.4	t	2026-05-08 00:01:27.547131
10588	2026-03-15 12:30:00	1	1.82	220	253.1	t	2026-05-08 00:01:27.547131
10589	2026-03-15 12:30:00	4	1.5	220	257.1	t	2026-05-08 00:01:27.547131
10590	2026-03-15 12:30:00	7	1.86	220	465.4	t	2026-05-08 00:01:27.547131
10591	2026-03-15 13:00:00	1	2.85	220	237.1	t	2026-05-08 00:01:27.547131
10592	2026-03-15 13:00:00	4	2.4	220	328.8	t	2026-05-08 00:01:27.547131
10593	2026-03-15 13:00:00	7	2.26	220	359.7	t	2026-05-08 00:01:27.547131
10594	2026-03-15 13:30:00	1	2.78	220	428.5	t	2026-05-08 00:01:27.547131
10595	2026-03-15 13:30:00	4	2.27	220	436.9	t	2026-05-08 00:01:27.547131
10596	2026-03-15 13:30:00	7	2.53	220	247.5	t	2026-05-08 00:01:27.547131
10597	2026-03-15 14:00:00	1	2.21	220	330.6	t	2026-05-08 00:01:27.547131
10598	2026-03-15 14:00:00	4	1.53	220	413.9	t	2026-05-08 00:01:27.547131
10599	2026-03-15 14:00:00	7	2.57	220	439.7	t	2026-05-08 00:01:27.547131
10600	2026-03-15 14:30:00	1	2.87	220	451.7	t	2026-05-08 00:01:27.547131
10601	2026-03-15 14:30:00	4	2.07	220	280.9	t	2026-05-08 00:01:27.547131
10602	2026-03-15 14:30:00	7	1.86	220	425.5	t	2026-05-08 00:01:27.547131
10603	2026-03-15 15:00:00	1	1.79	220	577	t	2026-05-08 00:01:27.547131
10604	2026-03-15 15:00:00	4	2.23	220	567	t	2026-05-08 00:01:27.547131
10605	2026-03-15 15:00:00	7	2.37	220	622.3	t	2026-05-08 00:01:27.547131
10606	2026-03-15 15:30:00	1	2.93	220	280.2	t	2026-05-08 00:01:27.547131
10607	2026-03-15 15:30:00	4	1.68	220	571	t	2026-05-08 00:01:27.547131
10608	2026-03-15 15:30:00	7	1.16	220	584.2	t	2026-05-08 00:01:27.547131
10609	2026-03-15 16:00:00	1	2.82	220	339	t	2026-05-08 00:01:27.547131
10610	2026-03-15 16:00:00	4	1.66	220	646.4	t	2026-05-08 00:01:27.547131
10611	2026-03-15 16:00:00	7	2.33	220	476.9	t	2026-05-08 00:01:27.547131
10612	2026-03-15 16:30:00	1	2.83	220	301.2	t	2026-05-08 00:01:27.547131
10613	2026-03-15 16:30:00	4	2.82	220	450.2	t	2026-05-08 00:01:27.547131
10614	2026-03-15 16:30:00	7	1.78	220	277.3	t	2026-05-08 00:01:27.547131
10615	2026-03-15 17:00:00	1	2.29	220	530.7	t	2026-05-08 00:01:27.547131
10616	2026-03-15 17:00:00	4	1.76	220	501.4	t	2026-05-08 00:01:27.547131
10617	2026-03-15 17:00:00	7	2.8	220	432.4	t	2026-05-08 00:01:27.547131
10618	2026-03-15 17:30:00	1	1.67	220	380.3	t	2026-05-08 00:01:27.547131
10619	2026-03-15 17:30:00	4	2.18	220	375.6	t	2026-05-08 00:01:27.547131
10620	2026-03-15 17:30:00	7	2.49	220	325.4	t	2026-05-08 00:01:27.547131
10621	2026-03-15 18:00:00	1	1.3	220	452.6	t	2026-05-08 00:01:27.547131
10622	2026-03-15 18:00:00	4	1.92	220	549.9	t	2026-05-08 00:01:27.547131
10623	2026-03-15 18:00:00	7	1.26	220	292.6	t	2026-05-08 00:01:27.547131
10624	2026-03-15 18:30:00	1	2.53	220	345.1	t	2026-05-08 00:01:27.547131
10625	2026-03-15 18:30:00	4	2.26	220	263.2	t	2026-05-08 00:01:27.547131
10626	2026-03-15 18:30:00	7	1.48	220	535.6	t	2026-05-08 00:01:27.547131
10627	2026-03-15 19:00:00	1	2.17	220	351.5	t	2026-05-08 00:01:27.547131
10628	2026-03-15 19:00:00	4	2.03	220	500.6	t	2026-05-08 00:01:27.547131
10629	2026-03-15 19:00:00	7	2.34	220	287.1	t	2026-05-08 00:01:27.547131
10630	2026-03-15 19:30:00	1	2.7	220	454.8	t	2026-05-08 00:01:27.547131
10631	2026-03-15 19:30:00	4	1.98	220	321.1	t	2026-05-08 00:01:27.547131
10632	2026-03-15 19:30:00	7	1.51	220	506.2	t	2026-05-08 00:01:27.547131
10633	2026-03-15 20:00:00	1	1.99	220	363.2	t	2026-05-08 00:01:27.547131
10634	2026-03-15 20:00:00	4	1.93	220	295.8	t	2026-05-08 00:01:27.547131
10635	2026-03-15 20:00:00	7	2.92	220	501.7	t	2026-05-08 00:01:27.547131
10636	2026-03-15 20:30:00	1	2.1	220	235	t	2026-05-08 00:01:27.547131
10637	2026-03-15 20:30:00	4	1.18	220	403.8	t	2026-05-08 00:01:27.547131
10638	2026-03-15 20:30:00	7	2.04	220	251.9	t	2026-05-08 00:01:27.547131
10639	2026-03-15 21:00:00	1	2.81	220	378.1	t	2026-05-08 00:01:27.547131
10640	2026-03-15 21:00:00	4	1.86	220	462.5	t	2026-05-08 00:01:27.547131
10641	2026-03-15 21:00:00	7	2.98	220	572.5	t	2026-05-08 00:01:27.547131
10642	2026-03-15 21:30:00	1	2.89	220	460.6	t	2026-05-08 00:01:27.547131
10643	2026-03-15 21:30:00	4	1.6	220	473.9	t	2026-05-08 00:01:27.547131
10644	2026-03-15 21:30:00	7	2.8	220	353.5	t	2026-05-08 00:01:27.547131
10645	2026-03-15 22:00:00	1	1.85	220	459.9	t	2026-05-08 00:01:27.547131
10646	2026-03-15 22:00:00	4	1.31	220	225.6	t	2026-05-08 00:01:27.547131
10647	2026-03-15 22:00:00	7	1.17	220	337.1	t	2026-05-08 00:01:27.547131
10648	2026-03-15 22:30:00	1	2.85	220	250.1	t	2026-05-08 00:01:27.547131
10649	2026-03-15 22:30:00	4	2.26	220	358.2	t	2026-05-08 00:01:27.547131
10650	2026-03-15 22:30:00	7	1.64	220	354	t	2026-05-08 00:01:27.547131
10651	2026-03-15 23:00:00	1	1.17	220	523.9	t	2026-05-08 00:01:27.547131
10652	2026-03-15 23:00:00	4	1.72	220	224.1	t	2026-05-08 00:01:27.547131
10653	2026-03-15 23:00:00	7	2.57	220	330.9	t	2026-05-08 00:01:27.547131
10654	2026-03-15 23:30:00	1	1.17	220	639.2	t	2026-05-08 00:01:27.547131
10655	2026-03-15 23:30:00	4	1.95	220	347.5	t	2026-05-08 00:01:27.547131
10656	2026-03-15 23:30:00	7	1.07	220	367.9	t	2026-05-08 00:01:27.547131
10657	2026-03-16 00:00:00	1	1.53	220	718.6	t	2026-05-08 00:01:27.547131
10658	2026-03-16 00:00:00	4	2.35	220	278.9	t	2026-05-08 00:01:27.547131
10659	2026-03-16 00:00:00	7	3	220	305.3	t	2026-05-08 00:01:27.547131
10660	2026-03-16 00:30:00	1	1.48	220	631.2	t	2026-05-08 00:01:27.547131
10661	2026-03-16 00:30:00	4	1.24	220	402.7	t	2026-05-08 00:01:27.547131
10662	2026-03-16 00:30:00	7	1.77	220	390.3	t	2026-05-08 00:01:27.547131
10663	2026-03-16 01:00:00	1	1.76	220	705.5	t	2026-05-08 00:01:27.547131
10664	2026-03-16 01:00:00	4	1.66	220	549.4	t	2026-05-08 00:01:27.547131
10665	2026-03-16 01:00:00	7	2.7	220	522.5	t	2026-05-08 00:01:27.547131
10666	2026-03-16 01:30:00	1	1.42	220	387.1	t	2026-05-08 00:01:27.547131
10667	2026-03-16 01:30:00	4	3.33	220	718.9	t	2026-05-08 00:01:27.547131
10668	2026-03-16 01:30:00	7	1.22	220	794.6	t	2026-05-08 00:01:27.547131
10669	2026-03-16 02:00:00	1	1.39	220	739.4	t	2026-05-08 00:01:27.547131
10670	2026-03-16 02:00:00	4	2.05	220	280.6	t	2026-05-08 00:01:27.547131
10671	2026-03-16 02:00:00	7	1.45	220	503.5	t	2026-05-08 00:01:27.547131
10672	2026-03-16 02:30:00	1	2.25	220	686.5	t	2026-05-08 00:01:27.547131
10673	2026-03-16 02:30:00	4	2.35	220	463.6	t	2026-05-08 00:01:27.547131
10674	2026-03-16 02:30:00	7	3.67	220	400.9	t	2026-05-08 00:01:27.547131
10675	2026-03-16 03:00:00	1	3.64	220	388.7	t	2026-05-08 00:01:27.547131
10676	2026-03-16 03:00:00	4	2.58	220	619.6	t	2026-05-08 00:01:27.547131
10677	2026-03-16 03:00:00	7	1.74	220	670	t	2026-05-08 00:01:27.547131
10678	2026-03-16 03:30:00	1	2.64	220	642.3	t	2026-05-08 00:01:27.547131
10679	2026-03-16 03:30:00	4	1.33	220	618.3	t	2026-05-08 00:01:27.547131
10680	2026-03-16 03:30:00	7	1.31	220	495.2	t	2026-05-08 00:01:27.547131
10681	2026-03-16 04:00:00	1	1.21	220	387.1	t	2026-05-08 00:01:27.547131
10682	2026-03-16 04:00:00	4	2.5	220	439.3	t	2026-05-08 00:01:27.547131
10683	2026-03-16 04:00:00	7	3.29	220	567.6	t	2026-05-08 00:01:27.547131
10684	2026-03-16 04:30:00	1	3.05	220	694.7	t	2026-05-08 00:01:27.547131
10685	2026-03-16 04:30:00	4	2.14	220	768.4	t	2026-05-08 00:01:27.547131
10686	2026-03-16 04:30:00	7	1.86	220	543.6	t	2026-05-08 00:01:27.547131
10687	2026-03-16 05:00:00	1	1.58	220	606.6	t	2026-05-08 00:01:27.547131
10688	2026-03-16 05:00:00	4	1.65	220	386.3	t	2026-05-08 00:01:27.547131
10689	2026-03-16 05:00:00	7	3.36	220	340.1	t	2026-05-08 00:01:27.547131
10690	2026-03-16 05:30:00	1	3.21	220	344	t	2026-05-08 00:01:27.547131
10691	2026-03-16 05:30:00	4	1.79	220	673.4	t	2026-05-08 00:01:27.547131
10692	2026-03-16 05:30:00	7	1.56	220	568.8	t	2026-05-08 00:01:27.547131
10693	2026-03-16 06:00:00	1	1.47	220	339.2	t	2026-05-08 00:01:27.547131
10694	2026-03-16 06:00:00	4	1.71	220	517.7	t	2026-05-08 00:01:27.547131
10695	2026-03-16 06:00:00	7	1.27	220	426.4	t	2026-05-08 00:01:27.547131
10696	2026-03-16 06:30:00	1	1.62	220	491.9	t	2026-05-08 00:01:27.547131
10697	2026-03-16 06:30:00	4	2.94	220	811.2	t	2026-05-08 00:01:27.547131
10698	2026-03-16 06:30:00	7	3.65	220	530.2	t	2026-05-08 00:01:27.547131
10699	2026-03-16 07:00:00	1	12.54	220	2978.7	t	2026-05-08 00:01:27.547131
10700	2026-03-16 07:00:00	4	23.13	220	4660.6	t	2026-05-08 00:01:27.547131
10701	2026-03-16 07:00:00	7	27.98	220	5656.8	t	2026-05-08 00:01:27.547131
10702	2026-03-16 07:30:00	1	20.67	220	4438.2	t	2026-05-08 00:01:27.547131
10703	2026-03-16 07:30:00	4	24.78	220	4692.6	t	2026-05-08 00:01:27.547131
10704	2026-03-16 07:30:00	7	28.48	220	5650.3	t	2026-05-08 00:01:27.547131
10705	2026-03-16 08:00:00	1	18.09	220	3283.8	t	2026-05-08 00:01:27.547131
10706	2026-03-16 08:00:00	4	24.86	220	4416.7	t	2026-05-08 00:01:27.547131
10707	2026-03-16 08:00:00	7	26.58	220	5380.3	t	2026-05-08 00:01:27.547131
10708	2026-03-16 08:30:00	1	15.34	220	4587.7	t	2026-05-08 00:01:27.547131
10709	2026-03-16 08:30:00	4	21.3	220	4864.7	t	2026-05-08 00:01:27.547131
10710	2026-03-16 08:30:00	7	21.76	220	4530.3	t	2026-05-08 00:01:27.547131
10711	2026-03-16 09:00:00	1	15.19	220	4439.3	t	2026-05-08 00:01:27.547131
10712	2026-03-16 09:00:00	4	17.68	220	5412.5	t	2026-05-08 00:01:27.547131
10713	2026-03-16 09:00:00	7	28.04	220	6684.8	t	2026-05-08 00:01:27.547131
10714	2026-03-16 09:30:00	1	15.9	220	4450.6	t	2026-05-08 00:01:27.547131
10715	2026-03-16 09:30:00	4	22.94	220	3654.1	t	2026-05-08 00:01:27.547131
10716	2026-03-16 09:30:00	7	24.87	220	4646.9	t	2026-05-08 00:01:27.547131
10717	2026-03-16 10:00:00	1	15.74	220	3244	t	2026-05-08 00:01:27.547131
10718	2026-03-16 10:00:00	4	21.86	220	5222.8	t	2026-05-08 00:01:27.547131
10719	2026-03-16 10:00:00	7	21.64	220	6168.1	t	2026-05-08 00:01:27.547131
10720	2026-03-16 10:30:00	1	16.76	220	4314.1	t	2026-05-08 00:01:27.547131
10721	2026-03-16 10:30:00	4	20.22	220	4165.3	t	2026-05-08 00:01:27.547131
10722	2026-03-16 10:30:00	7	29.84	220	5313.4	t	2026-05-08 00:01:27.547131
10723	2026-03-16 11:00:00	1	17.64	220	3275.6	t	2026-05-08 00:01:27.547131
10724	2026-03-16 11:00:00	4	19.04	220	5512.9	t	2026-05-08 00:01:27.547131
10725	2026-03-16 11:00:00	7	28.93	220	5405.6	t	2026-05-08 00:01:27.547131
10726	2026-03-16 11:30:00	1	13.32	220	4324	t	2026-05-08 00:01:27.547131
10727	2026-03-16 11:30:00	4	21.99	220	5164.9	t	2026-05-08 00:01:27.547131
10728	2026-03-16 11:30:00	7	25.1	220	5660.9	t	2026-05-08 00:01:27.547131
10729	2026-03-16 12:00:00	1	12.12	220	2606	t	2026-05-08 00:01:27.547131
10730	2026-03-16 12:00:00	4	25.53	220	4952.8	t	2026-05-08 00:01:27.547131
10731	2026-03-16 12:00:00	7	23.97	220	6520.6	t	2026-05-08 00:01:27.547131
10732	2026-03-16 12:30:00	1	11.92	220	4284.4	t	2026-05-08 00:01:27.547131
10733	2026-03-16 12:30:00	4	20.23	220	4379.7	t	2026-05-08 00:01:27.547131
10734	2026-03-16 12:30:00	7	30.02	220	6351.4	t	2026-05-08 00:01:27.547131
10735	2026-03-16 13:00:00	1	20.67	220	2709.7	t	2026-05-08 00:01:27.547131
10736	2026-03-16 13:00:00	4	17.59	220	4806.1	t	2026-05-08 00:01:27.547131
10737	2026-03-16 13:00:00	7	25.17	220	6196.7	t	2026-05-08 00:01:27.547131
10738	2026-03-16 13:30:00	1	17.27	220	3469.6	t	2026-05-08 00:01:27.547131
10739	2026-03-16 13:30:00	4	24.2	220	4393.1	t	2026-05-08 00:01:27.547131
10740	2026-03-16 13:30:00	7	25.53	220	6456.2	t	2026-05-08 00:01:27.547131
10741	2026-03-16 14:00:00	1	20.4	220	2680.8	t	2026-05-08 00:01:27.547131
10742	2026-03-16 14:00:00	4	24.47	220	4095.7	t	2026-05-08 00:01:27.547131
10743	2026-03-16 14:00:00	7	24.98	220	4849.4	t	2026-05-08 00:01:27.547131
10744	2026-03-16 14:30:00	1	13.51	220	4503.7	t	2026-05-08 00:01:27.547131
10745	2026-03-16 14:30:00	4	18.59	220	3856.2	t	2026-05-08 00:01:27.547131
10746	2026-03-16 14:30:00	7	26.55	220	4733.2	t	2026-05-08 00:01:27.547131
10747	2026-03-16 15:00:00	1	20.54	220	4532.1	t	2026-05-08 00:01:27.547131
10748	2026-03-16 15:00:00	4	20.91	220	4691	t	2026-05-08 00:01:27.547131
10749	2026-03-16 15:00:00	7	28.18	220	6697.6	t	2026-05-08 00:01:27.547131
10750	2026-03-16 15:30:00	1	20.99	220	4224.1	t	2026-05-08 00:01:27.547131
10751	2026-03-16 15:30:00	4	21.15	220	5465.6	t	2026-05-08 00:01:27.547131
10752	2026-03-16 15:30:00	7	26.06	220	6688.1	t	2026-05-08 00:01:27.547131
10753	2026-03-16 16:00:00	1	17.02	220	4287.7	t	2026-05-08 00:01:27.547131
10754	2026-03-16 16:00:00	4	22.93	220	5353.1	t	2026-05-08 00:01:27.547131
10755	2026-03-16 16:00:00	7	21.52	220	4777.1	t	2026-05-08 00:01:27.547131
10756	2026-03-16 16:30:00	1	18.03	220	3758.1	t	2026-05-08 00:01:27.547131
10757	2026-03-16 16:30:00	4	17.85	220	5069.4	t	2026-05-08 00:01:27.547131
10758	2026-03-16 16:30:00	7	26.99	220	4659.6	t	2026-05-08 00:01:27.547131
10759	2026-03-16 17:00:00	1	13.48	220	4119.4	t	2026-05-08 00:01:27.547131
10760	2026-03-16 17:00:00	4	20.24	220	4768.7	t	2026-05-08 00:01:27.547131
10761	2026-03-16 17:00:00	7	22.96	220	5219.1	t	2026-05-08 00:01:27.547131
10762	2026-03-16 17:30:00	1	19.16	220	3085.4	t	2026-05-08 00:01:27.547131
10763	2026-03-16 17:30:00	4	18.84	220	5185.6	t	2026-05-08 00:01:27.547131
10764	2026-03-16 17:30:00	7	29.88	220	6087.5	t	2026-05-08 00:01:27.547131
10765	2026-03-16 18:00:00	1	18.65	220	2867.6	t	2026-05-08 00:01:27.547131
10766	2026-03-16 18:00:00	4	16.11	220	4277.6	t	2026-05-08 00:01:27.547131
10767	2026-03-16 18:00:00	7	27.45	220	5534.6	t	2026-05-08 00:01:27.547131
10768	2026-03-16 18:30:00	1	13.94	220	3133.3	t	2026-05-08 00:01:27.547131
10769	2026-03-16 18:30:00	4	21.04	220	4464.8	t	2026-05-08 00:01:27.547131
10770	2026-03-16 18:30:00	7	26.43	220	4626.4	t	2026-05-08 00:01:27.547131
10771	2026-03-16 19:00:00	1	12.41	220	4648.3	t	2026-05-08 00:01:27.547131
10772	2026-03-16 19:00:00	4	23.8	220	5178.8	t	2026-05-08 00:01:27.547131
10773	2026-03-16 19:00:00	7	26.81	220	5741.3	t	2026-05-08 00:01:27.547131
10774	2026-03-16 19:30:00	1	20.39	220	3484.6	t	2026-05-08 00:01:27.547131
10775	2026-03-16 19:30:00	4	18.42	220	4978.1	t	2026-05-08 00:01:27.547131
10776	2026-03-16 19:30:00	7	27.27	220	5273.4	t	2026-05-08 00:01:27.547131
10777	2026-03-16 20:00:00	1	2.11	220	699.5	t	2026-05-08 00:01:27.547131
10778	2026-03-16 20:00:00	4	1.78	220	606.6	t	2026-05-08 00:01:27.547131
10779	2026-03-16 20:00:00	7	1.22	220	751.8	t	2026-05-08 00:01:27.547131
10780	2026-03-16 20:30:00	1	3.51	220	717.9	t	2026-05-08 00:01:27.547131
10781	2026-03-16 20:30:00	4	3.01	220	779.9	t	2026-05-08 00:01:27.547131
10782	2026-03-16 20:30:00	7	2.24	220	720.4	t	2026-05-08 00:01:27.547131
10783	2026-03-16 21:00:00	1	3.24	220	517.1	t	2026-05-08 00:01:27.547131
10784	2026-03-16 21:00:00	4	2.29	220	573.6	t	2026-05-08 00:01:27.547131
10785	2026-03-16 21:00:00	7	1.96	220	402	t	2026-05-08 00:01:27.547131
10786	2026-03-16 21:30:00	1	2	220	297.3	t	2026-05-08 00:01:27.547131
10787	2026-03-16 21:30:00	4	1.84	220	289.4	t	2026-05-08 00:01:27.547131
10788	2026-03-16 21:30:00	7	1.58	220	526.3	t	2026-05-08 00:01:27.547131
10789	2026-03-16 22:00:00	1	1.3	220	733.8	t	2026-05-08 00:01:27.547131
10790	2026-03-16 22:00:00	4	3.09	220	569.7	t	2026-05-08 00:01:27.547131
10791	2026-03-16 22:00:00	7	2.61	220	598.3	t	2026-05-08 00:01:27.547131
10792	2026-03-16 22:30:00	1	3.12	220	507	t	2026-05-08 00:01:27.547131
10793	2026-03-16 22:30:00	4	2.95	220	605.7	t	2026-05-08 00:01:27.547131
10794	2026-03-16 22:30:00	7	3.2	220	268.9	t	2026-05-08 00:01:27.547131
10795	2026-03-16 23:00:00	1	3.08	220	489.1	t	2026-05-08 00:01:27.547131
10796	2026-03-16 23:00:00	4	1.26	220	323.8	t	2026-05-08 00:01:27.547131
10797	2026-03-16 23:00:00	7	1.54	220	440.3	t	2026-05-08 00:01:27.547131
10798	2026-03-16 23:30:00	1	2.33	220	652.3	t	2026-05-08 00:01:27.547131
10799	2026-03-16 23:30:00	4	2.59	220	624.6	t	2026-05-08 00:01:27.547131
10800	2026-03-16 23:30:00	7	3.66	220	453.8	t	2026-05-08 00:01:27.547131
10801	2026-03-17 00:00:00	1	2.27	220	669.7	t	2026-05-08 00:01:27.547131
10802	2026-03-17 00:00:00	4	2.24	220	489.8	t	2026-05-08 00:01:27.547131
10803	2026-03-17 00:00:00	7	2.84	220	474.9	t	2026-05-08 00:01:27.547131
10804	2026-03-17 00:30:00	1	1.8	220	670.9	t	2026-05-08 00:01:27.547131
10805	2026-03-17 00:30:00	4	3.2	220	398.7	t	2026-05-08 00:01:27.547131
10806	2026-03-17 00:30:00	7	1.24	220	284.2	t	2026-05-08 00:01:27.547131
10807	2026-03-17 01:00:00	1	2.44	220	563.7	t	2026-05-08 00:01:27.547131
10808	2026-03-17 01:00:00	4	3.19	220	267.6	t	2026-05-08 00:01:27.547131
10809	2026-03-17 01:00:00	7	2.96	220	492.2	t	2026-05-08 00:01:27.547131
10810	2026-03-17 01:30:00	1	2	220	730.8	t	2026-05-08 00:01:27.547131
10811	2026-03-17 01:30:00	4	2.84	220	717	t	2026-05-08 00:01:27.547131
10812	2026-03-17 01:30:00	7	2.51	220	745.3	t	2026-05-08 00:01:27.547131
10813	2026-03-17 02:00:00	1	3.16	220	434.2	t	2026-05-08 00:01:27.547131
10814	2026-03-17 02:00:00	4	1.99	220	761.1	t	2026-05-08 00:01:27.547131
10815	2026-03-17 02:00:00	7	2.72	220	502.5	t	2026-05-08 00:01:27.547131
10816	2026-03-17 02:30:00	1	2.53	220	610.7	t	2026-05-08 00:01:27.547131
10817	2026-03-17 02:30:00	4	2.74	220	753.6	t	2026-05-08 00:01:27.547131
10818	2026-03-17 02:30:00	7	1.75	220	499.5	t	2026-05-08 00:01:27.547131
10819	2026-03-17 03:00:00	1	1.21	220	640	t	2026-05-08 00:01:27.547131
10820	2026-03-17 03:00:00	4	1.38	220	445.5	t	2026-05-08 00:01:27.547131
10821	2026-03-17 03:00:00	7	2.76	220	625.6	t	2026-05-08 00:01:27.547131
10822	2026-03-17 03:30:00	1	3.16	220	378.4	t	2026-05-08 00:01:27.547131
10823	2026-03-17 03:30:00	4	2.99	220	568.1	t	2026-05-08 00:01:27.547131
10824	2026-03-17 03:30:00	7	2.12	220	808.3	t	2026-05-08 00:01:27.547131
10825	2026-03-17 04:00:00	1	3.11	220	636.5	t	2026-05-08 00:01:27.547131
10826	2026-03-17 04:00:00	4	3.25	220	704	t	2026-05-08 00:01:27.547131
10827	2026-03-17 04:00:00	7	3.11	220	403.3	t	2026-05-08 00:01:27.547131
10828	2026-03-17 04:30:00	1	2.7	220	599.2	t	2026-05-08 00:01:27.547131
10829	2026-03-17 04:30:00	4	1.24	220	284.3	t	2026-05-08 00:01:27.547131
10830	2026-03-17 04:30:00	7	3.4	220	808.6	t	2026-05-08 00:01:27.547131
10831	2026-03-17 05:00:00	1	2.14	220	628	t	2026-05-08 00:01:27.547131
10832	2026-03-17 05:00:00	4	1.49	220	622.3	t	2026-05-08 00:01:27.547131
10833	2026-03-17 05:00:00	7	1.25	220	546.2	t	2026-05-08 00:01:27.547131
10834	2026-03-17 05:30:00	1	2.59	220	793.9	t	2026-05-08 00:01:27.547131
10835	2026-03-17 05:30:00	4	3.52	220	445.6	t	2026-05-08 00:01:27.547131
10836	2026-03-17 05:30:00	7	1.62	220	463.4	t	2026-05-08 00:01:27.547131
10837	2026-03-17 06:00:00	1	1.54	220	737.7	t	2026-05-08 00:01:27.547131
10838	2026-03-17 06:00:00	4	2.85	220	755.5	t	2026-05-08 00:01:27.547131
10839	2026-03-17 06:00:00	7	3.61	220	481.5	t	2026-05-08 00:01:27.547131
10840	2026-03-17 06:30:00	1	1.74	220	298.6	t	2026-05-08 00:01:27.547131
10841	2026-03-17 06:30:00	4	1.32	220	563.9	t	2026-05-08 00:01:27.547131
10842	2026-03-17 06:30:00	7	3.55	220	584.7	t	2026-05-08 00:01:27.547131
10843	2026-03-17 07:00:00	1	21.46	220	4356.5	t	2026-05-08 00:01:27.547131
10844	2026-03-17 07:00:00	4	17.72	220	3625.1	t	2026-05-08 00:01:27.547131
10845	2026-03-17 07:00:00	7	29.72	220	4638.8	t	2026-05-08 00:01:27.547131
10846	2026-03-17 07:30:00	1	12.99	220	3309.7	t	2026-05-08 00:01:27.547131
10847	2026-03-17 07:30:00	4	21.44	220	3591.7	t	2026-05-08 00:01:27.547131
10848	2026-03-17 07:30:00	7	26.86	220	6585.3	t	2026-05-08 00:01:27.547131
10849	2026-03-17 08:00:00	1	13.62	220	3044.3	t	2026-05-08 00:01:27.547131
10850	2026-03-17 08:00:00	4	25.35	220	4312.2	t	2026-05-08 00:01:27.547131
10851	2026-03-17 08:00:00	7	23.31	220	5013.5	t	2026-05-08 00:01:27.547131
10852	2026-03-17 08:30:00	1	11.89	220	2694	t	2026-05-08 00:01:27.547131
10853	2026-03-17 08:30:00	4	21.75	220	3931.2	t	2026-05-08 00:01:27.547131
10854	2026-03-17 08:30:00	7	21.09	220	5813.8	t	2026-05-08 00:01:27.547131
10855	2026-03-17 09:00:00	1	21.37	220	4197.3	t	2026-05-08 00:01:27.547131
10856	2026-03-17 09:00:00	4	18.77	220	5460.9	t	2026-05-08 00:01:27.547131
10857	2026-03-17 09:00:00	7	24.24	220	6540.9	t	2026-05-08 00:01:27.547131
10858	2026-03-17 09:30:00	1	11.92	220	2746.6	t	2026-05-08 00:01:27.547131
10859	2026-03-17 09:30:00	4	24.9	220	3994	t	2026-05-08 00:01:27.547131
10860	2026-03-17 09:30:00	7	25.66	220	6292.8	t	2026-05-08 00:01:27.547131
10861	2026-03-17 10:00:00	1	17.98	220	2609.9	t	2026-05-08 00:01:27.547131
10862	2026-03-17 10:00:00	4	22	220	4649.6	t	2026-05-08 00:01:27.547131
10863	2026-03-17 10:00:00	7	24.15	220	6316.8	t	2026-05-08 00:01:27.547131
10864	2026-03-17 10:30:00	1	16.56	220	2811.5	t	2026-05-08 00:01:27.547131
10865	2026-03-17 10:30:00	4	22.42	220	5135.3	t	2026-05-08 00:01:27.547131
10866	2026-03-17 10:30:00	7	22.82	220	4996	t	2026-05-08 00:01:27.547131
10867	2026-03-17 11:00:00	1	14.65	220	3979.2	t	2026-05-08 00:01:27.547131
10868	2026-03-17 11:00:00	4	23.51	220	5609.8	t	2026-05-08 00:01:27.547131
10869	2026-03-17 11:00:00	7	29.5	220	5594	t	2026-05-08 00:01:27.547131
10870	2026-03-17 11:30:00	1	16.53	220	3027.6	t	2026-05-08 00:01:27.547131
10871	2026-03-17 11:30:00	4	21.92	220	5104	t	2026-05-08 00:01:27.547131
10872	2026-03-17 11:30:00	7	29	220	6461.7	t	2026-05-08 00:01:27.547131
10873	2026-03-17 12:00:00	1	11.73	220	3084.7	t	2026-05-08 00:01:27.547131
10874	2026-03-17 12:00:00	4	16.14	220	4653.9	t	2026-05-08 00:01:27.547131
10875	2026-03-17 12:00:00	7	23.52	220	6261.8	t	2026-05-08 00:01:27.547131
10876	2026-03-17 12:30:00	1	12.46	220	2800.8	t	2026-05-08 00:01:27.547131
10877	2026-03-17 12:30:00	4	24.72	220	4905.4	t	2026-05-08 00:01:27.547131
10878	2026-03-17 12:30:00	7	22.44	220	5418.8	t	2026-05-08 00:01:27.547131
10879	2026-03-17 13:00:00	1	13.95	220	3852.5	t	2026-05-08 00:01:27.547131
10880	2026-03-17 13:00:00	4	19.36	220	4579.5	t	2026-05-08 00:01:27.547131
10881	2026-03-17 13:00:00	7	25.11	220	5061.6	t	2026-05-08 00:01:27.547131
10882	2026-03-17 13:30:00	1	16.07	220	2712.4	t	2026-05-08 00:01:27.547131
10883	2026-03-17 13:30:00	4	18.57	220	5258	t	2026-05-08 00:01:27.547131
10884	2026-03-17 13:30:00	7	27.91	220	5760.9	t	2026-05-08 00:01:27.547131
10885	2026-03-17 14:00:00	1	12.48	220	3866.5	t	2026-05-08 00:01:27.547131
10886	2026-03-17 14:00:00	4	24.04	220	3606.6	t	2026-05-08 00:01:27.547131
10887	2026-03-17 14:00:00	7	28.45	220	6703.5	t	2026-05-08 00:01:27.547131
10888	2026-03-17 14:30:00	1	15.77	220	4563.9	t	2026-05-08 00:01:27.547131
10889	2026-03-17 14:30:00	4	25.55	220	4147.4	t	2026-05-08 00:01:27.547131
10890	2026-03-17 14:30:00	7	23.37	220	6181.9	t	2026-05-08 00:01:27.547131
10891	2026-03-17 15:00:00	1	12.15	220	3010.6	t	2026-05-08 00:01:27.547131
10892	2026-03-17 15:00:00	4	21.92	220	4039.7	t	2026-05-08 00:01:27.547131
10893	2026-03-17 15:00:00	7	25.61	220	5073.4	t	2026-05-08 00:01:27.547131
10894	2026-03-17 15:30:00	1	14.43	220	3257.7	t	2026-05-08 00:01:27.547131
10895	2026-03-17 15:30:00	4	22.81	220	3863.1	t	2026-05-08 00:01:27.547131
10896	2026-03-17 15:30:00	7	25.22	220	4993.4	t	2026-05-08 00:01:27.547131
10897	2026-03-17 16:00:00	1	20.43	220	3740.6	t	2026-05-08 00:01:27.547131
10898	2026-03-17 16:00:00	4	21.47	220	3627.8	t	2026-05-08 00:01:27.547131
10899	2026-03-17 16:00:00	7	27.44	220	5073.4	t	2026-05-08 00:01:27.547131
10900	2026-03-17 16:30:00	1	20.79	220	3487.4	t	2026-05-08 00:01:27.547131
10901	2026-03-17 16:30:00	4	18.54	220	4227.7	t	2026-05-08 00:01:27.547131
10902	2026-03-17 16:30:00	7	29.53	220	4622.3	t	2026-05-08 00:01:27.547131
10903	2026-03-17 17:00:00	1	20.38	220	3456.1	t	2026-05-08 00:01:27.547131
10904	2026-03-17 17:00:00	4	17.6	220	3914.5	t	2026-05-08 00:01:27.547131
10905	2026-03-17 17:00:00	7	25.53	220	5544.1	t	2026-05-08 00:01:27.547131
10906	2026-03-17 17:30:00	1	20.64	220	3012	t	2026-05-08 00:01:27.547131
10907	2026-03-17 17:30:00	4	25.52	220	4563.3	t	2026-05-08 00:01:27.547131
10908	2026-03-17 17:30:00	7	24.84	220	4680.9	t	2026-05-08 00:01:27.547131
10909	2026-03-17 18:00:00	1	12.99	220	3097.7	t	2026-05-08 00:01:27.547131
10910	2026-03-17 18:00:00	4	22.91	220	4693.7	t	2026-05-08 00:01:27.547131
10911	2026-03-17 18:00:00	7	29.4	220	4711.4	t	2026-05-08 00:01:27.547131
10912	2026-03-17 18:30:00	1	18.15	220	4550.8	t	2026-05-08 00:01:27.547131
10913	2026-03-17 18:30:00	4	20.06	220	5379.5	t	2026-05-08 00:01:27.547131
10914	2026-03-17 18:30:00	7	27.92	220	6430.7	t	2026-05-08 00:01:27.547131
10915	2026-03-17 19:00:00	1	15.27	220	4576.8	t	2026-05-08 00:01:27.547131
10916	2026-03-17 19:00:00	4	17.26	220	5051.9	t	2026-05-08 00:01:27.547131
10917	2026-03-17 19:00:00	7	30.06	220	5263.3	t	2026-05-08 00:01:27.547131
10918	2026-03-17 19:30:00	1	16.96	220	3959.4	t	2026-05-08 00:01:27.547131
10919	2026-03-17 19:30:00	4	21.51	220	5217.9	t	2026-05-08 00:01:27.547131
10920	2026-03-17 19:30:00	7	26.81	220	6541.4	t	2026-05-08 00:01:27.547131
10921	2026-03-17 20:00:00	1	1.24	220	534.1	t	2026-05-08 00:01:27.547131
10922	2026-03-17 20:00:00	4	2.03	220	547.1	t	2026-05-08 00:01:27.547131
10923	2026-03-17 20:00:00	7	3.55	220	356.1	t	2026-05-08 00:01:27.547131
10924	2026-03-17 20:30:00	1	1.8	220	387.9	t	2026-05-08 00:01:27.547131
10925	2026-03-17 20:30:00	4	3.22	220	324.7	t	2026-05-08 00:01:27.547131
10926	2026-03-17 20:30:00	7	1.69	220	639.1	t	2026-05-08 00:01:27.547131
10927	2026-03-17 21:00:00	1	3.67	220	385	t	2026-05-08 00:01:27.547131
10928	2026-03-17 21:00:00	4	2.19	220	742.7	t	2026-05-08 00:01:27.547131
10929	2026-03-17 21:00:00	7	3.59	220	477.6	t	2026-05-08 00:01:27.547131
10930	2026-03-17 21:30:00	1	1.21	220	356.3	t	2026-05-08 00:01:27.547131
10931	2026-03-17 21:30:00	4	1.99	220	613.3	t	2026-05-08 00:01:27.547131
10932	2026-03-17 21:30:00	7	2.98	220	693.9	t	2026-05-08 00:01:27.547131
10933	2026-03-17 22:00:00	1	2.87	220	707.4	t	2026-05-08 00:01:27.547131
10934	2026-03-17 22:00:00	4	2.89	220	496.8	t	2026-05-08 00:01:27.547131
10935	2026-03-17 22:00:00	7	2.96	220	380	t	2026-05-08 00:01:27.547131
10936	2026-03-17 22:30:00	1	3.31	220	534.8	t	2026-05-08 00:01:27.547131
10937	2026-03-17 22:30:00	4	2.32	220	635.3	t	2026-05-08 00:01:27.547131
10938	2026-03-17 22:30:00	7	3.25	220	489	t	2026-05-08 00:01:27.547131
10939	2026-03-17 23:00:00	1	2	220	356.1	t	2026-05-08 00:01:27.547131
10940	2026-03-17 23:00:00	4	3.18	220	464.7	t	2026-05-08 00:01:27.547131
10941	2026-03-17 23:00:00	7	3.34	220	289.3	t	2026-05-08 00:01:27.547131
10942	2026-03-17 23:30:00	1	2.39	220	303.1	t	2026-05-08 00:01:27.547131
10943	2026-03-17 23:30:00	4	3.43	220	621.6	t	2026-05-08 00:01:27.547131
10944	2026-03-17 23:30:00	7	3.45	220	741	t	2026-05-08 00:01:27.547131
10945	2026-03-18 00:00:00	1	2.61	220	472.3	t	2026-05-08 00:01:27.547131
10946	2026-03-18 00:00:00	4	3.56	220	595.1	t	2026-05-08 00:01:27.547131
10947	2026-03-18 00:00:00	7	3.21	220	409.8	t	2026-05-08 00:01:27.547131
10948	2026-03-18 00:30:00	1	2.75	220	646.5	t	2026-05-08 00:01:27.547131
10949	2026-03-18 00:30:00	4	2.86	220	469.7	t	2026-05-08 00:01:27.547131
10950	2026-03-18 00:30:00	7	3.18	220	755.8	t	2026-05-08 00:01:27.547131
10951	2026-03-18 01:00:00	1	3.38	220	713.7	t	2026-05-08 00:01:27.547131
10952	2026-03-18 01:00:00	4	1.88	220	731.7	t	2026-05-08 00:01:27.547131
10953	2026-03-18 01:00:00	7	2.03	220	342	t	2026-05-08 00:01:27.547131
10954	2026-03-18 01:30:00	1	2.02	220	377.9	t	2026-05-08 00:01:27.547131
10955	2026-03-18 01:30:00	4	3.09	220	492.3	t	2026-05-08 00:01:27.547131
10956	2026-03-18 01:30:00	7	1.91	220	487.8	t	2026-05-08 00:01:27.547131
10957	2026-03-18 02:00:00	1	2.95	220	738.9	t	2026-05-08 00:01:27.547131
10958	2026-03-18 02:00:00	4	1.26	220	628.6	t	2026-05-08 00:01:27.547131
10959	2026-03-18 02:00:00	7	1.64	220	550.1	t	2026-05-08 00:01:27.547131
10960	2026-03-18 02:30:00	1	3.32	220	425.5	t	2026-05-08 00:01:27.547131
10961	2026-03-18 02:30:00	4	2.6	220	591.7	t	2026-05-08 00:01:27.547131
10962	2026-03-18 02:30:00	7	1.88	220	274	t	2026-05-08 00:01:27.547131
10963	2026-03-18 03:00:00	1	3.26	220	763.8	t	2026-05-08 00:01:27.547131
10964	2026-03-18 03:00:00	4	2.8	220	672.7	t	2026-05-08 00:01:27.547131
10965	2026-03-18 03:00:00	7	3.33	220	366.3	t	2026-05-08 00:01:27.547131
10966	2026-03-18 03:30:00	1	3.48	220	276.9	t	2026-05-08 00:01:27.547131
10967	2026-03-18 03:30:00	4	3.29	220	492.3	t	2026-05-08 00:01:27.547131
10968	2026-03-18 03:30:00	7	2.11	220	804.9	t	2026-05-08 00:01:27.547131
10969	2026-03-18 04:00:00	1	1.92	220	446.3	t	2026-05-08 00:01:27.547131
10970	2026-03-18 04:00:00	4	1.39	220	780.6	t	2026-05-08 00:01:27.547131
10971	2026-03-18 04:00:00	7	2.96	220	764.5	t	2026-05-08 00:01:27.547131
10972	2026-03-18 04:30:00	1	2.75	220	441.5	t	2026-05-08 00:01:27.547131
10973	2026-03-18 04:30:00	4	3.65	220	374.2	t	2026-05-08 00:01:27.547131
10974	2026-03-18 04:30:00	7	2.13	220	351.5	t	2026-05-08 00:01:27.547131
10975	2026-03-18 05:00:00	1	3.52	220	785.7	t	2026-05-08 00:01:27.547131
10976	2026-03-18 05:00:00	4	3.18	220	753.5	t	2026-05-08 00:01:27.547131
10977	2026-03-18 05:00:00	7	1.77	220	709.7	t	2026-05-08 00:01:27.547131
10978	2026-03-18 05:30:00	1	2.53	220	548.9	t	2026-05-08 00:01:27.547131
10979	2026-03-18 05:30:00	4	1.57	220	657.7	t	2026-05-08 00:01:27.547131
10980	2026-03-18 05:30:00	7	3.17	220	304.1	t	2026-05-08 00:01:27.547131
10981	2026-03-18 06:00:00	1	3.62	220	796.1	t	2026-05-08 00:01:27.547131
10982	2026-03-18 06:00:00	4	3.37	220	668.8	t	2026-05-08 00:01:27.547131
10983	2026-03-18 06:00:00	7	3.57	220	702	t	2026-05-08 00:01:27.547131
10984	2026-03-18 06:30:00	1	3.2	220	596	t	2026-05-08 00:01:27.547131
10985	2026-03-18 06:30:00	4	2.97	220	545.4	t	2026-05-08 00:01:27.547131
10986	2026-03-18 06:30:00	7	3.32	220	564.3	t	2026-05-08 00:01:27.547131
10987	2026-03-18 07:00:00	1	15.47	220	4462.9	t	2026-05-08 00:01:27.547131
10988	2026-03-18 07:00:00	4	21.97	220	4321.1	t	2026-05-08 00:01:27.547131
10989	2026-03-18 07:00:00	7	30.47	220	6436.6	t	2026-05-08 00:01:27.547131
10990	2026-03-18 07:30:00	1	15.57	220	3074.3	t	2026-05-08 00:01:27.547131
10991	2026-03-18 07:30:00	4	17.3	220	5237.6	t	2026-05-08 00:01:27.547131
10992	2026-03-18 07:30:00	7	23.9	220	6057.9	t	2026-05-08 00:01:27.547131
10993	2026-03-18 08:00:00	1	13.37	220	4004.4	t	2026-05-08 00:01:27.547131
10994	2026-03-18 08:00:00	4	25.21	220	5463.4	t	2026-05-08 00:01:27.547131
10995	2026-03-18 08:00:00	7	21.5	220	6359.9	t	2026-05-08 00:01:27.547131
10996	2026-03-18 08:30:00	1	13.84	220	4386.8	t	2026-05-08 00:01:27.547131
10997	2026-03-18 08:30:00	4	21.49	220	5659.1	t	2026-05-08 00:01:27.547131
10998	2026-03-18 08:30:00	7	29.08	220	5843.8	t	2026-05-08 00:01:27.547131
10999	2026-03-18 09:00:00	1	14.49	220	4153.8	t	2026-05-08 00:01:27.547131
11000	2026-03-18 09:00:00	4	19.22	220	4230.4	t	2026-05-08 00:01:27.547131
11001	2026-03-18 09:00:00	7	26.15	220	5136.8	t	2026-05-08 00:01:27.547131
11002	2026-03-18 09:30:00	1	21.12	220	3724.9	t	2026-05-08 00:01:27.547131
11003	2026-03-18 09:30:00	4	19.98	220	4999.5	t	2026-05-08 00:01:27.547131
11004	2026-03-18 09:30:00	7	28.3	220	5060.2	t	2026-05-08 00:01:27.547131
11005	2026-03-18 10:00:00	1	14.11	220	3449.3	t	2026-05-08 00:01:27.547131
11006	2026-03-18 10:00:00	4	18.02	220	4799.8	t	2026-05-08 00:01:27.547131
11007	2026-03-18 10:00:00	7	27.27	220	5423.2	t	2026-05-08 00:01:27.547131
11008	2026-03-18 10:30:00	1	18.99	220	4322.1	t	2026-05-08 00:01:27.547131
11009	2026-03-18 10:30:00	4	24.27	220	4803.6	t	2026-05-08 00:01:27.547131
11010	2026-03-18 10:30:00	7	28.64	220	6605.8	t	2026-05-08 00:01:27.547131
11011	2026-03-18 11:00:00	1	14.55	220	2637.7	t	2026-05-08 00:01:27.547131
11012	2026-03-18 11:00:00	4	18.43	220	5463.1	t	2026-05-08 00:01:27.547131
11013	2026-03-18 11:00:00	7	27.51	220	6059.3	t	2026-05-08 00:01:27.547131
11014	2026-03-18 11:30:00	1	16.36	220	3038.1	t	2026-05-08 00:01:27.547131
11015	2026-03-18 11:30:00	4	16.35	220	5662.1	t	2026-05-08 00:01:27.547131
11016	2026-03-18 11:30:00	7	26.7	220	5420.7	t	2026-05-08 00:01:27.547131
11017	2026-03-18 12:00:00	1	14.73	220	3305	t	2026-05-08 00:01:27.547131
11018	2026-03-18 12:00:00	4	22.94	220	3765	t	2026-05-08 00:01:27.547131
11019	2026-03-18 12:00:00	7	22.86	220	5473.5	t	2026-05-08 00:01:27.547131
11020	2026-03-18 12:30:00	1	15.79	220	3622.4	t	2026-05-08 00:01:27.547131
11021	2026-03-18 12:30:00	4	16.37	220	4849.9	t	2026-05-08 00:01:27.547131
11022	2026-03-18 12:30:00	7	22.1	220	4754.9	t	2026-05-08 00:01:27.547131
11023	2026-03-18 13:00:00	1	20.72	220	3321.9	t	2026-05-08 00:01:27.547131
11024	2026-03-18 13:00:00	4	16.23	220	5478.6	t	2026-05-08 00:01:27.547131
11025	2026-03-18 13:00:00	7	29.32	220	5610.9	t	2026-05-08 00:01:27.547131
11026	2026-03-18 13:30:00	1	12.61	220	2595	t	2026-05-08 00:01:27.547131
11027	2026-03-18 13:30:00	4	20.14	220	5111.8	t	2026-05-08 00:01:27.547131
11028	2026-03-18 13:30:00	7	25.99	220	4820.4	t	2026-05-08 00:01:27.547131
11029	2026-03-18 14:00:00	1	14.07	220	4289.3	t	2026-05-08 00:01:27.547131
11030	2026-03-18 14:00:00	4	18.34	220	4921.2	t	2026-05-08 00:01:27.547131
11031	2026-03-18 14:00:00	7	22.22	220	5082.5	t	2026-05-08 00:01:27.547131
11032	2026-03-18 14:30:00	1	11.95	220	4508.6	t	2026-05-08 00:01:27.547131
11033	2026-03-18 14:30:00	4	25.15	220	5245.3	t	2026-05-08 00:01:27.547131
11034	2026-03-18 14:30:00	7	21.96	220	4928.3	t	2026-05-08 00:01:27.547131
11035	2026-03-18 15:00:00	1	14.31	220	3175.9	t	2026-05-08 00:01:27.547131
11036	2026-03-18 15:00:00	4	21.64	220	4509.1	t	2026-05-08 00:01:27.547131
11037	2026-03-18 15:00:00	7	21.79	220	5289.6	t	2026-05-08 00:01:27.547131
11038	2026-03-18 15:30:00	1	15.5	220	2812	t	2026-05-08 00:01:27.547131
11039	2026-03-18 15:30:00	4	19.34	220	4144.9	t	2026-05-08 00:01:27.547131
11040	2026-03-18 15:30:00	7	29.94	220	4775.6	t	2026-05-08 00:01:27.547131
11041	2026-03-18 16:00:00	1	21.3	220	3243.8	t	2026-05-08 00:01:27.547131
11042	2026-03-18 16:00:00	4	21.01	220	3706.6	t	2026-05-08 00:01:27.547131
11043	2026-03-18 16:00:00	7	24.33	220	5904.8	t	2026-05-08 00:01:27.547131
11044	2026-03-18 16:30:00	1	16.54	220	3787.5	t	2026-05-08 00:01:27.547131
11045	2026-03-18 16:30:00	4	17.93	220	4030.9	t	2026-05-08 00:01:27.547131
11046	2026-03-18 16:30:00	7	27.85	220	5209.8	t	2026-05-08 00:01:27.547131
11047	2026-03-18 17:00:00	1	12.42	220	3081.7	t	2026-05-08 00:01:27.547131
11048	2026-03-18 17:00:00	4	17.05	220	3814	t	2026-05-08 00:01:27.547131
11049	2026-03-18 17:00:00	7	27.28	220	5713	t	2026-05-08 00:01:27.547131
11050	2026-03-18 17:30:00	1	16.29	220	2979.9	t	2026-05-08 00:01:27.547131
11051	2026-03-18 17:30:00	4	20.01	220	5095.3	t	2026-05-08 00:01:27.547131
11052	2026-03-18 17:30:00	7	23.1	220	5942.9	t	2026-05-08 00:01:27.547131
11053	2026-03-18 18:00:00	1	13.15	220	4362.7	t	2026-05-08 00:01:27.547131
11054	2026-03-18 18:00:00	4	16.55	220	3860.8	t	2026-05-08 00:01:27.547131
11055	2026-03-18 18:00:00	7	27.99	220	4761.1	t	2026-05-08 00:01:27.547131
11056	2026-03-18 18:30:00	1	11.87	220	4351.1	t	2026-05-08 00:01:27.547131
11057	2026-03-18 18:30:00	4	23.1	220	5404.7	t	2026-05-08 00:01:27.547131
11058	2026-03-18 18:30:00	7	25.87	220	6267.9	t	2026-05-08 00:01:27.547131
11059	2026-03-18 19:00:00	1	20.51	220	4384.4	t	2026-05-08 00:01:27.547131
11060	2026-03-18 19:00:00	4	25.15	220	3859.5	t	2026-05-08 00:01:27.547131
11061	2026-03-18 19:00:00	7	26.7	220	4514.3	t	2026-05-08 00:01:27.547131
11062	2026-03-18 19:30:00	1	18.31	220	3888.2	t	2026-05-08 00:01:27.547131
11063	2026-03-18 19:30:00	4	17.38	220	5168.2	t	2026-05-08 00:01:27.547131
11064	2026-03-18 19:30:00	7	25.04	220	6227.5	t	2026-05-08 00:01:27.547131
11065	2026-03-18 20:00:00	1	1.25	220	307	t	2026-05-08 00:01:27.547131
11066	2026-03-18 20:00:00	4	1.54	220	517.4	t	2026-05-08 00:01:27.547131
11067	2026-03-18 20:00:00	7	1.5	220	350.1	t	2026-05-08 00:01:27.547131
11068	2026-03-18 20:30:00	1	2.51	220	604.9	t	2026-05-08 00:01:27.547131
11069	2026-03-18 20:30:00	4	2.17	220	459.1	t	2026-05-08 00:01:27.547131
11070	2026-03-18 20:30:00	7	3.12	220	461.5	t	2026-05-08 00:01:27.547131
11071	2026-03-18 21:00:00	1	3.45	220	787.3	t	2026-05-08 00:01:27.547131
11072	2026-03-18 21:00:00	4	2.58	220	811.6	t	2026-05-08 00:01:27.547131
11073	2026-03-18 21:00:00	7	3.46	220	715.8	t	2026-05-08 00:01:27.547131
11074	2026-03-18 21:30:00	1	3.55	220	617.2	t	2026-05-08 00:01:27.547131
11075	2026-03-18 21:30:00	4	2.69	220	394.2	t	2026-05-08 00:01:27.547131
11076	2026-03-18 21:30:00	7	2.64	220	339.9	t	2026-05-08 00:01:27.547131
11077	2026-03-18 22:00:00	1	1.67	220	702.1	t	2026-05-08 00:01:27.547131
11078	2026-03-18 22:00:00	4	3.52	220	524.9	t	2026-05-08 00:01:27.547131
11079	2026-03-18 22:00:00	7	2.57	220	387.3	t	2026-05-08 00:01:27.547131
11080	2026-03-18 22:30:00	1	1.23	220	707.7	t	2026-05-08 00:01:27.547131
11081	2026-03-18 22:30:00	4	2.7	220	622.8	t	2026-05-08 00:01:27.547131
11082	2026-03-18 22:30:00	7	3.16	220	364.2	t	2026-05-08 00:01:27.547131
11083	2026-03-18 23:00:00	1	3.65	220	680.6	t	2026-05-08 00:01:27.547131
11084	2026-03-18 23:00:00	4	2.31	220	495.1	t	2026-05-08 00:01:27.547131
11085	2026-03-18 23:00:00	7	1.65	220	450.9	t	2026-05-08 00:01:27.547131
11086	2026-03-18 23:30:00	1	1.7	220	801.9	t	2026-05-08 00:01:27.547131
11087	2026-03-18 23:30:00	4	3.66	220	569.5	t	2026-05-08 00:01:27.547131
11088	2026-03-18 23:30:00	7	3.64	220	424.6	t	2026-05-08 00:01:27.547131
11089	2026-03-19 00:00:00	1	2.67	220	687.1	t	2026-05-08 00:01:27.547131
11090	2026-03-19 00:00:00	4	2.92	220	305.9	t	2026-05-08 00:01:27.547131
11091	2026-03-19 00:00:00	7	3.69	220	773.8	t	2026-05-08 00:01:27.547131
11092	2026-03-19 00:30:00	1	1.33	220	298	t	2026-05-08 00:01:27.547131
11093	2026-03-19 00:30:00	4	3.04	220	396.8	t	2026-05-08 00:01:27.547131
11094	2026-03-19 00:30:00	7	3.39	220	575.7	t	2026-05-08 00:01:27.547131
11095	2026-03-19 01:00:00	1	2.57	220	609.3	t	2026-05-08 00:01:27.547131
11096	2026-03-19 01:00:00	4	2.57	220	478.4	t	2026-05-08 00:01:27.547131
11097	2026-03-19 01:00:00	7	2.51	220	630.1	t	2026-05-08 00:01:27.547131
11098	2026-03-19 01:30:00	1	2.7	220	474.5	t	2026-05-08 00:01:27.547131
11099	2026-03-19 01:30:00	4	1.62	220	667.1	t	2026-05-08 00:01:27.547131
11100	2026-03-19 01:30:00	7	1.35	220	756.2	t	2026-05-08 00:01:27.547131
11101	2026-03-19 02:00:00	1	2.63	220	486.2	t	2026-05-08 00:01:27.547131
11102	2026-03-19 02:00:00	4	1.67	220	437.3	t	2026-05-08 00:01:27.547131
11103	2026-03-19 02:00:00	7	1.58	220	670.4	t	2026-05-08 00:01:27.547131
11104	2026-03-19 02:30:00	1	2.74	220	363	t	2026-05-08 00:01:27.547131
11105	2026-03-19 02:30:00	4	2.49	220	567.8	t	2026-05-08 00:01:27.547131
11106	2026-03-19 02:30:00	7	2.64	220	733.5	t	2026-05-08 00:01:27.547131
11107	2026-03-19 03:00:00	1	3.65	220	744.1	t	2026-05-08 00:01:27.547131
11108	2026-03-19 03:00:00	4	2.88	220	354.9	t	2026-05-08 00:01:27.547131
11109	2026-03-19 03:00:00	7	2.42	220	765.9	t	2026-05-08 00:01:27.547131
11110	2026-03-19 03:30:00	1	3.06	220	782.5	t	2026-05-08 00:01:27.547131
11111	2026-03-19 03:30:00	4	1.94	220	580.3	t	2026-05-08 00:01:27.547131
11112	2026-03-19 03:30:00	7	3.29	220	518.6	t	2026-05-08 00:01:27.547131
11113	2026-03-19 04:00:00	1	2.89	220	266	t	2026-05-08 00:01:27.547131
11114	2026-03-19 04:00:00	4	3.67	220	317.6	t	2026-05-08 00:01:27.547131
11115	2026-03-19 04:00:00	7	3.56	220	606.7	t	2026-05-08 00:01:27.547131
11116	2026-03-19 04:30:00	1	3.14	220	445.7	t	2026-05-08 00:01:27.547131
11117	2026-03-19 04:30:00	4	2.01	220	560.6	t	2026-05-08 00:01:27.547131
11118	2026-03-19 04:30:00	7	1.94	220	671.6	t	2026-05-08 00:01:27.547131
11119	2026-03-19 05:00:00	1	2.98	220	332.5	t	2026-05-08 00:01:27.547131
11120	2026-03-19 05:00:00	4	3.03	220	442.6	t	2026-05-08 00:01:27.547131
11121	2026-03-19 05:00:00	7	2.49	220	542.5	t	2026-05-08 00:01:27.547131
11122	2026-03-19 05:30:00	1	2.09	220	587.1	t	2026-05-08 00:01:27.547131
11123	2026-03-19 05:30:00	4	2.36	220	621.6	t	2026-05-08 00:01:27.547131
11124	2026-03-19 05:30:00	7	3.64	220	506.5	t	2026-05-08 00:01:27.547131
11125	2026-03-19 06:00:00	1	2.88	220	268.6	t	2026-05-08 00:01:27.547131
11126	2026-03-19 06:00:00	4	1.25	220	374	t	2026-05-08 00:01:27.547131
11127	2026-03-19 06:00:00	7	3.67	220	529.8	t	2026-05-08 00:01:27.547131
11128	2026-03-19 06:30:00	1	1.24	220	669.6	t	2026-05-08 00:01:27.547131
11129	2026-03-19 06:30:00	4	1.97	220	607.1	t	2026-05-08 00:01:27.547131
11130	2026-03-19 06:30:00	7	1.68	220	334.2	t	2026-05-08 00:01:27.547131
11131	2026-03-19 07:00:00	1	17.79	220	3060.3	t	2026-05-08 00:01:27.547131
11132	2026-03-19 07:00:00	4	21.56	220	5305.6	t	2026-05-08 00:01:27.547131
11133	2026-03-19 07:00:00	7	25.68	220	6132.8	t	2026-05-08 00:01:27.547131
11134	2026-03-19 07:30:00	1	14.29	220	3240.9	t	2026-05-08 00:01:27.547131
11135	2026-03-19 07:30:00	4	21.49	220	4955.5	t	2026-05-08 00:01:27.547131
11136	2026-03-19 07:30:00	7	27.79	220	6460.2	t	2026-05-08 00:01:27.547131
11137	2026-03-19 08:00:00	1	14.03	220	4711.9	t	2026-05-08 00:01:27.547131
11138	2026-03-19 08:00:00	4	17.28	220	4175.1	t	2026-05-08 00:01:27.547131
11139	2026-03-19 08:00:00	7	24.02	220	4838.6	t	2026-05-08 00:01:27.547131
11140	2026-03-19 08:30:00	1	18.97	220	3678.1	t	2026-05-08 00:01:27.547131
11141	2026-03-19 08:30:00	4	24.98	220	5058.8	t	2026-05-08 00:01:27.547131
11142	2026-03-19 08:30:00	7	27.07	220	5331.8	t	2026-05-08 00:01:27.547131
11143	2026-03-19 09:00:00	1	15.77	220	2742.1	t	2026-05-08 00:01:27.547131
11144	2026-03-19 09:00:00	4	21.69	220	3820.6	t	2026-05-08 00:01:27.547131
11145	2026-03-19 09:00:00	7	20.8	220	5025.7	t	2026-05-08 00:01:27.547131
11146	2026-03-19 09:30:00	1	14.89	220	4313.5	t	2026-05-08 00:01:27.547131
11147	2026-03-19 09:30:00	4	20.88	220	4352	t	2026-05-08 00:01:27.547131
11148	2026-03-19 09:30:00	7	21.98	220	5575.7	t	2026-05-08 00:01:27.547131
11149	2026-03-19 10:00:00	1	14.12	220	3406.2	t	2026-05-08 00:01:27.547131
11150	2026-03-19 10:00:00	4	24.85	220	5556.3	t	2026-05-08 00:01:27.547131
11151	2026-03-19 10:00:00	7	29.43	220	5421.8	t	2026-05-08 00:01:27.547131
11152	2026-03-19 10:30:00	1	21.39	220	3026.6	t	2026-05-08 00:01:27.547131
11153	2026-03-19 10:30:00	4	25.22	220	5304.8	t	2026-05-08 00:01:27.547131
11154	2026-03-19 10:30:00	7	29.04	220	5360.8	t	2026-05-08 00:01:27.547131
11155	2026-03-19 11:00:00	1	20.36	220	4715.8	t	2026-05-08 00:01:27.547131
11156	2026-03-19 11:00:00	4	24.86	220	4388	t	2026-05-08 00:01:27.547131
11157	2026-03-19 11:00:00	7	29.03	220	5830.7	t	2026-05-08 00:01:27.547131
11158	2026-03-19 11:30:00	1	15.01	220	3542.9	t	2026-05-08 00:01:27.547131
11159	2026-03-19 11:30:00	4	19.94	220	4578.8	t	2026-05-08 00:01:27.547131
11160	2026-03-19 11:30:00	7	21.04	220	5197.2	t	2026-05-08 00:01:27.547131
11161	2026-03-19 12:00:00	1	15.65	220	4416.8	t	2026-05-08 00:01:27.547131
11162	2026-03-19 12:00:00	4	25.14	220	3710.1	t	2026-05-08 00:01:27.547131
11163	2026-03-19 12:00:00	7	22.02	220	6301	t	2026-05-08 00:01:27.547131
11164	2026-03-19 12:30:00	1	17.76	220	3504.4	t	2026-05-08 00:01:27.547131
11165	2026-03-19 12:30:00	4	16.44	220	5435.9	t	2026-05-08 00:01:27.547131
11166	2026-03-19 12:30:00	7	20.86	220	4652.3	t	2026-05-08 00:01:27.547131
11167	2026-03-19 13:00:00	1	18.93	220	3373	t	2026-05-08 00:01:27.547131
11168	2026-03-19 13:00:00	4	25.36	220	5076.3	t	2026-05-08 00:01:27.547131
11169	2026-03-19 13:00:00	7	24.73	220	5164.1	t	2026-05-08 00:01:27.547131
11170	2026-03-19 13:30:00	1	15.03	220	4601.2	t	2026-05-08 00:01:27.547131
11171	2026-03-19 13:30:00	4	16.13	220	5043.1	t	2026-05-08 00:01:27.547131
11172	2026-03-19 13:30:00	7	27.09	220	6087.6	t	2026-05-08 00:01:27.547131
11173	2026-03-19 14:00:00	1	17.93	220	3945.5	t	2026-05-08 00:01:27.547131
11174	2026-03-19 14:00:00	4	25.3	220	3827.9	t	2026-05-08 00:01:27.547131
11175	2026-03-19 14:00:00	7	20.99	220	4676	t	2026-05-08 00:01:27.547131
11176	2026-03-19 14:30:00	1	14.96	220	2537.9	t	2026-05-08 00:01:27.547131
11177	2026-03-19 14:30:00	4	25.8	220	4937.5	t	2026-05-08 00:01:27.547131
11178	2026-03-19 14:30:00	7	24.57	220	5800.9	t	2026-05-08 00:01:27.547131
11179	2026-03-19 15:00:00	1	16.33	220	3635.1	t	2026-05-08 00:01:27.547131
11180	2026-03-19 15:00:00	4	22.94	220	4335	t	2026-05-08 00:01:27.547131
11181	2026-03-19 15:00:00	7	22.79	220	6351.7	t	2026-05-08 00:01:27.547131
11182	2026-03-19 15:30:00	1	15.34	220	3686.6	t	2026-05-08 00:01:27.547131
11183	2026-03-19 15:30:00	4	20.07	220	4468.1	t	2026-05-08 00:01:27.547131
11184	2026-03-19 15:30:00	7	26.19	220	6125.6	t	2026-05-08 00:01:27.547131
11185	2026-03-19 16:00:00	1	14.65	220	2561.3	t	2026-05-08 00:01:27.547131
11186	2026-03-19 16:00:00	4	20.76	220	4642.1	t	2026-05-08 00:01:27.547131
11187	2026-03-19 16:00:00	7	25.26	220	5943.6	t	2026-05-08 00:01:27.547131
11188	2026-03-19 16:30:00	1	17.87	220	3670.3	t	2026-05-08 00:01:27.547131
11189	2026-03-19 16:30:00	4	24.29	220	3721.4	t	2026-05-08 00:01:27.547131
11190	2026-03-19 16:30:00	7	25.88	220	6032.6	t	2026-05-08 00:01:27.547131
11191	2026-03-19 17:00:00	1	12.59	220	3219.2	t	2026-05-08 00:01:27.547131
11192	2026-03-19 17:00:00	4	20.74	220	4448	t	2026-05-08 00:01:27.547131
11193	2026-03-19 17:00:00	7	26.8	220	4766	t	2026-05-08 00:01:27.547131
11194	2026-03-19 17:30:00	1	20.31	220	3799.7	t	2026-05-08 00:01:27.547131
11195	2026-03-19 17:30:00	4	16.48	220	4671.8	t	2026-05-08 00:01:27.547131
11196	2026-03-19 17:30:00	7	24.51	220	5230.8	t	2026-05-08 00:01:27.547131
11197	2026-03-19 18:00:00	1	16.74	220	4182.1	t	2026-05-08 00:01:27.547131
11198	2026-03-19 18:00:00	4	20.25	220	5323.3	t	2026-05-08 00:01:27.547131
11199	2026-03-19 18:00:00	7	20.92	220	6597.1	t	2026-05-08 00:01:27.547131
11200	2026-03-19 18:30:00	1	15.94	220	4188.1	t	2026-05-08 00:01:27.547131
11201	2026-03-19 18:30:00	4	19.13	220	4888.6	t	2026-05-08 00:01:27.547131
11202	2026-03-19 18:30:00	7	28.93	220	5732	t	2026-05-08 00:01:27.547131
11203	2026-03-19 19:00:00	1	19.87	220	3585	t	2026-05-08 00:01:27.547131
11204	2026-03-19 19:00:00	4	24.09	220	3872.4	t	2026-05-08 00:01:27.547131
11205	2026-03-19 19:00:00	7	29.1	220	6223.3	t	2026-05-08 00:01:27.547131
11206	2026-03-19 19:30:00	1	19.46	220	3853.3	t	2026-05-08 00:01:27.547131
11207	2026-03-19 19:30:00	4	25.31	220	5677.6	t	2026-05-08 00:01:27.547131
11208	2026-03-19 19:30:00	7	22.32	220	5678.1	t	2026-05-08 00:01:27.547131
11209	2026-03-19 20:00:00	1	3.55	220	768.8	t	2026-05-08 00:01:27.547131
11210	2026-03-19 20:00:00	4	3.57	220	354.2	t	2026-05-08 00:01:27.547131
11211	2026-03-19 20:00:00	7	2.08	220	531.9	t	2026-05-08 00:01:27.547131
11212	2026-03-19 20:30:00	1	3.19	220	480.3	t	2026-05-08 00:01:27.547131
11213	2026-03-19 20:30:00	4	2.49	220	698.2	t	2026-05-08 00:01:27.547131
11214	2026-03-19 20:30:00	7	3.53	220	641.5	t	2026-05-08 00:01:27.547131
11215	2026-03-19 21:00:00	1	3.57	220	737.9	t	2026-05-08 00:01:27.547131
11216	2026-03-19 21:00:00	4	2.03	220	563.2	t	2026-05-08 00:01:27.547131
11217	2026-03-19 21:00:00	7	3.24	220	479.3	t	2026-05-08 00:01:27.547131
11218	2026-03-19 21:30:00	1	2.17	220	545.5	t	2026-05-08 00:01:27.547131
11219	2026-03-19 21:30:00	4	2.32	220	735.6	t	2026-05-08 00:01:27.547131
11220	2026-03-19 21:30:00	7	1.27	220	603.7	t	2026-05-08 00:01:27.547131
11221	2026-03-19 22:00:00	1	2.08	220	581.5	t	2026-05-08 00:01:27.547131
11222	2026-03-19 22:00:00	4	2.84	220	434.1	t	2026-05-08 00:01:27.547131
11223	2026-03-19 22:00:00	7	2.15	220	376.1	t	2026-05-08 00:01:27.547131
11224	2026-03-19 22:30:00	1	3.49	220	334.3	t	2026-05-08 00:01:27.547131
11225	2026-03-19 22:30:00	4	2.51	220	457.1	t	2026-05-08 00:01:27.547131
11226	2026-03-19 22:30:00	7	3.01	220	640.6	t	2026-05-08 00:01:27.547131
11227	2026-03-19 23:00:00	1	3.03	220	618.8	t	2026-05-08 00:01:27.547131
11228	2026-03-19 23:00:00	4	3.45	220	342.2	t	2026-05-08 00:01:27.547131
11229	2026-03-19 23:00:00	7	2.1	220	493.9	t	2026-05-08 00:01:27.547131
11230	2026-03-19 23:30:00	1	3.19	220	336.4	t	2026-05-08 00:01:27.547131
11231	2026-03-19 23:30:00	4	1.37	220	463.1	t	2026-05-08 00:01:27.547131
11232	2026-03-19 23:30:00	7	2.37	220	782.9	t	2026-05-08 00:01:27.547131
11233	2026-03-20 00:00:00	1	1.79	220	520.1	t	2026-05-08 00:01:27.547131
11234	2026-03-20 00:00:00	4	2.71	220	435.9	t	2026-05-08 00:01:27.547131
11235	2026-03-20 00:00:00	7	1.65	220	484.1	t	2026-05-08 00:01:27.547131
11236	2026-03-20 00:30:00	1	1.44	220	712.3	t	2026-05-08 00:01:27.547131
11237	2026-03-20 00:30:00	4	2.28	220	653.1	t	2026-05-08 00:01:27.547131
11238	2026-03-20 00:30:00	7	2.1	220	789.8	t	2026-05-08 00:01:27.547131
11239	2026-03-20 01:00:00	1	2.3	220	271.1	t	2026-05-08 00:01:27.547131
11240	2026-03-20 01:00:00	4	3.62	220	811.3	t	2026-05-08 00:01:27.547131
11241	2026-03-20 01:00:00	7	3.18	220	453.1	t	2026-05-08 00:01:27.547131
11242	2026-03-20 01:30:00	1	3.67	220	565.8	t	2026-05-08 00:01:27.547131
11243	2026-03-20 01:30:00	4	3.32	220	761	t	2026-05-08 00:01:27.547131
11244	2026-03-20 01:30:00	7	1.4	220	487.2	t	2026-05-08 00:01:27.547131
11245	2026-03-20 02:00:00	1	3.32	220	660.2	t	2026-05-08 00:01:27.547131
11246	2026-03-20 02:00:00	4	3.47	220	680.5	t	2026-05-08 00:01:27.547131
11247	2026-03-20 02:00:00	7	2.97	220	379.8	t	2026-05-08 00:01:27.547131
11248	2026-03-20 02:30:00	1	2.32	220	744.2	t	2026-05-08 00:01:27.547131
11249	2026-03-20 02:30:00	4	1.58	220	768	t	2026-05-08 00:01:27.547131
11250	2026-03-20 02:30:00	7	2.57	220	728.3	t	2026-05-08 00:01:27.547131
11251	2026-03-20 03:00:00	1	1.2	220	537.8	t	2026-05-08 00:01:27.547131
11252	2026-03-20 03:00:00	4	2	220	599.8	t	2026-05-08 00:01:27.547131
11253	2026-03-20 03:00:00	7	2.65	220	759.3	t	2026-05-08 00:01:27.547131
11254	2026-03-20 03:30:00	1	2.11	220	574.7	t	2026-05-08 00:01:27.547131
11255	2026-03-20 03:30:00	4	2.1	220	371.7	t	2026-05-08 00:01:27.547131
11256	2026-03-20 03:30:00	7	1.69	220	271.4	t	2026-05-08 00:01:27.547131
11257	2026-03-20 04:00:00	1	3.58	220	276.8	t	2026-05-08 00:01:27.547131
11258	2026-03-20 04:00:00	4	2.69	220	731.2	t	2026-05-08 00:01:27.547131
11259	2026-03-20 04:00:00	7	2.73	220	669.7	t	2026-05-08 00:01:27.547131
11260	2026-03-20 04:30:00	1	1.82	220	512.5	t	2026-05-08 00:01:27.547131
11261	2026-03-20 04:30:00	4	2.56	220	579	t	2026-05-08 00:01:27.547131
11262	2026-03-20 04:30:00	7	3.63	220	307.5	t	2026-05-08 00:01:27.547131
11263	2026-03-20 05:00:00	1	2.02	220	750.8	t	2026-05-08 00:01:27.547131
11264	2026-03-20 05:00:00	4	2.46	220	522.5	t	2026-05-08 00:01:27.547131
11265	2026-03-20 05:00:00	7	2.97	220	601.1	t	2026-05-08 00:01:27.547131
11266	2026-03-20 05:30:00	1	1.7	220	725.6	t	2026-05-08 00:01:27.547131
11267	2026-03-20 05:30:00	4	2.2	220	393.1	t	2026-05-08 00:01:27.547131
11268	2026-03-20 05:30:00	7	2.68	220	406.1	t	2026-05-08 00:01:27.547131
11269	2026-03-20 06:00:00	1	3.3	220	326.5	t	2026-05-08 00:01:27.547131
11270	2026-03-20 06:00:00	4	2.76	220	793.5	t	2026-05-08 00:01:27.547131
11271	2026-03-20 06:00:00	7	2.01	220	665.9	t	2026-05-08 00:01:27.547131
11272	2026-03-20 06:30:00	1	2.13	220	484.8	t	2026-05-08 00:01:27.547131
11273	2026-03-20 06:30:00	4	3.65	220	531.9	t	2026-05-08 00:01:27.547131
11274	2026-03-20 06:30:00	7	3.54	220	303.8	t	2026-05-08 00:01:27.547131
11275	2026-03-20 07:00:00	1	19.03	220	4114.7	t	2026-05-08 00:01:27.547131
11276	2026-03-20 07:00:00	4	24.24	220	4871.7	t	2026-05-08 00:01:27.547131
11277	2026-03-20 07:00:00	7	26.07	220	4833.9	t	2026-05-08 00:01:27.547131
11278	2026-03-20 07:30:00	1	13.88	220	3740.1	t	2026-05-08 00:01:27.547131
11279	2026-03-20 07:30:00	4	16.31	220	3875.3	t	2026-05-08 00:01:27.547131
11280	2026-03-20 07:30:00	7	23.93	220	6329.4	t	2026-05-08 00:01:27.547131
11281	2026-03-20 08:00:00	1	11.88	220	4525	t	2026-05-08 00:01:27.547131
11282	2026-03-20 08:00:00	4	23.61	220	3746.3	t	2026-05-08 00:01:27.547131
11283	2026-03-20 08:00:00	7	21.91	220	5644.2	t	2026-05-08 00:01:27.547131
11284	2026-03-20 08:30:00	1	16.87	220	3436.5	t	2026-05-08 00:01:27.547131
11285	2026-03-20 08:30:00	4	25.38	220	5480.6	t	2026-05-08 00:01:27.547131
11286	2026-03-20 08:30:00	7	21.72	220	6210.3	t	2026-05-08 00:01:27.547131
11287	2026-03-20 09:00:00	1	17.78	220	3640.9	t	2026-05-08 00:01:27.547131
11288	2026-03-20 09:00:00	4	18.2	220	3899	t	2026-05-08 00:01:27.547131
11289	2026-03-20 09:00:00	7	27.14	220	4928.1	t	2026-05-08 00:01:27.547131
11290	2026-03-20 09:30:00	1	15.78	220	2643.5	t	2026-05-08 00:01:27.547131
11291	2026-03-20 09:30:00	4	21.09	220	4543.6	t	2026-05-08 00:01:27.547131
11292	2026-03-20 09:30:00	7	25.14	220	6156.6	t	2026-05-08 00:01:27.547131
11293	2026-03-20 10:00:00	1	17.24	220	3331.3	t	2026-05-08 00:01:27.547131
11294	2026-03-20 10:00:00	4	19.67	220	4381.7	t	2026-05-08 00:01:27.547131
11295	2026-03-20 10:00:00	7	28.29	220	5011.9	t	2026-05-08 00:01:27.547131
11296	2026-03-20 10:30:00	1	12.92	220	4089	t	2026-05-08 00:01:27.547131
11297	2026-03-20 10:30:00	4	22.27	220	5031	t	2026-05-08 00:01:27.547131
11298	2026-03-20 10:30:00	7	26.8	220	6697.7	t	2026-05-08 00:01:27.547131
11299	2026-03-20 11:00:00	1	16.84	220	2602.3	t	2026-05-08 00:01:27.547131
11300	2026-03-20 11:00:00	4	20.32	220	3579.5	t	2026-05-08 00:01:27.547131
11301	2026-03-20 11:00:00	7	24.58	220	4631.5	t	2026-05-08 00:01:27.547131
11302	2026-03-20 11:30:00	1	16.2	220	2816.1	t	2026-05-08 00:01:27.547131
11303	2026-03-20 11:30:00	4	19.2	220	4306.8	t	2026-05-08 00:01:27.547131
11304	2026-03-20 11:30:00	7	23.68	220	5887.7	t	2026-05-08 00:01:27.547131
11305	2026-03-20 12:00:00	1	14.66	220	4232.3	t	2026-05-08 00:01:27.547131
11306	2026-03-20 12:00:00	4	16.58	220	4737.3	t	2026-05-08 00:01:27.547131
11307	2026-03-20 12:00:00	7	25.28	220	4950.8	t	2026-05-08 00:01:27.547131
11308	2026-03-20 12:30:00	1	13.9	220	4712	t	2026-05-08 00:01:27.547131
11309	2026-03-20 12:30:00	4	23.38	220	4529.9	t	2026-05-08 00:01:27.547131
11310	2026-03-20 12:30:00	7	27.23	220	5019.9	t	2026-05-08 00:01:27.547131
11311	2026-03-20 13:00:00	1	15.09	220	4234	t	2026-05-08 00:01:27.547131
11312	2026-03-20 13:00:00	4	23.5	220	3537.6	t	2026-05-08 00:01:27.547131
11313	2026-03-20 13:00:00	7	22.34	220	5190	t	2026-05-08 00:01:27.547131
11314	2026-03-20 13:30:00	1	15.07	220	2672.2	t	2026-05-08 00:01:27.547131
11315	2026-03-20 13:30:00	4	21.54	220	5149.5	t	2026-05-08 00:01:27.547131
11316	2026-03-20 13:30:00	7	27.41	220	4532.8	t	2026-05-08 00:01:27.547131
11317	2026-03-20 14:00:00	1	16.41	220	3383.1	t	2026-05-08 00:01:27.547131
11318	2026-03-20 14:00:00	4	23.72	220	4549.9	t	2026-05-08 00:01:27.547131
11319	2026-03-20 14:00:00	7	20.86	220	5900.3	t	2026-05-08 00:01:27.547131
11320	2026-03-20 14:30:00	1	21.31	220	4606.3	t	2026-05-08 00:01:27.547131
11321	2026-03-20 14:30:00	4	16.37	220	5548.9	t	2026-05-08 00:01:27.547131
11322	2026-03-20 14:30:00	7	23.66	220	6191.7	t	2026-05-08 00:01:27.547131
11323	2026-03-20 15:00:00	1	21.22	220	4044.3	t	2026-05-08 00:01:27.547131
11324	2026-03-20 15:00:00	4	19.62	220	5069.5	t	2026-05-08 00:01:27.547131
11325	2026-03-20 15:00:00	7	27.03	220	4833.1	t	2026-05-08 00:01:27.547131
11326	2026-03-20 15:30:00	1	15.81	220	4297.1	t	2026-05-08 00:01:27.547131
11327	2026-03-20 15:30:00	4	21.49	220	4768.2	t	2026-05-08 00:01:27.547131
11328	2026-03-20 15:30:00	7	22.92	220	6052.7	t	2026-05-08 00:01:27.547131
11329	2026-03-20 16:00:00	1	17.87	220	4342.3	t	2026-05-08 00:01:27.547131
11330	2026-03-20 16:00:00	4	25.09	220	5714.4	t	2026-05-08 00:01:27.547131
11331	2026-03-20 16:00:00	7	26.17	220	6537.1	t	2026-05-08 00:01:27.547131
11332	2026-03-20 16:30:00	1	13.76	220	4305.6	t	2026-05-08 00:01:27.547131
11333	2026-03-20 16:30:00	4	23.54	220	4017.5	t	2026-05-08 00:01:27.547131
11334	2026-03-20 16:30:00	7	21.02	220	6217.5	t	2026-05-08 00:01:27.547131
11335	2026-03-20 17:00:00	1	18.7	220	3208	t	2026-05-08 00:01:27.547131
11336	2026-03-20 17:00:00	4	21.75	220	4570.1	t	2026-05-08 00:01:27.547131
11337	2026-03-20 17:00:00	7	23.99	220	6442.1	t	2026-05-08 00:01:27.547131
11338	2026-03-20 17:30:00	1	11.67	220	3472.2	t	2026-05-08 00:01:27.547131
11339	2026-03-20 17:30:00	4	21.89	220	4770.1	t	2026-05-08 00:01:27.547131
11340	2026-03-20 17:30:00	7	28.09	220	5053.7	t	2026-05-08 00:01:27.547131
11341	2026-03-20 18:00:00	1	12.79	220	2956.2	t	2026-05-08 00:01:27.547131
11342	2026-03-20 18:00:00	4	20.89	220	5082.4	t	2026-05-08 00:01:27.547131
11343	2026-03-20 18:00:00	7	22.62	220	5497.6	t	2026-05-08 00:01:27.547131
11344	2026-03-20 18:30:00	1	19.77	220	3775.8	t	2026-05-08 00:01:27.547131
11345	2026-03-20 18:30:00	4	20.48	220	4847.7	t	2026-05-08 00:01:27.547131
11346	2026-03-20 18:30:00	7	26.66	220	4880.5	t	2026-05-08 00:01:27.547131
11347	2026-03-20 19:00:00	1	11.94	220	3710.5	t	2026-05-08 00:01:27.547131
11348	2026-03-20 19:00:00	4	18.19	220	4804.6	t	2026-05-08 00:01:27.547131
11349	2026-03-20 19:00:00	7	24.35	220	5895.4	t	2026-05-08 00:01:27.547131
11350	2026-03-20 19:30:00	1	18.27	220	3812.8	t	2026-05-08 00:01:27.547131
11351	2026-03-20 19:30:00	4	19.11	220	4082.5	t	2026-05-08 00:01:27.547131
11352	2026-03-20 19:30:00	7	25.2	220	5901.2	t	2026-05-08 00:01:27.547131
11353	2026-03-20 20:00:00	1	3.27	220	284.7	t	2026-05-08 00:01:27.547131
11354	2026-03-20 20:00:00	4	2.18	220	584	t	2026-05-08 00:01:27.547131
11355	2026-03-20 20:00:00	7	1.34	220	645.9	t	2026-05-08 00:01:27.547131
11356	2026-03-20 20:30:00	1	2.33	220	676.7	t	2026-05-08 00:01:27.547131
11357	2026-03-20 20:30:00	4	2.34	220	442	t	2026-05-08 00:01:27.547131
11358	2026-03-20 20:30:00	7	3.6	220	265.6	t	2026-05-08 00:01:27.547131
11359	2026-03-20 21:00:00	1	2.04	220	729.7	t	2026-05-08 00:01:27.547131
11360	2026-03-20 21:00:00	4	2.38	220	434.2	t	2026-05-08 00:01:27.547131
11361	2026-03-20 21:00:00	7	2.53	220	294.7	t	2026-05-08 00:01:27.547131
11362	2026-03-20 21:30:00	1	1.55	220	420.7	t	2026-05-08 00:01:27.547131
11363	2026-03-20 21:30:00	4	2.2	220	361.5	t	2026-05-08 00:01:27.547131
11364	2026-03-20 21:30:00	7	1.61	220	577.3	t	2026-05-08 00:01:27.547131
11365	2026-03-20 22:00:00	1	2.89	220	524.7	t	2026-05-08 00:01:27.547131
11366	2026-03-20 22:00:00	4	2.37	220	356.7	t	2026-05-08 00:01:27.547131
11367	2026-03-20 22:00:00	7	1.48	220	409.4	t	2026-05-08 00:01:27.547131
11368	2026-03-20 22:30:00	1	1.8	220	437.5	t	2026-05-08 00:01:27.547131
11369	2026-03-20 22:30:00	4	2.3	220	438	t	2026-05-08 00:01:27.547131
11370	2026-03-20 22:30:00	7	2.17	220	600	t	2026-05-08 00:01:27.547131
11371	2026-03-20 23:00:00	1	3.08	220	689.7	t	2026-05-08 00:01:27.547131
11372	2026-03-20 23:00:00	4	3.53	220	315.6	t	2026-05-08 00:01:27.547131
11373	2026-03-20 23:00:00	7	3.43	220	509.9	t	2026-05-08 00:01:27.547131
11374	2026-03-20 23:30:00	1	3.53	220	669.1	t	2026-05-08 00:01:27.547131
11375	2026-03-20 23:30:00	4	1.74	220	391.1	t	2026-05-08 00:01:27.547131
11376	2026-03-20 23:30:00	7	3.2	220	775	t	2026-05-08 00:01:27.547131
11377	2026-03-21 00:00:00	1	1.12	220	451	t	2026-05-08 00:01:27.547131
11378	2026-03-21 00:00:00	4	1.76	220	438.4	t	2026-05-08 00:01:27.547131
11379	2026-03-21 00:00:00	7	2.51	220	403.2	t	2026-05-08 00:01:27.547131
11380	2026-03-21 00:30:00	1	2.66	220	656.1	t	2026-05-08 00:01:27.547131
11381	2026-03-21 00:30:00	4	1.69	220	420.1	t	2026-05-08 00:01:27.547131
11382	2026-03-21 00:30:00	7	1.29	220	621.2	t	2026-05-08 00:01:27.547131
11383	2026-03-21 01:00:00	1	1.52	220	528.4	t	2026-05-08 00:01:27.547131
11384	2026-03-21 01:00:00	4	2.21	220	544.5	t	2026-05-08 00:01:27.547131
11385	2026-03-21 01:00:00	7	2.75	220	259.4	t	2026-05-08 00:01:27.547131
11386	2026-03-21 01:30:00	1	1.43	220	478.4	t	2026-05-08 00:01:27.547131
11387	2026-03-21 01:30:00	4	1.85	220	377.3	t	2026-05-08 00:01:27.547131
11388	2026-03-21 01:30:00	7	1.49	220	338	t	2026-05-08 00:01:27.547131
11389	2026-03-21 02:00:00	1	1.47	220	231	t	2026-05-08 00:01:27.547131
11390	2026-03-21 02:00:00	4	2.61	220	309.4	t	2026-05-08 00:01:27.547131
11391	2026-03-21 02:00:00	7	1.2	220	600.3	t	2026-05-08 00:01:27.547131
11392	2026-03-21 02:30:00	1	1.06	220	551.5	t	2026-05-08 00:01:27.547131
11393	2026-03-21 02:30:00	4	2.98	220	459.7	t	2026-05-08 00:01:27.547131
11394	2026-03-21 02:30:00	7	2.04	220	450.5	t	2026-05-08 00:01:27.547131
11395	2026-03-21 03:00:00	1	2.9	220	554.9	t	2026-05-08 00:01:27.547131
11396	2026-03-21 03:00:00	4	2.68	220	646.3	t	2026-05-08 00:01:27.547131
11397	2026-03-21 03:00:00	7	1.65	220	641.5	t	2026-05-08 00:01:27.547131
11398	2026-03-21 03:30:00	1	2.05	220	343.2	t	2026-05-08 00:01:27.547131
11399	2026-03-21 03:30:00	4	1.95	220	298.3	t	2026-05-08 00:01:27.547131
11400	2026-03-21 03:30:00	7	1.13	220	241	t	2026-05-08 00:01:27.547131
11401	2026-03-21 04:00:00	1	2.33	220	423.5	t	2026-05-08 00:01:27.547131
11402	2026-03-21 04:00:00	4	1.84	220	375	t	2026-05-08 00:01:27.547131
11403	2026-03-21 04:00:00	7	2.83	220	452.3	t	2026-05-08 00:01:27.547131
11404	2026-03-21 04:30:00	1	2.88	220	290.6	t	2026-05-08 00:01:27.547131
11405	2026-03-21 04:30:00	4	1.88	220	656.4	t	2026-05-08 00:01:27.547131
11406	2026-03-21 04:30:00	7	1.58	220	427.7	t	2026-05-08 00:01:27.547131
11407	2026-03-21 05:00:00	1	2.56	220	645	t	2026-05-08 00:01:27.547131
11408	2026-03-21 05:00:00	4	1.12	220	631.8	t	2026-05-08 00:01:27.547131
11409	2026-03-21 05:00:00	7	2.95	220	395.4	t	2026-05-08 00:01:27.547131
11410	2026-03-21 05:30:00	1	2.24	220	465.1	t	2026-05-08 00:01:27.547131
11411	2026-03-21 05:30:00	4	1.8	220	290.1	t	2026-05-08 00:01:27.547131
11412	2026-03-21 05:30:00	7	1.59	220	274.3	t	2026-05-08 00:01:27.547131
11413	2026-03-21 06:00:00	1	2.09	220	302.2	t	2026-05-08 00:01:27.547131
11414	2026-03-21 06:00:00	4	1.99	220	537	t	2026-05-08 00:01:27.547131
11415	2026-03-21 06:00:00	7	1.15	220	655.1	t	2026-05-08 00:01:27.547131
11416	2026-03-21 06:30:00	1	1.15	220	637	t	2026-05-08 00:01:27.547131
11417	2026-03-21 06:30:00	4	2.97	220	455.8	t	2026-05-08 00:01:27.547131
11418	2026-03-21 06:30:00	7	1.7	220	647.5	t	2026-05-08 00:01:27.547131
11419	2026-03-21 07:00:00	1	2.68	220	235.7	t	2026-05-08 00:01:27.547131
11420	2026-03-21 07:00:00	4	2.03	220	639.2	t	2026-05-08 00:01:27.547131
11421	2026-03-21 07:00:00	7	2.32	220	232.9	t	2026-05-08 00:01:27.547131
11422	2026-03-21 07:30:00	1	2.36	220	600.2	t	2026-05-08 00:01:27.547131
11423	2026-03-21 07:30:00	4	2.21	220	627.1	t	2026-05-08 00:01:27.547131
11424	2026-03-21 07:30:00	7	2.3	220	433.2	t	2026-05-08 00:01:27.547131
11425	2026-03-21 08:00:00	1	1.43	220	624.6	t	2026-05-08 00:01:27.547131
11426	2026-03-21 08:00:00	4	1.97	220	281.7	t	2026-05-08 00:01:27.547131
11427	2026-03-21 08:00:00	7	2.18	220	458.6	t	2026-05-08 00:01:27.547131
11428	2026-03-21 08:30:00	1	2.08	220	531.2	t	2026-05-08 00:01:27.547131
11429	2026-03-21 08:30:00	4	2.97	220	394.2	t	2026-05-08 00:01:27.547131
11430	2026-03-21 08:30:00	7	2.66	220	446.7	t	2026-05-08 00:01:27.547131
11431	2026-03-21 09:00:00	1	2.06	220	468.4	t	2026-05-08 00:01:27.547131
11432	2026-03-21 09:00:00	4	2.05	220	410.5	t	2026-05-08 00:01:27.547131
11433	2026-03-21 09:00:00	7	2.02	220	545.8	t	2026-05-08 00:01:27.547131
11434	2026-03-21 09:30:00	1	1.42	220	383.6	t	2026-05-08 00:01:27.547131
11435	2026-03-21 09:30:00	4	1.32	220	378.5	t	2026-05-08 00:01:27.547131
11436	2026-03-21 09:30:00	7	2.07	220	316.6	t	2026-05-08 00:01:27.547131
11437	2026-03-21 10:00:00	1	1.27	220	476.8	t	2026-05-08 00:01:27.547131
11438	2026-03-21 10:00:00	4	1.8	220	380.6	t	2026-05-08 00:01:27.547131
11439	2026-03-21 10:00:00	7	2.24	220	487.8	t	2026-05-08 00:01:27.547131
11440	2026-03-21 10:30:00	1	2.76	220	530.3	t	2026-05-08 00:01:27.547131
11441	2026-03-21 10:30:00	4	2.87	220	467.5	t	2026-05-08 00:01:27.547131
11442	2026-03-21 10:30:00	7	2.32	220	430.8	t	2026-05-08 00:01:27.547131
11443	2026-03-21 11:00:00	1	1.63	220	425.6	t	2026-05-08 00:01:27.547131
11444	2026-03-21 11:00:00	4	1.35	220	456.9	t	2026-05-08 00:01:27.547131
11445	2026-03-21 11:00:00	7	1.31	220	279	t	2026-05-08 00:01:27.547131
11446	2026-03-21 11:30:00	1	1.77	220	324.4	t	2026-05-08 00:01:27.547131
11447	2026-03-21 11:30:00	4	1.35	220	616.9	t	2026-05-08 00:01:27.547131
11448	2026-03-21 11:30:00	7	2.53	220	646.5	t	2026-05-08 00:01:27.547131
11449	2026-03-21 12:00:00	1	1.94	220	538	t	2026-05-08 00:01:27.547131
11450	2026-03-21 12:00:00	4	1.6	220	225.6	t	2026-05-08 00:01:27.547131
11451	2026-03-21 12:00:00	7	2.2	220	558.7	t	2026-05-08 00:01:27.547131
11452	2026-03-21 12:30:00	1	1.31	220	539.2	t	2026-05-08 00:01:27.547131
11453	2026-03-21 12:30:00	4	2.22	220	489.7	t	2026-05-08 00:01:27.547131
11454	2026-03-21 12:30:00	7	2.89	220	617.2	t	2026-05-08 00:01:27.547131
11455	2026-03-21 13:00:00	1	2.17	220	598.2	t	2026-05-08 00:01:27.547131
11456	2026-03-21 13:00:00	4	2.85	220	320.2	t	2026-05-08 00:01:27.547131
11457	2026-03-21 13:00:00	7	2.36	220	555.4	t	2026-05-08 00:01:27.547131
11458	2026-03-21 13:30:00	1	2.33	220	602.5	t	2026-05-08 00:01:27.547131
11459	2026-03-21 13:30:00	4	2.12	220	526.2	t	2026-05-08 00:01:27.547131
11460	2026-03-21 13:30:00	7	1.49	220	342.2	t	2026-05-08 00:01:27.547131
11461	2026-03-21 14:00:00	1	2.06	220	357.6	t	2026-05-08 00:01:27.547131
11462	2026-03-21 14:00:00	4	1.61	220	290.9	t	2026-05-08 00:01:27.547131
11463	2026-03-21 14:00:00	7	1.8	220	455.6	t	2026-05-08 00:01:27.547131
11464	2026-03-21 14:30:00	1	1.36	220	350.2	t	2026-05-08 00:01:27.547131
11465	2026-03-21 14:30:00	4	2.14	220	277.2	t	2026-05-08 00:01:27.547131
11466	2026-03-21 14:30:00	7	2.78	220	500.6	t	2026-05-08 00:01:27.547131
11467	2026-03-21 15:00:00	1	2.84	220	461.1	t	2026-05-08 00:01:27.547131
11468	2026-03-21 15:00:00	4	2.99	220	285.7	t	2026-05-08 00:01:27.547131
11469	2026-03-21 15:00:00	7	1.47	220	256.5	t	2026-05-08 00:01:27.547131
11470	2026-03-21 15:30:00	1	1.04	220	497.4	t	2026-05-08 00:01:27.547131
11471	2026-03-21 15:30:00	4	2.98	220	609.3	t	2026-05-08 00:01:27.547131
11472	2026-03-21 15:30:00	7	1.16	220	637.1	t	2026-05-08 00:01:27.547131
11473	2026-03-21 16:00:00	1	1.9	220	331.8	t	2026-05-08 00:01:27.547131
11474	2026-03-21 16:00:00	4	1.62	220	612.4	t	2026-05-08 00:01:27.547131
11475	2026-03-21 16:00:00	7	2.6	220	404	t	2026-05-08 00:01:27.547131
11476	2026-03-21 16:30:00	1	2.47	220	360	t	2026-05-08 00:01:27.547131
11477	2026-03-21 16:30:00	4	2.81	220	610.1	t	2026-05-08 00:01:27.547131
11478	2026-03-21 16:30:00	7	2.42	220	602.5	t	2026-05-08 00:01:27.547131
11479	2026-03-21 17:00:00	1	2.79	220	560.3	t	2026-05-08 00:01:27.547131
11480	2026-03-21 17:00:00	4	2.16	220	470.9	t	2026-05-08 00:01:27.547131
11481	2026-03-21 17:00:00	7	2.8	220	338.7	t	2026-05-08 00:01:27.547131
11482	2026-03-21 17:30:00	1	1.67	220	361.4	t	2026-05-08 00:01:27.547131
11483	2026-03-21 17:30:00	4	1.56	220	522.2	t	2026-05-08 00:01:27.547131
11484	2026-03-21 17:30:00	7	2.92	220	330.2	t	2026-05-08 00:01:27.547131
11485	2026-03-21 18:00:00	1	1.22	220	574.5	t	2026-05-08 00:01:27.547131
11486	2026-03-21 18:00:00	4	1.22	220	601.8	t	2026-05-08 00:01:27.547131
11487	2026-03-21 18:00:00	7	2.3	220	296.6	t	2026-05-08 00:01:27.547131
11488	2026-03-21 18:30:00	1	2.32	220	590.1	t	2026-05-08 00:01:27.547131
11489	2026-03-21 18:30:00	4	1.53	220	514.7	t	2026-05-08 00:01:27.547131
11490	2026-03-21 18:30:00	7	1.47	220	614	t	2026-05-08 00:01:27.547131
11491	2026-03-21 19:00:00	1	2.76	220	637.6	t	2026-05-08 00:01:27.547131
11492	2026-03-21 19:00:00	4	1.98	220	339.9	t	2026-05-08 00:01:27.547131
11493	2026-03-21 19:00:00	7	2.31	220	521.6	t	2026-05-08 00:01:27.547131
11494	2026-03-21 19:30:00	1	2.43	220	304.6	t	2026-05-08 00:01:27.547131
11495	2026-03-21 19:30:00	4	2.93	220	346.2	t	2026-05-08 00:01:27.547131
11496	2026-03-21 19:30:00	7	2.94	220	446.2	t	2026-05-08 00:01:27.547131
11497	2026-03-21 20:00:00	1	1.96	220	322.4	t	2026-05-08 00:01:27.547131
11498	2026-03-21 20:00:00	4	1.2	220	366.4	t	2026-05-08 00:01:27.547131
11499	2026-03-21 20:00:00	7	1.81	220	477.8	t	2026-05-08 00:01:27.547131
11500	2026-03-21 20:30:00	1	1.21	220	571.4	t	2026-05-08 00:01:27.547131
11501	2026-03-21 20:30:00	4	2.31	220	239.5	t	2026-05-08 00:01:27.547131
11502	2026-03-21 20:30:00	7	2.23	220	326.8	t	2026-05-08 00:01:27.547131
11503	2026-03-21 21:00:00	1	2.91	220	557	t	2026-05-08 00:01:27.547131
11504	2026-03-21 21:00:00	4	2.95	220	424.5	t	2026-05-08 00:01:27.547131
11505	2026-03-21 21:00:00	7	1.79	220	502	t	2026-05-08 00:01:27.547131
11506	2026-03-21 21:30:00	1	2.16	220	492	t	2026-05-08 00:01:27.547131
11507	2026-03-21 21:30:00	4	2.41	220	537.5	t	2026-05-08 00:01:27.547131
11508	2026-03-21 21:30:00	7	2.05	220	472.5	t	2026-05-08 00:01:27.547131
11509	2026-03-21 22:00:00	1	1.48	220	490.5	t	2026-05-08 00:01:27.547131
11510	2026-03-21 22:00:00	4	1.68	220	350.6	t	2026-05-08 00:01:27.547131
11511	2026-03-21 22:00:00	7	1.76	220	324.9	t	2026-05-08 00:01:27.547131
11512	2026-03-21 22:30:00	1	1.77	220	596.8	t	2026-05-08 00:01:27.547131
11513	2026-03-21 22:30:00	4	2.55	220	400.7	t	2026-05-08 00:01:27.547131
11514	2026-03-21 22:30:00	7	2.25	220	648	t	2026-05-08 00:01:27.547131
11515	2026-03-21 23:00:00	1	1.23	220	623.5	t	2026-05-08 00:01:27.547131
11516	2026-03-21 23:00:00	4	1.27	220	223.8	t	2026-05-08 00:01:27.547131
11517	2026-03-21 23:00:00	7	2.64	220	534	t	2026-05-08 00:01:27.547131
11518	2026-03-21 23:30:00	1	1.06	220	577.1	t	2026-05-08 00:01:27.547131
11519	2026-03-21 23:30:00	4	2.36	220	362.2	t	2026-05-08 00:01:27.547131
11520	2026-03-21 23:30:00	7	2.72	220	313.5	t	2026-05-08 00:01:27.547131
11521	2026-03-22 00:00:00	1	2.16	220	480.5	t	2026-05-08 00:01:27.547131
11522	2026-03-22 00:00:00	4	2.91	220	265.2	t	2026-05-08 00:01:27.547131
11523	2026-03-22 00:00:00	7	2.92	220	250.3	t	2026-05-08 00:01:27.547131
11524	2026-03-22 00:30:00	1	1.4	220	656	t	2026-05-08 00:01:27.547131
11525	2026-03-22 00:30:00	4	1.84	220	257.6	t	2026-05-08 00:01:27.547131
11526	2026-03-22 00:30:00	7	1.3	220	635.7	t	2026-05-08 00:01:27.547131
11527	2026-03-22 01:00:00	1	2.47	220	403.3	t	2026-05-08 00:01:27.547131
11528	2026-03-22 01:00:00	4	1.46	220	505.2	t	2026-05-08 00:01:27.547131
11529	2026-03-22 01:00:00	7	1.27	220	518.1	t	2026-05-08 00:01:27.547131
11530	2026-03-22 01:30:00	1	2.2	220	298.9	t	2026-05-08 00:01:27.547131
11531	2026-03-22 01:30:00	4	1.29	220	612.9	t	2026-05-08 00:01:27.547131
11532	2026-03-22 01:30:00	7	2.91	220	620.1	t	2026-05-08 00:01:27.547131
11533	2026-03-22 02:00:00	1	2.51	220	302.3	t	2026-05-08 00:01:27.547131
11534	2026-03-22 02:00:00	4	1.17	220	450.1	t	2026-05-08 00:01:27.547131
11535	2026-03-22 02:00:00	7	1.29	220	338.4	t	2026-05-08 00:01:27.547131
11536	2026-03-22 02:30:00	1	1.86	220	655.8	t	2026-05-08 00:01:27.547131
11537	2026-03-22 02:30:00	4	1.68	220	239.2	t	2026-05-08 00:01:27.547131
11538	2026-03-22 02:30:00	7	2.99	220	363.2	t	2026-05-08 00:01:27.547131
11539	2026-03-22 03:00:00	1	1.24	220	220.1	t	2026-05-08 00:01:27.547131
11540	2026-03-22 03:00:00	4	1.51	220	442.3	t	2026-05-08 00:01:27.547131
11541	2026-03-22 03:00:00	7	1.15	220	440.6	t	2026-05-08 00:01:27.547131
11542	2026-03-22 03:30:00	1	1.4	220	480.2	t	2026-05-08 00:01:27.547131
11543	2026-03-22 03:30:00	4	1.17	220	330.2	t	2026-05-08 00:01:27.547131
11544	2026-03-22 03:30:00	7	2.91	220	233.2	t	2026-05-08 00:01:27.547131
11545	2026-03-22 04:00:00	1	2.18	220	444	t	2026-05-08 00:01:27.547131
11546	2026-03-22 04:00:00	4	2.29	220	646.7	t	2026-05-08 00:01:27.547131
11547	2026-03-22 04:00:00	7	2.48	220	381.8	t	2026-05-08 00:01:27.547131
11548	2026-03-22 04:30:00	1	2.19	220	527.6	t	2026-05-08 00:01:27.547131
11549	2026-03-22 04:30:00	4	2.57	220	417.3	t	2026-05-08 00:01:27.547131
11550	2026-03-22 04:30:00	7	2.23	220	279.9	t	2026-05-08 00:01:27.547131
11551	2026-03-22 05:00:00	1	2.56	220	540.6	t	2026-05-08 00:01:27.547131
11552	2026-03-22 05:00:00	4	1.01	220	423.5	t	2026-05-08 00:01:27.547131
11553	2026-03-22 05:00:00	7	1.72	220	540.9	t	2026-05-08 00:01:27.547131
11554	2026-03-22 05:30:00	1	1.6	220	554.5	t	2026-05-08 00:01:27.547131
11555	2026-03-22 05:30:00	4	1.31	220	363.9	t	2026-05-08 00:01:27.547131
11556	2026-03-22 05:30:00	7	2.75	220	293.6	t	2026-05-08 00:01:27.547131
11557	2026-03-22 06:00:00	1	1.05	220	446.1	t	2026-05-08 00:01:27.547131
11558	2026-03-22 06:00:00	4	2.02	220	565.5	t	2026-05-08 00:01:27.547131
11559	2026-03-22 06:00:00	7	1.2	220	617.9	t	2026-05-08 00:01:27.547131
11560	2026-03-22 06:30:00	1	1.88	220	441.2	t	2026-05-08 00:01:27.547131
11561	2026-03-22 06:30:00	4	1.97	220	383.6	t	2026-05-08 00:01:27.547131
11562	2026-03-22 06:30:00	7	2.16	220	626.5	t	2026-05-08 00:01:27.547131
11563	2026-03-22 07:00:00	1	2.21	220	476.6	t	2026-05-08 00:01:27.547131
11564	2026-03-22 07:00:00	4	2.32	220	542.7	t	2026-05-08 00:01:27.547131
11565	2026-03-22 07:00:00	7	1.21	220	497.8	t	2026-05-08 00:01:27.547131
11566	2026-03-22 07:30:00	1	1.68	220	635.1	t	2026-05-08 00:01:27.547131
11567	2026-03-22 07:30:00	4	2.83	220	248.5	t	2026-05-08 00:01:27.547131
11568	2026-03-22 07:30:00	7	1.33	220	274.2	t	2026-05-08 00:01:27.547131
11569	2026-03-22 08:00:00	1	1.96	220	261.7	t	2026-05-08 00:01:27.547131
11570	2026-03-22 08:00:00	4	1.88	220	649.7	t	2026-05-08 00:01:27.547131
11571	2026-03-22 08:00:00	7	1.67	220	560.2	t	2026-05-08 00:01:27.547131
11572	2026-03-22 08:30:00	1	1.51	220	504.8	t	2026-05-08 00:01:27.547131
11573	2026-03-22 08:30:00	4	1.46	220	537.8	t	2026-05-08 00:01:27.547131
11574	2026-03-22 08:30:00	7	1.83	220	316.7	t	2026-05-08 00:01:27.547131
11575	2026-03-22 09:00:00	1	1.25	220	493	t	2026-05-08 00:01:27.547131
11576	2026-03-22 09:00:00	4	1.12	220	272.5	t	2026-05-08 00:01:27.547131
11577	2026-03-22 09:00:00	7	1.33	220	441.4	t	2026-05-08 00:01:27.547131
11578	2026-03-22 09:30:00	1	2.1	220	397.5	t	2026-05-08 00:01:27.547131
11579	2026-03-22 09:30:00	4	2.82	220	573.3	t	2026-05-08 00:01:27.547131
11580	2026-03-22 09:30:00	7	1.66	220	434.6	t	2026-05-08 00:01:27.547131
11581	2026-03-22 10:00:00	1	1.72	220	302.3	t	2026-05-08 00:01:27.547131
11582	2026-03-22 10:00:00	4	2.93	220	564.6	t	2026-05-08 00:01:27.547131
11583	2026-03-22 10:00:00	7	2.98	220	553.7	t	2026-05-08 00:01:27.547131
11584	2026-03-22 10:30:00	1	1.73	220	362.3	t	2026-05-08 00:01:27.547131
11585	2026-03-22 10:30:00	4	1.53	220	537.5	t	2026-05-08 00:01:27.547131
11586	2026-03-22 10:30:00	7	1.27	220	275.2	t	2026-05-08 00:01:27.547131
11587	2026-03-22 11:00:00	1	2.46	220	333.9	t	2026-05-08 00:01:27.547131
11588	2026-03-22 11:00:00	4	1.7	220	229.7	t	2026-05-08 00:01:27.547131
11589	2026-03-22 11:00:00	7	2.77	220	444.8	t	2026-05-08 00:01:27.547131
11590	2026-03-22 11:30:00	1	1.11	220	243.4	t	2026-05-08 00:01:27.547131
11591	2026-03-22 11:30:00	4	2.29	220	445.1	t	2026-05-08 00:01:27.547131
11592	2026-03-22 11:30:00	7	1.81	220	316	t	2026-05-08 00:01:27.547131
11593	2026-03-22 12:00:00	1	1.59	220	283.9	t	2026-05-08 00:01:27.547131
11594	2026-03-22 12:00:00	4	1.17	220	567.1	t	2026-05-08 00:01:27.547131
11595	2026-03-22 12:00:00	7	1.6	220	463.3	t	2026-05-08 00:01:27.547131
11596	2026-03-22 12:30:00	1	2.59	220	234.9	t	2026-05-08 00:01:27.547131
11597	2026-03-22 12:30:00	4	2.86	220	256.1	t	2026-05-08 00:01:27.547131
11598	2026-03-22 12:30:00	7	2.98	220	328.1	t	2026-05-08 00:01:27.547131
11599	2026-03-22 13:00:00	1	2.14	220	653.1	t	2026-05-08 00:01:27.547131
11600	2026-03-22 13:00:00	4	1.35	220	528.5	t	2026-05-08 00:01:27.547131
11601	2026-03-22 13:00:00	7	1.62	220	399.9	t	2026-05-08 00:01:27.547131
11602	2026-03-22 13:30:00	1	2.09	220	333.3	t	2026-05-08 00:01:27.547131
11603	2026-03-22 13:30:00	4	1.06	220	267	t	2026-05-08 00:01:27.547131
11604	2026-03-22 13:30:00	7	1.46	220	540.3	t	2026-05-08 00:01:27.547131
11605	2026-03-22 14:00:00	1	2.69	220	376.5	t	2026-05-08 00:01:27.547131
11606	2026-03-22 14:00:00	4	2.97	220	348.7	t	2026-05-08 00:01:27.547131
11607	2026-03-22 14:00:00	7	1.8	220	640.4	t	2026-05-08 00:01:27.547131
11608	2026-03-22 14:30:00	1	1.2	220	475.2	t	2026-05-08 00:01:27.547131
11609	2026-03-22 14:30:00	4	1.55	220	302.4	t	2026-05-08 00:01:27.547131
11610	2026-03-22 14:30:00	7	1.16	220	391.1	t	2026-05-08 00:01:27.547131
11611	2026-03-22 15:00:00	1	2.35	220	482	t	2026-05-08 00:01:27.547131
11612	2026-03-22 15:00:00	4	2.94	220	423.6	t	2026-05-08 00:01:27.547131
11613	2026-03-22 15:00:00	7	1.78	220	261.6	t	2026-05-08 00:01:27.547131
11614	2026-03-22 15:30:00	1	2.43	220	618.2	t	2026-05-08 00:01:27.547131
11615	2026-03-22 15:30:00	4	2.75	220	377.2	t	2026-05-08 00:01:27.547131
11616	2026-03-22 15:30:00	7	2.37	220	592	t	2026-05-08 00:01:27.547131
11617	2026-03-22 16:00:00	1	2.42	220	562.5	t	2026-05-08 00:01:27.547131
11618	2026-03-22 16:00:00	4	2.73	220	473.6	t	2026-05-08 00:01:27.547131
11619	2026-03-22 16:00:00	7	1.05	220	307.2	t	2026-05-08 00:01:27.547131
11620	2026-03-22 16:30:00	1	2.35	220	342.1	t	2026-05-08 00:01:27.547131
11621	2026-03-22 16:30:00	4	1.62	220	425.2	t	2026-05-08 00:01:27.547131
11622	2026-03-22 16:30:00	7	1.34	220	415	t	2026-05-08 00:01:27.547131
11623	2026-03-22 17:00:00	1	2.25	220	607.2	t	2026-05-08 00:01:27.547131
11624	2026-03-22 17:00:00	4	1.16	220	518.4	t	2026-05-08 00:01:27.547131
11625	2026-03-22 17:00:00	7	1.25	220	234.7	t	2026-05-08 00:01:27.547131
11626	2026-03-22 17:30:00	1	1.83	220	519.2	t	2026-05-08 00:01:27.547131
11627	2026-03-22 17:30:00	4	2.11	220	364.2	t	2026-05-08 00:01:27.547131
11628	2026-03-22 17:30:00	7	2.92	220	301.8	t	2026-05-08 00:01:27.547131
11629	2026-03-22 18:00:00	1	2.77	220	653.7	t	2026-05-08 00:01:27.547131
11630	2026-03-22 18:00:00	4	1.88	220	306	t	2026-05-08 00:01:27.547131
11631	2026-03-22 18:00:00	7	2.13	220	561.1	t	2026-05-08 00:01:27.547131
11632	2026-03-22 18:30:00	1	2.67	220	442.1	t	2026-05-08 00:01:27.547131
11633	2026-03-22 18:30:00	4	1.05	220	362.3	t	2026-05-08 00:01:27.547131
11634	2026-03-22 18:30:00	7	1.15	220	233.8	t	2026-05-08 00:01:27.547131
11635	2026-03-22 19:00:00	1	1.4	220	554.5	t	2026-05-08 00:01:27.547131
11636	2026-03-22 19:00:00	4	1.13	220	633.1	t	2026-05-08 00:01:27.547131
11637	2026-03-22 19:00:00	7	2.3	220	276.4	t	2026-05-08 00:01:27.547131
11638	2026-03-22 19:30:00	1	2.51	220	556.5	t	2026-05-08 00:01:27.547131
11639	2026-03-22 19:30:00	4	1.06	220	488.2	t	2026-05-08 00:01:27.547131
11640	2026-03-22 19:30:00	7	2.8	220	336.8	t	2026-05-08 00:01:27.547131
11641	2026-03-22 20:00:00	1	2.47	220	231.2	t	2026-05-08 00:01:27.547131
11642	2026-03-22 20:00:00	4	1.06	220	335.2	t	2026-05-08 00:01:27.547131
11643	2026-03-22 20:00:00	7	2.36	220	648.8	t	2026-05-08 00:01:27.547131
11644	2026-03-22 20:30:00	1	1.88	220	366.8	t	2026-05-08 00:01:27.547131
11645	2026-03-22 20:30:00	4	1.68	220	433.6	t	2026-05-08 00:01:27.547131
11646	2026-03-22 20:30:00	7	2.98	220	477.6	t	2026-05-08 00:01:27.547131
11647	2026-03-22 21:00:00	1	2.32	220	391.3	t	2026-05-08 00:01:27.547131
11648	2026-03-22 21:00:00	4	1.05	220	415.2	t	2026-05-08 00:01:27.547131
11649	2026-03-22 21:00:00	7	1.13	220	411.1	t	2026-05-08 00:01:27.547131
11650	2026-03-22 21:30:00	1	1.42	220	597	t	2026-05-08 00:01:27.547131
11651	2026-03-22 21:30:00	4	1.79	220	654.6	t	2026-05-08 00:01:27.547131
11652	2026-03-22 21:30:00	7	2.47	220	514.4	t	2026-05-08 00:01:27.547131
11653	2026-03-22 22:00:00	1	2.94	220	287.7	t	2026-05-08 00:01:27.547131
11654	2026-03-22 22:00:00	4	1.09	220	537.8	t	2026-05-08 00:01:27.547131
11655	2026-03-22 22:00:00	7	1.55	220	598.9	t	2026-05-08 00:01:27.547131
11656	2026-03-22 22:30:00	1	2.08	220	487	t	2026-05-08 00:01:27.547131
11657	2026-03-22 22:30:00	4	2	220	608	t	2026-05-08 00:01:27.547131
11658	2026-03-22 22:30:00	7	2.68	220	446.7	t	2026-05-08 00:01:27.547131
11659	2026-03-22 23:00:00	1	1.24	220	625.3	t	2026-05-08 00:01:27.547131
11660	2026-03-22 23:00:00	4	2.4	220	614.8	t	2026-05-08 00:01:27.547131
11661	2026-03-22 23:00:00	7	2.1	220	323.8	t	2026-05-08 00:01:27.547131
11662	2026-03-22 23:30:00	1	1.87	220	592.3	t	2026-05-08 00:01:27.547131
11663	2026-03-22 23:30:00	4	1	220	527	t	2026-05-08 00:01:27.547131
11664	2026-03-22 23:30:00	7	2.26	220	375.7	t	2026-05-08 00:01:27.547131
11665	2026-03-23 00:00:00	1	2.35	220	273.7	t	2026-05-08 00:01:27.547131
11666	2026-03-23 00:00:00	4	3.46	220	315.2	t	2026-05-08 00:01:27.547131
11667	2026-03-23 00:00:00	7	3.35	220	318.8	t	2026-05-08 00:01:27.547131
11668	2026-03-23 00:30:00	1	2.42	220	558.5	t	2026-05-08 00:01:27.547131
11669	2026-03-23 00:30:00	4	2.82	220	408.2	t	2026-05-08 00:01:27.547131
11670	2026-03-23 00:30:00	7	3.45	220	573.7	t	2026-05-08 00:01:27.547131
11671	2026-03-23 01:00:00	1	1.73	220	531.3	t	2026-05-08 00:01:27.547131
11672	2026-03-23 01:00:00	4	2.5	220	469.5	t	2026-05-08 00:01:27.547131
11673	2026-03-23 01:00:00	7	2.86	220	436.9	t	2026-05-08 00:01:27.547131
11674	2026-03-23 01:30:00	1	3.16	220	317.1	t	2026-05-08 00:01:27.547131
11675	2026-03-23 01:30:00	4	2.01	220	798.3	t	2026-05-08 00:01:27.547131
11676	2026-03-23 01:30:00	7	3.59	220	700.2	t	2026-05-08 00:01:27.547131
11677	2026-03-23 02:00:00	1	3.43	220	422.2	t	2026-05-08 00:01:27.547131
11678	2026-03-23 02:00:00	4	1.56	220	701.7	t	2026-05-08 00:01:27.547131
11679	2026-03-23 02:00:00	7	2.88	220	340.3	t	2026-05-08 00:01:27.547131
11680	2026-03-23 02:30:00	1	2.24	220	625.5	t	2026-05-08 00:01:27.547131
11681	2026-03-23 02:30:00	4	1.27	220	549.3	t	2026-05-08 00:01:27.547131
11682	2026-03-23 02:30:00	7	2.6	220	641.1	t	2026-05-08 00:01:27.547131
11683	2026-03-23 03:00:00	1	3.67	220	584.1	t	2026-05-08 00:01:27.547131
11684	2026-03-23 03:00:00	4	3.22	220	266.3	t	2026-05-08 00:01:27.547131
11685	2026-03-23 03:00:00	7	2.98	220	792.5	t	2026-05-08 00:01:27.547131
11686	2026-03-23 03:30:00	1	1.75	220	472.2	t	2026-05-08 00:01:27.547131
11687	2026-03-23 03:30:00	4	1.43	220	809.3	t	2026-05-08 00:01:27.547131
11688	2026-03-23 03:30:00	7	1.84	220	737.8	t	2026-05-08 00:01:27.547131
11689	2026-03-23 04:00:00	1	3.16	220	358.2	t	2026-05-08 00:01:27.547131
11690	2026-03-23 04:00:00	4	1.22	220	416.1	t	2026-05-08 00:01:27.547131
11691	2026-03-23 04:00:00	7	2.78	220	798.1	t	2026-05-08 00:01:27.547131
11692	2026-03-23 04:30:00	1	2.44	220	548.8	t	2026-05-08 00:01:27.547131
11693	2026-03-23 04:30:00	4	2.66	220	473.4	t	2026-05-08 00:01:27.547131
11694	2026-03-23 04:30:00	7	2.07	220	575.3	t	2026-05-08 00:01:27.547131
11695	2026-03-23 05:00:00	1	2.1	220	378.8	t	2026-05-08 00:01:27.547131
11696	2026-03-23 05:00:00	4	1.98	220	279.8	t	2026-05-08 00:01:27.547131
11697	2026-03-23 05:00:00	7	2.43	220	302.7	t	2026-05-08 00:01:27.547131
11698	2026-03-23 05:30:00	1	1.54	220	292.7	t	2026-05-08 00:01:27.547131
11699	2026-03-23 05:30:00	4	3.63	220	601.3	t	2026-05-08 00:01:27.547131
11700	2026-03-23 05:30:00	7	3.66	220	690.7	t	2026-05-08 00:01:27.547131
11701	2026-03-23 06:00:00	1	3.56	220	447.1	t	2026-05-08 00:01:27.547131
11702	2026-03-23 06:00:00	4	2.87	220	608.2	t	2026-05-08 00:01:27.547131
11703	2026-03-23 06:00:00	7	3.62	220	316.8	t	2026-05-08 00:01:27.547131
11704	2026-03-23 06:30:00	1	2.88	220	318.8	t	2026-05-08 00:01:27.547131
11705	2026-03-23 06:30:00	4	1.94	220	592.9	t	2026-05-08 00:01:27.547131
11706	2026-03-23 06:30:00	7	1.29	220	393.9	t	2026-05-08 00:01:27.547131
11707	2026-03-23 07:00:00	1	17.83	220	4240.5	t	2026-05-08 00:01:27.547131
11708	2026-03-23 07:00:00	4	16.65	220	4701.4	t	2026-05-08 00:01:27.547131
11709	2026-03-23 07:00:00	7	25.47	220	5294.4	t	2026-05-08 00:01:27.547131
11710	2026-03-23 07:30:00	1	17.74	220	3369	t	2026-05-08 00:01:27.547131
11711	2026-03-23 07:30:00	4	22	220	5683.8	t	2026-05-08 00:01:27.547131
11712	2026-03-23 07:30:00	7	28.02	220	6244.8	t	2026-05-08 00:01:27.547131
11713	2026-03-23 08:00:00	1	13.2	220	4076.9	t	2026-05-08 00:01:27.547131
11714	2026-03-23 08:00:00	4	16.82	220	4934.1	t	2026-05-08 00:01:27.547131
11715	2026-03-23 08:00:00	7	28.84	220	5770.4	t	2026-05-08 00:01:27.547131
11716	2026-03-23 08:30:00	1	16.29	220	3552.1	t	2026-05-08 00:01:27.547131
11717	2026-03-23 08:30:00	4	22.93	220	4139.3	t	2026-05-08 00:01:27.547131
11718	2026-03-23 08:30:00	7	23.59	220	6052.1	t	2026-05-08 00:01:27.547131
11719	2026-03-23 09:00:00	1	16.01	220	2620.5	t	2026-05-08 00:01:27.547131
11720	2026-03-23 09:00:00	4	24.09	220	3793.4	t	2026-05-08 00:01:27.547131
11721	2026-03-23 09:00:00	7	29.05	220	4988.4	t	2026-05-08 00:01:27.547131
11722	2026-03-23 09:30:00	1	16.49	220	2581.3	t	2026-05-08 00:01:27.547131
11723	2026-03-23 09:30:00	4	25.02	220	5324.1	t	2026-05-08 00:01:27.547131
11724	2026-03-23 09:30:00	7	29.68	220	5410.8	t	2026-05-08 00:01:27.547131
11725	2026-03-23 10:00:00	1	18.67	220	4204.5	t	2026-05-08 00:01:27.547131
11726	2026-03-23 10:00:00	4	20.37	220	3751.1	t	2026-05-08 00:01:27.547131
11727	2026-03-23 10:00:00	7	25.16	220	4580.5	t	2026-05-08 00:01:27.547131
11728	2026-03-23 10:30:00	1	16.52	220	4545.2	t	2026-05-08 00:01:27.547131
11729	2026-03-23 10:30:00	4	19.53	220	4251.2	t	2026-05-08 00:01:27.547131
11730	2026-03-23 10:30:00	7	26.34	220	5725.6	t	2026-05-08 00:01:27.547131
11731	2026-03-23 11:00:00	1	21.01	220	3147.8	t	2026-05-08 00:01:27.547131
11732	2026-03-23 11:00:00	4	24.03	220	4992.1	t	2026-05-08 00:01:27.547131
11733	2026-03-23 11:00:00	7	21.01	220	4590	t	2026-05-08 00:01:27.547131
11734	2026-03-23 11:30:00	1	16.17	220	4312.6	t	2026-05-08 00:01:27.547131
11735	2026-03-23 11:30:00	4	17.18	220	3885.4	t	2026-05-08 00:01:27.547131
11736	2026-03-23 11:30:00	7	21.06	220	5647.4	t	2026-05-08 00:01:27.547131
11737	2026-03-23 12:00:00	1	12.53	220	3460	t	2026-05-08 00:01:27.547131
11738	2026-03-23 12:00:00	4	16.17	220	3665.4	t	2026-05-08 00:01:27.547131
11739	2026-03-23 12:00:00	7	20.75	220	6614.1	t	2026-05-08 00:01:27.547131
11740	2026-03-23 12:30:00	1	12.78	220	3432.2	t	2026-05-08 00:01:27.547131
11741	2026-03-23 12:30:00	4	22.17	220	3749.6	t	2026-05-08 00:01:27.547131
11742	2026-03-23 12:30:00	7	22.94	220	6557.1	t	2026-05-08 00:01:27.547131
11743	2026-03-23 13:00:00	1	15.3	220	2815	t	2026-05-08 00:01:27.547131
11744	2026-03-23 13:00:00	4	21.35	220	4687.5	t	2026-05-08 00:01:27.547131
11745	2026-03-23 13:00:00	7	24.91	220	4653.9	t	2026-05-08 00:01:27.547131
11746	2026-03-23 13:30:00	1	19.32	220	3735.1	t	2026-05-08 00:01:27.547131
11747	2026-03-23 13:30:00	4	17.93	220	5653.4	t	2026-05-08 00:01:27.547131
11748	2026-03-23 13:30:00	7	29.3	220	4957.3	t	2026-05-08 00:01:27.547131
11749	2026-03-23 14:00:00	1	19.87	220	4321.8	t	2026-05-08 00:01:27.547131
11750	2026-03-23 14:00:00	4	25.9	220	4317.3	t	2026-05-08 00:01:27.547131
11751	2026-03-23 14:00:00	7	28.16	220	5772.1	t	2026-05-08 00:01:27.547131
11752	2026-03-23 14:30:00	1	13.85	220	3629.5	t	2026-05-08 00:01:27.547131
11753	2026-03-23 14:30:00	4	16.63	220	5464.9	t	2026-05-08 00:01:27.547131
11754	2026-03-23 14:30:00	7	28.42	220	5726.3	t	2026-05-08 00:01:27.547131
11755	2026-03-23 15:00:00	1	15.64	220	2758	t	2026-05-08 00:01:27.547131
11756	2026-03-23 15:00:00	4	23.66	220	5415	t	2026-05-08 00:01:27.547131
11757	2026-03-23 15:00:00	7	26.22	220	6694.5	t	2026-05-08 00:01:27.547131
11758	2026-03-23 15:30:00	1	19.56	220	4162.2	t	2026-05-08 00:01:27.547131
11759	2026-03-23 15:30:00	4	25.37	220	4172.4	t	2026-05-08 00:01:27.547131
11760	2026-03-23 15:30:00	7	26.06	220	4580.4	t	2026-05-08 00:01:27.547131
11761	2026-03-23 16:00:00	1	12.75	220	4065.9	t	2026-05-08 00:01:27.547131
11762	2026-03-23 16:00:00	4	19.28	220	5453.9	t	2026-05-08 00:01:27.547131
11763	2026-03-23 16:00:00	7	22.82	220	4636.2	t	2026-05-08 00:01:27.547131
11764	2026-03-23 16:30:00	1	19.51	220	2612.1	t	2026-05-08 00:01:27.547131
11765	2026-03-23 16:30:00	4	25.8	220	4994.6	t	2026-05-08 00:01:27.547131
11766	2026-03-23 16:30:00	7	24.7	220	5396.4	t	2026-05-08 00:01:27.547131
11767	2026-03-23 17:00:00	1	17.18	220	3313.4	t	2026-05-08 00:01:27.547131
11768	2026-03-23 17:00:00	4	20.97	220	4898.8	t	2026-05-08 00:01:27.547131
11769	2026-03-23 17:00:00	7	23.96	220	5850.5	t	2026-05-08 00:01:27.547131
11770	2026-03-23 17:30:00	1	14.34	220	3701.5	t	2026-05-08 00:01:27.547131
11771	2026-03-23 17:30:00	4	21.18	220	4470.5	t	2026-05-08 00:01:27.547131
11772	2026-03-23 17:30:00	7	27.39	220	5493.1	t	2026-05-08 00:01:27.547131
11773	2026-03-23 18:00:00	1	19.37	220	4324.1	t	2026-05-08 00:01:27.547131
11774	2026-03-23 18:00:00	4	21.42	220	5006.4	t	2026-05-08 00:01:27.547131
11775	2026-03-23 18:00:00	7	23.81	220	6183.5	t	2026-05-08 00:01:27.547131
11776	2026-03-23 18:30:00	1	11.95	220	3934.9	t	2026-05-08 00:01:27.547131
11777	2026-03-23 18:30:00	4	17.91	220	5011.5	t	2026-05-08 00:01:27.547131
11778	2026-03-23 18:30:00	7	26.6	220	4832.9	t	2026-05-08 00:01:27.547131
11779	2026-03-23 19:00:00	1	20.55	220	4524.3	t	2026-05-08 00:01:27.547131
11780	2026-03-23 19:00:00	4	18.01	220	3804.1	t	2026-05-08 00:01:27.547131
11781	2026-03-23 19:00:00	7	27.01	220	6628.7	t	2026-05-08 00:01:27.547131
11782	2026-03-23 19:30:00	1	19.35	220	3812.3	t	2026-05-08 00:01:27.547131
11783	2026-03-23 19:30:00	4	16.11	220	4761	t	2026-05-08 00:01:27.547131
11784	2026-03-23 19:30:00	7	25.18	220	5757.5	t	2026-05-08 00:01:27.547131
11785	2026-03-23 20:00:00	1	1.93	220	778.6	t	2026-05-08 00:01:27.547131
11786	2026-03-23 20:00:00	4	2.39	220	411.5	t	2026-05-08 00:01:27.547131
11787	2026-03-23 20:00:00	7	2.99	220	597.5	t	2026-05-08 00:01:27.547131
11788	2026-03-23 20:30:00	1	2.77	220	788	t	2026-05-08 00:01:27.547131
11789	2026-03-23 20:30:00	4	2.58	220	762.9	t	2026-05-08 00:01:27.547131
11790	2026-03-23 20:30:00	7	1.92	220	595.2	t	2026-05-08 00:01:27.547131
11791	2026-03-23 21:00:00	1	1.89	220	739.7	t	2026-05-08 00:01:27.547131
11792	2026-03-23 21:00:00	4	3.49	220	463.8	t	2026-05-08 00:01:27.547131
11793	2026-03-23 21:00:00	7	1.8	220	586.7	t	2026-05-08 00:01:27.547131
11794	2026-03-23 21:30:00	1	2.85	220	405.4	t	2026-05-08 00:01:27.547131
11795	2026-03-23 21:30:00	4	3.45	220	359.1	t	2026-05-08 00:01:27.547131
11796	2026-03-23 21:30:00	7	1.31	220	270	t	2026-05-08 00:01:27.547131
11797	2026-03-23 22:00:00	1	1.51	220	616.9	t	2026-05-08 00:01:27.547131
11798	2026-03-23 22:00:00	4	1.43	220	483.5	t	2026-05-08 00:01:27.547131
11799	2026-03-23 22:00:00	7	3.13	220	360.8	t	2026-05-08 00:01:27.547131
11800	2026-03-23 22:30:00	1	2.41	220	547.3	t	2026-05-08 00:01:27.547131
11801	2026-03-23 22:30:00	4	2.53	220	312.3	t	2026-05-08 00:01:27.547131
11802	2026-03-23 22:30:00	7	3.09	220	637.2	t	2026-05-08 00:01:27.547131
11803	2026-03-23 23:00:00	1	1.65	220	389.8	t	2026-05-08 00:01:27.547131
11804	2026-03-23 23:00:00	4	3.67	220	287.3	t	2026-05-08 00:01:27.547131
11805	2026-03-23 23:00:00	7	3.48	220	330.3	t	2026-05-08 00:01:27.547131
11806	2026-03-23 23:30:00	1	2.55	220	649	t	2026-05-08 00:01:27.547131
11807	2026-03-23 23:30:00	4	2.29	220	657.6	t	2026-05-08 00:01:27.547131
11808	2026-03-23 23:30:00	7	2.52	220	769.4	t	2026-05-08 00:01:27.547131
11809	2026-03-24 00:00:00	1	1.92	220	610.1	t	2026-05-08 00:01:27.547131
11810	2026-03-24 00:00:00	4	2.26	220	565.6	t	2026-05-08 00:01:27.547131
11811	2026-03-24 00:00:00	7	1.87	220	417.6	t	2026-05-08 00:01:27.547131
11812	2026-03-24 00:30:00	1	1.21	220	286.1	t	2026-05-08 00:01:27.547131
11813	2026-03-24 00:30:00	4	2.89	220	487.5	t	2026-05-08 00:01:27.547131
11814	2026-03-24 00:30:00	7	1.31	220	807.5	t	2026-05-08 00:01:27.547131
11815	2026-03-24 01:00:00	1	1.79	220	361.4	t	2026-05-08 00:01:27.547131
11816	2026-03-24 01:00:00	4	1.62	220	735.4	t	2026-05-08 00:01:27.547131
11817	2026-03-24 01:00:00	7	3.37	220	516.9	t	2026-05-08 00:01:27.547131
11818	2026-03-24 01:30:00	1	2.33	220	654.5	t	2026-05-08 00:01:27.547131
11819	2026-03-24 01:30:00	4	2.5	220	553.9	t	2026-05-08 00:01:27.547131
11820	2026-03-24 01:30:00	7	1.72	220	717.8	t	2026-05-08 00:01:27.547131
11821	2026-03-24 02:00:00	1	2.98	220	598	t	2026-05-08 00:01:27.547131
11822	2026-03-24 02:00:00	4	2.86	220	693.4	t	2026-05-08 00:01:27.547131
11823	2026-03-24 02:00:00	7	2.35	220	581.9	t	2026-05-08 00:01:27.547131
11824	2026-03-24 02:30:00	1	1.37	220	362.5	t	2026-05-08 00:01:27.547131
11825	2026-03-24 02:30:00	4	2.05	220	543.3	t	2026-05-08 00:01:27.547131
11826	2026-03-24 02:30:00	7	2.67	220	412	t	2026-05-08 00:01:27.547131
11827	2026-03-24 03:00:00	1	1.79	220	700.9	t	2026-05-08 00:01:27.547131
11828	2026-03-24 03:00:00	4	1.51	220	727.1	t	2026-05-08 00:01:27.547131
11829	2026-03-24 03:00:00	7	3.06	220	658.2	t	2026-05-08 00:01:27.547131
11830	2026-03-24 03:30:00	1	2.35	220	496.7	t	2026-05-08 00:01:27.547131
11831	2026-03-24 03:30:00	4	1.32	220	695.9	t	2026-05-08 00:01:27.547131
11832	2026-03-24 03:30:00	7	1.22	220	499.3	t	2026-05-08 00:01:27.547131
11833	2026-03-24 04:00:00	1	3.08	220	276.7	t	2026-05-08 00:01:27.547131
11834	2026-03-24 04:00:00	4	2.3	220	668	t	2026-05-08 00:01:27.547131
11835	2026-03-24 04:00:00	7	2.43	220	418	t	2026-05-08 00:01:27.547131
11836	2026-03-24 04:30:00	1	3.65	220	640	t	2026-05-08 00:01:27.547131
11837	2026-03-24 04:30:00	4	1.33	220	641.8	t	2026-05-08 00:01:27.547131
11838	2026-03-24 04:30:00	7	3.08	220	772.7	t	2026-05-08 00:01:27.547131
11839	2026-03-24 05:00:00	1	1.27	220	801.6	t	2026-05-08 00:01:27.547131
11840	2026-03-24 05:00:00	4	2.9	220	412.6	t	2026-05-08 00:01:27.547131
11841	2026-03-24 05:00:00	7	2.49	220	677	t	2026-05-08 00:01:27.547131
11842	2026-03-24 05:30:00	1	2.82	220	651.2	t	2026-05-08 00:01:27.547131
11843	2026-03-24 05:30:00	4	3.61	220	687.5	t	2026-05-08 00:01:27.547131
11844	2026-03-24 05:30:00	7	3.23	220	345.2	t	2026-05-08 00:01:27.547131
11845	2026-03-24 06:00:00	1	2.38	220	541.9	t	2026-05-08 00:01:27.547131
11846	2026-03-24 06:00:00	4	1.58	220	329.7	t	2026-05-08 00:01:27.547131
11847	2026-03-24 06:00:00	7	1.47	220	741.2	t	2026-05-08 00:01:27.547131
11848	2026-03-24 06:30:00	1	3.62	220	335.4	t	2026-05-08 00:01:27.547131
11849	2026-03-24 06:30:00	4	3.27	220	725.5	t	2026-05-08 00:01:27.547131
11850	2026-03-24 06:30:00	7	2.06	220	484.6	t	2026-05-08 00:01:27.547131
11851	2026-03-24 07:00:00	1	18.94	220	3306.8	t	2026-05-08 00:01:27.547131
11852	2026-03-24 07:00:00	4	22.18	220	3527.1	t	2026-05-08 00:01:27.547131
11853	2026-03-24 07:00:00	7	25.62	220	6107.2	t	2026-05-08 00:01:27.547131
11854	2026-03-24 07:30:00	1	12.77	220	2555.1	t	2026-05-08 00:01:27.547131
11855	2026-03-24 07:30:00	4	19.13	220	4411.6	t	2026-05-08 00:01:27.547131
11856	2026-03-24 07:30:00	7	27.32	220	6432.5	t	2026-05-08 00:01:27.547131
11857	2026-03-24 08:00:00	1	16.27	220	3727.5	t	2026-05-08 00:01:27.547131
11858	2026-03-24 08:00:00	4	17.83	220	5519.4	t	2026-05-08 00:01:27.547131
11859	2026-03-24 08:00:00	7	27.88	220	5246.6	t	2026-05-08 00:01:27.547131
11860	2026-03-24 08:30:00	1	13.46	220	3359.1	t	2026-05-08 00:01:27.547131
11861	2026-03-24 08:30:00	4	25.55	220	3859.8	t	2026-05-08 00:01:27.547131
11862	2026-03-24 08:30:00	7	20.95	220	5038.6	t	2026-05-08 00:01:27.547131
11863	2026-03-24 09:00:00	1	15.28	220	3633.7	t	2026-05-08 00:01:27.547131
11864	2026-03-24 09:00:00	4	18.18	220	4740.8	t	2026-05-08 00:01:27.547131
11865	2026-03-24 09:00:00	7	24.35	220	6240.3	t	2026-05-08 00:01:27.547131
11866	2026-03-24 09:30:00	1	20.02	220	3293.2	t	2026-05-08 00:01:27.547131
11867	2026-03-24 09:30:00	4	23.21	220	4999.2	t	2026-05-08 00:01:27.547131
11868	2026-03-24 09:30:00	7	23.09	220	5574.8	t	2026-05-08 00:01:27.547131
11869	2026-03-24 10:00:00	1	17.11	220	4526.1	t	2026-05-08 00:01:27.547131
11870	2026-03-24 10:00:00	4	20.81	220	5212.1	t	2026-05-08 00:01:27.547131
11871	2026-03-24 10:00:00	7	29.76	220	5074.8	t	2026-05-08 00:01:27.547131
11872	2026-03-24 10:30:00	1	17.94	220	3704.5	t	2026-05-08 00:01:27.547131
11873	2026-03-24 10:30:00	4	16.69	220	5465.5	t	2026-05-08 00:01:27.547131
11874	2026-03-24 10:30:00	7	22.08	220	6601.9	t	2026-05-08 00:01:27.547131
11875	2026-03-24 11:00:00	1	21.44	220	3111.6	t	2026-05-08 00:01:27.547131
11876	2026-03-24 11:00:00	4	24.24	220	4461.1	t	2026-05-08 00:01:27.547131
11877	2026-03-24 11:00:00	7	25.89	220	4644.2	t	2026-05-08 00:01:27.547131
11878	2026-03-24 11:30:00	1	18.49	220	4294	t	2026-05-08 00:01:27.547131
11879	2026-03-24 11:30:00	4	22.19	220	4385.9	t	2026-05-08 00:01:27.547131
11880	2026-03-24 11:30:00	7	25.74	220	5203.7	t	2026-05-08 00:01:27.547131
11881	2026-03-24 12:00:00	1	18.76	220	3916.1	t	2026-05-08 00:01:27.547131
11882	2026-03-24 12:00:00	4	18.08	220	5698.9	t	2026-05-08 00:01:27.547131
11883	2026-03-24 12:00:00	7	28.33	220	6670.8	t	2026-05-08 00:01:27.547131
11884	2026-03-24 12:30:00	1	20.3	220	3798	t	2026-05-08 00:01:27.547131
11885	2026-03-24 12:30:00	4	23.06	220	4756.2	t	2026-05-08 00:01:27.547131
11886	2026-03-24 12:30:00	7	20.55	220	6010.5	t	2026-05-08 00:01:27.547131
11887	2026-03-24 13:00:00	1	13.81	220	2678.6	t	2026-05-08 00:01:27.547131
11888	2026-03-24 13:00:00	4	16.78	220	3838.7	t	2026-05-08 00:01:27.547131
11889	2026-03-24 13:00:00	7	21.18	220	4932.4	t	2026-05-08 00:01:27.547131
11890	2026-03-24 13:30:00	1	16.42	220	3310.7	t	2026-05-08 00:01:27.547131
11891	2026-03-24 13:30:00	4	19.55	220	5412.3	t	2026-05-08 00:01:27.547131
11892	2026-03-24 13:30:00	7	27.22	220	5472.7	t	2026-05-08 00:01:27.547131
11893	2026-03-24 14:00:00	1	12.95	220	4236.3	t	2026-05-08 00:01:27.547131
11894	2026-03-24 14:00:00	4	19.31	220	3546.4	t	2026-05-08 00:01:27.547131
11895	2026-03-24 14:00:00	7	23.69	220	4806	t	2026-05-08 00:01:27.547131
11896	2026-03-24 14:30:00	1	16.77	220	2868.5	t	2026-05-08 00:01:27.547131
11897	2026-03-24 14:30:00	4	25.29	220	5370.3	t	2026-05-08 00:01:27.547131
11898	2026-03-24 14:30:00	7	29.24	220	5725.9	t	2026-05-08 00:01:27.547131
11899	2026-03-24 15:00:00	1	19.11	220	3668.6	t	2026-05-08 00:01:27.547131
11900	2026-03-24 15:00:00	4	25.34	220	5487.5	t	2026-05-08 00:01:27.547131
11901	2026-03-24 15:00:00	7	21.37	220	5112	t	2026-05-08 00:01:27.547131
11902	2026-03-24 15:30:00	1	11.51	220	2821.6	t	2026-05-08 00:01:27.547131
11903	2026-03-24 15:30:00	4	19.65	220	4046.6	t	2026-05-08 00:01:27.547131
11904	2026-03-24 15:30:00	7	23.95	220	5087.2	t	2026-05-08 00:01:27.547131
11905	2026-03-24 16:00:00	1	20.13	220	3830.2	t	2026-05-08 00:01:27.547131
11906	2026-03-24 16:00:00	4	21.16	220	4805.4	t	2026-05-08 00:01:27.547131
11907	2026-03-24 16:00:00	7	26.83	220	6157.2	t	2026-05-08 00:01:27.547131
11908	2026-03-24 16:30:00	1	16.91	220	2820.4	t	2026-05-08 00:01:27.547131
11909	2026-03-24 16:30:00	4	18.29	220	4456.5	t	2026-05-08 00:01:27.547131
11910	2026-03-24 16:30:00	7	23.67	220	5872.8	t	2026-05-08 00:01:27.547131
11911	2026-03-24 17:00:00	1	18.7	220	3898.7	t	2026-05-08 00:01:27.547131
11912	2026-03-24 17:00:00	4	18.31	220	4647	t	2026-05-08 00:01:27.547131
11913	2026-03-24 17:00:00	7	24.69	220	6379	t	2026-05-08 00:01:27.547131
11914	2026-03-24 17:30:00	1	13.55	220	4244.3	t	2026-05-08 00:01:27.547131
11915	2026-03-24 17:30:00	4	16.04	220	4747.8	t	2026-05-08 00:01:27.547131
11916	2026-03-24 17:30:00	7	25.03	220	4621	t	2026-05-08 00:01:27.547131
11917	2026-03-24 18:00:00	1	13.34	220	3949.8	t	2026-05-08 00:01:27.547131
11918	2026-03-24 18:00:00	4	24.4	220	4480.5	t	2026-05-08 00:01:27.547131
11919	2026-03-24 18:00:00	7	30.14	220	5899.4	t	2026-05-08 00:01:27.547131
11920	2026-03-24 18:30:00	1	18.48	220	2607.9	t	2026-05-08 00:01:27.547131
11921	2026-03-24 18:30:00	4	25.02	220	5504.1	t	2026-05-08 00:01:27.547131
11922	2026-03-24 18:30:00	7	27.79	220	6313.7	t	2026-05-08 00:01:27.547131
11923	2026-03-24 19:00:00	1	12.5	220	2703.3	t	2026-05-08 00:01:27.547131
11924	2026-03-24 19:00:00	4	21.58	220	3882.5	t	2026-05-08 00:01:27.547131
11925	2026-03-24 19:00:00	7	21.93	220	5405.5	t	2026-05-08 00:01:27.547131
11926	2026-03-24 19:30:00	1	20.96	220	4652.1	t	2026-05-08 00:01:27.547131
11927	2026-03-24 19:30:00	4	20.96	220	5706.2	t	2026-05-08 00:01:27.547131
11928	2026-03-24 19:30:00	7	23.48	220	5477.4	t	2026-05-08 00:01:27.547131
11929	2026-03-24 20:00:00	1	2.44	220	689.3	t	2026-05-08 00:01:27.547131
11930	2026-03-24 20:00:00	4	1.51	220	649.6	t	2026-05-08 00:01:27.547131
11931	2026-03-24 20:00:00	7	1.78	220	416.3	t	2026-05-08 00:01:27.547131
11932	2026-03-24 20:30:00	1	1.53	220	413.1	t	2026-05-08 00:01:27.547131
11933	2026-03-24 20:30:00	4	2.14	220	667.3	t	2026-05-08 00:01:27.547131
11934	2026-03-24 20:30:00	7	2.47	220	605.5	t	2026-05-08 00:01:27.547131
11935	2026-03-24 21:00:00	1	2.47	220	384.1	t	2026-05-08 00:01:27.547131
11936	2026-03-24 21:00:00	4	1.53	220	742.4	t	2026-05-08 00:01:27.547131
11937	2026-03-24 21:00:00	7	3.32	220	370.7	t	2026-05-08 00:01:27.547131
11938	2026-03-24 21:30:00	1	2.97	220	407.6	t	2026-05-08 00:01:27.547131
11939	2026-03-24 21:30:00	4	3.25	220	500.6	t	2026-05-08 00:01:27.547131
11940	2026-03-24 21:30:00	7	1.26	220	383.8	t	2026-05-08 00:01:27.547131
11941	2026-03-24 22:00:00	1	1.46	220	494.7	t	2026-05-08 00:01:27.547131
11942	2026-03-24 22:00:00	4	3.15	220	613.3	t	2026-05-08 00:01:27.547131
11943	2026-03-24 22:00:00	7	1.24	220	496	t	2026-05-08 00:01:27.547131
11944	2026-03-24 22:30:00	1	1.63	220	565.9	t	2026-05-08 00:01:27.547131
11945	2026-03-24 22:30:00	4	1.32	220	535.9	t	2026-05-08 00:01:27.547131
11946	2026-03-24 22:30:00	7	3.52	220	625.5	t	2026-05-08 00:01:27.547131
11947	2026-03-24 23:00:00	1	1.23	220	697.3	t	2026-05-08 00:01:27.547131
11948	2026-03-24 23:00:00	4	2.94	220	677.5	t	2026-05-08 00:01:27.547131
11949	2026-03-24 23:00:00	7	3.38	220	270.8	t	2026-05-08 00:01:27.547131
11950	2026-03-24 23:30:00	1	2.04	220	600.7	t	2026-05-08 00:01:27.547131
11951	2026-03-24 23:30:00	4	2.97	220	693.8	t	2026-05-08 00:01:27.547131
11952	2026-03-24 23:30:00	7	3.46	220	565.2	t	2026-05-08 00:01:27.547131
11953	2026-03-25 00:00:00	1	1.22	220	540.4	t	2026-05-08 00:01:27.547131
11954	2026-03-25 00:00:00	4	3.15	220	372.2	t	2026-05-08 00:01:27.547131
11955	2026-03-25 00:00:00	7	3.17	220	470.5	t	2026-05-08 00:01:27.547131
11956	2026-03-25 00:30:00	1	3.16	220	654.3	t	2026-05-08 00:01:27.547131
11957	2026-03-25 00:30:00	4	3.02	220	404	t	2026-05-08 00:01:27.547131
11958	2026-03-25 00:30:00	7	1.67	220	496.5	t	2026-05-08 00:01:27.547131
11959	2026-03-25 01:00:00	1	1.26	220	592	t	2026-05-08 00:01:27.547131
11960	2026-03-25 01:00:00	4	1.67	220	363.9	t	2026-05-08 00:01:27.547131
11961	2026-03-25 01:00:00	7	1.23	220	697.2	t	2026-05-08 00:01:27.547131
11962	2026-03-25 01:30:00	1	3.55	220	322	t	2026-05-08 00:01:27.547131
11963	2026-03-25 01:30:00	4	2.79	220	364.8	t	2026-05-08 00:01:27.547131
11964	2026-03-25 01:30:00	7	2.76	220	508.1	t	2026-05-08 00:01:27.547131
11965	2026-03-25 02:00:00	1	2.64	220	278.9	t	2026-05-08 00:01:27.547131
11966	2026-03-25 02:00:00	4	1.85	220	496.7	t	2026-05-08 00:01:27.547131
11967	2026-03-25 02:00:00	7	1.46	220	606.5	t	2026-05-08 00:01:27.547131
11968	2026-03-25 02:30:00	1	1.46	220	636	t	2026-05-08 00:01:27.547131
11969	2026-03-25 02:30:00	4	1.45	220	429.9	t	2026-05-08 00:01:27.547131
11970	2026-03-25 02:30:00	7	1.77	220	650.2	t	2026-05-08 00:01:27.547131
11971	2026-03-25 03:00:00	1	2.97	220	768.4	t	2026-05-08 00:01:27.547131
11972	2026-03-25 03:00:00	4	2.86	220	634.1	t	2026-05-08 00:01:27.547131
11973	2026-03-25 03:00:00	7	2.72	220	389.6	t	2026-05-08 00:01:27.547131
11974	2026-03-25 03:30:00	1	3.16	220	497.6	t	2026-05-08 00:01:27.547131
11975	2026-03-25 03:30:00	4	2.51	220	532.7	t	2026-05-08 00:01:27.547131
11976	2026-03-25 03:30:00	7	2.44	220	478.7	t	2026-05-08 00:01:27.547131
11977	2026-03-25 04:00:00	1	1.87	220	287.9	t	2026-05-08 00:01:27.547131
11978	2026-03-25 04:00:00	4	3.6	220	751.3	t	2026-05-08 00:01:27.547131
11979	2026-03-25 04:00:00	7	1.92	220	492.1	t	2026-05-08 00:01:27.547131
11980	2026-03-25 04:30:00	1	1.25	220	472.4	t	2026-05-08 00:01:27.547131
11981	2026-03-25 04:30:00	4	2.18	220	358.4	t	2026-05-08 00:01:27.547131
11982	2026-03-25 04:30:00	7	2.58	220	554.6	t	2026-05-08 00:01:27.547131
11983	2026-03-25 05:00:00	1	2.42	220	604.5	t	2026-05-08 00:01:27.547131
11984	2026-03-25 05:00:00	4	1.61	220	532.6	t	2026-05-08 00:01:27.547131
11985	2026-03-25 05:00:00	7	1.63	220	801.8	t	2026-05-08 00:01:27.547131
11986	2026-03-25 05:30:00	1	1.81	220	792	t	2026-05-08 00:01:27.547131
11987	2026-03-25 05:30:00	4	1.63	220	728.6	t	2026-05-08 00:01:27.547131
11988	2026-03-25 05:30:00	7	3.35	220	322.8	t	2026-05-08 00:01:27.547131
11989	2026-03-25 06:00:00	1	2.69	220	371.6	t	2026-05-08 00:01:27.547131
11990	2026-03-25 06:00:00	4	1.41	220	533.2	t	2026-05-08 00:01:27.547131
11991	2026-03-25 06:00:00	7	1.82	220	491.1	t	2026-05-08 00:01:27.547131
11992	2026-03-25 06:30:00	1	2.53	220	270.3	t	2026-05-08 00:01:27.547131
11993	2026-03-25 06:30:00	4	2.49	220	475.2	t	2026-05-08 00:01:27.547131
11994	2026-03-25 06:30:00	7	2.01	220	271.4	t	2026-05-08 00:01:27.547131
11995	2026-03-25 07:00:00	1	12.8	220	4173.6	t	2026-05-08 00:01:27.547131
11996	2026-03-25 07:00:00	4	18.24	220	5075.4	t	2026-05-08 00:01:27.547131
11997	2026-03-25 07:00:00	7	21.02	220	5253.9	t	2026-05-08 00:01:27.547131
11998	2026-03-25 07:30:00	1	18.04	220	3696.1	t	2026-05-08 00:01:27.547131
11999	2026-03-25 07:30:00	4	23.82	220	4145.8	t	2026-05-08 00:01:27.547131
12000	2026-03-25 07:30:00	7	28.08	220	4515.2	t	2026-05-08 00:01:27.547131
12001	2026-03-25 08:00:00	1	15.79	220	3423.3	t	2026-05-08 00:01:27.547131
12002	2026-03-25 08:00:00	4	21.32	220	4886.2	t	2026-05-08 00:01:27.547131
12003	2026-03-25 08:00:00	7	25.95	220	5755.9	t	2026-05-08 00:01:27.547131
12004	2026-03-25 08:30:00	1	18.66	220	4714.8	t	2026-05-08 00:01:27.547131
12005	2026-03-25 08:30:00	4	20.91	220	4243.7	t	2026-05-08 00:01:27.547131
12006	2026-03-25 08:30:00	7	29.69	220	5171.2	t	2026-05-08 00:01:27.547131
12007	2026-03-25 09:00:00	1	21.15	220	4582.5	t	2026-05-08 00:01:27.547131
12008	2026-03-25 09:00:00	4	22.78	220	4300.7	t	2026-05-08 00:01:27.547131
12009	2026-03-25 09:00:00	7	27.8	220	4848.7	t	2026-05-08 00:01:27.547131
12010	2026-03-25 09:30:00	1	20.13	220	4148.7	t	2026-05-08 00:01:27.547131
12011	2026-03-25 09:30:00	4	17.43	220	3552.4	t	2026-05-08 00:01:27.547131
12012	2026-03-25 09:30:00	7	26.21	220	5866.7	t	2026-05-08 00:01:27.547131
12013	2026-03-25 10:00:00	1	18.91	220	3825.2	t	2026-05-08 00:01:27.547131
12014	2026-03-25 10:00:00	4	25.77	220	5309.9	t	2026-05-08 00:01:27.547131
12015	2026-03-25 10:00:00	7	28.74	220	4641.7	t	2026-05-08 00:01:27.547131
12016	2026-03-25 10:30:00	1	16.94	220	4005.5	t	2026-05-08 00:01:27.547131
12017	2026-03-25 10:30:00	4	22.76	220	5629.2	t	2026-05-08 00:01:27.547131
12018	2026-03-25 10:30:00	7	27.87	220	5999.1	t	2026-05-08 00:01:27.547131
12019	2026-03-25 11:00:00	1	12.64	220	4360.6	t	2026-05-08 00:01:27.547131
12020	2026-03-25 11:00:00	4	23.34	220	3624.2	t	2026-05-08 00:01:27.547131
12021	2026-03-25 11:00:00	7	30.21	220	4544	t	2026-05-08 00:01:27.547131
12022	2026-03-25 11:30:00	1	21.11	220	4662.4	t	2026-05-08 00:01:27.547131
12023	2026-03-25 11:30:00	4	20.35	220	5519.3	t	2026-05-08 00:01:27.547131
12024	2026-03-25 11:30:00	7	23.86	220	6255.9	t	2026-05-08 00:01:27.547131
12025	2026-03-25 12:00:00	1	17.24	220	4050.5	t	2026-05-08 00:01:27.547131
12026	2026-03-25 12:00:00	4	16.24	220	4121.1	t	2026-05-08 00:01:27.547131
12027	2026-03-25 12:00:00	7	24.47	220	5489	t	2026-05-08 00:01:27.547131
12028	2026-03-25 12:30:00	1	12.12	220	4137.8	t	2026-05-08 00:01:27.547131
12029	2026-03-25 12:30:00	4	21.11	220	4753.5	t	2026-05-08 00:01:27.547131
12030	2026-03-25 12:30:00	7	26.94	220	6045.5	t	2026-05-08 00:01:27.547131
12031	2026-03-25 13:00:00	1	16.83	220	4541.7	t	2026-05-08 00:01:27.547131
12032	2026-03-25 13:00:00	4	20.24	220	3526	t	2026-05-08 00:01:27.547131
12033	2026-03-25 13:00:00	7	21.49	220	5793.1	t	2026-05-08 00:01:27.547131
12034	2026-03-25 13:30:00	1	19.2	220	3140.9	t	2026-05-08 00:01:27.547131
12035	2026-03-25 13:30:00	4	22.4	220	5050.6	t	2026-05-08 00:01:27.547131
12036	2026-03-25 13:30:00	7	26.07	220	5484.8	t	2026-05-08 00:01:27.547131
12037	2026-03-25 14:00:00	1	13.45	220	3283.3	t	2026-05-08 00:01:27.547131
12038	2026-03-25 14:00:00	4	25.03	220	4565.4	t	2026-05-08 00:01:27.547131
12039	2026-03-25 14:00:00	7	22.02	220	6408.1	t	2026-05-08 00:01:27.547131
12040	2026-03-25 14:30:00	1	11.6	220	3657.9	t	2026-05-08 00:01:27.547131
12041	2026-03-25 14:30:00	4	20.88	220	3641.9	t	2026-05-08 00:01:27.547131
12042	2026-03-25 14:30:00	7	20.54	220	6273.2	t	2026-05-08 00:01:27.547131
12043	2026-03-25 15:00:00	1	21.27	220	3782.5	t	2026-05-08 00:01:27.547131
12044	2026-03-25 15:00:00	4	23.74	220	4780.5	t	2026-05-08 00:01:27.547131
12045	2026-03-25 15:00:00	7	25.69	220	5201.4	t	2026-05-08 00:01:27.547131
12046	2026-03-25 15:30:00	1	16.31	220	3930.4	t	2026-05-08 00:01:27.547131
12047	2026-03-25 15:30:00	4	24.23	220	5624.3	t	2026-05-08 00:01:27.547131
12048	2026-03-25 15:30:00	7	25.54	220	4736	t	2026-05-08 00:01:27.547131
12049	2026-03-25 16:00:00	1	17.62	220	4291.9	t	2026-05-08 00:01:27.547131
12050	2026-03-25 16:00:00	4	22.91	220	5609.2	t	2026-05-08 00:01:27.547131
12051	2026-03-25 16:00:00	7	21.49	220	6307.5	t	2026-05-08 00:01:27.547131
12052	2026-03-25 16:30:00	1	17.33	220	2731.1	t	2026-05-08 00:01:27.547131
12053	2026-03-25 16:30:00	4	24.72	220	5690.1	t	2026-05-08 00:01:27.547131
12054	2026-03-25 16:30:00	7	29.39	220	5569.3	t	2026-05-08 00:01:27.547131
12055	2026-03-25 17:00:00	1	14.84	220	4548.9	t	2026-05-08 00:01:27.547131
12056	2026-03-25 17:00:00	4	24.1	220	5717.1	t	2026-05-08 00:01:27.547131
12057	2026-03-25 17:00:00	7	30.13	220	6331.3	t	2026-05-08 00:01:27.547131
12058	2026-03-25 17:30:00	1	12.44	220	4475.8	t	2026-05-08 00:01:27.547131
12059	2026-03-25 17:30:00	4	21.49	220	4262.2	t	2026-05-08 00:01:27.547131
12060	2026-03-25 17:30:00	7	23.67	220	5046.1	t	2026-05-08 00:01:27.547131
12061	2026-03-25 18:00:00	1	20.87	220	2919.7	t	2026-05-08 00:01:27.547131
12062	2026-03-25 18:00:00	4	17.53	220	3564.2	t	2026-05-08 00:01:27.547131
12063	2026-03-25 18:00:00	7	26	220	6360.9	t	2026-05-08 00:01:27.547131
12064	2026-03-25 18:30:00	1	14.76	220	3035.6	t	2026-05-08 00:01:27.547131
12065	2026-03-25 18:30:00	4	24.82	220	4645.1	t	2026-05-08 00:01:27.547131
12066	2026-03-25 18:30:00	7	28.22	220	4765.2	t	2026-05-08 00:01:27.547131
12067	2026-03-25 19:00:00	1	14.09	220	3565.3	t	2026-05-08 00:01:27.547131
12068	2026-03-25 19:00:00	4	16.74	220	5075.6	t	2026-05-08 00:01:27.547131
12069	2026-03-25 19:00:00	7	21.49	220	5359.1	t	2026-05-08 00:01:27.547131
12070	2026-03-25 19:30:00	1	19.08	220	3074	t	2026-05-08 00:01:27.547131
12071	2026-03-25 19:30:00	4	17.75	220	5438	t	2026-05-08 00:01:27.547131
12072	2026-03-25 19:30:00	7	21.81	220	4803.6	t	2026-05-08 00:01:27.547131
12073	2026-03-25 20:00:00	1	2.23	220	759.2	t	2026-05-08 00:01:27.547131
12074	2026-03-25 20:00:00	4	1.9	220	443.8	t	2026-05-08 00:01:27.547131
12075	2026-03-25 20:00:00	7	1.61	220	587.2	t	2026-05-08 00:01:27.547131
12076	2026-03-25 20:30:00	1	1.24	220	300.5	t	2026-05-08 00:01:27.547131
12077	2026-03-25 20:30:00	4	2.07	220	653.8	t	2026-05-08 00:01:27.547131
12078	2026-03-25 20:30:00	7	1.99	220	711.2	t	2026-05-08 00:01:27.547131
12079	2026-03-25 21:00:00	1	2.23	220	477	t	2026-05-08 00:01:27.547131
12080	2026-03-25 21:00:00	4	2.87	220	656.5	t	2026-05-08 00:01:27.547131
12081	2026-03-25 21:00:00	7	1.95	220	634.3	t	2026-05-08 00:01:27.547131
12082	2026-03-25 21:30:00	1	1.64	220	365.5	t	2026-05-08 00:01:27.547131
12083	2026-03-25 21:30:00	4	1.3	220	743.1	t	2026-05-08 00:01:27.547131
12084	2026-03-25 21:30:00	7	3.48	220	406.8	t	2026-05-08 00:01:27.547131
12085	2026-03-25 22:00:00	1	1.54	220	639.1	t	2026-05-08 00:01:27.547131
12086	2026-03-25 22:00:00	4	2.07	220	310	t	2026-05-08 00:01:27.547131
12087	2026-03-25 22:00:00	7	3.28	220	692.9	t	2026-05-08 00:01:27.547131
12088	2026-03-25 22:30:00	1	1.49	220	358.6	t	2026-05-08 00:01:27.547131
12089	2026-03-25 22:30:00	4	3.34	220	581.8	t	2026-05-08 00:01:27.547131
12090	2026-03-25 22:30:00	7	2.74	220	504.3	t	2026-05-08 00:01:27.547131
12091	2026-03-25 23:00:00	1	1.9	220	418.6	t	2026-05-08 00:01:27.547131
12092	2026-03-25 23:00:00	4	1.36	220	412.4	t	2026-05-08 00:01:27.547131
12093	2026-03-25 23:00:00	7	1.54	220	570.2	t	2026-05-08 00:01:27.547131
12094	2026-03-25 23:30:00	1	2.45	220	354.9	t	2026-05-08 00:01:27.547131
12095	2026-03-25 23:30:00	4	1.41	220	551.9	t	2026-05-08 00:01:27.547131
12096	2026-03-25 23:30:00	7	3.65	220	533.3	t	2026-05-08 00:01:27.547131
12097	2026-03-26 00:00:00	1	1.52	220	353.8	t	2026-05-08 00:01:27.547131
12098	2026-03-26 00:00:00	4	2.31	220	499.2	t	2026-05-08 00:01:27.547131
12099	2026-03-26 00:00:00	7	2.36	220	445.6	t	2026-05-08 00:01:27.547131
12100	2026-03-26 00:30:00	1	3.53	220	364	t	2026-05-08 00:01:27.547131
12101	2026-03-26 00:30:00	4	2.73	220	292.5	t	2026-05-08 00:01:27.547131
12102	2026-03-26 00:30:00	7	2.58	220	758.5	t	2026-05-08 00:01:27.547131
12103	2026-03-26 01:00:00	1	2.63	220	690.1	t	2026-05-08 00:01:27.547131
12104	2026-03-26 01:00:00	4	3.58	220	266.1	t	2026-05-08 00:01:27.547131
12105	2026-03-26 01:00:00	7	2.78	220	736	t	2026-05-08 00:01:27.547131
12106	2026-03-26 01:30:00	1	2.13	220	490.8	t	2026-05-08 00:01:27.547131
12107	2026-03-26 01:30:00	4	3.36	220	366.3	t	2026-05-08 00:01:27.547131
12108	2026-03-26 01:30:00	7	2.01	220	686.2	t	2026-05-08 00:01:27.547131
12109	2026-03-26 02:00:00	1	3.31	220	546.5	t	2026-05-08 00:01:27.547131
12110	2026-03-26 02:00:00	4	1.92	220	467.7	t	2026-05-08 00:01:27.547131
12111	2026-03-26 02:00:00	7	3.02	220	766.3	t	2026-05-08 00:01:27.547131
12112	2026-03-26 02:30:00	1	1.6	220	672.6	t	2026-05-08 00:01:27.547131
12113	2026-03-26 02:30:00	4	2.48	220	763.7	t	2026-05-08 00:01:27.547131
12114	2026-03-26 02:30:00	7	1.39	220	728	t	2026-05-08 00:01:27.547131
12115	2026-03-26 03:00:00	1	2.47	220	468.1	t	2026-05-08 00:01:27.547131
12116	2026-03-26 03:00:00	4	3.64	220	808.6	t	2026-05-08 00:01:27.547131
12117	2026-03-26 03:00:00	7	1.32	220	437.7	t	2026-05-08 00:01:27.547131
12118	2026-03-26 03:30:00	1	3.56	220	302.4	t	2026-05-08 00:01:27.547131
12119	2026-03-26 03:30:00	4	2.42	220	697.3	t	2026-05-08 00:01:27.547131
12120	2026-03-26 03:30:00	7	1.54	220	500.8	t	2026-05-08 00:01:27.547131
12121	2026-03-26 04:00:00	1	1.4	220	702.1	t	2026-05-08 00:01:27.547131
12122	2026-03-26 04:00:00	4	2.12	220	384.3	t	2026-05-08 00:01:27.547131
12123	2026-03-26 04:00:00	7	3.58	220	597.5	t	2026-05-08 00:01:27.547131
12124	2026-03-26 04:30:00	1	1.59	220	407.5	t	2026-05-08 00:01:27.547131
12125	2026-03-26 04:30:00	4	3.21	220	534.3	t	2026-05-08 00:01:27.547131
12126	2026-03-26 04:30:00	7	1.39	220	647.3	t	2026-05-08 00:01:27.547131
12127	2026-03-26 05:00:00	1	2.04	220	381.1	t	2026-05-08 00:01:27.547131
12128	2026-03-26 05:00:00	4	1.59	220	510.2	t	2026-05-08 00:01:27.547131
12129	2026-03-26 05:00:00	7	2.25	220	301	t	2026-05-08 00:01:27.547131
12130	2026-03-26 05:30:00	1	1.35	220	769.7	t	2026-05-08 00:01:27.547131
12131	2026-03-26 05:30:00	4	3.04	220	648.2	t	2026-05-08 00:01:27.547131
12132	2026-03-26 05:30:00	7	2.48	220	798.2	t	2026-05-08 00:01:27.547131
12133	2026-03-26 06:00:00	1	1.77	220	411.1	t	2026-05-08 00:01:27.547131
12134	2026-03-26 06:00:00	4	1.43	220	513.4	t	2026-05-08 00:01:27.547131
12135	2026-03-26 06:00:00	7	1.67	220	351.6	t	2026-05-08 00:01:27.547131
12136	2026-03-26 06:30:00	1	3.37	220	622	t	2026-05-08 00:01:27.547131
12137	2026-03-26 06:30:00	4	2.54	220	585.2	t	2026-05-08 00:01:27.547131
12138	2026-03-26 06:30:00	7	2.58	220	627.9	t	2026-05-08 00:01:27.547131
12139	2026-03-26 07:00:00	1	21.33	220	4644.5	t	2026-05-08 00:01:27.547131
12140	2026-03-26 07:00:00	4	19.03	220	5481.7	t	2026-05-08 00:01:27.547131
12141	2026-03-26 07:00:00	7	26.32	220	6318.7	t	2026-05-08 00:01:27.547131
12142	2026-03-26 07:30:00	1	15.97	220	3340.3	t	2026-05-08 00:01:27.547131
12143	2026-03-26 07:30:00	4	17.28	220	3858.6	t	2026-05-08 00:01:27.547131
12144	2026-03-26 07:30:00	7	26.01	220	5893.7	t	2026-05-08 00:01:27.547131
12145	2026-03-26 08:00:00	1	14.71	220	4054.2	t	2026-05-08 00:01:27.547131
12146	2026-03-26 08:00:00	4	24.15	220	5353.8	t	2026-05-08 00:01:27.547131
12147	2026-03-26 08:00:00	7	29.99	220	5148.1	t	2026-05-08 00:01:27.547131
12148	2026-03-26 08:30:00	1	13.68	220	2739.7	t	2026-05-08 00:01:27.547131
12149	2026-03-26 08:30:00	4	24.32	220	5590.6	t	2026-05-08 00:01:27.547131
12150	2026-03-26 08:30:00	7	23.85	220	4797.3	t	2026-05-08 00:01:27.547131
12151	2026-03-26 09:00:00	1	19.83	220	3714.8	t	2026-05-08 00:01:27.547131
12152	2026-03-26 09:00:00	4	17.53	220	4457	t	2026-05-08 00:01:27.547131
12153	2026-03-26 09:00:00	7	27.47	220	5878.9	t	2026-05-08 00:01:27.547131
12154	2026-03-26 09:30:00	1	15.12	220	3442.7	t	2026-05-08 00:01:27.547131
12155	2026-03-26 09:30:00	4	17.66	220	4215.1	t	2026-05-08 00:01:27.547131
12156	2026-03-26 09:30:00	7	22.35	220	5141.4	t	2026-05-08 00:01:27.547131
12157	2026-03-26 10:00:00	1	11.78	220	3956.5	t	2026-05-08 00:01:27.547131
12158	2026-03-26 10:00:00	4	25.99	220	4266.3	t	2026-05-08 00:01:27.547131
12159	2026-03-26 10:00:00	7	21.54	220	6136	t	2026-05-08 00:01:27.547131
12160	2026-03-26 10:30:00	1	13.45	220	3055.7	t	2026-05-08 00:01:27.547131
12161	2026-03-26 10:30:00	4	16.78	220	4486.1	t	2026-05-08 00:01:27.547131
12162	2026-03-26 10:30:00	7	25.32	220	5430.6	t	2026-05-08 00:01:27.547131
12163	2026-03-26 11:00:00	1	13.74	220	4021.2	t	2026-05-08 00:01:27.547131
12164	2026-03-26 11:00:00	4	18.25	220	3562.3	t	2026-05-08 00:01:27.547131
12165	2026-03-26 11:00:00	7	22.7	220	6679.1	t	2026-05-08 00:01:27.547131
12166	2026-03-26 11:30:00	1	21.48	220	3902.9	t	2026-05-08 00:01:27.547131
12167	2026-03-26 11:30:00	4	16.37	220	4693.4	t	2026-05-08 00:01:27.547131
12168	2026-03-26 11:30:00	7	25.48	220	5489.1	t	2026-05-08 00:01:27.547131
12169	2026-03-26 12:00:00	1	16.61	220	2700.3	t	2026-05-08 00:01:27.547131
12170	2026-03-26 12:00:00	4	17.24	220	4092.2	t	2026-05-08 00:01:27.547131
12171	2026-03-26 12:00:00	7	23.93	220	6588.7	t	2026-05-08 00:01:27.547131
12172	2026-03-26 12:30:00	1	19.34	220	4629.9	t	2026-05-08 00:01:27.547131
12173	2026-03-26 12:30:00	4	22.11	220	5233.9	t	2026-05-08 00:01:27.547131
12174	2026-03-26 12:30:00	7	27.3	220	5763.9	t	2026-05-08 00:01:27.547131
12175	2026-03-26 13:00:00	1	12.13	220	4480.7	t	2026-05-08 00:01:27.547131
12176	2026-03-26 13:00:00	4	18.11	220	4881.9	t	2026-05-08 00:01:27.547131
12177	2026-03-26 13:00:00	7	24.57	220	5264.9	t	2026-05-08 00:01:27.547131
12178	2026-03-26 13:30:00	1	11.65	220	3092.8	t	2026-05-08 00:01:27.547131
12179	2026-03-26 13:30:00	4	23.88	220	4741.2	t	2026-05-08 00:01:27.547131
12180	2026-03-26 13:30:00	7	21.33	220	5222	t	2026-05-08 00:01:27.547131
12181	2026-03-26 14:00:00	1	15.11	220	3804.3	t	2026-05-08 00:01:27.547131
12182	2026-03-26 14:00:00	4	20.69	220	4100.1	t	2026-05-08 00:01:27.547131
12183	2026-03-26 14:00:00	7	23.51	220	6130.2	t	2026-05-08 00:01:27.547131
12184	2026-03-26 14:30:00	1	20.28	220	2788.4	t	2026-05-08 00:01:27.547131
12185	2026-03-26 14:30:00	4	22.01	220	4273.5	t	2026-05-08 00:01:27.547131
12186	2026-03-26 14:30:00	7	28.38	220	4863.2	t	2026-05-08 00:01:27.547131
12187	2026-03-26 15:00:00	1	14.36	220	4394.3	t	2026-05-08 00:01:27.547131
12188	2026-03-26 15:00:00	4	18.2	220	4194.5	t	2026-05-08 00:01:27.547131
12189	2026-03-26 15:00:00	7	24.76	220	4926.9	t	2026-05-08 00:01:27.547131
12190	2026-03-26 15:30:00	1	12.8	220	2634.9	t	2026-05-08 00:01:27.547131
12191	2026-03-26 15:30:00	4	16.19	220	3589.1	t	2026-05-08 00:01:27.547131
12192	2026-03-26 15:30:00	7	29.59	220	5774.1	t	2026-05-08 00:01:27.547131
12193	2026-03-26 16:00:00	1	19.15	220	3209.8	t	2026-05-08 00:01:27.547131
12194	2026-03-26 16:00:00	4	24.56	220	5462.9	t	2026-05-08 00:01:27.547131
12195	2026-03-26 16:00:00	7	24.59	220	5168.7	t	2026-05-08 00:01:27.547131
12196	2026-03-26 16:30:00	1	14.63	220	4490.4	t	2026-05-08 00:01:27.547131
12197	2026-03-26 16:30:00	4	17.87	220	5115.6	t	2026-05-08 00:01:27.547131
12198	2026-03-26 16:30:00	7	24.85	220	5419.1	t	2026-05-08 00:01:27.547131
12199	2026-03-26 17:00:00	1	17.66	220	3208.1	t	2026-05-08 00:01:27.547131
12200	2026-03-26 17:00:00	4	16.39	220	3903.7	t	2026-05-08 00:01:27.547131
12201	2026-03-26 17:00:00	7	22.97	220	6142.3	t	2026-05-08 00:01:27.547131
12202	2026-03-26 17:30:00	1	13.77	220	3128.5	t	2026-05-08 00:01:27.547131
12203	2026-03-26 17:30:00	4	17.85	220	4027.5	t	2026-05-08 00:01:27.547131
12204	2026-03-26 17:30:00	7	30.09	220	4918.9	t	2026-05-08 00:01:27.547131
12205	2026-03-26 18:00:00	1	15.84	220	3800.7	t	2026-05-08 00:01:27.547131
12206	2026-03-26 18:00:00	4	24.46	220	5308.4	t	2026-05-08 00:01:27.547131
12207	2026-03-26 18:00:00	7	27.87	220	6475.1	t	2026-05-08 00:01:27.547131
12208	2026-03-26 18:30:00	1	17.14	220	3630.5	t	2026-05-08 00:01:27.547131
12209	2026-03-26 18:30:00	4	25.76	220	5138.5	t	2026-05-08 00:01:27.547131
12210	2026-03-26 18:30:00	7	24.33	220	4665.4	t	2026-05-08 00:01:27.547131
12211	2026-03-26 19:00:00	1	12.15	220	3950.4	t	2026-05-08 00:01:27.547131
12212	2026-03-26 19:00:00	4	21.92	220	5352.3	t	2026-05-08 00:01:27.547131
12213	2026-03-26 19:00:00	7	26.86	220	5360.5	t	2026-05-08 00:01:27.547131
12214	2026-03-26 19:30:00	1	12.04	220	4422.2	t	2026-05-08 00:01:27.547131
12215	2026-03-26 19:30:00	4	22.49	220	4466.1	t	2026-05-08 00:01:27.547131
12216	2026-03-26 19:30:00	7	28.6	220	6311	t	2026-05-08 00:01:27.547131
12217	2026-03-26 20:00:00	1	1.92	220	363.7	t	2026-05-08 00:01:27.547131
12218	2026-03-26 20:00:00	4	1.64	220	317.7	t	2026-05-08 00:01:27.547131
12219	2026-03-26 20:00:00	7	2.91	220	748.6	t	2026-05-08 00:01:27.547131
12220	2026-03-26 20:30:00	1	1.62	220	533.9	t	2026-05-08 00:01:27.547131
12221	2026-03-26 20:30:00	4	3.14	220	666.1	t	2026-05-08 00:01:27.547131
12222	2026-03-26 20:30:00	7	1.65	220	685.2	t	2026-05-08 00:01:27.547131
12223	2026-03-26 21:00:00	1	1.37	220	646.6	t	2026-05-08 00:01:27.547131
12224	2026-03-26 21:00:00	4	3.12	220	563	t	2026-05-08 00:01:27.547131
12225	2026-03-26 21:00:00	7	3.01	220	521.6	t	2026-05-08 00:01:27.547131
12226	2026-03-26 21:30:00	1	2.6	220	500.9	t	2026-05-08 00:01:27.547131
12227	2026-03-26 21:30:00	4	3.09	220	475.5	t	2026-05-08 00:01:27.547131
12228	2026-03-26 21:30:00	7	2.01	220	527.9	t	2026-05-08 00:01:27.547131
12229	2026-03-26 22:00:00	1	3.35	220	586.6	t	2026-05-08 00:01:27.547131
12230	2026-03-26 22:00:00	4	2.27	220	685.6	t	2026-05-08 00:01:27.547131
12231	2026-03-26 22:00:00	7	3.06	220	374.3	t	2026-05-08 00:01:27.547131
12232	2026-03-26 22:30:00	1	1.93	220	631.2	t	2026-05-08 00:01:27.547131
12233	2026-03-26 22:30:00	4	2.81	220	400.2	t	2026-05-08 00:01:27.547131
12234	2026-03-26 22:30:00	7	1.71	220	375.2	t	2026-05-08 00:01:27.547131
12235	2026-03-26 23:00:00	1	1.85	220	588.9	t	2026-05-08 00:01:27.547131
12236	2026-03-26 23:00:00	4	1.78	220	536.7	t	2026-05-08 00:01:27.547131
12237	2026-03-26 23:00:00	7	3.46	220	548.9	t	2026-05-08 00:01:27.547131
12238	2026-03-26 23:30:00	1	2.15	220	329.8	t	2026-05-08 00:01:27.547131
12239	2026-03-26 23:30:00	4	1.62	220	453.9	t	2026-05-08 00:01:27.547131
12240	2026-03-26 23:30:00	7	1.64	220	795.2	t	2026-05-08 00:01:27.547131
12241	2026-03-27 00:00:00	1	2.87	220	365.6	t	2026-05-08 00:01:27.547131
12242	2026-03-27 00:00:00	4	3.56	220	283.4	t	2026-05-08 00:01:27.547131
12243	2026-03-27 00:00:00	7	3.68	220	720	t	2026-05-08 00:01:27.547131
12244	2026-03-27 00:30:00	1	2.88	220	571.5	t	2026-05-08 00:01:27.547131
12245	2026-03-27 00:30:00	4	3.43	220	370.3	t	2026-05-08 00:01:27.547131
12246	2026-03-27 00:30:00	7	2.8	220	643.2	t	2026-05-08 00:01:27.547131
12247	2026-03-27 01:00:00	1	1.8	220	409.7	t	2026-05-08 00:01:27.547131
12248	2026-03-27 01:00:00	4	2.53	220	438.6	t	2026-05-08 00:01:27.547131
12249	2026-03-27 01:00:00	7	1.81	220	276.9	t	2026-05-08 00:01:27.547131
12250	2026-03-27 01:30:00	1	2.36	220	572.8	t	2026-05-08 00:01:27.547131
12251	2026-03-27 01:30:00	4	1.59	220	564.8	t	2026-05-08 00:01:27.547131
12252	2026-03-27 01:30:00	7	1.25	220	364.4	t	2026-05-08 00:01:27.547131
12253	2026-03-27 02:00:00	1	3.54	220	438	t	2026-05-08 00:01:27.547131
12254	2026-03-27 02:00:00	4	3.45	220	577.1	t	2026-05-08 00:01:27.547131
12255	2026-03-27 02:00:00	7	2.45	220	637.5	t	2026-05-08 00:01:27.547131
12256	2026-03-27 02:30:00	1	1.92	220	321	t	2026-05-08 00:01:27.547131
12257	2026-03-27 02:30:00	4	1.24	220	610.3	t	2026-05-08 00:01:27.547131
12258	2026-03-27 02:30:00	7	3.41	220	567.8	t	2026-05-08 00:01:27.547131
12259	2026-03-27 03:00:00	1	3.48	220	442.1	t	2026-05-08 00:01:27.547131
12260	2026-03-27 03:00:00	4	1.85	220	275.7	t	2026-05-08 00:01:27.547131
12261	2026-03-27 03:00:00	7	2.4	220	457.7	t	2026-05-08 00:01:27.547131
12262	2026-03-27 03:30:00	1	1.45	220	794.2	t	2026-05-08 00:01:27.547131
12263	2026-03-27 03:30:00	4	3.48	220	722	t	2026-05-08 00:01:27.547131
12264	2026-03-27 03:30:00	7	3.23	220	294	t	2026-05-08 00:01:27.547131
12265	2026-03-27 04:00:00	1	3.65	220	472	t	2026-05-08 00:01:27.547131
12266	2026-03-27 04:00:00	4	1.6	220	340.6	t	2026-05-08 00:01:27.547131
12267	2026-03-27 04:00:00	7	2.09	220	528	t	2026-05-08 00:01:27.547131
12268	2026-03-27 04:30:00	1	1.7	220	795.5	t	2026-05-08 00:01:27.547131
12269	2026-03-27 04:30:00	4	1.85	220	594	t	2026-05-08 00:01:27.547131
12270	2026-03-27 04:30:00	7	2.99	220	655.3	t	2026-05-08 00:01:27.547131
12271	2026-03-27 05:00:00	1	1.47	220	540.2	t	2026-05-08 00:01:27.547131
12272	2026-03-27 05:00:00	4	1.74	220	304.6	t	2026-05-08 00:01:27.547131
12273	2026-03-27 05:00:00	7	2.07	220	746.7	t	2026-05-08 00:01:27.547131
12274	2026-03-27 05:30:00	1	2.84	220	620	t	2026-05-08 00:01:27.547131
12275	2026-03-27 05:30:00	4	2.64	220	448.6	t	2026-05-08 00:01:27.547131
12276	2026-03-27 05:30:00	7	2.05	220	495.9	t	2026-05-08 00:01:27.547131
12277	2026-03-27 06:00:00	1	2.42	220	370.7	t	2026-05-08 00:01:27.547131
12278	2026-03-27 06:00:00	4	2.27	220	386.8	t	2026-05-08 00:01:27.547131
12279	2026-03-27 06:00:00	7	2.49	220	298.9	t	2026-05-08 00:01:27.547131
12280	2026-03-27 06:30:00	1	2.54	220	344.9	t	2026-05-08 00:01:27.547131
12281	2026-03-27 06:30:00	4	1.7	220	363.1	t	2026-05-08 00:01:27.547131
12282	2026-03-27 06:30:00	7	1.84	220	532.4	t	2026-05-08 00:01:27.547131
12283	2026-03-27 07:00:00	1	20.17	220	2986.3	t	2026-05-08 00:01:27.547131
12284	2026-03-27 07:00:00	4	18.26	220	5068	t	2026-05-08 00:01:27.547131
12285	2026-03-27 07:00:00	7	24.98	220	5436.7	t	2026-05-08 00:01:27.547131
12286	2026-03-27 07:30:00	1	18.3	220	4613.4	t	2026-05-08 00:01:27.547131
12287	2026-03-27 07:30:00	4	23.86	220	4733.7	t	2026-05-08 00:01:27.547131
12288	2026-03-27 07:30:00	7	30.49	220	6338.9	t	2026-05-08 00:01:27.547131
12289	2026-03-27 08:00:00	1	18.62	220	3730	t	2026-05-08 00:01:27.547131
12290	2026-03-27 08:00:00	4	21.68	220	4680	t	2026-05-08 00:01:27.547131
12291	2026-03-27 08:00:00	7	30.1	220	6209.6	t	2026-05-08 00:01:27.547131
12292	2026-03-27 08:30:00	1	13.32	220	3000.8	t	2026-05-08 00:01:27.547131
12293	2026-03-27 08:30:00	4	24.79	220	4043.4	t	2026-05-08 00:01:27.547131
12294	2026-03-27 08:30:00	7	24.47	220	6277.4	t	2026-05-08 00:01:27.547131
12295	2026-03-27 09:00:00	1	17.34	220	3279.5	t	2026-05-08 00:01:27.547131
12296	2026-03-27 09:00:00	4	23.87	220	4728.1	t	2026-05-08 00:01:27.547131
12297	2026-03-27 09:00:00	7	24.5	220	5354.9	t	2026-05-08 00:01:27.547131
12298	2026-03-27 09:30:00	1	12.75	220	4070.8	t	2026-05-08 00:01:27.547131
12299	2026-03-27 09:30:00	4	24.5	220	5286.8	t	2026-05-08 00:01:27.547131
12300	2026-03-27 09:30:00	7	22.7	220	5641	t	2026-05-08 00:01:27.547131
12301	2026-03-27 10:00:00	1	17.96	220	3013.2	t	2026-05-08 00:01:27.547131
12302	2026-03-27 10:00:00	4	25.8	220	4197.2	t	2026-05-08 00:01:27.547131
12303	2026-03-27 10:00:00	7	29.51	220	4625.2	t	2026-05-08 00:01:27.547131
12304	2026-03-27 10:30:00	1	15.81	220	4199.5	t	2026-05-08 00:01:27.547131
12305	2026-03-27 10:30:00	4	25.69	220	4485.5	t	2026-05-08 00:01:27.547131
12306	2026-03-27 10:30:00	7	29.4	220	6486.5	t	2026-05-08 00:01:27.547131
12307	2026-03-27 11:00:00	1	14.74	220	4077.6	t	2026-05-08 00:01:27.547131
12308	2026-03-27 11:00:00	4	23.65	220	4349.7	t	2026-05-08 00:01:27.547131
12309	2026-03-27 11:00:00	7	29.69	220	4588.1	t	2026-05-08 00:01:27.547131
12310	2026-03-27 11:30:00	1	19.35	220	3887.7	t	2026-05-08 00:01:27.547131
12311	2026-03-27 11:30:00	4	20.65	220	5084.1	t	2026-05-08 00:01:27.547131
12312	2026-03-27 11:30:00	7	29.15	220	6204.8	t	2026-05-08 00:01:27.547131
12313	2026-03-27 12:00:00	1	11.58	220	3074.4	t	2026-05-08 00:01:27.547131
12314	2026-03-27 12:00:00	4	19.68	220	3618.6	t	2026-05-08 00:01:27.547131
12315	2026-03-27 12:00:00	7	22.35	220	4519.6	t	2026-05-08 00:01:27.547131
12316	2026-03-27 12:30:00	1	12.22	220	3737.9	t	2026-05-08 00:01:27.547131
12317	2026-03-27 12:30:00	4	16.21	220	4921.1	t	2026-05-08 00:01:27.547131
12318	2026-03-27 12:30:00	7	23.1	220	6026	t	2026-05-08 00:01:27.547131
12319	2026-03-27 13:00:00	1	14.32	220	2975.4	t	2026-05-08 00:01:27.547131
12320	2026-03-27 13:00:00	4	19.69	220	5332.1	t	2026-05-08 00:01:27.547131
12321	2026-03-27 13:00:00	7	30.42	220	5703.1	t	2026-05-08 00:01:27.547131
12322	2026-03-27 13:30:00	1	12.15	220	4671.7	t	2026-05-08 00:01:27.547131
12323	2026-03-27 13:30:00	4	16.32	220	4175.8	t	2026-05-08 00:01:27.547131
12324	2026-03-27 13:30:00	7	24.47	220	5219.9	t	2026-05-08 00:01:27.547131
12325	2026-03-27 14:00:00	1	14.49	220	3345	t	2026-05-08 00:01:27.547131
12326	2026-03-27 14:00:00	4	24.36	220	3605.9	t	2026-05-08 00:01:27.547131
12327	2026-03-27 14:00:00	7	27.31	220	4909	t	2026-05-08 00:01:27.547131
12328	2026-03-27 14:30:00	1	14.26	220	2602.8	t	2026-05-08 00:01:27.547131
12329	2026-03-27 14:30:00	4	16.82	220	5165.6	t	2026-05-08 00:01:27.547131
12330	2026-03-27 14:30:00	7	21.33	220	5666.4	t	2026-05-08 00:01:27.547131
12331	2026-03-27 15:00:00	1	21	220	2647.6	t	2026-05-08 00:01:27.547131
12332	2026-03-27 15:00:00	4	22.84	220	5177.7	t	2026-05-08 00:01:27.547131
12333	2026-03-27 15:00:00	7	27.15	220	6685	t	2026-05-08 00:01:27.547131
12334	2026-03-27 15:30:00	1	14.61	220	2650.2	t	2026-05-08 00:01:27.547131
12335	2026-03-27 15:30:00	4	20.14	220	4940.7	t	2026-05-08 00:01:27.547131
12336	2026-03-27 15:30:00	7	23.9	220	5173.4	t	2026-05-08 00:01:27.547131
12337	2026-03-27 16:00:00	1	15.64	220	2620.2	t	2026-05-08 00:01:27.547131
12338	2026-03-27 16:00:00	4	16.84	220	4328.3	t	2026-05-08 00:01:27.547131
12339	2026-03-27 16:00:00	7	28.68	220	6008.2	t	2026-05-08 00:01:27.547131
12340	2026-03-27 16:30:00	1	18.98	220	2654.7	t	2026-05-08 00:01:27.547131
12341	2026-03-27 16:30:00	4	16.21	220	3736.5	t	2026-05-08 00:01:27.547131
12342	2026-03-27 16:30:00	7	25.12	220	6682	t	2026-05-08 00:01:27.547131
12343	2026-03-27 17:00:00	1	16.84	220	3449.2	t	2026-05-08 00:01:27.547131
12344	2026-03-27 17:00:00	4	25.79	220	4439.6	t	2026-05-08 00:01:27.547131
12345	2026-03-27 17:00:00	7	27.43	220	5921.9	t	2026-05-08 00:01:27.547131
12346	2026-03-27 17:30:00	1	18.24	220	3468.2	t	2026-05-08 00:01:27.547131
12347	2026-03-27 17:30:00	4	20.33	220	4961.6	t	2026-05-08 00:01:27.547131
12348	2026-03-27 17:30:00	7	29.14	220	4655.5	t	2026-05-08 00:01:27.547131
12349	2026-03-27 18:00:00	1	18.41	220	2839.2	t	2026-05-08 00:01:27.547131
12350	2026-03-27 18:00:00	4	17.73	220	3995	t	2026-05-08 00:01:27.547131
12351	2026-03-27 18:00:00	7	28.71	220	6583.8	t	2026-05-08 00:01:27.547131
12352	2026-03-27 18:30:00	1	16.73	220	4061.9	t	2026-05-08 00:01:27.547131
12353	2026-03-27 18:30:00	4	18.04	220	4983.3	t	2026-05-08 00:01:27.547131
12354	2026-03-27 18:30:00	7	30.01	220	5746.8	t	2026-05-08 00:01:27.547131
12355	2026-03-27 19:00:00	1	12.92	220	4706	t	2026-05-08 00:01:27.547131
12356	2026-03-27 19:00:00	4	19.82	220	5248.6	t	2026-05-08 00:01:27.547131
12357	2026-03-27 19:00:00	7	21.01	220	5739.3	t	2026-05-08 00:01:27.547131
12358	2026-03-27 19:30:00	1	12.17	220	3030.2	t	2026-05-08 00:01:27.547131
12359	2026-03-27 19:30:00	4	24.96	220	5402.3	t	2026-05-08 00:01:27.547131
12360	2026-03-27 19:30:00	7	22.67	220	5465.5	t	2026-05-08 00:01:27.547131
12361	2026-03-27 20:00:00	1	3.07	220	388.2	t	2026-05-08 00:01:27.547131
12362	2026-03-27 20:00:00	4	1.22	220	512.8	t	2026-05-08 00:01:27.547131
12363	2026-03-27 20:00:00	7	2.32	220	701.6	t	2026-05-08 00:01:27.547131
12364	2026-03-27 20:30:00	1	3.28	220	770.3	t	2026-05-08 00:01:27.547131
12365	2026-03-27 20:30:00	4	2.22	220	808.2	t	2026-05-08 00:01:27.547131
12366	2026-03-27 20:30:00	7	1.42	220	417.3	t	2026-05-08 00:01:27.547131
12367	2026-03-27 21:00:00	1	2.95	220	769.1	t	2026-05-08 00:01:27.547131
12368	2026-03-27 21:00:00	4	3.53	220	687.6	t	2026-05-08 00:01:27.547131
12369	2026-03-27 21:00:00	7	3.65	220	492.5	t	2026-05-08 00:01:27.547131
12370	2026-03-27 21:30:00	1	2.62	220	634.5	t	2026-05-08 00:01:27.547131
12371	2026-03-27 21:30:00	4	3.29	220	725.2	t	2026-05-08 00:01:27.547131
12372	2026-03-27 21:30:00	7	2.83	220	767	t	2026-05-08 00:01:27.547131
12373	2026-03-27 22:00:00	1	3.63	220	611.1	t	2026-05-08 00:01:27.547131
12374	2026-03-27 22:00:00	4	1.4	220	354.6	t	2026-05-08 00:01:27.547131
12375	2026-03-27 22:00:00	7	2.5	220	608.9	t	2026-05-08 00:01:27.547131
12376	2026-03-27 22:30:00	1	1.52	220	601.5	t	2026-05-08 00:01:27.547131
12377	2026-03-27 22:30:00	4	2.66	220	344.4	t	2026-05-08 00:01:27.547131
12378	2026-03-27 22:30:00	7	3.06	220	365.1	t	2026-05-08 00:01:27.547131
12379	2026-03-27 23:00:00	1	2.93	220	639	t	2026-05-08 00:01:27.547131
12380	2026-03-27 23:00:00	4	2.57	220	430.1	t	2026-05-08 00:01:27.547131
12381	2026-03-27 23:00:00	7	3.07	220	458.2	t	2026-05-08 00:01:27.547131
12382	2026-03-27 23:30:00	1	2.54	220	723.1	t	2026-05-08 00:01:27.547131
12383	2026-03-27 23:30:00	4	1.27	220	348.4	t	2026-05-08 00:01:27.547131
12384	2026-03-27 23:30:00	7	1.47	220	403.4	t	2026-05-08 00:01:27.547131
12385	2026-03-28 00:00:00	1	1.75	220	391.8	t	2026-05-08 00:01:27.547131
12386	2026-03-28 00:00:00	4	1.98	220	600.5	t	2026-05-08 00:01:27.547131
12387	2026-03-28 00:00:00	7	2.9	220	422.5	t	2026-05-08 00:01:27.547131
12388	2026-03-28 00:30:00	1	1.81	220	326.1	t	2026-05-08 00:01:27.547131
12389	2026-03-28 00:30:00	4	1.24	220	610.5	t	2026-05-08 00:01:27.547131
12390	2026-03-28 00:30:00	7	2.59	220	233	t	2026-05-08 00:01:27.547131
12391	2026-03-28 01:00:00	1	2.57	220	359.3	t	2026-05-08 00:01:27.547131
12392	2026-03-28 01:00:00	4	1.19	220	544.2	t	2026-05-08 00:01:27.547131
12393	2026-03-28 01:00:00	7	1.45	220	347	t	2026-05-08 00:01:27.547131
12394	2026-03-28 01:30:00	1	1.97	220	241.9	t	2026-05-08 00:01:27.547131
12395	2026-03-28 01:30:00	4	1.65	220	636.3	t	2026-05-08 00:01:27.547131
12396	2026-03-28 01:30:00	7	1.62	220	426.9	t	2026-05-08 00:01:27.547131
12397	2026-03-28 02:00:00	1	1.53	220	390.5	t	2026-05-08 00:01:27.547131
12398	2026-03-28 02:00:00	4	1.62	220	363.6	t	2026-05-08 00:01:27.547131
12399	2026-03-28 02:00:00	7	2.74	220	475.7	t	2026-05-08 00:01:27.547131
12400	2026-03-28 02:30:00	1	1.7	220	551.3	t	2026-05-08 00:01:27.547131
12401	2026-03-28 02:30:00	4	1.47	220	221.4	t	2026-05-08 00:01:27.547131
12402	2026-03-28 02:30:00	7	2.85	220	451.5	t	2026-05-08 00:01:27.547131
12403	2026-03-28 03:00:00	1	2.88	220	294.3	t	2026-05-08 00:01:27.547131
12404	2026-03-28 03:00:00	4	2.1	220	359.8	t	2026-05-08 00:01:27.547131
12405	2026-03-28 03:00:00	7	2.4	220	230.9	t	2026-05-08 00:01:27.547131
12406	2026-03-28 03:30:00	1	1.14	220	301.2	t	2026-05-08 00:01:27.547131
12407	2026-03-28 03:30:00	4	2.91	220	552.2	t	2026-05-08 00:01:27.547131
12408	2026-03-28 03:30:00	7	1.08	220	600.5	t	2026-05-08 00:01:27.547131
12409	2026-03-28 04:00:00	1	1.34	220	395.1	t	2026-05-08 00:01:27.547131
12410	2026-03-28 04:00:00	4	2.45	220	393.9	t	2026-05-08 00:01:27.547131
12411	2026-03-28 04:00:00	7	2.21	220	444.1	t	2026-05-08 00:01:27.547131
12412	2026-03-28 04:30:00	1	1.49	220	562.8	t	2026-05-08 00:01:27.547131
12413	2026-03-28 04:30:00	4	1.22	220	541.6	t	2026-05-08 00:01:27.547131
12414	2026-03-28 04:30:00	7	2.8	220	428.9	t	2026-05-08 00:01:27.547131
12415	2026-03-28 05:00:00	1	1.76	220	403.5	t	2026-05-08 00:01:27.547131
12416	2026-03-28 05:00:00	4	1.28	220	558.1	t	2026-05-08 00:01:27.547131
12417	2026-03-28 05:00:00	7	1.71	220	601	t	2026-05-08 00:01:27.547131
12418	2026-03-28 05:30:00	1	2.17	220	454.6	t	2026-05-08 00:01:27.547131
12419	2026-03-28 05:30:00	4	2.23	220	275.9	t	2026-05-08 00:01:27.547131
12420	2026-03-28 05:30:00	7	2.65	220	642.6	t	2026-05-08 00:01:27.547131
12421	2026-03-28 06:00:00	1	2.43	220	239.3	t	2026-05-08 00:01:27.547131
12422	2026-03-28 06:00:00	4	2.25	220	584.3	t	2026-05-08 00:01:27.547131
12423	2026-03-28 06:00:00	7	1.37	220	275.7	t	2026-05-08 00:01:27.547131
12424	2026-03-28 06:30:00	1	2.35	220	333.7	t	2026-05-08 00:01:27.547131
12425	2026-03-28 06:30:00	4	2.13	220	587	t	2026-05-08 00:01:27.547131
12426	2026-03-28 06:30:00	7	1.78	220	641.1	t	2026-05-08 00:01:27.547131
12427	2026-03-28 07:00:00	1	1.83	220	298.5	t	2026-05-08 00:01:27.547131
12428	2026-03-28 07:00:00	4	2.98	220	329.5	t	2026-05-08 00:01:27.547131
12429	2026-03-28 07:00:00	7	1.94	220	283.2	t	2026-05-08 00:01:27.547131
12430	2026-03-28 07:30:00	1	2.67	220	419.9	t	2026-05-08 00:01:27.547131
12431	2026-03-28 07:30:00	4	2.83	220	494.1	t	2026-05-08 00:01:27.547131
12432	2026-03-28 07:30:00	7	2.22	220	411	t	2026-05-08 00:01:27.547131
12433	2026-03-28 08:00:00	1	1.06	220	342.9	t	2026-05-08 00:01:27.547131
12434	2026-03-28 08:00:00	4	1.63	220	647.4	t	2026-05-08 00:01:27.547131
12435	2026-03-28 08:00:00	7	2.06	220	224.7	t	2026-05-08 00:01:27.547131
12436	2026-03-28 08:30:00	1	1.38	220	243	t	2026-05-08 00:01:27.547131
12437	2026-03-28 08:30:00	4	1.78	220	371.3	t	2026-05-08 00:01:27.547131
12438	2026-03-28 08:30:00	7	1.87	220	232.5	t	2026-05-08 00:01:27.547131
12439	2026-03-28 09:00:00	1	2.06	220	650.1	t	2026-05-08 00:01:27.547131
12440	2026-03-28 09:00:00	4	2.68	220	652	t	2026-05-08 00:01:27.547131
12441	2026-03-28 09:00:00	7	2.27	220	608.7	t	2026-05-08 00:01:27.547131
12442	2026-03-28 09:30:00	1	1.05	220	495.3	t	2026-05-08 00:01:27.547131
12443	2026-03-28 09:30:00	4	1.65	220	362.7	t	2026-05-08 00:01:27.547131
12444	2026-03-28 09:30:00	7	2.03	220	252.5	t	2026-05-08 00:01:27.547131
12445	2026-03-28 10:00:00	1	1.01	220	312.3	t	2026-05-08 00:01:27.547131
12446	2026-03-28 10:00:00	4	1.94	220	513.9	t	2026-05-08 00:01:27.547131
12447	2026-03-28 10:00:00	7	2.92	220	459	t	2026-05-08 00:01:27.547131
12448	2026-03-28 10:30:00	1	1.25	220	429.9	t	2026-05-08 00:01:27.547131
12449	2026-03-28 10:30:00	4	2.05	220	624.9	t	2026-05-08 00:01:27.547131
12450	2026-03-28 10:30:00	7	1.75	220	380.2	t	2026-05-08 00:01:27.547131
12451	2026-03-28 11:00:00	1	1.12	220	657.2	t	2026-05-08 00:01:27.547131
12452	2026-03-28 11:00:00	4	1.32	220	572.9	t	2026-05-08 00:01:27.547131
12453	2026-03-28 11:00:00	7	1.77	220	407.4	t	2026-05-08 00:01:27.547131
12454	2026-03-28 11:30:00	1	1.71	220	480.2	t	2026-05-08 00:01:27.547131
12455	2026-03-28 11:30:00	4	1.97	220	623.3	t	2026-05-08 00:01:27.547131
12456	2026-03-28 11:30:00	7	2.91	220	568.1	t	2026-05-08 00:01:27.547131
12457	2026-03-28 12:00:00	1	1.5	220	461	t	2026-05-08 00:01:27.547131
12458	2026-03-28 12:00:00	4	3	220	447.8	t	2026-05-08 00:01:27.547131
12459	2026-03-28 12:00:00	7	1.18	220	548.2	t	2026-05-08 00:01:27.547131
12460	2026-03-28 12:30:00	1	2.62	220	476.9	t	2026-05-08 00:01:27.547131
12461	2026-03-28 12:30:00	4	2.07	220	554.2	t	2026-05-08 00:01:27.547131
12462	2026-03-28 12:30:00	7	1.4	220	657.9	t	2026-05-08 00:01:27.547131
12463	2026-03-28 13:00:00	1	1.04	220	640.5	t	2026-05-08 00:01:27.547131
12464	2026-03-28 13:00:00	4	2.88	220	284.3	t	2026-05-08 00:01:27.547131
12465	2026-03-28 13:00:00	7	1.41	220	471.8	t	2026-05-08 00:01:27.547131
12466	2026-03-28 13:30:00	1	1	220	518.6	t	2026-05-08 00:01:27.547131
12467	2026-03-28 13:30:00	4	2.97	220	352	t	2026-05-08 00:01:27.547131
12468	2026-03-28 13:30:00	7	1.62	220	313.1	t	2026-05-08 00:01:27.547131
12469	2026-03-28 14:00:00	1	2.95	220	573	t	2026-05-08 00:01:27.547131
12470	2026-03-28 14:00:00	4	1.94	220	252	t	2026-05-08 00:01:27.547131
12471	2026-03-28 14:00:00	7	2.71	220	600.5	t	2026-05-08 00:01:27.547131
12472	2026-03-28 14:30:00	1	2.72	220	592.1	t	2026-05-08 00:01:27.547131
12473	2026-03-28 14:30:00	4	1.58	220	490.1	t	2026-05-08 00:01:27.547131
12474	2026-03-28 14:30:00	7	2.58	220	394.5	t	2026-05-08 00:01:27.547131
12475	2026-03-28 15:00:00	1	2.5	220	652	t	2026-05-08 00:01:27.547131
12476	2026-03-28 15:00:00	4	2.27	220	480.6	t	2026-05-08 00:01:27.547131
12477	2026-03-28 15:00:00	7	1.09	220	256.4	t	2026-05-08 00:01:27.547131
12478	2026-03-28 15:30:00	1	1.05	220	273.1	t	2026-05-08 00:01:27.547131
12479	2026-03-28 15:30:00	4	1.25	220	237	t	2026-05-08 00:01:27.547131
12480	2026-03-28 15:30:00	7	2.09	220	395.9	t	2026-05-08 00:01:27.547131
12481	2026-03-28 16:00:00	1	2.23	220	483.6	t	2026-05-08 00:01:27.547131
12482	2026-03-28 16:00:00	4	1.71	220	299.7	t	2026-05-08 00:01:27.547131
12483	2026-03-28 16:00:00	7	2.21	220	311.9	t	2026-05-08 00:01:27.547131
12484	2026-03-28 16:30:00	1	2.02	220	414.1	t	2026-05-08 00:01:27.547131
12485	2026-03-28 16:30:00	4	2.16	220	439.6	t	2026-05-08 00:01:27.547131
12486	2026-03-28 16:30:00	7	2.95	220	256.8	t	2026-05-08 00:01:27.547131
12487	2026-03-28 17:00:00	1	1.49	220	596.6	t	2026-05-08 00:01:27.547131
12488	2026-03-28 17:00:00	4	1.73	220	407.1	t	2026-05-08 00:01:27.547131
12489	2026-03-28 17:00:00	7	1.8	220	362.2	t	2026-05-08 00:01:27.547131
12490	2026-03-28 17:30:00	1	2.32	220	457.6	t	2026-05-08 00:01:27.547131
12491	2026-03-28 17:30:00	4	1.16	220	395.9	t	2026-05-08 00:01:27.547131
12492	2026-03-28 17:30:00	7	1.58	220	650.3	t	2026-05-08 00:01:27.547131
12493	2026-03-28 18:00:00	1	2.95	220	350.2	t	2026-05-08 00:01:27.547131
12494	2026-03-28 18:00:00	4	2.33	220	544.9	t	2026-05-08 00:01:27.547131
12495	2026-03-28 18:00:00	7	2.24	220	304.8	t	2026-05-08 00:01:27.547131
12496	2026-03-28 18:30:00	1	1.58	220	645.8	t	2026-05-08 00:01:27.547131
12497	2026-03-28 18:30:00	4	2.39	220	413.8	t	2026-05-08 00:01:27.547131
12498	2026-03-28 18:30:00	7	2.51	220	313.3	t	2026-05-08 00:01:27.547131
12499	2026-03-28 19:00:00	1	2.88	220	402.4	t	2026-05-08 00:01:27.547131
12500	2026-03-28 19:00:00	4	2.46	220	389.3	t	2026-05-08 00:01:27.547131
12501	2026-03-28 19:00:00	7	2.82	220	298.8	t	2026-05-08 00:01:27.547131
12502	2026-03-28 19:30:00	1	2.85	220	483.5	t	2026-05-08 00:01:27.547131
12503	2026-03-28 19:30:00	4	1.56	220	365.8	t	2026-05-08 00:01:27.547131
12504	2026-03-28 19:30:00	7	2.17	220	238.9	t	2026-05-08 00:01:27.547131
12505	2026-03-28 20:00:00	1	2.29	220	278	t	2026-05-08 00:01:27.547131
12506	2026-03-28 20:00:00	4	2	220	601.5	t	2026-05-08 00:01:27.547131
12507	2026-03-28 20:00:00	7	1.73	220	266.4	t	2026-05-08 00:01:27.547131
12508	2026-03-28 20:30:00	1	2.13	220	599.4	t	2026-05-08 00:01:27.547131
12509	2026-03-28 20:30:00	4	1.98	220	376.4	t	2026-05-08 00:01:27.547131
12510	2026-03-28 20:30:00	7	1.81	220	431.5	t	2026-05-08 00:01:27.547131
12511	2026-03-28 21:00:00	1	2.66	220	584.4	t	2026-05-08 00:01:27.547131
12512	2026-03-28 21:00:00	4	2.21	220	575.1	t	2026-05-08 00:01:27.547131
12513	2026-03-28 21:00:00	7	2.75	220	606.4	t	2026-05-08 00:01:27.547131
12514	2026-03-28 21:30:00	1	2.7	220	536.4	t	2026-05-08 00:01:27.547131
12515	2026-03-28 21:30:00	4	2.79	220	568.8	t	2026-05-08 00:01:27.547131
12516	2026-03-28 21:30:00	7	2.96	220	256	t	2026-05-08 00:01:27.547131
12517	2026-03-28 22:00:00	1	1.55	220	268.2	t	2026-05-08 00:01:27.547131
12518	2026-03-28 22:00:00	4	2.11	220	266.7	t	2026-05-08 00:01:27.547131
12519	2026-03-28 22:00:00	7	2.47	220	336.9	t	2026-05-08 00:01:27.547131
12520	2026-03-28 22:30:00	1	1.27	220	386.6	t	2026-05-08 00:01:27.547131
12521	2026-03-28 22:30:00	4	2.03	220	354.4	t	2026-05-08 00:01:27.547131
12522	2026-03-28 22:30:00	7	1.54	220	621.3	t	2026-05-08 00:01:27.547131
12523	2026-03-28 23:00:00	1	1.81	220	307	t	2026-05-08 00:01:27.547131
12524	2026-03-28 23:00:00	4	1.61	220	563.4	t	2026-05-08 00:01:27.547131
12525	2026-03-28 23:00:00	7	2.58	220	548.9	t	2026-05-08 00:01:27.547131
12526	2026-03-28 23:30:00	1	2.15	220	451.8	t	2026-05-08 00:01:27.547131
12527	2026-03-28 23:30:00	4	1.78	220	620.1	t	2026-05-08 00:01:27.547131
12528	2026-03-28 23:30:00	7	2.64	220	442.6	t	2026-05-08 00:01:27.547131
12529	2026-03-29 00:00:00	1	2.78	220	628.9	t	2026-05-08 00:01:27.547131
12530	2026-03-29 00:00:00	4	1.53	220	379.8	t	2026-05-08 00:01:27.547131
12531	2026-03-29 00:00:00	7	2.35	220	240.5	t	2026-05-08 00:01:27.547131
12532	2026-03-29 00:30:00	1	2.08	220	639.3	t	2026-05-08 00:01:27.547131
12533	2026-03-29 00:30:00	4	1.78	220	440.1	t	2026-05-08 00:01:27.547131
12534	2026-03-29 00:30:00	7	1.32	220	380.5	t	2026-05-08 00:01:27.547131
12535	2026-03-29 01:00:00	1	1.92	220	488	t	2026-05-08 00:01:27.547131
12536	2026-03-29 01:00:00	4	1.34	220	468.5	t	2026-05-08 00:01:27.547131
12537	2026-03-29 01:00:00	7	2.76	220	606.3	t	2026-05-08 00:01:27.547131
12538	2026-03-29 01:30:00	1	2.03	220	379.1	t	2026-05-08 00:01:27.547131
12539	2026-03-29 01:30:00	4	2.83	220	493	t	2026-05-08 00:01:27.547131
12540	2026-03-29 01:30:00	7	1.98	220	293.6	t	2026-05-08 00:01:27.547131
12541	2026-03-29 02:00:00	1	1.04	220	557.9	t	2026-05-08 00:01:27.547131
12542	2026-03-29 02:00:00	4	2.25	220	463.3	t	2026-05-08 00:01:27.547131
12543	2026-03-29 02:00:00	7	1.49	220	568.7	t	2026-05-08 00:01:27.547131
12544	2026-03-29 02:30:00	1	2.55	220	529.5	t	2026-05-08 00:01:27.547131
12545	2026-03-29 02:30:00	4	2.94	220	528.2	t	2026-05-08 00:01:27.547131
12546	2026-03-29 02:30:00	7	2.1	220	610.8	t	2026-05-08 00:01:27.547131
12547	2026-03-29 03:00:00	1	2.84	220	647	t	2026-05-08 00:01:27.547131
12548	2026-03-29 03:00:00	4	1.38	220	552	t	2026-05-08 00:01:27.547131
12549	2026-03-29 03:00:00	7	2.25	220	608.4	t	2026-05-08 00:01:27.547131
12550	2026-03-29 03:30:00	1	2.34	220	431.4	t	2026-05-08 00:01:27.547131
12551	2026-03-29 03:30:00	4	2.83	220	386.4	t	2026-05-08 00:01:27.547131
12552	2026-03-29 03:30:00	7	1.71	220	459.8	t	2026-05-08 00:01:27.547131
12553	2026-03-29 04:00:00	1	2.47	220	642.5	t	2026-05-08 00:01:27.547131
12554	2026-03-29 04:00:00	4	2.28	220	555.8	t	2026-05-08 00:01:27.547131
12555	2026-03-29 04:00:00	7	2.96	220	538.8	t	2026-05-08 00:01:27.547131
12556	2026-03-29 04:30:00	1	1.46	220	620.8	t	2026-05-08 00:01:27.547131
12557	2026-03-29 04:30:00	4	2.25	220	450.3	t	2026-05-08 00:01:27.547131
12558	2026-03-29 04:30:00	7	1.85	220	355.5	t	2026-05-08 00:01:27.547131
12559	2026-03-29 05:00:00	1	1.24	220	315.5	t	2026-05-08 00:01:27.547131
12560	2026-03-29 05:00:00	4	2.25	220	373.7	t	2026-05-08 00:01:27.547131
12561	2026-03-29 05:00:00	7	1.53	220	284.4	t	2026-05-08 00:01:27.547131
12562	2026-03-29 05:30:00	1	1.48	220	548.6	t	2026-05-08 00:01:27.547131
12563	2026-03-29 05:30:00	4	1.08	220	353.2	t	2026-05-08 00:01:27.547131
12564	2026-03-29 05:30:00	7	2.8	220	286.5	t	2026-05-08 00:01:27.547131
12565	2026-03-29 06:00:00	1	1.44	220	227.6	t	2026-05-08 00:01:27.547131
12566	2026-03-29 06:00:00	4	1.29	220	324.8	t	2026-05-08 00:01:27.547131
12567	2026-03-29 06:00:00	7	1.7	220	390.2	t	2026-05-08 00:01:27.547131
12568	2026-03-29 06:30:00	1	1.29	220	377.9	t	2026-05-08 00:01:27.547131
12569	2026-03-29 06:30:00	4	1.83	220	426.6	t	2026-05-08 00:01:27.547131
12570	2026-03-29 06:30:00	7	2.65	220	358.6	t	2026-05-08 00:01:27.547131
12571	2026-03-29 07:00:00	1	2.46	220	431.6	t	2026-05-08 00:01:27.547131
12572	2026-03-29 07:00:00	4	2.58	220	250	t	2026-05-08 00:01:27.547131
12573	2026-03-29 07:00:00	7	1.17	220	587.9	t	2026-05-08 00:01:27.547131
12574	2026-03-29 07:30:00	1	1.28	220	359.9	t	2026-05-08 00:01:27.547131
12575	2026-03-29 07:30:00	4	1.58	220	478.3	t	2026-05-08 00:01:27.547131
12576	2026-03-29 07:30:00	7	1.2	220	401.6	t	2026-05-08 00:01:27.547131
12577	2026-03-29 08:00:00	1	1.68	220	612.1	t	2026-05-08 00:01:27.547131
12578	2026-03-29 08:00:00	4	1.12	220	576.3	t	2026-05-08 00:01:27.547131
12579	2026-03-29 08:00:00	7	2.18	220	557	t	2026-05-08 00:01:27.547131
12580	2026-03-29 08:30:00	1	2.21	220	467.9	t	2026-05-08 00:01:27.547131
12581	2026-03-29 08:30:00	4	1.44	220	538.7	t	2026-05-08 00:01:27.547131
12582	2026-03-29 08:30:00	7	1.69	220	411.3	t	2026-05-08 00:01:27.547131
12583	2026-03-29 09:00:00	1	1.81	220	384.2	t	2026-05-08 00:01:27.547131
12584	2026-03-29 09:00:00	4	2.25	220	258.6	t	2026-05-08 00:01:27.547131
12585	2026-03-29 09:00:00	7	2.68	220	505.4	t	2026-05-08 00:01:27.547131
12586	2026-03-29 09:30:00	1	2.47	220	244	t	2026-05-08 00:01:27.547131
12587	2026-03-29 09:30:00	4	2.83	220	647.8	t	2026-05-08 00:01:27.547131
12588	2026-03-29 09:30:00	7	1.31	220	393.5	t	2026-05-08 00:01:27.547131
12589	2026-03-29 10:00:00	1	1.27	220	484.9	t	2026-05-08 00:01:27.547131
12590	2026-03-29 10:00:00	4	2.12	220	507.9	t	2026-05-08 00:01:27.547131
12591	2026-03-29 10:00:00	7	1.4	220	522.3	t	2026-05-08 00:01:27.547131
12592	2026-03-29 10:30:00	1	1.6	220	226	t	2026-05-08 00:01:27.547131
12593	2026-03-29 10:30:00	4	1.38	220	325.8	t	2026-05-08 00:01:27.547131
12594	2026-03-29 10:30:00	7	1.72	220	418.7	t	2026-05-08 00:01:27.547131
12595	2026-03-29 11:00:00	1	1.19	220	315.1	t	2026-05-08 00:01:27.547131
12596	2026-03-29 11:00:00	4	1.06	220	448.5	t	2026-05-08 00:01:27.547131
12597	2026-03-29 11:00:00	7	2.12	220	252.1	t	2026-05-08 00:01:27.547131
12598	2026-03-29 11:30:00	1	1.97	220	342.7	t	2026-05-08 00:01:27.547131
12599	2026-03-29 11:30:00	4	1.14	220	581.6	t	2026-05-08 00:01:27.547131
12600	2026-03-29 11:30:00	7	2.69	220	559.7	t	2026-05-08 00:01:27.547131
12601	2026-03-29 12:00:00	1	2.28	220	437.3	t	2026-05-08 00:01:27.547131
12602	2026-03-29 12:00:00	4	2.94	220	630.6	t	2026-05-08 00:01:27.547131
12603	2026-03-29 12:00:00	7	1.75	220	318.9	t	2026-05-08 00:01:27.547131
12604	2026-03-29 12:30:00	1	2.29	220	596.1	t	2026-05-08 00:01:27.547131
12605	2026-03-29 12:30:00	4	1.77	220	224	t	2026-05-08 00:01:27.547131
12606	2026-03-29 12:30:00	7	1.58	220	560.3	t	2026-05-08 00:01:27.547131
12607	2026-03-29 13:00:00	1	2.91	220	360.7	t	2026-05-08 00:01:27.547131
12608	2026-03-29 13:00:00	4	1.23	220	598.1	t	2026-05-08 00:01:27.547131
12609	2026-03-29 13:00:00	7	2.17	220	409.8	t	2026-05-08 00:01:27.547131
12610	2026-03-29 13:30:00	1	1.77	220	221.2	t	2026-05-08 00:01:27.547131
12611	2026-03-29 13:30:00	4	2.18	220	428.6	t	2026-05-08 00:01:27.547131
12612	2026-03-29 13:30:00	7	1.25	220	509	t	2026-05-08 00:01:27.547131
12613	2026-03-29 14:00:00	1	1.85	220	313.8	t	2026-05-08 00:01:27.547131
12614	2026-03-29 14:00:00	4	2.04	220	579.5	t	2026-05-08 00:01:27.547131
12615	2026-03-29 14:00:00	7	2.82	220	656.1	t	2026-05-08 00:01:27.547131
12616	2026-03-29 14:30:00	1	1.54	220	572.6	t	2026-05-08 00:01:27.547131
12617	2026-03-29 14:30:00	4	1.61	220	279.1	t	2026-05-08 00:01:27.547131
12618	2026-03-29 14:30:00	7	1.93	220	438.8	t	2026-05-08 00:01:27.547131
12619	2026-03-29 15:00:00	1	1.31	220	602.3	t	2026-05-08 00:01:27.547131
12620	2026-03-29 15:00:00	4	1.46	220	600.2	t	2026-05-08 00:01:27.547131
12621	2026-03-29 15:00:00	7	1.41	220	336.9	t	2026-05-08 00:01:27.547131
12622	2026-03-29 15:30:00	1	2.98	220	429	t	2026-05-08 00:01:27.547131
12623	2026-03-29 15:30:00	4	1.47	220	327.3	t	2026-05-08 00:01:27.547131
12624	2026-03-29 15:30:00	7	1.54	220	264.2	t	2026-05-08 00:01:27.547131
12625	2026-03-29 16:00:00	1	1.29	220	376.4	t	2026-05-08 00:01:27.547131
12626	2026-03-29 16:00:00	4	1.32	220	620.5	t	2026-05-08 00:01:27.547131
12627	2026-03-29 16:00:00	7	2.62	220	293.1	t	2026-05-08 00:01:27.547131
12628	2026-03-29 16:30:00	1	2.04	220	574	t	2026-05-08 00:01:27.547131
12629	2026-03-29 16:30:00	4	2.37	220	557.6	t	2026-05-08 00:01:27.547131
12630	2026-03-29 16:30:00	7	1.34	220	228	t	2026-05-08 00:01:27.547131
12631	2026-03-29 17:00:00	1	1.26	220	482	t	2026-05-08 00:01:27.547131
12632	2026-03-29 17:00:00	4	2.2	220	252.6	t	2026-05-08 00:01:27.547131
12633	2026-03-29 17:00:00	7	1.32	220	449.6	t	2026-05-08 00:01:27.547131
12634	2026-03-29 17:30:00	1	1.75	220	638.9	t	2026-05-08 00:01:27.547131
12635	2026-03-29 17:30:00	4	1.05	220	482.6	t	2026-05-08 00:01:27.547131
12636	2026-03-29 17:30:00	7	1.34	220	651.9	t	2026-05-08 00:01:27.547131
12637	2026-03-29 18:00:00	1	1.27	220	230.4	t	2026-05-08 00:01:27.547131
12638	2026-03-29 18:00:00	4	2.2	220	481.9	t	2026-05-08 00:01:27.547131
12639	2026-03-29 18:00:00	7	2.47	220	237.9	t	2026-05-08 00:01:27.547131
12640	2026-03-29 18:30:00	1	1.09	220	281.6	t	2026-05-08 00:01:27.547131
12641	2026-03-29 18:30:00	4	2.43	220	618.7	t	2026-05-08 00:01:27.547131
12642	2026-03-29 18:30:00	7	1.68	220	584.6	t	2026-05-08 00:01:27.547131
12643	2026-03-29 19:00:00	1	1.06	220	648.2	t	2026-05-08 00:01:27.547131
12644	2026-03-29 19:00:00	4	1.67	220	261.1	t	2026-05-08 00:01:27.547131
12645	2026-03-29 19:00:00	7	2.35	220	332.7	t	2026-05-08 00:01:27.547131
12646	2026-03-29 19:30:00	1	2.66	220	546.9	t	2026-05-08 00:01:27.547131
12647	2026-03-29 19:30:00	4	1.16	220	527.1	t	2026-05-08 00:01:27.547131
12648	2026-03-29 19:30:00	7	2.92	220	306.1	t	2026-05-08 00:01:27.547131
12649	2026-03-29 20:00:00	1	2.89	220	598.6	t	2026-05-08 00:01:27.547131
12650	2026-03-29 20:00:00	4	2.09	220	246.5	t	2026-05-08 00:01:27.547131
12651	2026-03-29 20:00:00	7	1.28	220	574.3	t	2026-05-08 00:01:27.547131
12652	2026-03-29 20:30:00	1	2.99	220	452.6	t	2026-05-08 00:01:27.547131
12653	2026-03-29 20:30:00	4	1.36	220	470.7	t	2026-05-08 00:01:27.547131
12654	2026-03-29 20:30:00	7	1.6	220	619.9	t	2026-05-08 00:01:27.547131
12655	2026-03-29 21:00:00	1	1.13	220	550.9	t	2026-05-08 00:01:27.547131
12656	2026-03-29 21:00:00	4	1.88	220	244.3	t	2026-05-08 00:01:27.547131
12657	2026-03-29 21:00:00	7	2.7	220	302.5	t	2026-05-08 00:01:27.547131
12658	2026-03-29 21:30:00	1	2.05	220	362.1	t	2026-05-08 00:01:27.547131
12659	2026-03-29 21:30:00	4	2.23	220	630.5	t	2026-05-08 00:01:27.547131
12660	2026-03-29 21:30:00	7	1.21	220	472.4	t	2026-05-08 00:01:27.547131
12661	2026-03-29 22:00:00	1	1.63	220	606.4	t	2026-05-08 00:01:27.547131
12662	2026-03-29 22:00:00	4	2.46	220	600.5	t	2026-05-08 00:01:27.547131
12663	2026-03-29 22:00:00	7	1.42	220	255.5	t	2026-05-08 00:01:27.547131
12664	2026-03-29 22:30:00	1	2.55	220	523.6	t	2026-05-08 00:01:27.547131
12665	2026-03-29 22:30:00	4	1.53	220	572.6	t	2026-05-08 00:01:27.547131
12666	2026-03-29 22:30:00	7	1.03	220	573.2	t	2026-05-08 00:01:27.547131
12667	2026-03-29 23:00:00	1	1.5	220	375.5	t	2026-05-08 00:01:27.547131
12668	2026-03-29 23:00:00	4	2.53	220	518	t	2026-05-08 00:01:27.547131
12669	2026-03-29 23:00:00	7	2.67	220	558.1	t	2026-05-08 00:01:27.547131
12670	2026-03-29 23:30:00	1	1.65	220	445.9	t	2026-05-08 00:01:27.547131
12671	2026-03-29 23:30:00	4	1.13	220	472.9	t	2026-05-08 00:01:27.547131
12672	2026-03-29 23:30:00	7	2.19	220	249.9	t	2026-05-08 00:01:27.547131
12673	2026-03-30 00:00:00	1	1.71	220	310.2	t	2026-05-08 00:01:27.547131
12674	2026-03-30 00:00:00	4	3.01	220	741.4	t	2026-05-08 00:01:27.547131
12675	2026-03-30 00:00:00	7	2.16	220	684.1	t	2026-05-08 00:01:27.547131
12676	2026-03-30 00:30:00	1	2.73	220	661.3	t	2026-05-08 00:01:27.547131
12677	2026-03-30 00:30:00	4	1.44	220	416.2	t	2026-05-08 00:01:27.547131
12678	2026-03-30 00:30:00	7	3.67	220	394.9	t	2026-05-08 00:01:27.547131
12679	2026-03-30 01:00:00	1	1.88	220	342.7	t	2026-05-08 00:01:27.547131
12680	2026-03-30 01:00:00	4	1.53	220	529.5	t	2026-05-08 00:01:27.547131
12681	2026-03-30 01:00:00	7	1.25	220	565.9	t	2026-05-08 00:01:27.547131
12682	2026-03-30 01:30:00	1	2.29	220	366.3	t	2026-05-08 00:01:27.547131
12683	2026-03-30 01:30:00	4	2.2	220	811.9	t	2026-05-08 00:01:27.547131
12684	2026-03-30 01:30:00	7	3.63	220	415.3	t	2026-05-08 00:01:27.547131
12685	2026-03-30 02:00:00	1	2.35	220	750.3	t	2026-05-08 00:01:27.547131
12686	2026-03-30 02:00:00	4	3.06	220	551	t	2026-05-08 00:01:27.547131
12687	2026-03-30 02:00:00	7	3.7	220	527.6	t	2026-05-08 00:01:27.547131
12688	2026-03-30 02:30:00	1	1.93	220	775.2	t	2026-05-08 00:01:27.547131
12689	2026-03-30 02:30:00	4	2.29	220	643	t	2026-05-08 00:01:27.547131
12690	2026-03-30 02:30:00	7	2.79	220	550.8	t	2026-05-08 00:01:27.547131
12691	2026-03-30 03:00:00	1	1.62	220	609.1	t	2026-05-08 00:01:27.547131
12692	2026-03-30 03:00:00	4	3.56	220	645.7	t	2026-05-08 00:01:27.547131
12693	2026-03-30 03:00:00	7	2.69	220	474.8	t	2026-05-08 00:01:27.547131
12694	2026-03-30 03:30:00	1	3.1	220	573.8	t	2026-05-08 00:01:27.547131
12695	2026-03-30 03:30:00	4	2.23	220	671.1	t	2026-05-08 00:01:27.547131
12696	2026-03-30 03:30:00	7	1.97	220	611.7	t	2026-05-08 00:01:27.547131
12697	2026-03-30 04:00:00	1	2.79	220	280.4	t	2026-05-08 00:01:27.547131
12698	2026-03-30 04:00:00	4	2.93	220	754.2	t	2026-05-08 00:01:27.547131
12699	2026-03-30 04:00:00	7	1.24	220	291.4	t	2026-05-08 00:01:27.547131
12700	2026-03-30 04:30:00	1	3.12	220	479.7	t	2026-05-08 00:01:27.547131
12701	2026-03-30 04:30:00	4	2.33	220	278.9	t	2026-05-08 00:01:27.547131
12702	2026-03-30 04:30:00	7	3.12	220	592.5	t	2026-05-08 00:01:27.547131
12703	2026-03-30 05:00:00	1	3.42	220	618.2	t	2026-05-08 00:01:27.547131
12704	2026-03-30 05:00:00	4	1.93	220	577.9	t	2026-05-08 00:01:27.547131
12705	2026-03-30 05:00:00	7	2.06	220	405.3	t	2026-05-08 00:01:27.547131
12706	2026-03-30 05:30:00	1	1.76	220	792.2	t	2026-05-08 00:01:27.547131
12707	2026-03-30 05:30:00	4	3.27	220	781.4	t	2026-05-08 00:01:27.547131
12708	2026-03-30 05:30:00	7	2.78	220	810.9	t	2026-05-08 00:01:27.547131
12709	2026-03-30 06:00:00	1	2.47	220	360.6	t	2026-05-08 00:01:27.547131
12710	2026-03-30 06:00:00	4	1.83	220	612.8	t	2026-05-08 00:01:27.547131
12711	2026-03-30 06:00:00	7	1.24	220	757.3	t	2026-05-08 00:01:27.547131
12712	2026-03-30 06:30:00	1	2.15	220	425.5	t	2026-05-08 00:01:27.547131
12713	2026-03-30 06:30:00	4	1.43	220	786.5	t	2026-05-08 00:01:27.547131
12714	2026-03-30 06:30:00	7	3.12	220	581.1	t	2026-05-08 00:01:27.547131
12715	2026-03-30 07:00:00	1	12.16	220	3744.5	t	2026-05-08 00:01:27.547131
12716	2026-03-30 07:00:00	4	25.02	220	5095.3	t	2026-05-08 00:01:27.547131
12717	2026-03-30 07:00:00	7	27.06	220	4916	t	2026-05-08 00:01:27.547131
12718	2026-03-30 07:30:00	1	18.91	220	2904.1	t	2026-05-08 00:01:27.547131
12719	2026-03-30 07:30:00	4	21.92	220	3680.8	t	2026-05-08 00:01:27.547131
12720	2026-03-30 07:30:00	7	20.73	220	6119.5	t	2026-05-08 00:01:27.547131
12721	2026-03-30 08:00:00	1	20.34	220	4328.7	t	2026-05-08 00:01:27.547131
12722	2026-03-30 08:00:00	4	18.31	220	4123.4	t	2026-05-08 00:01:27.547131
12723	2026-03-30 08:00:00	7	27.53	220	5833.3	t	2026-05-08 00:01:27.547131
12724	2026-03-30 08:30:00	1	14.82	220	2606.7	t	2026-05-08 00:01:27.547131
12725	2026-03-30 08:30:00	4	17.47	220	4101.3	t	2026-05-08 00:01:27.547131
12726	2026-03-30 08:30:00	7	22.23	220	6387.4	t	2026-05-08 00:01:27.547131
12727	2026-03-30 09:00:00	1	19.97	220	4101.2	t	2026-05-08 00:01:27.547131
12728	2026-03-30 09:00:00	4	19.6	220	4529.1	t	2026-05-08 00:01:27.547131
12729	2026-03-30 09:00:00	7	20.71	220	5247.1	t	2026-05-08 00:01:27.547131
12730	2026-03-30 09:30:00	1	21.28	220	3555.1	t	2026-05-08 00:01:27.547131
12731	2026-03-30 09:30:00	4	16.32	220	3886.7	t	2026-05-08 00:01:27.547131
12732	2026-03-30 09:30:00	7	25.67	220	6280.1	t	2026-05-08 00:01:27.547131
12733	2026-03-30 10:00:00	1	11.69	220	3652.8	t	2026-05-08 00:01:27.547131
12734	2026-03-30 10:00:00	4	23.39	220	4000.9	t	2026-05-08 00:01:27.547131
12735	2026-03-30 10:00:00	7	20.77	220	6631.3	t	2026-05-08 00:01:27.547131
12736	2026-03-30 10:30:00	1	17.71	220	4581.6	t	2026-05-08 00:01:27.547131
12737	2026-03-30 10:30:00	4	24.56	220	3895.5	t	2026-05-08 00:01:27.547131
12738	2026-03-30 10:30:00	7	22.11	220	4893.3	t	2026-05-08 00:01:27.547131
12739	2026-03-30 11:00:00	1	12.21	220	4579.3	t	2026-05-08 00:01:27.547131
12740	2026-03-30 11:00:00	4	16.97	220	4350.4	t	2026-05-08 00:01:27.547131
12741	2026-03-30 11:00:00	7	28.16	220	4967	t	2026-05-08 00:01:27.547131
12742	2026-03-30 11:30:00	1	13.77	220	3003.2	t	2026-05-08 00:01:27.547131
12743	2026-03-30 11:30:00	4	16.12	220	5199.1	t	2026-05-08 00:01:27.547131
12744	2026-03-30 11:30:00	7	21.48	220	6349.3	t	2026-05-08 00:01:27.547131
12745	2026-03-30 12:00:00	1	18.56	220	3561.3	t	2026-05-08 00:01:27.547131
12746	2026-03-30 12:00:00	4	16.24	220	3986.6	t	2026-05-08 00:01:27.547131
12747	2026-03-30 12:00:00	7	28.33	220	5367.3	t	2026-05-08 00:01:27.547131
12748	2026-03-30 12:30:00	1	14.89	220	4637.5	t	2026-05-08 00:01:27.547131
12749	2026-03-30 12:30:00	4	23.65	220	4045	t	2026-05-08 00:01:27.547131
12750	2026-03-30 12:30:00	7	27.94	220	5096.2	t	2026-05-08 00:01:27.547131
12751	2026-03-30 13:00:00	1	20.13	220	3588.3	t	2026-05-08 00:01:27.547131
12752	2026-03-30 13:00:00	4	17.23	220	4296.1	t	2026-05-08 00:01:27.547131
12753	2026-03-30 13:00:00	7	29.71	220	5266.7	t	2026-05-08 00:01:27.547131
12754	2026-03-30 13:30:00	1	19.07	220	2976.1	t	2026-05-08 00:01:27.547131
12755	2026-03-30 13:30:00	4	19.46	220	4158.3	t	2026-05-08 00:01:27.547131
12756	2026-03-30 13:30:00	7	24.91	220	5391.7	t	2026-05-08 00:01:27.547131
12757	2026-03-30 14:00:00	1	19.04	220	2860	t	2026-05-08 00:01:27.547131
12758	2026-03-30 14:00:00	4	16.54	220	4929.6	t	2026-05-08 00:01:27.547131
12759	2026-03-30 14:00:00	7	28.39	220	6140.5	t	2026-05-08 00:01:27.547131
12760	2026-03-30 14:30:00	1	20.5	220	4081	t	2026-05-08 00:01:27.547131
12761	2026-03-30 14:30:00	4	23.78	220	4310.4	t	2026-05-08 00:01:27.547131
12762	2026-03-30 14:30:00	7	23.54	220	6018.5	t	2026-05-08 00:01:27.547131
12763	2026-03-30 15:00:00	1	16.61	220	3137.4	t	2026-05-08 00:01:27.547131
12764	2026-03-30 15:00:00	4	19.91	220	5666.9	t	2026-05-08 00:01:27.547131
12765	2026-03-30 15:00:00	7	29.87	220	5224.6	t	2026-05-08 00:01:27.547131
12766	2026-03-30 15:30:00	1	15.06	220	3366.7	t	2026-05-08 00:01:27.547131
12767	2026-03-30 15:30:00	4	19.26	220	4695	t	2026-05-08 00:01:27.547131
12768	2026-03-30 15:30:00	7	29.24	220	5837.7	t	2026-05-08 00:01:27.547131
12769	2026-03-30 16:00:00	1	15.77	220	3439.2	t	2026-05-08 00:01:27.547131
12770	2026-03-30 16:00:00	4	19.51	220	3539.1	t	2026-05-08 00:01:27.547131
12771	2026-03-30 16:00:00	7	23.23	220	5679.4	t	2026-05-08 00:01:27.547131
12772	2026-03-30 16:30:00	1	21.29	220	2608.3	t	2026-05-08 00:01:27.547131
12773	2026-03-30 16:30:00	4	24.43	220	3900.9	t	2026-05-08 00:01:27.547131
12774	2026-03-30 16:30:00	7	26.72	220	6328.2	t	2026-05-08 00:01:27.547131
12775	2026-03-30 17:00:00	1	16.36	220	3639.5	t	2026-05-08 00:01:27.547131
12776	2026-03-30 17:00:00	4	16.28	220	5582.9	t	2026-05-08 00:01:27.547131
12777	2026-03-30 17:00:00	7	20.57	220	5586.6	t	2026-05-08 00:01:27.547131
12778	2026-03-30 17:30:00	1	18.76	220	4412.8	t	2026-05-08 00:01:27.547131
12779	2026-03-30 17:30:00	4	18.26	220	5261.3	t	2026-05-08 00:01:27.547131
12780	2026-03-30 17:30:00	7	26.26	220	4920.8	t	2026-05-08 00:01:27.547131
12781	2026-03-30 18:00:00	1	11.56	220	3764.5	t	2026-05-08 00:01:27.547131
12782	2026-03-30 18:00:00	4	16.87	220	5399.9	t	2026-05-08 00:01:27.547131
12783	2026-03-30 18:00:00	7	24.85	220	5237.5	t	2026-05-08 00:01:27.547131
12784	2026-03-30 18:30:00	1	17.15	220	4165.1	t	2026-05-08 00:01:27.547131
12785	2026-03-30 18:30:00	4	17.78	220	3926	t	2026-05-08 00:01:27.547131
12786	2026-03-30 18:30:00	7	29.02	220	4881.2	t	2026-05-08 00:01:27.547131
12787	2026-03-30 19:00:00	1	13.49	220	3262.2	t	2026-05-08 00:01:27.547131
12788	2026-03-30 19:00:00	4	22.34	220	4781.7	t	2026-05-08 00:01:27.547131
12789	2026-03-30 19:00:00	7	21.55	220	6189	t	2026-05-08 00:01:27.547131
12790	2026-03-30 19:30:00	1	15.81	220	2762	t	2026-05-08 00:01:27.547131
12791	2026-03-30 19:30:00	4	23.04	220	4583	t	2026-05-08 00:01:27.547131
12792	2026-03-30 19:30:00	7	27.91	220	5770.4	t	2026-05-08 00:01:27.547131
12793	2026-03-30 20:00:00	1	3.34	220	531.4	t	2026-05-08 00:01:27.547131
12794	2026-03-30 20:00:00	4	2.94	220	404.6	t	2026-05-08 00:01:27.547131
12795	2026-03-30 20:00:00	7	2.18	220	475.8	t	2026-05-08 00:01:27.547131
12796	2026-03-30 20:30:00	1	1.67	220	353.3	t	2026-05-08 00:01:27.547131
12797	2026-03-30 20:30:00	4	3.55	220	675.8	t	2026-05-08 00:01:27.547131
12798	2026-03-30 20:30:00	7	2.93	220	372.3	t	2026-05-08 00:01:27.547131
12799	2026-03-30 21:00:00	1	2	220	354.5	t	2026-05-08 00:01:27.547131
12800	2026-03-30 21:00:00	4	1.33	220	372	t	2026-05-08 00:01:27.547131
12801	2026-03-30 21:00:00	7	2.23	220	334.1	t	2026-05-08 00:01:27.547131
12802	2026-03-30 21:30:00	1	1.58	220	328.1	t	2026-05-08 00:01:27.547131
12803	2026-03-30 21:30:00	4	1.57	220	771.2	t	2026-05-08 00:01:27.547131
12804	2026-03-30 21:30:00	7	1.71	220	593.4	t	2026-05-08 00:01:27.547131
12805	2026-03-30 22:00:00	1	2.73	220	345	t	2026-05-08 00:01:27.547131
12806	2026-03-30 22:00:00	4	1.61	220	306.1	t	2026-05-08 00:01:27.547131
12807	2026-03-30 22:00:00	7	3.14	220	440.4	t	2026-05-08 00:01:27.547131
12808	2026-03-30 22:30:00	1	1.23	220	593.1	t	2026-05-08 00:01:27.547131
12809	2026-03-30 22:30:00	4	3.53	220	445.3	t	2026-05-08 00:01:27.547131
12810	2026-03-30 22:30:00	7	2.37	220	692.7	t	2026-05-08 00:01:27.547131
12811	2026-03-30 23:00:00	1	2.04	220	767	t	2026-05-08 00:01:27.547131
12812	2026-03-30 23:00:00	4	3.14	220	331.7	t	2026-05-08 00:01:27.547131
12813	2026-03-30 23:00:00	7	2.6	220	596.9	t	2026-05-08 00:01:27.547131
12814	2026-03-30 23:30:00	1	2.1	220	375	t	2026-05-08 00:01:27.547131
12815	2026-03-30 23:30:00	4	2.88	220	330	t	2026-05-08 00:01:27.547131
12816	2026-03-30 23:30:00	7	2	220	352.9	t	2026-05-08 00:01:27.547131
12817	2026-03-31 00:00:00	1	2.26	220	487.3	t	2026-05-08 00:01:27.547131
12818	2026-03-31 00:00:00	4	2.4	220	478.5	t	2026-05-08 00:01:27.547131
12819	2026-03-31 00:00:00	7	3.51	220	372.8	t	2026-05-08 00:01:27.547131
12820	2026-03-31 00:30:00	1	2.93	220	575.7	t	2026-05-08 00:01:27.547131
12821	2026-03-31 00:30:00	4	2.16	220	320.3	t	2026-05-08 00:01:27.547131
12822	2026-03-31 00:30:00	7	1.8	220	290.6	t	2026-05-08 00:01:27.547131
12823	2026-03-31 01:00:00	1	3.68	220	280.1	t	2026-05-08 00:01:27.547131
12824	2026-03-31 01:00:00	4	2.99	220	701	t	2026-05-08 00:01:27.547131
12825	2026-03-31 01:00:00	7	3.5	220	666	t	2026-05-08 00:01:27.547131
12826	2026-03-31 01:30:00	1	3.6	220	578.9	t	2026-05-08 00:01:27.547131
12827	2026-03-31 01:30:00	4	1.61	220	786.9	t	2026-05-08 00:01:27.547131
12828	2026-03-31 01:30:00	7	1.8	220	481.3	t	2026-05-08 00:01:27.547131
12829	2026-03-31 02:00:00	1	3.66	220	363.7	t	2026-05-08 00:01:27.547131
12830	2026-03-31 02:00:00	4	1.57	220	307	t	2026-05-08 00:01:27.547131
12831	2026-03-31 02:00:00	7	1.45	220	582.7	t	2026-05-08 00:01:27.547131
12832	2026-03-31 02:30:00	1	2.14	220	761.6	t	2026-05-08 00:01:27.547131
12833	2026-03-31 02:30:00	4	1.87	220	570.5	t	2026-05-08 00:01:27.547131
12834	2026-03-31 02:30:00	7	2.6	220	418.5	t	2026-05-08 00:01:27.547131
12835	2026-03-31 03:00:00	1	2.54	220	651.2	t	2026-05-08 00:01:27.547131
12836	2026-03-31 03:00:00	4	2.88	220	317.5	t	2026-05-08 00:01:27.547131
12837	2026-03-31 03:00:00	7	3.18	220	717.1	t	2026-05-08 00:01:27.547131
12838	2026-03-31 03:30:00	1	3.18	220	625	t	2026-05-08 00:01:27.547131
12839	2026-03-31 03:30:00	4	3.29	220	562.2	t	2026-05-08 00:01:27.547131
12840	2026-03-31 03:30:00	7	2.71	220	547.9	t	2026-05-08 00:01:27.547131
12841	2026-03-31 04:00:00	1	3.16	220	735.6	t	2026-05-08 00:01:27.547131
12842	2026-03-31 04:00:00	4	2.7	220	412.6	t	2026-05-08 00:01:27.547131
12843	2026-03-31 04:00:00	7	3.11	220	381.5	t	2026-05-08 00:01:27.547131
12844	2026-03-31 04:30:00	1	3.37	220	354.3	t	2026-05-08 00:01:27.547131
12845	2026-03-31 04:30:00	4	1.2	220	577.9	t	2026-05-08 00:01:27.547131
12846	2026-03-31 04:30:00	7	1.99	220	296.5	t	2026-05-08 00:01:27.547131
12847	2026-03-31 05:00:00	1	1.97	220	650.3	t	2026-05-08 00:01:27.547131
12848	2026-03-31 05:00:00	4	1.76	220	437.3	t	2026-05-08 00:01:27.547131
12849	2026-03-31 05:00:00	7	1.62	220	389.8	t	2026-05-08 00:01:27.547131
12850	2026-03-31 05:30:00	1	1.49	220	781.2	t	2026-05-08 00:01:27.547131
12851	2026-03-31 05:30:00	4	3.23	220	458.8	t	2026-05-08 00:01:27.547131
12852	2026-03-31 05:30:00	7	2.57	220	532.7	t	2026-05-08 00:01:27.547131
12853	2026-03-31 06:00:00	1	3.47	220	473.5	t	2026-05-08 00:01:27.547131
12854	2026-03-31 06:00:00	4	2.55	220	545.3	t	2026-05-08 00:01:27.547131
12855	2026-03-31 06:00:00	7	2.32	220	339.6	t	2026-05-08 00:01:27.547131
12856	2026-03-31 06:30:00	1	2.92	220	362.9	t	2026-05-08 00:01:27.547131
12857	2026-03-31 06:30:00	4	2.14	220	446.1	t	2026-05-08 00:01:27.547131
12858	2026-03-31 06:30:00	7	2.01	220	808.1	t	2026-05-08 00:01:27.547131
12859	2026-03-31 07:00:00	1	15.23	220	2976.2	t	2026-05-08 00:01:27.547131
12860	2026-03-31 07:00:00	4	23.08	220	5581.8	t	2026-05-08 00:01:27.547131
12861	2026-03-31 07:00:00	7	26.98	220	5055.6	t	2026-05-08 00:01:27.547131
12862	2026-03-31 07:30:00	1	14.2	220	4446	t	2026-05-08 00:01:27.547131
12863	2026-03-31 07:30:00	4	25.01	220	3883.9	t	2026-05-08 00:01:27.547131
12864	2026-03-31 07:30:00	7	27.01	220	5217.9	t	2026-05-08 00:01:27.547131
12865	2026-03-31 08:00:00	1	15.47	220	3642	t	2026-05-08 00:01:27.547131
12866	2026-03-31 08:00:00	4	16.71	220	5321.2	t	2026-05-08 00:01:27.547131
12867	2026-03-31 08:00:00	7	27.96	220	4628.6	t	2026-05-08 00:01:27.547131
12868	2026-03-31 08:30:00	1	18.18	220	3379.5	t	2026-05-08 00:01:27.547131
12869	2026-03-31 08:30:00	4	21.57	220	4790.1	t	2026-05-08 00:01:27.547131
12870	2026-03-31 08:30:00	7	24.88	220	5504.4	t	2026-05-08 00:01:27.547131
12871	2026-03-31 09:00:00	1	17.18	220	3883.8	t	2026-05-08 00:01:27.547131
12872	2026-03-31 09:00:00	4	16.32	220	5706.4	t	2026-05-08 00:01:27.547131
12873	2026-03-31 09:00:00	7	27.91	220	5472.4	t	2026-05-08 00:01:27.547131
12874	2026-03-31 09:30:00	1	16.57	220	4623.3	t	2026-05-08 00:01:27.547131
12875	2026-03-31 09:30:00	4	16.64	220	4279.1	t	2026-05-08 00:01:27.547131
12876	2026-03-31 09:30:00	7	26.7	220	4609.9	t	2026-05-08 00:01:27.547131
12877	2026-03-31 10:00:00	1	19.16	220	4563.9	t	2026-05-08 00:01:27.547131
12878	2026-03-31 10:00:00	4	23.73	220	4139.9	t	2026-05-08 00:01:27.547131
12879	2026-03-31 10:00:00	7	24.92	220	6232.9	t	2026-05-08 00:01:27.547131
12880	2026-03-31 10:30:00	1	13.89	220	4453.6	t	2026-05-08 00:01:27.547131
12881	2026-03-31 10:30:00	4	17.43	220	3586.4	t	2026-05-08 00:01:27.547131
12882	2026-03-31 10:30:00	7	30.37	220	5193.9	t	2026-05-08 00:01:27.547131
12883	2026-03-31 11:00:00	1	14.49	220	3366.8	t	2026-05-08 00:01:27.547131
12884	2026-03-31 11:00:00	4	22.85	220	4479.5	t	2026-05-08 00:01:27.547131
12885	2026-03-31 11:00:00	7	24.62	220	5331	t	2026-05-08 00:01:27.547131
12886	2026-03-31 11:30:00	1	13.48	220	3649	t	2026-05-08 00:01:27.547131
12887	2026-03-31 11:30:00	4	16.79	220	4769.7	t	2026-05-08 00:01:27.547131
12888	2026-03-31 11:30:00	7	26.3	220	5727.8	t	2026-05-08 00:01:27.547131
12889	2026-03-31 12:00:00	1	20.05	220	3224.7	t	2026-05-08 00:01:27.547131
12890	2026-03-31 12:00:00	4	21.26	220	5709.1	t	2026-05-08 00:01:27.547131
12891	2026-03-31 12:00:00	7	22	220	6176	t	2026-05-08 00:01:27.547131
12892	2026-03-31 12:30:00	1	15.13	220	4376.9	t	2026-05-08 00:01:27.547131
12893	2026-03-31 12:30:00	4	20.99	220	4042.2	t	2026-05-08 00:01:27.547131
12894	2026-03-31 12:30:00	7	25.87	220	4706.2	t	2026-05-08 00:01:27.547131
12895	2026-03-31 13:00:00	1	12.21	220	4364.3	t	2026-05-08 00:01:27.547131
12896	2026-03-31 13:00:00	4	16.23	220	3716.2	t	2026-05-08 00:01:27.547131
12897	2026-03-31 13:00:00	7	25.22	220	6539.3	t	2026-05-08 00:01:27.547131
12898	2026-03-31 13:30:00	1	14.76	220	2573.9	t	2026-05-08 00:01:27.547131
12899	2026-03-31 13:30:00	4	23.32	220	4962.6	t	2026-05-08 00:01:27.547131
12900	2026-03-31 13:30:00	7	23.18	220	4789.8	t	2026-05-08 00:01:27.547131
12901	2026-03-31 14:00:00	1	19.47	220	3101.2	t	2026-05-08 00:01:27.547131
12902	2026-03-31 14:00:00	4	25.29	220	4390.7	t	2026-05-08 00:01:27.547131
12903	2026-03-31 14:00:00	7	23.46	220	5019.6	t	2026-05-08 00:01:27.547131
12904	2026-03-31 14:30:00	1	18.42	220	2918	t	2026-05-08 00:01:27.547131
12905	2026-03-31 14:30:00	4	24.2	220	5189.2	t	2026-05-08 00:01:27.547131
12906	2026-03-31 14:30:00	7	26.15	220	6527.3	t	2026-05-08 00:01:27.547131
12907	2026-03-31 15:00:00	1	12.77	220	3046.2	t	2026-05-08 00:01:27.547131
12908	2026-03-31 15:00:00	4	20.7	220	3911.2	t	2026-05-08 00:01:27.547131
12909	2026-03-31 15:00:00	7	27.48	220	6423.2	t	2026-05-08 00:01:27.547131
12910	2026-03-31 15:30:00	1	16.98	220	2692.7	t	2026-05-08 00:01:27.547131
12911	2026-03-31 15:30:00	4	23.37	220	5287.7	t	2026-05-08 00:01:27.547131
12912	2026-03-31 15:30:00	7	28.48	220	6616.9	t	2026-05-08 00:01:27.547131
12913	2026-03-31 16:00:00	1	20.36	220	4162.8	t	2026-05-08 00:01:27.547131
12914	2026-03-31 16:00:00	4	23.65	220	3601.4	t	2026-05-08 00:01:27.547131
12915	2026-03-31 16:00:00	7	23.14	220	4858.8	t	2026-05-08 00:01:27.547131
12916	2026-03-31 16:30:00	1	16.68	220	4326	t	2026-05-08 00:01:27.547131
12917	2026-03-31 16:30:00	4	18.05	220	4381.5	t	2026-05-08 00:01:27.547131
12918	2026-03-31 16:30:00	7	23.12	220	5601.8	t	2026-05-08 00:01:27.547131
12919	2026-03-31 17:00:00	1	19.65	220	3979.9	t	2026-05-08 00:01:27.547131
12920	2026-03-31 17:00:00	4	16.74	220	5160.8	t	2026-05-08 00:01:27.547131
12921	2026-03-31 17:00:00	7	24.33	220	5052.6	t	2026-05-08 00:01:27.547131
12922	2026-03-31 17:30:00	1	14.59	220	4589	t	2026-05-08 00:01:27.547131
12923	2026-03-31 17:30:00	4	25.27	220	5322.6	t	2026-05-08 00:01:27.547131
12924	2026-03-31 17:30:00	7	24.76	220	4649.3	t	2026-05-08 00:01:27.547131
12925	2026-03-31 18:00:00	1	17.48	220	4423	t	2026-05-08 00:01:27.547131
12926	2026-03-31 18:00:00	4	24.68	220	4230.7	t	2026-05-08 00:01:27.547131
12927	2026-03-31 18:00:00	7	30.18	220	6625.8	t	2026-05-08 00:01:27.547131
12928	2026-03-31 18:30:00	1	19.06	220	3517.7	t	2026-05-08 00:01:27.547131
12929	2026-03-31 18:30:00	4	16.11	220	3658.3	t	2026-05-08 00:01:27.547131
12930	2026-03-31 18:30:00	7	28.2	220	6536.4	t	2026-05-08 00:01:27.547131
12931	2026-03-31 19:00:00	1	20.45	220	4610	t	2026-05-08 00:01:27.547131
12932	2026-03-31 19:00:00	4	21.35	220	4742.9	t	2026-05-08 00:01:27.547131
12933	2026-03-31 19:00:00	7	30.04	220	5323.7	t	2026-05-08 00:01:27.547131
12934	2026-03-31 19:30:00	1	17.41	220	4023.9	t	2026-05-08 00:01:27.547131
12935	2026-03-31 19:30:00	4	20.85	220	4957.8	t	2026-05-08 00:01:27.547131
12936	2026-03-31 19:30:00	7	21.04	220	5307.9	t	2026-05-08 00:01:27.547131
12937	2026-03-31 20:00:00	1	2.04	220	636	t	2026-05-08 00:01:27.547131
12938	2026-03-31 20:00:00	4	2.41	220	809	t	2026-05-08 00:01:27.547131
12939	2026-03-31 20:00:00	7	3.69	220	340.2	t	2026-05-08 00:01:27.547131
12940	2026-03-31 20:30:00	1	2.01	220	610	t	2026-05-08 00:01:27.547131
12941	2026-03-31 20:30:00	4	2.96	220	664.1	t	2026-05-08 00:01:27.547131
12942	2026-03-31 20:30:00	7	2.36	220	400.3	t	2026-05-08 00:01:27.547131
12943	2026-03-31 21:00:00	1	1.9	220	765.9	t	2026-05-08 00:01:27.547131
12944	2026-03-31 21:00:00	4	2.91	220	587.7	t	2026-05-08 00:01:27.547131
12945	2026-03-31 21:00:00	7	2.47	220	784.4	t	2026-05-08 00:01:27.547131
12946	2026-03-31 21:30:00	1	1.72	220	346.4	t	2026-05-08 00:01:27.547131
12947	2026-03-31 21:30:00	4	3.58	220	308.1	t	2026-05-08 00:01:27.547131
12948	2026-03-31 21:30:00	7	2.44	220	406.1	t	2026-05-08 00:01:27.547131
12949	2026-03-31 22:00:00	1	1.87	220	793.8	t	2026-05-08 00:01:27.547131
12950	2026-03-31 22:00:00	4	3.05	220	391.3	t	2026-05-08 00:01:27.547131
12951	2026-03-31 22:00:00	7	2.96	220	451.8	t	2026-05-08 00:01:27.547131
12952	2026-03-31 22:30:00	1	2.67	220	654.6	t	2026-05-08 00:01:27.547131
12953	2026-03-31 22:30:00	4	1.75	220	664.7	t	2026-05-08 00:01:27.547131
12954	2026-03-31 22:30:00	7	3.67	220	474.9	t	2026-05-08 00:01:27.547131
12955	2026-03-31 23:00:00	1	2.94	220	631.9	t	2026-05-08 00:01:27.547131
12956	2026-03-31 23:00:00	4	1.6	220	341.2	t	2026-05-08 00:01:27.547131
12957	2026-03-31 23:00:00	7	2.11	220	300.9	t	2026-05-08 00:01:27.547131
12958	2026-03-31 23:30:00	1	2.81	220	574	t	2026-05-08 00:01:27.547131
12959	2026-03-31 23:30:00	4	1.72	220	792.9	t	2026-05-08 00:01:27.547131
12960	2026-03-31 23:30:00	7	1.85	220	317.1	t	2026-05-08 00:01:27.547131
12961	2026-05-11 21:17:25	1	8.557327	11.726802	100.350075	t	2026-05-12 00:17:36.23214
12962	2026-05-11 21:17:25	2	0	0	0	f	2026-05-12 00:17:38.293689
12963	2026-05-11 21:17:25	3	7.898591	0	0	t	2026-05-12 00:17:41.470377
12964	2026-05-11 21:18:25	1	8.134543	11.619968	94.52314	t	2026-05-12 00:18:35.515307
12965	2026-05-11 21:18:25	2	0.5577042	0	0	t	2026-05-12 00:18:37.70124
12966	2026-05-11 21:18:25	3	9.451304	0	0	t	2026-05-12 00:18:39.530974
12967	2026-05-11 21:19:25	1	9.525548	12.0744505	115.01576	t	2026-05-12 00:19:37.269986
12968	2026-05-11 21:19:25	2	0.54804033	0	0	t	2026-05-12 00:19:39.308055
12969	2026-05-11 21:19:25	3	9.095015	0	0	t	2026-05-12 00:19:41.295652
12970	2026-05-11 21:20:25	1	8.970482	12.327757	110.585915	t	2026-05-12 00:20:39.159016
12971	2026-05-11 21:20:25	2	0.29483807	0	0	t	2026-05-12 00:20:42.262166
12972	2026-05-11 21:20:25	3	8.735406	0	0	t	2026-05-12 00:20:44.527591
12973	2026-05-11 21:21:25	1	8.802697	12.33911	108.61746	t	2026-05-12 00:21:34.832695
12974	2026-05-11 21:21:25	2	0.13451436	0	0	t	2026-05-12 00:21:36.509415
12975	2026-05-11 21:21:25	3	8.714701	0	0	t	2026-05-12 00:21:38.785161
12976	2026-05-11 21:22:25	1	8.585653	12.933992	111.04677	t	2026-05-12 00:22:35.879101
12977	2026-05-11 21:22:25	2	0.25896937	0	0	t	2026-05-12 00:22:37.985137
12978	2026-05-11 21:22:25	3	7.4850593	0	0	t	2026-05-12 00:22:40.384847
12979	2026-05-11 21:23:25	1	8.857084	13.255354	117.403786	t	2026-05-12 00:23:39.123694
12980	2026-05-11 21:23:25	2	0.49339333	0	0	t	2026-05-12 00:23:49.751019
12981	2026-05-11 21:23:25	3	8.168122	0	0	t	2026-05-12 00:23:52.582806
12982	2026-05-11 21:24:25	1	8.323265	11.957551	99.52586	t	2026-05-12 00:24:35.878349
12983	2026-05-11 21:31:54	1	183.20259	384.2944	70403.73	t	2026-05-12 00:31:56.126531
12984	2026-05-11 21:36:54	1	9.036039	10.953943	98.98026	t	2026-05-12 00:36:56.627944
12985	2026-05-11 21:37:54	1	10.125015	11.09823	112.36976	t	2026-05-12 00:37:55.856907
12986	2026-05-11 21:39:34	1	74.45641	647.0563	48177.49	f	2026-05-12 00:39:36.513606
12987	2026-05-11 21:40:34	1	10.248461	570.69696	5848.765	f	2026-05-12 00:40:36.016414
12988	2026-05-11 21:41:34	1	10.180916	570.5408	5808.628	f	2026-05-12 00:41:36.736343
12989	2026-05-12 20:33:20	1	7.6334558	0	0	f	2026-05-12 23:33:21.865366
12990	2026-05-12 20:34:19	1	7.6872897	0	0	f	2026-05-12 23:34:22.756976
12991	2026-05-12 20:37:18	1	7.215332	0	0	f	2026-05-12 23:37:22.270909
12992	2026-05-12 20:38:18	1	6.9815183	0	0	f	2026-05-12 23:38:22.863943
12993	2026-05-12 20:40:19	1	7.358391	0	0	f	2026-05-12 23:40:21.92182
12994	2026-05-12 20:41:18	1	7.683865	0	0	f	2026-05-12 23:41:21.417854
12995	2026-05-12 20:42:18	1	8.028645	0	0	f	2026-05-12 23:42:20.902201
12996	2026-05-12 20:43:19	1	7.819814	0	0	f	2026-05-12 23:43:22.35122
12997	2026-05-12 20:44:19	1	7.7757893	0	0	f	2026-05-12 23:44:22.165589
12998	2026-05-12 20:45:19	1	7.4981875	0	0	f	2026-05-12 23:45:21.544396
12999	2026-05-12 20:46:19	1	7.9091096	0	0	f	2026-05-12 23:46:22.701696
13000	2026-05-12 20:47:19	1	7.5932336	0	0	f	2026-05-12 23:47:22.433629
13001	2026-05-12 21:25:54	1	10.39809	179.65738	1868.0936	t	2026-05-13 00:25:57.491576
13002	2026-05-12 21:26:54	1	8.555433	179.83752	1538.588	t	2026-05-13 00:27:00.104321
13003	2026-05-12 21:28:53	1	17.13736	203.32948	3484.5303	t	2026-05-13 00:28:55.691197
13004	2026-05-12 21:29:54	1	12.389047	202.89723	2513.7031	t	2026-05-13 00:29:56.965476
13005	2026-05-12 21:30:53	1	8.657943	202.78308	1755.6842	t	2026-05-13 00:30:55.466269
13006	2026-05-12 21:31:54	1	8.9344635	202.57011	1809.8553	t	2026-05-13 00:31:56.424758
13007	2026-05-12 21:33:54	1	8.714317	202.75224	1766.8475	t	2026-05-13 00:33:58.417422
13008	2026-05-12 21:34:53	1	9.1747875	202.62491	1859.0405	t	2026-05-13 00:34:55.627897
13009	2026-05-12 21:40:51	1	9.8324995	247.69992	2435.5093	t	2026-05-13 00:40:53.40577
13010	2026-05-12 20:26:51	1	169.827	0	0	f	2026-05-13 00:40:55.567651
13011	2026-05-12 20:27:51	1	8.1159	0	0	f	2026-05-13 00:40:59.36085
13012	2026-05-12 20:28:53	1	7.5402	0	0	f	2026-05-13 00:41:04.013533
13013	2026-05-12 20:29:53	1	7.3583	0	0	f	2026-05-13 00:41:06.827795
13014	2026-05-12 20:31:18	1	7.2864	0	0	f	2026-05-13 00:41:09.866877
13015	2026-05-12 21:39:53	1	73.1805	279.64	20464.387	f	2026-05-13 00:41:13.285502
13016	2026-05-12 21:41:53	1	8.945418	248.37468	2221.8154	t	2026-05-13 00:41:54.605093
13017	2026-05-12 21:44:53	1	8.61621	248.38535	2140.1401	t	2026-05-13 00:44:55.478828
13018	2026-05-12 21:42:51	1	9.1868	248.48	2282.753	t	2026-05-13 00:44:57.405109
13019	2026-05-12 21:43:53	1	8.4137	248.78	2093.1152	t	2026-05-13 00:44:59.575241
13020	2026-05-12 21:45:53	1	8.834445	248.76935	2197.7393	t	2026-05-13 00:45:55.370199
13021	2026-05-12 21:46:53	1	8.11665	248.31816	2015.5116	t	2026-05-13 00:46:55.419405
13022	2026-05-12 21:47:53	1	8.739229	248.58249	2172.4194	t	2026-05-13 00:47:55.005148
13023	2026-05-12 21:50:09	1	106.48156	274.90637	29272.46	f	2026-05-13 00:50:11.233097
13024	2026-05-12 21:52:10	1	7.948476	215.80498	1715.3207	t	2026-05-13 00:52:13.043352
13025	2026-05-12 21:53:10	1	8.023692	215.8103	1731.5955	t	2026-05-13 00:53:12.3601
13026	2026-05-12 21:54:10	1	8.087536	215.67764	1744.3005	t	2026-05-13 00:54:12.653839
13027	2026-05-12 21:55:09	1	12.95819	133.75537	1733.2274	f	2026-05-13 00:55:11.812328
13028	2026-05-12 21:56:10	1	12.6223	216.59785	2733.9634	t	2026-05-13 00:56:11.813829
13029	2026-05-12 21:57:10	1	7.821441	216.11644	1690.342	t	2026-05-13 00:57:12.430149
13030	2026-05-12 21:58:34	1	86.539925	295.47388	25570.287	f	2026-05-13 00:58:36.51105
13031	2026-05-12 21:59:34	1	8.047358	248.08841	1996.4562	t	2026-05-13 00:59:36.637088
13032	2026-05-12 21:51:10	1	8.2593	215.37	1778.8086	t	2026-05-13 00:59:38.367538
13033	2026-05-12 22:00:34	1	7.847414	248.82521	1952.6345	t	2026-05-13 01:00:36.651153
13034	2026-05-12 22:01:33	1	8.289462	248.74268	2061.943	t	2026-05-13 01:01:36.216427
13035	2026-05-12 22:02:33	1	8.208486	248.64996	2041.0397	t	2026-05-13 01:02:35.626893
13036	2026-05-12 22:07:03	1	108.51792	317.6898	34475.03	f	2026-05-13 01:07:06.77126
\.


--
-- Data for Name: metas; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.metas (id, local_id, quadro_id, descricao, kwh_baseline, kwh_meta, data_inicio, data_fim, criado_em) FROM stdin;
1	2	1	Reducao 10% Terreo ADM Q1/26	1200	1080	2026-01-01	2026-03-31	2026-05-08 00:01:31.351496
2	3	2	Reducao 15% 1 Andar ADM Q1/26	980	833	2026-01-01	2026-03-31	2026-05-08 00:01:31.351496
3	4	3	Reducao 20% 2 Andar TI Q1/26	1100	880	2026-01-01	2026-03-31	2026-05-08 00:01:31.351496
\.


--
-- Data for Name: quadros; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.quadros (id, nome, local_id, area_id, quadro_pai_id, descricao) FROM stdin;
1	QLT-307	2	1	\N	Quadro principal - Terreo ADM
2	QLT-301	3	2	1	Quadro - 1 Andar ADM
3	QLT-302	4	3	1	Quadro - 2 Andar / Reitoria
\.


--
-- Data for Name: rateio; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.rateio (id, fatura_id, area_id, kwh, percentual, valor_rs, gerado_em) FROM stdin;
1	3	1	1258.7	0.72	893.51	2026-05-08 00:01:30.908358
2	3	2	1548.89	0.89	1099.5	2026-05-08 00:01:30.908358
3	3	3	1821.55	1.04	1293.05	2026-05-08 00:01:30.908358
\.


--
-- Data for Name: tarifas; Type: TABLE DATA; Schema: public; Owner: julya
--

COPY public.tarifas (id, local_id, valor_kwh, vigencia, descricao, criado_em) FROM stdin;
\.


--
-- Name: alertas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.alertas_id_seq', 17, true);


--
-- Name: areas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.areas_id_seq', 3, true);


--
-- Name: canais_medicao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.canais_medicao_id_seq', 9, true);


--
-- Name: consumo_diario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.consumo_diario_id_seq', 270, true);


--
-- Name: dispositivos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.dispositivos_id_seq', 9, true);


--
-- Name: dispositivos_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.dispositivos_status_id_seq', 9, true);


--
-- Name: enel_instalacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.enel_instalacoes_id_seq', 1, false);


--
-- Name: fatura_itens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.fatura_itens_id_seq', 1, false);


--
-- Name: faturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.faturas_id_seq', 3, true);


--
-- Name: faturas_ocr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.faturas_ocr_id_seq', 1, false);


--
-- Name: locais_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.locais_id_seq', 4, true);


--
-- Name: medicoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.medicoes_id_seq', 13037, true);


--
-- Name: metas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.metas_id_seq', 3, true);


--
-- Name: quadros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.quadros_id_seq', 3, true);


--
-- Name: rateio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.rateio_id_seq', 3, true);


--
-- Name: tarifas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: julya
--

SELECT pg_catalog.setval('public.tarifas_id_seq', 4, true);


--
-- Name: alertas alertas_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_pkey PRIMARY KEY (id);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: canais_medicao canais_medicao_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.canais_medicao
    ADD CONSTRAINT canais_medicao_pkey PRIMARY KEY (id);


--
-- Name: consumo_diario consumo_diario_canal_id_data_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.consumo_diario
    ADD CONSTRAINT consumo_diario_canal_id_data_key UNIQUE (canal_id, data);


--
-- Name: consumo_diario consumo_diario_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.consumo_diario
    ADD CONSTRAINT consumo_diario_pkey PRIMARY KEY (id);


--
-- Name: dispositivos dispositivos_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos
    ADD CONSTRAINT dispositivos_pkey PRIMARY KEY (id);


--
-- Name: dispositivos_status dispositivos_status_dispositivo_id_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos_status
    ADD CONSTRAINT dispositivos_status_dispositivo_id_key UNIQUE (dispositivo_id);


--
-- Name: dispositivos_status dispositivos_status_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos_status
    ADD CONSTRAINT dispositivos_status_pkey PRIMARY KEY (id);


--
-- Name: enel_instalacoes enel_instalacoes_local_id_numero_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.enel_instalacoes
    ADD CONSTRAINT enel_instalacoes_local_id_numero_key UNIQUE (local_id, numero);


--
-- Name: enel_instalacoes enel_instalacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.enel_instalacoes
    ADD CONSTRAINT enel_instalacoes_pkey PRIMARY KEY (id);


--
-- Name: fatura_itens fatura_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.fatura_itens
    ADD CONSTRAINT fatura_itens_pkey PRIMARY KEY (id);


--
-- Name: faturas faturas_local_id_mes_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas
    ADD CONSTRAINT faturas_local_id_mes_key UNIQUE (local_id, mes);


--
-- Name: faturas_ocr faturas_ocr_fatura_id_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas_ocr
    ADD CONSTRAINT faturas_ocr_fatura_id_key UNIQUE (fatura_id);


--
-- Name: faturas_ocr faturas_ocr_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas_ocr
    ADD CONSTRAINT faturas_ocr_pkey PRIMARY KEY (id);


--
-- Name: faturas faturas_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas
    ADD CONSTRAINT faturas_pkey PRIMARY KEY (id);


--
-- Name: locais locais_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.locais
    ADD CONSTRAINT locais_pkey PRIMARY KEY (id);


--
-- Name: medicoes medicoes_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.medicoes
    ADD CONSTRAINT medicoes_pkey PRIMARY KEY (id);


--
-- Name: metas metas_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.metas
    ADD CONSTRAINT metas_pkey PRIMARY KEY (id);


--
-- Name: quadros quadros_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.quadros
    ADD CONSTRAINT quadros_pkey PRIMARY KEY (id);


--
-- Name: rateio rateio_fatura_id_area_id_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.rateio
    ADD CONSTRAINT rateio_fatura_id_area_id_key UNIQUE (fatura_id, area_id);


--
-- Name: rateio rateio_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.rateio
    ADD CONSTRAINT rateio_pkey PRIMARY KEY (id);


--
-- Name: tarifas tarifas_local_id_vigencia_key; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.tarifas
    ADD CONSTRAINT tarifas_local_id_vigencia_key UNIQUE (local_id, vigencia);


--
-- Name: tarifas tarifas_pkey; Type: CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.tarifas
    ADD CONSTRAINT tarifas_pkey PRIMARY KEY (id);


--
-- Name: idx_alertas_timestamp; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_alertas_timestamp ON public.alertas USING btree ("timestamp");


--
-- Name: idx_consumo_diario_data; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_consumo_diario_data ON public.consumo_diario USING btree (canal_id, data);


--
-- Name: idx_enel_inst_local; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_enel_inst_local ON public.enel_instalacoes USING btree (local_id);


--
-- Name: idx_fatura_itens_fatura; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_fatura_itens_fatura ON public.fatura_itens USING btree (fatura_id);


--
-- Name: idx_faturas_ocr_fatura; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_faturas_ocr_fatura ON public.faturas_ocr USING btree (fatura_id);


--
-- Name: idx_faturas_status; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_faturas_status ON public.faturas USING btree (status);


--
-- Name: idx_faturas_vencimento; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_faturas_vencimento ON public.faturas USING btree (vencimento);


--
-- Name: idx_medicoes_canal; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_medicoes_canal ON public.medicoes USING btree (canal_id);


--
-- Name: idx_medicoes_timestamp; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_medicoes_timestamp ON public.medicoes USING btree ("timestamp");


--
-- Name: idx_tarifas_local; Type: INDEX; Schema: public; Owner: julya
--

CREATE INDEX idx_tarifas_local ON public.tarifas USING btree (local_id, vigencia);


--
-- Name: enel_instalacoes trg_enel_inst_atualizado_em; Type: TRIGGER; Schema: public; Owner: julya
--

CREATE TRIGGER trg_enel_inst_atualizado_em BEFORE UPDATE ON public.enel_instalacoes FOR EACH ROW EXECUTE FUNCTION public.set_atualizado_em();


--
-- Name: faturas trg_faturas_atualizado_em; Type: TRIGGER; Schema: public; Owner: julya
--

CREATE TRIGGER trg_faturas_atualizado_em BEFORE UPDATE ON public.faturas FOR EACH ROW EXECUTE FUNCTION public.set_atualizado_em();


--
-- Name: faturas_ocr trg_faturas_ocr_atualizado_em; Type: TRIGGER; Schema: public; Owner: julya
--

CREATE TRIGGER trg_faturas_ocr_atualizado_em BEFORE UPDATE ON public.faturas_ocr FOR EACH ROW EXECUTE FUNCTION public.set_atualizado_em();


--
-- Name: alertas alertas_canal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_canal_id_fkey FOREIGN KEY (canal_id) REFERENCES public.canais_medicao(id);


--
-- Name: areas areas_local_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_local_id_fkey FOREIGN KEY (local_id) REFERENCES public.locais(id);


--
-- Name: canais_medicao canais_medicao_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.canais_medicao
    ADD CONSTRAINT canais_medicao_dispositivo_id_fkey FOREIGN KEY (dispositivo_id) REFERENCES public.dispositivos(id);


--
-- Name: consumo_diario consumo_diario_canal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.consumo_diario
    ADD CONSTRAINT consumo_diario_canal_id_fkey FOREIGN KEY (canal_id) REFERENCES public.canais_medicao(id);


--
-- Name: dispositivos dispositivos_quadro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos
    ADD CONSTRAINT dispositivos_quadro_id_fkey FOREIGN KEY (quadro_id) REFERENCES public.quadros(id);


--
-- Name: dispositivos_status dispositivos_status_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.dispositivos_status
    ADD CONSTRAINT dispositivos_status_dispositivo_id_fkey FOREIGN KEY (dispositivo_id) REFERENCES public.dispositivos(id);


--
-- Name: enel_instalacoes enel_instalacoes_local_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.enel_instalacoes
    ADD CONSTRAINT enel_instalacoes_local_id_fkey FOREIGN KEY (local_id) REFERENCES public.locais(id) ON DELETE CASCADE;


--
-- Name: fatura_itens fatura_itens_fatura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.fatura_itens
    ADD CONSTRAINT fatura_itens_fatura_id_fkey FOREIGN KEY (fatura_id) REFERENCES public.faturas(id) ON DELETE CASCADE;


--
-- Name: faturas faturas_instalacao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas
    ADD CONSTRAINT faturas_instalacao_id_fkey FOREIGN KEY (instalacao_id) REFERENCES public.enel_instalacoes(id) ON DELETE SET NULL;


--
-- Name: faturas faturas_local_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas
    ADD CONSTRAINT faturas_local_id_fkey FOREIGN KEY (local_id) REFERENCES public.locais(id);


--
-- Name: faturas_ocr faturas_ocr_fatura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.faturas_ocr
    ADD CONSTRAINT faturas_ocr_fatura_id_fkey FOREIGN KEY (fatura_id) REFERENCES public.faturas(id) ON DELETE CASCADE;


--
-- Name: medicoes medicoes_canal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.medicoes
    ADD CONSTRAINT medicoes_canal_id_fkey FOREIGN KEY (canal_id) REFERENCES public.canais_medicao(id);


--
-- Name: metas metas_local_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.metas
    ADD CONSTRAINT metas_local_id_fkey FOREIGN KEY (local_id) REFERENCES public.locais(id);


--
-- Name: metas metas_quadro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.metas
    ADD CONSTRAINT metas_quadro_id_fkey FOREIGN KEY (quadro_id) REFERENCES public.quadros(id);


--
-- Name: quadros quadros_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.quadros
    ADD CONSTRAINT quadros_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: quadros quadros_local_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.quadros
    ADD CONSTRAINT quadros_local_id_fkey FOREIGN KEY (local_id) REFERENCES public.locais(id);


--
-- Name: quadros quadros_quadro_pai_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.quadros
    ADD CONSTRAINT quadros_quadro_pai_id_fkey FOREIGN KEY (quadro_pai_id) REFERENCES public.quadros(id) ON DELETE SET NULL;


--
-- Name: rateio rateio_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.rateio
    ADD CONSTRAINT rateio_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: rateio rateio_fatura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.rateio
    ADD CONSTRAINT rateio_fatura_id_fkey FOREIGN KEY (fatura_id) REFERENCES public.faturas(id);


--
-- Name: tarifas tarifas_local_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: julya
--

ALTER TABLE ONLY public.tarifas
    ADD CONSTRAINT tarifas_local_id_fkey FOREIGN KEY (local_id) REFERENCES public.locais(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO julya;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO julya;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO julya;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO julya;


--
-- PostgreSQL database dump complete
--

\unrestrict Y2lsptNFf2PUov1EN4E7G5T8yTsOLqa82Z4cNmkcNw15L2g415VX3hT2UhvJrqw

