/**
 * Module dependencies
 */
const https = require("https");
const qs = require("querystring");

const search = process.argv.slice(2).join(' ').trim();

if (!search.length) {
    return console.log('\n Usage: node index.js <search term>\n');
}

const PROTO = 'https://';
const HOST = 'swapi.dev';
const PATH = '/api/people/?' + qs.stringify({search});

const url = new URL(PROTO + HOST + PATH);

console.log('\n  searching for: \033[96m' + search + '\033[39m\n');
console.log('\n  searching on: \033[96m' + url.toString() + '\033[39m\n');

// using .get() instead of .request() just makes it more explicit
// also you do not have to call .end() after .request();
https.get(url, (res) => {
    let body = '';
    res.setEncoding('utf8');
    res.on('data', (chunk) => {
        body += chunk;
    });
    res.on('end', () => {
        const obj = JSON.parse(body);
        obj.results.forEach((p) => {
            console.log('  \033[90m Name: ' + p.name + '\033[39m');
            console.log('  \033[94m Birth Year: ' + p['birth_year'] + '\033[39m');
            console.log('--');
        });
    });
});
