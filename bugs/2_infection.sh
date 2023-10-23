#!/bin/bash -e

#!/bin/bash -e

cd /tmp

git clone https://github.com/infection/infection --depth 1
cd infection
git checkout 2789fdd689689b0c85f2c0ae9db50c8d2b39fb92

composer i --ignore-platform-reqs

echo "About to run the standalone test"

php /app/2_infection.php

echo "About to run the testsuite"

vendor/bin/phpunit

echo "OK, no bugs!"