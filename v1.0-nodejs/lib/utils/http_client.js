import axios from 'axios';

export default class HttpClient {
    constructor(host) {
        this.host = host;
        this.client = axios.create({
            baseURL: host.replace(/\/$/, '')
        });
    }

    get(path, config) {
        return this.client.get(path, config);
    }

    post(path, data, config) {
        return this.client.post(path, data, config);
    }
}
