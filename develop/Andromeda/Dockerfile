FROM tomcat:9.0-jdk11-temurin-focal

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG andromeda_url=http://andromeda:8080/andromeda/
ARG geco.septemberutil.version=v0.2

RUN mkdir gitrepos
WORKDIR gitrepos

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util/september-util && mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version

# install andromeda
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-andromeda.git
WORKDIR giles-eco-andromeda/andromeda
RUN mvn clean package -Dandromeda.baseDir=/usr/local/tomcat/andromeda-work -Dandromeda.tmp.folder=tmp -Dlog.level=info -Dandromeda.kafka.hosts=$kafka_host -Dandromeda.base.url=$andromeda_url -Dgeco.september.util.version=$geco.septemberutil.version -Dzookeeper.host=zookeeper

# deploy Cepheus
RUN cp ./target/andromeda.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir andromeda-work
WORKDIR andromeda-work
RUN mkdir tmp
