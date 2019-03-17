#!/bin/bash
# Buildah build script for RDKit with Python3.
# Also inlcudes numpy and pandas.
#
# The RDKIT_BRANCH environment variable must be defined. This defines the RDKit branch to use.

set -e

echo "Building RDKit"
./buildah-python3-rdkit.sh

echo "Building image"
./buildah-python3-image.sh



