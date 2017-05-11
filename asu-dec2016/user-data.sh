#!/bin/bash

# not working

apt-get -y update 
apt-get install -y openjdk-8-jdk 
apt-get install -y maven 
apt-get install -y git-all 
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - 
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list 
apt-get install -y jenkins 
service jenkins status
