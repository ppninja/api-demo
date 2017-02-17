import * as crypto from 'crypto';

// step 1
function filter_params(queries) {
    return Object.keys(queries).sort().map(function(k) {
        return encodeURIComponent(k) + "=" + encodeURIComponent(queries[k])
    }).join("&")
}

// step 2
function get_str_to_sign(http_verb, path, filtered_params) {
    return http_verb + "\n" + path + "\n" + filtered_params;
}

// step 3
function derive_key(timestamp, appsecret) {
    return crypto.createHmac('sha256', timestamp + "").update(appsecret).digest('hex');
}

export class Signature {
    constructor(appid, appsecret) {
        this.appid = appid;
        this.appsecret = appsecret;
    }

    sign(http_verb, path, params, timestamp) {
        let filtered_params = filter_params(params);
        let str_to_sign = get_str_to_sign(http_verb, path, filtered_params);
        let derived_key = derive_key(timestamp, this.appsecret);

        return crypto.createHmac('sha256', derived_key).update(str_to_sign).digest('hex');
    }


}
