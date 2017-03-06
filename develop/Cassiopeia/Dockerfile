FROM tomcat:8.0

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
RUN apt-get install -y tesseract-ocr

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
ARG cassiopeia_url=http://cassiopeia:8080/cassiopeia/
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
RUN git clone https://github.com/diging/giles-eco-cassiopeia.git
WORKDIR giles-eco-cassiopeia/cassiopeia
RUN mvn clean package -Dcassiopeia.baseDir=/usr/local/tomcat/cassiopeia-work -Dcassiopeia.tmp.folder=tmp -Dlog.level=info -Dkafka.hosts=$kafka_host -Dcassiopeia.base.url=$cassiopeia_url -Dtesseract.bin=/usr/bin/ -Dtesseract.data=/usr/share/tesseract-ocr/ -Dgeco.requests.version=request_version -Dgeco.util.version=util_version

# deploy Cassiopeia
RUN cp ./target/cassiopeia.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cassiopeia-work
WORKDIR cassiopeia-work
RUN mkdir tmp
