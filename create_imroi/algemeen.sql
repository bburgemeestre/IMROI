--
-- PostgreSQL database dump
--

-- Dumped from database version 11.8 (Debian 11.8-1.pgdg90+1)
-- Dumped by pg_dump version 12.4

-- Started on 2020-10-19 09:06:20

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
-- TOC entry 9 (class 2615 OID 316437)
-- Name: algemeen; Type: SCHEMA; Schema: -; Owner: oiv_admin
--

CREATE SCHEMA algemeen;


ALTER SCHEMA algemeen OWNER TO oiv_admin;

--
-- TOC entry 2064 (class 1247 OID 318308)
-- Name: emailadres; Type: DOMAIN; Schema: algemeen; Owner: oiv_admin
--

CREATE DOMAIN algemeen.emailadres AS character varying(254)
	CONSTRAINT emailadres_check CHECK (((VALUE)::text ~ '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'::text));


ALTER DOMAIN algemeen.emailadres OWNER TO oiv_admin;

SET default_tablespace = '';

--
-- TOC entry 200 (class 1259 OID 316438)
-- Name: applicatie; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.applicatie (
    id smallint NOT NULL,
    versie smallint,
    sub smallint,
    revisie smallint,
    omschrijving text,
    datum timestamp with time zone DEFAULT now(),
    db_versie smallint
);


ALTER TABLE algemeen.applicatie OWNER TO oiv_admin;

--
-- TOC entry 216 (class 1259 OID 318026)
-- Name: bag_extent; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.bag_extent (
    gid integer,
    identificatie text,
    pandstatus text,
    gebruiksdoel text,
    geom public.geometry(GeometryZ,28992)
);


ALTER TABLE algemeen.bag_extent OWNER TO oiv_admin;

--
-- TOC entry 217 (class 1259 OID 318051)
-- Name: bgt_extent_gid_seq; Type: SEQUENCE; Schema: algemeen; Owner: oiv_admin
--

CREATE SEQUENCE algemeen.bgt_extent_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE algemeen.bgt_extent_gid_seq OWNER TO oiv_admin;

--
-- TOC entry 226 (class 1259 OID 318132)
-- Name: bgt_extent; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.bgt_extent (
    gid integer DEFAULT nextval('algemeen.bgt_extent_gid_seq'::regclass) NOT NULL,
    identificatie character varying(80),
    lokaalid character varying(80),
    bron_tbl character varying(254),
    bron character varying(10),
    geovlak public.geometry(Geometry,28992)
);


ALTER TABLE algemeen.bgt_extent OWNER TO oiv_admin;

--
-- TOC entry 218 (class 1259 OID 318053)
-- Name: fotografie_id_seq; Type: SEQUENCE; Schema: algemeen; Owner: oiv_admin
--

CREATE SEQUENCE algemeen.fotografie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE algemeen.fotografie_id_seq OWNER TO oiv_admin;

--
-- TOC entry 221 (class 1259 OID 318059)
-- Name: fotografie; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.fotografie (
    id integer DEFAULT nextval('algemeen.fotografie_id_seq'::regclass) NOT NULL,
    geom public.geometry(Point,28992) NOT NULL,
    datum_aangemaakt timestamp with time zone DEFAULT now(),
    datum_gewijzigd timestamp with time zone,
    uitgesloten boolean DEFAULT false,
    src text NOT NULL,
    exif json,
    datum character varying(255),
    rd_x numeric,
    rd_y numeric,
    bestand character varying(255),
    fotograaf character varying(255),
    omschrijving text,
    bijzonderheden text
);


ALTER TABLE algemeen.fotografie OWNER TO oiv_admin;

--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE fotografie; Type: COMMENT; Schema: algemeen; Owner: oiv_admin
--

COMMENT ON TABLE algemeen.fotografie IS 'Algemene fotografie tabel';


--
-- TOC entry 222 (class 1259 OID 318071)
-- Name: gemeente_zonder_wtr; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.gemeente_zonder_wtr (
    id bigint NOT NULL,
    geom public.geometry(MultiPolygon,28992),
    objectid bigint,
    gml_id character varying(254),
    code character varying(6),
    gemeentena character varying(30),
    shape_leng double precision,
    shape_le_1 double precision,
    shape_area double precision,
    inpoly_fid bigint,
    simpgnflag integer,
    maxsimptol double precision,
    minsimptol double precision
);


ALTER TABLE algemeen.gemeente_zonder_wtr OWNER TO oiv_admin;

--
-- TOC entry 223 (class 1259 OID 318080)
-- Name: gt_pk_metadata; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.gt_pk_metadata (
    table_schema character varying(32) NOT NULL,
    table_name character varying(32) NOT NULL,
    pk_column character varying(32) NOT NULL,
    pk_column_idx integer,
    pk_policy character varying(32),
    pk_sequence character varying(64),
    CONSTRAINT gt_pk_metadata_table_pk_policy_check CHECK (((pk_policy)::text = ANY (ARRAY[('sequence'::character varying)::text, ('assigned'::character varying)::text, ('autogenerated'::character varying)::text])))
);


ALTER TABLE algemeen.gt_pk_metadata OWNER TO oiv_admin;

--
-- TOC entry 219 (class 1259 OID 318055)
-- Name: team_id_seq; Type: SEQUENCE; Schema: algemeen; Owner: oiv_admin
--

CREATE SEQUENCE algemeen.team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE algemeen.team_id_seq OWNER TO oiv_admin;

--
-- TOC entry 230 (class 1259 OID 318310)
-- Name: team; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.team (
    id integer DEFAULT nextval('algemeen.team_id_seq'::regclass) NOT NULL,
    statcode text NOT NULL,
    naam character varying(255) NOT NULL,
    email algemeen.emailadres,
    geom public.geometry(MultiPolygon,28992)
);


ALTER TABLE algemeen.team OWNER TO oiv_admin;

--
-- TOC entry 220 (class 1259 OID 318057)
-- Name: teamlid_id_seq; Type: SEQUENCE; Schema: algemeen; Owner: oiv_admin
--

CREATE SEQUENCE algemeen.teamlid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE algemeen.teamlid_id_seq OWNER TO oiv_admin;

--
-- TOC entry 231 (class 1259 OID 318324)
-- Name: teamlid; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.teamlid (
    id integer DEFAULT nextval('algemeen.teamlid_id_seq'::regclass) NOT NULL,
    team_id integer NOT NULL,
    login character varying(255) NOT NULL,
    wachtwoord character varying(255),
    naam character varying,
    email algemeen.emailadres
);


ALTER TABLE algemeen.teamlid OWNER TO oiv_admin;

--
-- TOC entry 224 (class 1259 OID 318095)
-- Name: veiligheidsregio; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.veiligheidsregio (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,28992),
    statcode text NOT NULL,
    statnaam text,
    rubriek text
);


ALTER TABLE algemeen.veiligheidsregio OWNER TO oiv_admin;

--
-- TOC entry 225 (class 1259 OID 318120)
-- Name: veiligheidsregio_watergrenzen; Type: TABLE; Schema: algemeen; Owner: oiv_admin
--

CREATE TABLE algemeen.veiligheidsregio_watergrenzen (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,28992),
    code character varying,
    naam character varying
);


ALTER TABLE algemeen.veiligheidsregio_watergrenzen OWNER TO oiv_admin;

--
-- TOC entry 4758 (class 0 OID 316438)
-- Dependencies: 200
-- Data for Name: applicatie; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.applicatie (id, versie, sub, revisie, omschrijving, datum, db_versie) FROM stdin;
\.


--
-- TOC entry 4759 (class 0 OID 318026)
-- Dependencies: 216
-- Data for Name: bag_extent; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.bag_extent (gid, identificatie, pandstatus, gebruiksdoel, geom) FROM stdin;
\.


--
-- TOC entry 4769 (class 0 OID 318132)
-- Dependencies: 226
-- Data for Name: bgt_extent; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.bgt_extent (gid, identificatie, lokaalid, bron_tbl, bron, geovlak) FROM stdin;
\.


--
-- TOC entry 4764 (class 0 OID 318059)
-- Dependencies: 221
-- Data for Name: fotografie; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.fotografie (id, geom, datum_aangemaakt, datum_gewijzigd, uitgesloten, src, exif, datum, rd_x, rd_y, bestand, fotograaf, omschrijving, bijzonderheden) FROM stdin;
\.


--
-- TOC entry 4765 (class 0 OID 318071)
-- Dependencies: 222
-- Data for Name: gemeente_zonder_wtr; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.gemeente_zonder_wtr (id, geom, objectid, gml_id, code, gemeentena, shape_leng, shape_le_1, shape_area, inpoly_fid, simpgnflag, maxsimptol, minsimptol) FROM stdin;
\.


--
-- TOC entry 4766 (class 0 OID 318080)
-- Dependencies: 223
-- Data for Name: gt_pk_metadata; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.gt_pk_metadata (table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence) FROM stdin;
\.


--
-- TOC entry 4770 (class 0 OID 318310)
-- Dependencies: 230
-- Data for Name: team; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.team (id, statcode, naam, email, geom) FROM stdin;
\.


--
-- TOC entry 4771 (class 0 OID 318324)
-- Dependencies: 231
-- Data for Name: teamlid; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.teamlid (id, team_id, login, wachtwoord, naam, email) FROM stdin;
\.


--
-- TOC entry 4767 (class 0 OID 318095)
-- Dependencies: 224
-- Data for Name: veiligheidsregio; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.veiligheidsregio (id, geom, statcode, statnaam, rubriek) FROM stdin;
\.


--
-- TOC entry 4768 (class 0 OID 318120)
-- Dependencies: 225
-- Data for Name: veiligheidsregio_watergrenzen; Type: TABLE DATA; Schema: algemeen; Owner: oiv_admin
--

COPY algemeen.veiligheidsregio_watergrenzen (id, geom, code, naam) FROM stdin;
\.


--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 217
-- Name: bgt_extent_gid_seq; Type: SEQUENCE SET; Schema: algemeen; Owner: oiv_admin
--

SELECT pg_catalog.setval('algemeen.bgt_extent_gid_seq', 1, false);


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 218
-- Name: fotografie_id_seq; Type: SEQUENCE SET; Schema: algemeen; Owner: oiv_admin
--

SELECT pg_catalog.setval('algemeen.fotografie_id_seq', 1, false);


--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 219
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: algemeen; Owner: oiv_admin
--

SELECT pg_catalog.setval('algemeen.team_id_seq', 1, false);


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 220
-- Name: teamlid_id_seq; Type: SEQUENCE SET; Schema: algemeen; Owner: oiv_admin
--

SELECT pg_catalog.setval('algemeen.teamlid_id_seq', 1, false);


--
-- TOC entry 4597 (class 2606 OID 316446)
-- Name: applicatie applicatie_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.applicatie
    ADD CONSTRAINT applicatie_pkey PRIMARY KEY (id);


--
-- TOC entry 4622 (class 2606 OID 318140)
-- Name: bgt_extent bgt_extent_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.bgt_extent
    ADD CONSTRAINT bgt_extent_pkey PRIMARY KEY (gid);


--
-- TOC entry 4603 (class 2606 OID 318069)
-- Name: fotografie fotografie_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.fotografie
    ADD CONSTRAINT fotografie_pkey PRIMARY KEY (id);


--
-- TOC entry 4606 (class 2606 OID 318078)
-- Name: gemeente_zonder_wtr gemeente_zonder_wtr_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.gemeente_zonder_wtr
    ADD CONSTRAINT gemeente_zonder_wtr_pkey PRIMARY KEY (id);


--
-- TOC entry 4609 (class 2606 OID 318085)
-- Name: gt_pk_metadata gt_pk_metadata_table_table_schema_table_name_pk_column_key; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.gt_pk_metadata
    ADD CONSTRAINT gt_pk_metadata_table_table_schema_table_name_pk_column_key UNIQUE (table_schema, table_name, pk_column);


--
-- TOC entry 4624 (class 2606 OID 318318)
-- Name: team team_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- TOC entry 4626 (class 2606 OID 318332)
-- Name: teamlid teamlid_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.teamlid
    ADD CONSTRAINT teamlid_pkey PRIMARY KEY (id);


--
-- TOC entry 4617 (class 2606 OID 318129)
-- Name: veiligheidsregio_watergrenzen veiligheidsregio_code_key; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.veiligheidsregio_watergrenzen
    ADD CONSTRAINT veiligheidsregio_code_key UNIQUE (code);


--
-- TOC entry 4612 (class 2606 OID 318102)
-- Name: veiligheidsregio veiligheidsregio_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.veiligheidsregio
    ADD CONSTRAINT veiligheidsregio_pkey PRIMARY KEY (id);


--
-- TOC entry 4614 (class 2606 OID 318104)
-- Name: veiligheidsregio veiligheidsregio_statcode_key; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.veiligheidsregio
    ADD CONSTRAINT veiligheidsregio_statcode_key UNIQUE (statcode);


--
-- TOC entry 4619 (class 2606 OID 318127)
-- Name: veiligheidsregio_watergrenzen veiligheidsregio_watergrens_pkey; Type: CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.veiligheidsregio_watergrenzen
    ADD CONSTRAINT veiligheidsregio_watergrens_pkey PRIMARY KEY (id);


--
-- TOC entry 4595 (class 1259 OID 316447)
-- Name: applicatie_idx; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE UNIQUE INDEX applicatie_idx ON algemeen.applicatie USING btree ((1));


--
-- TOC entry 4598 (class 1259 OID 318032)
-- Name: bag_extent_gebruiksdoel_1598528673305; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX bag_extent_gebruiksdoel_1598528673305 ON algemeen.bag_extent USING btree (gebruiksdoel);


--
-- TOC entry 4599 (class 1259 OID 318033)
-- Name: bag_extent_geom_1598528673782; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX bag_extent_geom_1598528673782 ON algemeen.bag_extent USING gist (geom);


--
-- TOC entry 4600 (class 1259 OID 318034)
-- Name: bag_extent_identificatie_1598528670784; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX bag_extent_identificatie_1598528670784 ON algemeen.bag_extent USING btree (identificatie);


--
-- TOC entry 4601 (class 1259 OID 318035)
-- Name: bag_extent_pandstatus_1598528672836; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX bag_extent_pandstatus_1598528672836 ON algemeen.bag_extent USING btree (pandstatus);


--
-- TOC entry 4620 (class 1259 OID 318141)
-- Name: bgt_extent_geom_159853174166; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX bgt_extent_geom_159853174166 ON algemeen.bgt_extent USING gist (geovlak);


--
-- TOC entry 4604 (class 1259 OID 318070)
-- Name: sidx_fotografie_geom; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX sidx_fotografie_geom ON algemeen.fotografie USING gist (geom);


--
-- TOC entry 4607 (class 1259 OID 318079)
-- Name: sidx_gemeente_geom; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX sidx_gemeente_geom ON algemeen.gemeente_zonder_wtr USING gist (geom);


--
-- TOC entry 4610 (class 1259 OID 318105)
-- Name: sidx_veiligheidsregio_geom; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX sidx_veiligheidsregio_geom ON algemeen.veiligheidsregio USING gist (geom);


--
-- TOC entry 4615 (class 1259 OID 318130)
-- Name: sidx_veiligheidsregio_watergrens_geom; Type: INDEX; Schema: algemeen; Owner: oiv_admin
--

CREATE INDEX sidx_veiligheidsregio_watergrens_geom ON algemeen.veiligheidsregio_watergrenzen USING gist (geom);


--
-- TOC entry 4628 (class 2606 OID 318333)
-- Name: teamlid gebruiker_team_id_fk; Type: FK CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.teamlid
    ADD CONSTRAINT gebruiker_team_id_fk FOREIGN KEY (team_id) REFERENCES algemeen.team(id);


--
-- TOC entry 4627 (class 2606 OID 318319)
-- Name: team team_statcode_fk; Type: FK CONSTRAINT; Schema: algemeen; Owner: oiv_admin
--

ALTER TABLE ONLY algemeen.team
    ADD CONSTRAINT team_statcode_fk FOREIGN KEY (statcode) REFERENCES algemeen.veiligheidsregio(statcode);


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 218
-- Name: SEQUENCE fotografie_id_seq; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT,USAGE ON SEQUENCE algemeen.fotografie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.fotografie_id_seq TO oiv_write;


--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE fotografie; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT ON TABLE algemeen.fotografie TO oiv_read;
GRANT INSERT,DELETE,UPDATE ON TABLE algemeen.fotografie TO oiv_write;


--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE gemeente_zonder_wtr; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT ON TABLE algemeen.gemeente_zonder_wtr TO oiv_read;
GRANT INSERT,DELETE,UPDATE ON TABLE algemeen.gemeente_zonder_wtr TO oiv_write;


--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE gt_pk_metadata; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT ON TABLE algemeen.gt_pk_metadata TO oiv_read;
GRANT INSERT,DELETE,UPDATE ON TABLE algemeen.gt_pk_metadata TO oiv_write;


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE team_id_seq; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT,USAGE ON SEQUENCE algemeen.team_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.team_id_seq TO oiv_write;


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE team; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT ON TABLE algemeen.team TO oiv_read;


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE teamlid_id_seq; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT,USAGE ON SEQUENCE algemeen.teamlid_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.teamlid_id_seq TO oiv_write;


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE teamlid; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT ON TABLE algemeen.teamlid TO oiv_read;


--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE veiligheidsregio; Type: ACL; Schema: algemeen; Owner: oiv_admin
--

GRANT SELECT ON TABLE algemeen.veiligheidsregio TO oiv_read;
GRANT INSERT,DELETE,UPDATE ON TABLE algemeen.veiligheidsregio TO oiv_write;


-- Completed on 2020-10-19 09:06:22

--
-- PostgreSQL database dump complete
--

