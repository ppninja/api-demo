import { HttpClient } from './utils/http_client';
import { Signature } from './utils/signature';

export class ApiBase {
    constructor(appid, appsecret, host) {
        this.appid = appid;
        this.appsecret = appsecret;
        this.host = host;

        this.http_client = new HttpClient(host);
        this.signature = new Signature(appid, appsecret);
    }

    add_signature_to_params(verb, path, params = {}){
        let timestamp = Math.floor(Date.now() / 1000);
        let signature = this.signature.sign(verb, path, params, timestamp);

        params['X-Ppj-Credential'] = this.appid;
        params['X-Ppj-Timestamp'] = timestamp;
        params['X-Ppj-Signature'] = signature;

        return params;
    }

    post(path, data, params = {}, headers= {}) {
        params = this.add_signature_to_params('POST', path, params);
        return this.http_client.post(path, data, params, headers);
    }

    get(path, params = {}) {
        params = this.add_signature_to_params('GET', path, params);
        return this.http_client.get(path, params);
    }

    get_file(path, params = {}){
        params = this.add_signature_to_params('GET', path, params);
        return this.http_client.get_file(path, params);
    }
}
