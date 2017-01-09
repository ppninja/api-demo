<?php
use Ppj\Auth;
require_once 'autoload.php';

$auth = new Auth();
$filename = '/path/to/test.pptx';

echo $auth->upload($filename);
