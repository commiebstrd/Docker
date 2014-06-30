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
apt-get install automake autoconf git-core make build-essential binutils gcc flex byacc \
	libnetfilter-conntrack-dev libnetfilter-queue-dev libnetfilter-queue1 \
	libnfnetlink-dev libnfnetlink0 \
	pkg-config libc6-dev libglib2.0-0 libglib2.0-dev linux-libc-dev \
	libgloox-dev libxml2-dev libxml++ \
	libpcap0.8-dev libpcap0.8 libdumbnet-dev \
	openssl libssl-dev \
	libev-dev -y 2>&1 | tee -a $logfile

git clone git://git.code.sf.net/p/honeybrid/git honeybrid-git 2>&1 | tee -a $logfile
cd honeybrid-git
autoreconf -vi
./configure "$@" 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 tee -a $logfile
mkdir /etc/honeybrid
mkdir /var/log/honeybrid
cp honeybrid.conf /etc/honeybrid/ 2>&1 | tee -a $logfile
cp honeybrid.sh /etc/init.d/ 2>&1 | tee -a $logfile

#Finished
echo "Finished build correctly - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile
mv $logfile /var/log/honeybrid/install.log
