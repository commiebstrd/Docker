#!/bin/bash -e

#Maintainer:	Spenser Reinhardt
#Release:	v0.1
#License:	GPLv2

logfile="$HOME/install.log"

echo "Creating new Docker container for Project Glastopf" | tee -a $logfile
echo $(date) | tee -a $logfile

#dependencies
echo "Installing prereqs" | tee -a $logfile

apt-get update 2>&1 | tee -a $logfile
apt-get install python2.7 python-openssl python-gevent libevent-dev python2.7-dev build-essential make 2>&1 | tee -a $logfile
apt-get install python-chardet python-requests python-sqlalchemy python-lxml 2>&1 | tee -a $logfile
apt-get install python-beautifulsoup mongodb python-pip python-dev python-setuptools 2>&1 | tee -a $logfile
apt-get install g++ git php5 php5-dev liblapack-dev gfortran libmysqlclient-dev 2>&1 | tee -a $logfile
apt-get install libxml2-dev libxslt-dev 2>&1 | tee -a $logfile
pip install --upgrade distribute 2>&1 | tee -a $logfile

#checout and build latest php sandbox
echo "Cloning and building PHP sandbox" | tee -a $logfile

cd /opt
git clone git://github.com/glastopf/BFR.git 2>&1 | tee -a $logfile
cd BFR
phpize 2>&1 | tee -a $logfile
./configure --enable-bfr 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile

#TODO Sed to replace zend
#zend_extension = /usr/lib/php5/20090626+lfs/bfr.so

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
glastopf-runner 2>&1 | tee -a $logfile

#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
