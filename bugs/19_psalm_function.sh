#!/bin/bash -e

standalone=$PWD/bugs/wrap.php

cd /tmp

if [ ! -d psalm_19 ]; then git clone https://github.com/vimeo/psalm -b 6.x psalm_19;fi

cd psalm_19

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

sleep 3

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c 'export USE_ZEND_ALLOC=0; /usr/bin/php ./psalm --no-cache'
echo "OK, no bugs!"
