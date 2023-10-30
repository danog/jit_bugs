#!/bin/bash -e

composer update

standalone=$PWD/bugs/wrap_madeline.php

refactor=$PWD/refactor.php

cd /tmp

rm -rf jit_test

wget https://paste.daniil.it/jit_1.tar.xz -c
tar -xf jit_1.tar.xz

cd jit_test

cp $standalone wrap.php

php $refactor

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php --repeat 2 -d opcache.blacklist_filename=b.txt -f /app/wrap.php test.php
