#start with ubuntu
FROM ubuntu

MAINTAINER Spenser Reinhardt

# updates and prereqs
RUN apt-get update -y

#copy and build
COPY ./install.sh ./install.sh
RUN chmod +x ./install.sh
RUN ./install.sh
