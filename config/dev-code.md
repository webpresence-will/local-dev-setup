#!/usr/bin/env bash

set -euo pipefail

SITE=$(basename "$PWD")
BASE_PATH="/var/www/html"

PHP_VERSION="8.5"

if [ -f ".php-version" ]; then
  PHP_VERSION=$(cat .php-version | tr -d '[:space:]')
fi

CONTAINER="php${PHP_VERSION/./}"

docker exec -it "$CONTAINER" sh -c "
  cd $BASE_PATH/$SITE && $*
"