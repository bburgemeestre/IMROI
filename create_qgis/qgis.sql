--
-- PostgreSQL database dump
--

-- Dumped from database version 11.8 (Debian 11.8-1.pgdg90+1)
-- Dumped by pg_dump version 12.4

-- Started on 2021-01-14 13:42:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4726 (class 1262 OID 316436)
-- Name: oiv_productie; Type: DATABASE; Schema: -; Owner: oiv_admin
--

CREATE DATABASE oiv_productie WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE oiv_productie OWNER TO oiv_admin;

\connect oiv_productie

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 11 (class 2615 OID 318142)
-- Name: qgis; Type: SCHEMA; Schema: -; Owner: oiv_admin
--

CREATE SCHEMA qgis;


ALTER SCHEMA qgis OWNER TO oiv_admin;

--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 11
-- Name: SCHEMA qgis; Type: COMMENT; Schema: -; Owner: oiv_admin
--

COMMENT ON SCHEMA qgis IS 'Schema voor applicatie qgis';


--
-- TOC entry 2042 (class 1247 OID 318211)
-- Name: eindstijl_type; Type: TYPE; Schema: qgis; Owner: oiv_admin
--

CREATE TYPE qgis.eindstijl_type AS ENUM (
    'square',
    'flat',
    'round'
);


ALTER TYPE qgis.eindstijl_type OWNER TO oiv_admin;

--
-- TOC entry 2035 (class 1247 OID 318218)
-- Name: lijnstijl_type; Type: TYPE; Schema: qgis; Owner: oiv_admin
--

CREATE TYPE qgis.lijnstijl_type AS ENUM (
    'no',
    'solid',
    'dash',
    'dot',
    'dash dot',
    'dash dot dot'
);


ALTER TYPE qgis.lijnstijl_type OWNER TO oiv_admin;

--
-- TOC entry 2038 (class 1247 OID 318232)
-- Name: verbindingsstijl_type; Type: TYPE; Schema: qgis; Owner: oiv_admin
--

CREATE TYPE qgis.verbindingsstijl_type AS ENUM (
    'bevel',
    'miter',
    'round'
);


ALTER TYPE qgis.verbindingsstijl_type OWNER TO oiv_admin;

--
-- TOC entry 2045 (class 1247 OID 318240)
-- Name: vulstijl_type; Type: TYPE; Schema: qgis; Owner: oiv_admin
--

CREATE TYPE qgis.vulstijl_type AS ENUM (
    'solid',
    'horizontal',
    'vertical',
    'cross',
    'b_diagonal',
    'f_diagonal',
    'diagonal_x',
    'dense1',
    'dense2',
    'dense3',
    'dense4',
    'dense5',
    'dense6',
    'dense7',
    'no'
);


ALTER TYPE qgis.vulstijl_type OWNER TO oiv_admin;

--
-- TOC entry 227 (class 1259 OID 318208)
-- Name: styles_id_seq; Type: SEQUENCE; Schema: qgis; Owner: oiv_admin
--

CREATE SEQUENCE qgis.styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE qgis.styles_id_seq OWNER TO oiv_admin;

SET default_tablespace = '';

--
-- TOC entry 228 (class 1259 OID 318271)
-- Name: styles; Type: TABLE; Schema: qgis; Owner: oiv_admin
--

CREATE TABLE qgis.styles (
    id integer DEFAULT nextval('qgis.styles_id_seq'::regclass) NOT NULL,
    laagnaam character varying(100),
    soortnaam character varying(100),
    lijndikte numeric,
    lijnkleur character varying(9),
    lijnstijl qgis.lijnstijl_type,
    vulkleur character varying(9),
    vulstijl qgis.vulstijl_type,
    verbindingsstijl qgis.verbindingsstijl_type,
    eindstijl qgis.eindstijl_type
);


ALTER TABLE qgis.styles OWNER TO oiv_admin;

--
-- TOC entry 229 (class 1259 OID 318282)
-- Name: styles_symbols_type; Type: TABLE; Schema: qgis; Owner: oiv_admin
--

CREATE TABLE qgis.styles_symbols_type (
    naam text NOT NULL,
    size integer,
    symbol_name text
);


ALTER TABLE qgis.styles_symbols_type OWNER TO oiv_admin;

--
-- TOC entry 343 (class 1259 OID 319765)
-- Name: view_bouwlagen; Type: VIEW; Schema: qgis; Owner: oiv_admin
--

CREATE VIEW qgis.view_bouwlagen AS
 SELECT bl.id,
    bl.geom,
    bl.datum_aangemaakt,
    bl.datum_gewijzigd,
    bl.bouwlaag,
    bl.bouwdeel,
    o.id AS object_id,
    o.formelenaam,
    o.status
   FROM (objecten.bouwlagen bl
     JOIN objecten.object o ON ((bl.id = o.id)))
  WHERE ((((o.status)::text = 'in gebruik'::text) AND (o.datum_geldig_vanaf <= now())) OR ((o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now())) OR (o.datum_geldig_tot IS NULL));


ALTER TABLE qgis.view_bouwlagen OWNER TO oiv_admin;

--
-- TOC entry 4719 (class 0 OID 318271)
-- Dependencies: 228
-- Data for Name: styles; Type: TABLE DATA; Schema: qgis; Owner: oiv_admin
--

COPY qgis.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) FROM stdin;
\.


--
-- TOC entry 4720 (class 0 OID 318282)
-- Dependencies: 229
-- Data for Name: styles_symbols_type; Type: TABLE DATA; Schema: qgis; Owner: oiv_admin
--

COPY qgis.styles_symbols_type (naam, size, symbol_name) FROM stdin;
\.


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 227
-- Name: styles_id_seq; Type: SEQUENCE SET; Schema: qgis; Owner: oiv_admin
--

SELECT pg_catalog.setval('qgis.styles_id_seq', 1, false);


--
-- TOC entry 4584 (class 2606 OID 318279)
-- Name: styles styles_pkey; Type: CONSTRAINT; Schema: qgis; Owner: oiv_admin
--

ALTER TABLE ONLY qgis.styles
    ADD CONSTRAINT styles_pkey PRIMARY KEY (id);


--
-- TOC entry 4586 (class 2606 OID 318281)
-- Name: styles styles_soortnaam_key; Type: CONSTRAINT; Schema: qgis; Owner: oiv_admin
--

ALTER TABLE ONLY qgis.styles
    ADD CONSTRAINT styles_soortnaam_key UNIQUE (soortnaam);


--
-- TOC entry 4588 (class 2606 OID 318289)
-- Name: styles_symbols_type styles_symbols_type_pkey; Type: CONSTRAINT; Schema: qgis; Owner: oiv_admin
--

ALTER TABLE ONLY qgis.styles_symbols_type
    ADD CONSTRAINT styles_symbols_type_pkey PRIMARY KEY (naam);


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE view_bouwlagen; Type: ACL; Schema: qgis; Owner: oiv_admin
--

GRANT SELECT ON TABLE qgis.view_bouwlagen TO oiv_read;
GRANT INSERT,DELETE,UPDATE ON TABLE qgis.view_bouwlagen TO oiv_write;


-- Completed on 2021-01-14 13:42:48

--
-- PostgreSQL database dump complete
--

