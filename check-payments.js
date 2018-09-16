const mysql = require('./mysql');
const express = require('express');
//const router = express.Router();

module.exports = (req, res, next) => {

    const sql = `SELECT * FROM session_number;
                SELECT * FROM session_paid;`;

    let info = null,
        paid = null;
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else {
            info = result[0];
            paid = result[1];

            const newinfo = {};
            const newpaid = {};

            paid.forEach(paid => {
                newpaid[paid.studentId] = paid;
            });

            info.forEach(info => {
                newinfo[info.studentId] = info;
            });

            Object.keys(newinfo).forEach((key, index) => {

                const {
                    studentId,
                    groupId,
                    sessionCount,
                    paymentPrice,
                    sessionsDoneCount
                } = newinfo[key];
                
                const {
                    sessionsPaidCount,
                    dayDiff
                } = newpaid[key];

                const payment = {
                    studentId,
                    groupId,
                    paymentPrice: paymentPrice *
                        sessionCount
                };

                if (sessionCount > 1) { //this means that the payment is not per month
                    //if student studied more then he paid we add a payment
                    if (sessionsDoneCount >= sessionsPaidCount) {
                        addPayment(payment);
                    } 
                } else {
                    //month sessions
                    if (dayDiff >= 30 * sessionsPaidCount) {
                        addPayment(payment);
                    }
                }
            });
            // res.status(200).json({
            //     message: "Checking payments",
            //     newinfo,
            //     newpaid
            // });
            next();
        }
    });
}

function addPayment(payment) {

    const sql = "INSERT INTO payment (studentId,groupId,paymentPrice,paymentDate,paymentDone) VALUES ('" +
        payment.studentId + "','" +
        payment.groupId + "','" +
        payment.paymentPrice + "'," +
        payment.paymentDate + ",'" +
        payment.paymentDone + "'" +
        ");";
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else {
            console.log("added new payment");
            // res.status(201).json({
            //     message: "payment added",
            //     payment: payment
            // });
            // next();
        }
    });

}

//module.exports = router;

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