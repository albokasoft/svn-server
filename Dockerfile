FROM debian:jessie
MAINTAINER Albokasoft

ENV LANG C.UTF-8

RUN apt-get update
RUN apt-get install -y nano sudo git subversion php5 apache2 libapache2-svn apache2-mpm-prefork
RUN apt-get clean

#add subversion user

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2enmod dav_svn
RUN /usr/sbin/a2enmod auth_digest

RUN mkdir /etc/apache2/dav_svn
RUN mkdir /var/local/svn

ADD ./svn.sudoers /etc/sudoers.d/svn
ADD files/dav_svn.conf /etc/apache2/mods-available/dav_svn.conf
ADD files/svn-entrypoint.sh /usr/local/bin/
ADD files/iF.SVNAdmin-stable-1.6.2 /var/www/svnadmin

RUN chmod a+x /usr/local/bin/svn*

VOLUME [ "/var/local/svn" ]

EXPOSE 80
EXPOSE 443

RUN sed -i 's/# exec CMD/&\nsvn-entrypoint.sh/g' /opt/entrypoint.sh

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
