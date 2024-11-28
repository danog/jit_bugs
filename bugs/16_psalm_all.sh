#!/bin/bash -e

cd $PWD/bugs

echo "About to run nightly.php"

docker run -v $PWD:/app --rm --privileged -it asan_tests bash -c 'export USE_ZEND_ALLOC=0; /usr/bin/php /app/nightly.php'

echo "OK, no bugs!"
