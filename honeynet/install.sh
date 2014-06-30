#!/bin/bash -e

#Maintainer:	Spenser Reinhardt
#Release:	v0.1
#License:	GPLv2

logfile=$(echo $HOME"install.log")

echo "Creating new Docker container for Project .." | tee -a $logfile
echo $(date) | tee -a $logfile

#apt-get sources
#cname=$(lsb-release -c)
sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse'     /etc/apt/sources.list
sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list
sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list
sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list

#dependencies
echo "Installing prereqs" | tee -a $logfile

apt-get update -y 2>&1 | tee -a $logfile

#Build here



#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
