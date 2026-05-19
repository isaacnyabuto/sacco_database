CREATE DATABASE  IF NOT EXISTS `sacco_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sacco_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: sacco_db
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `account_type` enum('saving','loan') NOT NULL,
  `balance` decimal(12,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `membersid` int DEFAULT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_member` (`membersid`),
  CONSTRAINT `fk_member` FOREIGN KEY (`membersid`) REFERENCES `members` (`membersId`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (61,'saving',0.00,'2026-05-18 08:28:21',11),(62,'saving',51000.00,'2026-05-18 08:28:21',12),(63,'saving',0.00,'2026-05-18 08:28:21',13),(64,'saving',20000.00,'2026-05-18 08:28:21',14),(65,'saving',0.00,'2026-05-18 08:28:21',15),(66,'saving',40000.00,'2026-05-18 08:28:21',16),(67,'saving',0.00,'2026-05-18 08:28:21',17),(68,'saving',0.00,'2026-05-18 08:28:21',18),(69,'saving',80000.00,'2026-05-18 08:28:21',19),(70,'saving',0.00,'2026-05-18 08:28:21',20),(71,'saving',0.00,'2026-05-18 08:28:21',21),(72,'saving',55000.00,'2026-05-18 08:28:21',22),(73,'saving',0.00,'2026-05-18 08:28:21',23),(74,'saving',30000.00,'2026-05-18 08:28:21',24),(75,'saving',0.00,'2026-05-18 08:28:21',25),(76,'saving',45000.00,'2026-05-18 08:28:21',26),(77,'saving',0.00,'2026-05-18 08:28:21',27),(78,'saving',0.00,'2026-05-18 08:28:21',28),(79,'saving',30000.00,'2026-05-18 08:28:21',29),(80,'saving',0.00,'2026-05-18 08:28:21',30);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan` (
  `loan_id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `membersId` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `status` enum('active','cleared','defaulted') DEFAULT 'active',
  `disbursement_date` date NOT NULL,
  `interest_amount` decimal(10,2) NOT NULL,
  `total_payable` decimal(10,2) NOT NULL,
  `balance_left` decimal(10,2) NOT NULL,
  `debug_log` varchar(255) DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  PRIMARY KEY (`loan_id`),
  UNIQUE KEY `application_id` (`application_id`),
  KEY `fk_loan_member` (`membersId`),
  KEY `fk_loan_account` (`account_id`),
  CONSTRAINT `fk_loan_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_loan_application` FOREIGN KEY (`application_id`) REFERENCES `loan_applications` (`application_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_loan_member` FOREIGN KEY (`membersId`) REFERENCES `members` (`membersId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES (1,5,2,30000.00,10.00,'active','2026-05-18',3000.00,33000.00,8000.00,'AUTO CREATED ON APPROVAL',NULL),(2,9,6,45000.00,11.50,'active','2026-05-18',5175.00,50175.00,36175.00,'AUTO CREATED ON APPROVAL',NULL),(3,12,9,90000.00,16.00,'active','2026-05-18',14400.00,104400.00,81400.00,'AUTO CREATED ON APPROVAL',NULL),(4,15,12,50000.00,12.50,'active','2026-05-18',6250.00,56250.00,56250.00,'AUTO CREATED ON APPROVAL',62),(5,17,14,20000.00,9.00,'active','2026-05-18',1800.00,21800.00,21800.00,'AUTO CREATED ON APPROVAL',64),(6,19,16,40000.00,11.00,'active','2026-05-18',4400.00,44400.00,44400.00,'AUTO CREATED ON APPROVAL',66),(7,22,19,80000.00,14.50,'active','2026-05-18',11600.00,91600.00,91600.00,'AUTO CREATED ON APPROVAL',69),(8,25,22,55000.00,12.00,'active','2026-05-18',6600.00,61600.00,61600.00,'AUTO CREATED ON APPROVAL',72),(9,27,24,30000.00,10.50,'active','2026-05-18',3150.00,33150.00,33150.00,'AUTO CREATED ON APPROVAL',74),(10,29,26,45000.00,11.50,'active','2026-05-18',5175.00,50175.00,50175.00,'AUTO CREATED ON APPROVAL',76),(11,32,29,35000.00,9.50,'active','2026-05-18',3325.00,38325.00,33325.00,'AUTO CREATED ON APPROVAL',79);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_applications`
--

DROP TABLE IF EXISTS `loan_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `membersId` int NOT NULL,
  `application_date` date NOT NULL,
  `requested_amount` decimal(10,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `approved_date` date DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  KEY `fk_app_member` (`membersId`),
  CONSTRAINT `fk_app_member` FOREIGN KEY (`membersId`) REFERENCES `members` (`membersId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_applications`
--

LOCK TABLES `loan_applications` WRITE;
/*!40000 ALTER TABLE `loan_applications` DISABLE KEYS */;
INSERT INTO `loan_applications` VALUES (4,1,'2026-05-10',50000.00,12.50,'approved','2026-05-11'),(5,2,'2026-05-10',30000.00,10.00,'approved',NULL),(6,3,'2026-05-11',80000.00,15.00,'approved','2026-05-12'),(7,4,'2026-05-11',150000.00,14.00,'rejected',NULL),(8,5,'2026-05-12',20000.00,9.00,'approved','2026-05-13'),(9,6,'2026-05-12',45000.00,11.50,'approved',NULL),(10,7,'2026-05-13',60000.00,13.00,'approved','2026-05-14'),(11,8,'2026-05-13',25000.00,10.00,'approved','2026-05-14'),(12,9,'2026-05-14',90000.00,16.00,'approved',NULL),(13,10,'2026-05-14',35000.00,12.00,'approved','2026-05-15'),(14,11,'2026-05-01',30000.00,10.00,'approved','2026-05-02'),(15,12,'2026-05-01',50000.00,12.50,'approved',NULL),(16,13,'2026-05-02',75000.00,14.00,'approved','2026-05-03'),(17,14,'2026-05-02',20000.00,9.00,'approved',NULL),(18,15,'2026-05-03',90000.00,15.00,'approved','2026-05-04'),(19,16,'2026-05-03',40000.00,11.00,'approved',NULL),(20,17,'2026-05-04',60000.00,13.00,'approved','2026-05-05'),(21,18,'2026-05-04',25000.00,10.00,'approved','2026-05-05'),(22,19,'2026-05-05',80000.00,14.50,'approved',NULL),(23,20,'2026-05-05',100000.00,16.00,'approved','2026-05-06'),(24,21,'2026-05-06',15000.00,8.50,'approved','2026-05-07'),(25,22,'2026-05-06',55000.00,12.00,'approved',NULL),(26,23,'2026-05-07',70000.00,13.50,'approved','2026-05-08'),(27,24,'2026-05-07',30000.00,10.50,'approved',NULL),(28,25,'2026-05-08',95000.00,15.50,'approved','2026-05-09'),(29,26,'2026-05-08',45000.00,11.50,'approved',NULL),(30,27,'2026-05-09',120000.00,16.00,'approved','2026-05-10'),(31,28,'2026-05-09',60000.00,13.00,'approved','2026-05-10'),(32,29,'2026-05-10',35000.00,9.50,'approved',NULL),(33,30,'2026-05-10',85000.00,14.00,'approved','2026-05-11');
/*!40000 ALTER TABLE `loan_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_repayments`
--

DROP TABLE IF EXISTS `loan_repayments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_repayments` (
  `repayment_id` int NOT NULL AUTO_INCREMENT,
  `loan_id` int NOT NULL,
  `payment_date` date NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) NOT NULL,
  PRIMARY KEY (`repayment_id`),
  KEY `fk_repayment_loan` (`loan_id`),
  CONSTRAINT `fk_repayment_loan` FOREIGN KEY (`loan_id`) REFERENCES `loan` (`loan_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_repayments`
--

LOCK TABLES `loan_repayments` WRITE;
/*!40000 ALTER TABLE `loan_repayments` DISABLE KEYS */;
INSERT INTO `loan_repayments` VALUES (1,1,'2026-05-18',2000.00,0.00),(2,1,'2026-05-18',3000.00,0.00),(3,2,'2026-05-18',5000.00,0.00),(4,2,'2026-05-18',7000.00,0.00),(5,3,'2026-05-18',10000.00,0.00),(6,3,'2026-05-18',8000.00,0.00),(7,1,'2026-05-18',4000.00,0.00),(8,2,'2026-05-18',2000.00,0.00),(9,3,'2026-05-18',5000.00,0.00),(10,1,'2026-05-18',1000.00,0.00),(11,1,'2026-05-18',5000.00,0.00),(12,1,'2026-05-18',5000.00,0.00),(13,1,'2026-05-18',5000.00,0.00),(16,11,'2026-05-18',5000.00,0.00);
/*!40000 ALTER TABLE `loan_repayments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `membersId` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `nationalId` varchar(20) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `join_date` date DEFAULT (curdate()),
  `status` enum('active','inactive') DEFAULT 'active',
  PRIMARY KEY (`membersId`),
  UNIQUE KEY `nationalId` (`nationalId`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'John','Mwangi','10000001','0701000001','john.mwangi@email.com','2026-05-15','active'),(2,'Mary','Achieng','10000002','0701000002','mary.achieng@email.com','2026-05-15','active'),(3,'Peter','Otieno','10000003','0701000003','peter.otieno@email.com','2026-05-15','inactive'),(4,'Grace','Wanjiku','10000004','0701000004','grace.wanjiku@email.com','2026-05-15','active'),(5,'James','Kamau','10000005','0701000005','james.kamau@email.com','2026-05-15','active'),(6,'Faith','Njeri','10000006','0701000006','faith.njeri@email.com','2026-05-15','inactive'),(7,'Brian','Kiptoo','10000007','0701000007','brian.kiptoo@email.com','2026-05-15','active'),(8,'Alice','Mutiso','10000008','0701000008','alice.mutiso@email.com','2026-05-15','active'),(9,'Daniel','Maina','10000009','0701000009','daniel.maina@email.com','2026-05-15','inactive'),(10,'Susan','Atieno','10000010','0701000010','susan.atieno@email.com','2026-05-15','active'),(11,'Samuel','Omondi','10000011','0701000011','samuel.omondi@email.com','2026-05-15','active'),(12,'Esther','Chebet','10000012','0701000012','esther.chebet@email.com','2026-05-15','inactive'),(13,'Joseph','Kariuki','10000013','0701000013','joseph.kariuki@email.com','2026-05-15','active'),(14,'Lucy','Wambui','10000014','0701000014','lucy.wambui@email.com','2026-05-15','active'),(15,'Kevin','Onyango','10000015','0701000015','kevin.onyango@email.com','2026-05-15','inactive'),(16,'Naomi','Jepkemoi','10000016','0701000016','naomi.jepkemoi@email.com','2026-05-15','active'),(17,'Eric','Macharia','10000017','0701000017','eric.macharia@email.com','2026-05-15','active'),(18,'Irene','Nasimiyu','10000018','0701000018','irene.nasimiyu@email.com','2026-05-15','inactive'),(19,'Paul','Mbugua','10000019','0701000019','paul.mbugua@email.com','2026-05-15','active'),(20,'Joyce','Wairimu','10000020','0701000020','joyce.wairimu@email.com','2026-05-15','active'),(21,'Dennis','Kilonzo','10000021','0701000021','dennis.kilonzo@email.com','2026-05-15','inactive'),(22,'Mercy','Cherono','10000022','0701000022','mercy.cherono@email.com','2026-05-15','active'),(23,'Victor','Barasa','10000023','0701000023','victor.barasa@email.com','2026-05-15','active'),(24,'Rose','Adhiambo','10000024','0701000024','rose.adhiambo@email.com','2026-05-15','inactive'),(25,'Allan','Mutua','10000025','0701000025','allan.mutua@email.com','2026-05-15','active'),(26,'Linda','Shikuku','10000026','0701000026','linda.shikuku@email.com','2026-05-15','active'),(27,'Andrew','Korir','10000027','0701000027','andrew.korir@email.com','2026-05-15','inactive'),(28,'Brenda','Kendi','10000028','0701000028','brenda.kendi@email.com','2026-05-15','active'),(29,'Michael','Githinji','10000029','0701000029','michael.githinji@email.com','2026-05-15','active'),(30,'Sarah','Chepkoech','10000030','0701000030','sarah.chepkoech@email.com','2026-05-15','inactive');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `loan_id` int DEFAULT NULL,
  `membersId` int NOT NULL,
  `type` enum('deposit','withdrawal','loan_disbursement','loan_repayment','adjustment') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `balance_before` decimal(12,2) DEFAULT '0.00',
  `balance_after` decimal(12,2) DEFAULT '0.00',
  `reference` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `account_id` (`account_id`),
  KEY `loan_id` (`loan_id`),
  KEY `membersId` (`membersId`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`loan_id`) REFERENCES `loan` (`loan_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `transactions_ibfk_3` FOREIGN KEY (`membersId`) REFERENCES `members` (`membersId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (2,61,NULL,11,'deposit',1000.00,0.00,0.00,NULL,'Test deposit','2026-05-18 08:46:44'),(3,62,NULL,12,'deposit',1000.00,0.00,0.00,NULL,'Test deposit','2026-05-18 08:50:27'),(4,79,11,29,'loan_repayment',5000.00,0.00,0.00,NULL,'Auto repayment transaction','2026-05-18 09:00:43');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `users_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff') DEFAULT 'staff',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `membersid` int DEFAULT NULL,
  PRIMARY KEY (`users_id`),
  UNIQUE KEY `username` (`username`),
  KEY `membersid` (`membersid`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`membersid`) REFERENCES `members` (`membersId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-19  9:55:31
