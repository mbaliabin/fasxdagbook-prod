--
-- PostgreSQL database dump
--

\restrict ksNx0nQV6dB5Nj6zNEpPfwmW27rgLW7zzBwxXO9CqrKAbz9M9dRWe4DmJwDZbeT

-- Dumped from database version 17.7 (Debian 17.7-3.pgdg13+1)
-- Dumped by pg_dump version 17.7 (Debian 17.7-3.pgdg13+1)

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
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: WorkoutType; Type: TYPE; Schema: public; Owner: fasx_user
--

CREATE TYPE public."WorkoutType" AS ENUM (
    'Running',
    'XC_Skiing_Classic',
    'XC_Skiing_Skate',
    'RollerSki_Classic',
    'StrengthTraining',
    'Other',
    'Bike',
    'RollerSki_Skate'
);


ALTER TYPE public."WorkoutType" OWNER TO fasx_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: DailyInformation; Type: TABLE; Schema: public; Owner: fasx_user
--

CREATE TABLE public."DailyInformation" (
    id integer NOT NULL,
    "userId" text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    main_param text,
    physical integer DEFAULT 0 NOT NULL,
    mental integer DEFAULT 0 NOT NULL,
    sleep_quality integer DEFAULT 0 NOT NULL,
    pulse integer,
    sleep_duration text,
    comment text,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "DailyInformation_mental_check" CHECK (((mental >= 0) AND (mental <= 10))),
    CONSTRAINT "DailyInformation_physical_check" CHECK (((physical >= 0) AND (physical <= 10))),
    CONSTRAINT "DailyInformation_pulse_check" CHECK (((pulse >= 30) AND (pulse <= 250))),
    CONSTRAINT "DailyInformation_sleep_quality_check" CHECK (((sleep_quality >= 0) AND (sleep_quality <= 10)))
);


ALTER TABLE public."DailyInformation" OWNER TO fasx_user;

--
-- Name: DailyInformation_id_seq; Type: SEQUENCE; Schema: public; Owner: fasx_user
--

CREATE SEQUENCE public."DailyInformation_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DailyInformation_id_seq" OWNER TO fasx_user;

--
-- Name: DailyInformation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fasx_user
--

ALTER SEQUENCE public."DailyInformation_id_seq" OWNED BY public."DailyInformation".id;


--
-- Name: Follow; Type: TABLE; Schema: public; Owner: fasx_user
--

CREATE TABLE public."Follow" (
    id text NOT NULL,
    "followerId" text NOT NULL,
    "followingId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Follow" OWNER TO fasx_user;

--
-- Name: Profile; Type: TABLE; Schema: public; Owner: fasx_user
--

CREATE TABLE public."Profile" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "fullName" text NOT NULL,
    bio text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gender text DEFAULT 'Мужчина'::text,
    "sportType" text DEFAULT 'Лыжные гонки'::text,
    club text DEFAULT 'Не указан'::text,
    association text DEFAULT 'ФЛГР'::text,
    "hrZones" jsonb DEFAULT '{"I1": "118-143", "I2": "143-161", "I3": "161-171", "I4": "171-181", "I5": "181-200"}'::jsonb,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Profile" OWNER TO fasx_user;

--
-- Name: User; Type: TABLE; Schema: public; Owner: fasx_user
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    "avatarUrl" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    "verificationToken" text,
    "originalAvatarUrl" text
);


ALTER TABLE public."User" OWNER TO fasx_user;

--
-- Name: Workout; Type: TABLE; Schema: public; Owner: fasx_user
--

CREATE TABLE public."Workout" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    distance double precision,
    duration integer NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    "zone1Min" integer DEFAULT 0 NOT NULL,
    "zone2Min" integer DEFAULT 0 NOT NULL,
    "zone3Min" integer DEFAULT 0 NOT NULL,
    "zone4Min" integer DEFAULT 0 NOT NULL,
    "zone5Min" integer DEFAULT 0 NOT NULL,
    type public."WorkoutType" NOT NULL,
    name text NOT NULL,
    comment text,
    effort integer,
    feeling integer,
    "updatedAt" timestamp(3) without time zone
);


ALTER TABLE public."Workout" OWNER TO fasx_user;

--
-- Name: DailyInformation id; Type: DEFAULT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."DailyInformation" ALTER COLUMN id SET DEFAULT nextval('public."DailyInformation_id_seq"'::regclass);


--
-- Data for Name: DailyInformation; Type: TABLE DATA; Schema: public; Owner: fasx_user
--

COPY public."DailyInformation" (id, "userId", date, main_param, physical, mental, sleep_quality, pulse, sleep_duration, comment, created_at) FROM stdin;
1	cmc5e85an0000qq8ty9tz0rxl	2025-10-09 00:00:00	paReise	3	2	9	90	08:45	test 1	2025-10-09 15:57:49.631
2	cmc5e85an0000qq8ty9tz0rxl	2025-11-28 00:00:00	\N	1	1	1	55	04:20	Сегодня первая тренировка за две недели после болезни. Начнём с кросса и силовой, что бы немного взбодрить мышцы	2025-11-28 04:41:32.985
3	cmc5e85an0000qq8ty9tz0rxl	2025-11-29 00:00:00	\N	4	6	0	65	07:00	Сегодня планирую покататься на лыжероллерах, на улице сыро, думаю будет тяжело. Пока начну с одного часа	2025-11-29 07:21:46.12
4	cmc5e85an0000qq8ty9tz0rxl	2025-11-30 00:00:00	\N	6	8	0	56	08:00	Сегодня хорошо выспался, встал чуть позже. Чувствую себя более менее. Погода сухая, тренировку сделаю на роллерар коньковым стилем, попробую на полиуретановых колесах	2025-11-30 08:03:04.498
5	cmc5e85an0000qq8ty9tz0rxl	2025-12-03 00:00:00	\N	6	4	6	62	06:00	\N	2025-12-04 04:02:29.458
6	cmc5e85an0000qq8ty9tz0rxl	2025-12-01 00:00:00	fridag	0	0	0	\N	\N	\N	2025-12-04 04:03:09.576
7	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 00:00:00	\N	7	10	9	50	07:00	Сегодня впервые более менее поспал, состояние хорошее, планирую выйти на тренировку на роллерах коньковым стилем	2025-12-04 04:05:07.73
9	cmc5e85an0000qq8ty9tz0rxl	2025-12-06 00:00:00	\N	8	8	10	56	07:00	Сегодня по дольше поспал, хорошо выспался. Планирую потренироваться сегодня 1,5 часа на роллерах	2025-12-06 06:55:35.251
8	cmc5e85an0000qq8ty9tz0rxl	2025-12-05 00:00:00	\N	7	8	10	65	07:00	Хорошо выспался, готов тренироваться	2025-12-05 04:23:22.227
10	cmc5e85an0000qq8ty9tz0rxl	2025-12-08 00:00:00	fridag	0	0	6	65	06:30	Сегодня решил сделать выходной	2025-12-08 05:05:23.301
11	cmc5e85an0000qq8ty9tz0rxl	2025-12-07 00:00:00	\N	8	6	7	55	06:00	Плохой сон, встать было тяжело	2025-12-08 05:06:20.525
12	cmc5e85an0000qq8ty9tz0rxl	2025-12-15 00:00:00	syk	8	8	8	60	6:00	\N	2025-12-15 05:24:25.927
13	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 00:00:00	syk	5	6	7	67	06:00	Сегодня чувствую себя получше, решил выйти потренироваться после болезни	2025-12-18 05:55:06.81
14	cmc5e85an0000qq8ty9tz0rxl	2025-12-19 00:00:00	\N	6	8	9	53	07:30	Сегодня получше выспался, чувствую себя утром лучше	2025-12-19 04:54:08.689
15	cmc5e85an0000qq8ty9tz0rxl	2025-12-20 00:00:00	\N	6	5	0	63	07:00	С утра чуть выше пульс чувствуется недовосстановление, так как на предыдущей тренировки пульс был высоковат	2025-12-20 05:26:11.826
16	cmc5e85an0000qq8ty9tz0rxl	2025-12-23 00:00:00	\N	9	9	9	\N	08:00	\N	2025-12-25 14:11:25.342
\.


--
-- Data for Name: Follow; Type: TABLE DATA; Schema: public; Owner: fasx_user
--

COPY public."Follow" (id, "followerId", "followingId", "createdAt") FROM stdin;
\.


--
-- Data for Name: Profile; Type: TABLE DATA; Schema: public; Owner: fasx_user
--

COPY public."Profile" (id, "userId", "fullName", bio, "createdAt", gender, "sportType", club, association, "hrZones", "updatedAt") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: fasx_user
--

COPY public."User" (id, email, password, name, "avatarUrl", "createdAt", "isVerified", "verificationToken", "originalAvatarUrl") FROM stdin;
cmc5a4nra0000qql0ktipo3xt	test@gmail.com	$2b$10$pGFyCtlOeSvSKALxs4hsCuOhwutFo/CAnQajjjJIjBPCGzuQag1DK	test	\N	2025-06-20 20:45:42.598	f	\N	\N
cmc7s84qs0000qqpxmtq85jf2	maksim@gmail.com	$2b$10$IJNdNc06TVfcBvGTdhWmL.MDd601NyS5hhjTSN61ecuHy57QSIpW2	Максим	\N	2025-06-22 14:47:50.02	f	\N	\N
cmdc2p03p0000qq3nvjrtqni5	test@yandex.ru	$2b$10$DtxKnarwOhY7pW8EldQdsOAUp0uF7ahCRLfvhtuj3aSpmz0ilStfm	test	\N	2025-07-20 19:31:40.357	f	\N	\N
cmflkyp110004o50j0527uijf	test1@mail.com	$2b$10$NqLCf3wnElix9NkGOgvpn.x8ctkh/KUKcQu5CUcYBl6v0tacTU3eS	Test1	\N	2025-09-15 20:32:25.909	f	\N	\N
cmfll69980007o50j4tlzlr7h	test2@mail.com	$2b$10$qgxdrE7Hpy3H7gm8xAeDN.EgyEDKtGTdH9PTpCTo9irHoX2iYRdv6	test2	\N	2025-09-15 20:38:18.716	f	\N	\N
cmc5e85an0000qq8ty9tz0rxl	baliabin.maksim@gmail.com	$2b$10$VIQRw5F1lgN2UhxXDsuuEeC1SoPfFnTeL6L..iEZoS3QjvCWi1xIy	Максим	https://s3.twcstorage.ru/49ffd73c-29437e7b-93fb-418e-8e49-2e57148af1b4/avatars/cmc5e85an0000qq8ty9tz0rxl-1766746667275-thumb.jpg	2025-06-20 22:40:23.759	f	\N	https://s3.twcstorage.ru/49ffd73c-29437e7b-93fb-418e-8e49-2e57148af1b4/avatars/cmc5e85an0000qq8ty9tz0rxl-1766746667275-full.jpg
\.


--
-- Data for Name: Workout; Type: TABLE DATA; Schema: public; Owner: fasx_user
--

COPY public."Workout" (id, "userId", "createdAt", distance, duration, date, "zone1Min", "zone2Min", "zone3Min", "zone4Min", "zone5Min", type, name, comment, effort, feeling, "updatedAt") FROM stdin;
cmc5cpjg10002qql0xb9yrz3h	cmc5a4nra0000qql0ktipo3xt	2025-06-20 21:57:56.016	15.5	90	2025-06-20 07:00:00	10	20	30	20	10	Running	Утренняя пробежка	Отличная тренировка	\N	\N	\N
cmcey91ye0001qq589vnqglgk	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:10:53.989	8.9	64	2025-06-16 00:00:00	12	41	9	2	0	Running	Lop		10	8	2025-06-27 15:10:53.989
cmceybe900005qq58e4fiyvbe	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:12:43.235	\N	43	2025-06-16 00:00:00	43	0	0	0	0	StrengthTraining	Styrke	Силовая тренировка	10	9	2025-06-27 15:12:43.235
cmceyen7l0007qq58f3jt4d13	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:15:14.804	31.4	121	2025-06-17 00:00:00	92	26	3	0	0	RollerSki_Classic	Rulleski klassisk		10	8	2025-06-27 15:15:14.804
cmceyihpo0009qq587yue070u	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:18:14.314	35.9	120	2025-06-18 00:00:00	78	39	1	1	1	RollerSki_Skate	Rulleski Skoyting		10	8	2025-06-27 15:18:14.314
cmceykb3y000bqq58o71gln7t	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:19:39.07	17.4	60	2025-06-19 00:00:00	32	23	4	1	0	RollerSki_Classic	Rulleski klassisk		9	9	2025-06-27 15:19:39.07
cmceylpvz000dqq58hdlevah6	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:20:44.868	\N	35	2025-06-19 00:00:00	35	0	0	0	0	StrengthTraining	Styrke		10	10	2025-06-27 15:20:44.868
cmceynu5r000fqq58qis1072i	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:22:23.713	32.6	120	2025-06-20 00:00:00	49	41	21	8	1	RollerSki_Skate	Rulleski Skoyting		10	8	2025-06-27 15:22:23.713
cmceyaino0003qq58yeu9n3wl	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:12:02.292	\N	17	2025-06-16 00:00:00	17	0	0	0	0	StrengthTraining	XC Training	Тренировка с эспандером	10	10	2025-06-27 15:43:43.771
cmceypntd000hqq58cikqvbtg	cmc5e85an0000qq8ty9tz0rxl	2025-06-27 15:23:48.816	39.3	136	2025-06-22 00:00:00	83	50	3	0	0	RollerSki_Skate	Rulleski Skoyting		9	8	2025-06-27 19:30:52.039
cmcoidr9z0001qqie0niqn2ke	cmc5e85an0000qq8ty9tz0rxl	2025-07-04 07:44:21.334	17.5	60	2025-06-24 00:00:00	34	24	2	0	0	RollerSki_Classic	Rulleski klassisk		9	9	2025-07-04 07:44:21.334
cmcoiexnh0003qqiec4rjxi69	cmc5e85an0000qq8ty9tz0rxl	2025-07-04 07:45:16.253	\N	60	2025-06-24 00:00:00	60	0	0	0	0	StrengthTraining	Styrke		9	8	2025-07-04 07:45:16.253
cmcok0kjh0005qqieqxqdaig6	cmc5e85an0000qq8ty9tz0rxl	2025-07-04 08:30:05.296	\N	16	2025-06-25 00:00:00	16	0	0	0	0	StrengthTraining	Styrke		9	8	2025-07-04 08:30:05.296
cmcumvgye0001qq1djmpq2pwm	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:36:43.272	30.9	118	2025-06-25 00:00:00	79	32	2	5	0	RollerSki_Classic	Rulleski klassisk		8	9	2025-07-08 14:36:43.272
cmcumx2nz0003qq1dby0xjzv8	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:37:58.078	23.4	90	2025-06-28 00:00:00	25	53	10	1	1	RollerSki_Skate	Rulleski skoyte		8	8	2025-07-08 14:37:58.078
cmcumyg470005qq1dodboi2pk	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:39:02.166	25.6	91	2025-06-28 00:00:00	11	46	24	10	0	RollerSki_Classic	Rulleski klassisk		9	7	2025-07-08 14:39:02.166
cmcumzzch0007qq1dhbaatqzw	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:40:13.744	33.5	119	2025-06-29 00:00:00	33	45	31	10	0	RollerSki_Skate	Rulleski skoyte		8	8	2025-07-08 14:40:13.744
cmcuni5cx000bqq1dmbaef8si	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:54:21.344	16.3	63	2025-07-04 00:00:00	16	30	11	6	0	RollerSki_Classic	Rulleski klassisk		9	8	2025-07-08 14:54:21.344
cmcunjx3e000dqq1d9jdgw73w	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:55:43.946	31	75	2025-07-05 00:00:00	0	0	0	0	75	RollerSki_Skate	Rulleski skoyte		10	7	2025-07-08 14:55:43.946
cmcungwib0009qq1djwf1czvw	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:53:23.208	25.2	87	2025-07-03 00:00:00	35	46	6	0	0	RollerSki_Skate	Rulleski skoyte		8	8	2025-07-08 14:58:56.049
cmdr7tnsa0001qqqa3ud3sz43	cmc5e85an0000qq8ty9tz0rxl	2025-07-31 09:51:48.394	\N	56	2025-07-07 00:00:00	56	0	0	0	0	StrengthTraining	Styrke		9	9	2025-07-31 09:51:48.394
cme4p53ho0003qq3jk8u2cavj	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:17:35.724	17.4	57	2025-08-02 00:00:00	32	23	2	0	0	RollerSki_Skate	Rulleski skoyte		9	8	2025-08-09 20:17:35.724
cmdrhj1mw000fqqqakfzenqsc	cmc5e85an0000qq8ty9tz0rxl	2025-07-31 14:23:29.288	10	57	2025-07-11 00:00:00	57	0	0	0	0	Bike	Вело	Велосипед	5	5	2025-07-31 14:23:29.288
cmdrr903g0001qqfbzi0atl70	cmc5e85an0000qq8ty9tz0rxl	2025-07-31 18:55:36.891	9.8	60	2025-07-28 00:00:00	24	31	5	0	0	Running	Lop		10	8	2025-07-31 18:55:58.211
cmdrrbsv10003qqfbq5oi50i2	cmc5e85an0000qq8ty9tz0rxl	2025-07-31 18:57:47.475	17.5	60	2025-07-29 00:00:00	39	21	0	0	0	RollerSki_Classic	Rulleski klassisk		9	8	2025-07-31 18:57:47.475
cmdrrdpsw0005qqfbgw0vhq2k	cmc5e85an0000qq8ty9tz0rxl	2025-07-31 18:59:16.831	17.2	66	2025-07-30 00:00:00	30	35	1	0	0	RollerSki_Skate	Rulleski skoyte		8	8	2025-07-31 18:59:16.831
cme4p6j9y0005qq3jfee4h9z3	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:18:42.837	17.5	61	2025-08-04 00:00:00	24	37	0	0	0	RollerSki_Skate	Rulleski skoyte	Утренняя разминка	7	9	2025-08-09 20:18:42.837
cme4p7s8z0007qq3jp9uaihek	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:19:41.109	17.4	62	2025-08-04 00:00:00	25	37	0	0	0	RollerSki_Classic	Rulleski klassisk	Разминка перед силовой тренировкой	7	10	2025-08-09 20:19:41.109
cme4p8iy00009qq3j2w3l8a3n	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:20:15.719	\N	57	2025-08-04 00:00:00	57	0	0	0	0	StrengthTraining	Styrke	Силовая тренировка	10	10	2025-08-09 20:20:15.719
cmcunlffk000fqq1dir9kn3an	cmc5e85an0000qq8ty9tz0rxl	2025-07-08 14:56:54.368	24.3	90	2025-07-07 00:00:00	90	0	0	0	0	RollerSki_Skate	Rulleski skoyte		7	10	2025-07-31 20:39:17.088
cmdrrfojb0007qqfb77aeaf4u	cmc5e85an0000qq8ty9tz0rxl	2025-07-31 19:00:48.502	20	68	2025-07-31 00:00:00	61	6	1	0	0	RollerSki_Skate	Rulleski skoyte		10	9	2025-07-31 20:44:34.391
cme4pagb8000bqq3js71boizn	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:21:45.619	31.6	115	2025-08-05 00:00:00	30	35	23	27	0	RollerSki_Skate	Rulleski skoyte Interval	Интервальная тренировка 4*10 в  I3	10	7	2025-08-09 20:21:45.619
cme4pd5b9000dqq3js2i8f386	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:23:51.332	18.5	175	2025-08-06 00:00:00	129	38	8	0	0	Running	Running with poles	Шаговая имитация в зоне I1	10	8	2025-08-09 20:23:51.332
cme4p37iv0001qq3jrlyrzr49	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:16:07.638	16.4	61	2025-08-01 00:00:00	30	29	2	0	0	RollerSki_Classic	Rulleski klassisk	Тренировка на лыжероллерах классическим стилем	9	8	2025-08-09 20:16:28.224
cme4pepg1000fqq3jedh80ct2	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:25:04.071	15.6	63	2025-08-07 00:00:00	31	29	3	0	0	RollerSki_Skate	Rulleski skoyte	Утренняя разминка на лыжероллерах	7	10	2025-08-09 20:25:04.071
cme4pgeow000hqq3jzlvuw8un	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:26:23.455	14.2	65	2025-08-07 00:00:00	59	6	0	0	0	RollerSki_Classic	Rulleski klassisk	Разминка на лыжероллерах перед силовой тренировкой	7	10	2025-08-09 20:26:23.455
cme4ph13a000jqq3jn0h31o0d	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:26:52.485	\N	60	2025-08-07 00:00:00	60	0	0	0	0	StrengthTraining	Styrke	Силовая тренировка	10	10	2025-08-09 20:26:52.485
cme4pm13k000lqq3jgn9523ri	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:30:45.764	34.6	124	2025-08-08 00:00:00	44	41	15	13	11	RollerSki_Classic	Rulleski klassisk Interval	Интервальная тренировка на лыжероллерах, 4*10 в зоне I4	10	10	2025-08-09 20:30:45.764
cme4pnu63000nqq3jkd6qw892	cmc5e85an0000qq8ty9tz0rxl	2025-08-09 20:32:10.107	50.6	182	2025-08-09 00:00:00	169	13	0	0	0	RollerSki_Skate	Rulleski skoyte	Длительная, низкоинтенсивная сессия	10	9	2025-08-09 20:32:10.107
cmfjgozzk0005qquac37odqh8	cmc5e85an0000qq8ty9tz0rxl	2025-09-14 08:57:22.735	5.6	30	2025-09-12 00:00:00	30	0	0	0	0	Running	Беговая тренировка		5	6	2025-09-14 08:57:22.735
cmecw0pfe0001qquh5mxrpug7	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 13:52:17.594	10.1	58	2025-08-11 00:00:00	11	37	10	0	0	Running	Lop	Бег по пересеченной местности	10	9	2025-08-15 13:52:17.594
cmecw1snb0005qquhnktgfjxx	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 13:53:08.41	\N	16	2025-08-11 00:00:00	0	16	0	0	0	StrengthTraining	XC training	Резина, тренажер	10	10	2025-08-15 13:53:08.41
cmecw3uw20007qquh3wego2v1	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 13:54:44.641	18.6	62	2025-08-11 00:00:00	52	10	0	0	0	RollerSki_Skate	Rulleski skoyte		7	10	2025-08-15 13:54:44.641
cmecw4hnx0009qquhn9r85pvq	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 13:55:14.157	\N	55	2025-08-11 00:00:00	55	0	0	0	0	StrengthTraining	Styrke	Силовая тренировка	10	10	2025-08-15 13:55:14.157
cmecw7ojl000bqquhbz8ujdtu	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 13:57:43.04	29	120	2025-08-12 00:00:00	94	22	3	1	0	RollerSki_Skate	Rulleski skoyte		8	10	2025-08-15 13:57:43.04
cmecw8ryn000dqquhofdop0rf	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 13:58:34.116	15	60	2025-08-13 00:00:00	31	29	0	0	0	RollerSki_Classic	Rulleski klassisk		9	8	2025-08-15 13:58:34.116
cmecwaprw000fqquh919pcmt6	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 14:00:04.603	13.1	110	2025-08-13 00:00:00	65	29	13	3	0	Running	Running with poles	Шаговая имитация с палками	10	4	2025-08-15 14:00:04.603
cmecwbydf000hqquhot7y9s3x	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 14:01:02.402	17.4	58	2025-08-14 00:00:00	47	11	0	0	0	RollerSki_Skate	Rulleski skoyte		6	10	2025-08-15 14:01:02.402
cmecwciuy000jqquhkn2z9x6b	cmc5e85an0000qq8ty9tz0rxl	2025-08-15 14:01:28.954	\N	55	2025-08-14 00:00:00	55	0	0	0	0	StrengthTraining	Styrke		10	10	2025-08-15 14:01:28.954
cmeq4gf1d0001qqc31g2eckhp	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:09:27.841	17.5	60	2025-08-14 00:00:00	49	11	0	0	0	RollerSki_Skate	Rulleski skoyting		9	9	2025-08-24 20:09:27.841
cmeq4gyyi0003qqc3twffbct6	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:09:53.658	\N	55	2025-08-14 00:00:00	55	0	0	0	0	StrengthTraining	Styrke		10	10	2025-08-24 20:09:53.658
cmeq4iix40005qqc342pvjrvv	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:11:06.184	29.6	106	2025-08-15 00:00:00	49	36	12	6	3	RollerSki_Classic	Rulleski klassisk		10	9	2025-08-24 20:11:06.184
cmeq4jlcf0007qqc37r4ajkhn	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:11:55.983	48.4	170	2025-08-16 00:00:00	151	19	0	0	0	RollerSki_Skate	Rulleski skoyting		10	10	2025-08-24 20:11:55.983
cmeq4ksb60009qqc3vz0yvdtv	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:12:51.653	11	48	2025-08-18 00:00:00	41	7	0	0	0	RollerSki_Classic	Rulleski klassik		5	8	2025-08-24 20:12:51.653
cmeq4l8hr000bqqc3nxdwzocv	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:13:12.639	\N	63	2025-08-18 00:00:00	63	0	0	0	0	StrengthTraining	Styrke		10	10	2025-08-24 20:13:12.639
cmeq4mf8a000dqqc306ughamx	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:14:08.025	27.8	102	2025-08-19 00:00:00	28	25	15	22	12	RollerSki_Skate	Rulleski skoyting		10	10	2025-08-24 20:14:08.025
cmeq4ny09000fqqc3ybm263ag	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:15:19.016	10.8	105	2025-08-20 00:00:00	101	4	0	0	0	Running	Running with poles		10	10	2025-08-24 20:15:19.016
cmeq4owyp000hqqc38melsr9w	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:16:04.32	14	60	2025-08-21 00:00:00	45	15	0	0	0	RollerSki_Skate	Rulleski skoyting		10	10	2025-08-24 20:16:04.32
cmeq4pg47000jqqc3qtbaal3f	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:16:29.143	\N	60	2025-08-21 00:00:00	60	0	0	0	0	StrengthTraining	Styrke		10	10	2025-08-24 20:16:29.143
cmeq4qowp000lqqc359zzax94	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:17:27.193	33.3	118	2025-08-22 00:00:00	22	60	23	13	0	RollerSki_Classic	Rulleski klassisk		10	6	2025-08-24 20:17:27.193
cmeq4rwmu000nqqc3ooqps8j4	cmc5e85an0000qq8ty9tz0rxl	2025-08-24 20:18:23.848	16.1	61	2025-08-23 00:00:00	24	32	4	1	0	RollerSki_Skate	Rulleski skoyting		10	10	2025-08-24 20:18:23.848
cmf4g8iyn0001qql1t41cpn70	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:48:01.533	18.6	66	2025-08-26 00:00:00	39	27	0	0	0	RollerSki_Skate	Rulleski skoyte		8	5	2025-09-03 20:48:01.533
cmf4gbcyq0005qql14e6n3eal	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:50:13.729	16	59	2028-08-29 00:00:00	40	17	2	0	0	RollerSki_Classic	Rulleski klassisk		6	4	2025-09-03 20:50:13.729
cmf4ga79o0003qql17wl8rrj0	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:49:19.692	17.4	59	2025-08-28 00:00:00	27	23	6	3	0	RollerSki_Skate	Rulleski skoyte	Плохое самочувствие	6	5	2025-09-03 20:51:16.966
cmf4geopv0007qql1pjddlr3e	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:52:48.93	16	59	2025-08-29 00:00:00	41	16	2	0	0	RollerSki_Skate	Rulleski skoyte		6	5	2025-09-03 20:52:48.93
cmf4ghnmp0009qql17y74fbgf	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:55:07.489	9.9	66	2025-08-30 00:00:00	11	25	28	2	0	Running	Lop		10	2	2025-09-03 20:55:07.489
cmf4gitce000bqql1mn7lsfv0	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:56:01.549	9.6	74	2025-09-01 00:00:00	43	22	5	4	0	Running	Lop		10	4	2025-09-03 20:56:01.549
cmf4gkict000dqql1cseljuq8	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:57:20.608	15	59	2025-09-02 00:00:00	54	5	0	0	0	RollerSki_Skate	Rulleski skoyte		7	3	2025-09-03 20:57:20.608
cmf4gm3n9000fqql1ppvqrzik	cmc5e85an0000qq8ty9tz0rxl	2025-09-03 20:58:34.869	15	60	2025-09-03 00:00:00	21	26	8	5	0	RollerSki_Classic	Rulleski klassisk		9	3	2025-09-03 20:58:34.869
cmfjgm39r0003qquar0r096tv	cmc5e85an0000qq8ty9tz0rxl	2025-09-14 08:55:07.022	\N	35	2025-09-12 00:00:00	35	0	0	0	0	StrengthTraining	Силовая тренировка	Комплекс упражнений	10	9	2025-09-14 08:55:07.022
cmfjgkpp00001qqua5ebd3sjb	cmc5e85an0000qq8ty9tz0rxl	2025-09-14 08:54:02.76	50	118	2025-09-13 00:00:00	0	0	0	15	103	RollerSki_Skate	Лыжероллеры свободный стиль	Соревнования по лыжероллерам, свободный стиль	10	6	2025-09-14 08:55:35.504
cmfwxzwsp0003o50j3km38i9b	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:22:45.563	7.3	47	2025-09-15 00:00:00	18	22	6	1	0	Running	Беговая тренировка		8	6	2025-09-23 19:22:45.563
cmfll1mzi0006o50jgx1u8p1i	cmflkyp110004o50j0527uijf	2025-09-15 20:34:43.229	3	15	2025-09-15 00:00:00	15	0	0	0	0	XC_Skiing_Classic	test	test	3	4	2025-09-15 20:34:43.229
cmfwy0noa0005o50j5qbkw55j	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:23:20.41	\N	60	2025-09-15 00:00:00	60	0	0	0	0	StrengthTraining	Силовая тренировка		7	6	2025-09-23 19:23:20.41
cmfwy6sco0007o50jax4xvl6h	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:28:06.398	6	40	2025-09-17 00:00:00	4	27	8	1	0	Running	Беговая тренировка		7	7	2025-09-23 19:28:06.398
cmfwyc7tm0009o50jl0fmno6z	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:32:19.737	26.8	103	2025-09-18 00:00:00	25	34	35	7	2	RollerSki_Skate	Лыжероллеры свободным стилем		7	6	2025-09-23 19:32:19.737
cmfwye30p000bo50j1qubar6m	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:33:46.816	5.6	35	2025-09-18 00:00:00	14	20	1	0	0	Running	Беговая тренировка		4	8	2025-09-23 19:33:46.816
cmfwyhvdi000do50j1jn5j7lo	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:36:43.541	\N	16	2025-09-19 00:00:00	16	0	0	0	0	StrengthTraining	ХС		8	7	2025-09-23 19:36:43.541
cmfwyjre0000fo50ji1wqwall	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:38:11.686	4.9	31	2025-09-19 00:00:00	6	25	0	0	0	Running	Беговая тренировка		8	6	2025-09-23 19:38:11.686
cmfwykood000ho50j5dv91yga	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:38:54.817	\N	41	2025-09-19 00:00:00	41	0	0	0	0	StrengthTraining	Силовая тренировка		8	8	2025-09-23 19:38:54.817
cmfwymjho000jo50jfngqoznd	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:40:21.419	22.1	85	2025-09-20 00:00:00	24	42	14	5	0	RollerSki_Classic	Лыжероллеры классическим стилем		8	6	2025-09-23 19:40:21.419
cmfwyopie000lo50jigr2o9ui	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:42:02.533	18.6	63	2025-09-21 00:00:00	53	10	0	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		7	4	2025-09-23 19:42:02.533
cmfwytwyo000no50japw24kjr	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:46:05.471	\N	60	2025-09-04 00:00:00	60	0	0	0	0	StrengthTraining	Силовая тренировка		7	7	2025-09-23 19:46:05.471
cmhkkow1i0015sw0j8t5cb07z	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:56:26.934	\N	60	2025-10-28 00:00:00	60	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-11-04 12:56:26.934
cmfwyvl9c000po50jdw74q76u	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:47:23.615	32.4	115	2025-09-06 00:00:00	33	68	11	3	0	RollerSki_Classic	Лыжероллеры классическим стилем		\N	6	2025-09-23 19:47:23.615
cmfwyw98x000ro50jzt1iurct	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:47:54.704	\N	16	2025-09-08 00:00:00	16	0	0	0	0	StrengthTraining	ХС		8	6	2025-09-23 19:47:54.704
cmfwyxx7f000to50jyw9pnl9c	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:49:12.41	11.2	40	2025-09-08 00:00:00	14	18	6	2	0	RollerSki_Skate	Лыжероллеры свободным стилем		6	7	2025-09-23 19:49:12.41
cmfwyyob2000vo50jzrsxq6vd	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:49:47.524	\N	58	2025-09-08 00:00:00	58	0	0	0	0	StrengthTraining	Силовая тренировка		7	5	2025-09-23 19:49:47.524
cmfwz0pje000xo50j51ooyjck	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:51:22.44	23.1	89	2025-09-09 00:00:00	14	43	29	3	0	RollerSki_Classic	Лыжероллеры классическим стилем		6	7	2025-09-23 19:51:22.44
cmfwz3ju3000zo50jnbdzrfva	cmc5e85an0000qq8ty9tz0rxl	2025-09-23 19:53:35.017	12.5	98	2025-09-10 00:00:00	55	32	8	3	0	Running	Имитация с палками		7	6	2025-09-23 19:53:35.017
cmfxu280i0011o50jjk4fet9f	cmc5e85an0000qq8ty9tz0rxl	2025-09-24 10:20:21.137	23.1	87	2025-09-24 00:00:00	2	30	26	29	0	RollerSki_Classic	Лыжероллеры классическим стилем	Утренняя тренировка, состояние тяжёлое, высоковатый пульс	8	2	2025-09-24 10:20:21.137
cmg2pvooo0013o50j6g6asg6p	cmc5e85an0000qq8ty9tz0rxl	2025-09-27 20:22:08.566	2.9	33	2025-09-25 00:00:00	33	0	0	0	0	Running	Беговая тренировка		7	1	2025-09-27 20:22:08.566
cmg2px6nn0015o50jvezzbaef	cmc5e85an0000qq8ty9tz0rxl	2025-09-27 20:23:18.514	9.3	35	2025-09-26 00:00:00	10	25	0	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		7	4	2025-09-27 20:23:18.514
cmg2py3y40017o50jtt23uhrb	cmc5e85an0000qq8ty9tz0rxl	2025-09-27 20:24:01.649	\N	56	2025-09-26 00:00:00	56	0	0	0	0	StrengthTraining	Силовая тренировка		10	4	2025-09-27 20:24:01.649
cmg2pyya90019o50jhvbaxinn	cmc5e85an0000qq8ty9tz0rxl	2025-09-27 20:24:40.975	3	20	2025-09-26 00:00:00	0	10	10	0	0	Running	Беговая тренировка 		8	2	2025-09-27 20:24:40.975
cmg2q0f4t001bo50j5587ox1c	cmc5e85an0000qq8ty9tz0rxl	2025-09-27 20:25:49.468	9.1	59	2025-09-27 00:00:00	10	49	0	0	0	Running	Беговая тренировка		8	2	2025-09-27 20:25:49.468
cmgdeshci0001o50iocxjntul	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 07:57:11.247	24.5	94	2025-09-27 00:00:00	18	54	20	2	0	RollerSki_Skate	Лыжероллеры свободным стилем		8	7	2025-10-05 07:57:11.247
cmgdeuvf70003o50inxsyb0gt	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 07:59:02.801	13.8	60	2025-09-29 00:00:00	24	23	13	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		6	8	2025-10-05 07:59:02.801
cmgdevp3p0005o50i2wtiycek	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 07:59:41.258	\N	60	2025-09-29 00:00:00	60	0	0	0	0	StrengthTraining	Силовая тренировка		7	7	2025-10-05 07:59:41.258
cmgdf6gjz0009o50ipmxeou0c	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 08:08:03.392	11.7	40	2025-10-01 00:00:00	2	14	12	11	1	RollerSki_Skate	Лыжероллеры свободным стилем		7	6	2025-10-05 08:08:03.392
cmgdf85t3000bo50i0qjbp27u	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 08:09:22.788	20.7	81	2025-10-02 00:00:00	38	40	3	0	0	RollerSki_Classic	Лыжероллеры классическим стилем		7	6	2025-10-05 08:09:22.788
cmgdfagvo000fo50i48bcx799	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 08:11:10.45	\N	55	2025-10-04 00:00:00	55	0	0	0	0	StrengthTraining	Силовая тренировка		10	7	2025-10-05 08:11:10.45
cmgdf9m2a000do50iov2oui6w	cmc5e85an0000qq8ty9tz0rxl	2025-10-05 08:10:30.511	18.2	65	2025-10-04 00:00:00	18	19	20	8	0	RollerSki_Skate	Лыжероллеры свободным стилем		8	3	2025-10-05 08:11:25.086
cmgmjyyc50001sw0juhcv0jp3	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:32:06.863	7.5	50	2025-10-01 00:00:00	50	0	0	0	0	Running	Беговая тренировка		5	4	2025-10-11 17:32:06.863
cmgmk2y9j0003sw0jxrkpoqo3	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:35:13.387	13.4	120	2025-10-05 00:00:00	59	42	15	4	0	Running	Бег с палками	Шаговая имитация с палками в подъем	10	7	2025-10-11 17:35:13.387
cmgmk46hd0005sw0jlm5lafff	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:36:10.704	4.2	30	2025-10-07 00:00:00	30	0	0	0	0	Running	Беговая тренировка		6	4	2025-10-11 17:36:10.704
cmgmk4qjh0007sw0j52l0v0v1	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:36:36.7	\N	30	2025-10-07 00:00:00	30	0	0	0	0	StrengthTraining	Силовая тренировка		10	7	2025-10-11 17:36:36.7
cmgmk6kvx0009sw0j4d6jtyn4	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:38:02.684	14.1	57	2025-10-09 00:00:00	25	25	7	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		6	6	2025-10-11 17:38:02.684
cmgmk7gvl000bsw0j0evewdub	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:38:44.143	\N	56	2025-10-10 00:00:00	56	0	0	0	0	StrengthTraining	Силовая тренировка		10	8	2025-10-11 17:39:14.345
cmgmk8uzf000dsw0ja9fuauv7	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:39:49.081	\N	16	2025-10-10 00:00:00	16	0	0	0	0	StrengthTraining	XC тренажер		10	9	2025-10-11 17:39:49.081
cmgmkboxn000fsw0j3vmu1yoy	cmc5e85an0000qq8ty9tz0rxl	2025-10-11 17:42:01.198	34	120	2025-10-11 00:00:00	13	56	43	8	0	RollerSki_Classic	Лыжероллеры классическим стилем	Double poling	10	7	2025-10-11 17:42:31.419
cmhkk8wyn000hsw0j69w9lf22	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:44:01.63	32.4	121	2025-01-12 00:00:00	13	56	43	8	1	RollerSki_Skate	Лыжероллеры свободным стилем		10	10	2025-11-04 12:44:01.63
cmhkkaihj000jsw0jagvvcgwv	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:45:16.183	32.4	117	2025-10-12 00:00:00	90	27	0	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		10	10	2025-11-04 12:45:16.183
cmhkkb93z000lsw0j01nay8ne	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:45:50.686	\N	58	2025-10-14 00:00:00	58	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-11-04 12:45:50.686
cmhkkdlnc000nsw0j58ss17ss	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:47:40.237	6.1	40	2025-10-15 00:00:00	40	0	0	0	0	Running	Беговая тренировка		10	10	2025-11-04 12:47:40.237
cmhkkelch000psw0jtwwicszy	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:48:26.513	15	65	2025-10-16 00:00:00	42	23	0	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		10	8	2025-11-04 12:48:26.513
cmhkkf52t000rsw0jo3b4hq5y	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:48:52.081	\N	16	2025-10-17 00:00:00	16	0	0	0	0	StrengthTraining	ХС		10	8	2025-11-04 12:48:52.081
cmhkkfsod000tsw0jq70ovfpy	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:49:22.669	\N	57	2025-10-17 00:00:00	57	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-11-04 12:49:22.669
cmhkkh20u000vsw0j0nf3hpwq	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:50:21.438	31.4	120	2025-10-18 00:00:00	10	35	25	44	6	RollerSki_Classic	Лыжероллеры классическим стилем		10	8	2025-11-04 12:50:21.438
cmhkkiakd000xsw0jh92jxxaa	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:51:19.165	14	58	2025-10-19 00:00:00	25	25	8	0	0	RollerSki_Skate	Лыжероллеры свободным стилем		10	9	2025-11-04 12:51:19.165
cmhkkl8t1000zsw0jcw6qp7y1	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:53:36.852	12.9	54	2025-10-23 00:00:00	9	21	19	5	0	RollerSki_Classic	Лыжероллеры классическим стилем		10	10	2025-11-04 12:53:36.852
cmhkkmvm80011sw0j8q0yn24y	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:54:53.072	16	62	2025-10-25 00:00:00	12	14	16	18	2	RollerSki_Skate	Лыжероллеры свободным стилем		10	10	2025-11-04 12:54:53.072
cmhkkoakd0013sw0jyk1dncis	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:55:59.101	15.1	67	2025-10-26 00:00:00	21	35	8	3	0	RollerSki_Classic	Лыжероллеры классическим стилем		10	8	2025-11-04 12:55:59.101
cmhkkqie80017sw0jd3d6asq4	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:57:42.55	13.9	61	2025-10-30 00:00:00	12	30	15	4	0	RollerSki_Classic	Лыжероллеры классическим стилем		10	10	2025-11-04 12:57:42.55
cmhkkrwyr0019sw0j9gshl0va	cmc5e85an0000qq8ty9tz0rxl	2025-11-04 12:58:48.098	13.8	62	2025-10-31 00:00:00	10	25	19	7	1	RollerSki_Skate	Лыжероллеры свободным стилем		10	10	2025-11-04 12:58:48.098
cmiilzpx7001bsw0jl94oaf4t	cmc5e85an0000qq8ty9tz0rxl	2025-11-28 08:37:01.818	8.3	50	2025-11-28 00:00:00	22	28	0	0	0	Running	Беговая тренировка	Беговой тренажер	6	8	2025-11-28 08:37:01.818
cmijyritp001dsw0j2ck9zoqw	cmc5e85an0000qq8ty9tz0rxl	2025-11-29 07:22:20.557	\N	10	2025-11-28 00:00:00	0	10	0	0	0	StrengthTraining	XC		10	7	2025-11-29 07:22:20.557
cmilfr6fg001fsw0j32a3dynx	cmc5e85an0000qq8ty9tz0rxl	2025-11-30 08:05:44.129	15.1	62	2025-11-29 00:00:00	1	8	15	23	15	RollerSki_Skate	Лыжероллеры коньковым стилем	Катался на резине, после большого перерыва это не просто. Погода сырая, толкнуться ногами не получается, тренировка почти на руках.	10	7	2025-11-30 08:05:44.129
cmiqx0lje001jsw0jhzlhp9ph	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:07:47.97	16.1	64	2025-11-30 00:00:00	1	11	15	20	17	RollerSki_Skate	Лыжероллеры коньковым сиилем	Катался на тяжёлых роллерах, мышцы чувствовали себя уже лучше, но пульс все ещё тяжелый	10	6	2025-12-04 04:07:47.97
cmiqx1gkq001lsw0jrtm8lgf5	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:08:28.202	\N	10	2025-12-02 00:00:00	10	0	0	0	0	StrengthTraining	XC	Лыжный тренажер	10	9	2025-12-04 04:08:28.202
cmiqx2jsr001nsw0jbzeizq3r	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:09:19.035	\N	47	2025-12-02 00:00:00	47	0	0	0	0	StrengthTraining	Силовая тренировка	Упражнения	10	7	2025-12-04 04:09:19.035
cmiqx3yax001psw0joi7gfbm9	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:10:24.489	13.9	58	2025-12-03 00:00:00	10	42	6	0	0	RollerSki_Skate	Лыжероллеры коньковым стилем		8	7	2025-12-04 04:10:24.489
cmisd2dmq001rsw0jjz5yuq0f	cmc5e85an0000qq8ty9tz0rxl	2025-12-05 04:24:51.074	13.7	63	2025-12-04 00:00:00	9	26	22	6	0	RollerSki_Classic	Лыжероллеры классическим стилем		8	7	2025-12-05 04:24:51.074
cmitxym3y001tsw0jvw83ahby	cmc5e85an0000qq8ty9tz0rxl	2025-12-06 06:57:33.55	12.9	64	2025-12-05 00:00:00	24	30	10	0	0	RollerSki_Skate	Лыжероллеры коньковым стилем	Тренировался на тяжёлых роллерых, прогулочный темп	6	8	2025-12-06 06:57:33.55
cmitxzmxd001vsw0j0r017xl7	cmc5e85an0000qq8ty9tz0rxl	2025-12-06 06:58:21.265	\N	54	2025-12-06 00:00:00	54	0	0	0	0	StrengthTraining	Силовая тренировка	Упражнения	10	9	2025-12-06 06:58:21.265
cmiwozadv0001sw0jena4qc3j	cmc5e85an0000qq8ty9tz0rxl	2025-12-08 05:09:26.983	22.2	103	2025-12-06 00:00:00	34	50	17	2	0	RollerSki_Classic	Лыжероллеры классическим стилем	Было тяжеловато, пульс все ещё высоковатый	10	7	2025-12-08 05:09:26.983
cmiwp1rsq0003sw0jr87mabzg	cmc5e85an0000qq8ty9tz0rxl	2025-12-08 05:11:22.872	23.2	104	2025-12-07 00:00:00	40	53	10	1	0	RollerSki_Skate	Лыжероллеры свободным стилем	Сегодня чувствовал себя получше, но вот пульс все ещё высокой, никак не восстановится. Тренировался на тяжёлых роллерах	3	8	2025-12-08 05:11:22.872
cmiz1ijn20005sw0jxm5ntqnr	cmc5e85an0000qq8ty9tz0rxl	2025-12-09 20:35:53.198	\N	10	2025-12-09 00:00:00	0	10	0	0	0	StrengthTraining	ХС	Лыжный тренажер	10	8	2025-12-09 20:35:53.198
cmiz1jhy70007sw0j65mikoqy	cmc5e85an0000qq8ty9tz0rxl	2025-12-09 20:36:37.661	\N	50	2025-12-09 00:00:00	50	0	0	0	0	StrengthTraining	Силовая тренировка	Силовые упражнения	10	9	2025-12-09 20:36:37.661
cmjb15ypg0009sw0jra5qqd8v	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 05:59:20.298	14.4	79	2025-12-10 00:00:00	7	43	22	7	0	XC_Skiing_Skate	Лыжи свободным стилем		9	5	2025-12-18 06:01:25.863
cmjb17xc0000bsw0jscknlu28	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 06:00:51.84	20	32	2025-12-11 00:00:00	3	16	10	3	0	XC_Skiing_Classic	Лыжи классическим стилем		9	6	2025-12-18 06:01:37.521
cmjb1aab9000dsw0johavkt78	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 06:02:41.972	16.8	92	2025-12-14 00:00:00	31	48	13	0	0	XC_Skiing_Skate	Лыжи свободным стилем		10	7	2025-12-18 06:02:41.972
cmjdux8hh000fsw0jik3ps3e4	cmc5e85an0000qq8ty9tz0rxl	2025-12-20 05:27:53.909	21	91	2025-12-18 00:00:00	3	78	10	0	0	XC_Skiing_Skate	Лыжи свободным стилем		10	4	2025-12-20 05:27:53.909
cmjduyvbn000hsw0jxsnrwchw	cmc5e85an0000qq8ty9tz0rxl	2025-12-20 05:29:10.162	19.3	90	2025-12-19 00:00:00	2	43	35	10	0	XC_Skiing_Classic	Лыжи классическим стилем		10	5	2025-12-20 05:29:10.162
\.


--
-- Name: DailyInformation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fasx_user
--

SELECT pg_catalog.setval('public."DailyInformation_id_seq"', 16, true);


--
-- Name: DailyInformation DailyInformation_pkey; Type: CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."DailyInformation"
    ADD CONSTRAINT "DailyInformation_pkey" PRIMARY KEY (id);


--
-- Name: Follow Follow_pkey; Type: CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Follow"
    ADD CONSTRAINT "Follow_pkey" PRIMARY KEY (id);


--
-- Name: Profile Profile_pkey; Type: CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Profile"
    ADD CONSTRAINT "Profile_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Workout Workout_pkey; Type: CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Workout"
    ADD CONSTRAINT "Workout_pkey" PRIMARY KEY (id);


--
-- Name: Profile_userId_key; Type: INDEX; Schema: public; Owner: fasx_user
--

CREATE UNIQUE INDEX "Profile_userId_key" ON public."Profile" USING btree ("userId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: fasx_user
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Follow Follow_followerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Follow"
    ADD CONSTRAINT "Follow_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Follow Follow_followingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Follow"
    ADD CONSTRAINT "Follow_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Profile Profile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Profile"
    ADD CONSTRAINT "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Workout Workout_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."Workout"
    ADD CONSTRAINT "Workout_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DailyInformation fk_daily_user; Type: FK CONSTRAINT; Schema: public; Owner: fasx_user
--

ALTER TABLE ONLY public."DailyInformation"
    ADD CONSTRAINT fk_daily_user FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict ksNx0nQV6dB5Nj6zNEpPfwmW27rgLW7zzBwxXO9CqrKAbz9M9dRWe4DmJwDZbeT

