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

router.post('/', upload.single('teacherPic'), (req, res, next) => {

    const teacher = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        picture: (req.file) ? req.file.path : ""
    };

    const sql = "INSERT INTO teacher (firstName,lastName,picture) VALUES ('" +
        teacher.firstName + "','" +
        teacher.lastName + "','" +
        teacher.picture + "'"
        +");";

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