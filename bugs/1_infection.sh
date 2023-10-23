#!/bin/bash -e

#!/bin/bash -e

standalone=$PWD/bugs/1_infection.php

cd /tmp

rm -rf infection

git clone https://github.com/infection/infection
cd infection
git checkout fe7cbe78e5838608df42ec7688d353ef1d631fee

composer i --ignore-platform-reqs

cp $standalone .

echo "About to run the standalone test"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php /app/2_infection.php

echo "About to run the testsuite"

docker run -v $PWD:/app --rm --privileged -it asan_tests /usr/bin/php vendor/bin/phpunit

echo "About to run composer"

rm -rf vendor

docker run -v $PWD:/app --rm --privileged -it asan_tests composer update

echo "OK, no bugs!"