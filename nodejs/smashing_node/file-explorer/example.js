const fs = require("fs");

// to obtain the current working directory
console.log(process.cwd())

// to change the directory
process.chdir("/");
console.log(process.cwd());

// access environment variables
console.log(process.env);

// communicate with the operating system through signals
// signal the process to terminate use SIGKILL
process.on("SIGKILL", function () {
    // signall received
});

// reads the entire file, puts it in memory
// then fires the callback
fs.readFile(__dirname + "/package.json", function (err, contents) {
    // do something with file
});

// use streams to read files in incremental chunks, not reading the
// entire file into memory
const stream = fs.createReadStream("package.json");
stream.on("data", function (chunk) {
    // do something with part of the file
});
stream.on("end", function(chunk) {
    // reached the end
});

// watch files example
const exStream = fs.createReadStream("index.js");
// get all files in working directory
const files = fs.readdirSync(process.cwd());
files.forEach(function (file) {
    // watch the file if it ends in ".css"
    if (/\.css/.test(file)) {
        fs.watchFile(process.cwd() + "/" + file, function () {
            console.log(' - ' + file + ' changed!');
        });
    }
});

// exit a program, and optionally supply an exit code
// it is good practice to provide a code of 1
console.log("exiting");
process.exit(1);
