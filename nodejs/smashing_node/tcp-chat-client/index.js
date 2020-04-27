/**
 * Module dependencies
 */
const net = require("net");


/**
 * Create client
 */
// const client = net.connect(3000, 'localhost');
// client.on('connect', function () {})
//
// the above is equivalent to
// net.connect(3000, 'localhost', function() {});
//
// if a function is givent to .connect it is set
// to get called on the 'connect' event


const client = net.connect(6667, 'irc.freenode.net');
client.setEncoding('utf8');

// how to connect using irc protocol
client.on('connect', function() {
    client.write('NICK mynick\r\n');
    client.write('USER mynick 0 * :realname\r\n');
    client.write('JOIN #node.js\r\n');
});
