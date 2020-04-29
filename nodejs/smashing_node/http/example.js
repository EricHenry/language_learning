
const http = require("http");
const fs = require("fs");

http.createServer(function(req, res) {
    // default Content-Type -> text/plain 
    res.writeHead(200);
    res.end("Hello World");
}).listen(3000);

http.createServer(function(req, res) {
    // we are sending over html, so we need to change the 
    // content type of the header to text/html to tell
    // the requester that we are responding with html
    // making the header appropriate in relation to the
    // content its sending over
    res.writeHead(200, {"Content-Type": "text/html"});
    res.end("Hello <b>World</b>");
}).listen(3001);

http.createServer(function(req, res) {
    // default value for header property "Transerfer-Encoding"
    // is set to "chunked"
    // this is important because responses can be created progressively
    res.writeHead(200);
    res.write("Hello");

    setTimeout(function () {
        res.end("World");
    }, 500);

}).listen(3002)

http.createServer(function(req, res) {
    // writing in "chunks" is also useful when the file system
    // is involved. writing in chunks composes well with reading
    // from the file system in chunks. Leveraging "ReadStream"
    //
    // this ends up being more efficient in memory allocation
    res.writeHead(200, {"Content-Type": "image/png"});
    const stream = fs.createReadStream("image.png");
    stream.on("data", function(data) {
        res.write(data);
    });
    stream.on("end", function () {
        res.end();
    });
}).listen(3003);

http.createServer(function(req, res) {
    // since reading from the file system and writing
    // a response both use streams, that means they can 
    // be composed together
    //
    // streams can be composed using the pipe function
    res.writeHead(200, {"Content-Type": "image/png"});
    const stream = fs.createReadStream("image.png");
    stream.pipe(res);
}).listen(3004);

// http.createServer(function(req, res) {}).listen(3003);