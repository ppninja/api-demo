const fs = require('fs')
const md5File = require('md5-file')

const ApiBase = require('./api_base')

class PPJClient {
  constructor(accesskey, host = 'https://sandbox.ppj.io/api') {
    this.api_base = new ApiBase(accesskey, host);
  }

  // need refactor after further learning on Promise or async/await
  upload(file_path, callback) {
    callback = callback || function () {}
    this.api_base.post(`/jobs`, {
      file_source: fs.createReadStream(file_path),
      file_md5: md5File.sync(file_path)
    }, callback)
  }

  status(token, callback) {
    callback = callback || function () {}
    this.api_base.get(`/jobs/${token}`, null, callback)
  }

  download(token, path, callback) {
    callback = callback || function () {}
    this.api_base.get(`/jobs/${token}/download`, null, function (status, content) {
      if (status === 200) {
        fs.writeFile(path, content, function (err) {
          if (err) throw err;
          callback(status, path)
        })
      } else {
        callback(status, content)
      }
    })
  }

  list(params, callback) {
    callback = callback || function () {}

    this.api_base.get('/jobs', params, callback);
  }

  quotas(callback) {
    callback = callback || function () {}
    this.api_base.get('/quotas', null, callback)
  }
}
module.exports = PPJClient
