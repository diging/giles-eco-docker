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
ARG geco.septemberutil.version=v0.2
ARG geco.kafka.util.version=v0.1

RUN mkdir gitrepos
WORKDIR gitrepos

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util && git checkout develop && cd september-util && mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version

# install kafka-util
RUN git clone https://github.com/diging/giles-eco-kafka-util.git && cd giles-eco-kafka-util/kafka-util && git checkout master && git pull && git checkout v0.1 && mvn clean install -Dgeco.kafka.util.version=$geco.kafka.util.version -Dgeco.september.util.version=$geco.septemberutil.version

WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-cepheus.git && cd giles-eco-cepheus && git checkout master && git pull  && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-cepheus/cepheus
RUN mvn clean package -Dcepheus.baseDir=/usr/local/tomcat/cepehus-work -Dcepheus.tmp.folder=tmp -Dlog.level=info -Dcepheus.kafka.hosts=$kafka_host -Dcepheus.base.url=$cepheus_url -Dgeco.september.util.version=$geco.septemberutil.version -Dzookeeper.host=zookeeper

# deploy Cepheus
RUN cp ./target/cepheus.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cepehus-work
WORKDIR cepehus-work
RUN mkdir tmp
