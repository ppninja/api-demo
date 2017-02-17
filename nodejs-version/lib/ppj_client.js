import { ApiBase } from './api_base';
import md5File from 'md5-file';
import FormData from 'form-data';
import * as fs from 'fs';

export class PpjClient {
    constructor(appid, appsecret, host) {
        this.api_base = new ApiBase(appid, appsecret, host);
    }

    upload(file_path, callback) {
        //check file exists
        let self = this;
        fs.access(file_path, fs.R_OK, (err) => {
            if (err) {
                console.log('file cannot be accessed/read.');
                return;
            }
            var params = {
                file_md5: md5File.sync(file_path)
            }

            var data = new FormData();
            data.append('file_source', fs.createReadStream(file_path));
            var headers = data.getHeaders();

            self.api_base.post("/api/job/create", data, params, headers).then((res) => {
                if (res.status == 200) {
                    console.log(res.data);
                    if (typeof(callback) === 'function') {
                        callback(res.data);
                    }
                }
            }).catch((err) => {
                console.log(err);
            });
        })
    }

    download(token, save_path) {
        let path = "/api/job/download";
        this.api_base.get_file(path, {
            token: token
        }).then((res) => {
            if (res.status == 200 && res.headers['content-type'] == 'application/zip') {
                if (/\/$/.test(save_path)) save_path = save_path + token + '.zip';

                fs.writeFile(save_path, res.data, (res) => {
                    console.log(res);
                });
            }
        }).catch((err) => {
            console.log(err);
        })
    }

    list(params, callback) {
        let path = "/api/job/list";
        this.api_base.get(path, params).then((res) => {
            if (res.status == 200) {
                if (typeof(callback) === 'function') {
                    callback(res.data);
                }
            }
        }).catch((err) => {
            console.log(err);
        })
    }

    status(token, callback) {
        let path = "/api/job/status";
        this.api_base.get(path, {
            token: token
        }).then((res) => {
            if (res.status == 200) {
                if (typeof(callback) === 'function') {
                    callback(res.data);
                }
            }
        }).catch((err) => {
            console.log(err);
        })
    }
}
