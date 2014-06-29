#start with ubuntu
FROM ubuntu

MAINTAINER Spenser Reinhardt

# updates and prereqs
RUN apt-get update -y
RUN apt-get install git -y

#clone and execute
RUN git clone https://github.com/commiebstrd/Docker.git -b honeynet
RUN chmod +x Docker/honeynet/glastopf/install.sh
RUN Docker/honeynet/glastopf/install.sh

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443
WORKDIR /opt/myhoneypot
CMD ["glastopf-runner"]
