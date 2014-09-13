#honeybrid
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN apt-get update -y

#copy and build
ADD install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh
RUN if [[ ! -d /opt/honeybrid/ ]]; then mkdir /opt/honeybrid/; fi
RUN if [[ ! -d /opt/honeybrid/var/ ]]; then mkdir /opt/honeybrid/var/; fi
RUN if [[ ! -d /opt/honeybrid/etc/ ]]; then mkdir /opt/honeybrid/etc/; fi

#add config
#ADD honeybrid.cfg /etc/honeybrid/honeybrid.cfg

#cleanup
RUN mv /install.log /opt/honeybrid/install.log
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /install.sh

EXPOSE 80 443
WORKDIR /opt/honeybrid
VOLUME /opt/honeybrid/var
CMD ["/etc/init.d/honeybrid.sh"]
