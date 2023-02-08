FROM tomcat:9.0-jdk11-temurin-focal

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git
RUN apt-get install -y tesseract-ocr
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG cassiopeia_url=http://cassiopeia:8080/cassiopeia/
ARG request_version=0.13
ARG util_version=0.6
ARG kafka_util_version=0.2
ARG geco.septemberutil.version=v0.2

RUN mkdir gitrepos
WORKDIR gitrepos

# install requests
# RUN git clone https://github.com/diging/giles-eco-requests.git && cd giles-eco-requests && git checkout develop && git pull  && cd giles-eco-requests && mvn clean install -Dgeco.requests.version=$request_version

# install util
# RUN git clone https://github.com/diging/giles-eco-util.git && cd giles-eco-util && git checkout develop && git pull && cd util && mvn clean install -Dgeco.util.version=$util_version

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util/september-util && mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version

# install kafka-util
# RUN git clone https://github.com/diging/giles-eco-kafka-util.git && cd giles-eco-kafka-util/kafka-util && git checkout master && git pull && git checkout v0.1 && mvn clean install -Dgeco.kafka.util.version=$geco.kafka.util.version -Dgeco.september.util.version=$geco.septemberutil.version

WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-cassiopeia.git
WORKDIR giles-eco-cassiopeia/cassiopeia
RUN mvn clean package -Dcassiopeia.baseDir=/usr/local/tomcat/cassiopeia-work -Dcassiopeia.tmp.folder=tmp -Dlog.level=info -Dkafka.hosts=$kafka_host -Dcassiopeia.base.url=$cassiopeia_url -Dtesseract.bin=/usr/bin/ -Dtesseract.data=/usr/share/tesseract-ocr/ -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version -Dgeco.september.util.version=$geco.septemberutil.version -Dgeco.kafka-util.version=$geco.kafka.util.version -Dzookeeper.host=zookeeper -Dgeco.kafka-util.version=$kafka_util_version

# deploy Cassiopeia
RUN cp ./target/cassiopeia.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cassiopeia-work
WORKDIR cassiopeia-work
RUN mkdir tmp
