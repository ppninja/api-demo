<?php
namespace Ppj;

final class Zone{

    static public $Host;
    static public $Api;

    /**
     * 构造函数 设置服务器与请求接口
     * @param string $Host
     * @param string $Api
     */
    public function __construct($Host, $Api)
    {
        self::$Host = $Host;
        self::$Api = $Api;
    }

    /**
     * 上传接口
     * @return \self
     */
    public static function zone0(){
        return new self(Config::$HOST, '/api/job/create');
    }

    /**
     * 获取状态接口
     * @return \self
     */
    public function zone1(){
        return new self(Config::$HOST, '/api/job/status');
    }

    /**
     * 下载接口
     * @return \self
     */
    public function zone2(){
        return new self(Config::$HOST, '/api/job/download');
    }
}
