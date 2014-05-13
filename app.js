// modules
var http = require('http')
  , hdb = require('hdb');

// client
var client = hdb.createClient({host: process.env.HANAIO_HOST, port: parseInt(process.env.HANAIO_PORT), user: process.env.HANAIO_USER, password: process.env.HANAIO_PASS});

// server
http.createServer(function (req, res) {
    client.connect(function (err) {
        if (err) {
            res.writeHead(500, {'Content-Type': 'text/plain'});
            res.end('Connection failed! ' + err);
            return;
        } 
        client.exec('SELECT CURRENT_TIMESTAMP "time" FROM DUMMY', function (err, rows) {
            client.end();
            if (err) {
                res.writeHead(500, {'Content-Type': 'text/plain'});
                res.end('Execution failed! ' + err);
                return;
            }
            res.writeHead(200, {'Content-Type': 'text/plain'});
            res.end(JSON.stringify(rows));
        });
    });
}).listen(2000);

console.log("listening");
