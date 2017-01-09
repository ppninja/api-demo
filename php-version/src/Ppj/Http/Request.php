<?php
namespace Ppj\Http;
use Ppj\Zone;

class Request{

    /**
     * @var object curl句柄
     */
    public $ch;

    //请求成功
    const OK = 0;

    /**
     * 构造函数  构造curl请求
     */
    public function __construct($signature,$accessKey,$paramString,$time) {
        $this->ch = curl_init();
        curl_setopt($this->ch, CURLOPT_RETURNTRANSFER, 1 );
        $header = $this->getRequsetHeader($accessKey,$time,$signature);
        if(!$header){
            throw new \Exception (Error::throwError(100001));
        }
        curl_setopt($this->ch, CURLOPT_URL, Zone::$Host.Zone::$Api.'?'.$paramString);
        curl_setopt($this->ch, CURLOPT_HTTPHEADER, $header );
    }

    /**
     * 生成头部签名
     * @param string $accessKey  accesskey
     * @param int $time  时间戳
     * @param int $signature 签名token
     * @return boolean
     */
    public function getRequsetHeader($accessKey,$time,$signature){
        if(empty($accessKey) || empty($time) || empty($signature)){
            return false;
        }
        return ['x-ppj-authorization:'.'Credential='.$accessKey.','.'Timestamp='.$time.','.'Signature='.$signature];
    }

    /**
     * 构析函数  释放curl句柄
     */
    public function __destruct() {
        curl_close($this->ch);
    }

    /**
     * get请求
     * @return string
     */
    public function http_get(){
        $sContent = curl_exec($this->ch);
        $aStatus = curl_getinfo($this->ch);
        if($aStatus['http_code'] == 200){
            return ['code'=>OK,'content'=>$sContent];
        }else{
            return $this->errorHandle($aStatus['http_code']);
        }
    }

    /**
     * post请求
     * @param array  $postParam post参数
     * @return string
     */
    public function http_post($postParam){
        curl_setopt ( $this->ch, CURLOPT_POST, 1 );
        curl_setopt($this->ch, CURLOPT_POSTFIELDS,$postParam);
        $sContent = curl_exec($this->ch);
        $aStatus = curl_getinfo($this->ch);
        if($aStatus['http_code'] == 200){
            return ['code'=>OK,'content'=>$sContent];
        }else{
            return $this->errorHandle($aStatus['http_code']);
        }
    }

    /**
     * http错误处理
     * @param int $http_code  http状态
     */
    public function errorHandle($http_code){
        switch ($http_code) {
            case 404:
                return Error::throwError(100003);
            case 400:
                return Error::throwError(100004);
            case 401:
            default:
                return Error::throwError(100002);
        }
    }
}
