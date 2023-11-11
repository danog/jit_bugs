# A repo full of reproducer for PHP JIT bugs. 

Run using `./run.sh`.

Edit the branch in `Dockerfile:33`

## Tests

Tested on fa218eab4a9b5304afb871a4405546068cb65008

1. Composer: Fixed
2. Psalm: always fails
3. MadelineProto: Fixed
4. Infection (patched): Fixed
5. Psalm (unit): ?
6. php-parser (unit): Fixed
7. Psalm (master, unit): always fails
8. Psalm (patched master, unit): always fails
9. Composer: always fails
