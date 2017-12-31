# Dockerfiles for building RDKit.

**IMPORTANT** these contents are currently experimental but are expected to superceed the existing informaticsmatters/rdkit*
Docker images.

These Dockerfiles and shell scripts are for building various Docker images for RDKit.

For each RDKit version (image tag) we build a number of images:

* `informaticsmatters/rdkit_build` - this does a full build of RDKit from source. The result is a kitchen sink image (almost 2GB in size)
that contains the entire build infrastructure and eveything that is built. The main purpose of this image is to build the artifacts 
needed for assembling the other lightweight images. Whist this image might be of some use for personal hacking it is NOT suitable for
a public facing system as it is so large and has such a large attack surface.
* `informaticsmatters/rdkit_python_debian` - a Debian based distribution designed for running RDKit from Python 2.7. The image size is 
approx 400MB.
* `informaticsmatters/rdkit_java_debian` -  a Debian based distribution designed for running RDKit from Java. The image size is 
approx 350MB.
* `informaticsmatters/rdkit_tomcat_debian` -  a Debian based distribution designed for running a servlet in Apache Tomcat that uses the
RDKit Java bindings. Youmneed to provide the war file with the web application. The image size is approx 370MB.

## Branches

* `master` - build from current RDKit master branch. Images have tag of `latest`
* `Release_2017_09_2` - build from RDKit Release_2017_09_2 branch. Images have tag of `Release_2017_09_2`

GitHub repo for RDKit is [here](https://github.com/rdkit/rdkit).  
GitHub repo for this project is [here](https://github.com/InformaticsMatters/docker-rdkit)

To create images for a new version of RDKit you should only need to create a new branch from `master` and then edit `params.sh`.

## Build and run

Create the docker images like this:

`./build.sh`

This builds the main `rdkit_build` image and then extracts the deb packages and Java artifacts from it for use in assembling
the other images, and then assembles those `rdkit_python_debian`, `rdkit_java_debian` and `rdkit_tomcat_debian` images.

Push the images to Docker Hub like this:

`./push.sh`

Run the Python image like this:

`docker run -it --rm informaticsmatters/rdkit_python_debian:<tag_name> python`

Run the Java image like this:

`docker run -it --rm informaticsmatters/rdkit_java_debian:<tag_name> bash`

The CLASSPATH environment variable is already defiend to include the RDKit library. 
You'll need to add your own classes and/or libraries to the CLASSPATH. 
To do a simple test with the java image using a simple Java class that can be foundd in the java_src directory:
```
docker run -it --rm -v $PWD/java_src:/example:Z -u root informaticsmatters/rdkit_java_debian:<tag_name> sh -c 'cd /example && ./run.sh'
RDKit version: 2018.03.1.dev1
Read smiles: c1ccccc1 Number of atoms: 6
```

## Coming soon

* Tests for built images.
* Images for Centos7 and RDKit cartridge.
* Requests also welcome!

 
