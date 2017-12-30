#!/usr/bin/env bash
echo ""
echo "Installing SSH and adding github host key"
echo ""

apt-get -yqq update && apt-get -yqq install apt-utils ssh

mkdir -p /root/.ssh
touch ~/.ssh/known_hosts
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

echo ""
echo "Installing git and stuff"
echo ""

apt-get -yqq install git mariadb-client

echo ""
echo "Cleaning up /var/www/html"
echo ""

cd /var/www/html
rm -rf {,.[!.],..?}*

echo ""
echo "Cloning magento"
echo ""
git clone https://github.com/OpenMage/magento-mirror.git .


echo ""
echo "Downloading sample data"
echo ""

mkdir -p ~/sample-data
cd ~/sample-data
git clone https://github.com/riconeitzel/magento_sample_data_1.9.1.0_clean.git .
cd src

echo ""
echo "Rsyncing skin and media, fix file permissions"
echo ""

mkdir -p /var/www/html/media
mkdir -p /var/www/html/skin
rsync -ar media/* /var/www/html/media/
rsync -ar skin/* /var/www/html/skin/

cd /var/www/html
find . -type f -exec chmod 444 {} \;
find . -type d -exec chmod 555 {} \;
find var/ -type f -exec chmod 666 {} \;
find media/ -type f -exec chmod 666 {} \;
find var/ -type d -exec chmod 777 {} \;
find media/ -type d -exec chmod 777 {} \;
chmod 777 includes
chmod 666 includes/config.php

echo ""
echo "Importing sample data dump"
echo ""
mysql -uroot -plizardsAndPumpkins -hmagento-db -e "CREATE DATABASE IF NOT EXISTS magento;"
mysql -uroot -plizardsAndPumpkins -hmagento-db magento < ~/sample-data/src/magento_sample_data_for_1.9.1.0.sql

echo ""
echo "Copy app/etc/local.xml"
echo ""
cp /build/config/local.xml /var/www/html/app/etc/local.xml
