#!/bin/bash -e

#!/bin/bash -e

cd /tmp

git clone https://github.com/infection/infection
cd infection
git checkout fe7cbe78e5838608df42ec7688d353ef1d631fee

composer i --ignore-platform-reqs

echo "About to run the standalone test"

php /app/2_infection.php

echo "About to run the testsuite"

vendor/bin/phpunit

echo "OK, no bugs!"