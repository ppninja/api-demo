import * as crypto from 'crypto';

const IgnoreParamters = ['file_source'];

function sign_parameters(request) {
    let params = request.parameters;

    return Object.keys(params).filter(function(val) {
        return !(val.startsWith('_') || IgnoreParamters.indexOf(val) >= 0);
    }).sort().map(function(key) {
        return `${key}=${params[key]}`;
    }).join('&');
}

function sign_text(request) {
    return `${request.method}\n${request.path}\n${sign_parameters(request)}`;
}

export default class Signature {
    constructor(appsecret) {
        this.appsecret = appsecret;
    }

    sign(request, timestamp) {
        console.log('start to generate signature', timestamp);

        let sign_text_result = sign_text(request);
        console.log('sign_text: ', sign_text_result);

        let sign_key = crypto.createHmac('sha256', timestamp + "").update(this.appsecret).digest('hex');
        console.log('sign_key: ', sign_key);

        let signature = crypto.createHmac('sha256', sign_key).update(sign_text_result).digest('hex');
        console.log('result signature: ', signature);

        return signature;
    }
}
