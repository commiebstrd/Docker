#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN apt-get update -y

#copy and build
WORKDIR /tmp/
ADD install.sh /tmp/install.sh
RUN chmod +x install.sh
RUN ./install.sh

#cleanup
RUN mv $HOME/install.log /opt/kippo/install.log
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /install.sh

ADD kippo.cfg /opt/kippo/kippo.cfg
EXPOSE 2222
WORKDIR /opt/kippo/
CMD ["./start.sh"]
