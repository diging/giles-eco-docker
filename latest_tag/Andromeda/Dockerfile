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
ARG andromeda_url=http://andromeda:8080/andromeda/
ARG request_version=v0.2.1-SNAPSHOT
ARG util_version=v0.4.2-SNAPSHOT
ARG geco.septemberutil.version=v0.2

# install giles-eco-requests
RUN mkdir gitrepos
WORKDIR gitrepos
RUN git clone https://github.com/diging/giles-eco-requests.git && cd giles-eco-requests && git checkout master && git pull  && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-requests/giles-eco-requests
RUN mvn clean install -Dgeco.requests.version=$request_version

# install giles-eco-util
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-util.git && cd giles-eco-util && git checkout master && git pull  && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-util/util
RUN mvn clean install -Dgeco.util.version=$util_version

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util && git checkout master && git pull && latesttag=$(git describe --tags) && git checkout ${latesttag} && cd september-util && mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version

# install andromeda
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-andromeda.git && cd giles-eco-andromeda && git checkout master && git pull  && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-andromeda/andromeda
RUN mvn clean package -Dandromeda.baseDir=/usr/local/tomcat/andromeda-work -Dandromeda.tmp.folder=tmp -Dlog.level=info -Dandromeda.kafka.hosts=$kafka_host -Dandromeda.base.url=$andromeda_url -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version -Dgeco.september.util.version=$geco.septemberutil.version

# deploy Cepheus
RUN cp ./target/andromeda.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir andromeda-work
WORKDIR andromeda-work
RUN mkdir tmp
