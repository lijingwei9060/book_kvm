
CREATE TABLE public.access (
    access_id integer NOT NULL,
    access_code character(1),
    comment character varying(30)
);

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);

CREATE TABLE public.artifact (
    id integer NOT NULL,
    project_id integer NOT NULL,
    repository_name character varying(255) NOT NULL,
    digest character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    pull_time timestamp without time zone,
    push_time timestamp without time zone,
    repository_id integer NOT NULL,
    media_type character varying(255) NOT NULL,
    manifest_media_type character varying(255) NOT NULL,
    size bigint,
    extra_attrs text,
    annotations jsonb,
    icon character varying(255),
    artifact_type character varying(255) NOT NULL
);

CREATE TABLE public.artifact_accessory (
    id integer NOT NULL,
    artifact_id bigint,
    subject_artifact_id bigint,
    type character varying(256),
    size bigint,
    digest character varying(1024),
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    subject_artifact_digest character varying(1024),
    subject_artifact_repo character varying(1024)
);

CREATE TABLE public.artifact_blob (
    id integer NOT NULL,
    digest_af character varying(255) NOT NULL,
    digest_blob character varying(255) NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.artifact_reference (
    id integer NOT NULL,
    parent_id integer NOT NULL,
    child_id integer NOT NULL,
    child_digest character varying(255) NOT NULL,
    platform character varying(255),
    urls character varying(1024),
    annotations jsonb
);

CREATE TABLE public.artifact_trash (
    id integer NOT NULL,
    media_type character varying(255) NOT NULL,
    manifest_media_type character varying(255) NOT NULL,
    repository_name character varying(255) NOT NULL,
    digest character varying(255) NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.audit_log (
    id integer NOT NULL,
    project_id integer NOT NULL,
    operation character varying(20) NOT NULL,
    resource_type character varying(255) NOT NULL,
    resource character varying(1024) NOT NULL,
    username character varying(255) NOT NULL,
    op_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.audit_log_ext (
    id bigint NOT NULL,
    project_id bigint,
    operation character varying(50),
    resource_type character varying(255),
    resource character varying(1024),
    username character varying(255),
    op_desc character varying(1024),
    op_result boolean DEFAULT true,
    payload text,
    source_ip character varying(50),
    op_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.blob (
    id integer NOT NULL,
    digest character varying(255) NOT NULL,
    content_type character varying(1024) NOT NULL,
    size bigint NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'none'::character varying,
    version bigint DEFAULT 0
);

CREATE TABLE public.cve_allowlist (
    id integer NOT NULL,
    project_id integer,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at bigint,
    items text NOT NULL
);

CREATE TABLE public.data_migrations (
    id integer NOT NULL,
    version integer,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.execution (
    id integer NOT NULL,
    vendor_type character varying(64) NOT NULL,
    vendor_id integer,
    status character varying(16),
    status_message text,
    trigger character varying(16) NOT NULL,
    extra_attrs json,
    start_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    end_time timestamp without time zone,
    revision integer,
    update_time timestamp without time zone
);

CREATE TABLE public.harbor_label (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    description text,
    color character varying(16),
    level character(1) NOT NULL,
    scope character(1) NOT NULL,
    project_id integer,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted boolean DEFAULT false NOT NULL
);

CREATE TABLE public.harbor_user (
    user_id integer NOT NULL,
    username character varying(255),
    email character varying(255),
    password character varying(40) NOT NULL,
    realname character varying(255) NOT NULL,
    comment character varying(30),
    deleted boolean DEFAULT false NOT NULL,
    reset_uuid character varying(40) DEFAULT NULL::character varying,
    salt character varying(40) DEFAULT NULL::character varying,
    sysadmin_flag boolean DEFAULT false NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password_version character varying(16) DEFAULT 'sha256'::character varying
);

CREATE TABLE public.immutable_tag_rule (
    id integer NOT NULL,
    project_id integer NOT NULL,
    tag_filter text,
    disabled boolean DEFAULT false NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.job_log (
    log_id integer NOT NULL,
    job_uuid character varying(64) NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    content text
);

CREATE TABLE public.job_queue_status (
    id integer NOT NULL,
    job_type character varying(256) NOT NULL,
    paused boolean DEFAULT false NOT NULL,
    update_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE public.label_reference (
    id integer NOT NULL,
    label_id integer NOT NULL,
    artifact_id integer NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.notification_policy (
    id integer NOT NULL,
    name character varying(256),
    project_id integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    description text,
    targets text,
    event_types text,
    creator character varying(256),
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.oidc_user (
    id integer NOT NULL,
    user_id integer NOT NULL,
    secret character varying(255) NOT NULL,
    subiss character varying(255) NOT NULL,
    token text,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.p2p_preheat_instance (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    vendor character varying(255) NOT NULL,
    endpoint character varying(255) NOT NULL,
    auth_mode character varying(255),
    auth_data text,
    enabled boolean,
    is_default boolean,
    insecure boolean,
    setup_timestamp integer
);

CREATE TABLE public.p2p_preheat_policy (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1024),
    project_id integer NOT NULL,
    provider_id integer NOT NULL,
    filters character varying(1024),
    trigger character varying(255),
    enabled boolean,
    creation_time timestamp without time zone,
    update_time timestamp without time zone,
    extra_attrs text
);

CREATE TABLE public.permission_policy (
    id integer NOT NULL,
    scope character varying(255) NOT NULL,
    resource character varying(255),
    action character varying(255),
    effect character varying(255),
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.project (
    project_id integer NOT NULL,
    owner_id integer NOT NULL,
    name character varying(255) NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted boolean DEFAULT false NOT NULL,
    registry_id integer
);

CREATE TABLE public.project_blob (
    id integer NOT NULL,
    project_id integer NOT NULL,
    blob_id integer NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.project_member (
    id integer NOT NULL,
    project_id integer NOT NULL,
    entity_id integer NOT NULL,
    entity_type character(1) NOT NULL,
    role integer NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.project_metadata (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.properties (
    id integer NOT NULL,
    k character varying(64) NOT NULL,
    v text NOT NULL
);

CREATE TABLE public.quota (
    id integer NOT NULL,
    reference character varying(255) NOT NULL,
    reference_id character varying(255) NOT NULL,
    hard jsonb NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    version bigint DEFAULT 0
);

CREATE TABLE public.quota_usage (
    id integer NOT NULL,
    reference character varying(255) NOT NULL,
    reference_id character varying(255) NOT NULL,
    used jsonb NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    version bigint DEFAULT 0
);

CREATE TABLE public.registry (
    id integer NOT NULL,
    name character varying(64),
    url character varying(256),
    access_key character varying(255),
    access_secret character varying(4096),
    insecure boolean DEFAULT false NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    credential_type character varying(16),
    type character varying(32),
    description text,
    health character varying(16)
);

CREATE TABLE public.replication_policy (
    id integer NOT NULL,
    name character varying(256),
    dest_registry_id integer,
    enabled boolean DEFAULT true NOT NULL,
    description text,
    deleted boolean DEFAULT false NOT NULL,
    trigger character varying(256),
    filters character varying(1024),
    replicate_deletion boolean DEFAULT false NOT NULL,
    start_time timestamp without time zone,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    creator character varying(256),
    src_registry_id integer,
    dest_namespace character varying(256),
    override boolean,
    dest_namespace_replace_count integer,
    speed_kb integer,
    copy_by_chunk boolean
);

CREATE TABLE public.report_vulnerability_record (
    id bigint NOT NULL,
    report_uuid text DEFAULT ''::text NOT NULL,
    vuln_record_id bigint DEFAULT 0 NOT NULL
);

CREATE TABLE public.repository (
    repository_id integer NOT NULL,
    name character varying(255) NOT NULL,
    project_id integer NOT NULL,
    description text,
    pull_count integer DEFAULT 0 NOT NULL,
    star_count integer DEFAULT 0 NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.retention_policy (
    id integer NOT NULL,
    scope_level character varying(20),
    scope_reference integer,
    trigger_kind character varying(20),
    data text,
    create_time timestamp without time zone,
    update_time timestamp without time zone
);

CREATE TABLE public.robot (
    id integer NOT NULL,
    name character varying(255),
    description character varying(1024),
    project_id integer,
    expiresat bigint,
    disabled boolean DEFAULT false NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    visible boolean DEFAULT true NOT NULL,
    secret character varying(2048),
    salt character varying(64),
    duration integer,
    creator_ref integer DEFAULT 0,
    creator_type character varying(255)
);

CREATE TABLE public.role (
    role_id integer NOT NULL,
    role_mask integer DEFAULT 0 NOT NULL,
    role_code character varying(20),
    name character varying(20)
);

CREATE TABLE public.role_permission (
    id integer NOT NULL,
    role_type character varying(255) NOT NULL,
    role_id integer NOT NULL,
    permission_policy_id integer NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.sbom_report (
    id integer NOT NULL,
    uuid character varying(64) NOT NULL,
    artifact_id integer NOT NULL,
    registration_uuid character varying(64) NOT NULL,
    mime_type character varying(256) NOT NULL,
    media_type character varying(256) NOT NULL,
    report json
);

CREATE TABLE public.scan_report (
    id integer NOT NULL,
    uuid character varying(64) NOT NULL,
    digest character varying(256) NOT NULL,
    registration_uuid character varying(64) NOT NULL,
    mime_type character varying(256) NOT NULL,
    report json,
    critical_cnt bigint,
    high_cnt bigint,
    medium_cnt bigint,
    low_cnt bigint,
    none_cnt bigint,
    unknown_cnt bigint,
    fixable_cnt bigint
);

CREATE TABLE public.scanner_registration (
    id integer NOT NULL,
    uuid character varying(64) NOT NULL,
    url character varying(256) NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(1024),
    auth character varying(16) NOT NULL,
    access_cred character varying(512),
    disabled boolean DEFAULT false NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    use_internal_addr boolean DEFAULT false NOT NULL,
    immutable boolean DEFAULT false NOT NULL,
    skip_cert_verify boolean DEFAULT false NOT NULL,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.schedule (
    id integer NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    vendor_type character varying(64),
    vendor_id integer,
    cron character varying(64),
    callback_func_name character varying(128),
    callback_func_param text,
    cron_type character varying(64),
    extra_attrs json,
    revision integer
);

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);

CREATE TABLE public.system_artifact (
    id integer NOT NULL,
    repository character varying(256) NOT NULL,
    digest character varying(255) DEFAULT ''::character varying NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    vendor character varying(255) DEFAULT ''::character varying NOT NULL,
    type character varying(255) DEFAULT ''::character varying NOT NULL,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    extra_attrs text DEFAULT ''::text NOT NULL
);

CREATE TABLE public.tag (
    id integer NOT NULL,
    repository_id integer NOT NULL,
    artifact_id integer NOT NULL,
    name character varying(255) NOT NULL,
    push_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    pull_time timestamp without time zone
);

CREATE TABLE public.task (
    id integer NOT NULL,
    execution_id integer NOT NULL,
    job_id character varying(64),
    status character varying(16) NOT NULL,
    status_code integer NOT NULL,
    status_revision integer,
    status_message text,
    run_count integer,
    extra_attrs json,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    start_time timestamp without time zone,
    update_time timestamp without time zone,
    end_time timestamp without time zone,
    vendor_type character varying(64) NOT NULL
);

CREATE TABLE public.user_group (
    id integer NOT NULL,
    group_name character varying(255) NOT NULL,
    group_type smallint DEFAULT 0,
    ldap_group_dn character varying(512) NOT NULL,
    creation_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.vulnerability_record (
    id bigint NOT NULL,
    cve_id text DEFAULT ''::text NOT NULL,
    registration_uuid text DEFAULT ''::text NOT NULL,
    package text DEFAULT ''::text NOT NULL,
    package_version text DEFAULT ''::text NOT NULL,
    package_type text DEFAULT ''::text NOT NULL,
    severity text DEFAULT ''::text NOT NULL,
    fixed_version text,
    urls text,
    cvss_score_v3 double precision,
    cvss_score_v2 double precision,
    cvss_vector_v3 text,
    cvss_vector_v2 text,
    description text,
    cwe_ids text,
    vendor_attributes json
);



