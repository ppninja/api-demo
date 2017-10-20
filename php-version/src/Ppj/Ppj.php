<?php
/**
* Copyright 2017 Ppj
*/

namespace Ppj;

/**
* Class Ppj
*
* @package Ppj
*/
class Ppj
{
    /**
    * @const string Version number of the Ppj PHP SDK
    */
    const VERSION = '1.0.0';

    /**
     * @var PpjClient The Http Client for sending request
     */
    protected $client;

    /**
     * Instantiates a new Ppj super-class object.
     */
    public function __construct()
    {
        // init http client for send request
        $this->client = new HttpClient(Config::$ACCESSKEY, Config::$ROOTPATH);
    }

    /**
     * 查询所有请求信息
     * @param type $token
     * @return array ($status, $content)
     */
    public function listAll($params){
        return $this->client->http_get('/jobs', $params);
    }

    /**
     * 上传文件
     *
     * @param string $filename  Path to uploading file
     *
     * @return array ($status, $content)
     */
    public function upload($filename){
        return $this->client->http_post('/jobs', array(
            'file_source' => new \CURLFile($filename),
            'file_md5' => md5_file($filename)
        ));
    }

    /**
     * 查询转码状态
     * @param type $token
     * @return array ($status, $content)
     */
    public function status($token){
        return $this->client->http_get('/jobs/'.$token);
    }

    /**
     * 下载文件
     * @param type $token
     * @param array ($status, $content)
     */
    public function download($token){
        return $this->client->http_get('/jobs/'.$token.'/download');
    }

    /**
     * 查询可用额度
     *
     * @return array ($status, $content)
     */
    public function quotas(){
        return $this->client->http_get('/quotas');
    }
}
