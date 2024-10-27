#!/usr/bin/env bash

set -ev

SCRIPT_DIR=$(dirname "$0")
DOCKER_CMD=docker

if [[ -z "$GROUP" ]] ; then
  echo "Cannot find GROUP env var"
  exit 1
fi

if [[ -z "$COMMIT" ]] ; then
  echo "Cannot find COMMIT env var"
  exit 1
fi

CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR

REPO=${GROUP}/$(basename front-end);

$DOCKER_CMD build -t ${REPO}:${COMMIT} .

sed -i "s|f3lin/front-end:[^ ]*|f3lin/front-end:$COMMIT|g" "$CODE_DIR/docker-compose.yml"

# if [[ -z "$TAG" ]] ; then
#   $DOCKER_CMD tag ${REPO}:${COMMIT} ${REPO}:${TAG}
#   # Remplace le tag de l'image dans le fichier docker-compose.yml
#   sed -i "s|f3lin/front-end:[^ ]*|f3lin/front-end:$TAG|g" "$CODE_DIR/docker-compose.yml"
# fi