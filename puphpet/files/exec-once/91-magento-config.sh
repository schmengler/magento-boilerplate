#!/bin/sh

# always run this script as vagrant user
if [ "$USER" != "vagrant" ]; then
	sudo -u vagrant -H sh -c "sh $0"
	exit
fi

cd /home/vagrant

# Some devbox specific Magento settings
n98-magerun config:set dev/log/active 1
n98-magerun config:set dev/template/allow_symlink 1

# Admin user
n98-magerun admin:user:delete --force admin
n98-magerun admin:user:create admin admin@example.com test123 Achmed Admin