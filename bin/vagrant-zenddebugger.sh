#!/bin/bash
# based on http://forums.zend.com/viewtopic.php?f=59&t=115943
if [ ! -f /vagrant/var/ZendDebugger.so ]; then
	cd /tmp
	wget "http://repos-source.zend.com/zend-server/6.3/deb/pool/zend-server-php-5.5-common_6.3.0+b31_amd64.deb"
	ar x zend-server-php-5.5-common_6.3.0+b31_amd64.deb
	tar -zxf data.tar.gz
	#--> usr/local/zend/lib/debugger/php-5.5.x/ZendDebugger.so
	mkdir /vagrant/var
	cp usr/local/zend/lib/debugger/php-5.5.x/ZendDebugger.so /vagrant/var/
fi