--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-0ubuntu0.24.10.1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-03-01 19:59:40 CST

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
-- TOC entry 7 (class 2615 OID 16394)
-- Name: eduardo; Type: SCHEMA; Schema: -; Owner: taskmaster_super
--

CREATE SCHEMA eduardo;


ALTER SCHEMA eduardo OWNER TO taskmaster_super;

--
-- TOC entry 8 (class 2615 OID 16395)
-- Name: test; Type: SCHEMA; Schema: -; Owner: taskmaster_super
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO taskmaster_super;

--
-- TOC entry 2 (class 3079 OID 16396)
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- TOC entry 1001 (class 1247 OID 16582)
-- Name: task_priority; Type: TYPE; Schema: public; Owner: taskmaster_super
--

CREATE TYPE public.task_priority AS ENUM (
    'normal',
    'low',
    'medium',
    'high',
    'critical'
);


ALTER TYPE public.task_priority OWNER TO taskmaster_super;

--
-- TOC entry 1004 (class 1247 OID 16594)
-- Name: task_type; Type: TYPE; Schema: public; Owner: taskmaster_super
--

CREATE TYPE public.task_type AS ENUM (
    'task',
    'subtask',
    'defect',
    'idea',
    'discarded',
    'archived'
);


ALTER TYPE public.task_type OWNER TO taskmaster_super;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16607)
-- Name: board; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.board (
    id_board integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE eduardo.board OWNER TO taskmaster_super;

--
-- TOC entry 221 (class 1259 OID 16610)
-- Name: board_id_board_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.board_id_board_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.board_id_board_seq OWNER TO taskmaster_super;

--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 221
-- Name: board_id_board_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.board_id_board_seq OWNED BY eduardo.board.id_board;


--
-- TOC entry 222 (class 1259 OID 16611)
-- Name: board_objects; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.board_objects (
    id_object bigint NOT NULL,
    id_board integer NOT NULL,
    id_project integer,
    id_tag integer
);


ALTER TABLE eduardo.board_objects OWNER TO taskmaster_super;

--
-- TOC entry 223 (class 1259 OID 16614)
-- Name: board_objects_id_object_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.board_objects_id_object_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.board_objects_id_object_seq OWNER TO taskmaster_super;

--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 223
-- Name: board_objects_id_object_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.board_objects_id_object_seq OWNED BY eduardo.board_objects.id_object;


--
-- TOC entry 224 (class 1259 OID 16615)
-- Name: board_states; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.board_states (
    id_board integer NOT NULL,
    state_set integer NOT NULL
);


ALTER TABLE eduardo.board_states OWNER TO taskmaster_super;

--
-- TOC entry 225 (class 1259 OID 16618)
-- Name: board_tasks_position; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.board_tasks_position (
    sort_order double precision,
    id_board integer NOT NULL,
    id_task integer NOT NULL
);


ALTER TABLE eduardo.board_tasks_position OWNER TO taskmaster_super;

--
-- TOC entry 281 (class 1259 OID 26243)
-- Name: epic; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.epic (
    id_epic integer NOT NULL,
    epic character varying(80) NOT NULL,
    state character varying(40),
    id_project integer NOT NULL,
    expanded boolean DEFAULT true,
    description character varying,
    priority public.task_priority
);


ALTER TABLE eduardo.epic OWNER TO taskmaster_super;

--
-- TOC entry 280 (class 1259 OID 26242)
-- Name: epic_id_epic_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE eduardo.epic ALTER COLUMN id_epic ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME eduardo.epic_id_epic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16621)
-- Name: external_task; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.external_task (
    id character varying(20) NOT NULL,
    key character varying(40) NOT NULL,
    id_task integer NOT NULL,
    integration character varying(40),
    icon character varying(255),
    updated timestamp without time zone,
    data json,
    id_project integer
);


ALTER TABLE eduardo.external_task OWNER TO taskmaster_super;

--
-- TOC entry 227 (class 1259 OID 16626)
-- Name: project; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.project (
    id_project integer NOT NULL,
    name character varying(80) NOT NULL,
    enable_billing boolean DEFAULT true,
    color character varying(12),
    project_key character varying(8)
);


ALTER TABLE eduardo.project OWNER TO taskmaster_super;

--
-- TOC entry 228 (class 1259 OID 16630)
-- Name: project_billing; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.project_billing (
    id_billing integer NOT NULL,
    id_project integer NOT NULL,
    from_date date,
    to_date date,
    hour_rate money
);


ALTER TABLE eduardo.project_billing OWNER TO taskmaster_super;

--
-- TOC entry 229 (class 1259 OID 16633)
-- Name: project_billing_id_billing_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE eduardo.project_billing ALTER COLUMN id_billing ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME eduardo.project_billing_id_billing_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16634)
-- Name: project_id_project_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.project_id_project_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.project_id_project_seq OWNER TO taskmaster_super;

--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 230
-- Name: project_id_project_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.project_id_project_seq OWNED BY eduardo.project.id_project;


--
-- TOC entry 231 (class 1259 OID 16635)
-- Name: project_integration; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.project_integration (
    id_project integer NOT NULL,
    id_integration integer NOT NULL,
    parameters jsonb
);


ALTER TABLE eduardo.project_integration OWNER TO taskmaster_super;

--
-- TOC entry 232 (class 1259 OID 16640)
-- Name: project_tags; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.project_tags (
    id_project integer NOT NULL,
    id_tag integer NOT NULL
);


ALTER TABLE eduardo.project_tags OWNER TO taskmaster_super;

--
-- TOC entry 233 (class 1259 OID 16643)
-- Name: state; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.state (
    state character varying(40) NOT NULL,
    hide_after_days integer,
    show_dimmed boolean DEFAULT false,
    background_color character varying(10)
);


ALTER TABLE eduardo.state OWNER TO taskmaster_super;

--
-- TOC entry 234 (class 1259 OID 16647)
-- Name: state_set; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.state_set (
    id_state_set integer NOT NULL,
    state_set character varying(40) NOT NULL
);


ALTER TABLE eduardo.state_set OWNER TO taskmaster_super;

--
-- TOC entry 235 (class 1259 OID 16650)
-- Name: state_set_id_state_set_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.state_set_id_state_set_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.state_set_id_state_set_seq OWNER TO taskmaster_super;

--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 235
-- Name: state_set_id_state_set_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.state_set_id_state_set_seq OWNED BY eduardo.state_set.id_state_set;


--
-- TOC entry 236 (class 1259 OID 16651)
-- Name: states_4_set; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.states_4_set (
    state_set integer NOT NULL,
    state character varying(40) NOT NULL,
    item_order integer DEFAULT 0,
    initial_state boolean DEFAULT false,
    end_state boolean DEFAULT false,
    next_states character varying(40)[],
    started_state boolean DEFAULT false
);


ALTER TABLE eduardo.states_4_set OWNER TO taskmaster_super;

--
-- TOC entry 237 (class 1259 OID 16660)
-- Name: tag; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.tag (
    id_tag integer NOT NULL,
    tag character varying(64) NOT NULL,
    system_tag boolean DEFAULT false,
    expression character varying
);


ALTER TABLE eduardo.tag OWNER TO taskmaster_super;

--
-- TOC entry 238 (class 1259 OID 16666)
-- Name: tag_id_tag_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.tag_id_tag_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.tag_id_tag_seq OWNER TO taskmaster_super;

--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 238
-- Name: tag_id_tag_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.tag_id_tag_seq OWNED BY eduardo.tag.id_tag;


--
-- TOC entry 239 (class 1259 OID 16667)
-- Name: task; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.task (
    id_task integer NOT NULL,
    id_project integer NOT NULL,
    title character varying(132) NOT NULL,
    description character varying,
    state character varying(40) NOT NULL,
    activity jsonb,
    state_latest_change timestamp without time zone,
    hierarchy public.ltree,
    priority public.task_priority,
    type public.task_type,
    due_date timestamp without time zone,
    estimated_start_date timestamp without time zone,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    last_activity timestamp without time zone,
    estimated_duration interval,
    expanded boolean DEFAULT true,
    notes character varying,
    id_epic integer
);


ALTER TABLE eduardo.task OWNER TO taskmaster_super;

--
-- TOC entry 240 (class 1259 OID 16673)
-- Name: task_id_task_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.task_id_task_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.task_id_task_seq OWNER TO taskmaster_super;

--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 240
-- Name: task_id_task_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.task_id_task_seq OWNED BY eduardo.task.id_task;


--
-- TOC entry 241 (class 1259 OID 16674)
-- Name: task_tags; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.task_tags (
    id_task integer NOT NULL,
    id_tag integer NOT NULL
);


ALTER TABLE eduardo.task_tags OWNER TO taskmaster_super;

--
-- TOC entry 242 (class 1259 OID 16677)
-- Name: time_spent; Type: TABLE; Schema: eduardo; Owner: taskmaster_super
--

CREATE TABLE eduardo.time_spent (
    id_interval integer NOT NULL,
    id_task integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    description character varying
);


ALTER TABLE eduardo.time_spent OWNER TO taskmaster_super;

--
-- TOC entry 243 (class 1259 OID 16682)
-- Name: time_spent_id_interval_seq; Type: SEQUENCE; Schema: eduardo; Owner: taskmaster_super
--

CREATE SEQUENCE eduardo.time_spent_id_interval_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE eduardo.time_spent_id_interval_seq OWNER TO taskmaster_super;

--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 243
-- Name: time_spent_id_interval_seq; Type: SEQUENCE OWNED BY; Schema: eduardo; Owner: taskmaster_super
--

ALTER SEQUENCE eduardo.time_spent_id_interval_seq OWNED BY eduardo.time_spent.id_interval;


--
-- TOC entry 244 (class 1259 OID 16683)
-- Name: v_task_time_spent; Type: VIEW; Schema: eduardo; Owner: eduardo
--

CREATE VIEW eduardo.v_task_time_spent AS
 SELECT t.id_task,
    t.hierarchy,
    sum((ts.end_time - ts.start_time)) AS time_spent
   FROM (eduardo.task t
     JOIN eduardo.time_spent ts ON ((t.id_task = ts.id_task)))
  GROUP BY t.id_task, t.hierarchy;


ALTER VIEW eduardo.v_task_time_spent OWNER TO eduardo;

--
-- TOC entry 245 (class 1259 OID 16688)
-- Name: v_task_time_spent_per_day; Type: VIEW; Schema: eduardo; Owner: eduardo
--

CREATE VIEW eduardo.v_task_time_spent_per_day AS
 SELECT t.id_task,
    t.hierarchy,
    ((ts.start_time - '06:00:00'::interval))::date AS the_date,
    sum((ts.end_time - ts.start_time)) AS time_spent
   FROM (eduardo.task t
     JOIN eduardo.time_spent ts ON ((t.id_task = ts.id_task)))
  GROUP BY t.id_task, t.hierarchy, (((ts.start_time - '06:00:00'::interval))::date)
  ORDER BY t.hierarchy;


ALTER VIEW eduardo.v_task_time_spent_per_day OWNER TO eduardo;

--
-- TOC entry 246 (class 1259 OID 16693)
-- Name: integration; Type: TABLE; Schema: public; Owner: taskmaster_super
--

CREATE TABLE public.integration (
    id_integration integer NOT NULL,
    integration character varying(40) NOT NULL,
    script character varying,
    parameters jsonb,
    icon character varying(255)
);


ALTER TABLE public.integration OWNER TO taskmaster_super;

--
-- TOC entry 247 (class 1259 OID 16698)
-- Name: integration_id_integration_seq; Type: SEQUENCE; Schema: public; Owner: taskmaster_super
--

ALTER TABLE public.integration ALTER COLUMN id_integration ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.integration_id_integration_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 248 (class 1259 OID 16699)
-- Name: roles; Type: TABLE; Schema: public; Owner: taskmaster_super
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    role character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO taskmaster_super;

--
-- TOC entry 249 (class 1259 OID 16704)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: taskmaster_super
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO taskmaster_super;

--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 249
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taskmaster_super
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 250 (class 1259 OID 16705)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: taskmaster_super
--

CREATE TABLE public.user_roles (
    "user" integer NOT NULL,
    role integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO taskmaster_super;

--
-- TOC entry 251 (class 1259 OID 16708)
-- Name: users; Type: TABLE; Schema: public; Owner: taskmaster_super
--

CREATE TABLE public.users (
    id integer NOT NULL,
    active boolean NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    token character varying(40)
);


ALTER TABLE public.users OWNER TO taskmaster_super;

--
-- TOC entry 252 (class 1259 OID 16713)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: taskmaster_super
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO taskmaster_super;

--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 252
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taskmaster_super
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 253 (class 1259 OID 16714)
-- Name: board; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.board (
    id_board integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE test.board OWNER TO taskmaster_super;

--
-- TOC entry 254 (class 1259 OID 16717)
-- Name: board_id_board_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.board_id_board_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.board_id_board_seq OWNER TO taskmaster_super;

--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 254
-- Name: board_id_board_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.board_id_board_seq OWNED BY test.board.id_board;


--
-- TOC entry 255 (class 1259 OID 16718)
-- Name: board_objects; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.board_objects (
    id_object bigint NOT NULL,
    id_board integer NOT NULL,
    id_project integer,
    id_tag integer
);


ALTER TABLE test.board_objects OWNER TO taskmaster_super;

--
-- TOC entry 256 (class 1259 OID 16721)
-- Name: board_objects_id_object_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.board_objects_id_object_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.board_objects_id_object_seq OWNER TO taskmaster_super;

--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 256
-- Name: board_objects_id_object_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.board_objects_id_object_seq OWNED BY test.board_objects.id_object;


--
-- TOC entry 257 (class 1259 OID 16722)
-- Name: board_states; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.board_states (
    id_board integer NOT NULL,
    state_set integer NOT NULL
);


ALTER TABLE test.board_states OWNER TO taskmaster_super;

--
-- TOC entry 258 (class 1259 OID 16725)
-- Name: board_tasks_position; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.board_tasks_position (
    sort_order double precision,
    id_board integer NOT NULL,
    id_task integer NOT NULL
);


ALTER TABLE test.board_tasks_position OWNER TO taskmaster_super;

--
-- TOC entry 283 (class 1259 OID 26723)
-- Name: epic; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.epic (
    id_epic integer NOT NULL,
    epic character varying(80) NOT NULL,
    state character varying(40),
    id_project integer NOT NULL,
    expanded boolean DEFAULT true,
    description character varying,
    priority public.task_priority
);


ALTER TABLE test.epic OWNER TO taskmaster_super;

--
-- TOC entry 282 (class 1259 OID 26722)
-- Name: epic_id_epic_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

ALTER TABLE test.epic ALTER COLUMN id_epic ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME test.epic_id_epic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 259 (class 1259 OID 16728)
-- Name: external_task; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.external_task (
    id character varying(20) NOT NULL,
    key character varying(40) NOT NULL,
    id_task integer NOT NULL,
    integration character varying(40),
    icon character varying(255),
    updated timestamp without time zone,
    data json,
    id_project integer
);


ALTER TABLE test.external_task OWNER TO taskmaster_super;

--
-- TOC entry 260 (class 1259 OID 16733)
-- Name: project; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.project (
    id_project integer NOT NULL,
    name character varying(80) NOT NULL,
    enable_billing boolean DEFAULT true,
    color character varying(12),
    project_key character varying(8)
);


ALTER TABLE test.project OWNER TO taskmaster_super;

--
-- TOC entry 261 (class 1259 OID 16737)
-- Name: project_billing; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.project_billing (
    id_billing integer NOT NULL,
    id_project integer NOT NULL,
    from_date date,
    to_date date,
    hour_rate money
);


ALTER TABLE test.project_billing OWNER TO taskmaster_super;

--
-- TOC entry 262 (class 1259 OID 16740)
-- Name: project_billing_id_billing_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

ALTER TABLE test.project_billing ALTER COLUMN id_billing ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME test.project_billing_id_billing_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 263 (class 1259 OID 16741)
-- Name: project_id_project_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.project_id_project_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.project_id_project_seq OWNER TO taskmaster_super;

--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 263
-- Name: project_id_project_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.project_id_project_seq OWNED BY test.project.id_project;


--
-- TOC entry 264 (class 1259 OID 16742)
-- Name: project_integration; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.project_integration (
    id_project integer NOT NULL,
    id_integration integer NOT NULL,
    parameters jsonb
);


ALTER TABLE test.project_integration OWNER TO taskmaster_super;

--
-- TOC entry 265 (class 1259 OID 16747)
-- Name: project_tags; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.project_tags (
    id_project integer NOT NULL,
    id_tag integer NOT NULL
);


ALTER TABLE test.project_tags OWNER TO taskmaster_super;

--
-- TOC entry 266 (class 1259 OID 16750)
-- Name: state; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.state (
    state character varying(40) NOT NULL,
    hide_after_days integer,
    show_dimmed boolean DEFAULT false,
    background_color character varying(10)
);


ALTER TABLE test.state OWNER TO taskmaster_super;

--
-- TOC entry 267 (class 1259 OID 16754)
-- Name: state_set; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.state_set (
    id_state_set integer NOT NULL,
    state_set character varying(40) NOT NULL
);


ALTER TABLE test.state_set OWNER TO taskmaster_super;

--
-- TOC entry 268 (class 1259 OID 16757)
-- Name: state_set_id_state_set_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.state_set_id_state_set_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.state_set_id_state_set_seq OWNER TO taskmaster_super;

--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 268
-- Name: state_set_id_state_set_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.state_set_id_state_set_seq OWNED BY test.state_set.id_state_set;


--
-- TOC entry 269 (class 1259 OID 16758)
-- Name: states_4_set; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.states_4_set (
    state_set integer NOT NULL,
    state character varying(40) NOT NULL,
    item_order integer DEFAULT 0,
    initial_state boolean DEFAULT false,
    end_state boolean DEFAULT false,
    next_states character varying(40)[],
    started_state boolean DEFAULT false
);


ALTER TABLE test.states_4_set OWNER TO taskmaster_super;

--
-- TOC entry 270 (class 1259 OID 16767)
-- Name: tag; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.tag (
    id_tag integer NOT NULL,
    tag character varying(64) NOT NULL,
    system_tag boolean DEFAULT false,
    expression character varying
);


ALTER TABLE test.tag OWNER TO taskmaster_super;

--
-- TOC entry 271 (class 1259 OID 16773)
-- Name: tag_id_tag_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.tag_id_tag_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.tag_id_tag_seq OWNER TO taskmaster_super;

--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 271
-- Name: tag_id_tag_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.tag_id_tag_seq OWNED BY test.tag.id_tag;


--
-- TOC entry 272 (class 1259 OID 16774)
-- Name: task; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.task (
    id_task integer NOT NULL,
    id_project integer NOT NULL,
    title character varying(132) NOT NULL,
    description character varying,
    state character varying(40) NOT NULL,
    activity jsonb,
    state_latest_change timestamp without time zone,
    hierarchy public.ltree,
    priority public.task_priority,
    type public.task_type,
    due_date timestamp without time zone,
    estimated_start_date timestamp without time zone,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    last_activity timestamp without time zone,
    estimated_duration interval,
    expanded boolean DEFAULT true,
    notes character varying,
    id_epic integer
);


ALTER TABLE test.task OWNER TO taskmaster_super;

--
-- TOC entry 273 (class 1259 OID 16780)
-- Name: task_id_task_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.task_id_task_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.task_id_task_seq OWNER TO taskmaster_super;

--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 273
-- Name: task_id_task_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.task_id_task_seq OWNED BY test.task.id_task;


--
-- TOC entry 274 (class 1259 OID 16781)
-- Name: task_tags; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.task_tags (
    id_task integer NOT NULL,
    id_tag integer NOT NULL
);


ALTER TABLE test.task_tags OWNER TO taskmaster_super;

--
-- TOC entry 275 (class 1259 OID 16784)
-- Name: time_spent; Type: TABLE; Schema: test; Owner: taskmaster_super
--

CREATE TABLE test.time_spent (
    id_interval integer NOT NULL,
    id_task integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    description character varying
);


ALTER TABLE test.time_spent OWNER TO taskmaster_super;

--
-- TOC entry 276 (class 1259 OID 16789)
-- Name: test_v_task_time_spent_per_day; Type: VIEW; Schema: test; Owner: eduardo
--

CREATE VIEW test.test_v_task_time_spent_per_day AS
 SELECT t.id_task,
    t.hierarchy,
    ((ts.start_time - '06:00:00'::interval))::date AS the_date,
    sum((ts.end_time - ts.start_time)) AS time_spent
   FROM (test.task t
     JOIN test.time_spent ts ON ((t.id_task = ts.id_task)))
  GROUP BY t.id_task, t.hierarchy, (((ts.start_time - '06:00:00'::interval))::date)
  ORDER BY t.hierarchy;


ALTER VIEW test.test_v_task_time_spent_per_day OWNER TO eduardo;

--
-- TOC entry 277 (class 1259 OID 16794)
-- Name: time_spent_id_interval_seq; Type: SEQUENCE; Schema: test; Owner: taskmaster_super
--

CREATE SEQUENCE test.time_spent_id_interval_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE test.time_spent_id_interval_seq OWNER TO taskmaster_super;

--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 277
-- Name: time_spent_id_interval_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: taskmaster_super
--

ALTER SEQUENCE test.time_spent_id_interval_seq OWNED BY test.time_spent.id_interval;


--
-- TOC entry 278 (class 1259 OID 16795)
-- Name: v_task_time_spent; Type: VIEW; Schema: test; Owner: eduardo
--

CREATE VIEW test.v_task_time_spent AS
 SELECT t.id_task,
    t.hierarchy,
    sum((ts.end_time - ts.start_time)) AS time_spent
   FROM (test.task t
     JOIN test.time_spent ts ON ((t.id_task = ts.id_task)))
  GROUP BY t.id_task, t.hierarchy;


ALTER VIEW test.v_task_time_spent OWNER TO eduardo;

--
-- TOC entry 279 (class 1259 OID 16800)
-- Name: v_task_time_spent_per_day; Type: VIEW; Schema: test; Owner: eduardo
--

CREATE VIEW test.v_task_time_spent_per_day AS
 SELECT t.id_task,
    t.hierarchy,
    ((ts.start_time - '06:00:00'::interval))::date AS the_date,
    sum((ts.end_time - ts.start_time)) AS time_spent
   FROM (test.task t
     JOIN test.time_spent ts ON ((t.id_task = ts.id_task)))
  GROUP BY t.id_task, t.hierarchy, (((ts.start_time - '06:00:00'::interval))::date)
  ORDER BY t.hierarchy;


ALTER VIEW test.v_task_time_spent_per_day OWNER TO eduardo;

--
-- TOC entry 3627 (class 2604 OID 16805)
-- Name: board id_board; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board ALTER COLUMN id_board SET DEFAULT nextval('eduardo.board_id_board_seq'::regclass);


--
-- TOC entry 3628 (class 2604 OID 16806)
-- Name: board_objects id_object; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_objects ALTER COLUMN id_object SET DEFAULT nextval('eduardo.board_objects_id_object_seq'::regclass);


--
-- TOC entry 3629 (class 2604 OID 16807)
-- Name: project id_project; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project ALTER COLUMN id_project SET DEFAULT nextval('eduardo.project_id_project_seq'::regclass);


--
-- TOC entry 3632 (class 2604 OID 16808)
-- Name: state_set id_state_set; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.state_set ALTER COLUMN id_state_set SET DEFAULT nextval('eduardo.state_set_id_state_set_seq'::regclass);


--
-- TOC entry 3637 (class 2604 OID 16809)
-- Name: tag id_tag; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.tag ALTER COLUMN id_tag SET DEFAULT nextval('eduardo.tag_id_tag_seq'::regclass);


--
-- TOC entry 3639 (class 2604 OID 16810)
-- Name: task id_task; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task ALTER COLUMN id_task SET DEFAULT nextval('eduardo.task_id_task_seq'::regclass);


--
-- TOC entry 3641 (class 2604 OID 16811)
-- Name: time_spent id_interval; Type: DEFAULT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.time_spent ALTER COLUMN id_interval SET DEFAULT nextval('eduardo.time_spent_id_interval_seq'::regclass);


--
-- TOC entry 3642 (class 2604 OID 16812)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3643 (class 2604 OID 16813)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3644 (class 2604 OID 16814)
-- Name: board id_board; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board ALTER COLUMN id_board SET DEFAULT nextval('test.board_id_board_seq'::regclass);


--
-- TOC entry 3645 (class 2604 OID 16815)
-- Name: board_objects id_object; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_objects ALTER COLUMN id_object SET DEFAULT nextval('test.board_objects_id_object_seq'::regclass);


--
-- TOC entry 3646 (class 2604 OID 16816)
-- Name: project id_project; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project ALTER COLUMN id_project SET DEFAULT nextval('test.project_id_project_seq'::regclass);


--
-- TOC entry 3649 (class 2604 OID 16817)
-- Name: state_set id_state_set; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.state_set ALTER COLUMN id_state_set SET DEFAULT nextval('test.state_set_id_state_set_seq'::regclass);


--
-- TOC entry 3654 (class 2604 OID 16818)
-- Name: tag id_tag; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.tag ALTER COLUMN id_tag SET DEFAULT nextval('test.tag_id_tag_seq'::regclass);


--
-- TOC entry 3656 (class 2604 OID 16819)
-- Name: task id_task; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task ALTER COLUMN id_task SET DEFAULT nextval('test.task_id_task_seq'::regclass);


--
-- TOC entry 3658 (class 2604 OID 16820)
-- Name: time_spent id_interval; Type: DEFAULT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.time_spent ALTER COLUMN id_interval SET DEFAULT nextval('test.time_spent_id_interval_seq'::regclass);


--
-- TOC entry 3664 (class 2606 OID 17484)
-- Name: board_objects board_objects_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_objects
    ADD CONSTRAINT board_objects_pkey PRIMARY KEY (id_object);


--
-- TOC entry 3662 (class 2606 OID 17486)
-- Name: board board_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board
    ADD CONSTRAINT board_pkey PRIMARY KEY (id_board);


--
-- TOC entry 3666 (class 2606 OID 17488)
-- Name: board_states board_states_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_states
    ADD CONSTRAINT board_states_pkey PRIMARY KEY (id_board, state_set);


--
-- TOC entry 3668 (class 2606 OID 17490)
-- Name: board_tasks_position board_tasks_position_pk; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_tasks_position
    ADD CONSTRAINT board_tasks_position_pk PRIMARY KEY (id_board, id_task);


--
-- TOC entry 3674 (class 2606 OID 17492)
-- Name: project_billing pk_billing; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_billing
    ADD CONSTRAINT pk_billing PRIMARY KEY (id_billing);


--
-- TOC entry 3738 (class 2606 OID 26248)
-- Name: epic pk_epic; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.epic
    ADD CONSTRAINT pk_epic PRIMARY KEY (id_epic);


--
-- TOC entry 3670 (class 2606 OID 17494)
-- Name: external_task pk_external_task; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.external_task
    ADD CONSTRAINT pk_external_task PRIMARY KEY (id);


--
-- TOC entry 3676 (class 2606 OID 17496)
-- Name: project_integration pk_project_integration; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_integration
    ADD CONSTRAINT pk_project_integration PRIMARY KEY (id_project, id_integration);


--
-- TOC entry 3692 (class 2606 OID 17498)
-- Name: time_spent pk_time_spent; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.time_spent
    ADD CONSTRAINT pk_time_spent PRIMARY KEY (id_interval);


--
-- TOC entry 3672 (class 2606 OID 17500)
-- Name: project project_pk; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project
    ADD CONSTRAINT project_pk PRIMARY KEY (id_project);


--
-- TOC entry 3678 (class 2606 OID 17502)
-- Name: project_tags project_tags_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_tags
    ADD CONSTRAINT project_tags_pkey PRIMARY KEY (id_project, id_tag);


--
-- TOC entry 3680 (class 2606 OID 17504)
-- Name: state state_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state);


--
-- TOC entry 3682 (class 2606 OID 17506)
-- Name: state_set state_set_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.state_set
    ADD CONSTRAINT state_set_pkey PRIMARY KEY (id_state_set);


--
-- TOC entry 3684 (class 2606 OID 17508)
-- Name: states_4_set states_4_set_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.states_4_set
    ADD CONSTRAINT states_4_set_pkey PRIMARY KEY (state_set, state);


--
-- TOC entry 3686 (class 2606 OID 17510)
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id_tag);


--
-- TOC entry 3688 (class 2606 OID 17512)
-- Name: task task_pk; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task
    ADD CONSTRAINT task_pk PRIMARY KEY (id_task);


--
-- TOC entry 3690 (class 2606 OID 17514)
-- Name: task_tags task_tags_pkey; Type: CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task_tags
    ADD CONSTRAINT task_tags_pkey PRIMARY KEY (id_task, id_tag);


--
-- TOC entry 3694 (class 2606 OID 17516)
-- Name: integration pk_integration; Type: CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.integration
    ADD CONSTRAINT pk_integration PRIMARY KEY (id_integration);


--
-- TOC entry 3696 (class 2606 OID 17518)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3698 (class 2606 OID 17520)
-- Name: roles roles_role_key; Type: CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_key UNIQUE (role);


--
-- TOC entry 3700 (class 2606 OID 17522)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY ("user", role);


--
-- TOC entry 3702 (class 2606 OID 17524)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3704 (class 2606 OID 17526)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3708 (class 2606 OID 17528)
-- Name: board_objects board_objects_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_objects
    ADD CONSTRAINT board_objects_pkey PRIMARY KEY (id_object);


--
-- TOC entry 3706 (class 2606 OID 17530)
-- Name: board board_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board
    ADD CONSTRAINT board_pkey PRIMARY KEY (id_board);


--
-- TOC entry 3710 (class 2606 OID 17532)
-- Name: board_states board_states_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_states
    ADD CONSTRAINT board_states_pkey PRIMARY KEY (id_board, state_set);


--
-- TOC entry 3712 (class 2606 OID 17534)
-- Name: board_tasks_position board_tasks_position_pk; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_tasks_position
    ADD CONSTRAINT board_tasks_position_pk PRIMARY KEY (id_board, id_task);


--
-- TOC entry 3718 (class 2606 OID 17536)
-- Name: project_billing pk_billing; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_billing
    ADD CONSTRAINT pk_billing PRIMARY KEY (id_billing);


--
-- TOC entry 3740 (class 2606 OID 26728)
-- Name: epic pk_epic; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.epic
    ADD CONSTRAINT pk_epic PRIMARY KEY (id_epic);


--
-- TOC entry 3714 (class 2606 OID 17538)
-- Name: external_task pk_external_task; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.external_task
    ADD CONSTRAINT pk_external_task PRIMARY KEY (id);


--
-- TOC entry 3720 (class 2606 OID 17540)
-- Name: project_integration pk_project_integration; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_integration
    ADD CONSTRAINT pk_project_integration PRIMARY KEY (id_project, id_integration);


--
-- TOC entry 3736 (class 2606 OID 17542)
-- Name: time_spent pk_time_spent; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.time_spent
    ADD CONSTRAINT pk_time_spent PRIMARY KEY (id_interval);


--
-- TOC entry 3716 (class 2606 OID 17544)
-- Name: project project_pk; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project
    ADD CONSTRAINT project_pk PRIMARY KEY (id_project);


--
-- TOC entry 3722 (class 2606 OID 17546)
-- Name: project_tags project_tags_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_tags
    ADD CONSTRAINT project_tags_pkey PRIMARY KEY (id_project, id_tag);


--
-- TOC entry 3724 (class 2606 OID 17548)
-- Name: state state_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state);


--
-- TOC entry 3726 (class 2606 OID 17550)
-- Name: state_set state_set_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.state_set
    ADD CONSTRAINT state_set_pkey PRIMARY KEY (id_state_set);


--
-- TOC entry 3728 (class 2606 OID 17552)
-- Name: states_4_set states_4_set_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.states_4_set
    ADD CONSTRAINT states_4_set_pkey PRIMARY KEY (state_set, state);


--
-- TOC entry 3730 (class 2606 OID 17554)
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id_tag);


--
-- TOC entry 3732 (class 2606 OID 17556)
-- Name: task task_pk; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task
    ADD CONSTRAINT task_pk PRIMARY KEY (id_task);


--
-- TOC entry 3734 (class 2606 OID 17558)
-- Name: task_tags task_tags_pkey; Type: CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task_tags
    ADD CONSTRAINT task_tags_pkey PRIMARY KEY (id_task, id_tag);


--
-- TOC entry 3746 (class 2606 OID 17559)
-- Name: board_tasks_position board_fk; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_tasks_position
    ADD CONSTRAINT board_fk FOREIGN KEY (id_board) REFERENCES eduardo.board(id_board) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3741 (class 2606 OID 17564)
-- Name: board_objects board_objects_id_board_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_objects
    ADD CONSTRAINT board_objects_id_board_fkey FOREIGN KEY (id_board) REFERENCES eduardo.board(id_board) NOT VALID;


--
-- TOC entry 3742 (class 2606 OID 17569)
-- Name: board_objects board_objects_id_project_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_objects
    ADD CONSTRAINT board_objects_id_project_fkey FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project) NOT VALID;


--
-- TOC entry 3743 (class 2606 OID 17574)
-- Name: board_objects board_objects_id_tag_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_objects
    ADD CONSTRAINT board_objects_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES eduardo.tag(id_tag) NOT VALID;


--
-- TOC entry 3744 (class 2606 OID 17579)
-- Name: board_states board_states_id_board_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_states
    ADD CONSTRAINT board_states_id_board_fkey FOREIGN KEY (id_board) REFERENCES eduardo.board(id_board) NOT VALID;


--
-- TOC entry 3745 (class 2606 OID 17584)
-- Name: board_states board_states_state_set_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_states
    ADD CONSTRAINT board_states_state_set_fkey FOREIGN KEY (state_set) REFERENCES eduardo.state_set(id_state_set) NOT VALID;


--
-- TOC entry 3750 (class 2606 OID 17589)
-- Name: project_billing fk_billing_project; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_billing
    ADD CONSTRAINT fk_billing_project FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project);


--
-- TOC entry 3787 (class 2606 OID 26254)
-- Name: epic fk_epic_project; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.epic
    ADD CONSTRAINT fk_epic_project FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project) ON DELETE CASCADE;


--
-- TOC entry 3748 (class 2606 OID 17594)
-- Name: external_task fk_external_task; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.external_task
    ADD CONSTRAINT fk_external_task FOREIGN KEY (id_task) REFERENCES eduardo.task(id_task) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3751 (class 2606 OID 17599)
-- Name: project_integration fk_prj_integration_int; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_integration
    ADD CONSTRAINT fk_prj_integration_int FOREIGN KEY (id_integration) REFERENCES public.integration(id_integration) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3752 (class 2606 OID 17604)
-- Name: project_integration fk_project_integration_prj; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_integration
    ADD CONSTRAINT fk_project_integration_prj FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project);


--
-- TOC entry 3757 (class 2606 OID 17609)
-- Name: task fk_project_task; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task
    ADD CONSTRAINT fk_project_task FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project) ON DELETE CASCADE;


--
-- TOC entry 3758 (class 2606 OID 26249)
-- Name: task fk_task_epic; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task
    ADD CONSTRAINT fk_task_epic FOREIGN KEY (id_epic) REFERENCES eduardo.epic(id_epic) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- TOC entry 3759 (class 2606 OID 17614)
-- Name: task fk_task_state; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task
    ADD CONSTRAINT fk_task_state FOREIGN KEY (state) REFERENCES eduardo.state(state) ON DELETE RESTRICT;


--
-- TOC entry 3762 (class 2606 OID 17619)
-- Name: time_spent fk_tp_task; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.time_spent
    ADD CONSTRAINT fk_tp_task FOREIGN KEY (id_task) REFERENCES eduardo.task(id_task);


--
-- TOC entry 3749 (class 2606 OID 17624)
-- Name: external_task id_project; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.external_task
    ADD CONSTRAINT id_project FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project);


--
-- TOC entry 3753 (class 2606 OID 17629)
-- Name: project_tags project_tags_id_project_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_tags
    ADD CONSTRAINT project_tags_id_project_fkey FOREIGN KEY (id_project) REFERENCES eduardo.project(id_project) NOT VALID;


--
-- TOC entry 3754 (class 2606 OID 17634)
-- Name: project_tags project_tags_id_tag_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.project_tags
    ADD CONSTRAINT project_tags_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES eduardo.tag(id_tag) NOT VALID;


--
-- TOC entry 3755 (class 2606 OID 17639)
-- Name: states_4_set states_4_set_state_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.states_4_set
    ADD CONSTRAINT states_4_set_state_fkey FOREIGN KEY (state) REFERENCES eduardo.state(state) NOT VALID;


--
-- TOC entry 3756 (class 2606 OID 17644)
-- Name: states_4_set states_4_set_state_set_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.states_4_set
    ADD CONSTRAINT states_4_set_state_set_fkey FOREIGN KEY (state_set) REFERENCES eduardo.state_set(id_state_set) NOT VALID;


--
-- TOC entry 3747 (class 2606 OID 17649)
-- Name: board_tasks_position task_fk; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.board_tasks_position
    ADD CONSTRAINT task_fk FOREIGN KEY (id_task) REFERENCES eduardo.task(id_task) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3760 (class 2606 OID 17654)
-- Name: task_tags task_tags_id_tag_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task_tags
    ADD CONSTRAINT task_tags_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES eduardo.tag(id_tag) NOT VALID;


--
-- TOC entry 3761 (class 2606 OID 17659)
-- Name: task_tags task_tags_id_task_fkey; Type: FK CONSTRAINT; Schema: eduardo; Owner: taskmaster_super
--

ALTER TABLE ONLY eduardo.task_tags
    ADD CONSTRAINT task_tags_id_task_fkey FOREIGN KEY (id_task) REFERENCES eduardo.task(id_task) NOT VALID;


--
-- TOC entry 3763 (class 2606 OID 17664)
-- Name: user_roles user_roles_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_fkey FOREIGN KEY (role) REFERENCES public.roles(id);


--
-- TOC entry 3764 (class 2606 OID 17669)
-- Name: user_roles user_roles_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taskmaster_super
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- TOC entry 3770 (class 2606 OID 17674)
-- Name: board_tasks_position board_fk; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_tasks_position
    ADD CONSTRAINT board_fk FOREIGN KEY (id_board) REFERENCES test.board(id_board) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3765 (class 2606 OID 17679)
-- Name: board_objects board_objects_id_board_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_objects
    ADD CONSTRAINT board_objects_id_board_fkey FOREIGN KEY (id_board) REFERENCES test.board(id_board) NOT VALID;


--
-- TOC entry 3766 (class 2606 OID 17684)
-- Name: board_objects board_objects_id_project_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_objects
    ADD CONSTRAINT board_objects_id_project_fkey FOREIGN KEY (id_project) REFERENCES test.project(id_project) NOT VALID;


--
-- TOC entry 3767 (class 2606 OID 17689)
-- Name: board_objects board_objects_id_tag_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_objects
    ADD CONSTRAINT board_objects_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES test.tag(id_tag) NOT VALID;


--
-- TOC entry 3768 (class 2606 OID 17694)
-- Name: board_states board_states_id_board_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_states
    ADD CONSTRAINT board_states_id_board_fkey FOREIGN KEY (id_board) REFERENCES test.board(id_board) NOT VALID;


--
-- TOC entry 3769 (class 2606 OID 17699)
-- Name: board_states board_states_state_set_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_states
    ADD CONSTRAINT board_states_state_set_fkey FOREIGN KEY (state_set) REFERENCES test.state_set(id_state_set) NOT VALID;


--
-- TOC entry 3774 (class 2606 OID 17704)
-- Name: project_billing fk_billing_project; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_billing
    ADD CONSTRAINT fk_billing_project FOREIGN KEY (id_project) REFERENCES test.project(id_project);


--
-- TOC entry 3788 (class 2606 OID 26734)
-- Name: epic fk_epic_project; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.epic
    ADD CONSTRAINT fk_epic_project FOREIGN KEY (id_project) REFERENCES test.project(id_project) ON DELETE CASCADE;


--
-- TOC entry 3772 (class 2606 OID 17709)
-- Name: external_task fk_external_task; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.external_task
    ADD CONSTRAINT fk_external_task FOREIGN KEY (id_task) REFERENCES test.task(id_task) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3775 (class 2606 OID 17714)
-- Name: project_integration fk_prj_integration_int; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_integration
    ADD CONSTRAINT fk_prj_integration_int FOREIGN KEY (id_integration) REFERENCES public.integration(id_integration) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3776 (class 2606 OID 17719)
-- Name: project_integration fk_project_integration_prj; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_integration
    ADD CONSTRAINT fk_project_integration_prj FOREIGN KEY (id_project) REFERENCES test.project(id_project);


--
-- TOC entry 3781 (class 2606 OID 17724)
-- Name: task fk_project_task; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task
    ADD CONSTRAINT fk_project_task FOREIGN KEY (id_project) REFERENCES test.project(id_project) ON DELETE CASCADE;


--
-- TOC entry 3782 (class 2606 OID 26729)
-- Name: task fk_task_epic; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task
    ADD CONSTRAINT fk_task_epic FOREIGN KEY (id_epic) REFERENCES test.epic(id_epic) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- TOC entry 3783 (class 2606 OID 17729)
-- Name: task fk_task_state; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task
    ADD CONSTRAINT fk_task_state FOREIGN KEY (state) REFERENCES test.state(state) ON DELETE RESTRICT;


--
-- TOC entry 3786 (class 2606 OID 17734)
-- Name: time_spent fk_tp_task; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.time_spent
    ADD CONSTRAINT fk_tp_task FOREIGN KEY (id_task) REFERENCES test.task(id_task);


--
-- TOC entry 3773 (class 2606 OID 17739)
-- Name: external_task id_project; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.external_task
    ADD CONSTRAINT id_project FOREIGN KEY (id_project) REFERENCES test.project(id_project);


--
-- TOC entry 3777 (class 2606 OID 17744)
-- Name: project_tags project_tags_id_project_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_tags
    ADD CONSTRAINT project_tags_id_project_fkey FOREIGN KEY (id_project) REFERENCES test.project(id_project) NOT VALID;


--
-- TOC entry 3778 (class 2606 OID 17749)
-- Name: project_tags project_tags_id_tag_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.project_tags
    ADD CONSTRAINT project_tags_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES test.tag(id_tag) NOT VALID;


--
-- TOC entry 3779 (class 2606 OID 17754)
-- Name: states_4_set states_4_set_state_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.states_4_set
    ADD CONSTRAINT states_4_set_state_fkey FOREIGN KEY (state) REFERENCES test.state(state) NOT VALID;


--
-- TOC entry 3780 (class 2606 OID 17759)
-- Name: states_4_set states_4_set_state_set_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.states_4_set
    ADD CONSTRAINT states_4_set_state_set_fkey FOREIGN KEY (state_set) REFERENCES test.state_set(id_state_set) NOT VALID;


--
-- TOC entry 3771 (class 2606 OID 17764)
-- Name: board_tasks_position task_fk; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.board_tasks_position
    ADD CONSTRAINT task_fk FOREIGN KEY (id_task) REFERENCES test.task(id_task) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3784 (class 2606 OID 17769)
-- Name: task_tags task_tags_id_tag_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task_tags
    ADD CONSTRAINT task_tags_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES test.tag(id_tag) NOT VALID;


--
-- TOC entry 3785 (class 2606 OID 17774)
-- Name: task_tags task_tags_id_task_fkey; Type: FK CONSTRAINT; Schema: test; Owner: taskmaster_super
--

ALTER TABLE ONLY test.task_tags
    ADD CONSTRAINT task_tags_id_task_fkey FOREIGN KEY (id_task) REFERENCES test.task(id_task) NOT VALID;


--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE v_task_time_spent; Type: ACL; Schema: eduardo; Owner: eduardo
--

GRANT SELECT ON TABLE eduardo.v_task_time_spent TO taskmaster_svc;


--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE v_task_time_spent_per_day; Type: ACL; Schema: eduardo; Owner: eduardo
--

GRANT SELECT ON TABLE eduardo.v_task_time_spent_per_day TO taskmaster_svc;


--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE v_task_time_spent; Type: ACL; Schema: test; Owner: eduardo
--

GRANT SELECT ON TABLE test.v_task_time_spent TO taskmaster_svc;


--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE v_task_time_spent_per_day; Type: ACL; Schema: test; Owner: eduardo
--

GRANT SELECT ON TABLE test.v_task_time_spent_per_day TO taskmaster_svc;


-- Completed on 2025-03-01 19:59:40 CST

--
-- PostgreSQL database dump complete
--

