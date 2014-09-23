#!/bin/sh
find /home/vagrant/www -type d -exec chmod 775 {} \;
find /home/vagrant/www -type f -exec chmod 664 {} \;
