--
-- PostgreSQL database cluster dump
--

-- Started on 2025-03-01 20:01:01 CST

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE taskmaster_super;
ALTER ROLE taskmaster_super WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;

CREATE ROLE taskmaster_svc;
ALTER ROLE taskmaster_svc WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:<removed-hash>';

--
-- User Configurations
--


--
-- Role memberships
--


GRANT taskmaster_super TO taskmaster_svc WITH INHERIT TRUE GRANTED BY postgres;



-- Completed on 2025-03-01 20:01:01 CST

--
-- PostgreSQL database cluster dump complete
--

