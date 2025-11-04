-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: supply_chain_costing
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `ad_hoc_cost_type`
--

DROP TABLE IF EXISTS `ad_hoc_cost_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ad_hoc_cost_type` (
  `ad_hoc_id` varchar(10) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`ad_hoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ad_hoc_cost_type`
--

LOCK TABLES `ad_hoc_cost_type` WRITE;
/*!40000 ALTER TABLE `ad_hoc_cost_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `ad_hoc_cost_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `city_code` varchar(10) NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `country_code` char(3) NOT NULL,
  PRIMARY KEY (`city_code`),
  KEY `country_code` (`country_code`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`country_code`) REFERENCES `country` (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  `client_id` varchar(10) NOT NULL,
  `client_name` varchar(150) NOT NULL,
  `payment_terms` varchar(50) DEFAULT NULL,
  `current_exposure` decimal(15,2) DEFAULT NULL,
  `credit_limit` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `country_code` char(3) NOT NULL,
  `country_name` varchar(100) NOT NULL,
  PRIMARY KEY (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal`
--

DROP TABLE IF EXISTS `deal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal` (
  `deal_no` varchar(20) NOT NULL,
  `sales_rep_id` varchar(10) NOT NULL,
  `client_id` varchar(10) NOT NULL,
  `product_ref` varchar(10) NOT NULL,
  `inco_code` varchar(10) NOT NULL,
  `status_code` varchar(10) NOT NULL,
  `date_created` date NOT NULL,
  `quote_due_date` date DEFAULT NULL,
  `quote_submitted_date` date DEFAULT NULL,
  `date_closed` date DEFAULT NULL,
  `sales_total` decimal(15,2) DEFAULT NULL,
  `cost_of_sales` decimal(15,2) DEFAULT NULL,
  `gross_profit` decimal(15,2) DEFAULT NULL,
  `finance_cost` decimal(15,2) DEFAULT NULL,
  `profit_after_fc` decimal(15,2) DEFAULT NULL,
  `gross_profit_pct` decimal(7,4) DEFAULT NULL,
  `profit_after_fc_pct` decimal(7,4) DEFAULT NULL,
  PRIMARY KEY (`deal_no`),
  KEY `sales_rep_id` (`sales_rep_id`),
  KEY `client_id` (`client_id`),
  KEY `product_ref` (`product_ref`),
  KEY `inco_code` (`inco_code`),
  KEY `status_code` (`status_code`),
  CONSTRAINT `deal_ibfk_1` FOREIGN KEY (`sales_rep_id`) REFERENCES `sales_rep` (`sales_rep_id`),
  CONSTRAINT `deal_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `deal_ibfk_3` FOREIGN KEY (`product_ref`) REFERENCES `product` (`product_ref`),
  CONSTRAINT `deal_ibfk_4` FOREIGN KEY (`inco_code`) REFERENCES `inco_term` (`inco_code`),
  CONSTRAINT `deal_ibfk_5` FOREIGN KEY (`status_code`) REFERENCES `deal_status` (`status_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal`
--

LOCK TABLES `deal` WRITE;
/*!40000 ALTER TABLE `deal` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_ad_hoc_cost`
--

DROP TABLE IF EXISTS `deal_ad_hoc_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_ad_hoc_cost` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deal_no` varchar(20) NOT NULL,
  `cost_ref` varchar(20) NOT NULL,
  `ad_hoc_id` varchar(10) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_cost` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ad_hoc_id` (`ad_hoc_id`),
  KEY `idx_ad_hoc_deal` (`deal_no`),
  CONSTRAINT `deal_ad_hoc_cost_ibfk_1` FOREIGN KEY (`deal_no`) REFERENCES `deal` (`deal_no`),
  CONSTRAINT `deal_ad_hoc_cost_ibfk_2` FOREIGN KEY (`ad_hoc_id`) REFERENCES `ad_hoc_cost_type` (`ad_hoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_ad_hoc_cost`
--

LOCK TABLES `deal_ad_hoc_cost` WRITE;
/*!40000 ALTER TABLE `deal_ad_hoc_cost` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_ad_hoc_cost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_cash_inflow`
--

DROP TABLE IF EXISTS `deal_cash_inflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_cash_inflow` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deal_no` varchar(20) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `sales_price` decimal(15,2) NOT NULL,
  `deposit_pct` decimal(5,4) NOT NULL,
  `deposit_date` date NOT NULL,
  `uplift_start` date NOT NULL,
  `uplift_days` int NOT NULL,
  `travel_days` int NOT NULL,
  `terms_days` int NOT NULL,
  `balance_pct` decimal(5,4) NOT NULL,
  `total_sales` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_inflow_deal` (`deal_no`),
  CONSTRAINT `deal_cash_inflow_ibfk_1` FOREIGN KEY (`deal_no`) REFERENCES `deal` (`deal_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_cash_inflow`
--

LOCK TABLES `deal_cash_inflow` WRITE;
/*!40000 ALTER TABLE `deal_cash_inflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_cash_inflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_cash_outflow`
--

DROP TABLE IF EXISTS `deal_cash_outflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_cash_outflow` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deal_no` varchar(20) NOT NULL,
  `stock_ref` varchar(20) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL,
  `deposit_pct` decimal(5,4) NOT NULL,
  `deposit_date` date NOT NULL,
  `balance_pct` decimal(5,4) NOT NULL,
  `balance_date` date NOT NULL,
  `total_cost` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stock_ref` (`stock_ref`),
  KEY `idx_outflow_deal` (`deal_no`),
  CONSTRAINT `deal_cash_outflow_ibfk_1` FOREIGN KEY (`deal_no`) REFERENCES `deal` (`deal_no`),
  CONSTRAINT `deal_cash_outflow_ibfk_2` FOREIGN KEY (`stock_ref`) REFERENCES `stock_item` (`stock_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_cash_outflow`
--

LOCK TABLES `deal_cash_outflow` WRITE;
/*!40000 ALTER TABLE `deal_cash_outflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_cash_outflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_sales_line`
--

DROP TABLE IF EXISTS `deal_sales_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_sales_line` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deal_no` varchar(20) NOT NULL,
  `line_type` enum('Product','Transport','Ad Hoc') NOT NULL,
  `product_ref` varchar(10) DEFAULT NULL,
  `description` varchar(150) NOT NULL,
  `uom_id` varchar(10) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL,
  `sales_price` decimal(15,2) NOT NULL,
  `gp_price` decimal(15,2) NOT NULL,
  `gp_pct` decimal(7,4) NOT NULL,
  `purchase_cost` decimal(15,2) NOT NULL,
  `sales_total` decimal(15,2) NOT NULL,
  `gp_total` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uom_id` (`uom_id`),
  KEY `product_ref` (`product_ref`),
  KEY `idx_sales_deal` (`deal_no`),
  CONSTRAINT `deal_sales_line_ibfk_1` FOREIGN KEY (`deal_no`) REFERENCES `deal` (`deal_no`),
  CONSTRAINT `deal_sales_line_ibfk_2` FOREIGN KEY (`uom_id`) REFERENCES `unit_of_measure` (`uom_id`),
  CONSTRAINT `deal_sales_line_ibfk_3` FOREIGN KEY (`product_ref`) REFERENCES `product` (`product_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_sales_line`
--

LOCK TABLES `deal_sales_line` WRITE;
/*!40000 ALTER TABLE `deal_sales_line` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_sales_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_status`
--

DROP TABLE IF EXISTS `deal_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_status` (
  `status_code` varchar(10) NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`status_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_status`
--

LOCK TABLES `deal_status` WRITE;
/*!40000 ALTER TABLE `deal_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_stock_cost`
--

DROP TABLE IF EXISTS `deal_stock_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_stock_cost` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deal_no` varchar(20) NOT NULL,
  `stock_ref` varchar(20) NOT NULL,
  `uom_id` varchar(10) NOT NULL,
  `product_ref` varchar(10) NOT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_cost` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stock_ref` (`stock_ref`),
  KEY `uom_id` (`uom_id`),
  KEY `product_ref` (`product_ref`),
  KEY `idx_stock_deal` (`deal_no`),
  CONSTRAINT `deal_stock_cost_ibfk_1` FOREIGN KEY (`deal_no`) REFERENCES `deal` (`deal_no`),
  CONSTRAINT `deal_stock_cost_ibfk_2` FOREIGN KEY (`stock_ref`) REFERENCES `stock_item` (`stock_ref`),
  CONSTRAINT `deal_stock_cost_ibfk_3` FOREIGN KEY (`uom_id`) REFERENCES `unit_of_measure` (`uom_id`),
  CONSTRAINT `deal_stock_cost_ibfk_4` FOREIGN KEY (`product_ref`) REFERENCES `product` (`product_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_stock_cost`
--

LOCK TABLES `deal_stock_cost` WRITE;
/*!40000 ALTER TABLE `deal_stock_cost` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_stock_cost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deal_transport_cost`
--

DROP TABLE IF EXISTS `deal_transport_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deal_transport_cost` (
  `id` int NOT NULL AUTO_INCREMENT,
  `deal_no` varchar(20) NOT NULL,
  `transport_ref` varchar(20) NOT NULL,
  `transport_id` varchar(10) DEFAULT NULL,
  `collection_city_code` varchar(10) DEFAULT NULL,
  `delivery_city_code` varchar(10) DEFAULT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `quantity_per_truck` decimal(15,3) DEFAULT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_cost` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transport_id` (`transport_id`),
  KEY `collection_city_code` (`collection_city_code`),
  KEY `delivery_city_code` (`delivery_city_code`),
  KEY `idx_trans_deal` (`deal_no`),
  CONSTRAINT `deal_transport_cost_ibfk_1` FOREIGN KEY (`deal_no`) REFERENCES `deal` (`deal_no`),
  CONSTRAINT `deal_transport_cost_ibfk_2` FOREIGN KEY (`transport_id`) REFERENCES `transport_company` (`transport_id`),
  CONSTRAINT `deal_transport_cost_ibfk_3` FOREIGN KEY (`collection_city_code`) REFERENCES `city` (`city_code`),
  CONSTRAINT `deal_transport_cost_ibfk_4` FOREIGN KEY (`delivery_city_code`) REFERENCES `city` (`city_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deal_transport_cost`
--

LOCK TABLES `deal_transport_cost` WRITE;
/*!40000 ALTER TABLE `deal_transport_cost` DISABLE KEYS */;
/*!40000 ALTER TABLE `deal_transport_cost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inco_term`
--

DROP TABLE IF EXISTS `inco_term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inco_term` (
  `inco_code` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`inco_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inco_term`
--

LOCK TABLES `inco_term` WRITE;
/*!40000 ALTER TABLE `inco_term` DISABLE KEYS */;
/*!40000 ALTER TABLE `inco_term` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `location_name` varchar(150) NOT NULL,
  `city_code` varchar(10) DEFAULT NULL,
  `country_code` char(3) DEFAULT NULL,
  PRIMARY KEY (`location_id`),
  KEY `city_code` (`city_code`),
  KEY `country_code` (`country_code`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`city_code`) REFERENCES `city` (`city_code`),
  CONSTRAINT `location_ibfk_2` FOREIGN KEY (`country_code`) REFERENCES `country` (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packaging`
--

DROP TABLE IF EXISTS `packaging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packaging` (
  `pack_id` varchar(10) NOT NULL,
  `pack_type` varchar(100) NOT NULL,
  PRIMARY KEY (`pack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packaging`
--

LOCK TABLES `packaging` WRITE;
/*!40000 ALTER TABLE `packaging` DISABLE KEYS */;
/*!40000 ALTER TABLE `packaging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_ref` varchar(10) NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `specification` varchar(255) DEFAULT NULL,
  `hs_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`product_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_rep`
--

DROP TABLE IF EXISTS `sales_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_rep` (
  `sales_rep_id` varchar(10) NOT NULL,
  `sales_rep_name` varchar(100) NOT NULL,
  PRIMARY KEY (`sales_rep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_rep`
--

LOCK TABLES `sales_rep` WRITE;
/*!40000 ALTER TABLE `sales_rep` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_rep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_item`
--

DROP TABLE IF EXISTS `stock_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_item` (
  `stock_ref` varchar(20) NOT NULL,
  `product_ref` varchar(10) NOT NULL,
  `uom_id` varchar(10) NOT NULL,
  `pack_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`stock_ref`),
  KEY `product_ref` (`product_ref`),
  KEY `uom_id` (`uom_id`),
  KEY `pack_id` (`pack_id`),
  CONSTRAINT `stock_item_ibfk_1` FOREIGN KEY (`product_ref`) REFERENCES `product` (`product_ref`),
  CONSTRAINT `stock_item_ibfk_2` FOREIGN KEY (`uom_id`) REFERENCES `unit_of_measure` (`uom_id`),
  CONSTRAINT `stock_item_ibfk_3` FOREIGN KEY (`pack_id`) REFERENCES `packaging` (`pack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_item`
--

LOCK TABLES `stock_item` WRITE;
/*!40000 ALTER TABLE `stock_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport_company`
--

DROP TABLE IF EXISTS `transport_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_company` (
  `transport_id` varchar(10) NOT NULL,
  `transporter_name` varchar(150) NOT NULL,
  PRIMARY KEY (`transport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_company`
--

LOCK TABLES `transport_company` WRITE;
/*!40000 ALTER TABLE `transport_company` DISABLE KEYS */;
/*!40000 ALTER TABLE `transport_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_of_measure`
--

DROP TABLE IF EXISTS `unit_of_measure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_of_measure` (
  `uom_id` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `shorthand` varchar(10) NOT NULL,
  PRIMARY KEY (`uom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_of_measure`
--

LOCK TABLES `unit_of_measure` WRITE;
/*!40000 ALTER TABLE `unit_of_measure` DISABLE KEYS */;
/*!40000 ALTER TABLE `unit_of_measure` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-04 18:24:35
