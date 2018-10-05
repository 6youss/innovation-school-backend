const express = require('express');
const router = express.Router();
const pdf = require('pdfkit');
const fs = require('fs');
const mysql = require('../mysql');
const checkAuth = require('../check-auth');

var tempDoc = new pdf({size:'A4'});

router.post('/', (req, res, next) => {

    const payments = req.body.payments;
    const validated = req.body.validated;

    if(validated === true){
        // console.log("validated !");
        // tempDoc.pipe(fs.createWriteStream('./bills/bill.pdf'));
        // tempDoc.end();
        // res.status(200).json({
        //     message:"added file"
        // });
    }else{
        const sql = `SELECT * FROM student WHERE studentId='${payments[0].studentId}';
        SELECT \`auto_increment\` FROM INFORMATION_SCHEMA.TABLES
        WHERE table_name = 'bill';`;
        mysql.query(sql,(err,result)=>{
            if(err) next();
            createPdf(payments,result[0][0],res,validated,result[1][0].AUTO_INCREMENT);
        });
    }


});

function createPdf(payments,student,res,validated,billNum){
    
    /**HEADER */
    const doc = new pdf({size:'A4'});
    const width=595.28,height=841.89/2;

    doc.image('./uploads/innovation-school.png', 50, 20, {width:150});

    doc.font('Times-Roman')
        .fontSize(10)
        .text("Innovation School\nCité 320 Logements Zone Urbaine\nN°01 Bat 04 Aprt 05.\ninnovation.school18@gmail.com\n0540 866 619",
            400,30,{width:200,align:'left',lineGap:4});

    doc.font('Times-Roman')
    .fontSize(15)
    .text(`${student.firstName} ${student.lastName}`,50,130,{width:200,align:'left',lineGap:5,continued:true})
    .fontSize(10)
    .text(`\nDate: ${new Date().toLocaleDateString("fr-FR")}\nFacture N°: ${billNum}`);
    
    let y=0;
    let total = 0;
    payments.forEach((payment,index) => {
        let lineGap= 25;
        y = (index+1)*lineGap+200;
        
        for(let i=0;i<5;i++){
            let x = i*(width-30)/5+15;    
            let text = ``;
            if(index==0){
                switch(i){
                    case 0: text = `Module`; break;
                    case 1: text = `Groupe`; break;
                    case 2: text = `Sessions`; break;
                    case 3: text = `Date`; break;
                    case 4: text = `Subtotal`; break;
                }
                doc.font('Times-Roman')
                .fontSize(10)
                .text(text,
                    x,y-lineGap,{width:(width-30)/5,align:'center'});
                
            }
            switch(i){
                case 0: text = payment[`moduleName`]; break;
                case 1: text = payment[`groupId`]; break;
                case 2: text = payment[`sessionCount`]; break;
                case 3: text = payment[`paymentDate`]; break;
                case 4: text = payment[`paymentPrice`].toLocaleString()+" DA"; break;
            }
            doc.font('Times-Roman')
            .fontSize(10)
            .text(text,
                x,y,{width:(width-30)/5,align:'center'});
            

        }
        total+=payment[`paymentPrice`];
    });

    doc.moveTo(50, 213)
    .lineTo(width-50, 213)
    .stroke();

    
    doc.rect(0, y+50, width, height-(y+50)).fill('#eee');

    doc.fill('#000');
    y+=80;
        
    doc.moveTo(50, y+13)
    .lineTo(width-50, y+13)
    .stroke();
    
    doc.font('Times-Roman')
    .fontSize(10)
    .text("Total",width-70,y,{width:50});
    
    doc.font('Times-Roman')
    .fontSize(15)
    .text(total.toLocaleString()+" DA",595-(width-50)/5-50,y+23,{width:(width-50)/5,align:'right'});

    doc.font('Times-Roman')
    .fontSize(10)
    .text("Thank you !",50,height-30);
    
    /**CREATE DOCUMENT */
    res.writeHead( 200, {
        'Content-Type': 'application/pdf',
        'Content-Disposition': 'attachment; filename=test.pdf'
    } );
    doc.pipe(fs.createWriteStream('./bills/bill.pdf'));
    doc.pipe(res);
    doc.end();
    // res.status(200).json({
    //     message:"added file"
    // });
}

module.exports = router;