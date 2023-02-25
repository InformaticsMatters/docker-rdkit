#!/bin/bash

set -e

source params.sh

docker push $BASE/rdkit-python3-debian:$DOCKER_TAG
docker push $BASE/rdkit-java-debian:$DOCKER_TAG
docker push $BASE/rdkit-tomcat-debian:$DOCKER_TAG

echo "Images pushed using tag $DOCKER_TAG"

