rm -rf /var/www/`cat /vagrant/etc/domain`
[ -d /home/vagrant/www ] && ln -fs /home/vagrant/www /var/www/`cat /vagrant/etc/domain`