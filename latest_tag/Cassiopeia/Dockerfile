FROM tomcat:8.5-jdk8-openjdk

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
RUN apt-get install -y tesseract-ocr
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG cassiopeia_url=http://cassiopeia:8080/cassiopeia/
ARG request_version=v0.2.1-SNAPSHOT
ARG util_version=v0.4.2-SNAPSHOT
ARG geco.septemberutil.version=v0.2

RUN mkdir gitrepos
WORKDIR gitrepos

# install requests
RUN git clone https://github.com/diging/giles-eco-requests.git && cd giles-eco-requests && git checkout master && git pull  && git checkout v0.7 && cd giles-eco-requests && mvn clean install -Dgeco.requests.version=$request_version

# install util
RUN git clone https://github.com/diging/giles-eco-util.git && cd giles-eco-util && git checkout master && git pull && git checkout v0.4.3 && cd util && mvn clean install -Dgeco.util.version=$util_version

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util && git checkout master && git pull && latesttag=$(git describe --tags) && git checkout ${latesttag} && cd september-util && mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version

WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-cassiopeia.git && cd giles-eco-cassiopeia && git checkout master && git pull && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-cassiopeia/cassiopeia
RUN mvn clean package -Dcassiopeia.baseDir=/usr/local/tomcat/cassiopeia-work -Dcassiopeia.tmp.folder=tmp -Dlog.level=info -Dkafka.hosts=$kafka_host -Dcassiopeia.base.url=$cassiopeia_url -Dtesseract.bin=/usr/bin/ -Dtesseract.data=/usr/share/tesseract-ocr/ -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version -Dgeco.september.util.version=$geco.septemberutil.version

# deploy Cassiopeia
RUN cp ./target/cassiopeia.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir cassiopeia-work
WORKDIR cassiopeia-work
RUN mkdir tmp
