#start with ubuntu
FROM ubuntu

MAINTAINER Spenser Reinhardt

# updates and prereqs
RUN apt-get update -y
RUN apt-get install git build-essential -y
RUN apt-get install wget net-snmp net-snmp-utils perl-Net-SNMP
#clone and move to dir
#RUN git clone https://github.com/nagios-plugins/nagios-plugins.git
#RUN cd nagios-plugins

#setup and test
#RUN ./tools/setup 2&>1 | tee build.log
#RUN ./configure 2&>1 | tee build.log
#RUN make 2&>1 | tee build.log
#RUN make test 2&>1 | tee build.log

