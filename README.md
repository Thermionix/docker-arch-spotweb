# docker-arch-spotweb

Dockerfile to build and run spotweb, image uses arch as a base

## Building the container yourself
To build this container, clone the repository and cd into it.

### Build it:
```
$ cd /repo/location/docker-arch-spotweb
$ docker build -t="spotweb" .
```

```
# Created the database structure, with a volume attached:
$ docker run -v </your/storage/path/spotweb-db>:/var/lib/mysql -v /etc/localtime:/etc/localtime:ro spotweb /opt/create-mysql-structure.sh
# Run in foreground:
$ docker run -v </your/storage/path/spotweb-db>:/var/lib/mysql -v /etc/localtime:/etc/localtime:ro -p 8091:80 spotweb

# Complete the install wizard at: http://your.host.ip.addr:8091/spotweb/install.php

# Once the wizard is complete, Commit the container id to the image
$ docker commit -m "dbsettings.inc.php" `docker ps -l -q -f IMAGE=spotweb` spotweb
```

You can now use your image
```
docker run -d -v </your/storage/path/spotweb-db>:/var/lib/mysql -v /etc/localtime:/etc/localtime:ro -p 8091:80 spotweb
```


You can update spotweb;
```
docker exec `docker ps -q -f IMAGE=spotweb` bash -c "cd /srv/http/spotweb && git pull && /usr/bin/php upgrade-db.php"
docker commit `docker ps -q -f IMAGE=spotweb` spotweb
```
