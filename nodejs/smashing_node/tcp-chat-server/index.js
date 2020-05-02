/**
 * Module dependencies
 */
const net = require("net");

/**
 * state
 */
let count = 0;
let users = {};

/**
 * Create server.
 */
const server = net.createServer(function (conn) {
    // handle connection
    console.log('\33[90m    new connection!\033[39m');
    conn.setEncoding('utf8');
    conn.write(
        '\n > welcome to \033[92mnode-chat\033[39m!'
      + '\n > ' + count + ' other people are connected at this time.'
      + '\n > please write your name and press enter: '
    );

    count++;
    // the nickname for the current connection
    let nickname;

    conn.on('data', function (data) {
        // remove the "enter" character
        data = data.replace('\r\n', '');

        // the first piece of data you expect is the nickname
        if (!nickname) {
            // make sure the nickname is not in use
            if (users[data]) {
                conn.write('\033[93m> nickname already in use. try again:\033[39m ');
                return;
            } else {
                nickname = data;
                users[nickname] = conn;

                // inform all the users someone has joined
                broadcast('\033[90m > ' + nickname + ' joined the room\033[39m\n');
            }
        } else {
            // otherwise consider it a chat message
            broadcast('\033[96m > ' + nickname + ':\033[39m ' + data + '\n', true);
        }
        console.log(data);
    });
    conn.on('close', function() {
        count--;
        broadcast('\033[90m > ' + nickname + ' left the room\033[39m\n');
    });

    function broadcast (msg, excludeSelf) {
        for (let u in users) {
            if (!excludeSelf || u != nickname) {
                users[u].write(msg);
            }
        }
    }
});


/**
 * Listen.
 */

 server.listen(3000, function() {
     console.log("\033[96m    server listening on *:3000\033[39m");
 });
