#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/opt/matrix-homeline}"
GIT_URL="${GIT_URL:-https://github.com/vhonchar/matrix-homeline}"
GIT_REF="${GIT_REF:-main}"
AWS_REGION="${AWS_REGION:-eu-central-1}"
PARAM_PATH="${PARAM_PATH:-/matrix-homeline/prod}"

# --- Clone or update repo ---
mkdir -p "$APP_DIR"

if [[ ! -d "$APP_DIR/.git" ]]; then
  [[ -n "$GIT_URL" ]] || { echo "GIT_URL is required" >&2; exit 1; }
  git clone "$GIT_URL" "$APP_DIR"
fi

cd "$APP_DIR"

# Ensure origin is correct, then fetch and checkout requested ref
if [[ -n "$GIT_URL" ]]; then
  git remote set-url origin "$GIT_URL"
fi

git fetch --prune --tags origin

# Checkout logic: branch -> tag -> SHA
if git show-ref --verify --quiet "refs/remotes/origin/${GIT_REF}"; then
  git checkout -f -B "$GIT_REF" "origin/${GIT_REF}"
  git pull --ff-only origin "$GIT_REF" || true
elif git show-ref --verify --quiet "refs/tags/${GIT_REF}"; then
  git checkout -f "refs/tags/${GIT_REF}"
else
  git checkout -f "$GIT_REF"
fi

# --- Render .env from SSM (tight perms) ---
umask 077
ENV_FILE="$APP_DIR/.env"
: > "$ENV_FILE"

aws ssm get-parameters-by-path \
  --region "$AWS_REGION" \
  --path "$PARAM_PATH" \
  --recursive \
  --with-decryption \
  --query "Parameters[*].[Name,Value]" \
  --output text \
| awk -F'	' '{
    name=$1; val=$2;
    gsub("^.*/", "", name);
    gsub("-", "_", name);
    gsub("\.", "_", name);
    name=toupper(name);
    printf "%s=%s
", name, val
  }' >> "$ENV_FILE"

chmod 600 "$ENV_FILE"

# --- Launch docker compose ---
# Adjust if your compose file is not at repo root
COMPOSE_DIR="$APP_DIR"
cd "$COMPOSE_DIR"

docker compose --env-file "$ENV_FILE" pull

docker compose --env-file "$ENV_FILE" up -d --remove-orphans

docker compose ps
