const express = require('express');
const router = express.Router();
const mysql = require('../mysql');
const checkAuth = require('../check-auth');
const upload = require('../upload');
const checkPayments = require('../check-payments');

router.get('/', (req, res, next) => {

    const sql = "SELECT * FROM student ;";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all students",
            students: result
        });
    });

},checkPayments);


router.get('/:studentId', (req, res, next) => {

    const studentId = req.params.studentId;

    const sql = "SELECT * FROM student WHERE studentId='" + studentId + "';";
    
    mysql.query(sql, function (err, result) {
        if (err) next();
        else
        res.status(200).json({
            message: "selected a student",
            student: result
        });
    });

});

router.get('/:studentId/payments', (req, res, next) => {

    const studentId = req.params.studentId;

    const sql =`SELECT p.paymentId,
                    p.studentId,
                    p.groupId,
                    p.paymentPrice,
                    DATE_FORMAT(p.paymentDate,'%Y/%m/%d') as paymentDate,
                    p.paymentDone,
                    p.paymentDoneDate,
                    pinfo.sessionCount,
                    DATE_FORMAT(pinfo.inscriptionDate,'%Y/%m/%d') as inscriptionDate,
                    moduleName
                FROM payment as p JOIN payment_info as pinfo 
                    ON p.studentId=pinfo.studentId AND p.groupId=pinfo.groupId
                    JOIN groupe as g ON pinfo.groupId=g.groupId
                    JOIN module as m ON g.moduleId=m.moduleId
                WHERE p.studentId='${studentId}';`;

    mysql.query(sql, function (err, result) {
        if (err) next();
        res.status(200).json({
            message: "selected student payments",
            payments: result
        });
    });

});


router.get('/:studentId/groups', (req, res, next) => {

    const studentId = req.params.studentId;

    const sql = `SELECT *
                FROM  groupe 
                WHERE groupId = (SELECT groupId 
                                    FROM study 
                                    WHERE studentId ='${studentId}');`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        console.log(result);
        res.status(200).json({
            message: "selected student groups",
            groups: result
        });
    });

});

router.get('/:studentId/sessions', (req, res, next) => {

    const studentId = req.params.studentId;

    const sql = `SELECT *
                FROM  session 
                WHERE groupId = (SELECT groupId 
                                    FROM study 
                                    WHERE studentId ='${studentId}');`

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        
        res.status(200).json({
            message: "selected student sessions",
            sessions: result
        });
    });

});

router.post('/',upload.single('picture'), (req, res, next) => {
    
    const student = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        picture: (req.file) ? req.file.filename : ""
    };

    const sql = `INSERT INTO student (firstName,lastName,picture) 
                VALUES (
                    CONCAT(UCASE(LEFT('${student.firstName}', 1)), 
                             LCASE(SUBSTRING('${student.firstName}', 2))),
                    UPPER('${student.lastName}'),
                    '${student.picture}'
                );`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "student added",
                student: student
            });
        }
    });


});

router.put('/:studentId', (req, res, next) => {

    const student = {
        studentId: req.params.studentId,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        picture: req.body.picture
    };

    console.log(req.body);

    const sql = "UPDATE student SET "+
        "firstName = '" + student.firstName +
        "',lastName ='" + student.lastName +
        "',picture ='" + student.picture +
        "' WHERE studentId ='" + student.studentId + 
        "';";

    console.log(sql);
    
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        
        res.status(203).json({
            message: "student updated",
            student: student
        });
    });

});

router.delete('/:studentId', (req, res, next) => {

    const sql = "DELETE FROM student WHERE \
                studentId = '" + req.params.studentId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "student deleted"
        });
    });

});

module.exports = router;