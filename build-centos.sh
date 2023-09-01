#!/bin/bash
#
# centos based build
#
# Currently Java and Cartridge images are not built to limit the complexity. Use the
# debain based images if you need these.


set -ex

source params.sh

# build RDKit
docker build --no-cache -f Dockerfile-build-centos\
  --platform $ARCH --push \
  -t $BASE/rdkit-build-centos:$DOCKER_TAG\
  --build-arg GIT_REPO=$GIT_REPO\
  --build-arg GIT_BRANCH=$GIT_BRANCH\
  --build-arg GIT_TAG=$GIT_TAG .

# copy the packages
rm -rf artifacts/centos/$DOCKER_TAG
mkdir -p artifacts/centos/$DOCKER_TAG/rpms
mkdir -p artifacts/centos/$DOCKER_TAG/java
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/centos/$DOCKER_TAG:/tohere:Z\
  $BASE/rdkit-build-centos:$DOCKER_TAG bash -c 'cp build/*.rpm /tohere/rpms && cp Code/JavaWrappers/gmwrapper/org.RDKit.jar /tohere/java && cp Code/JavaWrappers/gmwrapper/libGraphMolWrap.so /tohere/java'


# build image for python
docker build --no-cache -f Dockerfile-python3-centos\
  --platform $ARCH --push \
  -t $BASE/rdkit-python3-centos:$DOCKER_TAG\
  --build-arg TAG=$DOCKER_TAG .
echo "Built image ${BASE}/rdkit-python3-centos:$DOCKER_TAG"

# build image for java
docker build --no-cache -f Dockerfile-java-centos\
  --platform $ARCH --push \
  -t $BASE/rdkit-java-centos:$DOCKER_TAG\
  --build-arg TAG=$DOCKER_TAG .
echo "Built image ${BASE}/rdkit-java-centos:$DOCKER_TAG"
