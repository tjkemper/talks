sudo apt-get -y update 
sudo apt-get install -y openjdk-8-jdk 
sudo apt-get install -y maven 
sudo apt-get install -y git-all 
sudo wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - 
sudo echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list 
sudo apt-get install -y jenkins 
sudo service jenkins status
