#!/bin/bash
# Buildah build script for RDKit with Python3.
# Inlcudes InChi, Avalon, Cairo and Swig support.
#

set -e

source ../params.sh


if [ ! -v GIT_BRANCH ]; then
  echo "GIT_BRANCH not defined"
  exit 1
fi
echo "Using RDKit branch $GIT_BRANCH"

# checkout RDKit source code
cd /root
RDBASE=/root/rdkit
rm -rf $RDBASE
echo "Checking out RDKit source code"
git clone -b $GIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git


mkdir $RDBASE/build
cd $RDBASE/build

# build RDKit for python
echo "Running cmake"
cmake -Wno-dev\
  -DLIB_SUFFIX=64\
  -DRDK_INSTALL_INTREE=OFF\
  -DRDK_BUILD_INCHI_SUPPORT=ON\
  -DRDK_BUILD_AVALON_SUPPORT=ON\
  -DRDK_BUILD_CAIRO_SUPPORT=ON\
  -DRDK_BUILD_PYTHON_WRAPPERS=ON\
  -DRDK_BUILD_SWIG_WRAPPERS=ON\
  -DCMAKE_INSTALL_PREFIX=/usr\
  -DCPACK_PACKAGE_RELOCATABLE=OFF\
  ..

echo "Building RDKit"
nproc=$(getconf _NPROCESSORS_ONLN)
make -j $(( nproc > 2 ? nproc - 2 : 1 ))

echo "Creating RPMs"
cpack3 -G RPM

echo "RDKit build complete"

