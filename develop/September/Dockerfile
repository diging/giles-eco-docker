FROM tomcat:8.5-jdk8-openjdk

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG nepomuk_url=http://september:8080/september/
ARG request_version=v0.7
ARG util_version=v0.4.3

RUN mkdir gitrepos
WORKDIR gitrepos

# install requests
RUN git clone https://github.com/diging/giles-eco-requests.git && cd giles-eco-requests && git checkout master && git pull  && git checkout v0.7 && cd giles-eco-requests && mvn clean install -Dgeco.requests.version=$request_version

# install util
RUN git clone https://github.com/diging/giles-eco-util.git && cd giles-eco-util && git checkout master && git pull && git checkout v0.4.3 && cd util && mvn clean install -P no-gpg -Dgeco.util.version=$util_version

RUN git clone https://github.com/diging/giles-eco-september.git
WORKDIR giles-eco-september/september
RUN mvn clean package -Dlog.level=info -Dseptember.db_files=/data/dbs/september/ -Dseptember.kafka.hosts=$kafka_host -Dzookeeper.host=zookeeper -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version

# deploy Nepomuk
RUN cp ./target/september.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir persist
WORKDIR persist
RUN mkdir db
