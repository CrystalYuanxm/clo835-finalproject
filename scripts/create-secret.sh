#!/usr/bin/env bash
# Create the DB credentials Secret in the given cluster (no passwords in git).
# Usage: ./scripts/create-secret.sh kind-a
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/config.env"

CTX="${1:?usage: $0 <context>}"   # context is required, e.g. kind-a
NS="migrate-${STUDENT_ID}"
NAME="db-credentials-${STUDENT_ID}"

# Never overwrite: MySQL keeps the password from its first start   ← 新加的
if kubectl --context "$CTX" -n "$NS" get secret "$NAME" >/dev/null 2>&1; then
  echo "Secret ${NAME} already exists in ${CTX}, keeping it"
  exit 0
fi

# Random 32-char hex password (only needs coreutils)
randpw () { od -An -N16 -tx1 /dev/urandom | tr -d ' \n'; }

kubectl --context "$CTX" -n "$NS" create secret generic "$NAME" \
  --from-literal=MYSQL_ROOT_PASSWORD="$(randpw)" \
  --from-literal=MYSQL_DATABASE=migrate \
  --from-literal=MYSQL_USER=app \
  --from-literal=MYSQL_PASSWORD="$(randpw)"

echo "Secret ${NAME} created in ${CTX}/${NS}"
