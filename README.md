# A repo full of reproducer for PHP JIT bugs. 

Run using `./run.sh`.

Edit the branch in `Dockerfile:33`

## Tests

Tested on fa218eab4a9b5304afb871a4405546068cb65008

1. Composer: always fails
2. Psalm: always fails
3. MadelineProto: got a single shutdown hang the first time I tried (even with the new closure fixes), then nothing; expecting an assertion crash
4. Infection (patched): always fails
5. Psalm (unit): hang due to infinite loop in GC
6. php-parser (unit): always fails
7. Psalm (master, unit): always fails
8. Psalm (patched master, unit): always fails
9. Composer: always fails
