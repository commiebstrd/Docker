# Thug web browser honeypot
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive
ENV logfile $HOME/install.log
ENV V8_HOME /tmp/v8

RUN echo "Creating new Docker container for Project .." | tee -a $logfile
RUN echo $(date) | tee -a $logfile

#apt-get sources
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse'     /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list

# updates and prereqs
RUN echo "Installing prereqs" | tee -a $logfile
RUN apt-get update -y 2>&1 | tee -a $logfile
RUN apt-get install python2.7 python2.7-dev python-pip python-beautifulsoup python-html5lib libemu2 libemu-dev python-libemu python-pefile python-lxml python-chardet python-httplib2 python-requests libboost-all-dev libboost-python-dev python-cssutils zope* python-pygraphviz python-pyparsing python-pydot python-magic python-yara libyara2 mongodb python-pymongo python-librabbitmq python-pika python-setuptools libxml2-dev libxslt-dev graphviz mongodb build-essential autoconf libtool subversion -y 2>&1 | tee -a $logfile

#google-v8
WORKDIR /tmp/
RUN svn checkout http://v8.googlecode.com/svn/trunk/ v8 2>&1 | tee -a $logfile
RUN svn checkout http://pyv8.googlecode.com/svn/trunk/ pyv8 2>&1 | tee -a $logfile
RUN cp thug/patches/PyV8-patch1.diff . 2>&1 | tee -a $logfile
RUN  patch -p0 < PyV8-patch1.diff 2>&1 | tee -a $logfile
WORKDIR pyv8/
RUN python setup.py build 2>&1 | tee -a $logfile
RUN python setup.py install 2>&1 | tee -a $logfile

#python deps
RUN pip install jsbeautifier 2>&1 | tee -a $logfile
RUN pip install rarfile 2>&1 | tee -a $logfile
RUN pip install html5lib 2>&1 | tee -a $logfile
RUN pip install beautifulsoup4 2>&1 | tee -a $logfile
RUN pip install pefile 2>&1 | tee -a $logfile
RUN pip install lxml 2>&1 | tee -a $logfile
RUN pip install chardet 2>&1 | tee -a $logfile
RUN pip install httplib2 2>&1 | tee -a $logfile
RUN pip install requests 2>&1 | tee -a $logfile
RUN pip install cssutils 2>&1 | tee -a $logfile
RUN pip install zope.interface 2>&1 | tee -a $logfile
RUN pip install pyparsing 2>&1 | tee -a $logfile
RUN pip install pydot2 2>&1 | tee -a $logfile
RUN pip install python-magic 2>&1 | tee -a $logfile
RUN pip install pymongo 2>&1 | tee -a $logfile

#Install Libemu
WORKDIR /tmp/
RUN git clone git://git.carnivore.it/libemu.git 2>&1 | tee -a $logfile
WORKDIR libemu/
RUN autoreconf -v -i 2>&1 | tee -a $logfile
RUN ./configure --prefix=/opt/libemu 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile

#Install Pylibemu
WORKDIR /tmp/
RUN git clone git://github.com/buffer/pylibemu.git 2>&1 | tee -a $logfile
WORKDIR pylibemu/
RUN python setup.py build 2>&1 | tee -a $logfile
RUN python setup.py install 2>&1 | tee -a $logfile
	     
#Install Yara
WORKDIR /opt/
RUN git clone https://github.com/plusvic/yara.git 2>&1 | tee -a $logfile
WORKDIR yara/
RUN bash build.sh 2>&1 | tee -a $logfile
RUN make install 2>&1 | tee -a $logfile

#Install Yara-Python
WORKDIR yara-python/
RUN python setup.py build 2>&1 | tee -a $logfile
RUN python setup.py install 2>&1 | tee -a $logfile

#Fix Libemu shared libs
RUN touch /etc/ld.so.conf.d/libemu.conf 2>&1 | tee -a $logfile
RUN echo "/opt/libemu/lib/" > /etc/ld.so.conf.d/libemu.conf 2>&1 | tee -a $logfile
RUN ldconfig 2>&1 | tee -a $logfile

#thug
WORKDIR /opt/
RUN git clone https://github.com/buffer/thug.git thug 2>&1 | tee -a $logfile

#Test Thug
RUN python /opt/thug/src/thug.py -h 2>&1 | tee -a $logfile

#Finished
RUN echo "Finished build correctly - Enjoy!" | tee -a $logfile
RUN echo $(date) | tee -a $logfile

#cleanup
RUN mv $logfile /opt/thug/install.log
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/thug/
CMD ["python", "src/thug.py"]
