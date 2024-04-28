#!/bin/bash

echo "Starting build..."

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
    DOCKER_BASE_DIR="/"
fi

if [ -z "$DOCKER_FILE_PATH" ]; then
    DOCKER_FILE_PATH="/Dockerfile"
fi

git clone $GIT_REPO source_code
cd source_code

if [ ! -z "$GIT_BRANCH" ]; then
  git switch $GIT_BRANCH
fi

echo "Create docker login file..."
mkdir -p ~/.docker
echo "{\"auths\": {\"$DOCKER_REGISTRY\": {\"username\": \"$DOCKER_REGISTRY_USER\",\"password\": \"$DOCKER_REGISTRY_PASSWORD\"}}}" > ~/.docker/config.json

echo "Building image..."

/bin/bash /app/buildctl-daemonless.sh build --frontend dockerfile.v0 --local context=/app/source_code/$DOCKER_BASE_DIR --local dockerfile=/app/source_code/$DOCKER_BASE_DIR --output type=image,name=$IMAGE_NAME:$IMAGE_TAG,push=true

echo "Image built successfully."

exit 0
