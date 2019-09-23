#!/bin/bash
cd /var/www/project

if [ "$1" = "symfony" ]; then
 TYPE=$2
 echo "Install symfony $TYPE"

 # instal symfony
 if [ "$TYPE" = "website" ]; then
  symfony new --full project
 else
  symfony new project
 fi

 # move symfony
 rm -rf public
 mv -f project/* .
 rm -rf project

 php bin/console cache:clear
fi








if [ "$1" = "wordpress" ]; then
 echo "install wordpress"
fi
