/**
 * Module dependencies
 */
const http = require("http");
const qs = require("querystring");

/**
 * Create server
 */
const server = http.createServer((req, res) => {
    if ('/' === req.url) {
        res.writeHead(200, {"Content-Type": "text/html"});
        res.end([
            '<form method="POST" action="/url">',
            '<h1>My Form</h1>',
            '<fieldset>', 
            '<label>Personal information</label>',
            '<p>What is your name?</p>',
            '<input type="text" name="name">',
            '<p><button>Submit</button></p>',
            '</fieldset>',
            '</form>'
        ].join(''));
    } else if ('/url' === req.url && 'POST' === req.method) {
        let body = "";
        req.on('data', (chunk) => {
            body += chunk;
        });
        req.on('end', () => {
            res.writeHead(200, {"Content-Type": "text/html"});
            res.end(
                '<p>Content-Type: ' + req.headers['content-type'] + '</p>' 
                + '<p>Data:</p><pre>' + qs.parse(body).name + '</pre>'
            );
        });
    } else {
        res.writeHead(404);
        res.end('Not Found');
    }
});

/**
 * Listen
 */
server.listen(3000);
