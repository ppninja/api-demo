const request = require('request');
const queryString = require('query-string');

class ApiBase {
  constructor(accesskey, host) {
    this.accesskey = accesskey
    this.host = host
  }

  post(path, formData, cb) {
    var options = {
      url: this.host + path,
      method: 'POST',
      headers: {
        'X-PPJ-Credential': this.accesskey
      },
      formData: formData
    }

    request(options, function (error, response, body) {
      if (typeof cb === 'function') cb(response.statusCode, body)
    })
  }

  get(path, params, cb) {
    var query = params ? '?' + queryString.stringify(params) : '';
    var options = {
      url: this.host + path + query,
      headers: {
        'X-PPJ-Credential': this.accesskey
      }
    };

    request(options, function (error, response, body) {
      if (typeof cb === 'function') cb(response.statusCode, body)
    })
  }
}

module.exports = ApiBase
