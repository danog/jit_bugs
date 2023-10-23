<?php

require 'vendor/autoload.php';

use Infection\Configuration\Entry\Logs;
use Infection\Configuration\Entry\PhpUnit;
use Infection\Configuration\Entry\Source;
use Infection\Configuration\Schema\SchemaConfiguration;
use Infection\Configuration\Schema\SchemaConfigurationFactory;
use JsonSchema\Validator;

function test_it_can_create_a_config(
    string $json,
): void {
    $rawConfig = json_decode($json);

    $validator = new Validator();

    $validator->validate($rawConfig, json_decode('{
        "$schema": "https://json-schema.org/draft-07/schema#",
        "properties": {
            "source": {"type": "string"}
        }
    }'));

    $actual = (new SchemaConfigurationFactory())->create(
        '/path/to/config',
        $rawConfig
    );
}

function provideRawConfig(): iterable
{

    yield '[timeout] nominal' => [
        <<<'JSON'
{
"timeout": 100,
"source": {
    "directories": ["src"]
}
}
JSON
        ,
    ];


    yield '[logs][text] nominal' => [
        <<<'JSON'
{
"source": {
    "directories": ["src"]
},
"logs": {
    "text": "text.log"
}
}
JSON
        ,
    ];
    yield '[logs][html] nominal' => [
        <<<'JSON'
{
"source": {
    "directories": ["src"]
},
"logs": {
    "html": "report.html"
}
}
JSON
        ,
    ];
}

for ($x = 0; $x < 10000; $x++) {
    foreach (provideRawConfig() as [$a]) {
        test_it_can_create_a_config($a);
    }
}