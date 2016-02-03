FROM centos:centos6
MAINTAINER John Casey <jdcasey@commonjava.org>

EXPOSE 80

RUN yum -y update
RUN yum -y install tar bzip2 httpd mod_wsgi lsof sudo

ADD etc/ /etc/
ADD bin/ /usr/local/bin/

RUN chmod +x /usr/local/bin/*

RUN chmod o+rx /var/log /var/log/httpd
RUN chmod o+rwx /var/www/html
RUN chmod -R o+rx /etc/httpd

ADD cgi/*.py /var/www/cgi-bin/
RUN chmod +x /var/www/cgi-bin/*.py

CMD ['/usr/bin/httpd -D FOREGROUND']
