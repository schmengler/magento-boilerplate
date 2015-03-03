#!/bin/sh

if [ "$1" = "" ]; then
  echo "No environment specified. Usage: git-hook.sh [ENV]"
  exit 1
fi;

echo
echo "**** Checked out commit, now deploying modules..."
echo

cd $GIT_DIR
cd ..
bin/composer install --no-dev --no-scripts --no-ansi
bin/modman link src src
bin/modman deploy-all

echo
echo "**** Now setting up environment $1..."
echo

bin/n98-magerun --no-ansi ls:env:configure $1
