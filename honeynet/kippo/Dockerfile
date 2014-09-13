#Kippo
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive
ENV logfile $HOME/install.log

RUN echo "Creating new Docker container for Kippo .." | tee -a $logfile
RUN echo $(date) | tee -a $logfile

#apt-get sources
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse'     /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list

# updates and prereqs
RUN echo "Installing prereqs" | tee -a $logfile
RUN apt-get update -y 2>&1 | tee -a $logfile
RUN apt-get install git wget python-dev openssl python-openssl python-pyasn1 python-twisted -y 2>&1 | tee -a $logfile

#user
RUN useradd -d /opt/kippo -s /sbin/nologin -M kippo -U 2>&1 | tee -a ${logfile}

#install kippo
WORKDIR /opt/
RUN git clone https://github.com/desaster/kippo.git kippo 2>&1 | tee -a ${logfile}
RUN chown -R kippo:kippo kippo/ | 2>&1 tee -a ${logfile}
WORKDIR kippo/
RUN rm kippo.cfg.dist 2>&1 | tee -a ${logfile}

#Finished
RUN  echo "Finished build correctly - Enjoy!" | tee -a $logfile
RUN  echo $(date) | tee -a $logfile

#cleanup
RUN if [[ -f $logfile ]]; then mv $logfile /opt/thug/install.log; else echo "No log, use docker's"; fi
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD kippo.cfg /opt/kippo/kippo.cfg
EXPOSE 2222
WORKDIR /opt/kippo/
VOLUME /opt/kippo/var/
CMD ["./start.sh"]
