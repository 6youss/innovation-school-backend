const http = require('http');
const app = require('./app');

const port = process.env.PORT || 3001;
const server = http.createServer(app);

let lower="dsd",upper="QDS";


[lower, upper] = [upper, lower]



console.log("Server listening on "+port);
server.listen(port);