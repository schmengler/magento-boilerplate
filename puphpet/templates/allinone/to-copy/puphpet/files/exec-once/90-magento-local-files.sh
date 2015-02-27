#!/bin/bash
#
# Change these values according to your needs:
#
DOMAIN=`cat /vagrant/etc/domain`

# always run this script as vagrant user
if [ "$USER" != "vagrant" ]; then
	sudo -u vagrant -H sh -c "sh $0"
	exit
fi

# Link local.xml from /etc, this overwrites the generated local.xml
# from the install script. If it does not exist, the generated file gets copied to /etc first
# This way you can put the devbox local.xml under version control
if [ ! -f "/vagrant/etc/local.xml" ]; then
	cp /home/vagrant/www/app/etc/local.xml /vagrant/etc/local.xml
fi
ln -fs /vagrant/etc/local.xml /home/vagrant/www/app/etc/local.xml

# Copy devbox index.php and .htaccess files from /etc into project sources
#
# You'll often have a system specific .htaccess or index.php file that is not
# part of the external repository.
# You can put the versions for your development environment in the etc directory
# to version them with the development repository (the one with the Vagrant box).
# They will automatically get copied to the source dir.
#
# TODO: copy on each provisioning? (exec-always)
#
[ -f "/vagrant/etc/index.php" ] && cp /vagrant/etc/index.php /vagrant/www/index.php
[ -f "/vagrant/etc/.htaccess" ] && cp /vagrant/etc/.htaccess /vagrant/www/.htaccess