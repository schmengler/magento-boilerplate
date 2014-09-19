#!/bin/sh
#
# Change these values according to your needs:
#
DOMAIN=magento.local
MAGENTO_VERSION=magento-ce-1.9.0.1

# always run this script as vagrant user
if [ "$USER" != "vagrant" ]; then
	sudo -u vagrant -H sh -c "sh $0"
	exit
fi


mkdir /home/vagrant/www

# Install dependencies from composer.
# Extensions from Composer will be deployed after Magento has been installed
# --no-scripts prevents modman deploy
# in the default composer.json /usr/local/bin is specified as bin directory, so it has to be writable
chmod 0777 /usr/local/bin
cd /vagrant
composer install --dev --prefer-dist --no-interaction --no-scripts

cd /home/vagrant
# link project modman packages (src/modman imports others)
modman link ./src
modman deploy src --force

# Use n98-magerun to set up Magento (database and local.xml)
# use --noDownload if Magento core is deployed with modman or composer.
# Remove the line if there already is a configured Magento installation
n98-magerun install --dbHost="localhost" --dbUser="magento" --dbPass="root" --dbName="magento" --installSampleData=no --useDefaultConfigParams=yes --magentoVersionByName="$MAGENTO_VERSION" --installationFolder="www" --baseUrl="http://$DOMAIN/"

# Now after Magento has been installed, deploy all additional modules and run setup scripts
modman deploy-all --force
n98-magerun sys:setup:run

# Set up PHPUnit
cd /home/vagrant/www/shell
mysqladmin -uroot -proot create magento_unit_tests
php ecomdev-phpunit.php -a magento-config --db-name magento_unit_tests --base-url http://$DOMAIN/

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