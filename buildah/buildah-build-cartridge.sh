#!/bin/bash

set -e

# build the cartridge container based on the base image
newcontainer=$(buildah from scratch)
scratchmnt=$(buildah mount $newcontainer)
echo "Creating postgres container $newcontainer using $scratchmnt"

# install the python packages
dnf -y install\
  python\
  python-devel\
  numpy\
  boost\
  boost-python\
  postgresql-server\
  postgresql-devel\
  --installroot $scratchmnt\
  --releasever 28\
  --setopt install_weak_deps=false\
  --setopt tsflags=nodocs\
  --setopt override_install_langs=en_US.utf8
dnf -y clean all --installroot $scratchmnt --releasever 28
rm -rf $scratchmnt/var/cache/dnf

cd /root

# checkout RDKit source code
RDKIT_BRANCH=Release_2018_03_2
git clone -b $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git

RDBASE=/root/rdkit

mkdir $RDBASE/build
cd $RDBASE/build

# build RDKit
cmake -Wno-dev\
  -DRDK_INSTALL_INTREE=OFF\
  -DRDK_BUILD_INCHI_SUPPORT=ON\
  -DRDK_BUILD_AVALON_SUPPORT=OFF\
  -DRDK_BUILD_CAIRO_SUPPORT=ON\
  -DRDK_BUILD_PYTHON_WRAPPERS=OFF\
  -DRDK_BUILD_SWIG_WRAPPERS=OFF\
  -DCMAKE_INSTALL_PREFIX=/usr\
  -DRDK_BUILD_PGSQL=ON\
  -DPostgreSQL_ROOT=$scratchmnt/usr\
  -DPostgreSQL_TYPE_INCLUDE_DIR=$scratchmnt/usr/include/pgsql/server\
  ..

nproc=$(getconf _NPROCESSORS_ONLN)
make -j $(( nproc > 2 ? nproc - 2 : 1 ))

# install RDKit into the postgres container
make DESTDIR=$scratchmnt install
sh Code/PgSQL/rdkit/pgsql_install.sh

# set some config info
buildah config\
  --label name=rdkit-cartridge-mini\
  --env LD_LIBRARY_PATH=/usr/lib/\
  $newcontainer

# commit the python image
buildah unmount $newcontainer
buildah commit $newcontainer informaticsmatters/rdkit-cartridge-mini:latest

