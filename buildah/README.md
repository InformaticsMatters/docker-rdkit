# Buildah builds for RDkit

This directory contains scripts for using [buildah](https://buildah.io/) to build minimal RDKit Python3 and Java images.
These are based on Centos8. The images should be functionally equivalent to the ones built with "classic" approach in
top level directory, but are significantly smaller. We expect that these images will replace the "classic" ones at some
stage and we may do the same for the Debian based images as well.

The build is done in a Docker container to provide a consistent build environment.

The resulting `buildah` images can be pushed to Docker and then run as a standard container image for Docker and other
container runtimes. 

## To build

### Build the Docker image for building 

```
docker build -f Dockerfile-buildah -t informaticsmatters/rdkit-buildah:latest .
```

### Fire up the build container
```
docker run -it -v $PWD:$PWD:Z -v /var/lib/containers:/var/lib/containers --privileged -w $PWD --name rdkit_build informaticsmatters/rdkit-buildah:latest bash
```
Note that the `var/lib/containers` directory is mounted into the container allowing it to write to the area where the host machine
looks for images and containers. Also note that this runs as a privleged container so make sure you understand what is being built.

You should see a bash prompt from inside the container.

### Run the Python build

Build RDKit from the source code on that branch:

```
./buildah-python3-rdkit.sh
```

Build the container image:

```
./buildah-python3-image.sh
```

Check the output of the last step for the precise details of what to push.
The command listed below is just an example.
You need to do this from the host machine (not inside the container):
```
sudo buildah push informaticsmatters/rdkit-python3-mini:latest docker-daemon:informaticsmatters/rdkit-python3-mini:latest
```

### Run the Java build

The process is the same as for the Python image, just use the files with -java- rather than -python3-


## Image sizes

These images are significantly smaller than the "classic" onces for Centos.

The Python image is 657MB compared with 741MB.
The Java image is 519MB compared with 848MB.


