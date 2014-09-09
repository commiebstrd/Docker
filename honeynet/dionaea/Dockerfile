#dionaea
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
ADD dionaea.conf /opt/dionaea/etc/dionaea.conf

#cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ./install.sh

EXPOSE 80 443
WORKDIR /opt/dionaea
CMD ["/opt/dionaea/bin/dionaea", "-D -l all -L '*' -u nobody -g nobody -r /opt/dionaea/ -w /opt/dionaea/ -p /opt/dionaea/var/dionaea.pid -c /opt/dionaea/etc/dionaea.conf" ]
