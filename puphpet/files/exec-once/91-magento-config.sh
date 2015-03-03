#!/bin/sh

# always run this script as vagrant user
if [ "$USER" != "vagrant" ]; then
	sudo -u vagrant -H sh -c "sh $0"
	exit
fi

cd /home/vagrant

# Some devbox specific Magento settings
#
# Add disabled services, test/dev mode configurations etc. here
#
# - Developer settings
n98-magerun config:set dev/log/active 1
n98-magerun config:set dev/template/allow_symlink 1
n98-magerun config:set web/cookie/cookie_httponly 0
n98-magerun config:set dev/js/merge_files 0
n98-magerun config:set dev/css/merge_files 0
# - URLs
n98-magerun config:set web/secure/base_url http://`cat /vagrant/etc/domain`/
n98-magerun config:set web/unsecure/base_url http://`cat /vagrant/etc/domain`/
# - Services
n98-magerun config:set google/analytics/active 0
n98-magerun config:set google/analytics/account ""

#
# If you use LimeSoda_EnvironmentConfiguration, all above should be configured there and only
# this command stays here:
#
#n98-magerun ls:env:configure dev

# Admin user
n98-magerun admin:user:delete --force admin
n98-magerun admin:user:create admin admin@example.com test123 Achmed Admin