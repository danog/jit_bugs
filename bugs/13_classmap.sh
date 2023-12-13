#!/bin/bash -e

php bugs/classmap_gen.php

docker run -v $PWD:/app -w /app --rm --privileged -it asan_tests php /app/bugs/classmap.php
