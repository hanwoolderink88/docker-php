#!/bin/bash

 cd /var/www/project

if [ "$1" = "symfony" ]; then
 TYPE=$2

 # clear all
 rm -rf ./*

 # install symfony
 if [ "$TYPE" = "website" ]; then
  composer create-project symfony/website-skeleton project
 else
  composer create-project symfony/skeleton project
 fi

 # move
 mv ./project/* .
 mv ./project/.env .
 rm -rf project

 # Clear symfony cache
 php bin/console cache:clear
fi





































if [ "$1" = "wordpress" ]; then
 echo "install wordpress"
fi
