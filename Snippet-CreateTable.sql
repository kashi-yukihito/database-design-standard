/*
 * [Table Name]: {table_name}
 * [Description]: {テーブルの説明をここに記述}
 * [Reference]: N_TBL001, L_TBL001 (DOA)
 */

CREATE TABLE IF NOT EXISTS app_schema.{table_name} (
    -- L_PKY001 / L_TYP013: 主キー (自然キー)
    {table_name}_code VARCHAR(10) NOT NULL,

    -- 業務項目例 (N_COL007回避: {table}_name)
    {table_name}_name      VARCHAR(100) NOT NULL,
    {table_name}_sts       VARCHAR(10)  NOT NULL, -- N_COL005
    {table_name}_flag      BOOLEAN      NOT NULL, -- L_TYP008

    -- L_DAT002: トレーサビリティ用共通カラム
    created_at           TIMESTAMPTZ  DEFAULT now() NOT NULL,
    created_by           VARCHAR(36)  NOT NULL,
    updated_at           TIMESTAMPTZ  DEFAULT now() NOT NULL, -- updated_at must be updated explicitly by application logic
    updated_by           VARCHAR(36)  NOT NULL,
    
    -- L_DAT003: 楽観ロック (Application-side increment)
    version              BIGINT       DEFAULT 0 NOT NULL,

    -- L_DAT004: 論理削除 (Optional)
    deleted_at           TIMESTAMPTZ  DEFAULT NULL,
    deleted_by           VARCHAR(36)  DEFAULT NULL,

    -- 制約定義
    CONSTRAINT pk_{table_name} PRIMARY KEY ({table_name}_code), -- N_IDX001
    CONSTRAINT chk_{table_name}_sts CHECK ({table_name}_sts IN ('active', 'inactive', 'pending')) -- N_CON003, L_CON002
);

-- S_SEC005: PIIマーキング (個人情報保護)
COMMENT ON COLUMN app_schema.{table_name}.{table_name}_name IS 'PII: Full name of the subject';
COMMENT ON TABLE  app_schema.{table_name} IS 'Managed by databaseDesign-standards v1.0.0';