SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE student;
DROP TABLE teacher;
DROP TABLE groupe;
DROP TABLE user;
DROP TABLE room;
DROP TABLE payment;
DROP TABLE module;
DROP TABLE study;
DROP TABLE teach;
DROP TABLE session;
DROP TABLE session_present;
DROP TABLE session_absent;
DROP TABLE payment_info;
DROP TABLE pay;
DROP TABLE bill;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE student (
    studentId integer PRIMARY KEY AUTO_INCREMENT,
    firstName varchar(40),
    lastName varchar(40),
    sex varchar(6),
    picture varchar(500),
    birthday DATE,
    adress varchar(500),
    phone integer,
    parentPhone integer,
    inscriptionDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE teacher (
    teacherId integer PRIMARY KEY AUTO_INCREMENT,
    firstName varchar(40),
    lastName varchar(40),
    sex varchar(6),
    picture varchar(500),
    birthday DATE,
    adress varchar(500),
    phone integer,
    inscriptionDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE module (
    moduleId integer PRIMARY KEY AUTO_INCREMENT,
    moduleName varchar(40),
    picture varchar(500)
);

CREATE TABLE room (
    roomId integer PRIMARY KEY,
    places integer
);

CREATE TABLE user (
    userName varchar(16) PRIMARY KEY,
    password varchar(500),
    userType INTEGER,
    typeId INTEGER
);

CREATE TABLE groupe (
    groupId integer PRIMARY KEY AUTO_INCREMENT,
    moduleId integer,
    teacherId integer,
    level varchar(40),
    groupName varchar(40),
    FOREIGN KEY (moduleId) REFERENCES module (moduleId)  ON DELETE CASCADE,
    FOREIGN KEY (teacherId) REFERENCES teacher (teacherId)  ON DELETE CASCADE
);

CREATE TABLE room (
    roomId integer PRIMARY KEY,
    places integer
);

CREATE TABLE session (
    sessionId integer PRIMARY KEY AUTO_INCREMENT,
    groupId integer,
    teacherId integer,
    roomId integer,
    sessionDate DATETIME,
    sessionDone integer DEFAULT 0,
    compensationOf integer,
    FOREIGN KEY (compensationOf) REFERENCES session(sessionId) ON DELETE CASCADE,
    FOREIGN KEY (groupId) REFERENCES groupe(groupId)  ON DELETE CASCADE,
    FOREIGN KEY (teacherId) REFERENCES teacher(teacherId)  ON DELETE SET NULL,
    FOREIGN KEY (roomId) REFERENCES room(roomId)  ON DELETE SET NULL
);

CREATE TABLE study (
    groupId integer,
    studentId integer,
    PRIMARY KEY (studentId, groupId),
    FOREIGN KEY (groupId) REFERENCES groupe(groupId) ON DELETE CASCADE,
    FOREIGN KEY (studentId) REFERENCES student(studentId) ON DELETE CASCADE
);


CREATE TABLE teach (
    sessionId integer,
    teacherId integer,
    PRIMARY KEY (teacherId, sessionId),
    FOREIGN KEY (sessionId) REFERENCES session(sessionId)  ON DELETE CASCADE,
    FOREIGN KEY (teacherId) REFERENCES teacher(teacherId)  ON DELETE CASCADE
);

CREATE TABLE payment (
    paymentId integer PRIMARY KEY AUTO_INCREMENT,
    studentId integer,
    groupId integer,
    paymentPrice integer,
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    paymentDone integer DEFAULT 0,
    paymentDoneDate DATETIME,
    FOREIGN KEY (studentId) REFERENCES student(studentId)  ON DELETE CASCADE,
    FOREIGN KEY (groupId) REFERENCES groupe(groupId) ON DELETE SET NULL
);

CREATE TABLE payment_info (
    studentId integer,
    groupId integer,
    sessionCount integer DEFAULT 1,
    paymentPrice integer,
    inscriptionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (studentId, groupId),
    FOREIGN KEY (groupId) REFERENCES groupe(groupId) ON DELETE CASCADE,
    FOREIGN KEY (studentId) REFERENCES student(studentId)  ON DELETE CASCADE
);

CREATE TABLE session_absent (
    studentId integer ,
    sessionId integer,
    reason varchar(500),
    PRIMARY KEY (studentId, sessionId),
    FOREIGN KEY (studentId) REFERENCES student (studentId) ON DELETE CASCADE,
    FOREIGN KEY (sessionId) REFERENCES session (sessionId) ON DELETE CASCADE
);

CREATE TABLE session_present(
    studentId integer ,
    sessionId integer,
    evaluation varchar(10),
    observation varchar(500),
    PRIMARY KEY (studentId, sessionId),
    FOREIGN KEY (studentId) REFERENCES student (studentId) ON DELETE CASCADE,
    FOREIGN KEY (sessionId) REFERENCES session (sessionId)  ON DELETE CASCADE
);

CREATE TABLE bill(
    billId integer PRIMARY KEY AUTO_INCREMENT,
    studentId integer,
    totalPrice integer,
    billDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (studentId) REFERENCES student(studentId) ON DELETE CASCADE
);

CREATE TABLE pay (
    billId integer,
    paymentId integer,
    PRIMARY KEY (billId, paymentId),
    FOREIGN KEY (billId) REFERENCES bill(billId) ON DELETE CASCADE,
    FOREIGN KEY (paymentId) REFERENCES payment(paymentId) ON DELETE CASCADE
);


CREATE VIEW session_number AS
SELECT  pi.studentId,
        pi.groupId,
        pi.sessionCount,
        pi.paymentPrice,
        count(s.sessionId) as sessionsDoneCount,
        DATE(pi.inscriptionDate) as inscriptionDate
FROM
student as p JOIN payment_info as pi ON p.studentId=pi.studentId
JOIN session as s ON pi.groupId=s.groupId
WHERE s.sessionDone='1'
GROUP BY pi.studentId;

CREATE VIEW session_paid AS
SELECT p.studentId,
       p.groupId,
       SUM(p.paymentPrice) as totalPaid,
       SUM(p.paymentPrice) DIV pi.paymentPrice as sessionsPaidCount,
       MAX(DATE(p.paymentDate)) as paymentDate,
       DATEDIFF(CURRENT_TIMESTAMP,MAX(p.paymentDate)) as dayDiff
FROM
payment as p JOIN payment_info as pi ON p.studentId = pi.studentId
GROUP BY p.studentId;

CREATE VIEW groupe_info AS
SELECT g.groupId,
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
ON g.teacherId = t.teacherId;



SELECT `auto_increment` FROM INFORMATION_SCHEMA.TABLES
WHERE table_name = 'bill';

SELECT 'AUTO_INCREMENT' FROM INFORMATION_SCHEMA.TABLES
                WHERE table_name = 'bill';

SELECT DATE_FORMAT(sessionDate ,'%W %d/%b/%Y')


-- CREATE TRIGGER pay_del BEFORE DELETE ON payment
-- FOR EACH ROW 
-- BEGIN
--     DELETE FROM pay WHERE paymentId = OLD.paymentId;
-- END;

-- //deleting bill
-- CREATE TRIGGER bill_del BEFORE DELETE ON bill
-- FOR EACH ROW 
-- BEGIN
--     DELETE FROM pay WHERE billId = OLD.billId;
-- END;

-- //delete student from group
-- CREATE TRIGGER study_del BEFORE DELETE ON study
-- FOR EACH ROW 
-- BEGIN
--     DELETE FROM payment_info WHERE studentId = OLD.studentId;
-- END;

-- //deleting student
-- CREATE TRIGGER stu_del BEFORE DELETE ON student
-- FOR EACH ROW 
-- BEGIN
--     DELETE FROM bill WHERE studentId = OLD.studentId;
--     DELETE FROM payment WHERE studentId = OLD.studentId;
--     DELETE FROM study WHERE studentId=OLD.studentId;
-- END;

select COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME
from information_schema.KEY_COLUMN_USAGE
where TABLE_NAME = 'bill';

/*
    faire l'autentification ,
    ajouter une forme pour l'ajout des paiements
*/