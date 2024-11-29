#!/bin/bash -e

if [ "$1" == "" ] || [ "$2" == "" ]; then echo "Usage: $0 tracing|function|off testCase.php"; exit 1; fi

standalone=$PWD/bugs/wrap.php

cd /tmp

if [ ! -d phpseclib ]; then git clone https://github.com/phpseclib/phpseclib -b master;fi

cd phpseclib

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

sleep 3

if [ "$1" == "off" ]; then
    docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c "export USE_ZEND_ALLOC=0; sed -i 's/tracing/$1/g' /etc/php/php.ini; /usr/bin/php --repeat 2 -f vendor/bin/phpunit -c tests/phpunit.xml $2"
else
    docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c "export USE_ZEND_ALLOC=0; sed -i 's/tracing/$1/g' /etc/php/php.ini; /usr/bin/php --repeat 2 -f /app/wrap.php vendor/bin/phpunit -c tests/phpunit.xml $2"
fi

echo "OK, no bugs!"
