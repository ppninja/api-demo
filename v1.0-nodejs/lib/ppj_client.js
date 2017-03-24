import ApiBase from './api_base';
import md5File from 'md5-file';
import * as fs from 'fs';

export default class PPJClient {
    constructor(appid, appsecret, host) {
        this.api_base = new ApiBase(appid, appsecret, host);
    }

    // need refactor after further learning on Promise or async/await
    upload(file_path) {
        //check file exists
        let self = this;
        let result = new Promise((resolve, reject) => {
            fs.access(file_path, fs.R_OK, (err) => {
                if (err) {
                    reject({ err: err, msg: 'cannot open file' });
                    return;
                }

                self.api_base.post("/jobs", {
                    file_md5: md5File.sync(file_path),
                    file_source: fs.createReadStream(file_path)
                }).then((res) => {
                    resolve(res);
                }, (err) => {
                    reject(err);
                })
            })
        });

        return result;
    }

    status(token) {
        return this.api_base.get(`/jobs/${token}`, {
            token: token
        });
    }

    download(token) {
        return this.api_base.get(`/jobs/${token}/download`, {
            token: token
        }, {
            responseType: 'arraybuffer'
        });
    }

    list(params) {
        return this.api_base.get('/jobs', params);
    }
}
