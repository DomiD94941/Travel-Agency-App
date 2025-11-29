#!/usr/bin/env bash
set -euo pipefail

APP_ID="${1:-${APP_ID:-}}"

if [ -z "${APP_ID}" ]; then
  echo "[import] ERROR: No APP_ID provided."
  echo "Usage: ./import.sh <APP_ID>"
  exit 1
fi

if [ -f .env ]; then
  echo "[import] Loading .env..."
  set -o allexport
  source .env
  set +o allexport
fi

if [ -z "${ADMIN_PASSWORD:-}" ]; then
  echo "[import] ERROR: ADMIN_PASSWORD not set in .env" >&2
  exit 1
fi

DB_HOST="${DB_HOST:-adbfree}"
DB_PORT_INTERNAL="${DB_PORT_INTERNAL:-1521}"
DB_SERVICE_NAME="${DB_SERVICE_NAME:-MYATP}"

WORKSPACE="${WORKSPACE:-${TARGET_WORKSPACE:-}}"

if [ -z "${WORKSPACE}" ]; then
  echo "[import] ERROR: WORKSPACE or TARGET_WORKSPACE must be set." >&2
  exit 1
fi

DB_CONN="admin/${ADMIN_PASSWORD}@${DB_HOST}:${DB_PORT_INTERNAL}/${DB_SERVICE_NAME}"

echo "[import] Using DB connection: $DB_CONN"
echo "[import] Importing APEX App ID ${APP_ID} into workspace: ${WORKSPACE}"

if [ ! -f "apex_exports/f${APP_ID}/install.sql" ]; then
  echo "[import] ERROR: APEX export not found: apex_exports/f${APP_ID}/install.sql"
  exit 1
fi

docker compose run --rm \
  --entrypoint sql \
  sqlcl \
  "$DB_CONN" <<SQL
whenever sqlerror exit sql.sqlcode

begin
  apex_application_install.set_workspace(upper('${WORKSPACE}'));
end;
/

@/exports/f${APP_ID}/install.sql
exit
SQL

echo "[import] Done."
