const express = require('express');
const router = express.Router();
const multer = require('multer');
const mysql = require('../mysql');
const checkAuth = require('../check-auth');

const upload = require('../upload');

router.get('/', (req, res, next) => {

    const sql = "SELECT * FROM module ;";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all modules",
            modules: result
        });
    });

});

router.get('/:moduleId', (req, res, next) => {

    const moduleId = req.params.moduleId;

    const sql = "SELECT * FROM module WHERE moduleId='" + moduleId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        console.log(result);
        res.status(200).json({
            message: "selected a module",
            module: result
        });
    });

});

router.post('/' ,upload.single('picture'), (req, res, next) => {

    const module = {
        moduleName: req.body.moduleName,
        picture: (req.file) ? req.file.filename : ""
    };

    const sql = "INSERT INTO module (moduleName,picture) VALUES ('" +
        module.moduleName + "','"+
        module.picture + "'"
        +");";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "module added",
                module: result
            });
        }
    });
});


router.put('/', (req, res, next) => {
    const module = {
        moduleId: req.body.moduleId,
        moduleName: req.body.moduleName,
        picture: (req.file) ? req.file.filename : ""
    };

    const sql = "UPDATE module SET"+
        " moduleName ='" + module.moduleName +
        "',picture ='" + student.picture +
        "' WHERE moduleId ='" + module.moduleId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(203).json({
            message: "module updated",
            module: module
        });
    });

});

router.delete('/:moduleId', (req, res, next) => {

    const sql = "DELETE FROM module WHERE \
                moduleId = '" + req.params.moduleId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "module deleted"
        });
    });

});

module.exports = router;