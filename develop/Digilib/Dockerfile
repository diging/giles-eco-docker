FROM tomcat:8.5-jdk8-openjdk

MAINTAINER Julia Damerow https://github.com/jdamerow

# run installs in noninteractive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y maven

RUN mkdir download
WORKDIR download

# download and unpack digilib
RUN curl -O -L https://sourceforge.net/projects/digilib/files/releases/2.3/digilib-webapp-2.3.8-srv3.war && mkdir digilib && mv digilib-webapp-2.3.8-srv3.war digilib/ && cd digilib && jar xf digilib-webapp-2.3.8-srv3.war
COPY config/digilib-config.xml ./digilib/WEB-INF/

# deploy digilib
RUN cp -r ./digilib /usr/local/tomcat/webapps/
