# Dockerfiles for building RDKit.

These images supersede the existing informaticsmatters/rdkit_* Docker images.

These Dockerfiles and shell scripts are for building various Docker images for RDKit. The aim is to build a number of
lightweight images that are suited for running in production cloud environments like Kubernetes and OpenShift. For this
purpose the images need to be:

1. as small as is reasonable to minimise download time and reduce the potential attack surface 
2. run as a non-root user or an arbitrarily assigned user ID.

The approach taken to build these images currently follows the [builder pattern](https://blog.alexellis.io/mutli-stage-docker-builds/).
See the [Smaller containers](https://www.informaticsmatters.com/category/containers/index.html) series of posts on the 
[Informatics Matters blog](https://www.informaticsmatters.com/blog.html) for more details about how these images are built.

For each RDKit version (image tag) we build a number of images:

* [informaticsmatters/rdkit-python3-debian](https://hub.docker.com/r/informaticsmatters/rdkit-python3-debian/) - a Debian based distribution designed for running RDKit from Python 3. These images start from the `Release_2019_03` release.
* [informaticsmatters/rdkit-java-debian](https://hub.docker.com/r/informaticsmatters/rdkit-java-debian/) - a Debian based distribution designed for running RDKit from Java.
* [informaticsmatters/rdkit-tomcat-debian](https://hub.docker.com/r/informaticsmatters/rdkit-tomcat-debian/) -  a Debian based distribution designed for running a servlet in Apache Tomcat that uses the RDKit Java bindings. You need to provide the war file with the web application.
* [informaticsmatters/rdkit-cartridge-debian](https://hub.docker.com/r/informaticsmatters/rdkit-cartridge-debian/) - a Debian based distribution with PostgreSQL and the RDKit cartridge. Note that we were unable to build cartridge images for the 2021_09 and 2022_03 based releases.

Note: we now focus on the Debian based images. In the past we also built on centos and fedora, but this caused too much
of a maintenance problem.

## Branches and image tags

Each branch of this repo builds the images with the same name as the branch:

* `master` - built from the current RDKit master branch. These images are updated at irregular intervals. Images have the tag `latest`.
* `Release_YYYY_0X` (e.g. `Release_2026_03`) - built from the RDKit branch of that name and occasionally rebuilt as the code gets updated.
  Images have the same tag as the branch.
* `Release_YYYY_0X_Y` (e.g. `Release_2026_03_6`) - built from the RDKit release tag of that name. These images should never
  change [1]. Images have the same tag as the branch.

## Available versions

All images are on Docker Hub, as `informaticsmatters/rdkit-{python3,java,tomcat,cartridge}-debian:<tag>`. The table lists
the tags that are published, and where an image is not available for a version. For each series the first
tag is the rolling branch image and the others are the fixed release tags. The tag `latest` is the current RDKit master.

| RDKit series | Tags | Platforms | Not available |
|--------------|------|-----------|---------------|
| 2026_09 | `Release_2026_09`, `Release_2026_09_1` | amd64, arm64 | |
| 2026_03 | `Release_2026_03`, `Release_2026_03_1` to `Release_2026_03_6` | amd64, arm64 | |
| 2025_09 | `Release_2025_09`, `Release_2025_09_1` to `Release_2025_09_6` | amd64, arm64 | |
| 2025_03 | `Release_2025_03`, `Release_2025_03_1` to `Release_2025_03_6` | amd64, arm64 | |
| 2024_09 | `Release_2024_09`, `Release_2024_09_1` to `Release_2024_09_6` | amd64, arm64 [3] | |
| 2024_03 | `Release_2024_03`, `Release_2024_03_1` to `Release_2024_03_6` | amd64, arm64 [4] | |
| 2023_09 | `Release_2023_09`, `Release_2023_09_1` to `Release_2023_09_3` | amd64, arm64 [4] | |
| 2023_03 | `Release_2023_03`, `Release_2023_03_1` to `Release_2023_03_4` | amd64, arm64 [4] | `_4`: python3 and cartridge |
| 2022_09 | `Release_2022_09`, `Release_2022_09_4`, `Release_2022_09_5` | amd64 | `_4`: cartridge |
| 2022_03 | `Release_2022_03`, `Release_2022_03_5` | amd64 | cartridge |
| 2021_09 | `Release_2021_09`, `Release_2021_09_1`, `Release_2021_09_2` | amd64 | cartridge; tomcat for `Release_2021_09` |
| 2021_03 | `Release_2021_03`, `Release_2021_03_2` to `Release_2021_03_5` | amd64 | |
| 2020_09 | `Release_2020_09`, `Release_2020_09_1` to `Release_2020_09_4` | amd64 | |
| 2020_03 | `Release_2020_03`, `Release_2020_03_1` to `Release_2020_03_6` | amd64 | |
| 2019_09 | `Release_2019_09`, `Release_2019_09_1` to `Release_2019_09_3` | amd64 | |
| 2019_03 | `Release_2019_03`, `Release_2019_03_1`, `Release_2019_03_2`, `Release_2019_03_4` | amd64 | `_2`, `_4`: cartridge |
| 2018_09 | `Release_2018_09`, `Release_2018_09_1` to `Release_2018_09_3` | amd64 | python3 (these start from `Release_2019_03`) |
| 2018_03 | `Release_2018_03`, `Release_2018_03_1`, `Release_2018_03_2` | amd64 | python3, cartridge [2] |
| 2017_09 | `Release_2017_09_2` | amd64 | python3, cartridge. Not working correctly and may be dropped |

Notes on the other tags that are on Docker Hub:

* `latest` - built from RDKit master (amd64, arm64).
* `experimental` - not a release; do not rely on it.
* `Release_2018_03_01` and `Release_2026_09_01` - old two digit forms of `Release_2018_03_1` and `Release_2026_09_1`. Please use the single digit forms.
* `Release_2024_09_2-arm64` and `15.8-rdkit-2024_03_3` - arm64 only images; use the normal multi-platform tags.

[1] Where we say that the images should never change what we really mean in that the RDKit content should never change.
We may rebuild these images occasionally when we find further improvements, and the underlying Debian packages may be
updated, but the RDKit code should be exactly the same.

[2] These images were originally tagged as `Release_2018_03_01` (2 digits as the final number). For better consistency
with the RDKit GitHub tag names we switched to using a single digit format. Tags with two digits are also present for
backward compatibility and point to the equivalent single digit image. Please use the single digit format.

[3] `Release_2024_09_1` is amd64 only. All other 2024_09 tags have both amd64 and arm64.

[4] The tomcat images are amd64 only for the 2023_03 and 2023_09 tags and for `Release_2024_03_1` and `Release_2024_03_2`.
All other images for these tags have both amd64 and arm64.

GitHub repo for RDKit is [here](https://github.com/rdkit/rdkit).
GitHub repo for this project is [here](https://github.com/InformaticsMatters/docker-rdkit)

To create images for a new version of RDKit you should only need to create a new branch from the corresponding
previous version and then edit `params.sh`.

## Build and run

Since October 2023 we have switched to a multi-stage build and are building images for amd64 and arm64 architectures.
Thanks to @nmunro and @artran for assistance with building on arm64. These arm64 images should be treated as 
experimental. Please report any issue you may find.

You need to use the `buildx` extensions to build these images. The Dockerfile-debian is the multi-stage Dockerfile
that builds all the images, and it is run by executing `build-debian.sh`, which is parameterised through the contents
of `params.sh`. To be able to run this you probably will need to enable buildx using a command like this:
`docker buildx create --use`.

The `build` stage builds RDKit form the appropriate GitHub branch for RDKit, and creates the deb packages and the Java 
artifacts from it for use in the `python`, `java`, `tomcat` and `cartridge` stages.
Each subsequent stage is run separately and the images pushed to dockerhub.
Note: only the amd64 is currently built for the `tomcat` image.

Run the Python image like this:

`docker run -it --rm informaticsmatters/rdkit-python3-debian:<tag_name> python`

Run the Java image like this:

`docker run -it --rm informaticsmatters/rdkit-java-debian:<tag_name> bash`

The CLASSPATH environment variable is already defined to include the RDKit library. 
You'll need to add your own classes and/or libraries to the CLASSPATH. 
To do a simple test with the java image using simple Java classes that can be found in the java_src directory first compile
the classes like this:
```
$ docker run -it --rm -v $PWD/java_src:/example:Z informaticsmatters/rdkit-build-debian:<tag_name> sh -c 'cd /example && ./compile.sh'
```
Then run like this:
```
$ docker run -it --rm -v $PWD/java_src:/example:Z informaticsmatters/rdkit-java-debian:<tag_name> sh -c 'cd /example && ./run.sh'
RDKit version: 2020.09.3
Read smiles: c1ccccc1 Number of atoms: 6
RDKit version: 2020.09.3
Mol: org.RDKit.RWMol@5b2133b1
RDKit version: 2020.09.3
MorganFP: 4294967295
```

Javadocs are built into `/rdkit/Code/JavaWrappers/gmwrapper/doc`. Since the 2019_09 release a `javadocs.tgz` file is created in the 
`artifacts/debian/<tag>/java/` directory.

## RDBASE environment variable

In old versions of the images the RDBASE environment variable was set incorrectly which would impact functions where RDKit
needs to read its internal data files. Since the `2020_03`, `2019_09` and `2019_09_3` images this should be correctly set, but older images will
suffer this problem and to fix it you must define the RDBASE environment variable when you run the container and set it
to a value of `/usr/share/RDKit`. e.g. `docker run -it -e RDBASE=/usr/share/RDKit ...`

## Python 3

Starting with the `Release_2019_03` release RDKit only supports Python 3.
We have been building Python 3 versions on the master/latest branch and for the 2019_03 versions onwards.

## Java

Most images are built with Java 8. In early 2019 the Debian Buster repositories changed so that 
Java 11 was present and Java 8 was no longer available (and could not easily be added). Thus Debian
images from 2019 onwards are built with Java 11. 

## RDKit cartridge

We have now started to handle the RDKit postgres cartridge in a debian environment as a series of 
`informaticsmatters/rdkit-cartridge-debian` images.
This started with the `Release_2018_09` images. 

If you want to use the cartridge in the `informaticsmatters/rdkit-cartridge-debian:latest` image then try something
like this:

```
# start the container
$ docker run -d --name rdkitcartridge informaticsmatters/rdkit-cartridge-debian:latest

# connect to the container
$ docker exec -it -u postgres rdkitcartridge bash
# run psql and create a database
postgres@db485abc2f02:/rdkit$ psql 
psql (10.4 (Debian 10.4-2))
Type "help" for help.

postgres=# create database rdkit;
CREATE DATABASE
postgres=# \q
# connect again to that database and install the cartridge
postgres@db485abc2f02:/rdkit$ psql -d rdkit
psql (10.4 (Debian 10.4-2))
Type "help" for help.

rdkit=# CREATE EXTENSION rdkit;
CREATE EXTENSION
rdkit=# \q
```

Notes:

1. You must initially connect to the database as the `postgres` user, hence the need for the `-u postgres` option for 
   the `docker exec` command.

## Hopefully coming soon

* Tests for built images.

Requests also welcome!

## Building

`./build-debian.sh` builds all four images with a single `docker buildx bake` call (see `docker-bake.hcl`), so the
RDKit compile happens once per platform and is shared by all images. Layers are cached; the RDKit source layer is
invalidated only when the commit of the requested branch/tag changes. Options (environment variables):

* `DOCKER_BUILD_OPTS` - extra bake options, e.g. `--no-cache` to force a full rebuild (default: none)
* `DOCKER_PLATFORM` - default `linux/amd64,linux/arm64`; use `linux/amd64` for quick dev builds
* `DOCKER_PUSH=false` - build without pushing
* `DOCKER_TARGETS` - subset of `python java tomcat cartridge`
* `DOCKER_CACHE_REF` - optional registry cache reference, e.g. `informaticsmatters/rdkit-buildcache:debian`
* `DOCKER_N_CORES` - cores used for compiling


### New release

When a new RDKit release becomes available the general approach to build the images should be:

1. check the build runs on the `master` branch
2. create or update the `Release_YYYY_0X` branch. If new, branch of master, replace the `README.txt` with the content below
   and update `params.sh` with content similar to below (with appropriate release year and month) and run the build
3. create the `Release_YYYY_0X_Y` branch from the `Release_YYYY_0X` branch, update the `params.sh` with content similar 
   to below (with appropriate release year, month and version) and run the build

README.txt for `Release_*` branch:
```
# Dockerfiles for building RDKit.

See this document on the master branch for details
```

Sample params.sh for `Release_YYYY_0X` branches (adjust year and month accordingly):
```
export DOCKER_TAG=Release_2024_03
export GIT_REPO=https://github.com/rdkit/rdkit.git
export GIT_BRANCH=$DOCKER_TAG
unset GIT_TAG

export BASE=informaticsmatters
echo "DOCKER_TAG=$DOCKER_TAG GIT_BRANCH=$GIT_BRANCH"
```

Sample params.sh for `Release_YYYY_0X_Y` branches (adjust year, month and version accordingly):
```
export DOCKER_TAG=Release_2024_03_1
export GIT_REPO=https://github.com/rdkit/rdkit.git
export GIT_BRANCH=Release_2024_03
export GIT_TAG=$DOCKER_TAG

export BASE=informaticsmatters
echo "DOCKER_TAG=$DOCKER_TAG GIT_BRANCH=$GIT_BRANCH GIT_TAG=$GIT_TAG"
```