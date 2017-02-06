# giles-eco-docker

This repository holds Docker files for the Giles Ecosystem.

## Set Up
To start up the Gile Ecosystem, do the following:

1. Install docker and docker-compose.
1. Clone this repository.
1. Go to the giles-eco-docker directory.
1. Go into either the `develop` or `latest_tag` folder. Starting Docker from the folder `develop` will pull the latest code from the develop branch of each component. This might result in an unstable version of the Giles Ecosystem. Starting Docker from the folder `latest_tag` will build the latest release version of each component. It is recommended to use the `latest_tag` folder.
1. Create a folder called `data` with the folllowing folders inside called: `imgs`, `others`, `pdfs`, `texts`, `dbs`. Inside the `dbs` folder create two more folders: `giles` and `nepomuk`. The data folder will store all uploaded and extracted files. The dbs folder will contain the applications databases.
1. Run `docker-compose up`.

This will start the Giles Ecosystem docker environment. There will be 7 docker container running: Giles, Nepomuk, Cepheus, Cassiopeia (the Giles Ecosystem suite), Digilib (to serve up images, no exposed ports), Apache Kafka and Zookeeper.

The following ports will be exposed:
* `8080`: your Giles instance
* `8081`: your Nepomuk instance
* `8082`: your Cepheus instance
* `8083`: your Cassiopeia instance

## Configuration
1. Once up and running, go to Giles and login as admin (bottom of the page) with admin/admin.
1. Under "System" go to "Social SigIn" and provide client ids and secret for the sign in provider you want to use.
1. Under "System" go to "Authentication". Generate new signing secrets.
1. Go to "Apps". Create 3 new tokens for Nepomuk, Cepheus and Cassiopeia by clicking on "Register Apps".
  * For each application, login as admin/admin (see list above for port numbers).
  * Go to "System Config", and copy/paste the token that Giles generated.

## User Accounts

You should now be able to sign in to Giles using your selected sign in provider. After the first time, you've signed in, log out again. Then sign in as admin and approve your user account under "Users" (the thumbs-up button at the end of a user row). You can make a user admin by clicking the key icon.
