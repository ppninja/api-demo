// We need this to build our post string
var querystring = require('querystring');
var http = require('http');
var request = require('request');
var fs = require('fs');
var md5File = require('md5-file');

var filepath = 'test1.pptx';

var HOST = '';
var APPID = '';

queries = querystring.stringify({
    file_md5: md5File.sync(filepath),
    'X-Ppj-Mode': 'test',
    'X-Ppj-Credential': APPID
})
console.log(queries);

var req = request.post(HOST + "/api/job/create?" + queries, function(err, resp, body){
    if (err) {
    console.log('Error!');
  } else {
    console.log('URL: ' + body);
  }
})
var form = req.form();
form.append('file_source', fs.createReadStream(filepath));
