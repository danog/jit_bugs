#!/bin/bash -e

#!/bin/bash -e

standalone=$PWD/bugs/1_infection.php

cd /tmp

rm -rf infection

git clone https://github.com/infection/infection -b 0.27.4
cd infection

composer i --ignore-platform-reqs

cp $standalone .

echo "About to run the standalone test"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/1_infection.php

echo "About to run the testsuite"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php vendor/bin/phpunit

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests composer update

echo "OK, no bugs!"