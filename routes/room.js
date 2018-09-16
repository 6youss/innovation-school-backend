const express = require('express');
const router = express.Router();

const mysql = require('../mysql');
const checkAuth = require('../check-auth');




router.get('/', (req, res, next) => {

    const sql = "SELECT * FROM room ;";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(200).json({
            message: "selected all rooms",
            rooms: result
        });
    });

});

router.get('/:roomId', (req, res, next) => {

    const roomId = req.params.roomId;

    const sql = "SELECT * FROM room WHERE roomId='" + roomId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        console.log(result);
        res.status(200).json({
            message: "selected a room",
            room: result
        });
    });

});

router.post('/' , (req, res, next) => {

    const room = {
        roomId: req.body.roomId,
        places: req.body.places,
    };

    const sql = "INSERT INTO room (roomId,places) VALUES ('" +
        room.roomId + "','" +
        room.places + "'"
        +");";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else{
            res.status(201).json({
                message: "room added",
                room: room
            });
        }
    });
});


router.put('/', (req, res, next) => {

    const room = {
        roomId: req.body.roomId,
        places: req.body.places
    };

    const sql = "UPDATE room SET \
        roomId = '" + room.roomId +
        "',places ='" + room.lastName +
        "' WHERE roomId ='" + room.roomId + "';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        res.status(203).json({
            message: "room updated",
            room: room
        });
    });

});

router.delete('/:roomId', (req, res, next) => {

    const sql = "DELETE FROM room WHERE \
                roomId = '" + req.params.roomId +"';";

    mysql.query(sql, function (err, result) {
        if (err) throw err;
        else
        res.status(203).json({
            message: "room deleted"
        });
    });

});

module.exports = router;