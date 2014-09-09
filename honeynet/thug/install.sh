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
apt-get install subversion git-core python2.7 python2.7-dev python-pip build-essential autoconf libtool \
subversion libboost-all-dev libboost-python-dev python-setuptools libxml2-dev libxslt-dev \
graphviz mongodb-y 2>&1 | tee -a $logfile

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
pip install jsbeautifier 2>&1 | tee -a $logfile

#rarfile
pip install rarfile 2>&1 | tee -a $logfile

#html5lib
pip install html5lib 2>&1 | tee -a $logfile

#beautifulsoup4
pip install beautifulsoup4 2>&1 | tee -a $logfile

#Install Libemu
cd /tmp 2>&1 | tee -a $logfile
git clone git://git.carnivore.it/libemu.git 2>&1 | tee -a $logfile
cd libemu 2>&1 | tee -a $logfile
autoreconf -v -i 2>&1 | tee -a $logfile
./configure --prefix=/opt/libemu 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile

#Install Pylibemu
cd /tmp 2>&1 | tee -a $logfile
git clone git://github.com/buffer/pylibemu.git 2>&1 | tee -a $logfile
cd pylibemu 2>&1 | tee -a $logfile
python setup.py build 2>&1 | tee -a $logfile
python setup.py install 2>&1 | tee -a $logfile

#Install more packages via pip
pip install pefile 2>&1 | tee -a $logfile
pip install lxml 2>&1 | tee -a $logfile
pip install chardet 2>&1 | tee -a $logfile
pip install httplib2 2>&1 | tee -a $logfile
pip install requests 2>&1 | tee -a $logfile
pip install cssutils 2>&1 | tee -a $logfile
pip install zope.interface 2>&1 | tee -a $logfile
pip install pyparsing 2>&1 | tee -a $logfile
pip install pydot2 2>&1 | tee -a $logfile
pip install python-magic 2>&1 | tee -a $logfile
pip install pymongo 2>&1 | tee -a $logfile

#Install Yara
cd /opt 2>&1 | tee -a $logfile
git clone https://github.com/plusvic/yara.git 2>&1 | tee -a $logfile
cd yara/ 2>&1 | tee -a $logfile
bash build.sh 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile

#Install Yara-Python
cd /opt/yara/yara-python 2>&1 | tee -a $logfile
python setup.py build 2>&1 | tee -a $logfile
python setup.py install 2>&1 | tee -a $logfile

#Fix Libemu shared libs
touch /etc/ld.so.conf.d/libemu.conf 2>&1 | tee -a $logfile
echo "/opt/libemu/lib/" > /etc/ld.so.conf.d/libemu.conf 2>&1 | tee -a $logfile
ldconfig 2>&1 | tee -a $logfile

#thug
cd /opt
git clone https://github.com/buffer/thug.git thug 2>&1 | tee -a $logfile

#Test Thug
python /opt/thug/src/thug.py -h 2>&1 | tee -a $logfile

#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
