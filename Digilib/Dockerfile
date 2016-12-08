FROM tomcat:8.0

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven

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

RUN mkdir download
WORKDIR download

# download and unpack digilib
RUN curl -O -L https://sourceforge.net/projects/digilib/files/releases/2.3/digilib-webapp-2.3.8-srv3.war && mkdir digilib && mv digilib-webapp-2.3.8-srv3.war digilib/ && cd digilib && jar xf digilib-webapp-2.3.8-srv3.war
COPY config/digilib-config.xml ./digilib/WEB-INF/

# deploy digilib
RUN cp -r ./digilib /usr/local/tomcat/webapps/
