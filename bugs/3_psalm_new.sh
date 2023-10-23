#!/bin/bash -e

cd /tmp

rm -rf psalm

git clone https://github.com/nicelocal/psalm -b rector_pass --depth 1
cd psalm
git checkout 9d3fee47afa90f3eb53043a26f01e587d2dd34e5

export PSALM_ALLOW_XDEBUG=1

composer i --ignore-platform-reqs

echo "About to run psalm"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/psalm --no-cache

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests composer update

echo "OK, no bugs!"