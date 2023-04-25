
/* DATABASE */
-- CREATE DATABASE IF NOT EXISTS stockpricer;

/* 作成したDBに移動 */
\c stockpricer

/* SCHEMA */
DROP SCHEMA IF EXISTS main;

CREATE SCHEMA IF NOT EXISTS main
    AUTHORIZATION kawauso;


--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

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
-- Name: main; Type: SCHEMA; Schema: -; Owner: kawauso
--

-- CREATE SCHEMA main;


ALTER SCHEMA main OWNER TO kawauso;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: m_calendar; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.m_calendar (
    date character varying(8) NOT NULL,
    date_of_week character varying(1) NOT NULL,
    today_flg character varying(1) NOT NULL,
    remarks character varying(1000) NOT NULL,
    holiday_flg character varying(1) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.m_calendar OWNER TO kawauso;

--
-- Name: m_industry_scale; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.m_industry_scale (
    total_industry_code character varying(8) NOT NULL,
    total_industry_segment character varying(20) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    sub_industry_segment character varying(20) NOT NULL,
    scale_code character varying(3) NOT NULL,
    scale_segment character varying(20) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.m_industry_scale OWNER TO kawauso;

--
-- Name: m_market; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.m_market (
    market_code character varying(10) NOT NULL,
    market_name character varying(50) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    market_segment character varying(50) NOT NULL,
    market_stock_code character varying(4) NOT NULL,
    market_stock_code_api character varying(4),
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.m_market OWNER TO kawauso;

--
-- Name: m_message; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.m_message (
    message_code character varying(20) NOT NULL,
    messege_content character varying(1000) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.m_message OWNER TO kawauso;

--
-- Name: m_setting_info; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.m_setting_info (
    info_id character varying(100) NOT NULL,
    info_name character varying(100) NOT NULL,
    info_value character varying(200) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.m_setting_info OWNER TO kawauso;

--
-- Name: m_user; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.m_user (
    user_id character varying(20) NOT NULL,
    password character varying(64) NOT NULL,
    misinput_cnt numeric(1,0) NOT NULL,
    first_reg character varying(64) NOT NULL,
    second_reg character varying(64) NOT NULL,
    pwupdate_date timestamp without time zone NOT NULL,
    user_name character varying(50) NOT NULL,
    authorize_group_cd character varying(20) NOT NULL,
    valid_kbn character varying(1) NOT NULL,
    remarks character varying(1000) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.m_user OWNER TO kawauso;

--
-- Name: t_stock_data; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
)
PARTITION BY RANGE (base_date);


ALTER TABLE main.t_stock_data OWNER TO kawauso;

--
-- Name: st_stock_list_v; Type: VIEW; Schema: main; Owner: kawauso
--

CREATE VIEW main.st_stock_list_v AS
 SELECT tsd.base_date,
    tsd.stock_code,
    tsd.stock_name,
    tsd.market_code,
    tsd.market_segment_code,
    concat(tsd.stock_code, mm.market_stock_code_api) AS stock_code_api
   FROM (main.t_stock_data tsd
     LEFT JOIN main.m_market mm ON ((((tsd.market_code)::text = (mm.market_code)::text) AND ((tsd.market_segment_code)::text = (mm.market_segment_code)::text))))
  WHERE (((tsd.delete_flg)::text = '0'::text) AND ((mm.delete_flg)::text = '0'::text));


ALTER TABLE main.st_stock_list_v OWNER TO kawauso;

--
-- Name: t_stock_data_2011; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2011 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2011 FOR VALUES FROM ('20110101') TO ('20120101');


ALTER TABLE main.t_stock_data_2011 OWNER TO kawauso;

--
-- Name: t_stock_data_2012; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2012 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2012 FOR VALUES FROM ('20120101') TO ('20130101');


ALTER TABLE main.t_stock_data_2012 OWNER TO kawauso;

--
-- Name: t_stock_data_2013; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2013 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2013 FOR VALUES FROM ('20130101') TO ('20140101');


ALTER TABLE main.t_stock_data_2013 OWNER TO kawauso;

--
-- Name: t_stock_data_2014; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2014 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2014 FOR VALUES FROM ('20140101') TO ('20150101');


ALTER TABLE main.t_stock_data_2014 OWNER TO kawauso;

--
-- Name: t_stock_data_2015; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2015 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2015 FOR VALUES FROM ('20150101') TO ('20160101');


ALTER TABLE main.t_stock_data_2015 OWNER TO kawauso;

--
-- Name: t_stock_data_2016; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2016 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2016 FOR VALUES FROM ('20160101') TO ('20170101');


ALTER TABLE main.t_stock_data_2016 OWNER TO kawauso;

--
-- Name: t_stock_data_2017; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2017 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2017 FOR VALUES FROM ('20170101') TO ('20180101');


ALTER TABLE main.t_stock_data_2017 OWNER TO kawauso;

--
-- Name: t_stock_data_2018; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2018 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2018 FOR VALUES FROM ('20180101') TO ('20190101');


ALTER TABLE main.t_stock_data_2018 OWNER TO kawauso;

--
-- Name: t_stock_data_2019; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2019 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2019 FOR VALUES FROM ('20190101') TO ('20200101');


ALTER TABLE main.t_stock_data_2019 OWNER TO kawauso;

--
-- Name: t_stock_data_2020; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2020 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2020 FOR VALUES FROM ('20200101') TO ('20210101');


ALTER TABLE main.t_stock_data_2020 OWNER TO kawauso;

--
-- Name: t_stock_data_2021; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2021 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2021 FOR VALUES FROM ('20210101') TO ('20220101');


ALTER TABLE main.t_stock_data_2021 OWNER TO kawauso;

--
-- Name: t_stock_data_2022; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2022 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2022 FOR VALUES FROM ('20220101') TO ('20230101');


ALTER TABLE main.t_stock_data_2022 OWNER TO kawauso;

--
-- Name: t_stock_data_2023; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2023 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2023 FOR VALUES FROM ('20230101') TO ('20240101');


ALTER TABLE main.t_stock_data_2023 OWNER TO kawauso;

--
-- Name: t_stock_data_2024; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2024 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2024 FOR VALUES FROM ('20240101') TO ('20250101');


ALTER TABLE main.t_stock_data_2024 OWNER TO kawauso;

--
-- Name: t_stock_data_2025; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2025 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2025 FOR VALUES FROM ('20250101') TO ('20260101');


ALTER TABLE main.t_stock_data_2025 OWNER TO kawauso;

--
-- Name: t_stock_data_2026; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2026 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2026 FOR VALUES FROM ('20260101') TO ('20270101');


ALTER TABLE main.t_stock_data_2026 OWNER TO kawauso;

--
-- Name: t_stock_data_2027; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2027 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2027 FOR VALUES FROM ('20270101') TO ('20280101');


ALTER TABLE main.t_stock_data_2027 OWNER TO kawauso;

--
-- Name: t_stock_data_2028; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2028 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2028 FOR VALUES FROM ('20280101') TO ('20290101');


ALTER TABLE main.t_stock_data_2028 OWNER TO kawauso;

--
-- Name: t_stock_data_2029; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2029 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2029 FOR VALUES FROM ('20290101') TO ('20300101');


ALTER TABLE main.t_stock_data_2029 OWNER TO kawauso;

--
-- Name: t_stock_data_2030; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2030 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2030 FOR VALUES FROM ('20300101') TO ('20310101');


ALTER TABLE main.t_stock_data_2030 OWNER TO kawauso;

--
-- Name: t_stock_data_2031; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2031 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2031 FOR VALUES FROM ('20310101') TO ('20320101');


ALTER TABLE main.t_stock_data_2031 OWNER TO kawauso;

--
-- Name: t_stock_data_2032; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2032 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2032 FOR VALUES FROM ('20320101') TO ('20330101');


ALTER TABLE main.t_stock_data_2032 OWNER TO kawauso;

--
-- Name: t_stock_data_2033; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2033 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2033 FOR VALUES FROM ('20330101') TO ('20340101');


ALTER TABLE main.t_stock_data_2033 OWNER TO kawauso;

--
-- Name: t_stock_data_2034; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2034 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2034 FOR VALUES FROM ('20340101') TO ('20350101');


ALTER TABLE main.t_stock_data_2034 OWNER TO kawauso;

--
-- Name: t_stock_data_2035; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2035 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2035 FOR VALUES FROM ('20350101') TO ('20360101');


ALTER TABLE main.t_stock_data_2035 OWNER TO kawauso;

--
-- Name: t_stock_data_2036; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2036 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2036 FOR VALUES FROM ('20360101') TO ('20370101');


ALTER TABLE main.t_stock_data_2036 OWNER TO kawauso;

--
-- Name: t_stock_data_2037; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2037 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2037 FOR VALUES FROM ('20370101') TO ('20380101');


ALTER TABLE main.t_stock_data_2037 OWNER TO kawauso;

--
-- Name: t_stock_data_2038; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2038 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2038 FOR VALUES FROM ('20380101') TO ('20390101');


ALTER TABLE main.t_stock_data_2038 OWNER TO kawauso;

--
-- Name: t_stock_data_2039; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2039 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2039 FOR VALUES FROM ('20390101') TO ('20400101');


ALTER TABLE main.t_stock_data_2039 OWNER TO kawauso;

--
-- Name: t_stock_data_2040; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2040 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2040 FOR VALUES FROM ('20400101') TO ('20410101');


ALTER TABLE main.t_stock_data_2040 OWNER TO kawauso;

--
-- Name: t_stock_data_2041; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2041 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2041 FOR VALUES FROM ('20410101') TO ('20420101');


ALTER TABLE main.t_stock_data_2041 OWNER TO kawauso;

--
-- Name: t_stock_data_2042; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2042 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2042 FOR VALUES FROM ('20420101') TO ('20430101');


ALTER TABLE main.t_stock_data_2042 OWNER TO kawauso;

--
-- Name: t_stock_data_2043; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2043 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2043 FOR VALUES FROM ('20430101') TO ('20440101');


ALTER TABLE main.t_stock_data_2043 OWNER TO kawauso;

--
-- Name: t_stock_data_2044; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2044 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2044 FOR VALUES FROM ('20440101') TO ('20450101');


ALTER TABLE main.t_stock_data_2044 OWNER TO kawauso;

--
-- Name: t_stock_data_2045; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2045 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2045 FOR VALUES FROM ('20450101') TO ('20460101');


ALTER TABLE main.t_stock_data_2045 OWNER TO kawauso;

--
-- Name: t_stock_data_2046; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2046 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2046 FOR VALUES FROM ('20460101') TO ('20470101');


ALTER TABLE main.t_stock_data_2046 OWNER TO kawauso;

--
-- Name: t_stock_data_2047; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2047 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2047 FOR VALUES FROM ('20470101') TO ('20480101');


ALTER TABLE main.t_stock_data_2047 OWNER TO kawauso;

--
-- Name: t_stock_data_2048; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2048 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2048 FOR VALUES FROM ('20480101') TO ('20490101');


ALTER TABLE main.t_stock_data_2048 OWNER TO kawauso;

--
-- Name: t_stock_data_2049; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2049 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2049 FOR VALUES FROM ('20490101') TO ('20500101');


ALTER TABLE main.t_stock_data_2049 OWNER TO kawauso;

--
-- Name: t_stock_data_2050; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2050 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2050 FOR VALUES FROM ('20500101') TO ('20510101');


ALTER TABLE main.t_stock_data_2050 OWNER TO kawauso;

--
-- Name: t_stock_data_2051; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2051 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2051 FOR VALUES FROM ('20510101') TO ('20520101');


ALTER TABLE main.t_stock_data_2051 OWNER TO kawauso;

--
-- Name: t_stock_data_2052; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2052 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2052 FOR VALUES FROM ('20520101') TO ('20530101');


ALTER TABLE main.t_stock_data_2052 OWNER TO kawauso;

--
-- Name: t_stock_data_2053; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2053 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2053 FOR VALUES FROM ('20530101') TO ('20540101');


ALTER TABLE main.t_stock_data_2053 OWNER TO kawauso;

--
-- Name: t_stock_data_2054; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2054 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2054 FOR VALUES FROM ('20540101') TO ('20550101');


ALTER TABLE main.t_stock_data_2054 OWNER TO kawauso;

--
-- Name: t_stock_data_2055; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2055 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2055 FOR VALUES FROM ('20550101') TO ('20560101');


ALTER TABLE main.t_stock_data_2055 OWNER TO kawauso;

--
-- Name: t_stock_data_2056; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.t_stock_data_2056 (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_code character varying(10) NOT NULL,
    market_segment_code character varying(8) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    scale_code character varying(3) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.t_stock_data ATTACH PARTITION main.t_stock_data_2056 FOR VALUES FROM ('20560101') TO ('20570101');


ALTER TABLE main.t_stock_data_2056 OWNER TO kawauso;

--
-- Name: w_market_price_data; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
)
PARTITION BY RANGE (insert_date);


ALTER TABLE main.w_market_price_data OWNER TO kawauso;

--
-- Name: w_market_price_data_2011; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2011 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2011 FOR VALUES FROM ('20110101') TO ('20120101');


ALTER TABLE main.w_market_price_data_2011 OWNER TO kawauso;

--
-- Name: w_market_price_data_2012; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2012 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2012 FOR VALUES FROM ('20120101') TO ('20130101');


ALTER TABLE main.w_market_price_data_2012 OWNER TO kawauso;

--
-- Name: w_market_price_data_2013; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2013 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2013 FOR VALUES FROM ('20130101') TO ('20140101');


ALTER TABLE main.w_market_price_data_2013 OWNER TO kawauso;

--
-- Name: w_market_price_data_2014; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2014 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2014 FOR VALUES FROM ('20140101') TO ('20150101');


ALTER TABLE main.w_market_price_data_2014 OWNER TO kawauso;

--
-- Name: w_market_price_data_2015; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2015 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2015 FOR VALUES FROM ('20150101') TO ('20160101');


ALTER TABLE main.w_market_price_data_2015 OWNER TO kawauso;

--
-- Name: w_market_price_data_2016; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2016 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2016 FOR VALUES FROM ('20160101') TO ('20170101');


ALTER TABLE main.w_market_price_data_2016 OWNER TO kawauso;

--
-- Name: w_market_price_data_2017; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2017 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2017 FOR VALUES FROM ('20170101') TO ('20180101');


ALTER TABLE main.w_market_price_data_2017 OWNER TO kawauso;

--
-- Name: w_market_price_data_2018; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2018 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2018 FOR VALUES FROM ('20180101') TO ('20190101');


ALTER TABLE main.w_market_price_data_2018 OWNER TO kawauso;

--
-- Name: w_market_price_data_2019; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2019 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2019 FOR VALUES FROM ('20190101') TO ('20200101');


ALTER TABLE main.w_market_price_data_2019 OWNER TO kawauso;

--
-- Name: w_market_price_data_2020; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2020 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2020 FOR VALUES FROM ('20200101') TO ('20210101');


ALTER TABLE main.w_market_price_data_2020 OWNER TO kawauso;

--
-- Name: w_market_price_data_2021; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2021 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2021 FOR VALUES FROM ('20210101') TO ('20220101');


ALTER TABLE main.w_market_price_data_2021 OWNER TO kawauso;

--
-- Name: w_market_price_data_2022; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2022 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2022 FOR VALUES FROM ('20220101') TO ('20230101');


ALTER TABLE main.w_market_price_data_2022 OWNER TO kawauso;

--
-- Name: w_market_price_data_2023; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2023 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2023 FOR VALUES FROM ('20230101') TO ('20240101');


ALTER TABLE main.w_market_price_data_2023 OWNER TO kawauso;

--
-- Name: w_market_price_data_2024; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2024 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2024 FOR VALUES FROM ('20240101') TO ('20250101');


ALTER TABLE main.w_market_price_data_2024 OWNER TO kawauso;

--
-- Name: w_market_price_data_2025; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2025 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2025 FOR VALUES FROM ('20250101') TO ('20260101');


ALTER TABLE main.w_market_price_data_2025 OWNER TO kawauso;

--
-- Name: w_market_price_data_2026; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2026 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2026 FOR VALUES FROM ('20260101') TO ('20270101');


ALTER TABLE main.w_market_price_data_2026 OWNER TO kawauso;

--
-- Name: w_market_price_data_2027; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2027 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2027 FOR VALUES FROM ('20270101') TO ('20280101');


ALTER TABLE main.w_market_price_data_2027 OWNER TO kawauso;

--
-- Name: w_market_price_data_2028; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2028 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2028 FOR VALUES FROM ('20280101') TO ('20290101');


ALTER TABLE main.w_market_price_data_2028 OWNER TO kawauso;

--
-- Name: w_market_price_data_2029; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2029 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2029 FOR VALUES FROM ('20290101') TO ('20300101');


ALTER TABLE main.w_market_price_data_2029 OWNER TO kawauso;

--
-- Name: w_market_price_data_2030; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2030 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2030 FOR VALUES FROM ('20300101') TO ('20310101');


ALTER TABLE main.w_market_price_data_2030 OWNER TO kawauso;

--
-- Name: w_market_price_data_2031; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2031 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2031 FOR VALUES FROM ('20310101') TO ('20320101');


ALTER TABLE main.w_market_price_data_2031 OWNER TO kawauso;

--
-- Name: w_market_price_data_2032; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2032 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2032 FOR VALUES FROM ('20320101') TO ('20330101');


ALTER TABLE main.w_market_price_data_2032 OWNER TO kawauso;

--
-- Name: w_market_price_data_2033; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2033 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2033 FOR VALUES FROM ('20330101') TO ('20340101');


ALTER TABLE main.w_market_price_data_2033 OWNER TO kawauso;

--
-- Name: w_market_price_data_2034; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2034 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2034 FOR VALUES FROM ('20340101') TO ('20350101');


ALTER TABLE main.w_market_price_data_2034 OWNER TO kawauso;

--
-- Name: w_market_price_data_2035; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2035 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2035 FOR VALUES FROM ('20350101') TO ('20360101');


ALTER TABLE main.w_market_price_data_2035 OWNER TO kawauso;

--
-- Name: w_market_price_data_2036; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2036 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2036 FOR VALUES FROM ('20360101') TO ('20370101');


ALTER TABLE main.w_market_price_data_2036 OWNER TO kawauso;

--
-- Name: w_market_price_data_2037; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2037 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2037 FOR VALUES FROM ('20370101') TO ('20380101');


ALTER TABLE main.w_market_price_data_2037 OWNER TO kawauso;

--
-- Name: w_market_price_data_2038; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2038 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2038 FOR VALUES FROM ('20380101') TO ('20390101');


ALTER TABLE main.w_market_price_data_2038 OWNER TO kawauso;

--
-- Name: w_market_price_data_2039; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2039 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2039 FOR VALUES FROM ('20390101') TO ('20400101');


ALTER TABLE main.w_market_price_data_2039 OWNER TO kawauso;

--
-- Name: w_market_price_data_2040; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2040 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2040 FOR VALUES FROM ('20400101') TO ('20410101');


ALTER TABLE main.w_market_price_data_2040 OWNER TO kawauso;

--
-- Name: w_market_price_data_2041; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2041 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2041 FOR VALUES FROM ('20410101') TO ('20420101');


ALTER TABLE main.w_market_price_data_2041 OWNER TO kawauso;

--
-- Name: w_market_price_data_2042; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2042 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2042 FOR VALUES FROM ('20420101') TO ('20430101');


ALTER TABLE main.w_market_price_data_2042 OWNER TO kawauso;

--
-- Name: w_market_price_data_2043; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2043 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2043 FOR VALUES FROM ('20430101') TO ('20440101');


ALTER TABLE main.w_market_price_data_2043 OWNER TO kawauso;

--
-- Name: w_market_price_data_2044; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2044 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2044 FOR VALUES FROM ('20440101') TO ('20450101');


ALTER TABLE main.w_market_price_data_2044 OWNER TO kawauso;

--
-- Name: w_market_price_data_2045; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2045 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2045 FOR VALUES FROM ('20450101') TO ('20460101');


ALTER TABLE main.w_market_price_data_2045 OWNER TO kawauso;

--
-- Name: w_market_price_data_2046; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2046 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2046 FOR VALUES FROM ('20460101') TO ('20470101');


ALTER TABLE main.w_market_price_data_2046 OWNER TO kawauso;

--
-- Name: w_market_price_data_2047; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2047 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2047 FOR VALUES FROM ('20470101') TO ('20480101');


ALTER TABLE main.w_market_price_data_2047 OWNER TO kawauso;

--
-- Name: w_market_price_data_2048; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2048 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2048 FOR VALUES FROM ('20480101') TO ('20490101');


ALTER TABLE main.w_market_price_data_2048 OWNER TO kawauso;

--
-- Name: w_market_price_data_2049; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2049 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2049 FOR VALUES FROM ('20490101') TO ('20500101');


ALTER TABLE main.w_market_price_data_2049 OWNER TO kawauso;

--
-- Name: w_market_price_data_2050; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2050 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2050 FOR VALUES FROM ('20500101') TO ('20510101');


ALTER TABLE main.w_market_price_data_2050 OWNER TO kawauso;

--
-- Name: w_market_price_data_2051; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2051 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2051 FOR VALUES FROM ('20510101') TO ('20520101');


ALTER TABLE main.w_market_price_data_2051 OWNER TO kawauso;

--
-- Name: w_market_price_data_2052; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2052 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2052 FOR VALUES FROM ('20520101') TO ('20530101');


ALTER TABLE main.w_market_price_data_2052 OWNER TO kawauso;

--
-- Name: w_market_price_data_2053; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2053 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2053 FOR VALUES FROM ('20530101') TO ('20540101');


ALTER TABLE main.w_market_price_data_2053 OWNER TO kawauso;

--
-- Name: w_market_price_data_2054; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2054 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2054 FOR VALUES FROM ('20540101') TO ('20550101');


ALTER TABLE main.w_market_price_data_2054 OWNER TO kawauso;

--
-- Name: w_market_price_data_2055; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2055 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2055 FOR VALUES FROM ('20550101') TO ('20560101');


ALTER TABLE main.w_market_price_data_2055 OWNER TO kawauso;

--
-- Name: w_market_price_data_2056; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_market_price_data_2056 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.w_market_price_data ATTACH PARTITION main.w_market_price_data_2056 FOR VALUES FROM ('20560101') TO ('20570101');


ALTER TABLE main.w_market_price_data_2056 OWNER TO kawauso;

--
-- Name: w_stock_data_jpx; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.w_stock_data_jpx (
    base_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_name character varying(200) NOT NULL,
    market_segment character varying(50) NOT NULL,
    total_industry_code character varying(8) NOT NULL,
    total_industry_segment character varying(20) NOT NULL,
    sub_industry_code character varying(5) NOT NULL,
    sub_industry_segment character varying(20) NOT NULL,
    scale_code character varying(3) NOT NULL,
    scale_segment character varying(20) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);


ALTER TABLE main.w_stock_data_jpx OWNER TO kawauso;

--
-- Name: y_market_price_data; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
)
PARTITION BY RANGE (insert_date);


ALTER TABLE main.y_market_price_data OWNER TO kawauso;

--
-- Name: y_market_price_data_2011; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2011 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2011 FOR VALUES FROM ('20110101') TO ('20120101');


ALTER TABLE main.y_market_price_data_2011 OWNER TO kawauso;

--
-- Name: y_market_price_data_2012; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2012 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2012 FOR VALUES FROM ('20120101') TO ('20130101');


ALTER TABLE main.y_market_price_data_2012 OWNER TO kawauso;

--
-- Name: y_market_price_data_2013; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2013 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2013 FOR VALUES FROM ('20130101') TO ('20140101');


ALTER TABLE main.y_market_price_data_2013 OWNER TO kawauso;

--
-- Name: y_market_price_data_2014; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2014 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2014 FOR VALUES FROM ('20140101') TO ('20150101');


ALTER TABLE main.y_market_price_data_2014 OWNER TO kawauso;

--
-- Name: y_market_price_data_2015; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2015 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2015 FOR VALUES FROM ('20150101') TO ('20160101');


ALTER TABLE main.y_market_price_data_2015 OWNER TO kawauso;

--
-- Name: y_market_price_data_2016; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2016 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2016 FOR VALUES FROM ('20160101') TO ('20170101');


ALTER TABLE main.y_market_price_data_2016 OWNER TO kawauso;

--
-- Name: y_market_price_data_2017; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2017 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2017 FOR VALUES FROM ('20170101') TO ('20180101');


ALTER TABLE main.y_market_price_data_2017 OWNER TO kawauso;

--
-- Name: y_market_price_data_2018; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2018 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2018 FOR VALUES FROM ('20180101') TO ('20190101');


ALTER TABLE main.y_market_price_data_2018 OWNER TO kawauso;

--
-- Name: y_market_price_data_2019; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2019 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2019 FOR VALUES FROM ('20190101') TO ('20200101');


ALTER TABLE main.y_market_price_data_2019 OWNER TO kawauso;

--
-- Name: y_market_price_data_2020; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2020 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2020 FOR VALUES FROM ('20200101') TO ('20210101');


ALTER TABLE main.y_market_price_data_2020 OWNER TO kawauso;

--
-- Name: y_market_price_data_2021; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2021 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2021 FOR VALUES FROM ('20210101') TO ('20220101');


ALTER TABLE main.y_market_price_data_2021 OWNER TO kawauso;

--
-- Name: y_market_price_data_2022; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2022 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2022 FOR VALUES FROM ('20220101') TO ('20230101');


ALTER TABLE main.y_market_price_data_2022 OWNER TO kawauso;

--
-- Name: y_market_price_data_2023; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2023 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2023 FOR VALUES FROM ('20230101') TO ('20240101');


ALTER TABLE main.y_market_price_data_2023 OWNER TO kawauso;

--
-- Name: y_market_price_data_2024; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2024 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2024 FOR VALUES FROM ('20240101') TO ('20250101');


ALTER TABLE main.y_market_price_data_2024 OWNER TO kawauso;

--
-- Name: y_market_price_data_2025; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2025 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2025 FOR VALUES FROM ('20250101') TO ('20260101');


ALTER TABLE main.y_market_price_data_2025 OWNER TO kawauso;

--
-- Name: y_market_price_data_2026; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2026 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2026 FOR VALUES FROM ('20260101') TO ('20270101');


ALTER TABLE main.y_market_price_data_2026 OWNER TO kawauso;

--
-- Name: y_market_price_data_2027; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2027 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2027 FOR VALUES FROM ('20270101') TO ('20280101');


ALTER TABLE main.y_market_price_data_2027 OWNER TO kawauso;

--
-- Name: y_market_price_data_2028; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2028 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2028 FOR VALUES FROM ('20280101') TO ('20290101');


ALTER TABLE main.y_market_price_data_2028 OWNER TO kawauso;

--
-- Name: y_market_price_data_2029; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2029 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2029 FOR VALUES FROM ('20290101') TO ('20300101');


ALTER TABLE main.y_market_price_data_2029 OWNER TO kawauso;

--
-- Name: y_market_price_data_2030; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2030 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2030 FOR VALUES FROM ('20300101') TO ('20310101');


ALTER TABLE main.y_market_price_data_2030 OWNER TO kawauso;

--
-- Name: y_market_price_data_2031; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2031 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2031 FOR VALUES FROM ('20310101') TO ('20320101');


ALTER TABLE main.y_market_price_data_2031 OWNER TO kawauso;

--
-- Name: y_market_price_data_2032; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2032 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2032 FOR VALUES FROM ('20320101') TO ('20330101');


ALTER TABLE main.y_market_price_data_2032 OWNER TO kawauso;

--
-- Name: y_market_price_data_2033; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2033 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2033 FOR VALUES FROM ('20330101') TO ('20340101');


ALTER TABLE main.y_market_price_data_2033 OWNER TO kawauso;

--
-- Name: y_market_price_data_2034; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2034 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2034 FOR VALUES FROM ('20340101') TO ('20350101');


ALTER TABLE main.y_market_price_data_2034 OWNER TO kawauso;

--
-- Name: y_market_price_data_2035; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2035 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2035 FOR VALUES FROM ('20350101') TO ('20360101');


ALTER TABLE main.y_market_price_data_2035 OWNER TO kawauso;

--
-- Name: y_market_price_data_2036; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2036 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2036 FOR VALUES FROM ('20360101') TO ('20370101');


ALTER TABLE main.y_market_price_data_2036 OWNER TO kawauso;

--
-- Name: y_market_price_data_2037; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2037 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2037 FOR VALUES FROM ('20370101') TO ('20380101');


ALTER TABLE main.y_market_price_data_2037 OWNER TO kawauso;

--
-- Name: y_market_price_data_2038; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2038 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2038 FOR VALUES FROM ('20380101') TO ('20390101');


ALTER TABLE main.y_market_price_data_2038 OWNER TO kawauso;

--
-- Name: y_market_price_data_2039; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2039 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2039 FOR VALUES FROM ('20390101') TO ('20400101');


ALTER TABLE main.y_market_price_data_2039 OWNER TO kawauso;

--
-- Name: y_market_price_data_2040; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2040 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2040 FOR VALUES FROM ('20400101') TO ('20410101');


ALTER TABLE main.y_market_price_data_2040 OWNER TO kawauso;

--
-- Name: y_market_price_data_2041; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2041 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2041 FOR VALUES FROM ('20410101') TO ('20420101');


ALTER TABLE main.y_market_price_data_2041 OWNER TO kawauso;

--
-- Name: y_market_price_data_2042; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2042 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2042 FOR VALUES FROM ('20420101') TO ('20430101');


ALTER TABLE main.y_market_price_data_2042 OWNER TO kawauso;

--
-- Name: y_market_price_data_2043; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2043 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2043 FOR VALUES FROM ('20430101') TO ('20440101');


ALTER TABLE main.y_market_price_data_2043 OWNER TO kawauso;

--
-- Name: y_market_price_data_2044; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2044 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2044 FOR VALUES FROM ('20440101') TO ('20450101');


ALTER TABLE main.y_market_price_data_2044 OWNER TO kawauso;

--
-- Name: y_market_price_data_2045; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2045 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2045 FOR VALUES FROM ('20450101') TO ('20460101');


ALTER TABLE main.y_market_price_data_2045 OWNER TO kawauso;

--
-- Name: y_market_price_data_2046; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2046 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2046 FOR VALUES FROM ('20460101') TO ('20470101');


ALTER TABLE main.y_market_price_data_2046 OWNER TO kawauso;

--
-- Name: y_market_price_data_2047; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2047 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2047 FOR VALUES FROM ('20470101') TO ('20480101');


ALTER TABLE main.y_market_price_data_2047 OWNER TO kawauso;

--
-- Name: y_market_price_data_2048; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2048 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2048 FOR VALUES FROM ('20480101') TO ('20490101');


ALTER TABLE main.y_market_price_data_2048 OWNER TO kawauso;

--
-- Name: y_market_price_data_2049; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2049 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2049 FOR VALUES FROM ('20490101') TO ('20500101');


ALTER TABLE main.y_market_price_data_2049 OWNER TO kawauso;

--
-- Name: y_market_price_data_2050; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2050 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2050 FOR VALUES FROM ('20500101') TO ('20510101');


ALTER TABLE main.y_market_price_data_2050 OWNER TO kawauso;

--
-- Name: y_market_price_data_2051; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2051 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2051 FOR VALUES FROM ('20510101') TO ('20520101');


ALTER TABLE main.y_market_price_data_2051 OWNER TO kawauso;

--
-- Name: y_market_price_data_2052; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2052 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2052 FOR VALUES FROM ('20520101') TO ('20530101');


ALTER TABLE main.y_market_price_data_2052 OWNER TO kawauso;

--
-- Name: y_market_price_data_2053; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2053 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2053 FOR VALUES FROM ('20530101') TO ('20540101');


ALTER TABLE main.y_market_price_data_2053 OWNER TO kawauso;

--
-- Name: y_market_price_data_2054; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2054 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2054 FOR VALUES FROM ('20540101') TO ('20550101');


ALTER TABLE main.y_market_price_data_2054 OWNER TO kawauso;

--
-- Name: y_market_price_data_2055; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2055 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2055 FOR VALUES FROM ('20550101') TO ('20560101');


ALTER TABLE main.y_market_price_data_2055 OWNER TO kawauso;

--
-- Name: y_market_price_data_2056; Type: TABLE; Schema: main; Owner: kawauso
--

CREATE TABLE main.y_market_price_data_2056 (
    insert_date character varying(8) NOT NULL,
    stock_code character varying(8) NOT NULL,
    stock_code_api character varying(8) NOT NULL,
    time_stamp timestamp without time zone NOT NULL,
    open_rate numeric(24,12) NOT NULL,
    low_rate numeric(24,12) NOT NULL,
    high_rate numeric(24,12) NOT NULL,
    close_rate numeric(24,12) NOT NULL,
    volume numeric(24,12) NOT NULL,
    delete_flg character varying(1) NOT NULL,
    create_date timestamp without time zone NOT NULL,
    create_user_id character varying(20) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    update_user_id character varying(20) NOT NULL
);
ALTER TABLE ONLY main.y_market_price_data ATTACH PARTITION main.y_market_price_data_2056 FOR VALUES FROM ('20560101') TO ('20570101');


ALTER TABLE main.y_market_price_data_2056 OWNER TO kawauso;

--
-- Name: m_calendar m_calendar_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.m_calendar
    ADD CONSTRAINT m_calendar_pkey PRIMARY KEY (date);


--
-- Name: m_industry_scale m_industry_scale_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.m_industry_scale
    ADD CONSTRAINT m_industry_scale_pkey PRIMARY KEY (total_industry_code, sub_industry_code, scale_code);


--
-- Name: m_market m_market_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.m_market
    ADD CONSTRAINT m_market_pkey PRIMARY KEY (market_code, market_segment_code, market_stock_code);


--
-- Name: m_message m_message_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.m_message
    ADD CONSTRAINT m_message_pkey PRIMARY KEY (message_code);


--
-- Name: m_setting_info m_system_info_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.m_setting_info
    ADD CONSTRAINT m_system_info_pkey PRIMARY KEY (info_id);


--
-- Name: w_stock_data_jpx m_toshin_product_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_stock_data_jpx
    ADD CONSTRAINT m_toshin_product_pkey PRIMARY KEY (base_date, stock_code);


--
-- Name: m_user m_user_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.m_user
    ADD CONSTRAINT m_user_pkey PRIMARY KEY (user_id);


--
-- Name: t_stock_data_2011 t_stock_data_2011_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2011
    ADD CONSTRAINT t_stock_data_2011_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2012 t_stock_data_2012_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2012
    ADD CONSTRAINT t_stock_data_2012_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2013 t_stock_data_2013_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2013
    ADD CONSTRAINT t_stock_data_2013_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2014 t_stock_data_2014_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2014
    ADD CONSTRAINT t_stock_data_2014_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2015 t_stock_data_2015_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2015
    ADD CONSTRAINT t_stock_data_2015_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2016 t_stock_data_2016_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2016
    ADD CONSTRAINT t_stock_data_2016_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2017 t_stock_data_2017_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2017
    ADD CONSTRAINT t_stock_data_2017_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2018 t_stock_data_2018_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2018
    ADD CONSTRAINT t_stock_data_2018_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2019 t_stock_data_2019_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2019
    ADD CONSTRAINT t_stock_data_2019_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2020 t_stock_data_2020_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2020
    ADD CONSTRAINT t_stock_data_2020_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2021 t_stock_data_2021_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2021
    ADD CONSTRAINT t_stock_data_2021_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2022 t_stock_data_2022_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2022
    ADD CONSTRAINT t_stock_data_2022_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2023 t_stock_data_2023_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2023
    ADD CONSTRAINT t_stock_data_2023_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2024 t_stock_data_2024_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2024
    ADD CONSTRAINT t_stock_data_2024_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2025 t_stock_data_2025_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2025
    ADD CONSTRAINT t_stock_data_2025_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2026 t_stock_data_2026_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2026
    ADD CONSTRAINT t_stock_data_2026_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2027 t_stock_data_2027_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2027
    ADD CONSTRAINT t_stock_data_2027_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2028 t_stock_data_2028_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2028
    ADD CONSTRAINT t_stock_data_2028_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2029 t_stock_data_2029_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2029
    ADD CONSTRAINT t_stock_data_2029_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2030 t_stock_data_2030_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2030
    ADD CONSTRAINT t_stock_data_2030_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2031 t_stock_data_2031_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2031
    ADD CONSTRAINT t_stock_data_2031_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2032 t_stock_data_2032_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2032
    ADD CONSTRAINT t_stock_data_2032_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2033 t_stock_data_2033_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2033
    ADD CONSTRAINT t_stock_data_2033_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2034 t_stock_data_2034_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2034
    ADD CONSTRAINT t_stock_data_2034_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2035 t_stock_data_2035_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2035
    ADD CONSTRAINT t_stock_data_2035_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2036 t_stock_data_2036_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2036
    ADD CONSTRAINT t_stock_data_2036_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2037 t_stock_data_2037_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2037
    ADD CONSTRAINT t_stock_data_2037_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2038 t_stock_data_2038_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2038
    ADD CONSTRAINT t_stock_data_2038_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2039 t_stock_data_2039_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2039
    ADD CONSTRAINT t_stock_data_2039_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2040 t_stock_data_2040_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2040
    ADD CONSTRAINT t_stock_data_2040_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2041 t_stock_data_2041_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2041
    ADD CONSTRAINT t_stock_data_2041_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2042 t_stock_data_2042_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2042
    ADD CONSTRAINT t_stock_data_2042_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2043 t_stock_data_2043_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2043
    ADD CONSTRAINT t_stock_data_2043_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2044 t_stock_data_2044_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2044
    ADD CONSTRAINT t_stock_data_2044_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2045 t_stock_data_2045_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2045
    ADD CONSTRAINT t_stock_data_2045_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2046 t_stock_data_2046_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2046
    ADD CONSTRAINT t_stock_data_2046_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2047 t_stock_data_2047_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2047
    ADD CONSTRAINT t_stock_data_2047_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2048 t_stock_data_2048_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2048
    ADD CONSTRAINT t_stock_data_2048_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2049 t_stock_data_2049_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2049
    ADD CONSTRAINT t_stock_data_2049_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2050 t_stock_data_2050_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2050
    ADD CONSTRAINT t_stock_data_2050_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2051 t_stock_data_2051_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2051
    ADD CONSTRAINT t_stock_data_2051_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2052 t_stock_data_2052_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2052
    ADD CONSTRAINT t_stock_data_2052_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2053 t_stock_data_2053_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2053
    ADD CONSTRAINT t_stock_data_2053_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2054 t_stock_data_2054_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2054
    ADD CONSTRAINT t_stock_data_2054_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2055 t_stock_data_2055_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2055
    ADD CONSTRAINT t_stock_data_2055_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: t_stock_data_2056 t_stock_data_2056_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.t_stock_data_2056
    ADD CONSTRAINT t_stock_data_2056_pkey PRIMARY KEY (base_date, stock_code, market_code, market_segment_code, total_industry_code, sub_industry_code, scale_code);


--
-- Name: w_market_price_data_2011 w_market_price_data_2011_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2011
    ADD CONSTRAINT w_market_price_data_2011_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2012 w_market_price_data_2012_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2012
    ADD CONSTRAINT w_market_price_data_2012_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2013 w_market_price_data_2013_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2013
    ADD CONSTRAINT w_market_price_data_2013_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2014 w_market_price_data_2014_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2014
    ADD CONSTRAINT w_market_price_data_2014_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2015 w_market_price_data_2015_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2015
    ADD CONSTRAINT w_market_price_data_2015_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2016 w_market_price_data_2016_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2016
    ADD CONSTRAINT w_market_price_data_2016_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2017 w_market_price_data_2017_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2017
    ADD CONSTRAINT w_market_price_data_2017_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2018 w_market_price_data_2018_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2018
    ADD CONSTRAINT w_market_price_data_2018_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2019 w_market_price_data_2019_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2019
    ADD CONSTRAINT w_market_price_data_2019_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2020 w_market_price_data_2020_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2020
    ADD CONSTRAINT w_market_price_data_2020_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2021 w_market_price_data_2021_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2021
    ADD CONSTRAINT w_market_price_data_2021_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2022 w_market_price_data_2022_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2022
    ADD CONSTRAINT w_market_price_data_2022_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2023 w_market_price_data_2023_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2023
    ADD CONSTRAINT w_market_price_data_2023_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2024 w_market_price_data_2024_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2024
    ADD CONSTRAINT w_market_price_data_2024_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2025 w_market_price_data_2025_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2025
    ADD CONSTRAINT w_market_price_data_2025_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2026 w_market_price_data_2026_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2026
    ADD CONSTRAINT w_market_price_data_2026_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2027 w_market_price_data_2027_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2027
    ADD CONSTRAINT w_market_price_data_2027_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2028 w_market_price_data_2028_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2028
    ADD CONSTRAINT w_market_price_data_2028_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2029 w_market_price_data_2029_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2029
    ADD CONSTRAINT w_market_price_data_2029_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2030 w_market_price_data_2030_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2030
    ADD CONSTRAINT w_market_price_data_2030_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2031 w_market_price_data_2031_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2031
    ADD CONSTRAINT w_market_price_data_2031_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2032 w_market_price_data_2032_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2032
    ADD CONSTRAINT w_market_price_data_2032_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2033 w_market_price_data_2033_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2033
    ADD CONSTRAINT w_market_price_data_2033_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2034 w_market_price_data_2034_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2034
    ADD CONSTRAINT w_market_price_data_2034_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2035 w_market_price_data_2035_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2035
    ADD CONSTRAINT w_market_price_data_2035_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2036 w_market_price_data_2036_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2036
    ADD CONSTRAINT w_market_price_data_2036_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2037 w_market_price_data_2037_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2037
    ADD CONSTRAINT w_market_price_data_2037_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2038 w_market_price_data_2038_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2038
    ADD CONSTRAINT w_market_price_data_2038_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2039 w_market_price_data_2039_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2039
    ADD CONSTRAINT w_market_price_data_2039_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2040 w_market_price_data_2040_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2040
    ADD CONSTRAINT w_market_price_data_2040_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2041 w_market_price_data_2041_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2041
    ADD CONSTRAINT w_market_price_data_2041_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2042 w_market_price_data_2042_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2042
    ADD CONSTRAINT w_market_price_data_2042_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2043 w_market_price_data_2043_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2043
    ADD CONSTRAINT w_market_price_data_2043_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2044 w_market_price_data_2044_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2044
    ADD CONSTRAINT w_market_price_data_2044_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2045 w_market_price_data_2045_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2045
    ADD CONSTRAINT w_market_price_data_2045_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2046 w_market_price_data_2046_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2046
    ADD CONSTRAINT w_market_price_data_2046_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2047 w_market_price_data_2047_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2047
    ADD CONSTRAINT w_market_price_data_2047_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2048 w_market_price_data_2048_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2048
    ADD CONSTRAINT w_market_price_data_2048_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2049 w_market_price_data_2049_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2049
    ADD CONSTRAINT w_market_price_data_2049_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2050 w_market_price_data_2050_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2050
    ADD CONSTRAINT w_market_price_data_2050_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2051 w_market_price_data_2051_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2051
    ADD CONSTRAINT w_market_price_data_2051_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2052 w_market_price_data_2052_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2052
    ADD CONSTRAINT w_market_price_data_2052_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2053 w_market_price_data_2053_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2053
    ADD CONSTRAINT w_market_price_data_2053_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2054 w_market_price_data_2054_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2054
    ADD CONSTRAINT w_market_price_data_2054_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2055 w_market_price_data_2055_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2055
    ADD CONSTRAINT w_market_price_data_2055_pkey PRIMARY KEY (create_date);


--
-- Name: w_market_price_data_2056 w_market_price_data_2056_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.w_market_price_data_2056
    ADD CONSTRAINT w_market_price_data_2056_pkey PRIMARY KEY (create_date);


--
-- Name: y_market_price_data_2011 y_market_price_data_2011_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2011
    ADD CONSTRAINT y_market_price_data_2011_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2012 y_market_price_data_2012_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2012
    ADD CONSTRAINT y_market_price_data_2012_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2013 y_market_price_data_2013_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2013
    ADD CONSTRAINT y_market_price_data_2013_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2014 y_market_price_data_2014_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2014
    ADD CONSTRAINT y_market_price_data_2014_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2015 y_market_price_data_2015_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2015
    ADD CONSTRAINT y_market_price_data_2015_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2016 y_market_price_data_2016_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2016
    ADD CONSTRAINT y_market_price_data_2016_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2017 y_market_price_data_2017_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2017
    ADD CONSTRAINT y_market_price_data_2017_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2018 y_market_price_data_2018_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2018
    ADD CONSTRAINT y_market_price_data_2018_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2019 y_market_price_data_2019_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2019
    ADD CONSTRAINT y_market_price_data_2019_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2020 y_market_price_data_2020_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2020
    ADD CONSTRAINT y_market_price_data_2020_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2021 y_market_price_data_2021_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2021
    ADD CONSTRAINT y_market_price_data_2021_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2022 y_market_price_data_2022_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2022
    ADD CONSTRAINT y_market_price_data_2022_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2023 y_market_price_data_2023_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2023
    ADD CONSTRAINT y_market_price_data_2023_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2024 y_market_price_data_2024_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2024
    ADD CONSTRAINT y_market_price_data_2024_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2025 y_market_price_data_2025_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2025
    ADD CONSTRAINT y_market_price_data_2025_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2026 y_market_price_data_2026_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2026
    ADD CONSTRAINT y_market_price_data_2026_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2027 y_market_price_data_2027_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2027
    ADD CONSTRAINT y_market_price_data_2027_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2028 y_market_price_data_2028_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2028
    ADD CONSTRAINT y_market_price_data_2028_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2029 y_market_price_data_2029_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2029
    ADD CONSTRAINT y_market_price_data_2029_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2030 y_market_price_data_2030_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2030
    ADD CONSTRAINT y_market_price_data_2030_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2031 y_market_price_data_2031_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2031
    ADD CONSTRAINT y_market_price_data_2031_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2032 y_market_price_data_2032_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2032
    ADD CONSTRAINT y_market_price_data_2032_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2033 y_market_price_data_2033_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2033
    ADD CONSTRAINT y_market_price_data_2033_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2034 y_market_price_data_2034_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2034
    ADD CONSTRAINT y_market_price_data_2034_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2035 y_market_price_data_2035_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2035
    ADD CONSTRAINT y_market_price_data_2035_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2036 y_market_price_data_2036_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2036
    ADD CONSTRAINT y_market_price_data_2036_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2037 y_market_price_data_2037_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2037
    ADD CONSTRAINT y_market_price_data_2037_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2038 y_market_price_data_2038_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2038
    ADD CONSTRAINT y_market_price_data_2038_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2039 y_market_price_data_2039_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2039
    ADD CONSTRAINT y_market_price_data_2039_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2040 y_market_price_data_2040_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2040
    ADD CONSTRAINT y_market_price_data_2040_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2041 y_market_price_data_2041_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2041
    ADD CONSTRAINT y_market_price_data_2041_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2042 y_market_price_data_2042_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2042
    ADD CONSTRAINT y_market_price_data_2042_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2043 y_market_price_data_2043_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2043
    ADD CONSTRAINT y_market_price_data_2043_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2044 y_market_price_data_2044_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2044
    ADD CONSTRAINT y_market_price_data_2044_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2045 y_market_price_data_2045_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2045
    ADD CONSTRAINT y_market_price_data_2045_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2046 y_market_price_data_2046_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2046
    ADD CONSTRAINT y_market_price_data_2046_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2047 y_market_price_data_2047_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2047
    ADD CONSTRAINT y_market_price_data_2047_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2048 y_market_price_data_2048_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2048
    ADD CONSTRAINT y_market_price_data_2048_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2049 y_market_price_data_2049_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2049
    ADD CONSTRAINT y_market_price_data_2049_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2050 y_market_price_data_2050_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2050
    ADD CONSTRAINT y_market_price_data_2050_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2051 y_market_price_data_2051_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2051
    ADD CONSTRAINT y_market_price_data_2051_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2052 y_market_price_data_2052_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2052
    ADD CONSTRAINT y_market_price_data_2052_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2053 y_market_price_data_2053_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2053
    ADD CONSTRAINT y_market_price_data_2053_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2054 y_market_price_data_2054_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2054
    ADD CONSTRAINT y_market_price_data_2054_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2055 y_market_price_data_2055_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2055
    ADD CONSTRAINT y_market_price_data_2055_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: y_market_price_data_2056 y_market_price_data_2056_pkey; Type: CONSTRAINT; Schema: main; Owner: kawauso
--

ALTER TABLE ONLY main.y_market_price_data_2056
    ADD CONSTRAINT y_market_price_data_2056_pkey PRIMARY KEY (insert_date, stock_code, time_stamp);


--
-- Name: info_id; Type: sequence; Schema: main; Owner: kawauso
--

DROP SEQUENCE IF EXISTS main.info_id_no;

CREATE SEQUENCE IF NOT EXISTS main.info_id_no
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9999999
    CACHE 1;

ALTER SEQUENCE main.info_id_no
    OWNER TO kawauso;

--
-- SEQUENCE: main.market_segment_no
--
DROP SEQUENCE IF EXISTS main.market_segment_no;

CREATE SEQUENCE IF NOT EXISTS main.market_segment_no
    INCREMENT 1
    START 1
    MINVALUE 0
    MAXVALUE 9999999
    CACHE 1;

ALTER SEQUENCE main.market_segment_no
    OWNER TO kawauso;


--
-- FUNCTION: main.create_segment_code(character varying)
--

DROP FUNCTION IF EXISTS main.create_segment_code(character varying);

CREATE OR REPLACE FUNCTION main.create_segment_code(
	market_code character varying)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
BEGIN
     RAISE NOTICE 'Start create_segment_code. - market_code[%]', market_code;
     RETURN market_code || lpad(CAST(nextval('market_segment_no') AS VARCHAR), '4','0');
	 RAISE NOTICE 'End copyToCommand.';
EXCEPTION
  WHEN OTHERS THEN 
     RAISE NOTICE 'Error end create_segment_code.';
     RETURN lpad(CAST(nextval('market_segment_no') AS VARCHAR), '4','0');
END;
$BODY$;

ALTER FUNCTION main.create_segment_code(character varying)
    OWNER TO kawauso;


--
-- PostgreSQL database dump import m_market
--

INSERT INTO main.m_market
VALUES ('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'ETF・ETN','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'JASDAQ(グロース・内国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'JASDAQ(スタンダード・外国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'JASDAQ(スタンダード・内国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'PRO Market','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'REIT・ベンチャーファンド・カントリーファンド・インフラファンド','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'市場第一部（外国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'市場第一部（内国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'市場第二部（外国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'市場第二部（内国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'出資証券','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'マザーズ（外国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('JPX','日本取引所グループ（JPX）',create_segment_code('JPX'),'マザーズ（内国株）','TYO','.T','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER');

--
-- PostgreSQL database dump import m_industry_scale
--

INSERT INTO main.m_industry_scale
VALUES ('1050','鉱業','2','エネルギー資源 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('2050','建設業','3','建設・資材 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3050','食料品','1','食品 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3100','繊維製品','4','素材・化学 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3150','パルプ・紙','4','素材・化学 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3200','化学','4','素材・化学 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3250','医薬品','5','医薬品 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3300','石油・石炭製品','2','エネルギー資源 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3350','ゴム製品','6','自動車・輸送機 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3400','ガラス・土石製品','3','建設・資材 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3450','鉄鋼','7','鉄鋼・非鉄 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3500','非鉄金属','7','鉄鋼・非鉄 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3550','金属製品','3','建設・資材 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3600','機械','8','機械 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3650','電気機器','9','電機・精密 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3700','輸送用機器','6','自動車・輸送機 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3750','精密機器','9','電機・精密 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('3800','その他製品','10','情報通信・サービスその他 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('4050','電気・ガス業','11','電力・ガス ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('50','水産・農林業','1','食品 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('5050','陸運業','12','運輸・物流 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('5100','海運業','12','運輸・物流 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('5150','空運業','12','運輸・物流 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('5200','倉庫・運輸関連業','12','運輸・物流 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('5250','情報・通信業','10','情報通信・サービスその他 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('6050','卸売業','13','商社・卸売 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('6100','小売業','14','小売 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('7050','銀行業','15','銀行 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('7100','証券、商品先物取引業','16','金融（除く銀行） ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('7150','保険業','16','金融（除く銀行） ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('7200','その他金融業','16','金融（除く銀行） ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('8050','不動産業','17','不動産 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('9050','サービス業','10','情報通信・サービスその他 ','-','-','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('-','-','-','-','1','TOPIX Core30','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('-','-','-','-','2','TOPIX Large70','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('-','-','-','-','4','TOPIX Mid400','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('-','-','-','-','6','TOPIX Small 1','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER'),
('-','-','-','-','7','TOPIX Small 2','0',CURRENT_TIMESTAMP,'MUSER',CURRENT_TIMESTAMP,'MUSER');


--
-- PostgreSQL database dump import m_setting_info
--

INSERT INTO m_setting_info
VALUES (nextval('info_id_no'), 'market_code_jpy', 'JPX', '0', CURRENT_TIMESTAMP, 'M_USER', CURRENT_TIMESTAMP, 'M_USER'),
(nextval('info_id_no'), 'market_stock_code_jpy', 'TYO', '0', CURRENT_TIMESTAMP, 'M_USER', CURRENT_TIMESTAMP, 'M_USER')
(nextval('info_id_no'), 'market_stock_code_api_jpy', '.T', '0', CURRENT_TIMESTAMP, 'M_USER', CURRENT_TIMESTAMP, 'M_USER');

--
-- PostgreSQL database dump complete
--