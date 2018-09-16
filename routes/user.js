const express = require('express');
const router = express.Router();
const mysql = require('../mysql');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');


router.post('/signup', (req, res, next) => {

    bcrypt.hash(req.body.password, 10, callBack);
    
    var callBack = (err, hashedPassword) => {
        if (err) {
            return res.status(500).json({
                error: err
            });
        } else {

            const user = {
                email: req.body.email,
                password: hashedPassword,
                userId: req.body.userId
            };

            const sql = "INSERT INTO user (email,password,userId) VALUES ('" +
                user.email + "','" +
                user.password + "','" +
                user.userId + "'" +
                ");";
                
            mysql.query(sql, function (err, result) {
                if (err) throw err;
                else {
                    res.status(201).json({
                        message: "user created",
                        user: user
                    });
                }
            });
        }
    }
});


router.post('/signin', (req, res, next) => {

    console.log(req.body);
    
    const sql = "SELECT * FROM user WHERE " +
        "email='" + req.body.email + "';";

    mysql.query(sql, function (err, user) {
        if (err) throw err;
        else {
            if (user.length < 1) {
                res.status(401).json({
                    message: "Auth Failed",
                });
            } else {
                bcrypt.compare(req.body.password, user[0].password, (err, result) => {
                    if (err) {
                        return res.status(401).json({
                            message: "Auth Failed",
                        });
                    }
                    if (result) {
                        const token = jwt.sign({
                                email: user[0].email,
                                userId: user[0].userId
                            },
                            "JWTPASSWORD", {
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
                        message: "Auth Failed",
                    });
                });
            }
        }
    });

});

module.exports = router;