var mysql = require('mysql');
const fs = require('fs');
const update=false;

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    multipleStatements: true
});

con.connect(function (err) {
    if (err) throw err;
    //update the database structure when necessary
    if(update){
        fs.readFile('./db-update.txt','utf8',(err,data)=>{
            if(err){
                console.log(err)
            }
            con.query(data,function(err,res){
                if(err) throw err;
            });
        });
    }
});



module.exports = con;