#!/bin/bash
#
# author: Nanne Huiges (nanne@huiges.nl)

# verbose: shows commands for debugging
set -x

# todo
# backup ?

# update code
git checkout master
git merge upstream/master
git checkout raspi
git merge master
# build container
docker build -t nh/firefly:latest .
# restart / recreate
docker-compose up -d --force-recreate
# run isntall stuff
docker-compose exec -T firefly_iii_app php artisan migrate
docker-compose exec -T firefly_iii_app php artisan firefly:upgrade-database
docker-compose exec -T firefly_iii_app php artisan firefly:verify
docker-compose exec -T firefly_iii_app php artisan passport:install
docker-compose exec -T firefly_iii_app php artisan cache:clear

docker-compose exec -T firefly_iii_app chown -R www-data:www-data \
  -R /var/www/firefly-iii/storage/export \
  -R /var/www/firefly-iii/storage/upload \
  -R /var/www/firefly-iii/storage/logs \
  -R /var/www/firefly-iii/storage/framework/cache

