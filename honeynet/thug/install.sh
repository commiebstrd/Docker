#!/bin/bash -e

#Maintainer:	Spenser Reinhardt
#Release:	v0.1
#License:	GPLv2

logfile="$HOME/install.log"

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
apt-get install subversion git-core -y 2>&1 | tee -a $logfile

#google-v8
cd /tmp/
svn checkout http://v8.googlecode.com/svn/trunk/ v8 2>&1 | tee -a $logfile
svn checkout http://pyv8.googlecode.com/svn/trunk/ pyv8 2>&1 | tee -a $logfile
cp thug/patches/PyV8-patch1.diff . 2>&1 | tee -a $logfile
patch -p0 < PyV8-patch1.diff 2>&1 | tee -a $logfile
export V8_HOME=/tmp/v8
cd pyv8
python setup.py build 2>&1 | tee -a $logfile
python setup.py install 2>&1 | tee -a $logfile

#jsbeautifier
easy_install jsbeautifier 2>&1 | tee -a $logfile

#rarfile
easy_install rarfile 2>&1 | tee -a $logfile

#thug
cd /opt
git clone https://github.com/buffer/thug.git thug 2>&1 | tee -a $logfile

#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
