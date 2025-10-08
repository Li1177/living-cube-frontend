--
-- PostgreSQL database dump
--

\restrict hQlIU1cBJG3bMymDBVXfJMJmaldXcfMMGxU8lW0kW9LAFWfsrRgqLVULlreygSc

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: danmaku; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.danmaku (
    id integer NOT NULL,
    wallpaper_id integer,
    message character varying(255),
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.danmaku OWNER TO directus;

--
-- Name: danmaku_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.danmaku_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.danmaku_id_seq OWNER TO directus;

--
-- Name: danmaku_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.danmaku_id_seq OWNED BY public.danmaku.id;


--
-- Name: directus_access; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_access (
    id uuid NOT NULL,
    role uuid,
    "user" uuid,
    policy uuid NOT NULL,
    sort integer
);


ALTER TABLE public.directus_access OWNER TO directus;

--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent text,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    origin character varying(255)
);


ALTER TABLE public.directus_activity OWNER TO directus;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_activity_id_seq OWNER TO directus;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(64),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url character varying(255),
    versioning boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_collections OWNER TO directus;

--
-- Name: directus_comments; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_comments (
    id uuid NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_comments OWNER TO directus;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color character varying(255)
);


ALTER TABLE public.directus_dashboards OWNER TO directus;

--
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_extensions (
    enabled boolean DEFAULT true NOT NULL,
    id uuid NOT NULL,
    folder character varying(255) NOT NULL,
    source character varying(255) NOT NULL,
    bundle uuid
);


ALTER TABLE public.directus_extensions OWNER TO directus;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text
);


ALTER TABLE public.directus_fields OWNER TO directus;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_fields_id_seq OWNER TO directus;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    created_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json,
    focal_point_x integer,
    focal_point_y integer,
    tus_id character varying(64),
    tus_data json,
    uploaded_on timestamp with time zone
);


ALTER TABLE public.directus_files OWNER TO directus;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO directus;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO directus;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO directus;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO directus;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_notifications_id_seq OWNER TO directus;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO directus;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(64) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO directus;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text,
    policy uuid NOT NULL
);


ALTER TABLE public.directus_permissions OWNER TO directus;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_permissions_id_seq OWNER TO directus;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_policies; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_policies (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'badge'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_policies OWNER TO directus;

--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(64) DEFAULT 'bookmark'::character varying,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO directus;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_presets_id_seq OWNER TO directus;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO directus;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_relations_id_seq OWNER TO directus;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer,
    version uuid
);


ALTER TABLE public.directus_revisions OWNER TO directus;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_revisions_id_seq OWNER TO directus;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    parent uuid
);


ALTER TABLE public.directus_roles OWNER TO directus;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent text,
    share uuid,
    origin character varying(255),
    next_token character varying(64)
);


ALTER TABLE public.directus_sessions OWNER TO directus;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(255) DEFAULT '#6644FF'::character varying NOT NULL,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json,
    public_favicon uuid,
    default_appearance character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    default_theme_light character varying(255),
    theme_light_overrides json,
    default_theme_dark character varying(255),
    theme_dark_overrides json,
    report_error_url character varying(255),
    report_bug_url character varying(255),
    report_feature_url character varying(255),
    public_registration boolean DEFAULT false NOT NULL,
    public_registration_verify_email boolean DEFAULT true NOT NULL,
    public_registration_role uuid,
    public_registration_email_filter json,
    visual_editor_urls json,
    accepted_terms boolean DEFAULT false,
    project_id uuid,
    mcp_enabled boolean DEFAULT false NOT NULL,
    mcp_allow_deletes boolean DEFAULT false NOT NULL,
    mcp_prompts_collection character varying(255) DEFAULT NULL::character varying,
    mcp_system_prompt_enabled boolean DEFAULT true NOT NULL,
    mcp_system_prompt text
);


ALTER TABLE public.directus_settings OWNER TO directus;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_settings_id_seq OWNER TO directus;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO directus;

--
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_translations (
    id uuid NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.directus_translations OWNER TO directus;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true,
    appearance character varying(255),
    theme_dark character varying(255),
    theme_light character varying(255),
    theme_light_overrides json,
    theme_dark_overrides json,
    text_direction character varying(255) DEFAULT 'auto'::character varying NOT NULL
);


ALTER TABLE public.directus_users OWNER TO directus;

--
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_versions (
    id uuid NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    hash character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid,
    delta json
);


ALTER TABLE public.directus_versions OWNER TO directus;

--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_webhooks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    method character varying(10) DEFAULT 'POST'::character varying NOT NULL,
    url character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data boolean DEFAULT true NOT NULL,
    actions character varying(100) NOT NULL,
    collections character varying(255) NOT NULL,
    headers json,
    was_active_before_deprecation boolean DEFAULT false NOT NULL,
    migrated_flow uuid
);


ALTER TABLE public.directus_webhooks OWNER TO directus;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_webhooks_id_seq OWNER TO directus;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.purchases (
    id integer NOT NULL,
    wallpaper integer,
    status character varying(255),
    alipay_transaction_id character varying(255),
    price_at_purchase_cents integer
);


ALTER TABLE public.purchases OWNER TO directus;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.purchases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchases_id_seq OWNER TO directus;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.purchases_id_seq OWNED BY public.purchases.id;


--
-- Name: wallpapers; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.wallpapers (
    id integer NOT NULL,
    name character varying(255),
    description text,
    wallpaper_file uuid,
    tags json,
    price_cents integer
);


ALTER TABLE public.wallpapers OWNER TO directus;

--
-- Name: wallpapers_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.wallpapers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wallpapers_id_seq OWNER TO directus;

--
-- Name: wallpapers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.wallpapers_id_seq OWNED BY public.wallpapers.id;


--
-- Name: danmaku id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.danmaku ALTER COLUMN id SET DEFAULT nextval('public.danmaku_id_seq'::regclass);


--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Name: purchases id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.purchases ALTER COLUMN id SET DEFAULT nextval('public.purchases_id_seq'::regclass);


--
-- Name: wallpapers id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.wallpapers ALTER COLUMN id SET DEFAULT nextval('public.wallpapers_id_seq'::regclass);


--
-- Data for Name: danmaku; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.danmaku (id, wallpaper_id, message, "timestamp", user_id) FROM stdin;
21	2	哇!太好看了！！！	2025-10-03 13:59:47.669+00	\N
22	1	啊！我最喜欢的千束啊！	2025-10-03 14:00:11.627+00	\N
23	1	真棒！	2025-10-03 14:02:39.04+00	\N
26	2	测试弹幕10	2025-10-05 04:46:04.609+00	0
27	2	测试弹幕11	2025-10-05 04:47:53.534+00	0
28	1	千束弹幕测试1	2025-10-05 04:48:23.963+00	0
29	2	千反田测试弹幕11	2025-10-05 04:55:16.141+00	6
\.


--
-- Data for Name: directus_access; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_access (id, role, "user", policy, sort) FROM stdin;
6e16d75b-12e4-470a-96d4-689577a18199	5607caaf-0233-421d-801c-adbdac2970b5	\N	8fe5f381-f5ee-430d-91e8-df7674bb6836	\N
d9ef564b-c1a4-43a1-b0d3-a9873de039b2	5607caaf-0233-421d-801c-adbdac2970b5	\N	8b6e917f-61e1-4990-91f6-cc863a0b3831	1
6312458f-de49-4388-a69e-6e781ef39a59	\N	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	3d7a38d2-d536-4f24-afee-b8f2d7a644f6	1
d6215bc4-16ec-43af-856f-a1c7acbdc5d4	\N	\N	abf8a154-5b1c-4a46-ac9c-7300570f4f17	1
\.


--
-- Data for Name: directus_activity; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_activity (id, action, "user", "timestamp", ip, user_agent, collection, item, origin) FROM stdin;
1	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:15:43.586+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
2	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:17:35.879+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_settings	1	http://167.234.212.43:8055
3	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:18:41.573+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_settings	1	http://167.234.212.43:8055
4	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:22:03.79+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	1	http://167.234.212.43:8055
5	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:22:03.797+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	2	http://167.234.212.43:8055
6	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:22:03.802+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	3	http://167.234.212.43:8055
7	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:22:03.808+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	wallpaper	http://167.234.212.43:8055
8	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:27:37.536+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	wallpaper	http://167.234.212.43:8055
9	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:27:37.54+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	1	http://167.234.212.43:8055
10	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:27:37.542+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	2	http://167.234.212.43:8055
11	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:27:37.543+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	3	http://167.234.212.43:8055
12	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:39:37.208+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_settings	1	http://167.234.212.43:8055
13	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:44:22.083+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	4	http://167.234.212.43:8055
14	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:44:22.089+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	5	http://167.234.212.43:8055
15	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:44:22.096+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	6	http://167.234.212.43:8055
16	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:44:22.102+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	wallpapers	http://167.234.212.43:8055
17	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:46:55.743+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	7	http://167.234.212.43:8055
18	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:47:37.872+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	8	http://167.234.212.43:8055
19	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:50:38.342+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	7	http://167.234.212.43:8055
20	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:50:45.123+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	8	http://167.234.212.43:8055
21	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:52:51.843+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	9	http://167.234.212.43:8055
22	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:54:12.906+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	10	http://167.234.212.43:8055
23	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:55:08.184+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	11	http://167.234.212.43:8055
24	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 07:57:49.396+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	12	http://167.234.212.43:8055
25	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.494+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	wallpapers	http://167.234.212.43:8055
26	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.498+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	4	http://167.234.212.43:8055
27	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.499+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	5	http://167.234.212.43:8055
28	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.5+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	6	http://167.234.212.43:8055
29	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.501+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	9	http://167.234.212.43:8055
30	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.504+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	10	http://167.234.212.43:8055
31	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.506+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	11	http://167.234.212.43:8055
32	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:50:57.507+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	12	http://167.234.212.43:8055
33	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:51:44.142+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	13	http://167.234.212.43:8055
34	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:51:44.149+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	wallpapers	http://167.234.212.43:8055
35	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:53:41.011+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	14	http://167.234.212.43:8055
36	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:54:31.562+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	15	http://167.234.212.43:8055
37	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:55:18.663+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	16	http://167.234.212.43:8055
38	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:55:45.744+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	17	http://167.234.212.43:8055
39	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 15:56:27.39+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	18	http://167.234.212.43:8055
40	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:05:54.179+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	1	http://167.234.212.43:8055
41	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:05:54.184+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	2	http://167.234.212.43:8055
42	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:05:54.188+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://167.234.212.43:8055
43	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:05:54.199+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	http://167.234.212.43:8055
44	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:10:23.343+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	37040276-ade6-4563-966c-6bf375912210	http://167.234.212.43:8055
45	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:10:24.476+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	37040276-ade6-4563-966c-6bf375912210	http://167.234.212.43:8055
46	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:26:56.138+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	a5ba8e80-f556-431b-80bc-35a717762d9d	http://167.234.212.43:8055
47	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:26:57.751+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	a5ba8e80-f556-431b-80bc-35a717762d9d	http://167.234.212.43:8055
48	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:30:32.578+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	2c7f6647-58a5-4b33-97e7-223ce33e3260	http://167.234.212.43:8055
49	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:30:34.151+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	2c7f6647-58a5-4b33-97e7-223ce33e3260	http://167.234.212.43:8055
50	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:40:32.851+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	899c8da1-6b1d-4635-8a60-49e1458457de	http://167.234.212.43:8055
51	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:40:34.384+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	899c8da1-6b1d-4635-8a60-49e1458457de	http://167.234.212.43:8055
52	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:58:56.797+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	25333018-b758-4b46-b325-b0d19d3d0eda	http://167.234.212.43:8055
53	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 16:58:58.237+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	25333018-b758-4b46-b325-b0d19d3d0eda	http://167.234.212.43:8055
54	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 17:00:00.411+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	bb86cc42-bd33-444c-bee6-021031839a5a	http://167.234.212.43:8055
55	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 17:00:02.156+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	bb86cc42-bd33-444c-bee6-021031839a5a	http://167.234.212.43:8055
56	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 17:05:56.545+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	e112afd2-81fa-4b54-b750-6799c9e93958	http://167.234.212.43:8055
57	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 17:05:58.294+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	e112afd2-81fa-4b54-b750-6799c9e93958	http://167.234.212.43:8055
58	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:03:40.742+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0a5013b9-83fb-4e7f-9d63-c3c4ccb7f5e2	http://167.234.212.43:8055
59	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:03:42.162+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0a5013b9-83fb-4e7f-9d63-c3c4ccb7f5e2	http://167.234.212.43:8055
60	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:04:40.546+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	52b52dfc-e2bc-47a9-8a77-884fd1120ce2	http://167.234.212.43:8055
61	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:04:41.534+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	52b52dfc-e2bc-47a9-8a77-884fd1120ce2	http://167.234.212.43:8055
62	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:14:49.7+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	29facf54-28bf-4ae9-8d63-2e98a5cc26c4	http://167.234.212.43:8055
63	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:14:50.918+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	29facf54-28bf-4ae9-8d63-2e98a5cc26c4	http://167.234.212.43:8055
64	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:20:46.444+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
65	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:21:12.12+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	28747e9f-bd9c-4d63-8b4c-c0b6826ac052	http://167.234.212.43:8055
66	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:21:13.389+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	28747e9f-bd9c-4d63-8b4c-c0b6826ac052	http://167.234.212.43:8055
67	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:39:52.114+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
68	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.686+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	3	http://167.234.212.43:8055
69	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.694+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	4	http://167.234.212.43:8055
70	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.698+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	5	http://167.234.212.43:8055
71	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.703+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	6	http://167.234.212.43:8055
72	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.707+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	7	http://167.234.212.43:8055
73	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.712+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	aabb436c-1e32-4c09-b839-1c5b654b2023	http://167.234.212.43:8055
74	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.718+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	17d674ba-dae3-4f97-98fb-989af02896c1	http://167.234.212.43:8055
75	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:47:57.725+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_roles	5607caaf-0233-421d-801c-adbdac2970b5	http://167.234.212.43:8055
76	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:48:56.588+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	17d674ba-dae3-4f97-98fb-989af02896c1	http://167.234.212.43:8055
77	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:48:56.594+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_roles	5607caaf-0233-421d-801c-adbdac2970b5	http://167.234.212.43:8055
78	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.22+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	8	http://167.234.212.43:8055
79	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.226+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	9	http://167.234.212.43:8055
80	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.23+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	10	http://167.234.212.43:8055
81	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.234+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	11	http://167.234.212.43:8055
82	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.238+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	12	http://167.234.212.43:8055
83	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.244+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	13	http://167.234.212.43:8055
84	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.248+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	14	http://167.234.212.43:8055
85	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.252+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	15	http://167.234.212.43:8055
86	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.257+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	16	http://167.234.212.43:8055
87	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.261+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	17	http://167.234.212.43:8055
88	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.265+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	8b6e917f-61e1-4990-91f6-cc863a0b3831	http://167.234.212.43:8055
89	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.272+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	d9ef564b-c1a4-43a1-b0d3-a9873de039b2	http://167.234.212.43:8055
90	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:52:51.276+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_roles	5607caaf-0233-421d-801c-adbdac2970b5	http://167.234.212.43:8055
91	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:53:27.249+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	8eda300e-79b6-4c9b-970e-7d73d048dc7f	http://167.234.212.43:8055
92	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:53:28.904+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	8eda300e-79b6-4c9b-970e-7d73d048dc7f	http://167.234.212.43:8055
93	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:53:39.507+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	7b20da1c-b237-4ce7-a973-db7d5d4ce8f3	http://167.234.212.43:8055
94	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:53:40.841+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	7b20da1c-b237-4ce7-a973-db7d5d4ce8f3	http://167.234.212.43:8055
95	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:54:33.919+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
96	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:54:46.233+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	f135ade2-cff8-466d-b4ce-7a6144c2270d	http://167.234.212.43:8055
97	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:54:47.538+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	f135ade2-cff8-466d-b4ce-7a6144c2270d	http://167.234.212.43:8055
98	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:55:10.389+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0f53966c-6c49-487e-90ba-3fd1c58582ca	http://167.234.212.43:8055
99	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:55:11.799+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0f53966c-6c49-487e-90ba-3fd1c58582ca	http://167.234.212.43:8055
100	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:55:29.207+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	0a7c42bf-7fff-42fe-bd2d-08007b73a68e	http://167.234.212.43:8055
101	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:55:30.817+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	0a7c42bf-7fff-42fe-bd2d-08007b73a68e	http://167.234.212.43:8055
102	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:56:00.573+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	0210a5e2-90e6-40a3-953a-8b34b9aaeb09	http://167.234.212.43:8055
103	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 18:56:01.923+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	0210a5e2-90e6-40a3-953a-8b34b9aaeb09	http://167.234.212.43:8055
104	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 19:14:59.953+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	a2df032d-0cab-4f7a-a8fd-113d35d7ab2f	http://167.234.212.43:8055
105	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 19:15:01.42+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	a2df032d-0cab-4f7a-a8fd-113d35d7ab2f	http://167.234.212.43:8055
106	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 19:15:44.561+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	759fbe8c-b926-428e-bbbd-363e789d0617	http://167.234.212.43:8055
107	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 19:15:45.915+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	759fbe8c-b926-428e-bbbd-363e789d0617	http://167.234.212.43:8055
108	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 19:26:29.117+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0916311f-1035-40ec-b80e-602a10abca15	http://167.234.212.43:8055
109	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-29 19:26:29.899+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0916311f-1035-40ec-b80e-602a10abca15	http://167.234.212.43:8055
110	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 06:54:47.144+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	f46e0800-d3b4-46fd-ad80-ac72d9741148	http://167.234.212.43:8055
111	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 06:54:50.443+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	f46e0800-d3b4-46fd-ad80-ac72d9741148	http://167.234.212.43:8055
112	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 07:00:59.419+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
113	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 07:01:14.512+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	77bca324-bbdc-4b8f-8996-e2d7178cf4bc	http://167.234.212.43:8055
114	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 07:01:17.911+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	77bca324-bbdc-4b8f-8996-e2d7178cf4bc	http://167.234.212.43:8055
115	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 07:05:05.132+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
116	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 07:05:28.026+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	4750c2f8-c8b9-4a82-be4f-108499a505f6	http://167.234.212.43:8055
117	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 07:05:32.678+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	4750c2f8-c8b9-4a82-be4f-108499a505f6	http://167.234.212.43:8055
118	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:16:04.896+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	34b55851-9d57-4b36-867e-080eeb6c13e4	http://167.234.212.43:8055
119	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:16:08.596+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	34b55851-9d57-4b36-867e-080eeb6c13e4	http://167.234.212.43:8055
120	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:21:17.549+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
121	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:21:39.37+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	9143c466-13f5-4bc7-958c-aaefe73f71a5	http://167.234.212.43:8055
122	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:21:49.514+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	9143c466-13f5-4bc7-958c-aaefe73f71a5	http://167.234.212.43:8055
123	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:29:03.908+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	6b902b85-12aa-4845-81f1-c5d550e84b44	http://167.234.212.43:8055
124	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:29:15.318+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	6b902b85-12aa-4845-81f1-c5d550e84b44	http://167.234.212.43:8055
125	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:39:15.166+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	0480c034-1ca4-43fc-bae7-6c5e1689908d	http://167.234.212.43:8055
126	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:39:30.545+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	0480c034-1ca4-43fc-bae7-6c5e1689908d	http://167.234.212.43:8055
127	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:39:48.018+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	b6fdf846-c701-4825-ae49-2075077a43b9	http://167.234.212.43:8055
128	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 08:40:00.38+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	directus_files	b6fdf846-c701-4825-ae49-2075077a43b9	http://167.234.212.43:8055
129	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:33:38.008+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	acf08fe9-6c1c-4626-bbcc-6e3333baf311	http://167.234.212.43:8055
130	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:33:47.896+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	acf08fe9-6c1c-4626-bbcc-6e3333baf311	http://167.234.212.43:8055
131	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:36:37.144+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
132	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:36:51.964+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	ae30bef4-5d0d-48d6-aa32-adaea61dcbf5	http://167.234.212.43:8055
133	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:36:55.872+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	ae30bef4-5d0d-48d6-aa32-adaea61dcbf5	http://167.234.212.43:8055
134	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:39:55.973+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	2f4d9630-0e17-46d0-bac3-bf7a5b16e0b3	http://167.234.212.43:8055
135	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:40:47.575+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	2f4d9630-0e17-46d0-bac3-bf7a5b16e0b3	http://167.234.212.43:8055
136	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:46:25.765+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
137	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:46:38.304+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	f5623d60-2789-4165-8ba8-54307c850e21	http://167.234.212.43:8055
138	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:46:40.442+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	f5623d60-2789-4165-8ba8-54307c850e21	http://167.234.212.43:8055
139	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:50:02.169+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0b0939c7-c475-480e-bb99-c387457f5ccb	http://167.234.212.43:8055
140	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 12:50:32.217+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	0b0939c7-c475-480e-bb99-c387457f5ccb	http://167.234.212.43:8055
141	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:06:41.653+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	12e57289-87aa-4160-89ba-15f39ab3294e	http://167.234.212.43:8055
142	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:07:14.435+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	12e57289-87aa-4160-89ba-15f39ab3294e	http://167.234.212.43:8055
143	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:11:48.204+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	http://167.234.212.43:8055
144	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:12:03.22+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	5106e42f-3cc8-49d8-98f7-80fb174ef8c9	http://167.234.212.43:8055
145	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:12:23.874+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	5106e42f-3cc8-49d8-98f7-80fb174ef8c9	http://167.234.212.43:8055
146	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:13:51.376+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	21ca1935-c0e1-4c7e-b93b-dd4a62cf1048	http://167.234.212.43:8055
147	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:13:53.162+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	21ca1935-c0e1-4c7e-b93b-dd4a62cf1048	http://167.234.212.43:8055
148	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:24:29.735+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	eaa044e5-71ca-4af7-af98-9f7d74514339	http://167.234.212.43:8055
149	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:24:35.563+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	eaa044e5-71ca-4af7-af98-9f7d74514339	http://167.234.212.43:8055
150	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:26:08.077+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	9be8187f-d4a5-42c6-8868-d42860789973	http://167.234.212.43:8055
151	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:26:09.571+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	9be8187f-d4a5-42c6-8868-d42860789973	http://167.234.212.43:8055
152	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:38:54.706+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9	http://167.234.212.43:8055
153	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:42:56.781+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	wallpapers	1	http://167.234.212.43:8055
154	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 10:48:57.67+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_files	23def8da-3f5a-41ab-a3a9-7528f36e182b	http://167.234.212.43:8055
155	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 10:49:08.8+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	wallpapers	2	http://167.234.212.43:8055
156	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 11:03:19.477+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	19	http://167.234.212.43:8055
157	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 11:03:19.483+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	purchases	http://167.234.212.43:8055
158	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 11:08:40.26+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	20	http://167.234.212.43:8055
159	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 11:10:00.628+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	21	http://167.234.212.43:8055
160	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 11:10:32.671+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	22	http://167.234.212.43:8055
161	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 11:11:20.96+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	23	http://167.234.212.43:8055
162	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 12:11:56.021+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	18	http://167.234.212.43:8055
163	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 12:11:56.027+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://167.234.212.43:8055
164	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 12:11:56.035+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	http://167.234.212.43:8055
165	create	\N	2025-10-01 12:12:24.17+00	42.248.179.2	node	purchases	1	\N
166	create	\N	2025-10-01 12:14:12.181+00	42.248.179.2	node	purchases	2	\N
167	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 12:16:08.67+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	19	http://167.234.212.43:8055
168	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 12:16:08.675+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://167.234.212.43:8055
169	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 12:16:08.683+00	64.32.13.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	http://167.234.212.43:8055
170	create	\N	2025-10-01 12:16:37.642+00	42.248.179.2	node	purchases	3	\N
171	create	\N	2025-10-01 13:16:48.862+00	42.248.179.2	node	purchases	4	\N
172	create	\N	2025-10-01 13:30:34.168+00	42.248.179.2	node	purchases	5	\N
173	create	\N	2025-10-01 13:34:19.614+00	42.248.179.2	node	purchases	6	\N
174	create	\N	2025-10-01 13:38:08.695+00	42.248.179.2	node	purchases	7	\N
175	create	\N	2025-10-01 13:40:38.744+00	42.248.179.2	node	purchases	8	\N
176	create	\N	2025-10-01 13:44:04.259+00	42.248.179.2	node	purchases	9	\N
177	create	\N	2025-10-01 14:38:07.93+00	42.248.179.2	node	purchases	10	\N
178	create	\N	2025-10-01 14:40:08.745+00	42.248.179.2	node	purchases	11	\N
179	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.893+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	20	http://167.234.212.43:8055
180	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.898+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	21	http://167.234.212.43:8055
181	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.902+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	22	http://167.234.212.43:8055
182	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.906+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	23	http://167.234.212.43:8055
183	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.91+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	3d7a38d2-d536-4f24-afee-b8f2d7a644f6	http://167.234.212.43:8055
184	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.916+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	6312458f-de49-4388-a69e-6e781ef39a59	http://167.234.212.43:8055
185	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:52:46.921+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	http://167.234.212.43:8055
186	create	\N	2025-10-01 14:57:07.363+00	42.248.179.2	node	purchases	12	\N
187	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:57:36.161+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	24	http://167.234.212.43:8055
188	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:57:36.165+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	25	http://167.234.212.43:8055
189	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:57:36.171+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	22	http://167.234.212.43:8055
190	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:57:36.172+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	3d7a38d2-d536-4f24-afee-b8f2d7a644f6	http://167.234.212.43:8055
191	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:57:36.178+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	6312458f-de49-4388-a69e-6e781ef39a59	http://167.234.212.43:8055
192	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 14:57:36.184+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	http://167.234.212.43:8055
193	create	\N	2025-10-01 14:59:01.602+00	42.248.179.2	node	purchases	13	\N
194	create	\N	2025-10-01 15:12:50.003+00	42.248.179.2	node	purchases	14	\N
195	create	\N	2025-10-01 15:18:50.057+00	42.248.179.2	node	purchases	15	\N
196	create	\N	2025-10-01 15:23:12.713+00	42.248.179.2	node	purchases	16	\N
197	create	\N	2025-10-01 15:36:11.677+00	42.248.179.2	node	purchases	17	\N
198	create	\N	2025-10-01 15:39:32.177+00	42.248.179.2	node	purchases	18	\N
199	create	\N	2025-10-01 15:41:27.151+00	42.248.179.2	node	purchases	19	\N
200	create	\N	2025-10-01 15:45:25.716+00	42.248.179.2	node	purchases	20	\N
201	create	\N	2025-10-01 15:48:27.348+00	42.248.179.2	node	purchases	21	\N
202	create	\N	2025-10-01 15:51:06.212+00	42.248.179.2	node	purchases	22	\N
203	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 15:51:46.722+00	42.248.179.2	node	purchases	22	\N
204	create	\N	2025-10-01 15:54:07.903+00	42.248.179.2	node	purchases	23	\N
205	create	\N	2025-10-01 15:56:12.918+00	42.248.179.2	node	purchases	24	\N
206	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 15:56:49.606+00	42.248.179.2	node	purchases	24	\N
207	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 15:57:02.773+00	42.248.179.2	node	purchases	22	\N
208	create	\N	2025-10-01 15:58:41.276+00	42.248.179.2	node	purchases	25	\N
209	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 15:59:27.5+00	42.248.179.2	node	purchases	24	\N
210	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 15:59:29.456+00	42.248.179.2	node	purchases	25	\N
211	create	\N	2025-10-01 16:02:13.164+00	42.248.179.2	node	purchases	26	\N
212	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 16:02:58.211+00	42.248.179.2	node	purchases	26	\N
213	create	\N	2025-10-01 16:05:03.788+00	42.248.179.2	node	purchases	27	\N
214	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 16:05:35.736+00	42.248.179.2	node	purchases	27	\N
215	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 16:06:04.791+00	42.248.179.2	node	purchases	24	\N
216	create	\N	2025-10-01 16:07:50.696+00	42.248.179.2	node	purchases	28	\N
217	create	\N	2025-10-01 16:09:49.647+00	42.248.179.2	node	purchases	29	\N
218	create	\N	2025-10-01 16:12:59.414+00	42.248.179.2	node	purchases	30	\N
219	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 16:13:34.848+00	42.248.179.2	node	purchases	30	\N
220	create	\N	2025-10-01 16:14:49.293+00	42.248.179.2	node	purchases	31	\N
221	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 16:15:37.948+00	42.248.179.2	node	purchases	31	\N
222	create	\N	2025-10-01 17:05:26.315+00	42.248.179.2	node	purchases	32	\N
223	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 17:06:04.169+00	42.248.179.2	node	purchases	32	\N
224	create	\N	2025-10-01 17:36:20.928+00	42.248.179.2	node	purchases	33	\N
225	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-01 17:36:59.534+00	42.248.179.2	node	purchases	33	\N
226	create	\N	2025-10-02 00:49:12.879+00	42.248.179.125	node	purchases	34	\N
227	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 00:50:16.756+00	42.248.179.125	node	purchases	34	\N
228	create	\N	2025-10-02 00:58:59.368+00	42.248.179.125	node	purchases	35	\N
229	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 00:59:35.779+00	42.248.179.125	node	purchases	35	\N
230	create	\N	2025-10-02 01:10:40.651+00	42.248.179.125	node	purchases	36	\N
231	update	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 01:11:12.313+00	42.248.179.125	node	purchases	36	\N
232	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:22:29.316+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	24	http://167.234.212.43:8055
233	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:22:29.321+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	Bullet_comments_for_wallpapers	http://167.234.212.43:8055
234	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:24:37.317+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	Bullet_comments_for_wallpapers	http://167.234.212.43:8055
235	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:24:37.32+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	24	http://167.234.212.43:8055
236	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:25:05.231+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	25	http://167.234.212.43:8055
237	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:25:05.236+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_collections	danmaku	http://167.234.212.43:8055
238	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:47:23.601+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	26	http://167.234.212.43:8055
239	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:49:12.255+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	27	http://167.234.212.43:8055
240	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:52:07.469+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	28	http://167.234.212.43:8055
241	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:52:46.64+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	29	http://167.234.212.43:8055
242	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 06:58:57.446+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	29	http://167.234.212.43:8055
243	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 07:01:32.734+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_fields	28	http://167.234.212.43:8055
244	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 07:02:35.769+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	1	http://167.234.212.43:8055
245	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 07:35:43.357+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	26	http://167.234.212.43:8055
246	create	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 07:35:43.362+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_permissions	27	http://167.234.212.43:8055
247	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 07:35:43.365+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	http://167.234.212.43:8055
248	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 07:35:43.372+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	http://167.234.212.43:8055
249	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 10:50:58.52+00	42.248.179.125	node	danmaku	2	\N
250	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 13:35:29.495+00	42.248.179.125	node	danmaku	3	\N
251	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 13:38:00.99+00	42.248.179.125	node	danmaku	4	\N
252	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 13:41:17.116+00	42.248.179.125	node	danmaku	5	\N
253	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 14:00:43.501+00	42.248.179.125	node	danmaku	6	\N
254	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 14:26:57.825+00	42.248.179.125	node	danmaku	7	\N
255	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:07:11.177+00	42.248.179.125	node	danmaku	8	\N
256	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:29:00.679+00	42.248.179.125	node	danmaku	9	\N
257	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.621+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	9	http://167.234.212.43:8055
258	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.623+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	8	http://167.234.212.43:8055
259	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.624+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	7	http://167.234.212.43:8055
260	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.625+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	6	http://167.234.212.43:8055
261	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.626+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	5	http://167.234.212.43:8055
262	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.627+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	4	http://167.234.212.43:8055
263	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.628+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	3	http://167.234.212.43:8055
264	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.629+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	2	http://167.234.212.43:8055
265	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:34:09.63+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	1	http://167.234.212.43:8055
266	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:34:43.774+00	42.248.179.125	node	danmaku	10	\N
267	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:35:09.269+00	42.248.179.125	node	danmaku	11	\N
268	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:55:37.57+00	42.248.179.125	node	danmaku	12	\N
269	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:57:02.004+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	12	http://167.234.212.43:8055
270	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:57:02.005+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	11	http://167.234.212.43:8055
271	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 15:57:02.006+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	10	http://167.234.212.43:8055
272	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:57:34.778+00	42.248.179.125	node	danmaku	13	\N
273	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 15:57:46.641+00	42.248.179.125	node	danmaku	14	\N
274	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 16:16:23.101+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	13	http://167.234.212.43:8055
275	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-02 16:16:23.103+00	198.2.210.237	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	14	http://167.234.212.43:8055
276	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-02 16:16:40.071+00	42.248.179.125	node	danmaku	15	\N
277	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 00:59:39.256+00	42.248.177.116	node	danmaku	16	\N
278	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 01:07:27.815+00	42.248.177.116	node	danmaku	17	\N
279	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 01:10:51.042+00	42.248.177.116	node	danmaku	18	\N
280	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 13:57:36.339+00	42.248.177.116	node	danmaku	19	\N
281	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 13:58:20.014+00	42.248.177.116	node	danmaku	20	\N
282	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-03 13:59:20.293+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	15	http://167.234.212.43:8055
283	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-03 13:59:20.295+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	16	http://167.234.212.43:8055
284	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-03 13:59:20.297+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	18	http://167.234.212.43:8055
285	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-03 13:59:20.297+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	17	http://167.234.212.43:8055
286	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-03 13:59:20.298+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	19	http://167.234.212.43:8055
287	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-03 13:59:20.3+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	20	http://167.234.212.43:8055
288	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 13:59:47.671+00	42.248.177.116	node	danmaku	21	\N
289	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 14:00:11.628+00	42.248.177.116	node	danmaku	22	\N
290	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 14:02:39.042+00	42.248.177.116	node	danmaku	23	\N
291	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-03 14:03:04.028+00	42.248.177.116	node	danmaku	24	\N
292	login	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-04 07:01:22.092+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	https://api.run-gen.com
293	create	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	2025-10-05 04:43:37.892+00	167.234.212.43	curl/7.81.0	danmaku	25	\N
294	create	\N	2025-10-05 04:46:04.61+00	167.234.212.43	node	danmaku	26	\N
295	create	\N	2025-10-05 04:47:53.536+00	167.234.212.43	node	danmaku	27	\N
296	create	\N	2025-10-05 04:48:23.965+00	167.234.212.43	node	danmaku	28	\N
297	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-05 04:50:21.819+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	24	https://api.run-gen.com
298	delete	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-05 04:50:21.821+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	danmaku	25	https://api.run-gen.com
299	create	\N	2025-10-05 04:55:16.142+00	167.234.212.43	node	danmaku	29	\N
300	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-05 06:48:29.399+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	https://api.run-gen.com
301	update	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-05 07:12:40.933+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	https://api.run-gen.com
\.


--
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning) FROM stdin;
wallpapers	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
purchases	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
danmaku	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
\.


--
-- Data for Name: directus_comments; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_comments (id, collection, item, comment, date_created, date_updated, user_created, user_updated) FROM stdin;
\.


--
-- Data for Name: directus_dashboards; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_dashboards (id, name, icon, note, date_created, user_created, color) FROM stdin;
\.


--
-- Data for Name: directus_extensions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_extensions (enabled, id, folder, source, bundle) FROM stdin;
\.


--
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_fields (id, collection, field, special, interface, options, display, display_options, readonly, hidden, sort, width, translations, note, conditions, required, "group", validation, validation_message) FROM stdin;
13	wallpapers	id	\N	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
14	wallpapers	name	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
15	wallpapers	description	\N	input-multiline	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
16	wallpapers	wallpaper_file	file	file	\N	\N	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
17	wallpapers	tags	cast-json	tags	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
18	wallpapers	price_cents	\N	input	\N	\N	\N	f	f	6	full	\N	\N	\N	t	\N	\N	\N
19	purchases	id	\N	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
20	purchases	wallpaper	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
21	purchases	status	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
22	purchases	alipay_transaction_id	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
23	purchases	price_at_purchase_cents	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
25	danmaku	id	\N	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
26	danmaku	wallpaper_id	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
27	danmaku	message	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
29	danmaku	user_id	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
28	danmaku	timestamp	date-created	\N	{"format":"short"}	\N	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
\.


--
-- Data for Name: directus_files; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_files (id, storage, filename_disk, filename_download, title, type, folder, uploaded_by, created_on, modified_by, modified_on, charset, filesize, width, height, duration, embed, description, location, tags, metadata, focal_point_x, focal_point_y, tus_id, tus_data, uploaded_on) FROM stdin;
6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9	oci	6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9.png	ComfyUI_00003_ (3).png	Comfy UI 00003  (3)	image/png	\N	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-09-30 13:38:54.701+00	\N	2025-09-30 13:39:28.616+00	\N	2447284	1080	1920	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-09-30 13:39:28.61+00
23def8da-3f5a-41ab-a3a9-7528f36e182b	oci	23def8da-3f5a-41ab-a3a9-7528f36e182b.png	ComfyUI_00036_ (4).png	Comfy UI 00036  (4)	image/png	\N	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-01 10:48:57.667+00	\N	2025-10-01 10:48:59.171+00	\N	2686925	1080	1920	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2025-10-01 10:48:59.168+00
\.


--
-- Data for Name: directus_flows; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_flows (id, name, icon, color, description, status, trigger, accountability, options, operation, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_folders; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_folders (id, name, parent) FROM stdin;
\.


--
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_migrations (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2025-09-29 07:14:52.785884+00
20201029A	Remove System Relations	2025-09-29 07:14:52.794406+00
20201029B	Remove System Collections	2025-09-29 07:14:52.801122+00
20201029C	Remove System Fields	2025-09-29 07:14:52.813855+00
20201105A	Add Cascade System Relations	2025-09-29 07:14:52.884631+00
20201105B	Change Webhook URL Type	2025-09-29 07:14:52.896302+00
20210225A	Add Relations Sort Field	2025-09-29 07:14:52.905487+00
20210304A	Remove Locked Fields	2025-09-29 07:14:52.910296+00
20210312A	Webhooks Collections Text	2025-09-29 07:14:52.918864+00
20210331A	Add Refresh Interval	2025-09-29 07:14:52.922691+00
20210415A	Make Filesize Nullable	2025-09-29 07:14:52.932649+00
20210416A	Add Collections Accountability	2025-09-29 07:14:52.939886+00
20210422A	Remove Files Interface	2025-09-29 07:14:52.943457+00
20210506A	Rename Interfaces	2025-09-29 07:14:52.971022+00
20210510A	Restructure Relations	2025-09-29 07:14:52.990734+00
20210518A	Add Foreign Key Constraints	2025-09-29 07:14:53.000611+00
20210519A	Add System Fk Triggers	2025-09-29 07:14:53.042926+00
20210521A	Add Collections Icon Color	2025-09-29 07:14:53.046884+00
20210525A	Add Insights	2025-09-29 07:14:53.074685+00
20210608A	Add Deep Clone Config	2025-09-29 07:14:53.078802+00
20210626A	Change Filesize Bigint	2025-09-29 07:14:53.097658+00
20210716A	Add Conditions to Fields	2025-09-29 07:14:53.101845+00
20210721A	Add Default Folder	2025-09-29 07:14:53.110261+00
20210802A	Replace Groups	2025-09-29 07:14:53.116324+00
20210803A	Add Required to Fields	2025-09-29 07:14:53.120189+00
20210805A	Update Groups	2025-09-29 07:14:53.125007+00
20210805B	Change Image Metadata Structure	2025-09-29 07:14:53.130492+00
20210811A	Add Geometry Config	2025-09-29 07:14:53.134276+00
20210831A	Remove Limit Column	2025-09-29 07:14:53.137766+00
20210903A	Add Auth Provider	2025-09-29 07:14:53.160864+00
20210907A	Webhooks Collections Not Null	2025-09-29 07:14:53.169712+00
20210910A	Move Module Setup	2025-09-29 07:14:53.174864+00
20210920A	Webhooks URL Not Null	2025-09-29 07:14:53.183667+00
20210924A	Add Collection Organization	2025-09-29 07:14:53.19192+00
20210927A	Replace Fields Group	2025-09-29 07:14:53.202869+00
20210927B	Replace M2M Interface	2025-09-29 07:14:53.205615+00
20210929A	Rename Login Action	2025-09-29 07:14:53.208371+00
20211007A	Update Presets	2025-09-29 07:14:53.215919+00
20211009A	Add Auth Data	2025-09-29 07:14:53.219299+00
20211016A	Add Webhook Headers	2025-09-29 07:14:53.222649+00
20211103A	Set Unique to User Token	2025-09-29 07:14:53.228346+00
20211103B	Update Special Geometry	2025-09-29 07:14:53.231332+00
20211104A	Remove Collections Listing	2025-09-29 07:14:53.234676+00
20211118A	Add Notifications	2025-09-29 07:14:53.2561+00
20211211A	Add Shares	2025-09-29 07:14:53.282127+00
20211230A	Add Project Descriptor	2025-09-29 07:14:53.285922+00
20220303A	Remove Default Project Color	2025-09-29 07:14:53.29534+00
20220308A	Add Bookmark Icon and Color	2025-09-29 07:14:53.30001+00
20220314A	Add Translation Strings	2025-09-29 07:14:53.303332+00
20220322A	Rename Field Typecast Flags	2025-09-29 07:14:53.308545+00
20220323A	Add Field Validation	2025-09-29 07:14:53.311902+00
20220325A	Fix Typecast Flags	2025-09-29 07:14:53.316864+00
20220325B	Add Default Language	2025-09-29 07:14:53.328745+00
20220402A	Remove Default Value Panel Icon	2025-09-29 07:14:53.337864+00
20220429A	Add Flows	2025-09-29 07:14:53.38254+00
20220429B	Add Color to Insights Icon	2025-09-29 07:14:53.386811+00
20220429C	Drop Non Null From IP of Activity	2025-09-29 07:14:53.390554+00
20220429D	Drop Non Null From Sender of Notifications	2025-09-29 07:14:53.394311+00
20220614A	Rename Hook Trigger to Event	2025-09-29 07:14:53.397439+00
20220801A	Update Notifications Timestamp Column	2025-09-29 07:14:53.407253+00
20220802A	Add Custom Aspect Ratios	2025-09-29 07:14:53.410986+00
20220826A	Add Origin to Accountability	2025-09-29 07:14:53.415908+00
20230401A	Update Material Icons	2025-09-29 07:14:53.425939+00
20230525A	Add Preview Settings	2025-09-29 07:14:53.429491+00
20230526A	Migrate Translation Strings	2025-09-29 07:14:53.443385+00
20230721A	Require Shares Fields	2025-09-29 07:14:53.450555+00
20230823A	Add Content Versioning	2025-09-29 07:14:53.477688+00
20230927A	Themes	2025-09-29 07:14:53.499482+00
20231009A	Update CSV Fields to Text	2025-09-29 07:14:53.504885+00
20231009B	Update Panel Options	2025-09-29 07:14:53.507948+00
20231010A	Add Extensions	2025-09-29 07:14:53.514317+00
20231215A	Add Focalpoints	2025-09-29 07:14:53.517854+00
20240122A	Add Report URL Fields	2025-09-29 07:14:53.521698+00
20240204A	Marketplace	2025-09-29 07:14:53.552907+00
20240305A	Change Useragent Type	2025-09-29 07:14:53.565632+00
20240311A	Deprecate Webhooks	2025-09-29 07:14:53.576723+00
20240422A	Public Registration	2025-09-29 07:14:53.584259+00
20240515A	Add Session Window	2025-09-29 07:14:53.587531+00
20240701A	Add Tus Data	2025-09-29 07:14:53.591182+00
20240716A	Update Files Date Fields	2025-09-29 07:14:53.599587+00
20240806A	Permissions Policies	2025-09-29 07:14:53.654108+00
20240817A	Update Icon Fields Length	2025-09-29 07:14:53.688219+00
20240909A	Separate Comments	2025-09-29 07:14:53.705643+00
20240909B	Consolidate Content Versioning	2025-09-29 07:14:53.709278+00
20240924A	Migrate Legacy Comments	2025-09-29 07:14:53.716225+00
20240924B	Populate Versioning Deltas	2025-09-29 07:14:53.721732+00
20250224A	Visual Editor	2025-09-29 07:14:53.726302+00
20250609A	License Banner	2025-09-29 07:14:53.732661+00
20250613A	Add Project ID	2025-09-29 07:14:53.748167+00
20250718A	Add Direction	2025-09-29 07:14:53.752472+00
20250813A	Add MCP	2025-09-29 07:14:53.75819+00
\.


--
-- Data for Name: directus_notifications; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_notifications (id, "timestamp", status, recipient, sender, subject, message, collection, item) FROM stdin;
\.


--
-- Data for Name: directus_operations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_operations (id, name, key, type, position_x, position_y, options, resolve, reject, flow, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_panels; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_panels (id, dashboard, name, icon, color, show_header, note, type, position_x, position_y, width, height, options, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_permissions (id, collection, action, permissions, validation, presets, fields, policy) FROM stdin;
1	wallpapers	read	\N	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
2	directus_files	read	\N	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
3	directus_files	create	\N	\N	\N	*	aabb436c-1e32-4c09-b839-1c5b654b2023
4	directus_files	read	\N	\N	\N	*	aabb436c-1e32-4c09-b839-1c5b654b2023
5	directus_files	update	\N	\N	\N	*	aabb436c-1e32-4c09-b839-1c5b654b2023
6	directus_files	delete	\N	\N	\N	*	aabb436c-1e32-4c09-b839-1c5b654b2023
7	directus_files	share	\N	\N	\N	*	aabb436c-1e32-4c09-b839-1c5b654b2023
8	directus_files	create	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
9	directus_files	read	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
10	directus_files	update	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
11	directus_files	delete	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
12	directus_files	share	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
13	wallpapers	create	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
14	wallpapers	read	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
15	wallpapers	update	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
16	wallpapers	delete	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
17	wallpapers	share	\N	\N	\N	*	8b6e917f-61e1-4990-91f6-cc863a0b3831
18	purchases	create	\N	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
19	purchases	read	\N	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
20	purchases	create	\N	\N	\N	*	3d7a38d2-d536-4f24-afee-b8f2d7a644f6
21	purchases	read	\N	\N	\N	*	3d7a38d2-d536-4f24-afee-b8f2d7a644f6
23	wallpapers	read	\N	\N	\N	*	3d7a38d2-d536-4f24-afee-b8f2d7a644f6
24	directus_files	read	\N	\N	\N	*	3d7a38d2-d536-4f24-afee-b8f2d7a644f6
25	purchases	update	\N	\N	\N	*	3d7a38d2-d536-4f24-afee-b8f2d7a644f6
26	danmaku	create	\N	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
27	danmaku	read	\N	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
\.


--
-- Data for Name: directus_policies; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_policies (id, name, icon, description, ip_access, enforce_tfa, admin_access, app_access) FROM stdin;
8fe5f381-f5ee-430d-91e8-df7674bb6836	Administrator	verified	$t:admin_description	\N	f	t	t
abf8a154-5b1c-4a46-ac9c-7300570f4f17	$t:public_label	public	$t:public_description	\N	f	f	t
aabb436c-1e32-4c09-b839-1c5b654b2023	directus_files	badge	\N	\N	f	f	f
8b6e917f-61e1-4990-91f6-cc863a0b3831	file	badge	\N	\N	f	f	f
3d7a38d2-d536-4f24-afee-b8f2d7a644f6	API User	badge	\N	\N	f	f	f
\.


--
-- Data for Name: directus_presets; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_presets (id, bookmark, "user", role, collection, search, layout, layout_query, layout_options, refresh_interval, filter, icon, color) FROM stdin;
3	\N	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	\N	wallpapers		tabular	{"tabular":{"fields":["description","name","tags","wallpaper_file","id"],"page":1},"map":{"limit":1000},"cards":{"sort":["-id"],"page":1}}	{"tabular":{"widths":{"description":160,"name":160,"tags":160,"wallpaper_file":297.77777099609375}},"cards":{"size":2}}	\N	\N	bookmark	\N
4	\N	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	\N	danmaku	\N	\N	{"tabular":{"fields":["message","timestamp","user_id","wallpaper_id"]}}	{"tabular":{"widths":{"message":160,"timestamp":619,"user_id":231,"wallpaper_id":160}}}	\N	\N	bookmark	\N
2	\N	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	\N	directus_users	\N	cards	{"cards":{"sort":["email"],"page":1}}	{"cards":{"icon":"account_circle","title":"{{ first_name }} {{ last_name }}","subtitle":"{{ email }}","size":4}}	\N	\N	bookmark	\N
1	\N	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	\N	directus_files	\N	cards	{"cards":{"sort":["-uploaded_on"],"page":1}}	{"cards":{"icon":"insert_drive_file","title":"{{ title }}","subtitle":"{{ type }} • {{ filesize }}","size":4,"imageFit":"crop"}}	\N	\N	bookmark	\N
\.


--
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_relations (id, many_collection, many_field, one_collection, one_field, one_collection_field, one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
1	wallpapers	wallpaper_file	directus_files	\N	\N	\N	\N	\N	nullify
2	purchases	wallpaper	wallpapers	\N	\N	\N	\N	\N	nullify
\.


--
-- Data for Name: directus_revisions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_revisions (id, activity, collection, item, data, delta, parent, version) FROM stdin;
1	2	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_role":null,"public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01999453-08b1-74af-875f-0a721eb73b38","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null}	{"accepted_terms":true}	\N	\N
2	3	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"zh-CN","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_role":null,"public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01999453-08b1-74af-875f-0a721eb73b38","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null}	{"default_language":"zh-CN"}	\N	\N
3	4	directus_fields	1	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"wallpaper"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"wallpaper"}	\N	\N
4	5	directus_fields	2	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"wallpaper"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"wallpaper"}	\N	\N
5	6	directus_fields	3	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"wallpaper"}	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"wallpaper"}	\N	\N
6	7	directus_collections	wallpaper	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"wallpaper"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"wallpaper"}	\N	\N
7	12	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_role":null,"public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"01999453-08b1-74af-875f-0a721eb73b38","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null}	{"default_language":"en-US"}	\N	\N
8	13	directus_fields	4	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"wallpapers"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"wallpapers"}	\N	\N
28	43	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	{"id":"d6215bc4-16ec-43af-856f-a1c7acbdc5d4","role":null,"user":null,"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","sort":1}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
27	42	directus_policies	abf8a154-5b1c-4a46-ac9c-7300570f4f17	{"id":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","name":"$t:public_label","icon":"public","description":"$t:public_description","ip_access":null,"enforce_tfa":false,"admin_access":false,"app_access":true,"permissions":[1,2],"users":["d6215bc4-16ec-43af-856f-a1c7acbdc5d4"],"roles":["d6215bc4-16ec-43af-856f-a1c7acbdc5d4"]}	{"app_access":true}	28	\N
33	52	directus_files	25333018-b758-4b46-b325-b0d19d3d0eda	{"title":"4kfacefix 00025  (大)","filename_download":"4kfacefix_00025_ (大).png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00025  (大)","filename_download":"4kfacefix_00025_ (大).png","type":"image/png","storage":"oci"}	\N	\N
34	54	directus_files	bb86cc42-bd33-444c-bee6-021031839a5a	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	\N	\N
9	14	directus_fields	5	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"wallpapers"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status","collection":"wallpapers"}	\N	\N
10	15	directus_fields	6	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"wallpapers"}	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"wallpapers"}	\N	\N
11	16	directus_collections	wallpapers	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"wallpapers"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"wallpapers"}	\N	\N
12	17	directus_fields	7	{"sort":4,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"title"}	{"sort":4,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"title"}	\N	\N
13	18	directus_fields	8	{"sort":5,"interface":"input-multiline","special":null,"collection":"wallpapers","field":"description"}	{"sort":5,"interface":"input-multiline","special":null,"collection":"wallpapers","field":"description"}	\N	\N
14	21	directus_fields	9	{"sort":4,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"title"}	{"sort":4,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"title"}	\N	\N
15	22	directus_fields	10	{"sort":5,"interface":"input-multiline","special":null,"collection":"wallpapers","field":"description"}	{"sort":5,"interface":"input-multiline","special":null,"collection":"wallpapers","field":"description"}	\N	\N
16	23	directus_fields	11	{"sort":6,"interface":"tags","special":["cast-json"],"collection":"wallpapers","field":"tags"}	{"sort":6,"interface":"tags","special":["cast-json"],"collection":"wallpapers","field":"tags"}	\N	\N
17	24	directus_fields	12	{"sort":7,"interface":"input","special":null,"collection":"wallpapers","field":"price"}	{"sort":7,"interface":"input","special":null,"collection":"wallpapers","field":"price"}	\N	\N
18	33	directus_fields	13	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"wallpapers"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"wallpapers"}	\N	\N
19	34	directus_collections	wallpapers	{"singleton":false,"collection":"wallpapers"}	{"singleton":false,"collection":"wallpapers"}	\N	\N
20	35	directus_fields	14	{"sort":2,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"name"}	{"sort":2,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"name"}	\N	\N
21	36	directus_fields	15	{"sort":3,"interface":"input-multiline","special":null,"collection":"wallpapers","field":"description"}	{"sort":3,"interface":"input-multiline","special":null,"collection":"wallpapers","field":"description"}	\N	\N
22	37	directus_fields	16	{"sort":4,"interface":"file","special":["file"],"required":true,"collection":"wallpapers","field":"wallpaper_file"}	{"sort":4,"interface":"file","special":["file"],"required":true,"collection":"wallpapers","field":"wallpaper_file"}	\N	\N
23	38	directus_fields	17	{"sort":5,"interface":"tags","special":["cast-json"],"collection":"wallpapers","field":"tags"}	{"sort":5,"interface":"tags","special":["cast-json"],"collection":"wallpapers","field":"tags"}	\N	\N
24	39	directus_fields	18	{"sort":6,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"price_cents"}	{"sort":6,"interface":"input","special":null,"required":true,"collection":"wallpapers","field":"price_cents"}	\N	\N
25	40	directus_permissions	1	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}	27	\N
26	41	directus_permissions	2	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	27	\N
29	44	directus_files	37040276-ade6-4563-966c-6bf375912210	{"title":"1080 00030 ","filename_download":"1080_00030_.png","type":"image/png","storage":"oci"}	{"title":"1080 00030 ","filename_download":"1080_00030_.png","type":"image/png","storage":"oci"}	\N	\N
30	46	directus_files	a5ba8e80-f556-431b-80bc-35a717762d9d	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	\N	\N
31	48	directus_files	2c7f6647-58a5-4b33-97e7-223ce33e3260	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	\N	\N
32	50	directus_files	899c8da1-6b1d-4635-8a60-49e1458457de	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026  Clean","filename_download":"4kfacefix_00026__clean.png","type":"image/png","storage":"oci"}	\N	\N
35	56	directus_files	e112afd2-81fa-4b54-b750-6799c9e93958	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	\N	\N
36	58	directus_files	0a5013b9-83fb-4e7f-9d63-c3c4ccb7f5e2	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	\N	\N
37	60	directus_files	52b52dfc-e2bc-47a9-8a77-884fd1120ce2	{"title":"4kfacefix 00026  (小) Clean","filename_download":"4kfacefix_00026_ (小)_clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026  (小) Clean","filename_download":"4kfacefix_00026_ (小)_clean.png","type":"image/png","storage":"oci"}	\N	\N
38	62	directus_files	29facf54-28bf-4ae9-8d63-2e98a5cc26c4	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	\N	\N
39	65	directus_files	28747e9f-bd9c-4d63-8b4c-c0b6826ac052	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
40	68	directus_permissions	3	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"}	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"}	45	\N
41	69	directus_permissions	4	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	45	\N
42	70	directus_permissions	5	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"}	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"}	45	\N
43	71	directus_permissions	6	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"}	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"}	45	\N
44	72	directus_permissions	7	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}	{"policy":"aabb436c-1e32-4c09-b839-1c5b654b2023","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}	45	\N
80	139	directus_files	0b0939c7-c475-480e-bb99-c387457f5ccb	{"title":"Comfy UI 00052  (1)","filename_download":"ComfyUI_00052_ (1).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00052  (1)","filename_download":"ComfyUI_00052_ (1).png","type":"image/png","storage":"oci"}	\N	\N
82	144	directus_files	5106e42f-3cc8-49d8-98f7-80fb174ef8c9	{"title":"Comfy UI 00014  (6)","filename_download":"ComfyUI_00014_ (6).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00014  (6)","filename_download":"ComfyUI_00014_ (6).png","type":"image/png","storage":"oci"}	\N	\N
83	146	directus_files	21ca1935-c0e1-4c7e-b93b-dd4a62cf1048	{"title":"Comfy UI Temp Lfnac 00002 ","filename_download":"ComfyUI_temp_lfnac_00002_.png","type":"image/png","storage":"oci"}	{"title":"Comfy UI Temp Lfnac 00002 ","filename_download":"ComfyUI_temp_lfnac_00002_.png","type":"image/png","storage":"oci"}	\N	\N
84	148	directus_files	eaa044e5-71ca-4af7-af98-9f7d74514339	{"title":"Comfy UI 00008  (7)","filename_download":"ComfyUI_00008_ (7).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00008  (7)","filename_download":"ComfyUI_00008_ (7).png","type":"image/png","storage":"oci"}	\N	\N
85	150	directus_files	9be8187f-d4a5-42c6-8868-d42860789973	{"title":"Comfy UI 00003  (3)","filename_download":"ComfyUI_00003_ (3).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00003  (3)","filename_download":"ComfyUI_00003_ (3).png","type":"image/png","storage":"oci"}	\N	\N
86	152	directus_files	6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9	{"title":"Comfy UI 00003  (3)","filename_download":"ComfyUI_00003_ (3).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00003  (3)","filename_download":"ComfyUI_00003_ (3).png","type":"image/png","storage":"oci"}	\N	\N
87	153	wallpapers	1	{"name":"11","wallpaper_file":"6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9","price_cents":10}	{"name":"11","wallpaper_file":"6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9","price_cents":10}	\N	\N
92	158	directus_fields	20	{"sort":2,"interface":"select-dropdown-m2o","special":["m2o"],"collection":"purchases","field":"wallpaper"}	{"sort":2,"interface":"select-dropdown-m2o","special":["m2o"],"collection":"purchases","field":"wallpaper"}	\N	\N
93	159	directus_fields	21	{"sort":3,"interface":"input","special":null,"collection":"purchases","field":"status"}	{"sort":3,"interface":"input","special":null,"collection":"purchases","field":"status"}	\N	\N
94	160	directus_fields	22	{"sort":4,"interface":"input","special":null,"collection":"purchases","field":"alipay_transaction_id"}	{"sort":4,"interface":"input","special":null,"collection":"purchases","field":"alipay_transaction_id"}	\N	\N
95	161	directus_fields	23	{"sort":5,"interface":"input","special":null,"collection":"purchases","field":"price_at_purchase_cents"}	{"sort":5,"interface":"input","special":null,"collection":"purchases","field":"price_at_purchase_cents"}	\N	\N
98	165	purchases	1	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
99	166	purchases	2	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
102	170	purchases	3	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
103	171	purchases	4	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
104	172	purchases	5	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
105	173	purchases	6	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
106	174	purchases	7	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
46	74	directus_access	17d674ba-dae3-4f97-98fb-989af02896c1	{"policy":{"permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}],"update":[],"delete":[]},"name":"directus_files"},"sort":1,"role":"5607caaf-0233-421d-801c-adbdac2970b5"}	{"policy":{"permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}],"update":[],"delete":[]},"name":"directus_files"},"sort":1,"role":"5607caaf-0233-421d-801c-adbdac2970b5"}	\N	\N
45	73	directus_policies	aabb436c-1e32-4c09-b839-1c5b654b2023	{"permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}],"update":[],"delete":[]},"name":"directus_files"}	{"permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}],"update":[],"delete":[]},"name":"directus_files"}	46	\N
47	78	directus_permissions	8	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"}	57	\N
48	79	directus_permissions	9	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	57	\N
107	175	purchases	8	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
108	176	purchases	9	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
109	177	purchases	10	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
110	178	purchases	11	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
111	179	directus_permissions	20	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"}	115	\N
49	80	directus_permissions	10	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"}	57	\N
50	81	directus_permissions	11	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"}	57	\N
51	82	directus_permissions	12	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"}	57	\N
52	83	directus_permissions	13	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"}	57	\N
53	84	directus_permissions	14	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}	57	\N
54	85	directus_permissions	15	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"update"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"update"}	57	\N
55	86	directus_permissions	16	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"delete"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"delete"}	57	\N
56	87	directus_permissions	17	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"share"}	{"policy":"8b6e917f-61e1-4990-91f6-cc863a0b3831","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"share"}	57	\N
58	89	directus_access	d9ef564b-c1a4-43a1-b0d3-a9873de039b2	{"policy":{"name":"file","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"share"}],"update":[],"delete":[]}},"sort":1,"role":"5607caaf-0233-421d-801c-adbdac2970b5"}	{"policy":{"name":"file","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"share"}],"update":[],"delete":[]}},"sort":1,"role":"5607caaf-0233-421d-801c-adbdac2970b5"}	\N	\N
81	141	directus_files	12e57289-87aa-4160-89ba-15f39ab3294e	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
88	154	directus_files	23def8da-3f5a-41ab-a3a9-7528f36e182b	{"title":"Comfy UI 00036  (4)","filename_download":"ComfyUI_00036_ (4).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00036  (4)","filename_download":"ComfyUI_00036_ (4).png","type":"image/png","storage":"oci"}	\N	\N
89	155	wallpapers	2	{"name":"11","wallpaper_file":"23def8da-3f5a-41ab-a3a9-7528f36e182b","price_cents":10}	{"name":"11","wallpaper_file":"23def8da-3f5a-41ab-a3a9-7528f36e182b","price_cents":10}	\N	\N
90	156	directus_fields	19	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"purchases"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"purchases"}	\N	\N
91	157	directus_collections	purchases	{"singleton":false,"collection":"purchases"}	{"singleton":false,"collection":"purchases"}	\N	\N
96	162	directus_permissions	18	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"}	\N	\N
97	164	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	{"id":"d6215bc4-16ec-43af-856f-a1c7acbdc5d4","role":null,"user":null,"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","sort":1}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
100	167	directus_permissions	19	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"}	\N	\N
101	169	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	{"id":"d6215bc4-16ec-43af-856f-a1c7acbdc5d4","role":null,"user":null,"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","sort":1}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
112	180	directus_permissions	21	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"}	115	\N
57	88	directus_policies	8b6e917f-61e1-4990-91f6-cc863a0b3831	{"name":"file","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"share"}],"update":[],"delete":[]}}	{"name":"file","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"share"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"update"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"delete"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"share"}],"update":[],"delete":[]}}	58	\N
59	91	directus_files	8eda300e-79b6-4c9b-970e-7d73d048dc7f	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026 ","filename_download":"4kfacefix_00026_.png","type":"image/png","storage":"oci"}	\N	\N
60	93	directus_files	7b20da1c-b237-4ce7-a973-db7d5d4ce8f3	{"title":"4kfacefix 00025  (大)","filename_download":"4kfacefix_00025_ (大).png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00025  (大)","filename_download":"4kfacefix_00025_ (大).png","type":"image/png","storage":"oci"}	\N	\N
61	96	directus_files	f135ade2-cff8-466d-b4ce-7a6144c2270d	{"title":"4kfacefix 00025  (大) Clean","filename_download":"4kfacefix_00025_ (大)_clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00025  (大) Clean","filename_download":"4kfacefix_00025_ (大)_clean.png","type":"image/png","storage":"oci"}	\N	\N
62	98	directus_files	0f53966c-6c49-487e-90ba-3fd1c58582ca	{"title":"4kfacefix 00025  (大) Clean","filename_download":"4kfacefix_00025_ (大)_clean.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00025  (大) Clean","filename_download":"4kfacefix_00025_ (大)_clean.png","type":"image/png","storage":"oci"}	\N	\N
63	100	directus_files	0a7c42bf-7fff-42fe-bd2d-08007b73a68e	{"title":"4kfacefix 00013 ","filename_download":"4kfacefix_00013_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00013 ","filename_download":"4kfacefix_00013_.png","type":"image/png","storage":"oci"}	\N	\N
64	102	directus_files	0210a5e2-90e6-40a3-953a-8b34b9aaeb09	{"title":"Comfy UI 00003  (3)","filename_download":"ComfyUI_00003_ (3).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00003  (3)","filename_download":"ComfyUI_00003_ (3).png","type":"image/png","storage":"oci"}	\N	\N
65	104	directus_files	a2df032d-0cab-4f7a-a8fd-113d35d7ab2f	{"title":"4kfacefix 00017 ","filename_download":"4kfacefix_00017_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00017 ","filename_download":"4kfacefix_00017_.png","type":"image/png","storage":"oci"}	\N	\N
66	106	directus_files	759fbe8c-b926-428e-bbbd-363e789d0617	{"title":"4kfacefix 00025  (大)","filename_download":"4kfacefix_00025_ (大).png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00025  (大)","filename_download":"4kfacefix_00025_ (大).png","type":"image/png","storage":"oci"}	\N	\N
67	108	directus_files	0916311f-1035-40ec-b80e-602a10abca15	{"title":"4kfacefix 00026  (小)","filename_download":"4kfacefix_00026_ (小).png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00026  (小)","filename_download":"4kfacefix_00026_ (小).png","type":"image/png","storage":"oci"}	\N	\N
68	110	directus_files	f46e0800-d3b4-46fd-ad80-ac72d9741148	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
69	113	directus_files	77bca324-bbdc-4b8f-8996-e2d7178cf4bc	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
70	116	directus_files	4750c2f8-c8b9-4a82-be4f-108499a505f6	{"title":"4kfacefix 00017 ","filename_download":"4kfacefix_00017_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00017 ","filename_download":"4kfacefix_00017_.png","type":"image/png","storage":"oci"}	\N	\N
71	118	directus_files	34b55851-9d57-4b36-867e-080eeb6c13e4	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
72	121	directus_files	9143c466-13f5-4bc7-958c-aaefe73f71a5	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
73	123	directus_files	6b902b85-12aa-4845-81f1-c5d550e84b44	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
74	125	directus_files	0480c034-1ca4-43fc-bae7-6c5e1689908d	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
75	127	directus_files	b6fdf846-c701-4825-ae49-2075077a43b9	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
76	129	directus_files	acf08fe9-6c1c-4626-bbcc-6e3333baf311	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	{"title":"4K 00020 ","filename_download":"4k_00020_.png","type":"image/png","storage":"oci"}	\N	\N
77	132	directus_files	ae30bef4-5d0d-48d6-aa32-adaea61dcbf5	{"title":"Comfy UI 00024  (5)","filename_download":"ComfyUI_00024_ (5).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00024  (5)","filename_download":"ComfyUI_00024_ (5).png","type":"image/png","storage":"oci"}	\N	\N
78	134	directus_files	2f4d9630-0e17-46d0-bac3-bf7a5b16e0b3	{"title":"4kfacefix 00013 ","filename_download":"4kfacefix_00013_.png","type":"image/png","storage":"oci"}	{"title":"4kfacefix 00013 ","filename_download":"4kfacefix_00013_.png","type":"image/png","storage":"oci"}	\N	\N
79	137	directus_files	f5623d60-2789-4165-8ba8-54307c850e21	{"title":"Comfy UI 00024  (5)","filename_download":"ComfyUI_00024_ (5).png","type":"image/png","storage":"oci"}	{"title":"Comfy UI 00024  (5)","filename_download":"ComfyUI_00024_ (5).png","type":"image/png","storage":"oci"}	\N	\N
113	181	directus_permissions	22	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"}	115	\N
114	182	directus_permissions	23	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}	115	\N
115	183	directus_policies	3d7a38d2-d536-4f24-afee-b8f2d7a644f6	{"name":"API User","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}],"update":[],"delete":[]}}	{"name":"API User","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}],"update":[],"delete":[]}}	116	\N
117	185	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	{"first_name":"API","last_name":"User","email":"api@yourproject.com","policies":{"create":[{"policy":{"name":"API User","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}],"update":[],"delete":[]}}}],"update":[],"delete":[]}}	{"first_name":"API","last_name":"User","email":"api@yourproject.com","policies":{"create":[{"policy":{"name":"API User","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}],"update":[],"delete":[]}}}],"update":[],"delete":[]}}	\N	\N
116	184	directus_access	6312458f-de49-4388-a69e-6e781ef39a59	{"policy":{"name":"API User","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}],"update":[],"delete":[]}},"sort":1,"user":"cadeba3f-391c-4e57-9fe2-3ec3d4aa2430"}	{"policy":{"name":"API User","permissions":{"create":[{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"read"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"create"},{"policy":"+","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"wallpapers","action":"read"}],"update":[],"delete":[]}},"sort":1,"user":"cadeba3f-391c-4e57-9fe2-3ec3d4aa2430"}	117	\N
118	186	purchases	12	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
119	187	directus_permissions	24	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"directus_files","action":"read"}	\N	\N
120	188	directus_permissions	25	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"update"}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"purchases","action":"update"}	\N	\N
121	191	directus_access	6312458f-de49-4388-a69e-6e781ef39a59	{"id":"6312458f-de49-4388-a69e-6e781ef39a59","role":null,"user":"cadeba3f-391c-4e57-9fe2-3ec3d4aa2430","policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6","sort":1}	{"policy":"3d7a38d2-d536-4f24-afee-b8f2d7a644f6"}	122	\N
164	236	directus_fields	25	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"danmaku"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"danmaku"}	\N	\N
165	237	directus_collections	danmaku	{"singleton":false,"collection":"danmaku"}	{"singleton":false,"collection":"danmaku"}	\N	\N
166	238	directus_fields	26	{"sort":2,"interface":"input","special":null,"required":true,"collection":"danmaku","field":"wallpaper_id"}	{"sort":2,"interface":"input","special":null,"required":true,"collection":"danmaku","field":"wallpaper_id"}	\N	\N
167	239	directus_fields	27	{"sort":3,"interface":"input","special":null,"required":true,"collection":"danmaku","field":"message"}	{"sort":3,"interface":"input","special":null,"required":true,"collection":"danmaku","field":"message"}	\N	\N
168	240	directus_fields	28	{"sort":4,"interface":"datetime","special":["date-created"],"required":true,"options":{"format":"short"},"collection":"danmaku","field":"timestamp"}	{"sort":4,"interface":"datetime","special":["date-created"],"required":true,"options":{"format":"short"},"collection":"danmaku","field":"timestamp"}	\N	\N
169	241	directus_fields	29	{"sort":5,"interface":"input","special":null,"required":true,"collection":"danmaku","field":"user_id"}	{"sort":5,"interface":"input","special":null,"required":true,"collection":"danmaku","field":"user_id"}	\N	\N
122	192	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	{"id":"cadeba3f-391c-4e57-9fe2-3ec3d4aa2430","first_name":"API","last_name":"User","email":"api@yourproject.com","password":null,"location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":null,"token":"**********","last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","policies":["6312458f-de49-4388-a69e-6e781ef39a59"]}	{"token":"**********"}	\N	\N
123	193	purchases	13	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
124	194	purchases	14	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
125	195	purchases	15	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
126	196	purchases	16	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
127	197	purchases	17	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
128	198	purchases	18	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
129	199	purchases	19	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
130	200	purchases	20	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
131	201	purchases	21	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
132	202	purchases	22	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
133	203	purchases	22	{"id":22,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
134	204	purchases	23	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
135	205	purchases	24	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
136	206	purchases	24	{"id":24,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
137	207	purchases	22	{"id":22,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
138	208	purchases	25	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
139	209	purchases	24	{"id":24,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
140	210	purchases	25	{"id":25,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
141	211	purchases	26	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
142	212	purchases	26	{"id":26,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
143	213	purchases	27	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
144	214	purchases	27	{"id":27,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
145	215	purchases	24	{"id":24,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
146	216	purchases	28	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
147	217	purchases	29	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
148	218	purchases	30	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
149	219	purchases	30	{"id":30,"wallpaper":1,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
150	220	purchases	31	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
151	221	purchases	31	{"id":31,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
152	222	purchases	32	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
153	223	purchases	32	{"id":32,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
154	224	purchases	33	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
155	225	purchases	33	{"id":33,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
156	226	purchases	34	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
157	227	purchases	34	{"id":34,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
158	228	purchases	35	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":1,"status":"pending","price_at_purchase_cents":10}	\N	\N
159	229	purchases	35	{"id":35,"wallpaper":1,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
160	230	purchases	36	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	{"wallpaper":2,"status":"pending","price_at_purchase_cents":10}	\N	\N
161	231	purchases	36	{"id":36,"wallpaper":2,"status":"paid","alipay_transaction_id":null,"price_at_purchase_cents":10}	{"status":"paid"}	\N	\N
162	232	directus_fields	24	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"Bullet_comments_for_wallpapers"}	{"sort":1,"hidden":true,"interface":"input","readonly":true,"field":"id","collection":"Bullet_comments_for_wallpapers"}	\N	\N
163	233	directus_collections	Bullet_comments_for_wallpapers	{"singleton":false,"collection":"Bullet_comments_for_wallpapers"}	{"singleton":false,"collection":"Bullet_comments_for_wallpapers"}	\N	\N
170	242	directus_fields	29	{"id":29,"collection":"danmaku","field":"user_id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"danmaku","field":"user_id","required":false}	\N	\N
171	243	directus_fields	28	{"id":28,"collection":"danmaku","field":"timestamp","special":["date-created"],"interface":null,"options":{"format":"short"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"danmaku","field":"timestamp","interface":null}	\N	\N
172	244	danmaku	1	{"wallpaper_id":1,"message":"测试弹幕！","timestamp":"2025-10-01T04:00:00.000Z"}	{"wallpaper_id":1,"message":"测试弹幕！","timestamp":"2025-10-01T04:00:00.000Z"}	\N	\N
173	245	directus_permissions	26	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"danmaku","action":"create"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"danmaku","action":"create"}	\N	\N
174	246	directus_permissions	27	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"danmaku","action":"read"}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","permissions":null,"validation":null,"fields":["*"],"presets":null,"collection":"danmaku","action":"read"}	\N	\N
175	248	directus_access	d6215bc4-16ec-43af-856f-a1c7acbdc5d4	{"id":"d6215bc4-16ec-43af-856f-a1c7acbdc5d4","role":null,"user":null,"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17","sort":1}	{"policy":"abf8a154-5b1c-4a46-ac9c-7300570f4f17"}	\N	\N
176	249	danmaku	2	{"wallpaper_id":1,"message":"测试弹幕！","user_id":null}	{"wallpaper_id":1,"message":"测试弹幕！","user_id":null}	\N	\N
177	250	danmaku	3	{"wallpaper_id":1,"message":"so cute","user_id":null}	{"wallpaper_id":1,"message":"so cute","user_id":null}	\N	\N
178	251	danmaku	4	{"wallpaper_id":2,"message":"love","user_id":null}	{"wallpaper_id":2,"message":"love","user_id":null}	\N	\N
179	252	danmaku	5	{"wallpaper_id":1,"message":"taibangle ","user_id":null}	{"wallpaper_id":1,"message":"taibangle ","user_id":null}	\N	\N
180	253	danmaku	6	{"wallpaper_id":2,"message":"你好","user_id":null}	{"wallpaper_id":2,"message":"你好","user_id":null}	\N	\N
181	254	danmaku	7	{"wallpaper_id":2,"message":"你好","user_id":null}	{"wallpaper_id":2,"message":"你好","user_id":null}	\N	\N
182	255	danmaku	8	{"wallpaper_id":2,"message":"最喜欢千反田","user_id":null}	{"wallpaper_id":2,"message":"最喜欢千反田","user_id":null}	\N	\N
183	256	danmaku	9	{"wallpaper_id":2,"message":"千反田弹幕测试","user_id":null}	{"wallpaper_id":2,"message":"千反田弹幕测试","user_id":null}	\N	\N
184	266	danmaku	10	{"wallpaper_id":2,"message":"可爱的千反田！","user_id":null}	{"wallpaper_id":2,"message":"可爱的千反田！","user_id":null}	\N	\N
185	267	danmaku	11	{"wallpaper_id":2,"message":"你好！","user_id":null}	{"wallpaper_id":2,"message":"你好！","user_id":null}	\N	\N
186	268	danmaku	12	{"wallpaper_id":2,"message":"千反田测试，第二次","user_id":null}	{"wallpaper_id":2,"message":"千反田测试，第二次","user_id":null}	\N	\N
187	272	danmaku	13	{"wallpaper_id":2,"message":"千反田测试1","user_id":null}	{"wallpaper_id":2,"message":"千反田测试1","user_id":null}	\N	\N
188	273	danmaku	14	{"wallpaper_id":2,"message":"千反田测试2","user_id":null}	{"wallpaper_id":2,"message":"千反田测试2","user_id":null}	\N	\N
189	276	danmaku	15	{"wallpaper_id":2,"message":"千反田测试1","user_id":null}	{"wallpaper_id":2,"message":"千反田测试1","user_id":null}	\N	\N
190	277	danmaku	16	{"wallpaper_id":2,"message":"你好","user_id":null}	{"wallpaper_id":2,"message":"你好","user_id":null}	\N	\N
191	278	danmaku	17	{"wallpaper_id":2,"message":"你好","user_id":null}	{"wallpaper_id":2,"message":"你好","user_id":null}	\N	\N
192	279	danmaku	18	{"wallpaper_id":2,"message":"你好","user_id":null}	{"wallpaper_id":2,"message":"你好","user_id":null}	\N	\N
193	280	danmaku	19	{"message":"锦木千束测试1","wallpaper_id":1}	{"message":"锦木千束测试1","wallpaper_id":1}	\N	\N
194	281	danmaku	20	{"message":"锦木千束测试2","wallpaper_id":1}	{"message":"锦木千束测试2","wallpaper_id":1}	\N	\N
195	288	danmaku	21	{"message":"哇!太好看了！！！","wallpaper_id":2}	{"message":"哇!太好看了！！！","wallpaper_id":2}	\N	\N
196	289	danmaku	22	{"message":"啊！我最喜欢的千束啊！","wallpaper_id":1}	{"message":"啊！我最喜欢的千束啊！","wallpaper_id":1}	\N	\N
197	290	danmaku	23	{"message":"真棒！","wallpaper_id":1}	{"message":"真棒！","wallpaper_id":1}	\N	\N
198	291	danmaku	24	{"message":"唉，又是AI","wallpaper_id":2}	{"message":"唉，又是AI","wallpaper_id":2}	\N	\N
199	293	danmaku	25	{"video_id":"2","content":"curl test","user_id":1,"timestamp":"1970-01-01T00:00:00.010Z"}	{"video_id":"2","content":"curl test","user_id":1,"timestamp":"1970-01-01T00:00:00.010Z"}	\N	\N
200	294	danmaku	26	{"wallpaper_id":2,"message":"测试弹幕10","user_id":0,"timestamp":"1970-01-01T00:00:00.084Z"}	{"wallpaper_id":2,"message":"测试弹幕10","user_id":0,"timestamp":"1970-01-01T00:00:00.084Z"}	\N	\N
201	295	danmaku	27	{"wallpaper_id":2,"message":"测试弹幕11","user_id":0,"timestamp":"1970-01-01T00:00:00.051Z"}	{"wallpaper_id":2,"message":"测试弹幕11","user_id":0,"timestamp":"1970-01-01T00:00:00.051Z"}	\N	\N
202	296	danmaku	28	{"wallpaper_id":1,"message":"千束弹幕测试1","user_id":0,"timestamp":"1970-01-01T00:00:00.115Z"}	{"wallpaper_id":1,"message":"千束弹幕测试1","user_id":0,"timestamp":"1970-01-01T00:00:00.115Z"}	\N	\N
203	299	danmaku	29	{"wallpaper_id":2,"message":"千反田测试弹幕11","user_id":6,"timestamp":"1970-01-01T00:00:00.298Z"}	{"wallpaper_id":2,"message":"千反田测试弹幕11","user_id":6,"timestamp":"1970-01-01T00:00:00.298Z"}	\N	\N
204	300	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	{"id":"cadeba3f-391c-4e57-9fe2-3ec3d4aa2430","first_name":"API","last_name":"User","email":"api@yourproject.com","password":null,"location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"5607caaf-0233-421d-801c-adbdac2970b5","token":"**********","last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","policies":["6312458f-de49-4388-a69e-6e781ef39a59"]}	{"role":"5607caaf-0233-421d-801c-adbdac2970b5"}	\N	\N
205	301	directus_users	cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	{"id":"cadeba3f-391c-4e57-9fe2-3ec3d4aa2430","first_name":"API","last_name":"User","email":"api@yourproject.com","password":null,"location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"5607caaf-0233-421d-801c-adbdac2970b5","token":"**********","last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","policies":["6312458f-de49-4388-a69e-6e781ef39a59"]}	{"token":"**********"}	\N	\N
\.


--
-- Data for Name: directus_roles; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_roles (id, name, icon, description, parent) FROM stdin;
5607caaf-0233-421d-801c-adbdac2970b5	Administrator	verified	$t:admin_description	\N
\.


--
-- Data for Name: directus_sessions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_sessions (token, "user", expires, ip, user_agent, share, origin, next_token) FROM stdin;
xhl9v5UlKiSRDW5xrlZACa0tpVGNvNLrge2-8VQ5jJZLY4pDG7hMvbZd24_txlHU	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-05 14:45:06.178+00	104.194.206.238	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://167.234.212.43:8055	\N
F23JsG3aOHK1Itm-fwlpNdBOzsZH_HQpMDuyRhp3iJJjFndjbw4CHtVFyh8q2IJh	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-06 18:39:52.105+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://167.234.212.43:8055	\N
YI0XZGBwI89CNwpeXAdMIjMgq6Z6ax6vSY3j1B5lBpDuKbGH0C27kQLDo9B4-zJm	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-07 07:00:59.405+00	66.11.117.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://167.234.212.43:8055	\N
jyrVAfwEETfNUyzjWqm7ZciJp2n6Tt6rj02v6WePCG1oCaJkukko94gEaaOBHVYW	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-05 06:19:23.07+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	https://api.run-gen.com	asDWmu4uVSPq1vHk5K3FTtVJpsH070vdBqJqH5S94V-YdV6yIwT2YrglFKAgvxdB
asDWmu4uVSPq1vHk5K3FTtVJpsH070vdBqJqH5S94V-YdV6yIwT2YrglFKAgvxdB	fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	2025-10-06 06:19:13.07+00	2604:9cc0:14:3551:bff3:1cd0:7a1b:259	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	https://api.run-gen.com	\N
\.


--
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_settings (id, project_name, project_url, project_color, project_logo, public_foreground, public_background, public_note, auth_login_attempts, auth_password_policy, storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder, basemaps, mapbox_key, module_bar, project_descriptor, default_language, custom_aspect_ratios, public_favicon, default_appearance, default_theme_light, theme_light_overrides, default_theme_dark, theme_dark_overrides, report_error_url, report_bug_url, report_feature_url, public_registration, public_registration_verify_email, public_registration_role, public_registration_email_filter, visual_editor_urls, accepted_terms, project_id, mcp_enabled, mcp_allow_deletes, mcp_prompts_collection, mcp_system_prompt_enabled, mcp_system_prompt) FROM stdin;
1	Directus	\N	#6644FF	\N	\N	\N	\N	25	\N	all	\N	\N	\N	\N	\N	\N	\N	en-US	\N	\N	auto	\N	\N	\N	\N	\N	\N	\N	f	t	\N	\N	\N	t	01999453-08b1-74af-875f-0a721eb73b38	f	f	\N	t	\N
\.


--
-- Data for Name: directus_shares; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_shares (id, name, collection, item, role, password, user_created, date_created, date_start, date_end, times_used, max_uses) FROM stdin;
\.


--
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_translations (id, language, key, value) FROM stdin;
\.


--
-- Data for Name: directus_users; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_users (id, first_name, last_name, email, password, location, title, description, tags, avatar, language, tfa_secret, status, role, token, last_access, last_page, provider, external_identifier, auth_data, email_notifications, appearance, theme_dark, theme_light, theme_light_overrides, theme_dark_overrides, text_direction) FROM stdin;
fff9d5bd-3fb5-4877-8d9b-d219eb14dea5	Admin	User	citywalker1127@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$pifDJ0X7k0SZYVAZvU+QTA$qDpKoiwVdgqXkMkxVoglt1LHV8cAMzQ4Ar+IUKjtXDA	\N	\N	\N	\N	\N	\N	\N	active	5607caaf-0233-421d-801c-adbdac2970b5	\N	2025-10-05 06:19:13.075+00	/settings/data-model/wallpapers	default	\N	\N	t	\N	\N	\N	\N	\N	auto
cadeba3f-391c-4e57-9fe2-3ec3d4aa2430	API	User	api@yourproject.com	\N	\N	\N	\N	\N	\N	\N	\N	active	5607caaf-0233-421d-801c-adbdac2970b5	GMqR8Hb_zkd43NN9lHE30jj3R96RoV1y	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto
\.


--
-- Data for Name: directus_versions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_versions (id, key, name, collection, item, hash, date_created, date_updated, user_created, user_updated, delta) FROM stdin;
\.


--
-- Data for Name: directus_webhooks; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_webhooks (id, name, method, url, status, data, actions, collections, headers, was_active_before_deprecation, migrated_flow) FROM stdin;
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.purchases (id, wallpaper, status, alipay_transaction_id, price_at_purchase_cents) FROM stdin;
1	1	pending	\N	10
2	1	pending	\N	10
3	2	pending	\N	10
4	2	pending	\N	10
5	1	pending	\N	10
6	2	pending	\N	10
7	2	pending	\N	10
8	1	pending	\N	10
9	2	pending	\N	10
10	2	pending	\N	10
11	1	pending	\N	10
12	1	pending	\N	10
13	2	pending	\N	10
14	2	pending	\N	10
15	1	pending	\N	10
16	2	pending	\N	10
17	2	pending	\N	10
18	2	pending	\N	10
19	2	pending	\N	10
20	1	pending	\N	10
21	1	pending	\N	10
23	2	pending	\N	10
22	2	paid	\N	10
25	2	paid	\N	10
26	2	paid	\N	10
27	2	paid	\N	10
24	2	paid	\N	10
28	2	pending	\N	10
29	1	pending	\N	10
30	1	paid	\N	10
31	2	paid	\N	10
32	2	paid	\N	10
33	2	paid	\N	10
34	2	paid	\N	10
35	1	paid	\N	10
36	2	paid	\N	10
\.


--
-- Data for Name: wallpapers; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.wallpapers (id, name, description, wallpaper_file, tags, price_cents) FROM stdin;
1	11	\N	6bdf54b8-7b13-41f0-98c6-176ed2e4f1f9	\N	10
2	11	\N	23def8da-3f5a-41ab-a3a9-7528f36e182b	\N	10
\.


--
-- Name: danmaku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.danmaku_id_seq', 29, true);


--
-- Name: directus_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_activity_id_seq', 301, true);


--
-- Name: directus_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_fields_id_seq', 29, true);


--
-- Name: directus_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_notifications_id_seq', 1, false);


--
-- Name: directus_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_permissions_id_seq', 27, true);


--
-- Name: directus_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_presets_id_seq', 4, true);


--
-- Name: directus_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_relations_id_seq', 2, true);


--
-- Name: directus_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_revisions_id_seq', 205, true);


--
-- Name: directus_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, true);


--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_webhooks_id_seq', 1, false);


--
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.purchases_id_seq', 36, true);


--
-- Name: wallpapers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.wallpapers_id_seq', 2, true);


--
-- Name: danmaku danmaku_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.danmaku
    ADD CONSTRAINT danmaku_pkey PRIMARY KEY (id);


--
-- Name: directus_access directus_access_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_comments directus_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_pkey PRIMARY KEY (id);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_extensions directus_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_extensions
    ADD CONSTRAINT directus_extensions_pkey PRIMARY KEY (id);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_policies directus_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_policies
    ADD CONSTRAINT directus_policies_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_translations directus_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_translations
    ADD CONSTRAINT directus_translations_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_versions directus_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_pkey PRIMARY KEY (id);


--
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: wallpapers wallpapers_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.wallpapers
    ADD CONSTRAINT wallpapers_pkey PRIMARY KEY (id);


--
-- Name: directus_access directus_access_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_comments directus_comments_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_comments directus_comments_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_revisions directus_revisions_version_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_version_foreign FOREIGN KEY (version) REFERENCES public.directus_versions(id) ON DELETE CASCADE;


--
-- Name: directus_roles directus_roles_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_roles(id);


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_favicon_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_favicon_foreign FOREIGN KEY (public_favicon) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_registration_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_registration_role_foreign FOREIGN KEY (public_registration_role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_versions directus_versions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_webhooks directus_webhooks_migrated_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_migrated_flow_foreign FOREIGN KEY (migrated_flow) REFERENCES public.directus_flows(id) ON DELETE SET NULL;


--
-- Name: purchases purchases_wallpaper_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_wallpaper_foreign FOREIGN KEY (wallpaper) REFERENCES public.wallpapers(id) ON DELETE SET NULL;


--
-- Name: wallpapers wallpapers_wallpaper_file_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.wallpapers
    ADD CONSTRAINT wallpapers_wallpaper_file_foreign FOREIGN KEY (wallpaper_file) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict hQlIU1cBJG3bMymDBVXfJMJmaldXcfMMGxU8lW0kW9LAFWfsrRgqLVULlreygSc

