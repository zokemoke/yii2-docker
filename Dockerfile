#FROM 1and1internet/ubuntu-16-apache
FROM 1and1internet/ubuntu-16-apache-php-7.2
MAINTAINER kawin@damasac.com
#ARG DEBIAN_FRONTEND=noninteractive
#ARG PHP_VERSION=7.2

RUN apt-get update \ 
  && cd /usr/lib/apt/methods \
  && ln -s http https
RUN apt-get install -y --no-install-recommends apt-transport-https ca-certificates
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql \
  && ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools \
  && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
  && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
  && source ~/.bashrc
RUN apt-get install -y --no-install-recommends unixodbc-dev

RUN a2enmod rewrite
COPY config/php.ini /usr/local/etc/php/
