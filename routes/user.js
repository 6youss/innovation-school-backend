const express = require('express');
const router = express.Router();
const mysql = require('../mysql');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');


router.post('/signup', (req, res, next) => {

    var callBack = (err, hashedPassword) => {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else {
            const user = {
                userName: req.body.userName,
                password: hashedPassword,
                userType: req.body.userType,
                typeId: req.body.typeId
            };
            const sql = `INSERT INTO user (userName,password,userType,typeId) VALUES 
                ('${user.userName}',
                '${user.password}',
                '${user.userType}',
                '${user.typeId}');`
            mysql.query(sql, function (err, result) {
                if (err) next();
                else {
                    return res.status(201).json({
                        message: "user created",
                        user: user
                    });
                }
            });
        }
    }
    bcrypt.hash(req.body.password, 10, callBack);
});


router.post('/signin', (req, res, next) => {

    const sql = "SELECT * FROM user WHERE " +
        "userName='" + req.body.userName + "';";

    mysql.query(sql, function (err, user) {
        if (err) next;
        else {
            if (user.length < 1) {
                res.status(401).json({
                    error: "Auth Failed",
                });
            } else {
                bcrypt.compare(req.body.password, user[0].password, (err, result) => {
                    if (err) {
                        return res.status(401).json({
                            error: "Auth Failed",
                        });
                    }
                    if (result) {
                        const token = jwt.sign({
                                userName: user[0].userName,
                                userType: user[0].userType,
                                typeId: user[0].typeId,
                            },
                            "JWTPASSWORD@262qsddsqds", {
                                expiresIn: "1h"
                            }
                        );
                        return res.status(200).json({
                            message: "Auth successful",
                            token: token,
                            user: user
                        });
                    }
                    res.status(401).json({
                        error: "Auth Failed",
                    });
                });
            }
        }
    });

});

module.exports = router;