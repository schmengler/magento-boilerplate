#!/bin/sh
chmod +x /var/www/magento.local/cron.sh
cat /vagrant/etc/crontab | crontab -u vagrant -