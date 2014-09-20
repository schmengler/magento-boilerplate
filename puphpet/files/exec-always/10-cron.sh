#!/bin/sh
chmod +x /var/www/`cat /vagrant/etc/domain`/cron.sh
cat /vagrant/etc/crontab | sed s/{DOMAIN}/`cat /vagrant/etc/domain`/ | crontab -u vagrant -