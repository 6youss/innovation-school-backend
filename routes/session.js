const express = require('express');
const router = express.Router();

const mysql = require('../mysql');
const checkAuth = require('../check-auth');

router.get('/', (req, res, next) => {
    
    const sql = `SELECT sessionId,
                    groupId,
                    roomId,
                    DATE_FORMAT(sessionDate,'%Y/%m/%d %H:%i') as sessionDate,
                    sessionDone,
                    compensationOf,
                    teacherId
                FROM session;`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all sessions",
            session: result
        });
        next();
    });

});

router.get('/:sessionId', (req, res, next) => {

    const sessionId = req.params.sessionId;

    const sql = `SELECT sessionId,
                        groupId,
                        roomId,
                        DATE_FORMAT(sessionDate,'%Y/%m/%d %H:%i') as sessionDate,
                        sessionDone,
                        compensationOf,
                        teacherId
                FROM session 
                WHERE sessionId='${sessionId}';`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected a session",
            session: result
        });
    });

});

router.get('/:sessionId/students', (req, res, next) => {

    const sessionId = req.params.sessionId;

    const sql = `SELECT * 
                FROM student
                WHERE studentId IN (SELECT studentId FROM session_present
                                    WHERE sessionId='${sessionId}'
                                    );`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected students of session",
            students: result
        });
    });

});

router.get('/:sessionId/reviews', (req, res, next) => {

    const sessionId = req.params.sessionId;

    const sql = `SELECT * 
                FROM session_present
                WHERE sessionId='${sessionId}';`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected student reviews of session",
            reviews: result
        });
    });

});

router.post('/' , (req, res, next) => {

    const session = {
        groupId: req.body.groupId,
        roomId: req.body.roomId,
        sessionDate: req.body.sessionDate
    };

    const sql = "INSERT INTO session (groupId,roomId,sessionDate) VALUES ('" +
        session.groupId + "','" +
        session.roomId + "','" +
        session.sessionDate + "'"
        +");";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "session added",
                session: session
            });
        }
    });
});


router.put('/', (req, res, next) => {

    const session = {
        sessionId: req.body.sessionId,
        groupId: req.body.groupId,
        roomId: req.body.roomId,
        sessionDate: req.body.sessionDate,
        sessionDone:req.body.sessionDone
    };

    const sql = "UPDATE session SET \
        groupId = '" + session.groupId +
        "',roomId ='" + session.roomId +
        "',sessionDate ='" + session.sessionDate +
        "',sessionDone ='" + session.sessionDone +
        "' WHERE sessionId ='" + session.sessionId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(203).json({
            message: "session updated",
            session: session
        });
        next();
    });

});

router.delete('/:sessionId', (req, res, next) => {

    const sql = "DELETE FROM session WHERE \
                sessionId = '" + req.params.sessionId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "session deleted"
        });
    });

});


//mark a student as absent in a specific session
router.post('/:sessionId/absent' , (req, res, next) => {

    const absent = {
        sessionId: req.params.sessionId,
        studentId: req.body.studentId,
        reason: req.body.reason?req.body.reason:""
    };

    const sql = `INSERT INTO session_present (sessionId,studentId,evaluation,observation) VALUES (
                    '${present.sessionId}',
                    '${present.studentId}',
                    '${present.evaluation}',
                    '${present.observation}'
                );`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "marked a student as absent in session",
                absent: absent
            });
        }
    });
});

//mark a student as present in a specific session
router.post('/:sessionId/present' , (req, res, next) => {

    const present = {
        sessionId: req.params.sessionId,
        studentId: req.body.studentId,
        evaluation: req.body.evaluation?req.body.evaluation:"Medium",
        observation: req.body.observation?req.body.observation:"Not given",
    };

    const sql = `INSERT INTO session_present (sessionId,studentId,evaluation,observation) VALUES (
                    '${present.sessionId}',
                    '${present.studentId}',
                    '${present.evaluation}',
                    '${present.observation}'
                );`;
    console.log(sql);    
    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "marked a student as present in session",
                present: present
            });
        }
    });
});

router.put('/:sessionId/present' , (req, res, next) => {

    const present = {
        sessionId: req.params.sessionId,
        studentId: req.body.studentId,
        evaluation: req.body.evaluation,
        observation: req.body.observation,
    };

    const sql = `UPDATE session_present SET
                    evaluation='${present.evaluation}',
                    observation='${present.observation}'
                WHERE sessionId='${present.sessionId}'
                      AND studentId='${present.studentId}';`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "edited the presence",
                present: present
            });
        }
    });
});

module.exports = router;