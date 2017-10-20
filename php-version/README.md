所需环境
php version 5.5+
extension curl

如果你的版本低于5.5  请修改如下部分 否则将无法正常上传文件

Ppj.php
`'file_source' => new \CURLFile($filename)`
为 `'file_source' => '@'.$filename`

5.6+的php curl扩展默认不支持旧的'@'语法 5.5版本的两种语法都支持

Demo:
1. 将host, appid, appsecret添加到src/Ppj/Config.php 中
2. 见demo.php


使用方法
1.引入sdk文件
<?php
use Ppj\Auth;
require_once 'Ppj/autoload.php';
$auth = = new Auth(PPJAPPID,PPJAPPSEECRET);


2.上传文件
<?php
//获取上传token $file_path 为要上传文件绝对路径
$token = $auth->getUploadToken($file_path);
$return = $auth->upload($token);

返回值见$return

3.下载文件
<?php
//$token为上传成功以后返回的文件token  $filename为要下载到的绝对路径
//如 /www/a.zip   文件的后缀统一为zip
$result = $auth->downLoad($token,$filename);
