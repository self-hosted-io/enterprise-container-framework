## Builda CICD Image
This image is designed for use in CICD pipelines. It can be called via usual `docker run <image> /bin/bash -c "my script.sh" for example.

This image is NOT production image and only to be used in your build process. It includes various JDK and development tools to build and test your software. It has minimal views on security and includes things that security scanners may dislike.
  