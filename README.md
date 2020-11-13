# Dockerfiles for building RDKit.

These images superceed the existing informaticsmatters/rdkit_* Docker images.

These Dockerfiles and shell scripts are for building various Docker images for RDKit. The aim is to build a number of lightweight images that are suited for running in production cloud environments like Kubernetes and OpenShift. For this purpose the images need to be:

1. as small as is reasonable to minimise dowload time and reduce the potential attack surface 
1. run as a non-root user or an arbitarily assigned user ID.

The approach taken to build these images currently follows the [builder pattern](https://blog.alexellis.io/mutli-stage-docker-builds/).
See the [Smaller containers](https://www.informaticsmatters.com/category/containers/index.html) series of posts on the 
[Informatics Matters blog](https://www.informaticsmatters.com/blog.html) for more details about how these images are built.

For each RDKit version (image tag) we build a number of images:

* [informaticsmatters/rdkit-build-debian](https://hub.docker.com/r/informaticsmatters/rdkit-build-debian/) - this does a full build of RDKit from source. The result is a kitchen sink image (almost 2GB in size) that contains the entire build infrastructure and eveything that is built. The main purpose of this image is to build the artifacts needed for assembling the other lightweight images. Whist this image might be of some use for personal hacking it is NOT suitable for a public facing system as it is so large and has such a big attack surface. Earlier versions were named `informaticsmatters/rdkit-build`.
* [informaticsmatters/rdkit-python-debian](https://hub.docker.com/r/informaticsmatters/rdkit-python-debian/) - a Debian based distribution designed for running RDKit from Python 2. The image size is approx 400MB. The last Python 2 images are for the `Release_2018_09` release.
* [informaticsmatters/rdkit-python3-debian](https://hub.docker.com/r/informaticsmatters/rdkit-python3-debian/) - a Debian based distribution designed for running RDKit from Python 3. Thes images start from the `Release_2019_03` release.
* [informaticsmatters/rdkit-java-debian](https://hub.docker.com/r/informaticsmatters/rdkit-java-debian/) - a Debian based distribution designed for running RDKit from Java.
* [informaticsmatters/rdkit-tomcat-debian](https://hub.docker.com/r/informaticsmatters/rdkit-tomcat-debian/) -  a Debian based distribution designed for running a servlet in Apache Tomcat that uses the RDKit Java bindings. You need to provide the war file with the web application.
* [informaticsmatters/rdkit-cartridge-debian](https://hub.docker.com/r/informaticsmatters/rdkit-cartridge-debian/) - a Debian based distribution with PostgreSQL and the RDKit cartridge. 
* [informaticsmatters/rdkit-build-centos](https://hub.docker.com/r/informaticsmatters/rdkit-build-centos/) - Kitchen sink build image equivalent to `informaticsmatters/rdkit-build-debian`.
* [informaticsmatters/rdkit-python3-centos](https://hub.docker.com/r/informaticsmatters/rdkit-python3-centos/) - a Centos based distribution designed for running RDKit from Python 3. Thes images start from the `Release_2019_09` release.
* [informaticsmatters/rdkit-java-centos](https://hub.docker.com/r/informaticsmatters/rdkit-java-centos/) - a Centos based distribution designed for running RDKit from Java.

## Branches

* `master` - build from current RDKit master branch. These images are updated at irregular intervals. Images have tag of `latest`.
* `Release_2017_09_2` - build from RDKit Release_2017_09_2 branch. These are not working correctly yet and may be dropped.
* `Release_2018_03` - build from RDKit Release_2018_03 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2018_03`
* `Release_2018_03_1` - build from RDKit Release_2018_03_1 release tag. These images should never change [1]. Images have tag of `Release_2018_03_1` [2]
* `Release_2018_03_2` - build from RDKit Release_2018_03_2 release tag. These images should never change [1]. Images have tag of `Release_2018_03_2`.
* `Release_2018_09` - build from RDKit Release_2018_09 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2018_09`
* `Release_2018_09_1` - build from RDKit Release_2018_09_1 release tag. These images should never change [1]. Images have tag of `Release_2018_09_1`
* `Release_2018_09_2` - build from RDKit Release_2018_09_2 release tag. These images should never change [1]. Images have tag of `Release_2018_09_2`
* `Release_2018_09_3` - build from RDKit Release_2018_09_3 release tag. These images should never change [1]. Images have tag of `Release_2018_09_3`
* `Release_2019_03` - build from RDKit Release_2019_03 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2019_03`
* `Release_2019_03_1` - build from RDKit Release_2019_03_1 release tag. These images should never change [1]. Images have tag of `Release_2019_03_1`
* `Release_2019_03_2` - build from RDKit Release_2019_03_2 release tag. These images should never change [1]. Images have tag of `Release_2019_03_2`
* `Release_2019_03_3` - build from RDKit Release_2019_03_3 release tag. These images should never change [1]. Images have tag of `Release_2019_03_3`
* `Release_2019_03_4` - build from RDKit Release_2019_03_4 release tag. These images should never change [1]. Images have tag of `Release_2019_03_4`
* `Release_2019_09` - build from RDKit Release_2019_09 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2019_09`
* `Release_2019_09_1` - build from RDKit Release_2019_09_1 release tag. These images should never change [1]. Images have tag of `Release_2019_09_1`
* `Release_2019_09_2` - build from RDKit Release_2019_09_2 release tag. These images should never change [1]. Images have tag of `Release_2019_09_2`
* `Release_2020_03` - build from RDKit Release_2020_03 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2020_03`
* `Release_2020_03_1` - build from RDKit Release_2020_03_1 release tag. These images should never change [1]. Images have tag of `Release_2020_03_1`
* `Release_2020_03_2` - build from RDKit Release_2020_03_2 release tag. These images should never change [1]. Images have tag of `Release_2020_03_2`
* `Release_2020_03_3` - build from RDKit Release_2020_03_3 release tag. These images should never change [1]. Images have tag of `Release_2020_03_3`
* `Release_2020_09` - build from RDKit Release_2020_09 branch and occasionally rebuilt as the code gets updated. Images have tag of `Release_2020_09` 
* `Release_2020_09_1` - build from RDKit Release_2020_09_1 release tag. These images should never change [1]. Images have tag of `Release_2020_09_1`


[1] Where we say that the images should never change what we really mean in that the RDKit content should never change. We may rebuild these images occasionally when we find further improvements, and the underlying Centos/Debian packages may be updated, but the RDKit code should be exactly the same.

[2] These images were originally tagged as `Release_2018_03_01` (2 digits as the final number). For better consistency with the RDKit GitHub tag names we switched to using a single digit format. Tags with two digits are also present for backward compatibility and point to the equivalent single digit image. Please use the single digit format.

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

The CLASSPATH environment variable is already defined to include the RDKit library. 
You'll need to add your own classes and/or libraries to the CLASSPATH. 
To do a simple test with the java image using a simple Java class that can be found in the java_src directory:
```
docker run -it --rm -v $PWD/java_src:/example:Z -u root informaticsmatters/rdkit-java-debian:<tag_name> sh -c 'cd /example && ./run.sh'
RDKit version: 2018.03.1.dev1
Read smiles: c1ccccc1 Number of atoms: 6
RDKit version: 2020.03.1
Mol: org.RDKit.RWMol@77459877
```

Javadocs are built into `/rdkit/Code/JavaWrappers/gmwrapper/doc`. Since the 2019_09 release a `javadocs.tgz` file is created in the 
`artifacts/debian/<tag>/java/` directory.

## RDBASE environment variable

In old versions of the images the RDBASE environment variable was set incorrectly which would impact functions where RDKit
needs to read it's internal data files. Since the `2020_03`, `2019_09` and `2019_09_3` images this should be correctly set, but older images will
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

We have now started to handle the RDKit postgres cartridge in a debian environment as a series of `informaticsmatters/rdkit-cartridge-debian` images.
This started with the `Release_2018_09` images. 

If you want to use the cartridge in the `informaticsmatters/rdkit-cartridge-debian:latest` image then try something like this.


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

1. You must initially connect to the database as the `postgres` user, hence the need for the `-u postgres` option for the `docker exec` command.

## Hopefully coming soon

* Tests for built images.

Requests also welcome!

