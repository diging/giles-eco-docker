FROM tomcat:8.5-jdk8-openjdk

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven
RUN apt-get install -y git-all
#RUN apt-get install -y mysql-server
RUN apt-get install -y subversion

ARG kafka_host=kafka:9092
ARG giles_url=http://giles:8080/giles/
ARG request_version=0.6
ARG util_version=0.4.2
ARG kafka_util_version=v0.1
ARG geco.septemberutil.version=v0.2

RUN mkdir gitrepos
WORKDIR gitrepos

# install requests
RUN git clone https://github.com/diging/giles-eco-requests.git && cd giles-eco-requests && git checkout master && git pull  && git checkout v0.7 && cd giles-eco-requests && mvn clean install -Dgeco.requests.version=$request_version

# install util
RUN git clone https://github.com/diging/giles-eco-util.git && cd giles-eco-util && git checkout master && git pull && git checkout v0.4.3 && cd util && mvn clean install -Dgeco.util.version=$util_version

# install september-util
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-september-util.git && cd giles-eco-september-util && git checkout master && git pull && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-september-util/september-util
RUN mvn clean install -Dgeco.septemberutil.version=$geco.septemberutil.version -Dgeco.requests.version=$request_version -Dgeco.util.version=$util_version

# install kafka util
RUN git clone https://github.com/diging/giles-eco-kafka-util.git && cd giles-eco-kafka-util && git checkout master && git pull && git checkout v0.1 && cd kafka-util && mvn clean install -Dgeco.kafka.util.version=$kafka_util_version -Dgeco.september.util.version=$geco.septemberutil.version

# install spring social
WORKDIR ../..
RUN git clone https://github.com/jdamerow/spring-social-github.git
WORKDIR spring-social-github
RUN ./gradlew publishToMavenLocal

# install mitreid
WORKDIR ../..
RUN git clone https://github.com/jdamerow/spring-social-mitreid-connect.git
WORKDIR spring-social-mitreid-connect/mitreid-connect
RUN mvn clean install

# build giles
WORKDIR ../..
RUN git clone https://github.com/diging/giles-eco-giles-web.git && cd giles-eco-giles-web && git checkout master && git pull  && latesttag=$(git describe --tags) && git checkout ${latesttag}
WORKDIR giles-eco-giles-web/giles-eco
RUN mvn clean package -P prod -Dgeco.giles.db_files=/data/dbs/giles/ -Dlog.level=info -Dgiles.kafka.hosts=$kafka_host -Dgiles.base.url=$giles_url -Dmitreid.show.login=false -Ddb.database.url=jdbc:mysql://mysql:3306/giles -Ddb.user=giles -Ddb.password=GilesPassword -Dgiles.file.tmp.dir=/usr/local/tomcat/giles-work/tmp -Ddigilib.url=http://digilib:8080/digilib/servlet/Scaler/ -Dgeco.requests.version=$request_version -Dzookeeper.host=zookeeper -Demail.enabled=false -Dgeco.util.version=$util_version -Dgeco.september.util.version=$geco.septemberutil.version -Dgeco.kafka-util.version=$kafka_util_version

# deploy Giles
RUN cp ./target/giles.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat/
RUN mkdir giles-work
WORKDIR giles-work
RUN mkdir tmp

COPY scripts/startup /tmp/
RUN chmod 755 /tmp/startup

CMD /tmp/startup
