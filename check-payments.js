const mysql = require('./mysql');
const express = require('express');
const router = express.Router();

 router.get('/',(req,res,next)=>{
    
    const sql = `SELECT * FROM session_number;
                SELECT * FROM session_paid;`;
    
    let info=null,paid=null;
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
          info=result[0];
          paid=result[1];
          res.status(200).json({
            message: "Checking payments",
            info,
            paid
        });
        }
    });
});

module.exports = router;

/*
    //sessionCount > 0
    1-count the sessions done for each student
    if the (sessionCount % info.sessionCount === 0) then there's a new payment

        for doing that : 
            - we should estimate how much his payments are worth 
                by converting their price to sessions
            - if the (sessionCount > worthOfPayment) && the condition mentioned above
                then we can generate a new payment
                
*/
