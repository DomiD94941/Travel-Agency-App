#!/usr/bin/env bash
set -euo pipefail

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
echo "[importer] Target workspace:    $TARGET_WORKSPACE"
echo "[importer] Target schema:       $TARGET_SCHEMA"

echo "[importer] Waiting for DB to be ready..."
until sql -s "$DB_CONN" <<<'select 1 from dual;' >/dev/null 2>&1; do
  sleep 5
done

echo "[importer] Waiting for APEX packages..."
until sql -s "$DB_CONN" <<<'begin apex_util.find_security_group_id(p_workspace=>''INTERNAL''); end; /' >/dev/null 2>&1; do
  sleep 10
done

echo "[importer] Running DB scripts from /db (if any)..."
if ls /db/*.sql >/dev/null 2>&1; then
  for f in /db/*.sql; do
    echo "[importer] -> Running $f"
    sql -s "$DB_CONN" <<SQL
whenever sqlerror exit sql.sqlcode
set define on
define TARGET_WORKSPACE='${TARGET_WORKSPACE}'
define TARGET_SCHEMA='${TARGET_SCHEMA}'
define TARGET_SCHEMA_PASS='${TARGET_SCHEMA_PASS}'
define DEV_USER='${DEV_USER}'
define DEV_PASS='${DEV_PASS}'
@$f
SQL
  done
else
  echo "[importer] No /db/*.sql found."
fi

EXPORT_PATH="/exports/f${APP_ID}/install.sql"

if [ -f "$EXPORT_PATH" ]; then
  echo "[importer] Importing APEX app ${APP_ID} into workspace ${TARGET_WORKSPACE}..."
  sql -s "$DB_CONN" <<SQL
whenever sqlerror exit sql.sqlcode
begin
  apex_application_install.set_workspace(upper('${TARGET_WORKSPACE}'));
end;
/
@$EXPORT_PATH
SQL
else
  echo "[importer] No APEX export file found at $EXPORT_PATH. Skipping import."
fi

echo "[importer] Import finished successfully."
