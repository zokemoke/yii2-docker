FROM 1and1internet/ubuntu-16-apache
MAINTAINER kawin@damasac.com
ARG DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION=7.2

RUN apt-get install apt-transport-https ca-certificates
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
&& curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install msodbcsql \
&& ACCEPT_EULA=Y apt-get install mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
&& echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
&& source ~/.bashrc
RUN apt-get install unixodbc-dev

RUN a2enmod rewrite
COPY config/php.ini /usr/local/etc/php/
