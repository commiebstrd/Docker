#!/bin/bash -e

#Maintainer:	Spenser Reinhardt
#Release:	v0.1
#License:	GPLv2

logfile="$HOME/install.log"

echo "Creating new Docker container for Kippo .." | tee -a $logfile
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
apt-get install git wget python-dev openssl python-openssl python-pyasn1 python-twisted -y 2>&1 | tee -a $logfile

#user
useradd -d /opt/kippo -s /sbin/nologin -M kippo -U 2>&1 | tee -a ${logfile}

#install kippo
cd /opt/ 2>&1 tee -a ${logfile}
git clone https://github.com/desaster/kippo.git kippo 2>&1 | tee -a ${logfile}
chown -R kippo:kippo kippo/ | 2>&1 tee -a ${logfile}
cd kippo 2>&1 | tee -a ${logfile}
rm kippo.cfg.dist 2>&1 | tee -a ${logfile}

#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
