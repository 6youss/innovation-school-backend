const express = require('express');
const router = express.Router();
const pdf = require('pdfkit');
const fs = require('fs');
const mysql = require('../mysql');
const checkAuth = require('../check-auth');


router.get('/', (req, res, next) => {
    
    res.writeHead( 200, {
        'Content-Type': 'application/pdf',
        'Content-Disposition': 'attachment; filename=test.pdf'
    } );
    const myDoc = new pdf();
    
    myDoc.font('Times-Roman')
        .fontSize(48)
        .text('hahaha',300,100);
    
    myDoc.pipe(res);
    myDoc.end();
});

function createPdf(res){
    //{ paymentId,studentId,groupId,paymentPrice,paymentDate,paymentDone,paymentDoneDate}
}

module.exports = router;