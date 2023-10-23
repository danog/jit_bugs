#!/bin/bash -e

cd /tmp

rm -rf psalm

git clone https://github.com/vimeo/psalm
cd psalm
git checkout 7428e49b115a2a837aa29cf0fafd0ca902fe2457

git branch -D master || true
git branch master
git checkout master

export PSALM_ALLOW_XDEBUG=1

composer i --ignore-platform-reqs

echo "About to run phpunit"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/vendor/bin/phpunit --debug tests/MagicMethodAnnotationTest.php

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests composer update

echo "OK, no bugs!"