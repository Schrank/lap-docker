#!/usr/bin/env bash
echo ""
echo "Installing SSH, git, composer and adding github host key"
echo ""

apt-get -yqq update && apt-get -yqq install apt-utils ssh unzip curl git composer
docker-php-ext-install -j$(nproc) curl

mkdir -p /root/.ssh
touch ~/.ssh/known_hosts
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

composer global require hirak/prestissimo

echo ""
echo "Cleaning up /var/www/html"
echo ""

cd /var/www/html
rm -rf {,.[!.],..?}*

SAMPLE_PROJECT_VERSION=2017-11-09-01

echo "Cloning https://github.com/lizards-and-pumpkins/sample-project.git"
cd /var/www/html
git clone --quiet https://github.com/lizards-and-pumpkins/sample-project.git .
git checkout tags/$SAMPLE_PROJECT_VERSION -b $SAMPLE_PROJECT_VERSION

mkdir -p /var/www/html/file-storage/key-value-store
mkdir -p /var/www/html/file-storage/search-engine
mkdir -p /var/www/html/file-storage/share/log
mkdir -p /var/www/html/file-storage/file-storage
chmod -R 777 /var/www/html/file-storage/

composer install --ignore-platform-reqs --no-progress --profile --prefer-dist
