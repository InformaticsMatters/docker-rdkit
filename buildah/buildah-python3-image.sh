#!/bin/bash
# Buildah build script for RDKit image with Python3.
# Also inlcudes numpy and pandas.
#
# The RDKIT_BRANCH environment variable must be defined. This defines the RDKit branch to pull
# and is used to define the tag for the image that is built.
#
# The result is a buildah image that can be pushed to the local docker registry like this:
# buildah push informaticsmatters/rdkit-python3-mini:latest docker-daemon:informaticsmatters/rdkit-python3-mini:$IMAGE_TAG

set -e


if [ ! -v RDKIT_BRANCH ]; then
  echo "RDKIT_BRANCH not defined"
  exit 1
elif [ "$RDKIT_BRANCH" = "master" ]; then
  export IMAGE_TAG="latest"
else
  export IMAGE_TAG=$RDKIT_BRANCH
fi
echo "Using image tag $IMAGE_TAG"

export IMAGE_NAME="informaticsmatters/rdkit-python3-mini"

cd /root/rdkit/build

# build the python container based on the base image
export newcontainer=$(buildah from scratch)
export scratchmnt=$(buildah mount $newcontainer)
echo "Creating python3 container $newcontainer using $scratchmnt"

# install the required packages
dnf -y install\
  bash\
  coreutils\
  cairo\
  python3\
  python3-devel\
  python3-numpy\
  python3-pandas\
  boost\
  boost-python3\
  curl\
  zip\
  unzip\
  procps-ng\
  --installroot $scratchmnt --releasever 29\
  --setopt install_weak_deps=false\
  --setopt tsflags=nodocs\
  --setopt override_install_langs=en_US.utf8
dnf -y clean all --installroot $scratchmnt --releasever 29
rm -rf $scratchmnt/var/cache/dnf

# install RDKit into the python container
make DESTDIR=$scratchmnt install

# set some config info
buildah config\
  --label name=rdkit-python-mini\
  --env LD_LIBRARY_PATH=/usr/lib/\
  $newcontainer

# commit the python image
buildah unmount $newcontainer
buildah commit $newcontainer $IMAGE_NAME:$IMAGE_TAG

echo "The built image can be pushed to docker using:"
echo "sudo buildah push $IMAGE_NAME:$IMAGE_TAG docker-daemon:$IMAGE_NAME:$IMAGE_TAG"
echo "Note: that needs to be done outside of the build container"

