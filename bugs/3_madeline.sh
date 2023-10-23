#!/bin/bash -e

standalone=$PWD/bugs/wrap_madeline.php

cd /tmp

rm -rf jit_test

wget https://paste.daniil.it/jit_1.tar.xz -c
tar -xf jit_1.tar.xz

cd jit_test

cp $standalone wrap.php

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php -d opcache.blacklist_filename=b.txt -f /app/wrap.php test.php