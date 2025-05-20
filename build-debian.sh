#!/bin/bash

set -xe

source params.sh

DBO=${DOCKER_BUILD_OPTIONS:-''}
PLATFORMS=${DOCKER_PLATFORMS:-linux/amd64,linux/arm64}
DOCKERFILE=Dockerfile-debian

# build image for python3 on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORMS \
  --target python \
  -t $BASE/rdkit-python3-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --push .
echo "Built images $BASE/rdkit-python3-debian:$DOCKER_TAG"

# build image for java on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORMS \
  --target java \
  -t $BASE/rdkit-java-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --push .
echo "Built images $BASE/rdkit-java-debian:$DOCKER_TAG"

# build image for tomcat on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORMS \
  --target tomcat \
  -t $BASE/rdkit-tomcat-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --push .
echo "Built images $BASE/rdkit-tomcat-debian:$DOCKER_TAG"

# build image for cartridge on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORMS \
  --target cartridge \
  -t $BASE/rdkit-cartridge-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --push .
echo "Built images $BASE/rdkit-cartridge-debian:$DOCKER_TAG"


