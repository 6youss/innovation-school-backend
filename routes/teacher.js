const express = require('express');
const router = express.Router();
const multer = require('multer');
const mysql = require('../mysql');
const checkAuth = require('../check-auth');

const upload = require('../upload');


router.get('/', (req, res, next) => {

    const sql = "SELECT * FROM teacher ;";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all teachers",
            teachers: result
        });
    });

});

router.get('/:teacherId', (req, res, next) => {

    const teacherId = req.params.teacherId;

    const sql = "SELECT * FROM teacher WHERE teacherId='" + teacherId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        console.log(result);
        res.status(200).json({
            message: "selected a teacher",
            teacher: result
        });
    });

});

router.get('/:teacherId/sessions', (req, res, next) => {

    const teacherId = req.params.teacherId;

    const sql =`SELECT *
                FROM session
                WHERE teacherId='${teacherId}'
                ORDER BY groupId,sessionDate DESC;`;

    mysql.query(sql, function (err, result) {
        if (err) next();
        res.status(200).json({
            message: "selected teacher sessions",
            sessions: result
        });
    });

});

router.post('/', upload.single('teacherPic'), (req, res, next) => {

    const teacher = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        picture: (req.file) ? req.file.filename : "",
        birthday: (req.body.birthday) ? req.body.birthday : "0",
        adress: (req.body.adress) ? req.body.adress : "",
        phone: (req.body.phone) ? req.body.phone : 0,
    };

    const sql = `INSERT INTO teacher 
                (firstName,lastName,picture,birthday,adress,phone) 
                VALUES (
                    CONCAT( UCASE(LEFT('${teacher.firstName}', 1)),LCASE(SUBSTRING('${teacher.firstName}',2))),
                    UPPER('${teacher.lastName}'),
                    '${teacher.picture}',
                    '${teacher.birthday}',
                    '${teacher.adress}',
                    '${teacher.phone}'
                );`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "Teacher Added",
                teacher: teacher
            });
        }
    });
});

router.put('/', (req, res, next) => {

    const teacher = {
        teacherId: req.body.teacherId,
        firstName: req.body.firstName,
        lastName: req.body.lastName
    };

    const sql = "UPDATE teacher SET \
                firstName = '" + teacher.firstName +
        "',lastName ='" + teacher.lastName +
        "' WHERE teacherId ='" + teacher.teacherId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        console.log(result);
        res.status(203).json({
            message: "Teacher updated",
            teacher: teacher
        });
    });

});

router.delete('/:teacherId', (req, res, next) => {

    const sql = "DELETE FROM teacher WHERE \
                teacherId = '" + req.params.teacherId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "Teacher deleted"
        });
    });

});

//TEACH
router.post('/teach', (req, res, next) => {

    const teach = {
        teacherId: req.body.teacherId,
        sessionId: req.body.sessionId
    };

    const sql = "INSERT INTO teach (teacherId,sessionId) VALUES ('" +
        teach.teacherId + "','" +
        teach.sessionId + "'"
        +");";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "teacher teaches session",
                teacher: teacher
            });
        }
    });
});

module.exports = router;