#!/bin/sh
for dir in .modman/*/
do
    dir=${dir%*/}
    if [ ! -f $dir/modman ] && [ -f $dir/package.xml ]; then
        echo ${dir##*/} does not contain a modman file, autogenerating from package.xml...
        php $(dirname $0)/package2modman.php $dir/package.xml > $dir/modman
    fi
done