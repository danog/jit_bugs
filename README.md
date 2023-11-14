# A repo full of reproducer for PHP JIT bugs. 

Run using `./run.sh`.

Edit the branch in `Dockerfile:33`

## Tests

Tested on fa218eab4a9b5304afb871a4405546068cb65008

1. Composer: Fixed
2. Psalm: Fixed
3. MadelineProto: Fixed
4. Infection (patched): Fixed
5. Psalm (unit): ?
6. php-parser (unit): Fixed
7. Psalm (master, unit): Fixed
8. Psalm (patched master, unit): Fixed
9. Composer: Fixed
10. Amphp: Always fails
11. Reactphp: Always fails
12. Amphp: Always fails
