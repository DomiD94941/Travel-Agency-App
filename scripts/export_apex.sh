set -euo pipefail

APP_ID="${1:-${APP_ID:-100}}"

if [ -f .env ]; then
  echo "[export] Loading environment from .env..."
  set -o allexport
  source .env
  set +o allexport
fi

if [ -z "${ADMIN_PASSWORD:-}" ]; then
  echo "[export] ERROR: ADMIN_PASSWORD is not set (in .env or environment)" >&2
  exit 1
fi

DB_HOST="${DB_HOST:-adbfree}"
DB_PORT_INTERNAL="${DB_PORT_INTERNAL:-1521}"
DB_SERVICE_NAME="${DB_SERVICE_NAME:-MYATP}"

DB_CONN="admin/${ADMIN_PASSWORD}@${DB_HOST}:${DB_PORT_INTERNAL}/${DB_SERVICE_NAME}"

echo "[export] Exporting APEX app ${APP_ID} using connection:"
echo "          $DB_CONN"

EXPORT_DIR="apex_exports/f${APP_ID}"
mkdir -p "$EXPORT_DIR"

docker compose run --rm \
  --entrypoint sql \
  sqlcl \
  "$DB_CONN" <<SQL
apex export -applicationid ${APP_ID} -split -dir /exports -skipExportDate -expOriginalIds
exit
SQL

echo "[export] Export finished. Files are in: $EXPORT_DIR"
