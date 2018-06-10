# Dockerfiles for building RDKit.

**IMPORTANT** these contents are currently experimental but are expected to superceed the existing informaticsmatters/rdkit*
Docker images.

These Dockerfiles and shell scripts are for building various Docker images for RDKit. The aim is to build a number of lightweight images that are suited for running in production cloud environments like Kubernetes and OpenShift. For this purpose the images need to be:

1. as small as is reasonable to minimise dowload time and reduce the potential attack surface 
1. run as a non-root user or an arbitarily assigned user ID.

The approach taken to build these images currently follows the [builder pattern](https://blog.alexellis.io/mutli-stage-docker-builds/).
See the [Smaller containers](https://www.informaticsmatters.com/category/containers/index.html) series of posts on the 
[Informatics Matters blog](https://www.informaticsmatters.com/blog.html) for more details about how these images are built.

For each RDKit version (image tag) we build a number of images:

* [informaticsmatters/rdkit-build](https://hub.docker.com/r/informaticsmatters/rdkit-build/) - this does a full build of RDKit from source. The result is a kitchen sink image (almost 2GB in size) that contains the entire build infrastructure and eveything that is built. The main purpose of this image is to build the artifacts needed for assembling the other lightweight images. Whist this image might be of some use for personal hacking it is NOT suitable for a public facing system as it is so large and has such a big attack surface.
* [informaticsmatters/rdkit-python-debian](https://hub.docker.com/r/informaticsmatters/rdkit-python-debian/) - a Debian based distribution designed for running RDKit from Python 2.7. The image size is approx 400MB.
* [informaticsmatters/rdkit-python-centos](https://hub.docker.com/r/informaticsmatters/rdkit-python-centos/) - a Centos7 based distribution designed for running RDKit from Python 2.7.
* [informaticsmatters/rdkit-java-debian](https://hub.docker.com/r/informaticsmatters/rdkit-java-debian/) - a Debian based distribution designed for running RDKit from Java. The image size is 
approx 350MB.
* [informaticsmatters/rdkit-tomcat-debian](https://hub.docker.com/r/informaticsmatters/rdkit-tomcat-debian/) -  a Debian based distribution designed for running a servlet in Apache Tomcat that uses the RDKit Java bindings. You need to provide the war file with the web application. The image size is approx 370MB.

## Branches

* `master` - build from current RDKit master branch. These images are updated at irregular intervals. Images have tag of `latest`.
* `Release_2017_09_2` - build from RDKit Release_2017_09_2 branch. These are not working correctly yet and may be dropped.
* `Release_2018_03` - build from RDKit Release_2018_03 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2018_03`.
* `Release_2018_03_1` - build from RDKit Release_2018_03_1 release tag. These images should never change [1]. Images have tag of `Release_2018_03_1` [2].
* `Release_2018_03_2` - build from RDKit Release_2018_03_2 release tag. These images should never change [1]. Images have tag of `Release_2018_03_2`.

[1] Where we say that the images should never change what we really mean in that the RDKit content should never change. We may rebuild these images occasionally when we find further improvements, and the underlying Centos/Debian packages may be updated, but the RDKit code should be exactly the same.

[2] These images were originally tagged as `Release_2018_03_01` (2 digits as the final number). For better consistency with the RDKit GitHub tag names we switched to using a single digit format. Tags with two digits are also present for backward compatibility and point to the equivalent single digit image. Please use the signle digit format.

GitHub repo for RDKit is [here](https://github.com/rdkit/rdkit).
GitHub repo for this project is [here](https://github.com/InformaticsMatters/docker-rdkit)

To create images for a new version of RDKit you should only need to create a new branch from `master` and then edit `params.sh`.

## Build and run

Create the docker images like this:

`./build.sh`

This builds the main `rdkit-build` image and then extracts the deb and rpm packages and the Java artifacts from it for use in assembling
the other images, and then assembles those `rdkit-python-debian`, `rdkit-java-debian` and `rdkit-tomcat-debian` images.

Push the images to Docker Hub like this:

`./push.sh`

Run the Python image like this:

`docker run -it --rm informaticsmatters/rdkit-python-debian:<tag_name> python`

Run the Java image like this:

`docker run -it --rm informaticsmatters/rdkit-java-debian:<tag_name> bash`

The CLASSPATH environment variable is already defiend to include the RDKit library. 
You'll need to add your own classes and/or libraries to the CLASSPATH. 
To do a simple test with the java image using a simple Java class that can be found in the java_src directory:
```
docker run -it --rm -v $PWD/java_src:/example:Z -u root informaticsmatters/rdkit-java-debian:<tag_name> sh -c 'cd /example && ./run.sh'
RDKit version: 2018.03.1.dev1
Read smiles: c1ccccc1 Number of atoms: 6
```

## RDKit cartridge

Efforts are now underway to extend this process to handle the RDKit postgres cartridge.
So far the build and installation of the cartridge in the `rdkit-build` image is working, but the RPM and DEB packages are not being built.
We hope to solve this soon so that we can create a series of `informaticsmatters/rdkit-postgresql` images.

If you want to use the cartridge in the `informaticsmatters/rdkit-build:latest` image then try something like this:
```
$ docker run -it --rm -u postgres informaticsmatters/rdkit-build:latest bash
postgres@db485abc2f02:/rdkit$ service postgresql start
[ ok ] Starting PostgreSQL 10 database server: main.
postgres@db485abc2f02:/rdkit$ psql 
psql (10.4 (Debian 10.4-2))
Type "help" for help.

postgres=# create database rdkit;
CREATE DATABASE
postgres=# \q
postgres@db485abc2f02:/rdkit$ psql -d rdkit
psql (10.4 (Debian 10.4-2))
Type "help" for help.

rdkit=# CREATE EXTENSION rdkit;
CREATE EXTENSION
rdkit=# \q
```

Notes:
1. The postgresql service is not started by default in this image as typically it will not be used. Hence why its necessary to run `service postgresql start`.
2. You must initially connect to the database as the `postgres` user, hence the need for the `-u postgres` option for the `docker run` command.

## Hopefully coming soon

* Tests for built images.
* Images for RDKit cartridge.

Requests also welcome!

 
