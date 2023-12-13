<?php
$f = '<?php

$vendorDir = dirname(__DIR__);

return array(
';

$v = 'a';
for ($x = 0; $x < 11_000; $x++) {
    $v++;
    $f .= "'$v' => \$vendorDir . '$v',\n";
}

$f .= ");\n";

file_put_contents(__DIR__.'/classmap.php', $f);