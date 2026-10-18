#!/bin/bash
#
# Buildah build script for RDKit image with Java.
# Also inlcudes numpy and pandas.
#
# The GIT_BRANCH environment variable must be defined. This defines the RDKit branch to pull
# and is used to define the tag for the image that is built.
#
# The result is a buildah image that can be pushed to the local docker registry like this:
# buildah push informaticsmatters/rdkit-java-mini:latest docker-daemon:informaticsmatters/rdkit-java-mini:$IMAGE_TAG

set -e

source ../params.sh

if [ ! -v GIT_BRANCH ]; then
  echo "GIT_BRANCH not defined"
  exit 1
elif [ "$GIT_BRANCH" = "master" ]; then
  export IMAGE_TAG="latest"
else
  export IMAGE_TAG=$GIT_BRANCH
fi
echo "Using image tag $IMAGE_TAG"

export IMAGE_NAME="informaticsmatters/rdkit-java-mini"

# build the java container based on the base image
export newcontainer=$(buildah from scratch)
export scratchmnt=$(buildah mount $newcontainer)
echo "Creating java container $newcontainer using $scratchmnt"

# install the required packages
yum -y install\
  --setopt override_install_langs=en_US.utf8\
  --setopt install_weak_deps=false\
  --setopt tsflags=nodocs\
  --installroot $scratchmnt --releasever 8\
  java-11-openjdk-headless\
  bash\
  coreutils\
  cairo\
  boost-system\
  boost-thread\
  boost-serialization\
  boost-regex\
  boost-chrono\
  boost-date-time\
  boost-atomic\
  boost-iostreams\
  curl\
  zip\
  unzip\
  procps-ng
  
yum -y clean all --installroot $scratchmnt --releasever 8
rm -rf $scratchmnt/var/cache/dnf


# install RDKit
cd /root/rdkit/build
make DESTDIR=$scratchmnt install

# copy the java artifacts
mkdir -p $scratchmnt/rdkit/gmwrapper
cp /root/rdkit/Code/JavaWrappers/gmwrapper/org.RDKit.jar $scratchmnt/rdkit/gmwrapper/
cp /root/rdkit/build/Code/JavaWrappers/gmwrapper/libGraphMolWrap.so $scratchmnt/rdkit/gmwrapper/


# set some config info
buildah config\
  --label name=rdkit-java-mini\
  --env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/rdkit/gmwrapper\
  --env CLASSPATH=/rdkit/gmwrapper/org.RDKit.jar\
  --env RDBASE=/usr/share/RDKit\
  --env JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\
  --user 1000\
  $newcontainer
  

# commit the java image
buildah unmount $newcontainer
buildah commit $newcontainer $IMAGE_NAME:$IMAGE_TAG

echo "The built image can be pushed to docker using:"
echo "sudo buildah push $IMAGE_NAME:$IMAGE_TAG docker-daemon:$IMAGE_NAME:$IMAGE_TAG"
echo "Note: that needs to be done outside of the build container"

