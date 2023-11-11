#!/bin/bash -e

standalone=$PWD/bugs/wrap.php

cd /tmp

rm -rf psalm_7

git clone https://github.com/nicelocal/psalm -b master psalm_7
cd psalm_7
git checkout c7d7b48bdd798b404976054d1b5220082c2f246e

git branch -D master || true
git branch master
git checkout master

sed 's:findUnusedCode=:cacheDirectory="/tmp/psalm" findUnusedCode=:g' -i psalm.xml.dist
sed 's/error_log[(]/exit(/g' -i src/Psalm/Internal/Fork/Pool.php

export PSALM_ALLOW_XDEBUG=1

cp $standalone .

composer i --ignore-platform-reqs

echo "About to run psalm"

sleep 3

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c 'export USE_ZEND_ALLOC=1; /usr/bin/php --repeat 2 -f /app/wrap.php /app/psalm --no-cache'

echo "OK, no bugs!"
