#start with ubuntu
FROM ubuntu

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN sudo apt-get update -y
RUN sudo apt-get install git lsb-release -y

#copy and execute
WORKDIR /opt
COPY ./install.sh ./install.sh
RUN chmod +x ./install.sh
RUN sudo ./install.sh

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ./install.sh

EXPOSE 80 443
WORKDIR /opt/myhoneypot
CMD ["glastopf-runner"]
