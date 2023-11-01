<?php

use PhpParser\Node\Expr\Array_;
use PhpParser\Node\Expr\ArrayItem;
use PhpParser\Node\Expr\ArrowFunction;
use PhpParser\Node\Expr\Variable;
use PhpParser\Node\FunctionLike;
use PhpParser\Node\Scalar\LNumber;
use PhpParser\Node\Stmt\Foreach_;
use PhpParser\NodeFinder;
use PhpParser\NodeTraverser;
use PhpParser\NodeVisitor\NameResolver;
use PhpParser\ParserFactory;
use PhpParser\PrettyPrinter\Standard;

require __DIR__.'/vendor/autoload.php';

$i = new RecursiveDirectoryIterator($argv[1] ?? '.');
$i = new RecursiveIteratorIterator($i);
$i = new RegexIterator($i, '/^.+\.php$/i', RecursiveRegexIterator::GET_MATCH);

$parser = (new ParserFactory)->create(ParserFactory::PREFER_PHP7);
$finder = new NodeFinder;
$resolver = new NodeTraverser(new NameResolver());
$printer = new Standard();

foreach ($i as [$file]) {
    $f = file_get_contents($file);
    try {
        $parsed = $resolver->traverse($parser->parse($f));
    } catch (\Throwable) {
        continue;
    }

    foreach ($finder->findInstanceOf($parsed, FunctionLike::class) as $f) {
        if ($f instanceof ArrowFunction) continue;
        if ($f->stmts === null) continue;
        $f->stmts = [new Foreach_(
            new Array_([new ArrayItem(new LNumber(0))]),
            new Variable('____'),
            ['stmts' => $f->stmts]
        )];
    }

    file_put_contents($file, $printer->prettyPrintFile($parsed));
}
