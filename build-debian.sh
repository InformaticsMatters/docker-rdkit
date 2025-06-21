#!/bin/bash

set -xe

source params.sh

DBO=${DOCKER_BUILD_OPTS:---no-cache}
PLATFORM=${DOCKER_PLATFORM:-linux/amd64,linux/arm64}
DOCKERFILE=Dockerfile-debian
nproc=$(getconf _NPROCESSORS_ONLN) && N_CORES=${DOCKER_N_CORES:-$(( nproc > 2 ? nproc - 2 : 1 ))}

# build image for python3 on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORM \
  --target python \
  -t $BASE/rdkit-python3-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg N_CORES=$N_CORES \
  --push .
echo "Built images $BASE/rdkit-python3-debian:$DOCKER_TAG"

# build image for java on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORM \
  --target java \
  -t $BASE/rdkit-java-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg N_CORES=$N_CORES \
  --push .
echo "Built images $BASE/rdkit-java-debian:$DOCKER_TAG"

# build image for tomcat on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORM \
  --target tomcat \
  -t $BASE/rdkit-tomcat-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg N_CORES=$N_CORES \
  --push .
echo "Built images $BASE/rdkit-tomcat-debian:$DOCKER_TAG"

# build image for cartridge on debian
docker buildx build $DBO -f $DOCKERFILE \
  --platform $PLATFORM \
  --target cartridge \
  -t $BASE/rdkit-cartridge-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO \
  --build-arg GIT_BRANCH=$GIT_BRANCH \
  --build-arg N_CORES=$N_CORES \
  --push .
echo "Built images $BASE/rdkit-cartridge-debian:$DOCKER_TAG"


