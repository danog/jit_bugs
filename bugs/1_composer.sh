#!/bin/bash -e

standalone=$PWD/bugs/wrap.php

cd /tmp

rm -rf psalm

git clone https://github.com/vimeo/psalm
cd psalm
git checkout 7428e49b115a2a837aa29cf0fafd0ca902fe2457

git branch -D master || true
git branch master
git checkout master

cp $standalone .

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/wrap.php /usr/bin/composer update --ignore-platform-reqs

echo "OK, no bugs!"