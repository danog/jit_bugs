#!/bin/bash -e

docker build . -t asan_tests

composer update

for f in bugs/*sh; do
    echo "!!! About to run $f !!!"
    $f || echo "!!! Failed to run $f !!!"
done