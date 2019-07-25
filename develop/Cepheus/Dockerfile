FROM tomcat:8.0

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
RUN apt-get install -y subversion

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
ARG request_version=0.6
ARG util_version=0.4.2
ARG geco_septemberutil_version=0.3
ARG geco_kafka_util_version=0.1

# install giles-eco-requests
RUN mkdir gitrepos
WORKDIR gitrepos
RUN git clone https://github.com/diging/giles-eco-requests.git
WORKDIR giles-eco-requests/giles-eco-requests
RUN mvn clean install -Dgeco.requests.version=$request_version

# install giles-eco-util
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-util.git
WORKDIR giles-eco-util/util
RUN mvn clean install -Dgeco.util.version=$util_version

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util/september-util && mvn clean install -Dgeco.septemberutil.version=$geco_septemberutil_version -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version

# install kafka-util
RUN git clone https://github.com/diging/giles-eco-kafka-util.git && cd giles-eco-kafka-util/kafka-util && mvn clean install -Dgeco.kafka.util.version=$geco_kafka_util_version -Dgeco.september.util.version=$geco_septemberutil_version

WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-cepheus.git
WORKDIR giles-eco-cepheus/cepheus
RUN mvn clean package -Dcepheus.baseDir=/usr/local/tomcat/cepehus-work -Dcepheus.tmp.folder=tmp -Dlog.level=info -Dcepheus.kafka.hosts=$kafka_host -Dcepheus.base.url=$cepheus_url -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version -Dgeco.september.util.version=$geco_septemberutil_version -Dgeco.kafka-util.version=$geco_kafka_util_version

# deploy Cepheus
RUN cp ./target/cepheus.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cepehus-work
WORKDIR cepehus-work
RUN mkdir tmp
