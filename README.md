# giles-eco-docker

This repository holds Docker files for the Giles Ecosystem.

## Set Up
To start up the Gile Ecosystem, do the following:

1. Install docker and docker-compose.
1. Clone this repository.
1. Go to the giles-eco-docker directory.
1. Go into either the `develop` or `latest_tag` folder. Starting Docker from the folder `develop` will pull the latest code from the develop branch of each component. This might result in an unstable version of the Giles Ecosystem. Starting Docker from the folder `latest_tag` will build the latest release version of each component. It is recommended to use the `latest_tag` folder.
1. Create a folder called `data` with the following folders inside called: `imgs`, `others`, `pdfs`, `texts`, `mysql`, `dbs`. Inside the `dbs` folder create two more folders: `giles` and `nepomuk`. The data folder will store all uploaded and extracted files. The `mysql` folder will contain your database files. If you use a version earlier than v0.5 for Giles or v0.6 for Nepomuk, the folder `db` will contain the database files.
1. Run `docker-compose up`.

Note: if you have installed the Giles Ecosystem docker containers previously for an older release, make sure to remove all containers and images before installing it again. Otherwise you might end up running the older release or with a combination of non-compatible component versions.

This will start the Giles Ecosystem docker environment. There will be 7 docker container running: Giles, Nepomuk, Cepheus, Cassiopeia (the Giles Ecosystem suite), Digilib (to serve up images, no exposed ports), Apache Kafka and Zookeeper.

The following ports will be exposed:
* `8080`: your Giles instance; the webapp is running at `http://locahost:8080/giles`
* `8081`: your Nepomuk instance; the webapp is running at `http://locahost:8081/nepomuk`
* `8082`: your Cepheus instance; the webapp is running at `http://locahost:8082/cepheus`
* `8083`: your Cassiopeia instance; the webapp is running at `http://locahost:8083/cassiopeia`
* `8084`: your Andromeda instance; the webapp is running at `http://localhost:8084/andromeda`

## Configuration
1. Once up and running, go to Giles and login as admin (bottom of the page) with admin/admin.
1. Under "System" go to "Social SigIn" and provide client ids and secret for the sign in provider you want to use. In GitHub, for instance, go to your settings and register a new OAuth application.
1. Under "System" go to "Authentication". Generate new signing secrets.
1. Go to "Apps" in the main menu. Create a new token for Nepomuk by clicking on "Register Apps". You can leave the "Identity Provider" and (empty) "Provider Client ID" fields as they are.
  * Login to Nepomuk as admin/admin (see list above for port numbers).
  * Go to "System Config", and copy/paste the token that Giles generated.

## User Accounts

You should now be able to sign in to Giles using your selected sign in provider. After the first time, you've signed in, log out again. Then sign in as admin and approve your user account under "Users" (the thumbs-up button at the end of a user row). You can make a user admin by clicking the key icon.

## Note
If `docker-compose up` fails with an error message such as `Could not transfer artifact org.apache.maven:maven-archiver:pom:2.6 from/to central (https://repo.maven.apache.org/maven2): Connection reset -> [Help 1]`, this might simply be a connection issue and rerunning `docker-compose up` could fix it.

