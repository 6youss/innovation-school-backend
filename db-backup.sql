-- MySQL dump 10.13  Distrib 8.0.12, for Win64 (x86_64)
--
-- Host: localhost    Database: innovation_school
-- ------------------------------------------------------
-- Server version	8.0.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `bill` (
  `billId` int(11) NOT NULL AUTO_INCREMENT,
  `studentId` int(11) DEFAULT NULL,
  `totalPrice` int(11) DEFAULT NULL,
  `billDate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`billId`),
  KEY `studentId` (`studentId`),
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`studentId`) REFERENCES `student` (`studentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupe`
--

DROP TABLE IF EXISTS `groupe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `groupe` (
  `groupId` int(11) NOT NULL AUTO_INCREMENT,
  `moduleId` int(11) DEFAULT NULL,
  `teacherId` int(11) DEFAULT NULL,
  `level` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`groupId`),
  KEY `moduleId` (`moduleId`),
  KEY `teacherId` (`teacherId`),
  CONSTRAINT `groupe_ibfk_1` FOREIGN KEY (`moduleId`) REFERENCES `module` (`moduleid`),
  CONSTRAINT `groupe_ibfk_2` FOREIGN KEY (`teacherId`) REFERENCES `teacher` (`teacherid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupe`
--

LOCK TABLES `groupe` WRITE;
/*!40000 ALTER TABLE `groupe` DISABLE KEYS */;
INSERT INTO `groupe` VALUES (1,1,1,'A1'),(2,1,1,'A2'),(3,1,1,'C2'),(4,2,1,'A1'),(5,2,1,'A1'),(6,2,1,'B2'),(7,1,1,'A2');
/*!40000 ALTER TABLE `groupe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `groupe_info`
--

DROP TABLE IF EXISTS `groupe_info`;
/*!50001 DROP VIEW IF EXISTS `groupe_info`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `groupe_info` AS SELECT 
 1 AS `groupId`,
 1 AS `level`,
 1 AS `teacherId`,
 1 AS `firstName`,
 1 AS `lastName`,
 1 AS `teacherPicture`,
 1 AS `moduleId`,
 1 AS `moduleName`,
 1 AS `modulePicture`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `module` (
  `moduleId` int(11) NOT NULL AUTO_INCREMENT,
  `moduleName` varchar(40) DEFAULT NULL,
  `picture` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`moduleId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module`
--

LOCK TABLES `module` WRITE;
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` VALUES (1,'french',''),(2,'english',''),(3,'',''),(4,'english','1536035649570.png'),(5,'lotfi','1537613312870.jpeg'),(6,'teeeeest','1537969078670.jpeg'),(7,'coucoux',''),(8,'coucouxxx',''),(9,'coucouxxx',''),(10,'coucouxxx',''),(11,'coucouxxx',''),(12,'coucouxxx',''),(13,'coucouxxx','');
/*!40000 ALTER TABLE `module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pay`
--

DROP TABLE IF EXISTS `pay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pay` (
  `billId` int(11) NOT NULL,
  `paymentId` int(11) NOT NULL,
  PRIMARY KEY (`billId`,`paymentId`),
  KEY `paymentId` (`paymentId`),
  CONSTRAINT `pay_ibfk_1` FOREIGN KEY (`billId`) REFERENCES `bill` (`billid`),
  CONSTRAINT `pay_ibfk_2` FOREIGN KEY (`paymentId`) REFERENCES `payment` (`paymentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pay`
--

LOCK TABLES `pay` WRITE;
/*!40000 ALTER TABLE `pay` DISABLE KEYS */;
/*!40000 ALTER TABLE `pay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `payment` (
  `paymentId` int(11) NOT NULL AUTO_INCREMENT,
  `studentId` int(11) DEFAULT NULL,
  `groupId` int(11) DEFAULT NULL,
  `paymentPrice` int(11) DEFAULT NULL,
  `paymentDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `paymentDone` int(11) DEFAULT '0',
  `paymentDoneDate` datetime DEFAULT NULL,
  PRIMARY KEY (`paymentId`),
  KEY `studentId` (`studentId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`studentId`) REFERENCES `student` (`studentid`),
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `groupe` (`groupid`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,1,7500,'2018-09-16 01:52:40',0,NULL),(2,2,1,7500,'2018-09-16 01:52:40',0,NULL),(3,3,1,7500,'2018-09-16 01:52:40',0,NULL),(4,1,1,7500,'2018-09-16 17:59:12',0,NULL),(5,2,1,7500,'2018-09-16 17:59:12',0,NULL),(6,3,1,7500,'2018-09-16 17:59:12',0,NULL),(7,1,1,7500,'2018-09-16 17:59:47',0,NULL),(8,2,1,7500,'2018-09-16 17:59:47',0,NULL),(9,3,1,7500,'2018-09-16 17:59:47',0,NULL),(10,5,2,7500,'2018-10-10 22:40:15',0,NULL),(11,3,2,7500,'2018-10-10 22:40:15',0,NULL),(12,12,2,7500,'2018-10-10 22:40:15',0,NULL);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_info`
--

DROP TABLE IF EXISTS `payment_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `payment_info` (
  `studentId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `sessionCount` int(11) DEFAULT '1',
  `paymentPrice` int(11) DEFAULT NULL,
  `inscriptionDate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`studentId`,`groupId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `payment_info_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `groupe` (`groupid`),
  CONSTRAINT `payment_info_ibfk_2` FOREIGN KEY (`studentId`) REFERENCES `student` (`studentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_info`
--

LOCK TABLES `payment_info` WRITE;
/*!40000 ALTER TABLE `payment_info` DISABLE KEYS */;
INSERT INTO `payment_info` VALUES (1,1,3,2500,'2018-09-16 01:52:40'),(2,1,3,2500,'2018-09-16 01:52:40'),(3,1,3,2500,'2018-09-16 01:52:40'),(3,2,5,1500,'2018-10-10 22:40:15'),(5,2,5,1500,'2018-10-10 22:40:15'),(12,2,5,1500,'2018-10-10 22:40:15');
/*!40000 ALTER TABLE `payment_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reported_session`
--

DROP TABLE IF EXISTS `reported_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `reported_session` (
  `sessionId` int(11) NOT NULL,
  `roomId` int(11) DEFAULT NULL,
  `reportedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`sessionId`),
  KEY `roomId` (`roomId`),
  CONSTRAINT `reported_session_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `session` (`sessionid`),
  CONSTRAINT `reported_session_ibfk_2` FOREIGN KEY (`roomId`) REFERENCES `room` (`roomid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reported_session`
--

LOCK TABLES `reported_session` WRITE;
/*!40000 ALTER TABLE `reported_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `reported_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `room` (
  `roomId` int(11) NOT NULL,
  `places` int(11) DEFAULT NULL,
  PRIMARY KEY (`roomId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (25,16),(26,18),(27,151);
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `session` (
  `sessionId` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `roomId` int(11) DEFAULT NULL,
  `sessionDate` datetime DEFAULT NULL,
  `sessionDone` int(11) DEFAULT '0',
  `compensationOf` int(11) DEFAULT NULL,
  `teacherId` int(11) DEFAULT NULL,
  PRIMARY KEY (`sessionId`),
  KEY `groupId` (`groupId`),
  KEY `roomId` (`roomId`),
  KEY `compensationOf` (`compensationOf`),
  KEY `teacherId` (`teacherId`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `groupe` (`groupid`),
  CONSTRAINT `session_ibfk_2` FOREIGN KEY (`roomId`) REFERENCES `room` (`roomid`),
  CONSTRAINT `session_ibfk_3` FOREIGN KEY (`compensationOf`) REFERENCES `session` (`sessionid`),
  CONSTRAINT `session_ibfk_4` FOREIGN KEY (`teacherId`) REFERENCES `teacher` (`teacherid`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES (16,1,25,'2018-10-08 12:00:00',1,NULL,1),(17,1,25,'2018-10-09 12:00:00',1,NULL,1),(18,1,25,'2018-10-10 12:00:00',1,NULL,1),(19,1,25,'2018-10-11 12:00:00',1,NULL,1),(20,1,25,'2018-10-12 12:00:00',1,NULL,1),(21,1,25,'2018-10-13 12:00:00',1,NULL,1);
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_absent`
--

DROP TABLE IF EXISTS `session_absent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `session_absent` (
  `studentId` int(11) NOT NULL,
  `sessionId` int(11) NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`studentId`,`sessionId`),
  KEY `sessionId` (`sessionId`),
  CONSTRAINT `session_absent_ibfk_1` FOREIGN KEY (`studentId`) REFERENCES `student` (`studentid`),
  CONSTRAINT `session_absent_ibfk_2` FOREIGN KEY (`sessionId`) REFERENCES `session` (`sessionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_absent`
--

LOCK TABLES `session_absent` WRITE;
/*!40000 ALTER TABLE `session_absent` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_absent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `session_number`
--

DROP TABLE IF EXISTS `session_number`;
/*!50001 DROP VIEW IF EXISTS `session_number`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `session_number` AS SELECT 
 1 AS `studentId`,
 1 AS `groupId`,
 1 AS `sessionCount`,
 1 AS `paymentPrice`,
 1 AS `sessionsDoneCount`,
 1 AS `inscriptionDate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `session_paid`
--

DROP TABLE IF EXISTS `session_paid`;
/*!50001 DROP VIEW IF EXISTS `session_paid`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `session_paid` AS SELECT 
 1 AS `studentId`,
 1 AS `groupId`,
 1 AS `totalPaid`,
 1 AS `sessionsPaidCount`,
 1 AS `paymentDate`,
 1 AS `dayDiff`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `session_present`
--

DROP TABLE IF EXISTS `session_present`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `session_present` (
  `studentId` int(11) NOT NULL,
  `sessionId` int(11) NOT NULL,
  `evaluation` varchar(10) DEFAULT NULL,
  `observation` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`studentId`,`sessionId`),
  KEY `sessionId` (`sessionId`),
  CONSTRAINT `session_present_ibfk_1` FOREIGN KEY (`studentId`) REFERENCES `student` (`studentid`),
  CONSTRAINT `session_present_ibfk_2` FOREIGN KEY (`sessionId`) REFERENCES `session` (`sessionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_present`
--

LOCK TABLES `session_present` WRITE;
/*!40000 ALTER TABLE `session_present` DISABLE KEYS */;
INSERT INTO `session_present` VALUES (1,16,'Medium','Not given'),(1,17,'Medium','Not given'),(1,18,'Medium','Not given'),(1,19,'Medium','Not given'),(1,20,'Medium','Not given'),(1,21,'Weak','Not given'),(2,16,'Medium','Not given'),(2,17,'Medium','Not given'),(2,18,'Medium','Not given'),(2,19,'Medium','Not given'),(2,20,'Medium','Not given'),(2,21,'Good','yes yes'),(3,16,'Medium','Not given'),(3,17,'Medium','Not given'),(3,18,'Medium','Not given'),(3,19,'Medium','Not given'),(3,20,'Medium','Not given'),(3,21,'Weak','Not given');
/*!40000 ALTER TABLE `session_present` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `student` (
  `studentId` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(40) DEFAULT NULL,
  `lastName` varchar(40) DEFAULT NULL,
  `picture` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`studentId`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'mehdi','kho','IMG_1146.jpg'),(2,'zakaria','sifouane',NULL),(3,'undefined','undefined',NULL),(4,'coucoux','hihi',NULL),(5,'coucoux','hihi',NULL),(6,'coucoux','hihi',NULL),(7,'coucoux','hihi',NULL),(8,'coucoux','hihi',NULL),(11,'jojo','undefined','req.file.path'),(12,'jojo','undefined',''),(13,'jojo','undefined',''),(14,'test@test.com','password',''),(15,'test@test.com','password',''),(16,'test@test.com','password',''),(17,'test@test.com','password',''),(18,'test@test.com','password',''),(19,'mohamed','cheref',''),(20,'mohamed','cheref',''),(21,'mehdi','kho',''),(22,'Youcef','Zahariou',''),(23,'youcef','zahariou',''),(24,'Youcef','Zahariou','uploadsYoucefZahariou1535638660759'),(25,'Youcef','Zahariou','uploadsYoucefZahariou1535638679985'),(26,'Youcef','Zahariou','uploadsYoucefZahariou1535638856156.jpeg'),(27,'Youcef','Zahariou','uploadsYoucefZahariou1535638913669.jpeg'),(28,'Youcef','Zahariou','uploadsYoucefZahariou1535639377311.jpeg'),(29,'Youcef','Zahariou','uploadsYoucefZahariou1535639489757.png'),(30,'Youcef','Zahariou','uploadsYoucefZahariou1535639979730.png'),(31,'undefined','ho','uploadsundefinedho1535640493410.png'),(32,'undefined','ho','uploadsundefinedho1535640565521.png'),(33,'undefined','qsdqsd',''),(34,'dsqd','ddd','uploadsdsqdddd1535641063523.png'),(35,'dsqd','ddd','uploadsdsqdddd1535641080500.png'),(36,'jijel','ziama','jijelziama1535641143515.jpeg'),(37,'coucouuu','hiiiii','coucouuuhiiiii1535816983727.png'),(38,'habiba','zahariou','habibazahariou1535818486936.jpeg'),(39,'hey','mmaaaan','heymmaaaan1535853360575.jpeg'),(40,'jiji','jojo','jijijojo1535853502364.png'),(41,'qsddc','dqsfs','qsddcdqsfs1535854259716.jpeg'),(42,'undefined','undefined',''),(43,'undefined','undefined',''),(44,'fdqsd','qsdqsd','fdqsdqsdqsd1535863002371.jpeg'),(45,'fdqsd','qsdqsd','fdqsdqsdqsd1535863024596.jpeg'),(46,'qsdsqdd','dqsddddd','1535985557074.jpeg'),(47,'qsdsqdd','dqsddddd','1535985597970.jpeg'),(48,'lotfi','bouchama','1537613250126.jpeg'),(49,'yesyes','YESYES',''),(50,'yesyes','YESYES',''),(51,'Yesyesyes','YESYESYES',''),(52,'','UNDEFINED',''),(53,'Undefined','UNDEFINED',''),(54,'Undefined','UNDEFINED',''),(55,'Undefined','UNDEFINED',''),(56,'','UNDEFINED',''),(57,'','UNDEFINED',''),(58,'','UNDEFINED',''),(59,'Undefined','UNDEFINED',''),(60,'Undefined','UNDEFINED','');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study`
--

DROP TABLE IF EXISTS `study`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `study` (
  `groupId` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  PRIMARY KEY (`studentId`,`groupId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `study_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `groupe` (`groupid`),
  CONSTRAINT `study_ibfk_2` FOREIGN KEY (`studentId`) REFERENCES `student` (`studentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study`
--

LOCK TABLES `study` WRITE;
/*!40000 ALTER TABLE `study` DISABLE KEYS */;
INSERT INTO `study` VALUES (1,1),(1,2),(1,3),(2,3),(2,5),(2,12);
/*!40000 ALTER TABLE `study` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teach`
--

DROP TABLE IF EXISTS `teach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `teach` (
  `sessionId` int(11) NOT NULL,
  `teacherId` int(11) NOT NULL,
  PRIMARY KEY (`teacherId`,`sessionId`),
  KEY `sessionId` (`sessionId`),
  CONSTRAINT `teach_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `session` (`sessionid`),
  CONSTRAINT `teach_ibfk_2` FOREIGN KEY (`teacherId`) REFERENCES `teacher` (`teacherid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teach`
--

LOCK TABLES `teach` WRITE;
/*!40000 ALTER TABLE `teach` DISABLE KEYS */;
/*!40000 ALTER TABLE `teach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher`
--

DROP TABLE IF EXISTS `teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `teacher` (
  `teacherId` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(40) DEFAULT NULL,
  `lastName` varchar(40) DEFAULT NULL,
  `sex` varchar(6) DEFAULT NULL,
  `picture` varchar(500) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `adress` varchar(500) DEFAULT NULL,
  `phone` int(11) DEFAULT NULL,
  `inscriptionDate` date DEFAULT NULL,
  PRIMARY KEY (`teacherId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher`
--

LOCK TABLES `teacher` WRITE;
/*!40000 ALTER TABLE `teacher` DISABLE KEYS */;
INSERT INTO `teacher` VALUES (1,'teacher','teacher',NULL,'',NULL,NULL,NULL,NULL),(2,'boxing','2ddddddd',NULL,'',NULL,NULL,NULL,NULL),(3,'teacher3','teaching',NULL,'',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `teacher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user` (
  `userName` varchar(16) NOT NULL,
  `password` varchar(500) DEFAULT NULL,
  `userType` int(11) DEFAULT NULL,
  `typeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('coucou','$2b$10$Lr2Au5QGjha29MsXDbNnvuMjP0oB5w6t0gEZsdUvlgIKTlIQu46Ge',0,0),('teacher','$2b$10$FSMepZs6zlN5WyzSASjc9OpduK2d2sR1wxPjOX4e8BIobRyWFreo.',1,1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `groupe_info`
--

/*!50001 DROP VIEW IF EXISTS `groupe_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `groupe_info` AS select `g`.`groupId` AS `groupId`,`g`.`level` AS `level`,`g`.`teacherId` AS `teacherId`,`t`.`firstName` AS `firstName`,`t`.`lastName` AS `lastName`,`t`.`picture` AS `teacherPicture`,`m`.`moduleId` AS `moduleId`,`m`.`moduleName` AS `moduleName`,`m`.`picture` AS `modulePicture` from ((`groupe` `g` join `module` `m` on((`g`.`moduleId` = `m`.`moduleId`))) join `teacher` `t` on((`g`.`teacherId` = `t`.`teacherId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `session_number`
--

/*!50001 DROP VIEW IF EXISTS `session_number`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `session_number` AS select `pi`.`studentId` AS `studentId`,`pi`.`groupId` AS `groupId`,`pi`.`sessionCount` AS `sessionCount`,`pi`.`paymentPrice` AS `paymentPrice`,count(`s`.`sessionId`) AS `sessionsDoneCount`,cast(`pi`.`inscriptionDate` as date) AS `inscriptionDate` from ((`student` `p` join `payment_info` `pi` on((`p`.`studentId` = `pi`.`studentId`))) join `session` `s` on((`pi`.`groupId` = `s`.`groupId`))) where (`s`.`sessionDone` = '1') group by `pi`.`studentId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `session_paid`
--

/*!50001 DROP VIEW IF EXISTS `session_paid`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `session_paid` AS select `p`.`studentId` AS `studentId`,`p`.`groupId` AS `groupId`,sum(`p`.`paymentPrice`) AS `totalPaid`,(sum(`p`.`paymentPrice`) DIV `pi`.`paymentPrice`) AS `sessionsPaidCount`,max(cast(`p`.`paymentDate` as date)) AS `paymentDate`,(to_days(now()) - to_days(max(`p`.`paymentDate`))) AS `dayDiff` from (`payment` `p` join `payment_info` `pi` on((`p`.`studentId` = `pi`.`studentId`))) group by `p`.`studentId` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-29 21:33:55
