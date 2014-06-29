#!/bin/bash -e

#Maintainer:	Spenser Reinhardt
#Version:	v0.1
#License:	GPLv2

logfile=$(echo $HOME"install.log")

#install deps
apt-get install libudns-dev libglib2.0-dev libssl-dev libcurl4-openssl-dev \
libreadline-dev libsqlite3-dev python-dev \
libtool automake autoconf build-essential \
subversion git-core \
flex bison \
pkg-config \
wget -y 2>&1 | tee -a $logfile

#make build and install dir
mkdir -p /opt/dionaea
cd /opt/dionaea

#liblcfg
git clone git://git.carnivore.it/liblcfg.git liblcfg 2>&1 | tee -a $logfile
cd liblcfg/code
autoreconf -vi 2>&1 | tee -a $logfile
./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile
cd ..
cd ..

#libemu
git clone git://git.carnivore.it/libemu.git libemu 2>&1 | tee -a $logfile
cd libemu
autoreconf -vi 2>&1 | tee -a $logfile
./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile
cd ..

#libnl - could be installed via apt, but git is prefered
git clone git://git.infradead.org/users/tgr/libnl.git 2>&1 | tee -a $logfile
cd libnl
autoreconf -vi 2>&1 | tee -a $logfile
export LDFLAGS=-Wl,-rpath,/opt/dionaea/lib
./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile
cd ..

#libev
wget http://dist.schmorp.de/libev/Attic/libev-4.04.tar.gz 2>&1 | tee -a $logfile
tar xfz libev-4.04.tar.gz 2>&1 | tee -a $logfile
cd libev-4.04
./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile
cd ..

#python 3.3
wget http://www.python.org/ftp/python/3.2.2/Python-3.2.2.tgz 2>&1 | tee -a $logfile
tar xfz Python-3.2.2.tgz 2>&1 | tee -a $logfile
cd Python-3.2.2/
./configure --enable-shared --prefix=/opt/dionaea --with-computed-gotos --enable-ipv6 LDFLAGS="-Wl,-rpath=/opt/dionaea/lib/ -L/usr/lib/x86_64-linux-gnu/" 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile

#cython
wget http://cython.org/release/Cython-0.15.tar.gz 2>&1 | tee -a $logfile
tar xfz Cython-0.15.tar.gz 2>&1 | tee -a $logfile
cd Cython-0.15
/opt/dionaea/bin/python3 setup.py install 2>&1 | tee -a $logfile
cd ..

#udns - !ubuntu
#wget http://www.corpit.ru/mjt/udns/old/udns_0.0.9.tar.gz 2>&1 | tee -a $logfile
#tar xfz udns_0.0.9.tar.gz 2>&1 | tee -a $logfile
#cd udns-0.0.9/
#./configure 2>&1 | tee -a $logfile
#make shared 2>&1 | tee -a $logfile
#cp udns.h /opt/dionaea/include/ 2>&1 | tee -a $logfile
#cp *.so* /opt/dionaea/lib/ 2>&1 | tee -a $logfile
#cd /opt/dionaea/lib
#ln -s libudns.so.0 libudns.so 2>&1 | tee -a $logfile
#cd -
#cd ..

#libpcap
wget http://www.tcpdump.org/release/libpcap-1.1.1.tar.gz 2>&1 | tee -a $logfile
tar xfz libpcap-1.1.1.tar.gz 2>&1 | tee -a $logfile
cd libpcap-1.1.1
./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile
cd ..

#dionaea
git clone git://git.carnivore.it/dionaea.git dionaea 2>&1 | tee -a $logfile
cd dionaea
autoreconf -vi 2>&1 | tee -a $logfile
./configure --with-lcfg-include=/opt/dionaea/include/ \
	--with-lcfg-lib=/opt/dionaea/lib/ \
	--with-python=/opt/dionaea/bin/python3.2 \
	--with-cython-dir=/opt/dionaea/bin \
	--with-udns-include=/opt/dionaea/include/ \
	--with-udns-lib=/opt/dionaea/lib/ \
	--with-emu-include=/opt/dionaea/include/ \
	--with-emu-lib=/opt/dionaea/lib/ \
	--with-gc-include=/usr/include/gc \
	--with-ev-include=/opt/dionaea/include \
	--with-ev-lib=/opt/dionaea/lib \
	--with-nl-include=/opt/dionaea/include \
	--with-nl-lib=/opt/dionaea/lib/ \
	--with-curl-config=/usr/bin/ \
	--with-pcap-include=/opt/dionaea/include \
	--with-pcap-lib=/opt/dionaea/lib/ \
 2>&1 | tee -a $logfile
make 2>&1 | tee -a $logfile
make install 2>&1 | tee -a $logfile

echo "Done making Dionaea - Enjoy!" | tee -a $logfile
echo $(date) | tee -a $logfile

mv $logfile /opt/dionaea/install.log
