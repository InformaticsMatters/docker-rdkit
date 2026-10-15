# Builds all debian images in a single buildx invocation so that the expensive
# 'build' stage (RDKit compile) is solved once per platform and shared by every target.
# Variables are taken from the environment (see params.sh and build-debian.sh).

variable "BASE" { default = "informaticsmatters" }
variable "DOCKER_TAG" { default = "latest" }
variable "GIT_REPO" { default = "https://github.com/rdkit/rdkit.git" }
variable "GIT_BRANCH" { default = "master" }
variable "GIT_TAG" { default = "" }
variable "N_CORES" { default = "1" }
# commit sha(s) of the requested ref; changing it invalidates the cache from the git clone onwards
variable "RDKIT_REF" { default = "" }
variable "PLATFORMS" { default = "linux/amd64,linux/arm64" }
# optional registry cache reference, e.g. informaticsmatters/rdkit-buildcache:debian
variable "CACHE_REF" { default = "" }

group "default" {
  targets = ["python", "java", "tomcat", "cartridge"]
}

target "_common" {
  dockerfile = "Dockerfile-debian"
  context    = "."
  platforms  = split(",", PLATFORMS)
  args = {
    GIT_REPO   = GIT_REPO
    GIT_BRANCH = GIT_BRANCH
    GIT_TAG    = GIT_TAG
    N_CORES    = N_CORES
    RDKIT_REF  = RDKIT_REF
  }
  cache-from = CACHE_REF != "" ? ["type=registry,ref=${CACHE_REF}"] : []
  cache-to   = CACHE_REF != "" ? ["type=registry,ref=${CACHE_REF},mode=max"] : []
}

target "python" {
  inherits = ["_common"]
  target   = "python"
  tags     = ["${BASE}/rdkit-python3-debian:${DOCKER_TAG}"]
}

target "java" {
  inherits = ["_common"]
  target   = "java"
  tags     = ["${BASE}/rdkit-java-debian:${DOCKER_TAG}"]
}

target "tomcat" {
  inherits = ["_common"]
  target   = "tomcat"
  tags     = ["${BASE}/rdkit-tomcat-debian:${DOCKER_TAG}"]
}

target "cartridge" {
  inherits = ["_common"]
  target   = "cartridge"
  tags     = ["${BASE}/rdkit-cartridge-debian:${DOCKER_TAG}"]
}
