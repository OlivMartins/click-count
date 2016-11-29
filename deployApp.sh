#!/bin/bash

#Prerequisite Docker has already been installed

# TODO : 
# - check if docker is available => if not install docker
# - use a docker compose file 
# - check logs ( docker logs $numCtn | grep -i clickCount | tail -1 ) => $numCtn to define
# - Test ips provided for STAGE & PROD environments 
# - Remove sudo commands & add groups/users

usage(){
	
	if [[ $# != 1 ]];then
		echo "./deployApp.sh [IP ADDRESS]"
		exit
	fi
}

installDocker(){

	curl -fsSL https://get.docker.com/ | sh
}
#distrib=`cat /etc/issue | cut -d ' ' -f1 | head -1`

usage $@
ipAddr=$1

sed -i.bkp "s/\"redis\"/\"${ipAddr}\"/" click-count/src/main/java/fr/xebia/clickcount/Configuration.java

#Create war with maven

sudo docker run -it --rm --name clickcount -v "$PWD/click-count":/usr/src/click-count -w /usr/src/click-count maven mvn clean package
sudo mv -v click-count/src/main/java/fr/xebia/clickcount/Configuration.java.bkp click-count/src/main/java/fr/xebia/clickcount/Configuration.java

#Create an image with tomcat & the new war

sudo mv -v click-count/target/clickCount.war tomcat/
sudo docker build -t xebiaapp tomcat/

#Run a container from the tomcat image with the application

sudo docker run -dti -p 8080:8080 xebiaapp

