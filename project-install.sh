#!/bin/bash

if [ "$1" = "symfony" ]; then
 TYPE=$2
 echo " "
 echo " "
 echo "Installing symfony $TYPE"
 echo " "

 # remove all current files in the www dir
 echo "Removing all files"
 rm -rf /var/www/project
 cd /var/www

 # install symfony
 echo "Installing symfony using the symfony installer...."
 if [ "$TYPE" = "website" ]; then
  symfony new --full project
 else
  symfony new project
 fi

# Clear symfony cache
 php bin/console cache:clear
fi





































if [ "$1" = "wordpress" ]; then
 echo "install wordpress"
fi
