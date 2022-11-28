ARG DISPATCHER_MODULE_URL=https://download.macromedia.com/dispatcher/download/dispatcher-apache2.4-linux-x86_64-4.3.5.tar.gz
FROM almalinux:latest
ARG DISPATCHER_MODULE_URL

RUN yum -y update
RUN yum -y install httpd && \
    yum clean all && \
    mv $(curl --insecure --silent ${DISPATCHER_MODULE_URL} | tar xzvf - --wildcards "*.so" | head -1) /etc/httpd/modules/mod_dispatcher.so && \
    chown root:root /etc/httpd/modules/mod_dispatcher.so

EXPOSE 80

RUN mkdir -p /mnt/var/www/author && \
    mkdir -p /mnt/var/www/html && \
    mkdir -p /mnt/var/www/default && \
    chown -R apache:apache /mnt/var/www

WORKDIR /etc/httpd
CMD [ "apachectl", \
      "-DFOREGROUND" ]