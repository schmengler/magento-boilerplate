#!/bin/sh
chmod 0600 /home/vagrant/.ssh/*
[ -d /var/www/`cat /vagrant/etc/domain` ] && chown -R www-data:www-data /var/www/`cat /vagrant/etc/domain`/