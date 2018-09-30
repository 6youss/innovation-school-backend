const express = require('express');
const router = express.Router();
const pdf = require('pdfkit');
const fs = require('fs');
const mysql = require('../mysql');
const checkAuth = require('../check-auth');
const checkPayments = require('../check-payments');



router.get('/', checkPayments,(req, res, next) => {

    const sql = "SELECT * FROM payment;";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all payments",
            payment: result
        });
    });

});

router.get('/:paymentId', (req, res, next) => {

    const paymentId = req.params.paymentId;

    const sql = "SELECT * FROM payment WHERE paymentId='" + paymentId + "';";

    mysql.query(sql, function (err, result) {
        if (err) next();
        else{
            
            res.status(200).json({
                message: "selected a payment",
                payment: result
            });
        }
        
    });

});


router.post('/' , (req, res, next) => {

    const payment = {
        studentId: req.body.studentId,
        groupId: req.body.groupId,
        paymentPrice: req.body.paymentPrice,
        paymentDate: req.body.paymentDate?req.body.paymentDate:"CURRENT_TIMESTAMP",
        paymentDone: req.body.paymentDone?req.body.paymentDone:0
    };
    const sql = "INSERT INTO payment (studentId,groupId,paymentPrice,paymentDate,paymentDone) VALUES ('" +
        payment.studentId + "','" +
        payment.groupId + "','" +
        payment.paymentPrice + "'," + 
        payment.paymentDate + ",'" +
        payment.paymentDone + "'"
        +");";
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "payment added",
                payment: payment
            });
        }
    });
});


router.put('/', (req, res, next) => {

    const payment = {
        paymentId: req.body.paymentId,
        studentId: req.body.studentId,
        paymentPrice: req.body.paymentPrice,
        paymentDate: req.body.paymentDate,
        paymentDone: req.body.paymentDone
    };

    const sql = "UPDATE payment SET \
        studentId = '" + payment.studentId +
        "',paymentPrice ='" + payment.paymentPrice +
        "',paymentDate ='" + payment.paymentDate +
        "',paymentDone ='" + payment.paymentDone +
        "' WHERE paymentId ='" + payment.paymentId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(203).json({
            message: "payment updated",
            payment: payment
        });
    });

});

router.delete('/:paymentId', (req, res, next) => {

    const sql = "DELETE FROM payment WHERE \
                paymentId = '" + req.params.paymentId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "payment deleted"
        });
    });

});


//PAYMENT INFO
router.get('/info', (req, res, next) => {

    const sql = "SELECT * FROM payment_info ;";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all payments info",
            paymentInfo: result
        });
    });

});

router.get('/info/:groupId', (req, res, next) => {

    const groupId = req.params.groupId;

    const sql = "SELECT * FROM payment_info WHERE groupId='" + groupId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        console.log(result);
        res.status(200).json({
            message: "selected payment info of a group",
            paymentInfo: result
        });
    });

});

router.post('/info',(req, res, next) => {

    const paymentInfo = {
        studentId: req.body.studentId,
        groupId: req.body.groupId,
        sessionCount: req.body.sessionCount,
        paymentPrice: req.body.paymentPrice
    };
    const sql = "INSERT INTO payment_info (studentId,groupId,sessionCount,paymentPrice) VALUES ('" +
        paymentInfo.studentId + "','" +
        paymentInfo.groupId + "','" +
        paymentInfo.sessionCount + "','" +
        paymentInfo.paymentPrice + "'"
        +");";
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "payment info added for student",
                paymentInfo: paymentInfo
            });
        }
    });
});

module.exports = router;