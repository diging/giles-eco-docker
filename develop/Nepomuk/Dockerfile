FROM tomcat:8.5-jdk8-openjdk

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG nepomuk_url=http://nepomuk:8080/nepomuk/
ARG request_version=v0.7
ARG util_version=v0.4.3
ARG geco.septemberutil.version=v0.2
ARG geco.kafka.util.version=v0.1
RUN mkdir gitrepos
WORKDIR gitrepos

# install requests
RUN git clone https://github.com/diging/giles-eco-requests.git && cd giles-eco-requests && git checkout master && git pull  && git checkout v0.7 && cd giles-eco-requests && mvn clean install -Dgeco.requests.version=$request_version

# install util
RUN git clone https://github.com/diging/giles-eco-util.git && cd giles-eco-util && git checkout master && git pull && git checkout v0.4.3 && cd util && mvn clean install -P no-gpg -Dgeco.util.version=$util_version

# install september-util
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util/september-util && mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version

# install kafka-util
RUN git clone https://github.com/diging/giles-eco-kafka-util.git && cd giles-eco-kafka-util/kafka-util && git checkout master && git pull && git checkout v0.1 && mvn clean install -Dgeco.kafka.util.version=$geco.kafka.util.version -Dgeco.september.util.version=$geco.septemberutil.version

RUN git clone https://github.com/diging/giles-eco-nepomuk.git
WORKDIR giles-eco-nepomuk/nepomuk
RUN mvn clean package -Dnepomuk.db.files=/data/dbs/nepomuk/ -Dnepomuk.digilibBaseDir=/data -Dnepomuk.images.folder=imgs -Dnepomuk.baseDir=/data/ -Dnepomuk.texts.folder=texts -Dnepomuk.pdfs.folder=pdfs -Dnepomuk.otherFiles.folder=other -Dlog.level=info -Dnepomuk.kafka.hosts=$kafka_host -Dnepomuk.base.url=$nepomuk_url -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version -Dzookeeper.host=zookeeper -Ddb.database.url=jdbc:mysql://mysql:3306/nepomuk -Ddb.user=nepomuk -Ddb.password=NepomukPassword -Dgeco.september.util.version=$geco.septemberutil.version -Dgeco.kafka-util.version=$geco.kafka.util.version

# deploy Nepomuk
RUN cp ./target/nepomuk.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir persist
WORKDIR persist
RUN mkdir db
