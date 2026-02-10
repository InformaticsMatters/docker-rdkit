#!/bin/bash
# 
# AWS Lambda based build
#
# NOTE - this is a bit a a hack as Centos7 comes with boost version 1.53, and several
# of the required libraries require this version, but recent RDKit builds (since the 
# switch to modern C++) require boost 1.58 or later.
# The solution is to build boost binaries for 1.58 so that RDKit can be built against
# those and to copy those binaries into the destination image, and to use the --nodeps
# option when rpm installing the RDKit RPMs.
# The resulting image has both versions of boost in /usr/lib64 and RDKit seems to be
# quite happy with this.
#
# Credit to Paolo Tosco for helping to work out a strategy for this. 

set -ex

source params.sh

# build RDKit
docker build --no-cache -f Dockerfile-build-python36-lambda\
  -t $BASE/rdkit-build-python36-lambda:$DOCKER_TAG\
  --build-arg RDKIT_BRANCH=$GIT_BRANCH .

# copy the packages
rm -rf artifacts/python36-lambda/$DOCKER_TAG
mkdir -p artifacts/python36-lambda/$DOCKER_TAG/rpms
mkdir -p artifacts/python36-lambda/$DOCKER_TAG/java
mkdir -p artifacts/python36-lambda/$DOCKER_TAG/boost
mkdir -p artifacts/python36-lambda/$DOCKER_TAG/layer
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/python36-lambda/$DOCKER_TAG:/tohere:Z\
  $BASE/rdkit-build-python36-lambda:$DOCKER_TAG bash -c 'cp build/*.rpm /tohere/rpms && cp /root/boost-1.58.0.tgz /tohere/boost'

# build image for python
docker build --no-cache -f Dockerfile-python36-lambda\
  -t $BASE/rdkit-python36-lambda:$DOCKER_TAG\
  --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image informaticsmatters/rdkit-python36-lambda:$DOCKER_TAG"

# copy the assembled layer
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/python36-lambda/$DOCKER_TAG:/tohere:Z\
  $BASE/rdkit-python36-lambda:$DOCKER_TAG bash -c 'cp /tmp/layer/rdkit-python36.zip /tohere/layer'

