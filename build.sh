#!/bin/bash

set -e

if [ -z "$GIT_REPO" ]; then
  echo "GIT_REPOが設定されていません。"
  exit 1
fi

if [ -z "$IMAGE_NAME" ]; then
  echo "IMAGE_NAMEが設定されていません。"
  exit 1
fi

if [ -z "$IMAGE_TAG" ]; then
  echo "IMAGE_TAGが設定されていません。"
  exit 1
fi

if [ -z "$DOCKER_REGISTRY" ]; then
  echo "DOCKER_REGISTRYが設定されていません。"
  exit 1
fi

if [ -z "$DOCKER_REGISTRY_USER" ]; then
  echo "DOCKER_REGISTRY_USERが設定されていません。"
  exit 1
fi

if [ -z "$DOCKER_REGISTRY_PASSWORD" ]; then
  echo "DOCKER_REGISTRY_PASSWORDが設定されていません。"
  exit 1
fi

if [ -z "$DOCKER_BASE_DIR" ]; then
    DOCKER_BASE_DIR="./"
fi

if [ -z "$DOCKER_FILE_PATH" ]; then
    DOCKER_FILE_PATH="./Dockerfile"
fi

/bin/bash -c "/bin/bash -c 'dockerd-entrypoint.sh'" > /dev/null &

DOCKER_LOCK="/var/run/docker.sock"
while [ ! -e $DOCKER_LOCK ]
do
  sleep 1
done

git clone $GIT_REPO source_code
cd source_code

if [ ! -z "$GIT_BRANCH" ]; then
  git switch $GIT_BRANCH
fi

docker build -t $IMAGE_NAME:$IMAGE_TAG -f $DOCKER_FILE_PATH $DOCKER_BASE_DIR

echo $DOCKER_REGISTRY_PASSWORD | docker login $DOCKER_REGISTRY --username $DOCKER_REGISTRY_USER --password-stdin

docker push $IMAGE_NAME:$IMAGE_TAG

exit 0