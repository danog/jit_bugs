#!/bin/bash -e

docker build . -t asan_tests

for f in bugs/*sh; do
    $f || echo "!!! $f failed !!!"
done