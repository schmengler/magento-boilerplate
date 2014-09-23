#!/bin/sh
chmod 0600 /home/vagrant/.ssh/*
chown -R www-data:www-data /var/www/`cat /vagrant/etc/domain`/