const express = require('express');
const router = express.Router();
const mysql = require('../mysql');
const checkAuth = require('../check-auth');
const upload = require('../upload');
const checkPayments = require('../check-payments');

router.get('/', (req, res, next) => {

    const sql = "SELECT * FROM student ;";

    mysql.query(sql, function (err, result) {
        if (err) next(err);
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
                FROM  groupe_info
                WHERE groupId IN (SELECT groupId 
                                    FROM study 
                                    WHERE studentId ='${studentId}');`;

    mysql.query(sql, function (err, result) {
        if (err) next(err);
        
        res.status(200).json({
            message: "selected student groups",
            groups: result
        });
    });

});

router.get('/:studentId/sessions', (req, res, next) => {

    const studentId = req.params.studentId;

    const sql = `SELECT sessionId,
                        groupId,
                        roomId,
                        DATE_FORMAT(sessionDate,'%Y/%m/%d') as sessionDate,
                        sessionDone,
                        compensationOf,
                        teacherId,
                (SELECT m.moduleName
                    from module as m
                    WHERE m.moduleId IN (SELECT g.moduleId 
                                         FROM groupe as g 
                                         WHERE g.groupId=s.groupId)) as moduleName
                FROM  session as s
                WHERE groupId IN (SELECT groupId 
                                    FROM study 
                                    WHERE studentId ='${studentId}');`

    mysql.query(sql, function (err, result) {
        if (err) {
            
            next();
        }
        
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
        picture: (req.file) ? req.file.filename : "",
        birthday: (req.body.birthday) ? req.body.birthday : "0",
        adress: (req.body.adress) ? req.body.adress : "",
        phone: (req.body.phone) ? req.body.phone : 0,
        parentPhone: (req.body.parentPhone) ? req.body.parentPhone : 0,
    };
    
    const sql = `INSERT INTO student 
                (firstName,lastName,picture,birthday,adress,phone,parentPhone) 
                VALUES (
                    CONCAT( UCASE(LEFT('${student.firstName}', 1)),LCASE(SUBSTRING('${student.firstName}',2))),
                    UPPER('${student.lastName}'),
                    '${student.picture}',
                    '${student.birthday}',
                    '${student.adress}',
                    '${student.phone}',
                    '${student.parentPhone}'
                );`;
    //STR_TO_DATE('${student.birthday}','%d/%m/%Y'),
    mysql.query(sql, function (err, result) {
        if (err) next(err);
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

    const sql = "UPDATE student SET "+
        "firstName = '" + student.firstName +
        "',lastName ='" + student.lastName +
        "',picture ='" + student.picture +
        "' WHERE studentId ='" + student.studentId + 
        "';";

    mysql.query(sql, function (err, result) {
        if (err) next(err);
        
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
        if (err) next(err);
        else
        res.status(203).json({
            message: "student deleted"
        });
    });

});

module.exports = router;