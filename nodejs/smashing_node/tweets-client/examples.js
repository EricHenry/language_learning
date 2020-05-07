/**
 * Module dependencies
 */
const http = require("http");

/*
 * using request to call for data
 */

// Server
http.createServer((req, res) => {
        res.writeHead(200);
        res.end('Hello World');
    })
    .listen(3000);

// client
http.request(
    { host: '127.0.0.1', port: 3000, url: '/', method: 'GET' }, 
    (res) => { 
        let body = '';
        res.setEncoding('utf8');
        res.on('data', (chunk) => {
            body += chunk;
        });
        res.on('end', () => {
            console.log('\n We got: \033[96m' + body + '\033[39m\n');
        });
    }
).end();
