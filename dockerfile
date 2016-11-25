FROM  debian:jessie

MAINTAINER Elsayed Awdallah <comando4ever@gmail.com>

# install apache
RUN apt-get update && apt-get -y install apache2

# install phpbrew requirements.
RUN apt-get install -y php5 php5-dev php-pear autoconf automake curl libcurl3-openssl-dev build-essential libxslt1-dev re2c libxml2 libxml2-dev php5-cli bison libbz2-dev libreadline-dev
RUN apt-get install -y libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg62-turbo-dev libjpeg62-turbo  libgd-dev libgd3 libxpm4 libltdl7 libltdl-dev
RUN apt-get install -y libssl-dev openssl
RUN apt-get install -y gettext libgettextpo-dev libgettextpo0
RUN apt-get install -y libicu-dev
RUN apt-get install -y libmhash-dev libmhash2
RUN apt-get install -y libmcrypt-dev libmcrypt4

RUN apt-get install -y apache2-dev

RUN export DEBIAN_FRONTEND=noninteractive

# config mysql
RUN echo mysql-server-5.5 mysql-server/root_password password 1234 | debconf-set-selections
RUN echo mysql-server-5.5 mysql-server/root_password_again password 1234 | debconf-set-selections

# install mysql
RUN apt-get install -y mysql-server mysql-client libmysqlclient-dev libmysqld-dev

# install phpbrew
RUN curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
RUN chmod +x phpbrew
RUN mv phpbrew /usr/bin/phpbrew

RUN phpbrew init

RUN echo "[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc" >> ~/.bashrc
RUN phpbrew update --old
RUN phpbrew install --old 5.3.29 +default+mysql+apxs2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2enmod php5
RUN /usr/sbin/a2enmod rewrite
RUN /usr/sbin/a2dismod 'mpm_*' && /usr/sbin/a2enmod mpm_prefork

RUN export PHPBREW_PHP=php-5.3.29 && phpbrew ext install gd

# enable modrewrite in .htacssess files.
RUN sed -in 's/AllowOverride None/AllowOverride all/i' /etc/apache2/apache2.conf

# restart apache server in case it was already started.
RUN service apache2 restart

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
