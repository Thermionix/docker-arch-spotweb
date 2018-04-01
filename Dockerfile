FROM base/archlinux
MAINTAINER thermionix

RUN		pacman -Sy --noconfirm
RUN		pacman -S --needed supervisor git mariadb nginx php-fpm php-gd fcron --noconfirm
RUN		pacman -Scc --noconfirm

RUN		sed -i 's,;extension=pdo_mysql,extension=pdo_mysql,g' /etc/php/php.ini
RUN 	sed -i 's,;extension=mysql,extension=mysql,g' /etc/php/php.ini
RUN 	sed -i 's,;extension=gettext,extension=gettext,g' /etc/php/php.ini
RUN		sed -i 's,;extension=gd,extension=gd,g' /etc/php/php.ini
RUN		sed -i 's,;extension=zip,extension=zip,g' /etc/php/php.ini
RUN		sed -i 's,;extension=openssl.so,extension=openssl.so,g' /etc/php/php.ini
RUN		sed -i "s,;date.timezone =.*,date.timezone = Australia/Brisbane,g" /etc/php/php.ini
RUN		sed -i "s,memory_limit = 128M,memory_limit = 512M,g" /etc/php/php.ini

RUN		git clone https://github.com/spotweb/spotweb.git /srv/http/spotweb
RUN		mkdir /srv/http/spotweb/cache
RUN		chmod 777 /srv/http/spotweb/cache

ADD		dbsettings.inc.php /srv/http/spotweb/dbsettings.inc.php
RUN		chown -R http:http /srv/http

ADD		./create-mysql-structure.sh /opt/create-mysql-structure.sh
RUN		chmod +x /opt/create-mysql-structure.sh

ADD		nginx.conf /etc/nginx/nginx.conf
ADD		spotweb.conf /etc/nginx/sites-enabled/spotweb.conf

RUN		echo -e '!stdout(true)\n0 */2 * * * cd /srv/http/spotweb && /usr/bin/php retrieve.php' | fcrontab -

ADD 	mariadb.ini /etc/supervisor.d/mariadb.ini
ADD 	nginx.ini /etc/supervisor.d/nginx.ini
ADD 	php-fpm.ini /etc/supervisor.d/php-fpm.ini
ADD		cron.ini /etc/supervisor.d/cron.ini

VOLUME ["/var/lib/mysql"]

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
