## Reference Image Overview
The reference images here are built using `rockylinux` refer to the Git repo and `image.yaml` spec for more details on how the image is built or how you may customise it.

This repo contains the following reference images:

### Base Images
* `base-ent` - Base Enterprise Image

### Python
* `python-ent-3.10` - Python 3.10 Enterprise Image
* `python-ent-3.11` - Python 3.11 Enterprise Image
* `python-ent-3.12` - Python 3.12 Enterprise Image

### Java
* `java-ent-11` - Java 11 Enterprise Image
* `java-ent-17` - Java 17 Enterprise Image
* `java-ent-21` - Java 21 Enterprise Image

### NodeJS
* `nodejs-ent-18` - NodeJS 18 Enterprise Image
* `nodejs-ent-20` - NodeJS 20 Enterprise Image
* `nodejs-ent-22` - NodeJS 22 Enterprise Image

### Golang
* `golang-builder` - Golang Builder Image
* `golang-ent-9` - Golang Enterprise Image based on RHEL like 9~ major version OS

### CI/CD
A special image for CI/CD purposes, includes many tools and utilities for CI/CD pipelines. Do not use this image for production purposes.

* `caas-ci:latest` - CI/CD Image