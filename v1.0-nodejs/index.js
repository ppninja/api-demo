import * as fs from 'fs';
import PPJClient from './lib/ppj_client';

const APPID = '';
const APPSECRET = '';
const HOST = '';

let client = new PPJClient(APPID, APPSECRET, HOST);

// upload example
const FILE_PATH = '/path/to/file';
client.upload(FILE_PATH).then((res)=>{
    console.log(res.headers['content-type']);

    console.log(res.data);
}, (err)=>{
    console.log('error', err);
})

//status example
// client.status("7Y5Lby615TXBdwqX").then((res)=>{
//     console.log(res.headers['content-type']);
//
//     console.log(res.data);
// })

// download example
// let path = '/Users/daggerjames/Downloads/test/test.zip';
// client.download("7Y5Lby615TXBdwqX").then((res) => {
//     console.log(res.headers['content-disposition']);
//     console.log(res.headers['content-type']);
//
//     fs.writeFile(path, res.data, () => {
//         console.log(`write to path: ${path}`);
//     });
// })

// list example
// client.list().then((res)=>{
//     console.log(res.headers['content-type']);
//
//     console.log(res.data);
// })
// client.list({state: 'completed'}).then((res)=>{
//     console.log(res.data);
// })
//
// client.list({start_date: '2017-03-24T15:20:02+08:00'}).then((res)=>{
//     console.log(res.data);
// })
