<?php
namespace Ppj;


/**
 * 按键名升序格式化数组参数
 * 
 * @param type $param
 * @return type
 */
function arrayToStrParam($param){
    ksort($param);
    $str = '';
    foreach($param as $key=>$val){
        $str .= $key."=".$val.'&';
    }
    return rtrim($str,'&');
}

