#!/bin/bash -e

if [ "$1" == "" ]; then echo 'This test needs an argument!'; exit 1; fi

standalone=$PWD/bugs/wrap.php

cd /tmp

if [ ! -d psalm_15 ]; then git clone https://github.com/vimeo/psalm -b master psalm_15;fi

cd psalm_15

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

sleep 3

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c "export USE_ZEND_ALLOC=0; sed -i 's/tracing/function/g' /etc/php/php.ini; /usr/bin/php --repeat 2 -f /app/wrap.php vendor/bin/phpunit $1"

echo "OK, no bugs!"
