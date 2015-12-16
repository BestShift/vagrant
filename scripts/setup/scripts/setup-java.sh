#!/bin/bash

# Default Java Runtimes and SDK
apt-install-if-needed openjdk-7-jdk openjdk-7-jre

# Configuration
if [ ! -e ~/.setup/java ]; then
	echo "JAVA_HOME='/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java'" | sudo tee -a /etc/environment >/dev/null
	source /etc/environment
	touch ~/.setup/java
fi