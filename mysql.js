var mysql = require('mysql');
const fs = require('fs');
const update=true;

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "Moonswing15",
    database: "innovation_school",
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