<?php
ini_set('display_errors',1);
error_reporting(7);
$mem = new Memcache;
$mem->connect('172.0.0.1',11211);
$mem->set('test','Hello world!',0,12);
$val = $mem->get('test');
echo $val;
var_dump($val);