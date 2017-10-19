<?php
// use Ppj\Auth;
// require_once 'autoload.php';
//
// $auth = new Auth();
// $filename = '/Users/daggerjames/Desktop/ppts/test.pptx';
//
// echo $auth->upload($filename);
require_once __DIR__ . '/src/Ppj/autoload.php';
use Ppj\Ppj;

$client = new Ppj();

// demo: create/upload job
// $filepath = '/path/to/upload/file.pptx';
// $result = $client->upload($filename);
// echo $result['status'] .': '.$result['content'];

// demo: check a job status
// $token = 'token_get_from_upload';
// $result = $client->status($token);
// echo $result['status'] .': '.$result['content'];

// demo: download for a job
// $token = 'token_get_from_upload';
// $path = '/path/to/save/file.zip';
// $result = $client->download($token);
// if ($result['status'] == 200) {
//     file_put_contents($path, $result['content']);
//     echo 'Write file to: '.$path;
// } else {
//     echo $result['status'] .': '.$result['content'];
// }

// demo: get all jobs based on conditions [start_date, end_date] (optional parameters)
// $opts = array('start_date'=>'2017-10-01');   YYYY-MM-DD
// $result = $client->listAll($opts);
// echo $result['status'] .': '.$result['content'];
