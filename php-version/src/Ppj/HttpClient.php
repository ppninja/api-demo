<?php
namespace Ppj;

class HttpClient{
    protected $rootpath;
    protected $accesskey;

    /**
     * 构造函数  保存常量
     */
    public function __construct($accesskey, $rootpath) {
        $this->rootpath = $rootpath;
        $this->accesskey = $accesskey;
    }

    /**
     * get请求
     */
    public function http_get($path, $queries = null){
        $query = ($queries ? '?'. http_build_query($queries) : '');

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1 );
        curl_setopt($ch, CURLOPT_URL, $this->rootpath . $path . $query);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('X-PPJ-Credential: '.$this->accesskey));
        // curl_setopt($ch, CURLOPT_VERBOSE, true);
        $sContent = curl_exec($ch);
        $aStatus = curl_getinfo($ch);
        curl_close($ch);
        return ['status'=>$aStatus['http_code'], 'content'=>$sContent];
    }

    /**
     * post请求
     */
    public function http_post($path, $postParam){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1 );
        curl_setopt($ch, CURLOPT_URL, $this->rootpath . $path);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('X-PPJ-Credential: '.$this->accesskey));
        curl_setopt($ch, CURLOPT_POST, 1 );
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postParam);
        // curl_setopt($ch, CURLOPT_VERBOSE, true);
        $sContent = curl_exec($ch);
        $aStatus = curl_getinfo($ch);
        curl_close($ch);
        return ['status'=>$aStatus['http_code'], 'content'=>$sContent];
    }
}
