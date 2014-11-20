#!/bin/sh

DUMP=`ls -1t /vagrant/systemstorage/live/database/*.sql.gz | head -n1`

echo "Importing SQL dump from $DUMP. This will take a while..."
echo "You can ignore warnings about using a password on the command line interface." >&2

DBH="localhost";
DBU="root"
DBP="root"
DBN="magento"

echo "1) Drop database"
(echo "SET foreign_key_checks = 0;"; 
 (mysqldump -h ${DBH} -u${DBU} -p${DBP} --add-drop-table --no-data ${DBN} | 
     grep ^DROP); 
 echo "SET foreign_key_checks = 1;") | mysql -h ${DBH} -u${DBU} -p${DBP} ${DBN}

echo "2) Import database"
gunzip < ${DUMP} | mysql -h ${DBH} -u${DBU} -p${DBP} ${DBN}

echo "Done importing SQL dump."