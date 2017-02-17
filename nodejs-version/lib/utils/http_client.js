import axios from 'axios';

export class HttpClient {
    constructor(host) {
        this.host = host;
        this.client = axios.create({
            baseURL: host.replace(/\/$/, '')
        });
    }

    get(path, params) {
        return this.client.get(path, {
            params: params
        });
    }

    post(path, data, params, headers) {
        return this.client.post(path, data, {
            params: params,
            headers: headers
        });
    }

    get_file(path, params) {
        return this.client.get(path, {
            params: params,
            responseType: 'arraybuffer'
        });
    }
}
