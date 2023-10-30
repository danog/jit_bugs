#!/bin/bash -e

composer update

standalone=$PWD/bugs/wrap.php
refactor=$PWD/refactor.php

cd /tmp

rm -rf psalm_8

git clone https://github.com/nicelocal/psalm -b master psalm_8
cd psalm_8
git checkout c7d7b48bdd798b404976054d1b5220082c2f246e

git branch -D master || true
git branch master
git checkout master

export PSALM_ALLOW_XDEBUG=1

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

php $refactor

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php --repeat 2 -f /app/wrap.php /app/psalm --no-cache

echo "OK, no bugs!"
