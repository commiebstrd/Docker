#!/bin/bash -e

#Maintainer:	Spenser Reinhardt
#Release:	v0.1
#License:	GPLv2

logfile="$HOME/install.log"

echo "Creating new Docker container for Project Glastopf" | tee -a $logfile
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
apt-get install python2.7 python-openssl python-gevent libevent-dev python2.7-dev build-essential make \
python-chardet python-requests python-sqlalchemy python-lxml python-beautifulsoup mongodb python-pip \
python-dev python-setuptools g++ git php5 php5-dev liblapack-dev gfortran libmysqlclient-dev libxml2-dev \
libxslt-dev -y 2>&1 | tee -a $logfile
pip install --upgrade distribute -y 2>&1 | tee -a $logfile

#checout and build latest php sandbox
echo "Cloning and building PHP sandbox" | tee -a $logfile

cd /opt
git clone git://github.com/glastopf/BFR.git 2>&1 | tee -a $logfile
cd BFR
phpize 2>&1 | tee -a $logfile
./configure --enable-bfr 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile
for i in $(find / -type f -name php.ini); do
	sed -i "/[PHP]/azend_extension=$(find /usr/lib/php5 -type f -name bfr.so)" $i;
done

#Clone and build glastopf
echo "Cloning and building Glastopf" | tee -a $logfile

cd /opt
git clone https://github.com/glastopf/glastopf.git 2>&1 | tee -a $logfile
cd glastopf
python setup.py install 2>&1 | tee -a $logfile

#Make dir for glastopf env
echo "Making glastopf environment" | tee -a $loglfile

cd /opt
mkdir myhoneypot
cd myhoneypot

#Initialize config
glastopf-runner 2>&1 | tee -a $logfile

#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
