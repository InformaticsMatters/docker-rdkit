#!/bin/bash

set -xe

source params.sh

DBO=${DOCKER_BUILD_OPTS:---no-cache}

# build RDKit
docker build $DBO -f Dockerfile-build-debian\
  -t $BASE/rdkit-build:$DOCKER_TAG\
  --build-arg GIT_REPO=$GIT_REPO\
  --build-arg GIT_BRANCH=$GIT_BRANCH\
  --build-arg GIT_TAG=$GIT_TAG .

# copy the packages
rm -rf artifacts/debian/$DOCKER_TAG
mkdir -p artifacts/debian/$DOCKER_TAG
mkdir -p artifacts/debian/$DOCKER_TAG/debs
mkdir -p artifacts/debian/$DOCKER_TAG/java
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/debian/$DOCKER_TAG:/tohere:Z\
  $BASE/rdkit-build:$DOCKER_TAG bash -c 'cp build/*.deb /tohere/debs && cp Code/JavaWrappers/gmwrapper/org.RDKit.jar /tohere/java && cp Code/JavaWrappers/gmwrapper/libGraphMolWrap.so /tohere/java'

# build image for python on debian
docker build $DBO -f Dockerfile-python-debian\
  -t $BASE/rdkit-python-debian:$DOCKER_TAG\
  --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image informaticsmatters/rdkit-python-debian:$DOCKER_TAG"

# build image for java on debian
docker build $DBO -f Dockerfile-java-debian\
  -t $BASE/rdkit-java-debian:$DOCKER_TAG\
  --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image informaticsmatters/rdkit-java-debian:$DOCKER_TAG"

# build image for tomcat on debian
docker build $DBO -f Dockerfile-tomcat-debian\
  -t $BASE/rdkit-tomcat-debian:$DOCKER_TAG\
  --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image informaticsmatters/rdkit-tomcat-debian:$DOCKER_TAG"

# build image for postgresql cartridge on debian
docker build $DBO -f Dockerfile-cartridge-debian\
  -t $BASE/rdkit-cartridge-debian:$DOCKER_TAG\
  --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image informaticsmatters/rdkit-cartridge-debian:$DOCKER_TAG"

