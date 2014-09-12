#conpot
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN apt-get update -y

#copy and build
COPY ./install.sh ./install.sh
RUN chmod +x ./install.sh
RUN ./install.sh

#Add config
ADD conpot.cfg /opt/conpot/conpot.cfg

#cleanup
RUN mv /install.log /opt/[project]/install.log
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /install.sh

EXPOSE 80 161 503
WORKDIR /opt/conpot
VOLUME /opt/conpot/var/
CMD ["conpot", "-c /opt/conpot/conpot.cfg", ">> var/conpot.log"]
