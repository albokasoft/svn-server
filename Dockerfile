FROM httpd:2.4
MAINTAINER Albokasoft

ENV LANG C.UTF-8

RUN apt-get update
RUN apt-get install -y nano sudo git subversion php5 libapache2-svn apache2-mpm-prefork
RUN apt-get clean

RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2enmod dav_svn
RUN /usr/sbin/a2enmod auth_digest

RUN mkdir /etc/apache2/dav_svn
RUN mkdir /var/local/svn

ADD files/svn.sudoers /etc/sudoers.d/svn
ADD files/dav_svn.conf /etc/apache2/mods-available/dav_svn.conf
ADD files/svn-entrypoint.sh /usr/local/bin/
ADD files/svn-entrypoint.sh /opt/entrypoint.sh
ADD files/iF.SVNAdmin-stable-1.6.2 /var/www/svnadmin
RUN chown www-data:www-data -R /var/www/svnadmin

RUN chmod a+x /usr/local/bin/svn*

VOLUME [ "/var/local/svn" ]

#EXPOSE 80 exposed in httpd
EXPOSE 443

RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
