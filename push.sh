#!/bin/bash

set -e

source params.sh

docker push $BASE/rdkit-build:$TAG
docker push $BASE/rdkit-python-debian:$TAG
docker push $BASE/rdkit-java-debian:$TAG
docker push $BASE/rdkit-tomcat-debian:$TAG

echo "Images pushed using tag $TAG"

