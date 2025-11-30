#!/usr/bin/env bash
set -euo pipefail

# Load env
if [ -f .env ]; then
  echo "[importer] Loading .env..."
  set -o allexport
  source .env
  set +o allexport
fi

REQUIRED_VARS=(
  TARGET_WORKSPACE
  TARGET_SCHEMA
  TARGET_SCHEMA_PASS
  ADMIN_PASSWORD
  DB_HOST
  DB_SERVICE_NAME
  DB_PORT_INTERNAL
)

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "[importer] ERROR: Missing required variable: $var"
    exit 1
  fi
done

APP_ID="${APP_ID:-100}"
DEV_USER="${DEV_USER:-DEV}"
DEV_PASS="${DEV_PASS:-Dev_9494!A}"

DB_CONN="admin/${ADMIN_PASSWORD}@${DB_HOST}:${DB_PORT_INTERNAL}/${DB_SERVICE_NAME}"

echo "[importer] Using DB connection: $DB_CONN"
echo "[importer] Target workspace: $TARGET_WORKSPACE"
echo "[importer] Target schema: $TARGET_SCHEMA"

echo "[importer] Waiting for DB..."
until sql -s "$DB_CONN" <<<'select 1 from dual;' >/dev/null 2>&1; do
  sleep 5
done

echo "[importer] Waiting for APEX..."
until sql -s "$DB_CONN" <<<'begin apex_util.find_security_group_id(p_workspace=>''INTERNAL''); end; /' >/dev/null 2>&1; do
  sleep 10
done

echo "[importer] Running DB scripts..."

shopt -s nullglob
files=(/db/*.sql)

for f in "${files[@]}"; do
  echo "[importer] -> Running $f"

  if [[ "$f" == *"00_workspace"* ]]; then
    sql -s "$DB_CONN" <<SQL
whenever sqlerror exit sql.sqlcode
set define on
define TARGET_WORKSPACE='${TARGET_WORKSPACE}'
define TARGET_SCHEMA='${TARGET_SCHEMA}'
define TARGET_SCHEMA_PASS='${TARGET_SCHEMA_PASS}'
@$f
SQL

  else
    sql -s "$DB_CONN" <<SQL
whenever sqlerror exit sql.sqlcode
set define off
alter session set current_schema=${TARGET_SCHEMA};
@$f
SQL
  fi
done

echo "[importer] DONE."
