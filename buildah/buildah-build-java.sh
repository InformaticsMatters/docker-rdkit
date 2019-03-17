#!/bin/bash

set -e

cd /root

# checkout RDKit source code
RDKIT_BRANCH=Release_2018_03_2
git clone -b $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git
mkdir $RDBASE/build
cd $RDBASE/build

RDBASE=/root/rdkit
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# build RDKit for java
cmake -Wno-dev\
  -DRDK_INSTALL_INTREE=OFF\
  -DRDK_BUILD_INCHI_SUPPORT=ON\
  -DRDK_BUILD_AVALON_SUPPORT=OFF\
  -DRDK_BUILD_CAIRO_SUPPORT=ON\
  -DRDK_BUILD_PYTHON_WRAPPERS=OFF\
  -DRDK_BUILD_SWIG_WRAPPERS=ON\
  -DCMAKE_INSTALL_PREFIX=/usr\
  ..

make -j $(( nproc > 2 ? nproc - 2 : 1 ))

# build the java container based on the base image
newcontainer=$(buildah from scratch)
scratchmnt=$(buildah mount $newcontainer)
echo "Creating java container $newcontainer using $scratchmnt"

# install the java packages
dnf -y install\
  bash\
  coreutils\
  cairo\
  java-1.8.0-openjdk-headless\
  boost-system\
  boost-chrono\
  boost-date-time\
  boost-regex\
  boost-serialization\
  boost-thread\
  boost-atomic\
  --installroot $scratchmnt --releasever 28\
  --setopt install_weak_deps=false\
  --setopt tsflags=nodocs\
  --setopt override_install_langs=en_US.utf8
dnf -y clean all --installroot $scratchmnt --releasever 28
rm -rf $scratchmnt/var/cache/dnf

# install RDKit into the java container
make DESTDIR=$scratchmnt install

# set some config info
buildah config\
  --label name=rdkit-java-mini\
  --env JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\
  --env LD_LIBRARY_PATH=/root/rdkit/Code/JavaWrappers/gmwrapper\
  --env CLASSPATH=/root/rdkit/Code/JavaWrappers/gmwrapper/org.RDKit.jar\
  $newcontainer

# commit the java image
buildah unmount $newcontainer
buildah commit $newcontainer informaticsmatters/rdkit-java-mini:latest


