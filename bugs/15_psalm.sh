#!/bin/bash -e

standalone=$PWD/bugs/wrap.php

cd /tmp

if [ ! -d psalm_15 ]; then git clone https://github.com/vimeo/psalm -b master psalm_15;fi

cd psalm_15

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

sleep 3

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c 'export USE_ZEND_ALLOC=0; /usr/bin/php --repeat 2 -f /app/wrap.php vendor/bin/phpunit tests/FileUpdates/ErrorAfterUpdateTest.php'
echo "OK, no bugs!"
