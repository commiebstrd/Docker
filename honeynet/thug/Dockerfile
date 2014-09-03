#start with ubuntu
FROM ubuntu:latest

MAINTAINER Spenser Reinhardt
ENV DEBIAN_FRONTEND noninteractive

# updates and prereqs
RUN apt-get update -y
RUN apt-get install python python-beautifulsoup python-html5lib libemu2 libemu-dev python-libemu python-pefile python-lxml python-chardet python-httplib2 python-requests libboost-all-dev libboost-python-dev python-cssutils zope* python-pygraphviz python-pyparsing python-pydot python-magic python-yara libyara2 mongodb python-pymongo python-librabbitmq python-pika -y

#copy and build
COPY ./install.sh ./install.sh
RUN chmod +x ./install.sh
RUN ./install.sh

#cleanup
RUN mv ./install.log /opt/thug/install.log
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ./install.sh

EXPOSE 80 443
WORKDIR /opt/[project]
#CMD ["binary-to-start"]
