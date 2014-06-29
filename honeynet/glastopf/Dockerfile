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
