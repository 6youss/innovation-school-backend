const express = require('express');
const app = express();
const bodyParser = require('body-parser');

const studentRoutes = require('./routes/student');
const teacherRoutes = require('./routes/teacher');
const userRoutes = require('./routes/user');
const moduleRoutes = require('./routes/module');
const groupRoutes = require('./routes/group');
const paymentRoutes = require('./routes/payment');
const sessionRoutes = require('./routes/session');
const roomRoutes = require('./routes/room');
const billRoutes = require('./routes/bill');

const checkPayments = require('./check-payments');


app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(bodyParser.json());

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Origin, Authorization,\
                                                 Accept, Client-Security-Token, Accept-Encoding');
    if(req.method ==='OPTIONS'){
        res.header('Access-Control-Allow-Methods','PATCH, PUT, GET, POST, DELETE');
        return res.status(200).json({});
    }
    next();
});



app.use('/student', studentRoutes);
app.use('/teacher', teacherRoutes);
app.use('/group', groupRoutes);
app.use('/user', userRoutes);
app.use('/module', moduleRoutes);
app.use('/payment', paymentRoutes);
app.use('/session', sessionRoutes);
app.use('/room', roomRoutes);
app.use('/bill', billRoutes);

app.use('/uploads', express.static('uploads'));
app.use('/bills', express.static('bills'));
app.use('/checkpayments', checkPayments);

app.use((req, res, next) => {
    const error = new Error('Not found');
    error.status = 404;
    next(error);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    res.json({
        error: {
            message: error.message
        }
    });
});

module.exports = app;