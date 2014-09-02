#!/bin/sh

# Set up default Git configuration for "The Installer"
git config --global jbh-installer.license "proprietary"
git config --global jbh-installer.company-name "SGH informationstechnologie UG mbH"
git config --global jbh-installer.company-name-short "SGH"               
git config --global jbh-installer.company-url "http://www.sgh-it.eu/"    

# Directories
cd ~
mkdir www

# Set up modman and install dependencies from composer.
# Extensions from Composer will be deployed after Magento has been installed
cd /vagrant
modman init www
composer install --dev --prefer-dist --no-interaction --no-scripts
cd ~

# link project modman packages (src/modman imports others)
modman link ./src
modman deploy src --force

# Use n98-magerun to set up Magento (database and local.xml)
# CHANGE BASE URL AND MAGENTO VERSION HERE:
# use --noDownload if Magento core is deployed with modman
n98-magerun install --dbHost="localhost" --dbUser="root" --dbPass="" --dbName="magento" --installSampleData=yes --useDefaultConfigParams=yes --magentoVersionByName="magento-ce-1.8.1.0" --installationFolder="www" --baseUrl="http://magento.local/"

# link local.xml, this overwrites the generated local.xml from the install script
# Uncomment if you deployed a file app/etc/local.xml.devbox
#ln -fs local.xml.devbox ~/www/app/etc/local.xml 

# Now after Magento has been installed, deploy all additional modules and run setup scripts
modman deploy-all --force
n98-magerun sys:setup:run

# Set up PHPUnit
cd www/shell
mysqladmin -uroot create magento_unit_tests
php ecomdev-phpunit.php -a magento-config --db-name magento_unit_tests --base-url http://magento.local/

# Some devbox specific Magento settings
n98-magerun admin:user:create fschmengler fschmengler@sgh-it.eu test123 Fabian Schmengler
n98-magerun config:set dev/log/active 1