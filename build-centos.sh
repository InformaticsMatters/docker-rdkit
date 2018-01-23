#!/bin/bash

set -e

source params.sh

# build RDKit
docker build -f Dockerfile-build-centos\
  -t $BASE/rdkit-build:$TAG\
  --build-arg RDKIT_BRANCH=$BRANCH .

# copy the packages
rm -rf artifacts/$TAG
mkdir -p artifacts/$TAG
mkdir artifacts/$TAG/rpms
mkdir artifacts/$TAG/java
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/$TAG:/tohere:Z\
  $BASE/rdkit-build:$TAG bash -c 'cp build/*.rpm /tohere/rpms && cp Code/JavaWrappers/gmwrapper/org.RDKit.jar /tohere/java && cp Code/JavaWrappers/gmwrapper/libGraphMolWrap.so /tohere/java'

# build image for python
docker build -f Dockerfile-python-centos\
  -t $BASE/rdkit-python-centos:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-python-centos:$TAG"


# build image for java
docker build -f Dockerfile-java-centos\
  -t $BASE/rdkit-java-centos:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-java-centos:$TAG"

# build image for tomcat
docker build -f Dockerfile-tomcat-centos\
  -t $BASE/rdkit-tomcat-centos:$TAG\
  --build-arg TAG=$TAG .
echo "Built image informaticsmatters/rdkit-java-centos:$TAG"
