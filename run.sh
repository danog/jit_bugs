#!/bin/bash -e

docker build . -t asan_tests

for f in bugs/*sh; do
    f=$(basename $f)
    docker run -v $PWD/bugs:/app --rm --privileged -it asan_tests /app/$f || echo "!!! $f failed !!!"
done