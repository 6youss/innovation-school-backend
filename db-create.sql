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
    inscriptionDate DATE DEFAULT CURDATE()
                ON UPDATE CURDATE()
);

CREATE TABLE study (
    groupId integer,
    studentId integer,
    PRIMARY KEY (studentId, groupId),
    FOREIGN KEY (groupId) REFERENCES groupe(groupId),
    FOREIGN KEY (studentId) REFERENCES student(studentId)
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
    inscriptionDate DATE DEFAULT CURDATE()
                ON UPDATE CURDATE()
);

CREATE TABLE teach (
    sessionId integer,
    teacherId integer,
    PRIMARY KEY (teacherId, sessionId),
    FOREIGN KEY (sessionId) REFERENCES session(sessionId),
    FOREIGN KEY (teacherId) REFERENCES teacher(teacherId)
);

CREATE TABLE payment (
    paymentId integer PRIMARY KEY AUTO_INCREMENT,
    studentId integer,
    groupId integer,
    paymentPrice integer,
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    paymentDone integer DEFAULT 0,
    paymentDoneDate DATETIME,
    FOREIGN KEY (studentId) REFERENCES student(studentId),
    FOREIGN KEY (groupId) REFERENCES groupe(groupId)
);

CREATE TABLE payment_info (
    studentId integer,
    groupId integer,
    sessionCount integer DEFAULT 1,
    paymentPrice integer,
    inscriptionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (studentId, groupId),
    FOREIGN KEY (groupId) REFERENCES groupe(groupId),
    FOREIGN KEY (studentId) REFERENCES student(studentId)
);
 

CREATE TABLE groupe (
    groupId integer PRIMARY KEY AUTO_INCREMENT,
    moduleId integer,
    teacherId integer,
    level varchar(40),
    groupName varchar(40),
    FOREIGN KEY (moduleId) REFERENCES module (moduleId),
    FOREIGN KEY (teacherId) REFERENCES teacher (teacherId)
);

CREATE TABLE module (
    moduleId integer PRIMARY KEY AUTO_INCREMENT,
    moduleName varchar(40)
);

CREATE TABLE session_absent (
    studentId integer ,
    sessionId integer,
    reason varchar(500),
    PRIMARY KEY (studentId, sessionId),
    FOREIGN KEY (studentId) REFERENCES student (studentId),
    FOREIGN KEY (sessionId) REFERENCES session (sessionId)
);

CREATE TABLE session_present (
    studentId integer ,
    sessionId integer,
    evaluation varchar(10),
    observation varchar(500),
    PRIMARY KEY (studentId, sessionId),
    FOREIGN KEY (studentId) REFERENCES student (studentId),
    FOREIGN KEY (sessionId) REFERENCES session (sessionId)
);

CREATE TABLE session (
    sessionId integer PRIMARY KEY AUTO_INCREMENT,
    groupId integer,
    teacherId integer,
    roomId integer,
    sessionDate DATETIME,
    sessionDone integer DEFAULT 0,
    compensationOf integer,
    FOREIGN KEY (compensationOf) REFERENCES session(sessionId),
    FOREIGN KEY (groupId) REFERENCES groupe(groupId),
    FOREIGN KEY (teacherId) REFERENCES teacher(teacherId),
    FOREIGN KEY (roomId) REFERENCES room(roomId)
);

CREATE TABLE room (
    roomId integer PRIMARY KEY,
    places integer
);

CREATE TABLE user (
    email varchar(256) PRIMARY KEY,
    userId integer UNIQUE,
    password varchar(500)
);

CREATE TABLE bill(
    billId integer PRIMARY KEY AUTO_INCREMENT,
    studentId integer,
    totalPrice integer,
    billDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (studentId) REFERENCES student(studentId)
);

CREATE TABLE pay (
    billId integer,
    paymentId integer,
    PRIMARY KEY (billId, paymentId),
    FOREIGN KEY (billId) REFERENCES bill(billId),
    FOREIGN KEY (paymentId) REFERENCES payment(paymentId)
);


//trigger when deleting a groupe,student

ALTER TABLE student MODIFY picture VARCHAR(500);

SELECT * 
FROM student
WHERE studentId IN (SELECT studentId FROM study
                    WHERE groupId='2'
                    );

SELECT * 
FROM student
WHERE studentId IN (SELECT studentId FROM session_present
                    WHERE sessionId='5'
                    );

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
ON g.teacherId = t.teacherId
WHERE g.groupId='2';


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


INSERT INTO session 
(groupId,roomId,sessionDate) 
VALUES ('1',
        '26',
        CURRENT_TIMESTAMP
);

SELECT DATE_FORMAT(sessionDate ,'%W %d/%b/%Y')
from session;

ALTER TABLE session ADD teacherId integer; 
ALTER TABLE session ADD CONSTRAINT FOREIGN KEY (teacherId) REFERENCES teacher(teacherId);

ALTER TABLE payment_info ADD inscriptionDate DATE;

ALTER TABLE payment_info MODIFY COLUMN inscriptionDate DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE payment_info MODIFY COLUMN sessionCount integer DEFAULT 1;

update payment_info set inscriptionDate=CURRENT_TIMESTAMP where groupId='1';

truncate session_present;
truncate session_absent;
truncate study;
truncate payment_info;
truncate payment;

select * from session;
delete from session where sessionId='';


select *
FROM
session as se JOIN study st ON se.groupId=st.groupId
WHERE studentId='1';

SELECT *
FROM  session 
WHERE groupId = (SELECT groupId 
                     FROM study 
                     WHERE studentId ='1');

SELECT *
FROM  groupe 
WHERE groupId = (SELECT groupId 
                     FROM study 
                     WHERE studentId ='1');