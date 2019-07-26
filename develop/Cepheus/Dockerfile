FROM tomcat:8.5-jdk8-openjdk

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG cepheus_url=http://cepheus:8080/cepheus/
ARG geco_septemberutil_version=0.3

RUN mkdir gitrepos
WORKDIR gitrepos

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util/september-util && mvn clean install -Dgeco.septemberutil.version=$geco_septemberutil_version

WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-cepheus.git
WORKDIR giles-eco-cepheus/cepheus
RUN mvn clean package -Dcepheus.baseDir=/usr/local/tomcat/cepehus-work -Dcepheus.tmp.folder=tmp -Dlog.level=info -Dcepheus.kafka.hosts=$kafka_host -Dcepheus.base.url=$cepheus_url -Dgeco.september.util.version=$geco_septemberutil_version -Dzookeeper.host=zookeeper

# deploy Cepheus
RUN cp ./target/cepheus.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cepehus-work
WORKDIR cepehus-work
RUN mkdir tmp
