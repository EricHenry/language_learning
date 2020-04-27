/**
 * Module dependencies
 */

const fs = require('fs');
const {stdin, stdout} = process;
// three Stream objects that match the three Unix Standard Streams
// **stdin**: Standard input, readable stream
// **stdout**: Standard output, writeable stream
// **stderr**: Standard error, writeable stream

// sync
//console.log("read dir sync: ", fs.readdirSync(__dirname));

// async
//function async (err, files) { console.log("asynct read dir", files); }
//fs.readdir(__dirname, async);

fs.readdir(process.cwd(), function (err, files) {
    console.log('');

    if (!files.length) {
        return console.log('    \033[31m No files to show!\033[39m\n');
    }

    console.log('    Select which file or directory you want to see\n');

    file(0);

    let stats = [];

    // called for each file walked in the directory
    function file(i) {
        let filename = files[i];

        fs.stat(__dirname + '/' + filename, function (err, stat) {
            stats[i] = stat;

            if (stat.isDirectory()) {
                console.log('    '+i+'    \033[36m' + filename + '/\033[39m');
            } else {
                console.log('    '+i+'    \033[90m' + filename + '\033[39m');
            }

            if (++i == files.length) {
                read()
            } else {
                file(i);
            }
        }); 
    }

    // read user input when files are shown
    function read() {
        console.log('');
        stdout.write('    \033[33mEnter your choice: \33[39m');

        stdin.resume();
        stdin.setEncoding("utf8")

        stdin.on("data", option);
    }

    function option(data) {
        const chosenFile = Number(data);
        const filename = files[chosenFile];
        if (!filename) {
            stdout.write('    \033[31mEnter your choice: \033[39');
        } else {
            stdin.pause();
            // check if the chosen file is a directory
            if (stats[chosenFile].isDirectory()) {
                fs.readdir(__dirname + '/' + filename, function (err, files) {
                    console.log('');
                    console.log('    (' + files.length + ' files)');
                    files.forEach(function (file) {
                        console.log('    -  ' + file);
                    });
                    console.log('');
                })
            } else {
                fs.readFile(__dirname + '/' + filename, 'utf8', function (err, data) {
                    console.log('');
                    console.log('\033[90' + data.replace(/(.*)/g, '    $1') + '\033[39m');
                });
            }
        }
    }
});