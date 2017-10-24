# docker-privacyidea
[privacyIDEA](https://privacyidea.org/) is a Two Factor Authentication System which is multi-tenency- and multi-instance-capable. In this docker image based on phusion privacyIDEA is provided.

## Usage

```
docker run -d -p 8089:8078 --name privacyidea --link mysql:db -v /privacyidea/etc:/etc/privacyidea:rw -v /privacyidea/log:/var/log/privacyidea:rw -v /privacyidea/lib:/var/lib/privacyidea:rw -e GROUP_ID=999 -e PORT=8078 --restart always dtjs48jkt/privacyidea
```

After starting the docker container go to:

https://server or https://server:port if you have defined an alternative port

## Update Functionality
This docker image is based on Ubuntu. On each start of the container an update of the used Ubuntu packages is performed. Due to the running update it might take a little longer until the application webtrees is available. 

## Persistent storage of data
Configuration files should be stored outside the container. Therefor you should create directories that are mapped to the container internal directories as described under Parameters.
In the container apache is running under user www-data [33] (group www-data[33]). Both directories must therfore be read- and writable for this user. If this is not possible you can use the alternative and use the parameter GROUP_ID to inform the container about the group that has read and write access to those folders.

## Database
The image does not contain a MySQL database. You could use the --link parameter to drectly connect to a database (e.g. [MySQL Docker Image](https://store.docker.com/images/mysql)).

## Logging
Log data of the contained web-server is written in the files in the folder /var/log/apache2/. If access to those files is necessary this location could be mapped to an external volume. Logs of privacyIDEA app is written to /var/log/privacyidea.

## Port of Apache web server / Encryption
This image only supports https based communication. Per default the Apache web server listens on port 443.
If it is necessary to change the default port (e.g. in case of collisions) you can set the optional parameter PORT to a different value.
The https communication is based on a self signed certificate. It is possible to use an alternative certificate. Therfore you have to map the internal folder /crt to an external location. This folder should contain the two files privacyidea.key (Key without password protection) und privacyidea.crt (certificate). It is not possible to change further encryption settings from outside the container.
If you want a more sofisticated encryption you should use a reverse proxy in front of the privacyIDEA container.

## Parameters
* `-v /etc/privacyidea` - Where privacyIDEA server stores its config files (pi.cfg, enckey, private.pem, public.pem)
* `-v /var/lib/privacyIDEA` - Enhancements for privacyIDEA. See privacyIDEA documentation for more details.
* `-v /var/log/privacyIDEA` - Log files of privacyIDEA application.
* `-v /var/log/apache2` - Log files of apache2 server.
* `-e GROUP_ID` - allow access to mapped volumes
* `-e PORT` - change port web server listens on

## Versions

+ **24.10.2017:** Initial release.
