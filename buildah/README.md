# Buildah builds for RDkit

This directory contains scripts for using [buildah](https://buildah.io/) to build minimal RDKit Python3 images.
These are based on Fedora as a base OS (because of RDKit's requirement for a modern version of boost that
is not present in the current Centos7 OS - we may switch back to using Centos once this is resolved and Centos
support for Python3 is improved).

The build is done in a Docker container to provide a consistent build environment.

The resulting `buildah` image can be pushed to Docker and then run as a standard container image for Docker and other
container runtimes. 

## To build

### Build the Docker image for building 

```
docker build -f Dockerfile-buildah -t informaticsmatters/rdkit-buildah:latest .
```

### Fire up the build container
```
docker run -it -v $PWD:$PWD:Z -v /var/lib/containers:/var/lib/containers --privileged -w $PWD --rm informaticsmatters/rdkit-buildah:latest bash
```
Note that the `var/lib/containers` directory is mounted into the container allowing it to write to the area where the host machine
looks for images and containers. Also note that this runs as a privleged container so make sure you understand what is being built.

You should see a bash prompt from inside the container.

### Run the build
Define the `RDKIT_BRANCH` environment variable that specifies the RDKit branch to use:
```
export RDKIT_BRANCH=Release_2018_03_2
```

Build RDKit from the source code on that branch:

```
./buildah-python3-rdkit.sh
```

Build the container image:

```
./buildah-python3-image.sh
```

Note: the two previous steps can be run using this one command: `buildah-python3.sh`

Check the output of the last step for the precise details of what to push.
The command listed below is just an example.
You need to do this from the host machine (not inside the container):
```
sudo buildah push informaticsmatters/rdkit-python3-mini:Release_2018_03_2 docker-daemon:informaticsmatters/rdkit-python3-mini:Release_2018_03_2
```

## RDKit cartridge build

This directory also contains files related to building the RDKit cartridge in a similar manner.
These files are not yet operational and should be ignored.

