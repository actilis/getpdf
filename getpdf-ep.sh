#!/bin/bash

chgrp -R apache    /var/www/html \
   && chown -R apache    /var/www/html/logs /var/www/html/docs \
   && rm -f /var/www/html/index.*

echo "$@"
exec /httpd-entrypoint.sh "$@"
