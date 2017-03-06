FROM tomcat:8.0

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all

# install JDK 8
RUN \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list  && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  apt-get -y update && \
  apt-get -y install oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables.
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ARG kafka_host=kafka:9092
ARG cepheus_url=http://cepheus:8080/cepheus/
ARG request_version=v0.2.1-SNAPSHOT
ARG util_version=v0.4.2-SNAPSHOT

# install giles-eco-requests
RUN mkdir gitrepos
WORKDIR gitrepos
RUN git clone https://github.com/diging/giles-eco-requests.git
WORKDIR giles-eco-requests/giles-eco-requests
RUN mvn clean install -Dgeco.requests.version=request_version

# install giles-eco-util
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-util.git
WORKDIR giles-eco-util/util
RUN mvn clean install -Dgeco.util.version=util_version

WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-cepheus.git
WORKDIR giles-eco-cepheus/cepheus
RUN mvn clean package -Dcepheus.baseDir=/usr/local/tomcat/cepehus-work -Dcepheus.tmp.folder=tmp -Dlog.level=info -Dcepheus.kafka.hosts=$kafka_host -Dcepheus.base.url=$cepheus_url -Dgeco.requests.version=request_version -Dgeco.util.version=util_version

# deploy Cepheus
RUN cp ./target/cepheus.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cepehus-work
WORKDIR cepehus-work
RUN mkdir tmp
