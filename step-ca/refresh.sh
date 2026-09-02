#!/bin/sh

set -eu

project_directory=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)

cd "$project_directory"

docker compose up -d step-ca
docker compose run --rm cert-init
docker compose up -d --no-deps nginx
docker compose exec -T nginx nginx -s reload

echo "Local certificates refreshed and Nginx reloaded."
