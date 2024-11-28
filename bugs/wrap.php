<?php

$pid = getmypid();
register_shutdown_function(function () use ($pid) {
    $status = opcache_get_status(false);

    $ok = true;
    if ($status["memory_usage"]["free_memory"] < 10*1024*1024) {
        echo "Not enough free opcache memory!".PHP_EOL;
        $ok = false;
    }
    if ($status["interned_strings_usage"]["free_memory"] < 1*1024*1024) {
        echo "Not enough free interned strings memory!".PHP_EOL;
        $ok = false;
    }
    if ($status["jit"]["buffer_free"] < 10*1024*1024) {
        echo "Not enough free JIT memory!".PHP_EOL;
        $ok = false;
    }
    if (!$status["jit"]["on"]) {
        echo "JIT is not enabled!".PHP_EOL;
        var_dump($status);
        $ok = false;
    }

    unset($status);
    while (gc_collect_cycles());

    //if ($pid === getmypid()) {
        //`rm -rf /tmp/psalm`;
    //}

    if (!$ok) die(139);
});

$argc--;
array_shift($argv);

$_SERVER['argc']--;
array_shift($_SERVER['argv']);

require $argv[0];
