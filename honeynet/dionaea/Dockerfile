#dionaea
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive
ENV logfile $HOME/install.log

#install deps
RUN apt-get update 2>&1 | tee $logfile
RUN apt-get install libudns-dev libglib2.0-dev libssl-dev libcurl4-openssl-dev libreadline-dev libsqlite3-dev python-dev libtool automake autoconf build-essential subversion git-core flex bison pkg-config wget -y 2>&1 | tee -a $logfile

#make build and install dir
RUN mkdir -p /opt/dionaea
WORKDIR /opt/dionaea/

#liblcfg
RUN git clone git://git.carnivore.it/liblcfg.git liblcfg 2>&1 | tee -a $logfile
WORKDIR liblcfg/code/
RUN autoreconf -vi 2>&1 | tee -a $logfile
RUN ./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile
WORKDIR /opt/dionaea/

#libemu
RUN git clone git://git.carnivore.it/libemu.git libemu 2>&1 | tee -a $logfile
WORKDIR libemu/
RUN  autoreconf -vi 2>&1 | tee -a $logfile
RUN ./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
RUN  make install 2>&1 | tee -a $logfile
WORKDIR /opt/dionaea/

#libnl - could be installed via apt, but git is prefered
RUN git clone git://git.infradead.org/users/tgr/libnl.git 2>&1 | tee -a $logfile
WORKDIR libnl/
RUN autoreconf -vi 2>&1 | tee -a $logfile
RUN export LDFLAGS=-Wl,-rpath,/opt/dionaea/lib
RUN ./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
RUN make 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile
WORKDIR /opt/dionaea

#libev
ADD http://dist.schmorp.de/libev/Attic/libev-4.04.tar.gz /opt/dionaea/libev-4.04.tar.gz
RUN tar xfzv libev-4.04.tar.gz 2>&1 | tee -a $logfile
WORKDIR libev-4.04
RUN ./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile
WORKDIR /opt/dionaea

#python 3.3
ADD http://www.python.org/ftp/python/3.2.2/Python-3.2.2.tgz /opt/dionaea/Python-3.2.2.tgz
RUN tar xfzv Python-3.2.2.tgz 2>&1 | tee -a $logfile
WORKDIR Python-3.2.2/
RUN ./configure --enable-shared --prefix=/opt/dionaea --with-computed-gotos --enable-ipv6 LDFLAGS="-Wl,-rpath=/opt/dionaea/lib/ -L/usr/lib/x86_64-linux-gnu/" 2>&1 | tee -a $logfile
RUN make 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile

#cython
ADD http://cython.org/release/Cython-0.15.tar.gz /opt/dionaea/Python-3.2.2/Cython-0.15.tar.gz
RUN tar xfzv Cython-0.15.tar.gz 2>&1 | tee -a $logfile
WORKDIR Cython-0.15/
RUN /opt/dionaea/bin/python3 setup.py install 2>&1 | tee -a $logfile
WORKDIR /opt/dionaea/

#libpcap
ADD http://www.tcpdump.org/release/libpcap-1.1.1.tar.gz /opt/dionaea/libpcap-1.1.1.tar.gz
RUN tar xfzv libpcap-1.1.1.tar.gz 2>&1 | tee -a $logfile
WORKDIR libpcap-1.1.1/
RUN ./configure --prefix=/opt/dionaea 2>&1 | tee -a $logfile
RUN make 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile
WORKDIR /opt/dionaea/

#dionaea
RUN git clone git://git.carnivore.it/dionaea.git dionaea 2>&1 | tee -a $logfile
WORKDIR dionaea/
RUN autoreconf -vi 2>&1 | tee -a $logfile
RUN ./configure --with-lcfg-include=/opt/dionaea/include/ \
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
RUN make 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile

#finished
RUN echo "Done making Dionaea - Enjoy!" | tee -a $logfile
RUN echo $(date) | tee -a $logfile
RUN mv $logfile /opt/dionaea/install.log

#cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -f /opt/dionaea/libpcap-1.1.1.tar.gz /opt/dionaea/Python-3.2.2/Cython-0.15.tar.gz /opt/dionaea/Python-3.2.2.tgz /opt/dionaea/libev-4.04.tar.gz 

#post build
EXPOSE 80 443
WORKDIR /opt/dionaea
CMD ["/opt/dionaea/bin/dionaea", "-D -l all -L '*' -u nobody -g nobody -r /opt/dionaea/ -w /opt/dionaea/ -p /opt/dionaea/var/dionaea.pid -c /opt/dionaea/etc/dionaea.conf" ]
