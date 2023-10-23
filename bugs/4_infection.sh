#!/bin/bash -e

#!/bin/bash -e

wrap=$PWD/bugs/wrap.php
standalone=$PWD/bugs/infection.php

cd /tmp

rm -rf infection

git clone https://github.com/infection/infection -b 0.27.4
cd infection

composer i --ignore-platform-reqs

cp $standalone .
cp $wrap .

echo "About to run the standalone test"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/wrap.php /app/infection.php

echo "About to run the testsuite"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/wrap.php vendor/bin/phpunit || EXIT_CODE=$?

if [ $EXIT_CODE -gt 128 ]; then
    exit $EXIT_CODE
fi

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/wrap.php /usr/bin/composer update

echo "OK, no bugs!"