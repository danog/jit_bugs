#!/bin/bash -e

cd /tmp

git clone https://github.com/vimeo/psalm
cd psalm
git checkout 7428e49b115a2a837aa29cf0fafd0ca902fe2457

export PSALM_ALLOW_XDEBUG=1

composer i --ignore-platform-reqs

php vendor/bin/phpunit --debug tests/MagicMethodAnnotationTest.php

echo "OK, no bugs!"