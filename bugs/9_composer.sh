#!/bin/bash -e

standalone=$PWD/bugs/wrap.php
c=$PWD/bugs/9_composer.json

cd /tmp

mkdir -p test

cd test

mkdir -p src

docker run -v $PWD:/app --rm --privileged -it asan_tests rm -rf vendor composer.lock

cp $standalone .
cp $c composer.json

echo "About to run composer"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php --repeat 2 -f /app/wrap.php /usr/bin/composer update --ignore-platform-reqs

echo "OK, no bugs!"
