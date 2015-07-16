FROM base/archlinux
MAINTAINER thermionix

RUN		pacman -Sy --noconfirm
RUN		pacman-key --refresh-keys
RUN		pacman -S --needed supervisor git mariadb nginx php-fpm php-gd cronie --noconfirm
RUN		pacman -Scc --noconfirm

RUN		sed -i 's,;extension=pdo_mysql.so,extension=pdo_mysql.so,g' /etc/php/php.ini
RUN 	sed -i 's,;extension=mysql.so,extension=mysql.so,g' /etc/php/php.ini
RUN		sed -i 's,;extension=gd.so,extension=gd.so,g' /etc/php/php.ini
RUN		sed -i 's,;extension=zip.so,extension=zip.so,g' /etc/php/php.ini
RUN		sed -i 's,;extension=openssl.so,extension=openssl.so,g' /etc/php/php.ini
RUN		sed -i "s,;date.timezone =.*,date.timezone = Australia/Melbourne,g" /etc/php/php.ini
RUN		sed -i "s,memory_limit = 128M,memory_limit = 512M,g" /etc/php/php.ini

RUN		git clone https://github.com/spotweb/spotweb.git /srv/http/spotweb
RUN		mkdir /srv/http/spotweb/cache
RUN		chmod 777 /srv/http/spotweb/cache
RUN		chown -R http:http /srv/http

ADD		./create-mysql-structure.sh /opt/create-mysql-structure.sh
RUN		chmod +x /opt/create-mysql-structure.sh

ADD		nginx.conf /etc/nginx/nginx.conf
ADD		spotweb.conf /etc/nginx/sites-enabled/spotweb.conf

RUN 	echo '0 */4 * * * cd /srv/http/spotweb && /usr/bin/php retrieve.php > /dev/null' > /etc/cron.d/spotweb

ADD 	mariadb.ini /etc/supervisor.d/mariadb.ini
ADD 	nginx.ini /etc/supervisor.d/nginx.ini
ADD 	php-fpm.ini /etc/supervisor.d/php-fpm.ini
ADD		cron.ini /etc/supervisor.d/cron.ini

VOLUME ["/var/lib/mysql"]

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
