#!/usr/bin/env bash
set -euo pipefail

echo "Hello world"

#APP_DIR="${APP_DIR:-/opt/matrix-homeline}"
#PARAM_PATH="${PARAM_PATH:-/matrix-homeline/prod/}"
#
#cd "$APP_DIR"
#
## Render .env (tight perms)
#umask 077
#ENV_FILE="$APP_DIR/.env"
#: > "$ENV_FILE"
#
#aws ssm get-parameters-by-path \
#  --path "$PARAM_PATH" \
#  --with-decryption \
#  --query "Parameters[*].[Name,Value]" \
#  --output text \
#| awk -F'\t' '{
#    name=$1; val=$2;
#    gsub("^.*/", "", name);
#    printf "%s=%s\n", name, val
#  }' >> "$ENV_FILE"
#
#chmod 600 "$ENV_FILE"
#
## Adjust if your compose file is not at repo root
#COMPOSE_DIR="$APP_DIR"
#cd "$COMPOSE_DIR"
#
#docker compose --env-file "$ENV_FILE" pull
#docker compose --env-file "$ENV_FILE" up -d --remove-orphans
#docker compose ps
