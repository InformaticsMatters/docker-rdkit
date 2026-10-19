#!/bin/bash

set -xe

source params.sh

# Builds all images with a single 'buildx bake' call so the RDKit compile (the 'build' stage)
# happens once per platform and is shared by all targets.
#
# Environment overrides:
#   DOCKER_BUILD_OPTS  extra bake options, e.g. "--no-cache" to force a full rebuild (default: none)
#   DOCKER_PLATFORM    platforms to build (default: linux/amd64,linux/arm64)
#   DOCKER_N_CORES     cores used to compile (default: all but 2)
#   DOCKER_CACHE_REF   optional registry cache ref, e.g. informaticsmatters/rdkit-buildcache:debian
#   DOCKER_TARGETS     targets to build (default: python java tomcat cartridge)
#   DOCKER_PUSH        set to "false" to not push (default: push)
DBO=${DOCKER_BUILD_OPTS:-}
nproc=$(getconf _NPROCESSORS_ONLN)
export N_CORES=${DOCKER_N_CORES:-$(( nproc > 2 ? nproc - 2 : 1 ))}
export PLATFORMS=${DOCKER_PLATFORM:-linux/amd64,linux/arm64}
export CACHE_REF=${DOCKER_CACHE_REF:-}
export GIT_TAG=${GIT_TAG:-}
TARGETS=${DOCKER_TARGETS:-python java tomcat cartridge}
if [ "${DOCKER_PUSH:-true}" = "false" ]; then PUSH=""; else PUSH="--push"; fi

# Resolve the commit(s) of the requested ref so the clone layer (and everything after it) is
# rebuilt only when RDKit has actually changed, while the earlier apt layers stay cached.
export RDKIT_REF=$(git ls-remote $GIT_REPO ${GIT_TAG:+"refs/tags/$GIT_TAG" "refs/tags/$GIT_TAG^{}"} "refs/heads/$GIT_BRANCH" | awk '{print $1}' | tr '\n' '-')
echo "RDKIT_REF=$RDKIT_REF"

docker buildx bake -f docker-bake.hcl $DBO $PUSH $TARGETS

echo "Built images $BASE/rdkit-{python3,java,tomcat,cartridge}-debian:$DOCKER_TAG"
