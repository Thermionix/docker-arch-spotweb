#!/bin/sh


/usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

su - mysql -s /bin/bash -c '/usr/bin/mysqld --pid-file=/run/mysqld/mysqld.pid --bind-address=127.0.0.1 --skip-name-resolve --datadir=/var/lib/mysql' &
sleep 10
mysql -uroot -e "CREATE USER spotweb@localhost IDENTIFIED BY 'spotweb'; CREATE DATABASE spotweb; GRANT ALL PRIVILEGES ON spotweb.* TO spotweb@localhost IDENTIFIED BY 'spotweb'; FLUSH PRIVILEGES; "
sleep 2
killall mysqld
sleep 5


