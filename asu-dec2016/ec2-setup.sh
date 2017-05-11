#!/bin/bash

sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get install -y openjdk-8-jdk && sudo apt-get install -y maven && sudo apt-get install -y git-all && wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - && sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && sudo apt-get install -y jenkins
