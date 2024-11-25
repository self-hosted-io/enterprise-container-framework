#!/bin/bash

# Define the Maven version (optional, you can find the latest version automatically)
MAVEN_BASE_URL="https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz"

# create mvn directory in /opt
mkdir -p /opt/maven/apache-maven-$MAVEN_VERSION

# Download Maven to /usr/local/apache-maven to /tmp
curl -s -L $MAVEN_BASE_URL -o /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz

# Extract the downloaded file to /usr/local/apache-maven
tar -xzf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt/maven/apache-maven-$MAVEN_VERSION --strip-components=1

# Create a symbolic link to the Maven installation directory
ln -s /opt/maven/apache-maven-$MAVEN_VERSION/bin/mvnexit /usr/bin/mvn







