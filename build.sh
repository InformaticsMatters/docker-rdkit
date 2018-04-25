#!/bin/bash

set -xe

source params.sh

# build RDKit
docker build -f Dockerfile-build-debian\
  -t $BASE/rdkit-build:$TAG\
  --build-arg RDKIT_BRANCH=$BRANCH .

# copy the packages
rm -rf artifacts/$TAG
mkdir -p artifacts/$TAG
mkdir artifacts/$TAG/debs
mkdir artifacts/$TAG/rpms
mkdir artifacts/$TAG/java
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/$TAG:/tohere:Z\
  $BASE/rdkit-build:$TAG bash -c 'cp build/*.deb /tohere/debs && cp build/*.rpm /tohere/rpms && cp Code/JavaWrappers/gmwrapper/org.RDKit.jar /tohere/java && cp Code/JavaWrappers/gmwrapper/libGraphMolWrap.so /tohere/java'

# build image for python on debian
docker build -f Dockerfile-python-debian\
  -t $BASE/rdkit-python-debian:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-python-debian:$TAG"

# build image for python on centos
docker build -f Dockerfile-python-centos\
  -t $BASE/rdkit-python-centos:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-python-centos:$TAG"

# build image for java on debian
docker build -f Dockerfile-java-debian\
  -t $BASE/rdkit-java-debian:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-java-debian:$TAG"

# build image for tomcat on debian
docker build -f Dockerfile-tomcat-debian\
  -t $BASE/rdkit-tomcat-debian:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-tomcat-debian:$TAG"
