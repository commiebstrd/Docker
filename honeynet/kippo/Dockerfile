#start with ubuntu
FROM ubuntu

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN apt-get update -y

#copy and build
COPY ./install.sh ./install.sh
RUN chmod +x ./install.sh
RUN ./install.sh

#cleanup
RUN mv /install.log /opt/kippo/install.log
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /install.sh

EXPOSE 2222
WORKDIR /opt/kippo
CMD ["./start.sh"]
