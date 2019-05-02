#FROM 1and1internet/ubuntu-16-apache
FROM 1and1internet/ubuntu-16-apache-php-7.2
MAINTAINER kawin@damasac.com
#ARG DEBIAN_FRONTEND=noninteractive
#ARG PHP_VERSION=7.2

RUN apt-get update \ 
  && cd /usr/lib/apt/methods \
  && ln -s http https
RUN apt-get install -y --no-install-recommends apt-transport-https ca-certificates

RUN su \
	&& curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
	&& curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
	&& exit
RUN apt-get update \
	&& ACCEPT_EULA=Y apt-get -y install msodbcsql17 \
	&& ACCEPT_EULA=Y apt-get -y install unixodbc-dev mssql-tools \
	&& apt-get -y install php-pear php7.2-dev \
	&& pecl install sqlsrv \
	&& pecl install pdo_sqlsrv
RUN su \
	&& echo "extension=sqlsrv.so" > /etc/php/7.2/mods-available/sqlsrv.ini \
	&& echo "extension=pdo_sqlsrv.so" > /etc/php/7.2/mods-available/pdo_sqlsrv.ini \
	&& exit
RUN ln -s /etc/php/7.2/mods-available/sqlsrv.ini /etc/php/7.2/cli/conf.d/20-sqlsrv.ini \
	&& ln -s /etc/php/7.2/mods-available/pdo_sqlsrv.ini /etc/php/7.2/cli/conf.d/20-pdo_sqlsrv.ini \
	&& ln -s /etc/php/7.2/mods-available/sqlsrv.ini /etc/php/7.2/apache2/conf.d/20-sqlsrv.ini \
	&& ln -s /etc/php/7.2/mods-available/pdo_sqlsrv.ini /etc/php/7.2/apache2/conf.d/20-pdo_sqlsrv.ini
RUN dpkg -l cron \
	&& apt-get install cron
RUN a2enmod rewrite
COPY config/php.ini /usr/local/etc/php/
CMD php yii queue/listen &
