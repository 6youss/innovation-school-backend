const express = require('express');
const router = express.Router();
const mysql = require('../mysql');
const checkAuth = require('../check-auth');


router.get('/', (req, res, next) => {

    const sql = `SELECT g.groupId,
                    g.level,
                    g.teacherId,
                    t.firstName,
                    t.lastName,
                    t.picture as teacherPicture,
                    m.moduleId,
                    m.moduleName,
                    m.picture as modulePicture
                FROM groupe AS g
                JOIN module AS m
                ON g.moduleId=m.moduleId
                JOIN teacher AS t
                ON g.teacherId = t.teacherId;`

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all groups",
            groups: result
        });
    });

});

router.get('/:groupId', (req, res, next) => {

    const groupId = req.params.groupId;

    const sql = `SELECT g.groupId,
                    g.level,
                    g.teacherId,
                    t.firstName,
                    t.lastName,
                    t.picture as teacherPicture,
                    m.moduleId,
                    m.moduleName,
                    m.picture as modulePicture
                FROM groupe AS g
                JOIN module AS m
                ON g.moduleId=m.moduleId
                JOIN teacher AS t
                ON g.teacherId = t.teacherId
                WHERE g.groupId='${groupId}';`;

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected a group",
            group: result
        });
    });

});

router.post('/' , (req, res, next) => {

    const group = {
        moduleId: req.body.moduleId,
        teacherId: req.body.teacherId,
        level: req.body.level
    };

    const sql = "INSERT INTO groupe (moduleId,teacherId,level) VALUES ('" +
        group.moduleId + "','" +
        group.teacherId + "','" +
        group.level + "'"
        +");";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "group added",
                group: result
            });
        }
    });
});


router.put('/', (req, res, next) => {

    const group = {
        moduleId: req.body.moduleId,
        teacherId: req.body.teacherId,
        level: req.body.level
    };

    const sql = "UPDATE groupe SET \
        moduleId = '" + group.moduleId +
        "',teacherId ='" + group.lastName +
        "',level ='" + group.level +
        "' WHERE groupId ='" + group.groupId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(203).json({
            message: "group updated",
            group: group
        });
    });

});

router.delete('/:groupId', (req, res, next) => {

    const sql = "DELETE FROM groupe WHERE \
                groupId = '" + req.params.groupId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "group deleted"
        });
    });

});

// STUDY
//get the students of a certain group
router.get('/:groupId/students', (req, res, next) => {

    const groupId = req.params.groupId;

    
    const sql = `SELECT * FROM student
                WHERE studentId IN (SELECT studentId FROM study
                                    WHERE groupId='${groupId}'
                                    );`
    const sql2 = `SELECT * FROM student
                WHERE studentId NOT IN (SELECT studentId FROM study
                                    WHERE groupId='${groupId}'
                                    );`
    mysql.query(sql+sql2, function (err, result) {
        if (err) throw err;
        
        res.status(200).json({
            message: "selected students of group "+groupId,
            students: result[0],
            otherStudents:result[1]
        });
    });

});

//get the sessions of a certain group
router.get('/:groupId/sessions', (req, res, next) => {

    const groupId = req.params.groupId;
    
    const sql = `SELECT 
                    sessionId,
                    roomId,
                    DATE_FORMAT(sessionDate ,'%W %d/%b/%Y %H:%i') as sessionDate,
                    sessionDone 
                FROM session
                WHERE groupId = '${groupId}';`

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected sessions of group "+groupId,
            sessions: result
        });
    });

});
//add student to a selected group
router.post('/:groupId/:studentId' , (req, res, next) => {

    const study = {
        groupId: req.params.groupId,
        studentId: req.params.studentId
    };

    const sql = "INSERT INTO study (groupId,studentId) VALUES ('" +
        study.groupId + "','" +
        study.studentId + "'"
        +");";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "added student to group",
                study: study
            });
        }
    });
});
//remove a student from a selected group
router.delete('/:groupId/:studentId', (req, res, next) => {

    const sql = "DELETE FROM study WHERE \
                groupId = '" + req.params.groupId +"' AND studentId = '" + req.params.studentId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "student deleted from group"
        });
    });

});


module.exports = router;