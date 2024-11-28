#!/bin/bash -e

cd $PWD/bugs

echo "About to run nightly.php"

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c 'sed -i "s/tracing/function/g" /etc/php/php.ini; export USE_ZEND_ALLOC=0; /usr/bin/php /app/nightly.php 4'

echo "OK, no bugs!"
