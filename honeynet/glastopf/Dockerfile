#glastopf
#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN sudo apt-get update -y
RUN sudo apt-get install git lsb-release -y

#copy and execute
WORKDIR /tmp
ADD install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ./install.sh

EXPOSE 80 443
WORKDIR /opt/myhoneypot
CMD ["glastopf-runner"]
