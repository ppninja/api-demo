## ppj-api

Node.js version API for https://ppj.io

Implemented based on [API v1](https://ppninja.github.io/saas-docs/#introduction).

接入请先阅读上方的文档

### install

npm install ppj-api

### Run demo

check demo.js file


### usage

``` javascript
const PPJClient = require('ppj-api')

const client = new PPJClient('your_ppj_access_key')
```

### Apis

API回调的参数见[主文档](https://ppninja.github.io/saas-docs/#introduction)，这里只注明 node.js sdk 中与主文档对应的请求

函数名|参数|说明
---|---|---
upload|filepath: string, callback: function|[创建Job](https://ppninja.github.io/saas-docs/#create)
status|token: string, callback: function|[查询特定Job](https://ppninja.github.io/saas-docs/#show)
download|token: string, path: string, callback: function|[下载产物](https://ppninja.github.io/saas-docs/#download)
list|params: array, callback: function|[获取所有Jobs](https://ppninja.github.io/saas-docs/#list)
quotas|callback: function|[查看可用额度](https://ppninja.github.io/saas-docs/#quotas)

### 仍有疑问？
请加QQ群（459962155）或微信（GockGe）咨询

### Rights
All Rights reserved to https://ppj.io.
