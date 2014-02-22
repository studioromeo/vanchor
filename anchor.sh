#!/usr/bin/env bash
# init
cd /vagrant/laravel

# get anchor
git clone https://github.com/studioromeo/ac.git workbench/anchor/core

# load the workbench
composer dump-autoload
php artisan dump-autoload

# set up the database
mysql -u root -proot -e 'create database anchor'
sed -i "58c\'database' => 'anchor'," app/config/database.php
sed -i "60c\'password' => 'root'," app/config/database.php


# create the schema
php artisan migrate --bench="anchor/core"

#seed the database
cd workbench/anchor/core
composer install --dev
cd ../../../
php artisan db:seed --class="Anchor\Core\Database\Seeds\DatabaseSeeder"

#download the theme
git clone https://github.com/daviddarnes/ticket.git public/themes/default

#publish core assets
php artisan asset:publish --bench="anchor/core"

#enable the thing!
sed -i "109c\'Anchor\\\Core\\\CoreServiceProvider'," app/config/app.php

mv app/routes.php app/routes.example.php
