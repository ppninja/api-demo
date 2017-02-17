import { PpjClient } from './lib/ppj_client';

let path = "/path/to/ppt/file";

let client = new PpjClient('appid', 'appsecret', 'host');

//上传
client.upload(path, (res) => {
    console.log(res);
});

//查询状态  e.g. token is 'YhyfTjk3zUfuZbxN'
client.status("token_responded_with_upload", (res) => {
    console.log(res);
});

// for list
// params {} could be filter
// e.g.
// status:      'completed'
// start_date: '20170101'
// end_date: '20170102'
client.list({}, (res)=>{
    console.log(res);
})

// for download
client.download("token_responded_with_upload", 'path_to_save_zip_file');
