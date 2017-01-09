<?php
namespace Ppj\Http;

class Error{

    static public $ErrorMessage = [
        '100001'=>'create request header faild! check accessKey or your signature!',
        '100002'=>'request faild, signature error!',
        '100003'=>'request url not found!',
        '100004'=>'request param error!'
        
    ];

    /**
     * 抛出异常
     * @param int $code 状态吗
     * @return string
     */
    static public function throwError($code){
        if(isset(self::$ErrorMessage[$code])){
            return ['code'=>$code,'message'=>self::$ErrorMessage[$code]];
        }
    }
}
