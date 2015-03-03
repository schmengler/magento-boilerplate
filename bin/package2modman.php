<?php
/**
 * Generate modman file from Magento Connect 2.0 package.xml
 *
 * Usage:
 *
 *   php package2modman.php path/to/package.xml > path/to/modman
 *
 */
require_once(__DIR__ . "/../www/app/Mage.php");

$package = new Mage_Connect_Package($argv[1]);
$modmanDefinition = array();
foreach ($package->getContents() as $path) {
    $path = preg_replace('{^\./}', '', $path);
    $path = preg_replace('{^app/code/(.*?)/(.*?)/(.*?)/(.*)$}', 'app/code/$1/$2/$3', $path);
    $path = preg_replace('{^lib/(.*?)/(.*)$}', 'lib/$1', $path);
    $path = preg_replace('{^js/(.*?)/(.*?)/(.*)$}', 'js/$1', $path);
    $path = preg_replace('{^app/design/(.*?)/(.*?)/default/layout/(.*?)/(.*)$}', 'app/design/$1/$2/default/layout/$3', $path);
    $path = preg_replace('{^app/design/(.*?)/(.*?)/default/template/(.*?)/(.*)$}', 'app/design/$1/$2/default/template/$3', $path);
    $path = preg_replace('{^skin/(.*?)/(.*?)/default/(.*?)/(.*?)/(.*)$}', 'skin/$1/$2/default/$3/$4', $path);
    $modmanDefinition[$path] = $path;
}
foreach ($modmanDefinition as $source => $target) {
    printf("%s %s\n", $source, $target);
}