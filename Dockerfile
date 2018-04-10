FROM actilis/httpd-php

MAINTAINER Francois MICAUX <dok-getpdf@actilis.net>

LABEL Vendor="Actilis" \
      License=GPLv3 \
      Version=18.4

RUN yum -y --setopt=tsflags=nodocs install libXrender libXext  fontconfig libfontenc libXfont urw-fonts xz \
 && curl -Ls https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
  | tar -C /usr/local --strip-components 1 -xJ   \
 && chown -R root.root /usr/local/{lib,include,share,bin}  \
 && yum clean all && rm -rf /var/cache/yum 

USER root
COPY conf.d /etc/httpd/conf.d/00-site.conf
COPY site /var/www/html

RUN chgrp -R apache    /var/www/html \
 && chown -R apache    /var/www/html/{logs,docs} 

