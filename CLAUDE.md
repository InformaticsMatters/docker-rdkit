# docker-rdkit

Builds the `informaticsmatters/rdkit-{python3,java,tomcat,cartridge}-debian` images from RDKit source (amd64 + arm64).

## Layout

- `Dockerfile-debian` - multi-stage. The `build` stage compiles RDKit and makes the deb packages and Java artifacts; `python`, `java`, `tomcat`, `cartridge` stages copy from it. `build` is never pushed.
- `docker-bake.hcl` - defines the four targets, tags and build args.
- `build-debian.sh` - entry point. Sources `params.sh`, then runs one `docker buildx bake` for all targets, so the RDKit compile happens once per platform and is shared.
- `params.sh` - per-branch settings: `DOCKER_TAG`, `GIT_REPO`, `GIT_BRANCH`, `GIT_TAG`, `BASE`.
- `buildah/`, `artifacts/` - legacy, not used by the current build.

## Building

Needs buildx with a docker-container builder (`docker buildx create --use`).

```
./build-debian.sh                                              # both platforms, PUSHES to Docker Hub
DOCKER_PLATFORM=linux/amd64 DOCKER_PUSH=false ./build-debian.sh  # quick local check, nothing pushed
```

Default is to push, tagged with `DOCKER_TAG` from `params.sh` (`latest` on master), which overwrites the published
images. Use `DOCKER_PUSH=false` unless you mean to publish.

Environment variables:

- `DOCKER_BUILD_OPTS` - extra bake options; `--no-cache` forces a full rebuild (default: none)
- `DOCKER_PLATFORM` - default `linux/amd64,linux/arm64`
- `DOCKER_PUSH=false` - do not push
- `DOCKER_TARGETS` - subset of `python java tomcat cartridge`
- `DOCKER_CACHE_REF` - optional registry cache ref, e.g. `informaticsmatters/rdkit-buildcache:debian`
- `DOCKER_N_CORES` - compile cores (default: all but 2)

Caching: the script resolves the commit of the requested branch/tag with `git ls-remote` and passes it as `RDKIT_REF`,
so the git clone layer and everything after it rebuild only when RDKit changes. A repeat run with no changes finishes in
seconds (all steps `CACHED`). A single-platform, no-push bake leaves images only in the builder cache (not loaded locally).
Cold compile is about 10 minutes for amd64; arm64 runs in parallel/emulated.

Note: only amd64 is expected for `tomcat` per the README, though the bake builds all requested platforms for every target.

## New release

When a new RDKit release is available:

1. Check the build works on `master`.
2. Create or update the `Release_YYYY_0X` branch. If new, branch off `master`, replace `README.md` with
   the two-line stub below, set `params.sh` to the branch form below, and run the build.
3. Create the `Release_YYYY_0X_Y` branch from `Release_YYYY_0X`, set `params.sh` to the tag form below, and run the build.

Each release branch differs from master essentially only in `params.sh` (and the README stub). Do not copy a release
branch's `params.sh` back to master. Build-script changes go on master and are merged into release branches.

README stub for `Release_*` branches:

```
# Dockerfiles for building RDKit.

See this document on the master branch for details
```

`params.sh` for `Release_YYYY_0X` (tracks the RDKit branch, image tag is the branch name):

```
export DOCKER_TAG=Release_2024_03
export GIT_REPO=https://github.com/rdkit/rdkit.git
export GIT_BRANCH=$DOCKER_TAG
unset GIT_TAG

export BASE=informaticsmatters
echo "DOCKER_TAG=$DOCKER_TAG GIT_BRANCH=$GIT_BRANCH"
```

`params.sh` for `Release_YYYY_0X_Y` (pins an RDKit release tag; image content should never change):

```
export DOCKER_TAG=Release_2024_03_1
export GIT_REPO=https://github.com/rdkit/rdkit.git
export GIT_BRANCH=Release_2024_03
export GIT_TAG=$DOCKER_TAG

export BASE=informaticsmatters
echo "DOCKER_TAG=$DOCKER_TAG GIT_BRANCH=$GIT_BRANCH GIT_TAG=$GIT_TAG"
```

`master` uses `DOCKER_TAG=latest`, `GIT_BRANCH=master`, `unset GIT_TAG`.
