--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.4 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: gate; Type: TABLE; Schema: public; Owner: interstellardbadmin
--

CREATE TABLE public.gate (
    id character varying(3) NOT NULL,
    name character varying(20),
    connections json
);


ALTER TABLE public.gate OWNER TO interstellardbadmin;

--
-- Data for Name: gate; Type: TABLE DATA; Schema: public; Owner: interstellardbadmin
--

COPY public.gate (id, name, connections) FROM stdin;
SOL	Sol	[{ "id": "RAN", "hu": "100" }, { "id": "PRX", "hu": "90" }, { "id": "SIR", "hu": "100" }, { "id": "ARC", "hu": "200" }, { "id": "ALD", "hu": "250" }]
PRX	Proxima	[{ "id": "SOL", "hu": "90" }, { "id": "SIR", "hu": "100" }, { "id": "ALT", "hu": "150" }]
SIR	Sirius	[{ "id": "SOL", "hu": "80" }, { "id": "PRX", "hu": "10" }, { "id": "CAS", "hu": "200" }]
CAS	Castor	[{ "id": "SIR", "hu": "200" }, { "id": "PRO", "hu": "120" }]
PRO	Procyon	[{ "id": "CAS", "hu": "80" }]
DEN	Denebula	[{ "id": "PRO", "hu": "5" }, { "id": "ARC", "hu": "2" }, { "id": "FOM", "hu": "8" }, { "id": "RAN", "hu": "100" }, { "id": "ALD", "hu": "3" }]
RAN	Ran	[{ "id": "SOL", "hu": "100" }]
ARC	Arcturus	[{ "id": "SOL", "hu": "500" }, { "id": "DEN", "hu": "120" }]
FOM	Fomalhaut	[{ "id": "PRX", "hu": "10" }, { "id": "DEN", "hu": "20" }, { "id": "ALS", "hu": "9" }]
ALT	Altair	[{ "id": "FOM", "hu": "140" }, { "id": "VEG", "hu": "220" }]
VEG	Vega	[{ "id": "ARC", "hu": "220" }, { "id": "ALD", "hu": "580" }]
ALD	Aldermain	[{ "id": "SOL", "hu": "200" }, { "id": "ALS", "hu": "160" }, { "id": "VEG", "hu": "320" }]
ALS	Alshain	[{ "id": "ALT", "hu": "1" }, { "id": "ALD", "hu": "1" }]
\.


--
-- Name: gate gate_pkey; Type: CONSTRAINT; Schema: public; Owner: interstellardbadmin
--

ALTER TABLE ONLY public.gate
    ADD CONSTRAINT gate_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

