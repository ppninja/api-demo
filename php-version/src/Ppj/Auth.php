<?php
namespace Ppj;
use Ppj\Http\Request;

class Auth{

    /**
     * @var string appid
     */
    private $accessKey;

    /**
     * @var string appsecret
     */
    private $secretKey;

    /**
     * @var int 签名时间戳
     */
    static $time;

    /**
     * @var string 参数签名
     */
    static $paramString;

    /**
     * @var array 上传文件信息
     */
    static $postParam;

    /**
     * 构造函数
     * @param type $accessKey id
     * @param type $secretKey secret
     */
    public function __construct()
    {
        $this->accessKey = Config::$APPID;
        $this->secretKey = Config::$APPSECRET;
    }

    /**
     * 获取签名
     * @param string $type 请求方式
     * @return string
     */
    public function auth($type = 'POST'){
        self::$time = time();
        self::$paramString = $this->getParamSign(self::$postParam);
        return $this->getSignature($this->getEncodeText($type),$this->getKey());
    }

    /**
     * 生成参数签名
     * @param string $postParam 请求参数集合
     * @return string
     */
    private function getParamSign($postParam){
        unset($postParam['file_source']);
        ksort($postParam);
        return arrayToStrParam($postParam);
    }

    /**
     * 生成文本签名
     * @param string $type 请求方式
     * @return string
     */
    private function getEncodeText($type){
        return $type."\n".zone::$Api."\n".self::$paramString;
    }

    /**
     * 生成key
     * @return string
     */
    private function getKey(){
        return hash_hmac('sha256', $this->secretKey, self::$time);
    }

    /**
     * 生成签名
     * @param string $paramSign 参数签名
     * @param string $key key
     * @return string
     */
    private function getSignature($paramSign,$key){
        return hash_hmac('sha256',$paramSign,$key);
    }

    /**
     * 上传文件
     * @param string $token 上传token
     * @return array
     */
    public function upload($filename){
        Zone::zone0();
        self::$postParam = ['file_source'=>new \CURLFile($filename),'file_md5'=>md5_file($filename)];
        $request = new Request($this->auth(),$this->accessKey,self::$paramString,self::$time);
        $result = $request->http_post(self::$postParam);
        if($result['code'] == 0){
            return $result['content'];
        }else{
            return $result;
        }
    }

    /**
     * 查询转码状态
     * @param type $token
     * @return string
     */
    public function getFileTransStatus($token){
        Zone::zone1();
        self::$postParam = ['token'=>$token];
        $signature = $this->auth('GET');
        $request = new Request($signature,$this->accessKey,self::$paramString,self::$time);
        $result = $request->http_get();
        if($result['code'] == 0){
            return $result['content'];
        }else{
            return $result;
        }
    }

    /**
     * 下载文件
     * @param type $token
     * @param srting $filename 文件下载的路径
     */
    public function downLoad($token,$filename){
        Zone::zone2();
        self::$postParam = ['token'=>$token];
        $signature = $this->auth('GET');
        $request = new Request($signature,$this->accessKey,self::$paramString,self::$time);
        $result = $request->http_get();
        if($result['code'] == 0){
            file_put_contents($filename, $result['content']);
            return true;
        }else{
            return $result;
        }
    }
}
