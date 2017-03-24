import HttpClient from './utils/http_client';
import Signature from './utils/signature';
import FormData from 'form-data';

class Request {
    constructor(method, path, params) {
        this.method = method;
        this.path = path;
        this.parameters = params;
    }
}

const versionHeaders = {
    'Accept': 'application/vnd.ppj.v1+json'
}

export default class ApiBase {
    constructor(appid, appsecret, host) {
        this.appid = appid;
        this.appsecret = appsecret;
        this.host = host;

        this.http_client = new HttpClient(host);
        this.signature = new Signature(appsecret);
    }

    authentication_headers(request) {
        let timestamp = Math.floor(Date.now() / 1000);
        let signature = this.signature.sign(request, timestamp);

        return {
            'X-PPJ-Credential': this.appid,
            'X-PPJ-Timestamp': timestamp,
            'X-PPJ-Signature': signature
        }
    }

    post(path, params, extraConfig) {
        // all post request using FormData
        let data = new FormData();
        console.log('params', params);
        Object.keys(params).forEach(function(key) {
            data.append(key, params[key]);
        })
        let headers = Object.assign({}, versionHeaders, data.getHeaders(), this.authentication_headers(new Request('POST', path, params)));

        let config = Object.assign({}, extraConfig, { headers: headers });

        return this.http_client.post(path, data, config);
    }

    get(path, params, extraConfig) {
        let headers = Object.assign({}, versionHeaders, this.authentication_headers(new Request('GET', path, params)));

        let config = Object.assign({}, extraConfig, { params: params, headers: headers });

        return this.http_client.get(path, config);
    }
}
