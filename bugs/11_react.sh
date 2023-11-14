#!/bin/bash -e

composer update

standalone=$PWD/bugs/wrap.php
refactor=$PWD/refactor.php

cd /tmp

rm -rf promise

git clone https://github.com/reactphp/promise
cd promise

cp $standalone .

composer i --ignore-platform-reqs

sleep 3

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c 'export USE_ZEND_ALLOC=1; /usr/bin/php -d opcache.jit=0 --repeat 2 -f /app/wrap.php /app/vendor/bin/phpunit'

echo "OK, no bugs!"
