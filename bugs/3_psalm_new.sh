#!/bin/bash -e

standalone=$PWD/bugs/wrap.php

cd /tmp

rm -rf psalm_3

git clone https://github.com/nicelocal/psalm -b rector_pass --depth 1 psalm_3
cd psalm_3
git checkout 9d3fee47afa90f3eb53043a26f01e587d2dd34e5

git branch -D master || true
git branch master
git checkout master

export PSALM_ALLOW_XDEBUG=1

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/wrap.php /app/psalm --no-cache

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/wrap.php /usr/bin/composer update

echo "OK, no bugs!"