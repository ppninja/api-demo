// a demo
const PPJClient = require('./lib/index.js')

const client = new PPJClient('your_ppj_access_key', 'https://sandbox.ppj.io/api')

// demo for upload/create a job
// client.upload('/path/to/uploading/file.ppt', function (status, content) {
//   console.log(status, content)
// })

// demo for check a job status, token is responding by create a job
// client.status('token', function (status, content) {
//   console.log(status, content)
// })

// demo for download a job product
// client.download('token', '/path/to/save/output.zip', function (status, content) {
//   console.log(status, content)
// })

// demo for list all jobs
// client.list({ start_date: '2017-10-01' }, function (status, content) { console.log(status, content) })

// demo for list quotas
// client.quotas(function (status, content) { console.log(status, content) })
