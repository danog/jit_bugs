#!/bin/bash -e

standalone=$PWD/bugs/wrap.php

cd /tmp

rm -rf php-parser

git clone https://github.com/nikic/php-parser
cd php-parser
git checkout 8d50e9d066fd857dc4d6354047bda9111f179b46

cp $standalone .

export PSALM_ALLOW_XDEBUG=1

composer i --ignore-platform-reqs

echo "About to run phpunit"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php --repeat 2 -f /app/wrap.php /app/vendor/bin/phpunit

echo "OK, no bugs!"
