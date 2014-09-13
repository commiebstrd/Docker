#conpot
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive
ENV logfile $HOME/install.log

RUN echo "Creating new Docker container for Conpot.." | tee -a $logfile
RUN echo $(date) | tee -a $logfile

#apt-get sources
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse'     /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list

#dependencies
RUN echo "Installing prereqs" | tee -a $logfile
RUN apt-get update -y 2>&1 | tee -a $logfile
RUN apt-get install libsmi2ldbl snmp-mibs-downloader -y 2>&1 | tee -a $logfile

#Build here
WORKDIR /opt/
RUN git clone git@github.com:glastopf/conpot.git 2>&1 | tee -a $logfile
WORKDIR conpot/
RUN python setup.py install 2>&1 | tee -a $logfile

#Finished
RUN echo "Finished build correctly - Enjoy!" | tee -a $logfile
RUN echo $(date) | tee -a $logfile
RUN if [[ ! -d /opt/conpot/ ]] || [[ ! -d /opt/conpot/var/ ]]; then mkdir -p /opt/conpot/var/; fi

#Add config
ADD conpot.cfg /opt/conpot/conpot.cfg

#cleanup
RUN if [[ -f $logfile ]]; then mv $logfile /opt/thug/install.log; else echo "No log, use docker's"; fi
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 161 503
WORKDIR /opt/conpot
VOLUME /opt/conpot/var/
CMD ["conpot", "-c /opt/conpot/conpot.cfg", ">> var/conpot.log"]
