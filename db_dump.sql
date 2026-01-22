--
-- PostgreSQL database dump
--

\restrict 0xNM0C3bqGHnhL64JlF6w65Tdqz5kHc9eqzPpK60E2SQVSrGs75BUckSzfGhNkn

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
17	cmc5e85an0000qq8ty9tz0rxl	2025-12-27 00:00:00	skadet	4	3	9	62	09:00	Сегодня так же не тренируюсь, восстанавливаюсь	2025-12-27 07:15:09.47
31	cmc5e85an0000qq8ty9tz0rxl	2026-01-09 00:00:00	syk	4	1	5	52	06:00	Пульс немного опустился лежа, но боли за грудиной опять начались после вчерашней тренировки	2026-01-09 07:08:54.682
18	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 00:00:00	skadet,fridag	4	3	9	62	07:30	Сегодня утром немного чувствовал тяжесть в груди, продолжаю отдыхать и реабилитироваться	2025-12-28 06:53:41.356
19	cmc5e85an0000qq8ty9tz0rxl	2025-12-29 00:00:00	skadet,fridag	3	3	1	65	04:00	\N	2025-12-29 19:25:33.142
20	cmc5e85an0000qq8ty9tz0rxl	2025-12-30 00:00:00	skadet,fridag	2	3	2	60	08:00	\N	2025-12-30 07:28:16.708
21	cmjsaxmce0000l80wxeswp94e	2025-12-30 00:00:00		5	5	5	\N	\N	\N	2025-12-30 08:05:58.488
22	cmc5e85an0000qq8ty9tz0rxl	2025-12-31 00:00:00		3	2	8	72	07:30	Сегодня чувствую себя лучше, но пульс утром лежа высоковат, так же очень плохо засыпал ночью	2025-12-31 07:05:40.55
32	cmc5e85an0000qq8ty9tz0rxl	2026-01-10 00:00:00	syk	5	8	10	58	08:00	Сегодня утром чувствую себя лучше, заложенности в груди почти нет, хотя вчера тренировался	2026-01-10 07:25:08.344
23	cmc5e85an0000qq8ty9tz0rxl	2026-01-01 00:00:00	skadet,syk	4	0	0	\N	\N	\N	2026-01-01 19:28:22.349
24	cmc5e85an0000qq8ty9tz0rxl	2026-01-02 00:00:00	skadet,fridag	2	1	7	63	07:00	\N	2026-01-02 09:18:04.359
25	cmjwvg1nw0004kh0v3mdpyece	2026-01-02 00:00:00		4	4	4	\N	\N	\N	2026-01-02 12:51:03.191
26	cmc5e85an0000qq8ty9tz0rxl	2026-01-03 00:00:00	syk,fridag,skadet	2	2	8	73	07:00	\N	2026-01-03 07:56:51.386
27	cmc5e85an0000qq8ty9tz0rxl	2026-01-04 00:00:00	skadet,syk,fridag	4	1	8	73	07:00	Боль в груди утром, пульс никак не восстановится	2026-01-04 08:25:45.273
28	cmc5e85an0000qq8ty9tz0rxl	2026-01-07 00:00:00	skadet,syk,fridag	4	4	8	60	08:00	\N	2026-01-07 13:37:50.982
29	cmc5e85an0000qq8ty9tz0rxl	2026-01-06 00:00:00	skadet,syk,fridag	2	3	8	59	08:30	\N	2026-01-07 13:38:13.091
33	cmc5e85an0000qq8ty9tz0rxl	2026-01-11 00:00:00	syk	5	5	1	56	04:00	Плохо спал, давило на грудь, утром проснулся состояние не поменялось, даже не знаю стоит ли сегодня тренироваться, хотя после нагрузки состояние не ухудшается	2026-01-11 05:00:09.997
30	cmc5e85an0000qq8ty9tz0rxl	2026-01-08 00:00:00	skadet,syk	4	4	9	60	08:00	\N	2026-01-08 13:09:29.145
35	cmc5e85an0000qq8ty9tz0rxl	2026-01-13 00:00:00	syk	4	7	10	58	07:00	Состояние хорошее, пуль утром нормальный в полусидячем состоянии 57	2026-01-13 05:46:49.637
34	cmc5e85an0000qq8ty9tz0rxl	2026-01-12 00:00:00	syk,fridag	5	4	10	53	07:30	Утром была заложенность в носу, стоя был немного завышен пульс и тяжело дышать из за того что забит нос	2026-01-12 09:07:39.237
36	cmc5e85an0000qq8ty9tz0rxl	2026-01-14 00:00:00	syk	7	9	10	54	07:20	Самочувствие хорошее, утренний пульс нормальный, сидел за ноутбуком был 70	2026-01-14 05:50:59.78
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
cmjwvi73h0006kh0vv84klxxf	cmjwvg1nw0004kh0v3mdpyece	Игорь		2026-01-02 12:51:49.228	Мужчина	Лыжные гонки		ФЛГР	{"I1": "", "I2": "", "I3": "", "I4": "", "I5": ""}	2026-01-02 12:51:49.228
cmjn3ljel0003pc0vp1k1j9la	cmc5e85an0000qq8ty9tz0rxl	Максим Балябин	Занимаюсь лыжным спортом с 2010 года	2025-12-26 16:40:40.317	Мужчина	Лыжные гонки	Fasx Ski	ФЛГР	{"I1": "110-143", "I2": "144-163", "I3": "164-173", "I4": "174-184", "I5": "185>"}	2026-01-09 12:24:40.484
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
cmjplvpzj0000nz0y3xmbcc3r	maksim.blj999@gmail.com	$2b$10$AvSAsZUqeigN0op0QNybheUUJrUMP2VReslt/67rfC1eCxRY7T28a	Ivan	\N	2025-12-28 10:48:00.847	t	\N	\N
cmjn6xjxb0000ni0xwx3qewcg	blackbad078@gmail.com	$2b$10$xRagZdwtq2DbTV1/EqCW7eAXtBA5PTXzbOqCn3LtAnvb/IkJugXl6	Ivan	\N	2025-12-26 18:13:59.712	f	c2acf63750b94389d73a3c30ea65785f4318ba23b93af023cda522e306c956d1	\N
cmjsaxmce0000l80wxeswp94e	m.balyabin095@yandex.ru	$2b$10$RjT8sDfy72r2NQIlj1JvKO/Ybya9lWCv5CqVPWgE.L/lxweR/vk7.	Maksim	\N	2025-12-30 08:04:52.19	t	\N	\N
cmjt8oyxs0001l80wopyi5vgp	sdf2edwedwd@xitroo.com	$2b$10$vvsgMtV3whtrEjgGzcwrfuBaU.n/jLug6uVfPv1WN3g8yBrFNvZVi	sdf2edwedwd@xitroo.com	\N	2025-12-30 23:49:55.552	t	\N	\N
cmjwvatna0002kh0v7nqnuy6o	mxbaljabin999@gmail.com	$2b$10$Jgf9fHoBpbzlSgRFuJgvBucmMToq19DR5puRzzLNwRFb0.xNw1hvy	Maksim	\N	2026-01-02 12:46:05.206	f	ddc0e3694fb6dfffa3a40dc032f1a68fd26bd70ce8dcb9be20021bab68fbcd2f	\N
cmjwvegdg0003kh0vums8ofmy	b.igor1969@gmail.com	$2b$10$bg4QBWDYwKQ8eMhw8lk3w.GBv0PCskI4dfS3mzsdy8b4e9PvAfOv.	Igor	\N	2026-01-02 12:48:54.628	f	084ea41771cac32ab17778e221521b8d83d5c862256edc202cfa9a8f3bd5658b	\N
cmjn91qtq0000p40xtdeg2t7h	mxbaljabin@gmail.com	$2b$10$EKo5CsijDvoBW3p0FuzlpunnNexJFAXC5ecbVMhSv4hlBRNk/xUH2	ivan	\N	2025-12-26 19:13:14.511	t	\N	\N
cmc5e85an0000qq8ty9tz0rxl	baliabin.maksim@gmail.com	$2b$10$VIQRw5F1lgN2UhxXDsuuEeC1SoPfFnTeL6L..iEZoS3QjvCWi1xIy	Максим Балябин	https://s3.twcstorage.ru/49ffd73c-29437e7b-93fb-418e-8e49-2e57148af1b4/avatars/cmc5e85an0000qq8ty9tz0rxl-1767957855271-thumb.jpg	2025-06-20 22:40:23.759	t	\N	https://s3.twcstorage.ru/49ffd73c-29437e7b-93fb-418e-8e49-2e57148af1b4/avatars/cmc5e85an0000qq8ty9tz0rxl-1767957855271-full.jpg
cmjwvg1nw0004kh0v3mdpyece	b.igorr1969@gmail.com	$2b$10$oqUo6oGogUYfwi5h4OuYgOclyDjYSFzAgGBvm/5sMMVWRyHQcuIla	Игорь	\N	2026-01-02 12:50:08.877	t	\N	\N
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
cmiqx1gkq001lsw0jrtm8lgf5	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:08:28.202	\N	10	2025-12-02 00:00:00	10	0	0	0	0	StrengthTraining	XC	Лыжный тренажер	10	9	2025-12-04 04:08:28.202
cmiqx2jsr001nsw0jbzeizq3r	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:09:19.035	\N	47	2025-12-02 00:00:00	47	0	0	0	0	StrengthTraining	Силовая тренировка	Упражнения	10	7	2025-12-04 04:09:19.035
cmiqx3yax001psw0joi7gfbm9	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:10:24.489	13.9	58	2025-12-03 00:00:00	10	42	6	0	0	RollerSki_Skate	Лыжероллеры коньковым стилем		8	7	2025-12-04 04:10:24.489
cmisd2dmq001rsw0jjz5yuq0f	cmc5e85an0000qq8ty9tz0rxl	2025-12-05 04:24:51.074	13.7	63	2025-12-04 00:00:00	9	26	22	6	0	RollerSki_Classic	Лыжероллеры классическим стилем		8	7	2025-12-05 04:24:51.074
cmitxym3y001tsw0jvw83ahby	cmc5e85an0000qq8ty9tz0rxl	2025-12-06 06:57:33.55	12.9	64	2025-12-05 00:00:00	24	30	10	0	0	RollerSki_Skate	Лыжероллеры коньковым стилем	Тренировался на тяжёлых роллерых, прогулочный темп	6	8	2025-12-06 06:57:33.55
cmiwozadv0001sw0jena4qc3j	cmc5e85an0000qq8ty9tz0rxl	2025-12-08 05:09:26.983	22.2	103	2025-12-06 00:00:00	34	50	17	2	0	RollerSki_Classic	Лыжероллеры классическим стилем	Было тяжеловато, пульс все ещё высоковатый	10	7	2025-12-08 05:09:26.983
cmiwp1rsq0003sw0jr87mabzg	cmc5e85an0000qq8ty9tz0rxl	2025-12-08 05:11:22.872	23.2	104	2025-12-07 00:00:00	40	53	10	1	0	RollerSki_Skate	Лыжероллеры свободным стилем	Сегодня чувствовал себя получше, но вот пульс все ещё высокой, никак не восстановится. Тренировался на тяжёлых роллерах	3	8	2025-12-08 05:11:22.872
cmiz1ijn20005sw0jxm5ntqnr	cmc5e85an0000qq8ty9tz0rxl	2025-12-09 20:35:53.198	\N	10	2025-12-09 00:00:00	0	10	0	0	0	StrengthTraining	ХС	Лыжный тренажер	10	8	2025-12-09 20:35:53.198
cmiz1jhy70007sw0j65mikoqy	cmc5e85an0000qq8ty9tz0rxl	2025-12-09 20:36:37.661	\N	50	2025-12-09 00:00:00	50	0	0	0	0	StrengthTraining	Силовая тренировка	Силовые упражнения	10	9	2025-12-09 20:36:37.661
cmjb15ypg0009sw0jra5qqd8v	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 05:59:20.298	14.4	79	2025-12-10 00:00:00	7	43	22	7	0	XC_Skiing_Skate	Лыжи свободным стилем		9	5	2025-12-18 06:01:25.863
cmjb1aab9000dsw0johavkt78	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 06:02:41.972	16.8	92	2025-12-14 00:00:00	31	48	13	0	0	XC_Skiing_Skate	Лыжи свободным стилем		10	7	2025-12-18 06:02:41.972
cmjdux8hh000fsw0jik3ps3e4	cmc5e85an0000qq8ty9tz0rxl	2025-12-20 05:27:53.909	21	91	2025-12-18 00:00:00	3	78	10	0	0	XC_Skiing_Skate	Лыжи свободным стилем		10	4	2025-12-20 05:27:53.909
cmjduyvbn000hsw0jxsnrwchw	cmc5e85an0000qq8ty9tz0rxl	2025-12-20 05:29:10.162	19.3	90	2025-12-19 00:00:00	2	43	35	10	0	XC_Skiing_Classic	Лыжи классическим стилем		10	5	2025-12-20 05:29:10.162
cmjpfwmwk0007td0wgqceb8ol	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 08:00:45.812	20.19	91	2025-12-20 00:00:00	6	83	2	0	0	XC_Skiing_Skate	Лыжи свободный стиль		9	10	2025-12-28 08:00:45.812
cmjpfzywt0009td0wxkl7pxfw	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 08:03:21.341	\N	53	2025-12-05 00:00:00	53	0	0	0	0	StrengthTraining	Силовая тренировка		10	8	2025-12-28 08:03:21.341
cmjb17xc0000bsw0jscknlu28	cmc5e85an0000qq8ty9tz0rxl	2025-12-18 06:00:51.84	20	90	2025-12-11 00:00:00	3	76	11	0	0	XC_Skiing_Classic	Лыжи классическим стилем		9	6	2025-12-28 08:05:45.522
cmjpg5kin000btd0wuakf9ktx	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 08:07:42.623	13.95	62	2025-11-09 00:00:00	7	22	19	14	0	RollerSki_Skate	Лыжероллеры свободным стилем		8	7	2025-12-28 08:07:42.623
cmjpg6fh2000dtd0w8fl6duuj	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 08:08:22.742	\N	59	2025-11-10 00:00:00	14	23	18	4	0	RollerSki_Skate	Лыжероллеры классическим стилем		10	7	2025-12-28 08:08:22.742
cmjpga0hg000htd0wlxc3l2rf	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 08:11:09.94	\N	43	2025-11-22 00:00:00	1	7	9	15	11	RollerSki_Skate	Лыжероллеры свободный стиль		7	7	2025-12-28 08:11:09.94
cmiqx0lje001jsw0jhzlhp9ph	cmc5e85an0000qq8ty9tz0rxl	2025-12-04 04:07:47.97	16.1	64	2025-11-30 00:00:00	1	11	15	20	17	RollerSki_Skate	Лыжероллеры коньковым стилем	Катался на тяжёлых роллерах, мышцы чувствовали себя уже лучше, но пульс все ещё тяжелый	10	6	2025-12-28 10:54:11.789
cmjq3kr2u0001n70xf4w6y3pp	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:03:22.134	51	180	2025-07-26 00:00:00	150	30	0	0	0	RollerSki_Skate	Лыжероллеры коньковый стиль		10	8	2025-12-28 19:03:22.134
cmjq3losx0003n70xs415i6ie	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:04:05.834	32.63	118	2025-07-25 00:00:00	40	37	30	10	1	RollerSki_Classic	Лыжероллеры классический стиль		10	10	2025-12-28 19:04:05.834
cmjq3myf60005n70xe47ltzfs	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:05:04.961	15.66	60	2025-07-24 00:00:00	60	0	0	0	0	RollerSki_Skate	Лыжероллеры коньковый стиль		7	10	2025-12-28 19:05:04.961
cmjq3nev50007n70xyz274j5o	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:05:26.273	\N	58	2025-07-24 00:00:00	58	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-12-28 19:05:26.273
cmjq3pjp30009n70xklqbuh84	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:07:05.846	14.36	120	2025-07-23 00:00:00	73	47	0	0	0	Running	Шаговая имитация		10	10	2025-12-28 19:07:05.846
cmjq3qhf0000bn70x5nmtxtlh	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:07:49.548	33.83	120	2025-07-22 00:00:00	38	35	38	9	0	RollerSki_Skate	Лыжероллеры коньковый стиль		10	10	2025-12-28 19:07:49.548
cmjq3r454000dn70xq5rne0e7	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:08:19	\N	16	2025-07-21 00:00:00	0	16	0	0	0	StrengthTraining	XC		10	10	2025-12-28 19:08:19
cmjq3sl4d000fn70x4evyoucd	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:09:27.653	9.51	67	2025-07-21 00:00:00	30	34	3	0	0	Running	Беговая тренировка		10	8	2025-12-28 19:09:27.653
cmjq3t4dg000hn70xzt4q7fje	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:09:52.612	\N	55	2025-07-21 00:00:00	55	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-12-28 19:09:52.612
cmjq3u06n000jn70x5ntrwd55	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:10:33.838	54.26	185	2025-07-19 00:00:00	181	4	0	0	0	RollerSki_Skate	Лыжероллеры коньковый стиль		10	7	2025-12-28 19:10:33.838
cmjq3v9gr000ln70x7q9jaznh	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:11:32.523	34.59	120	2025-07-18 00:00:00	36	44	6	18	16	RollerSki_Classic	Лыжероллеры классика Interval		8	10	2025-12-28 19:11:32.523
cmjq3w8fi000nn70xc32txjw2	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:12:17.838	18.42	69	2025-07-17 00:00:00	68	1	0	0	0	RollerSki_Skate	Лыжероллеры коньковым стилем		10	10	2025-12-28 19:12:17.838
cmjq3wtp4000pn70xxh6es7rb	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:12:45.4	\N	16	2025-07-17 00:00:00	0	16	0	0	0	StrengthTraining	XC		10	10	2025-12-28 19:12:45.4
cmjq3xarj000rn70xldmkb93y	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:13:07.519	\N	49	2025-07-17 00:00:00	49	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-12-28 19:13:07.519
cmjq3y62u000tn70x9ipbm7oq	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:13:48.102	12.47	123	2025-07-16 00:00:00	107	16	0	0	0	Running	Шаговая имитация		10	10	2025-12-28 19:13:48.102
cmjq3z123000vn70xvnqzt7x5	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:14:28.244	32.51	121	2025-07-15 00:00:00	28	50	34	6	3	RollerSki_Skate	Лыжероллеры коньковым стилем		10	10	2025-12-28 19:14:28.244
cmjq401n2000xn70xb030rkvk	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:15:15.662	16.37	60	2025-07-14 00:00:00	42	18	0	0	0	RollerSki_Classic	Лыжероллеры классическим стилем		8	10	2025-12-28 19:15:15.662
cmjq40pci000zn70x9y6mx4pz	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:15:46.384	\N	60	2025-07-14 00:00:00	60	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-12-28 19:15:46.384
cmjq41nxe0011n70xznpftoav	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:16:31.201	53.36	179	2025-07-12 00:00:00	156	23	0	0	0	RollerSki_Skate	Лыжероллеры коньковым стилем		9	10	2025-12-28 19:16:31.201
cmjq43ap00013n70xfbcrjpwt	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:17:47.363	32.73	120	2025-07-11 00:00:00	14	31	28	25	22	RollerSki_Skate	Лыжероллеры конек Interval		10	10	2025-12-28 19:17:47.363
cmjq447a90015n70xn96fhdlt	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:18:29.601	9.53	63	2025-07-10 00:00:00	26	35	2	0	0	Running	Беговая тренировка		8	10	2025-12-28 19:18:29.601
cmjq44ny90017n70xxlaw4hup	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:18:51.201	\N	58	2025-07-10 00:00:00	58	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-12-28 19:18:51.201
cmjq45d3j0019n70xrf1ti2lp	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:19:23.791	13.32	120	2025-07-09 00:00:00	93	25	2	0	0	Running	Шаговая имитация		10	10	2025-12-28 19:19:23.791
cmjq4702f001bn70x4oudbfd6	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:20:40.208	33.3	120	2025-07-08 00:00:00	70	42	6	1	1	RollerSki_Classic	Лыжероллеры классический стиль		8	10	2025-12-28 19:20:40.208
cmjq488we001dn70x17ue2ugv	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:21:38.318	16.5	50	2025-07-02 00:00:00	30	20	0	0	0	RollerSki_Classic	Лыжероллеры классический стиль		10	10	2025-12-28 19:21:38.318
cmjq4cldu001fn70xmi9h2i3u	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:25:01.122	9.89	64	2025-06-16 00:00:00	12	41	9	2	0	Running	Беговая тренировка		7	10	2025-12-28 19:25:01.122
cmjq4dx5d001hn70x2k0lr36i	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:26:03.003	17.24	65	2025-06-13 00:00:00	12	21	18	13	1	RollerSki_Skate	Лыжероллеры коньковый стиль		6	10	2025-12-28 19:26:03.003
cmjq4fpa7001jn70xafmzm3nz	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:27:26.143	20.01	120	2025-06-12 00:00:00	28	78	8	4	2	Running	Беговая тренировка		10	10	2025-12-28 19:27:26.143
cmjq4gcnc001ln70xiollo18v	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:27:56.424	13.45	120	2025-06-11 00:00:00	106	14	0	0	0	Running	Шаговая имитация		9	10	2025-12-28 19:27:56.424
cmjq4han8001nn70xmg27sspj	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:28:40.484	31.05	120	2025-06-10 00:00:00	84	32	3	1	0	RollerSki_Classic	Лыжероллеры классический стиль		10	10	2025-12-28 19:28:40.484
cmjq4i7be001pn70xrhct8paf	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:29:22.825	10.6	63	2025-06-09 00:00:00	2	5	22	30	4	Running	Беговая тренировка		7	10	2025-12-28 19:29:22.825
cmjq4io1k001rn70x503mj5n4	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:29:44.504	\N	60	2025-06-09 00:00:00	60	0	0	0	0	StrengthTraining	Силовая тренировка		10	10	2025-12-28 19:29:44.504
cmjq4jky2001tn70xgwxh8ipf	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:30:27.146	23.21	90	2025-06-07 00:00:00	77	12	1	0	0	RollerSki_Skate	Лыжероллеры коньковый стиль		8	10	2025-12-28 19:30:33.714
cmjq4kztw001vn70xcmvulm4a	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:31:33.083	24.29	89	2025-06-06 00:00:00	28	42	15	3	1	RollerSki_Classic	Лыжероллеры классический стиль		8	7	2025-12-28 19:31:33.083
cmjq4lv5j001xn70xdvyngmhm	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:32:13.684	26.33	93	2025-06-05 00:00:00	32	37	20	3	1	RollerSki_Skate	Лыжероллеры коньковый стиль		6	10	2025-12-28 19:32:13.684
cmjq4n76u001zn70xda1ozsuh	cmc5e85an0000qq8ty9tz0rxl	2025-12-28 19:33:15.942	12.07	81	2025-06-02 00:00:00	50	27	2	2	0	Running	Беговая тренировка		10	10	2025-12-28 19:33:15.942
cmjy2232j0008kh0v33joln7i	cmc5e85an0000qq8ty9tz0rxl	2026-01-03 08:43:01.002	\N	103	2025-04-01 00:00:00	49	54	0	0	0	Running	Шаговая имитация	Кросс с палками	9	9	2026-01-03 08:43:01.002
cmjy23l4z000akh0vy5pyo4aa	cmc5e85an0000qq8ty9tz0rxl	2026-01-03 08:44:11.075	32.56	121	2025-04-02 00:00:00	11	54	24	24	8	RollerSki_Classic	Лыжероллеры классический стиль		9	9	2026-01-03 08:44:11.075
cmjy24gj3000ckh0v6e8ddc3g	cmc5e85an0000qq8ty9tz0rxl	2026-01-03 08:44:51.759	\N	120	2025-04-03 00:00:00	120	0	0	0	0	Running	Беговая тренировка		8	8	2026-01-03 08:44:51.759
cmk6jkt400009lb0wtlvk2ps7	cmc5e85an0000qq8ty9tz0rxl	2026-01-09 07:15:37.44	13.02	63	2026-01-08 00:00:00	24	39	0	0	0	XC_Skiing_Skate	Лыжи свободный стиль	Тяжело тренироваться после долгого перерыва в 3 недели, очень сильно упала техника	10	2	2026-01-09 08:47:25.824
cmk72okxu0007lw0w1hrlx114	cmc5e85an0000qq8ty9tz0rxl	2026-01-09 16:10:26.177	13.54	64	2026-01-09 00:00:00	25	39	0	0	0	XC_Skiing_Skate	Лыжи свободный стиль 	Сегодня тренировка прошла уже лучше, на грудь не давило, пульс ещё высоковат.	10	7	2026-01-09 16:10:26.177
cmk99j74u0009lw0wm13zb99a	cmc5e85an0000qq8ty9tz0rxl	2026-01-11 04:57:44.67	13.54	64	2026-01-10 00:00:00	25	39	0	0	0	XC_Skiing_Skate	Лыжи свободный стиль	Самочувствие более менее. Свежий морозный снег  лыжи плохо ехали, очень тяжело было толкаться 	10	6	2026-01-11 04:57:44.67
cmk9z9gom000blw0wqnxjxma9	cmc5e85an0000qq8ty9tz0rxl	2026-01-11 16:58:00.502	11.14	62	2026-01-11 00:00:00	22	39	1	0	0	XC_Skiing_Classic	Лыжи классический стиль	Самочувствие хорошее, но трасса плохая палки проваливаются толчка практически нет исходя из этого пульс высоковат	10	8	2026-01-11 16:58:00.502
cmkcybzde000dlw0w2f5qgo5m	cmc5e85an0000qq8ty9tz0rxl	2026-01-13 18:55:16.946	12.5	70	2026-01-13 00:00:00	53	17	0	0	0	XC_Skiing_Skate	Лыжи свободный стиль	Хорошее самочувствие, лыжи хорошо ехали сегодня, но трасса рыхловатая поэтому пульс все равно для такой катухи высоковато мог быть и меньше. Сегодня получалось очень часто держать 1 зону поэтому темп снизил, что бы повысить процент тренировок в 1 й зоне	7	8	2026-01-13 18:55:16.946
\.


--
-- Name: DailyInformation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fasx_user
--

SELECT pg_catalog.setval('public."DailyInformation_id_seq"', 36, true);


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
GRANT USAGE ON SCHEMA public TO dagbook_psql;


--
-- Name: TABLE "DailyInformation"; Type: ACL; Schema: public; Owner: fasx_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."DailyInformation" TO dagbook_psql;


--
-- Name: SEQUENCE "DailyInformation_id_seq"; Type: ACL; Schema: public; Owner: fasx_user
--

GRANT SELECT,USAGE ON SEQUENCE public."DailyInformation_id_seq" TO dagbook_psql;


--
-- Name: TABLE "Follow"; Type: ACL; Schema: public; Owner: fasx_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Follow" TO dagbook_psql;


--
-- Name: TABLE "Profile"; Type: ACL; Schema: public; Owner: fasx_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Profile" TO dagbook_psql;


--
-- Name: TABLE "User"; Type: ACL; Schema: public; Owner: fasx_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."User" TO dagbook_psql;


--
-- Name: TABLE "Workout"; Type: ACL; Schema: public; Owner: fasx_user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Workout" TO dagbook_psql;


--
-- PostgreSQL database dump complete
--

\unrestrict 0xNM0C3bqGHnhL64JlF6w65Tdqz5kHc9eqzPpK60E2SQVSrGs75BUckSzfGhNkn

