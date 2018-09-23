#!/bin/bash
# Attempt to do a centos based build
# NOTE - this does not yet work correctly. Use build.sh which is debian based instead.

set -ex

source params.sh

# build RDKit
docker build -f Dockerfile-build-centos\
  -t $BASE/rdkit-build:$DOCKER_TAG\
  --build-arg RDKIT_BRANCH=$GIT_BRANCH .

# copy the packages
rm -rf artifacts/centos/$DOCKER_TAG
mkdir -p artifacts/centos/$DOCKER_TAG/rpms
mkdir -p artifacts/centos/$DOCKER_TAG/java
mkdir -p artifacts/centos/$DOCKER_TAG/boost
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/centos/$DOCKER_TAG:/tohere:Z\
  $BASE/rdkit-build:$DOCKER_TAG bash -c 'cp build/*.rpm /tohere/rpms && cp /root/boost-1.56.0.tgz /tohere/boost'

# cp Code/JavaWrappers/gmwrapper/org.RDKit.jar /tohere/java && cp Code/JavaWrappers/gmwrapper/libGraphMolWrap.so /tohere/java && 

# build image for python
docker build -f Dockerfile-python-centos\
  -t $BASE/rdkit-python-centos:$DOCKER_TAG\
  --build-arg TAG=$DOCKER_TAG .
echo "Built image informaticsmatters/rdkit-python-centos:$DOCKER_TAG"

# build image for java
#docker build -f Dockerfile-java-centos\
#  -t $BASE/rdkit-java-centos:$DOCKER_TAG\
#  --build-arg TAG=$DOCKER_TAG .
#echo "Built image informaticsmatters/rdkit-java-centos:$DOCKER_TAG"

# build image for tomcat
#docker build -f Dockerfile-tomcat-centos\
#  -t $BASE/rdkit-tomcat-centos:$DOCKER_TAG\
#  --build-arg TAG=$DOCKER_TAG .
#echo "Built image informaticsmatters/rdkit-java-centos:$DOCKER_TAG"
