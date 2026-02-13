--
-- PostgreSQL database dump
--

\restrict lWEA5C6z84kXhPStdDskLzPuQQK2xZ50Qv8kTAgPv1OhBHO10SWUHjLYDBWjvfK

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-12 22:17:02

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
-- TOC entry 225 (class 1259 OID 16526)
-- Name: ad_reward_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_reward_claims (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    claimed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 16525)
-- Name: ad_reward_claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_reward_claims_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 224
-- Name: ad_reward_claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_reward_claims_id_seq OWNED BY public.ad_reward_claims.id;


--
-- TOC entry 221 (class 1259 OID 16426)
-- Name: game_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_participants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    game_id uuid NOT NULL,
    user_id uuid,
    "position" integer NOT NULL,
    team integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT game_participants_position_check CHECK ((("position" >= 0) AND ("position" <= 3))),
    CONSTRAINT game_participants_team_check CHECK ((team = ANY (ARRAY[0, 1])))
);


--
-- TOC entry 220 (class 1259 OID 16406)
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id text,
    status text DEFAULT 'finished'::text NOT NULL,
    team0_points integer DEFAULT 0 NOT NULL,
    team1_points integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    finished_at timestamp with time zone,
    entry_price integer DEFAULT 1 NOT NULL,
    CONSTRAINT games_status_check CHECK ((status = ANY (ARRAY['finished'::text, 'cancelled'::text])))
);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN games.entry_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.games.entry_price IS 'Créditos de entrada de la mesa; usado para ranking (puntos = rondas × entry_price).';


--
-- TOC entry 223 (class 1259 OID 16493)
-- Name: iap_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.iap_transactions (
    transaction_id text NOT NULL,
    user_id uuid NOT NULL,
    product_id text NOT NULL,
    credits integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 16477)
-- Name: ranking_prize_state; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ranking_prize_state (
    id integer DEFAULT 1 NOT NULL,
    daily_last_awarded_date date,
    weekly_last_awarded_week_start date,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ranking_prize_state_id_check CHECK ((id = 1))
);


--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    apple_user_id text NOT NULL,
    email text,
    display_name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    credits numeric(10,2) DEFAULT 5 NOT NULL,
    avatar text DEFAULT '🎴'::text NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    games_played integer DEFAULT 0 NOT NULL,
    games_won integer DEFAULT 0 NOT NULL,
    total_points integer DEFAULT 0 CONSTRAINT users_ranking_points_total_not_null NOT NULL
);


--
-- TOC entry 4896 (class 2604 OID 16529)
-- Name: ad_reward_claims id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_reward_claims ALTER COLUMN id SET DEFAULT nextval('public.ad_reward_claims_id_seq'::regclass);


--
-- TOC entry 4924 (class 2606 OID 16535)
-- Name: ad_reward_claims ad_reward_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_reward_claims
    ADD CONSTRAINT ad_reward_claims_pkey PRIMARY KEY (id);


--
-- TOC entry 4913 (class 2606 OID 16441)
-- Name: game_participants game_participants_game_id_position_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_participants
    ADD CONSTRAINT game_participants_game_id_position_key UNIQUE (game_id, "position");


--
-- TOC entry 4915 (class 2606 OID 16439)
-- Name: game_participants game_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_participants
    ADD CONSTRAINT game_participants_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 2606 OID 16423)
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- TOC entry 4921 (class 2606 OID 16505)
-- Name: iap_transactions iap_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.iap_transactions
    ADD CONSTRAINT iap_transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4919 (class 2606 OID 16486)
-- Name: ranking_prize_state ranking_prize_state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ranking_prize_state
    ADD CONSTRAINT ranking_prize_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4904 (class 2606 OID 16404)
-- Name: users users_apple_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_apple_user_id_key UNIQUE (apple_user_id);


--
-- TOC entry 4906 (class 2606 OID 16402)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4925 (class 1259 OID 16541)
-- Name: idx_ad_reward_claims_user_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_reward_claims_user_date ON public.ad_reward_claims USING btree (user_id, claimed_at);


--
-- TOC entry 4916 (class 1259 OID 16452)
-- Name: idx_game_participants_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_game_participants_game_id ON public.game_participants USING btree (game_id);


--
-- TOC entry 4917 (class 1259 OID 16453)
-- Name: idx_game_participants_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_game_participants_user_id ON public.game_participants USING btree (user_id);


--
-- TOC entry 4909 (class 1259 OID 16424)
-- Name: idx_games_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_games_created_at ON public.games USING btree (created_at DESC);


--
-- TOC entry 4910 (class 1259 OID 16476)
-- Name: idx_games_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_games_finished_at ON public.games USING btree (finished_at) WHERE (finished_at IS NOT NULL);


--
-- TOC entry 4911 (class 1259 OID 16425)
-- Name: idx_games_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_games_status ON public.games USING btree (status);


--
-- TOC entry 4922 (class 1259 OID 16511)
-- Name: idx_iap_transactions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_iap_transactions_user_id ON public.iap_transactions USING btree (user_id);


--
-- TOC entry 4902 (class 1259 OID 16405)
-- Name: idx_users_apple_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_apple_user_id ON public.users USING btree (apple_user_id);


--
-- TOC entry 4929 (class 2606 OID 16536)
-- Name: ad_reward_claims ad_reward_claims_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_reward_claims
    ADD CONSTRAINT ad_reward_claims_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4926 (class 2606 OID 16442)
-- Name: game_participants game_participants_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_participants
    ADD CONSTRAINT game_participants_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id) ON DELETE CASCADE;


--
-- TOC entry 4927 (class 2606 OID 16447)
-- Name: game_participants game_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_participants
    ADD CONSTRAINT game_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4928 (class 2606 OID 16506)
-- Name: iap_transactions iap_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.iap_transactions
    ADD CONSTRAINT iap_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-02-12 22:17:02

--
-- PostgreSQL database dump complete
--

\unrestrict lWEA5C6z84kXhPStdDskLzPuQQK2xZ50Qv8kTAgPv1OhBHO10SWUHjLYDBWjvfK

