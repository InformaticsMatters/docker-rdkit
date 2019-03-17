#!/bin/bash
# Build script for RDKit with Python3.
# Also inlcudes numpy and pandas.
#
# The RDKIT_BRANCH environment variable must be defined. This defines the RDKit branch to use.

set -e


if [ ! -v RDKIT_BRANCH ]; then
  echo "RDKIT_BRANCH not defined"
  exit 1
fi
echo "Using RDKit branch $RDKIT_BRANCH"

# checkout RDKit source code
cd /root
RDBASE=/root/rdkit
rm -rf $RDBASE
echo "Checking out RDKit source code"
git clone -b $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git


mkdir $RDBASE/build
cd $RDBASE/build

# build RDKit for python
echo "Running cmake"
cmake -Wno-dev\
  -DRDK_INSTALL_INTREE=OFF\
  -DRDK_BUILD_INCHI_SUPPORT=ON\
  -DRDK_BUILD_AVALON_SUPPORT=ON\
  -DRDK_BUILD_CAIRO_SUPPORT=ON\
  -DRDK_BUILD_PYTHON_WRAPPERS=ON\
  -DRDK_BUILD_SWIG_WRAPPERS=OFF\
  -DCMAKE_INSTALL_PREFIX=/usr\
  ..

echo "Building RDKit"
nproc=$(getconf _NPROCESSORS_ONLN)
make -j $(( nproc > 2 ? nproc - 2 : 1 ))

echo "RDKit build complete"

