#!/bin/bash
#
# Change these values according to your needs:
#
DOMAIN=`cat /vagrant/etc/domain`
MAGENTO_VERSION=magento-ce-1.9.2.1

# always run this script as vagrant user
if [ "$USER" != "vagrant" ]; then
	sudo -u vagrant -H sh -c "sh $0"
	exit
fi


# if we can't find an agent, start one, and restart the script.
if [ -z "$SSH_AUTH_SOCK" ] ; then
  exec ssh-agent bash -c "ssh-add ~/.ssh/*_id_rsa; $0 $*"
  exit
fi

mkdir /home/vagrant/www

# Install dependencies from composer.
# Extensions from Composer will be deployed after Magento has been installed
# --no-scripts prevents modman deploy
cd /vagrant
composer install --prefer-dist --no-interaction --no-scripts

# Since composer installs Magento into /vagrant/www we need to sync it once to the box
cp -r /vagrant/www /home/vagrant/

cd /home/vagrant
# link project modman packages (src/modman imports others)
modman link ./src
modman deploy src --force

# Use n98-magerun to set up Magento (database and local.xml)
# uses --noDownload because Magento core is deployed with composer.
# Remove the line if there already is a configured Magento installation
n98-magerun install --noDownload --dbHost="localhost" --dbUser="magento" --dbPass="root" --dbName="magento" --installSampleData=no --useDefaultConfigParams=yes --magentoVersionByName="$MAGENTO_VERSION" --installationFolder="www" --baseUrl="http://$DOMAIN/" --forceUseDb="magento"

# Now after Magento has been installed, deploy all additional modules and run setup scripts
modman deploy-all --force
n98-magerun sys:setup:run

# Set up PHPUnit
cd /home/vagrant/www/shell
mysqladmin -uroot -proot create magento_unit_tests
php ecomdev-phpunit.php -a install
php ecomdev-phpunit.php -a magento-config --db-name magento_unit_tests --db-user root --base-url http://$DOMAIN/

# Link local.xml from /etc, this overwrites the generated local.xml
# from the install script. If it does not exist, the generated file gets copied to /etc first
# This way you can put the devbox local.xml under version control
if [ ! -f "/vagrant/etc/local.xml" ]; then
	cp /home/vagrant/www/app/etc/local.xml /vagrant/etc/local.xml
fi
if [ ! -f "/vagrant/etc/local.xml.phpunit" ]; then
	cp /home/vagrant/www/app/etc/local.xml.phpunit /vagrant/etc/local.xml.phpunit
fi
ln -fs /vagrant/etc/local.xml /home/vagrant/www/app/etc/local.xml
ln -fs /vagrant/etc/local.xml.phpunit /home/vagrant/www/app/etc/local.xml.phpunit
