/**
 * Module dependencies
 */
const http = require("http");
const qs = require("querystring");

/**
 * Server
 */
http.createServer((req, res) => {
    let body = "";
    req.on('data', (chunk) => {
        body += chunk;
    });
    req.on('end', () => {
        res.writeHead(200);
        res.end('Done');
        console.log('\n We got: \033[96m' + qs.parse(body).name + '\033[39m\n');
    });
})
.listen(3000);
