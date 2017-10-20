## PPJ SDK for PHP (v1.0 正式版)

This repository contains the open source PHP SDK that allows you to access the PPJ Platform from your PHP app.

### Installation
--------------------------
not support for any Composer right now.

manually put `src/Ppj` in your working directory, and require the `src/Ppj/autoload.php`

see demo.php

```
require_once __DIR__ . '/src/Ppj/autoload.php';
use Ppj\Ppj;

$client = new Ppj();
```

### Apis

API回调的参数见[主文档](https://ppninja.github.io/saas-docs/#introduction)，这里只注明 php sdk 中与主文档对应的请求

函数名|参数|说明
---|---|---
upload|$filename: string|[创建Job](https://ppninja.github.io/saas-docs/#create)
status|$token: string|[查询特定Job](https://ppninja.github.io/saas-docs/#show)
download|$token: string|[下载产物](https://ppninja.github.io/saas-docs/#download)
listAll|$params: array|[获取所有Jobs](https://ppninja.github.io/saas-docs/#list)
quotas||[查看可用额度](https://ppninja.github.io/saas-docs/#quotas)

### 仍有疑问？
请加QQ群（459962155）或微信（GockGe）咨询

### Rights
All Rights reserved to https://ppj.io.
