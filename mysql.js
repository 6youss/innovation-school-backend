
var mysql = require('mysql');

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "Moonswing15",
    database: "innovation_school",
    multipleStatements: true
});

con.connect(function (err) {
    if (err) throw err;
    console.log("DB Connected!");
    
});

module.exports = con;