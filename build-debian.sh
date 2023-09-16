#!/bin/bash

set -xe

source params.sh

#DBO=${DOCKER_BUILD_OPTS:---no-cache}
function get_deb_package_name() {
   if [[ $GIT_BRANCH = "master" ]]
   then
      echo $GIT_BRANCH
   else
       echo $GIT_BRANCH | cut -d_ -f2 -f3
   fi
}

res="$(get_deb_package_name)"

# build RDKit
docker buildx build $DBO -f Dockerfile-build-debian \
  --platform linux/arm64,linux/amd64 \
  --push \
  -t $BASE/rdkit-build-debian:$DOCKER_TAG \
  --build-arg GIT_REPO=$GIT_REPO\
  --build-arg GIT_BRANCH=$GIT_BRANCH\
  --build-arg DEB_PACKAGE_DETAILS=$res\
  --build-arg GIT_TAG=$GIT_TAG .

# copy the packages
rm -rf artifacts/debian/$DOCKER_TAG
mkdir -p artifacts/debian/$DOCKER_TAG
mkdir -p artifacts/debian/$DOCKER_TAG/debs
mkdir -p artifacts/debian/$DOCKER_TAG/java
docker run -it --rm -u $(id -u)\
  -v $PWD/artifacts/debian/$DOCKER_TAG:/tohere:Z\
  $BASE/rdkit-build-debian:$DOCKER_TAG bash -c 'cp /rdkit/build/*.deb /tohere/debs && cp /rdkit/Code/JavaWrappers/gmwrapper/org.RDKit.jar /rdkit/Code/JavaWrappers/gmwrapper/libGraphMolWrap.so /rdkit/Code/JavaWrappers/gmwrapper/javadoc.tgz /tohere/java'

# build image for python3 on debian
docker buildx build $DBO -f Dockerfile-python3-debian \
 --platform linux/arm64,linux/amd64 \
 --push \
 -t $BASE/rdkit-python3-debian:$DOCKER_TAG \
 --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image ${BASE}/rdkit-python3-debian:$DOCKER_TAG"

# build image for java on debian
docker buildx build $DBO -f Dockerfile-java-debian \
 --platform linux/arm64,linux/amd64 \
 --push \
 -t $BASE/rdkit-java-debian:$DOCKER_TAG \
 --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image ${BASE}/rdkit-java-debian:$DOCKER_TAG"

# build image for tomcat on debian
docker buildx build $DBO -f Dockerfile-tomcat-debian \
 --platform linux/arm64,linux/amd64 \
 --push \
 -t $BASE/rdkit-tomcat-debian:$DOCKER_TAG \
 --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image ${BASE}/rdkit-tomcat-debian:$DOCKER_TAG"

# build image for postgresql cartridge on debian
docker buildx build $DBO -f Dockerfile-cartridge-debian \
  --platform linux/arm64,linux/amd64 \
  --push \
  -t $BASE/rdkit-cartridge-debian:$DOCKER_TAG \
  --build-arg DOCKER_TAG=$DOCKER_TAG .
echo "Built image ${BASE}/rdkit-cartridge-debian:$DOCKER_TAG"

