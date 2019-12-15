#!/bin/bash

set -e

source params.sh

docker push $BASE/rdkit-build-centos:$DOCKER_TAG
docker push $BASE/rdkit-python3-centos:$DOCKER_TAG
docker push $BASE/rdkit-java-centos:$DOCKER_TAG

echo "Images pushed using tag $DOCKER_TAG"

