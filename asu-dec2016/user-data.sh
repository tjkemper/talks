#!/bin/bash

apt-get -y update && apt-get -y upgrade && apt-get install -y openjdk-8-jdk && apt-get install -y maven && apt-get install -y git-all && wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add - && sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && apt-get install -y jenkins
