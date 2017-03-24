## ppj-saas

HTTP client for ppj saas api, node.js version.

Implemented based on [API v1](http://test.ppj.io/enterprise/docs/).

### install

_wait until publish to a node package_

### Run demo

```
npm install
```

modify index.js with your own APPID, APPSECRET & HOST

uncomment example code, and run with below

```
npm run start
```


### usage

``` javascript
import PPJClient from './lib/ppj_client';

let client = new PPJClient(APPID, APPSECRET, HOST);
```

#### Upload

```
let p = client.upload(/path/to/ppt/file)

// return a Promise Object
p.then((res) => {
  console.log(res.data);   //{'token': 'TOKEN'}
})
```

#### Status, Download, List
see `index.js`
