-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 03, 2019 at 11:03 PM
-- Server version: 10.3.12-MariaDB
-- PHP Version: 7.2.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+02:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `id` int(8) NOT NULL,
  `dept` varchar(10) NOT NULL,
  `dept_name` varchar(50) NOT NULL,
  `dept_manager` int(8) NOT NULL,
  `approval_id` int(8) NOT NULL DEFAULT 0,
  `cost_code` varchar(20) NOT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`id`, `dept`, `dept_name`, `dept_manager`, `approval_id`, `cost_code`, `user_id`, `changed`) VALUES
(1, 'admin', 'Administration', 2, 1, '000/001', 1, '2019-03-03 19:30:16');

-- --------------------------------------------------------

--
-- Table structure for table `grn`
--

CREATE TABLE `grn` (
  `id` int(8) NOT NULL,
  `supplier_id` int(8) NOT NULL,
  `store_id` int(8) NOT NULL,
  `receipt_date` date NOT NULL,
  `export_date` timestamp NULL DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `grn_detail`
--

CREATE TABLE `grn_detail` (
  `grn_id` int(8) NOT NULL,
  `order_id` int(8) NOT NULL,
  `order_line` int(8) NOT NULL,
  `actual_price` decimal(10,2) NOT NULL,
  `vat_included` tinyint(1) NOT NULL DEFAULT 0,
  `actual_qty` decimal(10,2) NOT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `product_id` int(8) NOT NULL,
  `store_id` int(8) NOT NULL,
  `on_hand` decimal(10,2) NOT NULL DEFAULT 0.00,
  `bin_location` varchar(20) DEFAULT NULL,
  `min_level` decimal(10,2) NOT NULL DEFAULT 0.00,
  `max_level` decimal(10,2) DEFAULT NULL,
  `reorder_level` decimal(10,2) NOT NULL DEFAULT 0.00,
  `reorder_qty` decimal(10,2) NOT NULL DEFAULT 1.00,
  `check_frequency` int(8) NOT NULL DEFAULT 365,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_check`
--

CREATE TABLE `inventory_check` (
  `product_id` int(8) NOT NULL,
  `store_id` int(8) NOT NULL,
  `check_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `on_hand` decimal(10,2) NOT NULL DEFAULT 0.00,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logon_log`
--

CREATE TABLE `logon_log` (
  `id` int(8) NOT NULL,
  `user_name_given` varchar(50) DEFAULT NULL,
  `password_given` varchar(50) DEFAULT NULL,
  `success` enum('Y','N') NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

CREATE TABLE `order_detail` (
  `order_id` int(8) NOT NULL,
  `line` int(8) NOT NULL,
  `product_id` int(8) NOT NULL,
  `qty` decimal(10,0) NOT NULL,
  `price` decimal(10,0) NOT NULL,
  `closed` bit(1) NOT NULL DEFAULT b'0',
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `people`
--

CREATE TABLE `people` (
  `id` int(8) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `other_name` varchar(50) DEFAULT NULL,
  `id_no` varchar(20) DEFAULT NULL,
  `id_type` varchar(20) NOT NULL DEFAULT 'ZA ID',
  `cust_code` varchar(20) DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `people`
--

INSERT INTO `people` (`id`, `surname`, `first_name`, `other_name`, `id_no`, `id_type`, `cust_code`, `user_id`, `changed`) VALUES
(1, 'Crothall', 'Robert', 'James', '4707225035084', 'ZA ID', 'CROT01', 1, '2019-03-03 19:13:53'),
(2, 'Boland', 'Judy', NULL, NULL, 'ZA ID', NULL, 1, '2019-03-03 19:18:51');

-- --------------------------------------------------------

--
-- Table structure for table `people_prop`
--

CREATE TABLE `people_prop` (
  `people_id` int(8) NOT NULL,
  `property_id` int(8) NOT NULL,
  `relationship` varchar(20) NOT NULL DEFAULT '"Rent"',
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(8) NOT NULL,
  `part_no` varchar(20) NOT NULL,
  `description` varchar(50) NOT NULL,
  `category` int(8) NOT NULL,
  `order_units` decimal(10,2) NOT NULL DEFAULT 1.00,
  `sale_price` decimal(10,2) NOT NULL,
  `profit_percent` decimal(10,2) DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `product_order`
--

CREATE TABLE `product_order` (
  `id` int(8) NOT NULL,
  `supplier_id` int(8) NOT NULL,
  `order_date` date NOT NULL,
  `store_id` int(8) NOT NULL,
  `approver_id` int(8) DEFAULT NULL,
  `approver_date` date DEFAULT NULL,
  `export_date` timestamp NULL DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `product_price`
--

CREATE TABLE `product_price` (
  `product_id` int(8) NOT NULL,
  `supplier_id` int(8) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `price_date` date NOT NULL,
  `lead_time` smallint(6) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `id` int(8) NOT NULL,
  `res_id` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(20) NOT NULL DEFAULT '''None''',
  `notes` text DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `requisition`
--

CREATE TABLE `requisition` (
  `id` int(8) NOT NULL,
  `store_id` int(8) NOT NULL,
  `product_id` int(8) NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `dept_id` int(8) NOT NULL,
  `req_date` date NOT NULL,
  `approver_id` int(8) DEFAULT NULL,
  `approver_date` date DEFAULT NULL,
  `delivery_date` date NOT NULL,
  `delivery_qty` decimal(10,2) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `cost_code` varchar(20) DEFAULT NULL,
  `export_date` timestamp NULL DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(8) NOT NULL,
  `store_id` int(8) NOT NULL,
  `person_id` int(8) NOT NULL,
  `trans_date` date NOT NULL,
  `export_date` timestamp NULL DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sales_detail`
--

CREATE TABLE `sales_detail` (
  `id` int(8) NOT NULL,
  `sales_id` int(8) NOT NULL,
  `product_id` int(8) NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE `store` (
  `id` int(8) NOT NULL,
  `name` varchar(50) NOT NULL,
  `dept_id` int(8) NOT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `store`
--

INSERT INTO `store` (`id`, `name`, `dept_id`, `user_id`, `changed`) VALUES
(1, 'Admin Office Store', 1, 1, '2019-03-03 19:31:33');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id` int(8) NOT NULL,
  `supp_name` varchar(50) NOT NULL,
  `addr1` varchar(50) NOT NULL,
  `addr2` varchar(50) DEFAULT NULL,
  `addr3` varchar(50) DEFAULT NULL,
  `postcode` varchar(10) DEFAULT NULL,
  `contact1` varchar(50) DEFAULT NULL,
  `phone1` varchar(20) DEFAULT NULL,
  `contact2` varchar(50) DEFAULT NULL,
  `phone2` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `payment_method` varchar(20) NOT NULL,
  `lead_time` smallint(6) NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(8) NOT NULL,
  `username` varchar(50) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `locked` enum('Y','N') NOT NULL,
  `dept_id` int(8) NOT NULL,
  `notes` text DEFAULT NULL,
  `user_id` int(8) NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `hash`, `surname`, `first_name`, `phone`, `mobile`, `email`, `locked`, `dept_id`, `notes`, `user_id`, `changed`) VALUES
(1, 'robcrothall', ' ', 'Crothall', 'Rob', '0466040441', '0836785055', 'rob@crothall.co.za', 'N', 1, NULL, 1, '2019-03-03 19:16:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_department_people` (`dept_manager`),
  ADD KEY `FK_department_people2` (`approval_id`);

--
-- Indexes for table `grn`
--
ALTER TABLE `grn`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_grn_supplier` (`supplier_id`),
  ADD KEY `FK_grn_store` (`store_id`);

--
-- Indexes for table `grn_detail`
--
ALTER TABLE `grn_detail`
  ADD PRIMARY KEY (`grn_id`,`order_id`,`order_line`),
  ADD KEY `FK_grn_detail_product_order` (`order_id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`product_id`,`store_id`),
  ADD KEY `FK_inventory_store` (`store_id`);

--
-- Indexes for table `inventory_check`
--
ALTER TABLE `inventory_check`
  ADD PRIMARY KEY (`product_id`,`store_id`,`check_date`),
  ADD KEY `FK_inventory_check_store` (`store_id`);

--
-- Indexes for table `logon_log`
--
ALTER TABLE `logon_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`order_id`,`line`),
  ADD KEY `FK_order_detail_product` (`product_id`);

--
-- Indexes for table `people`
--
ALTER TABLE `people`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `people_prop`
--
ALTER TABLE `people_prop`
  ADD KEY `FK_people_prop_people` (`people_id`),
  ADD KEY `FK_people_prop_properties` (`property_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_order`
--
ALTER TABLE `product_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_product_order_supplier` (`supplier_id`),
  ADD KEY `FK_product_order_store` (`store_id`),
  ADD KEY `FK_product_order_people` (`approver_id`);

--
-- Indexes for table `product_price`
--
ALTER TABLE `product_price`
  ADD PRIMARY KEY (`product_id`,`supplier_id`,`price_date`),
  ADD KEY `FK_product_price_supplier` (`supplier_id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requisition`
--
ALTER TABLE `requisition`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_requisition_store` (`store_id`),
  ADD KEY `FK_requisition_product` (`product_id`),
  ADD KEY `FK_requisition_dept` (`dept_id`),
  ADD KEY `FK_requisition_people` (`approver_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_sales_store` (`store_id`),
  ADD KEY `FK_sales_people` (`person_id`);

--
-- Indexes for table `sales_detail`
--
ALTER TABLE `sales_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_sales_detail_sales` (`sales_id`),
  ADD KEY `FK_sales_detail_product` (`product_id`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_store_dept` (`dept_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `grn`
--
ALTER TABLE `grn`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `product_id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logon_log`
--
ALTER TABLE `logon_log`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `people`
--
ALTER TABLE `people`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_order`
--
ALTER TABLE `product_order`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `requisition`
--
ALTER TABLE `requisition`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales_detail`
--
ALTER TABLE `sales_detail`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `store`
--
ALTER TABLE `store`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `department`
--
ALTER TABLE `department`
  ADD CONSTRAINT `FK_department_people` FOREIGN KEY (`dept_manager`) REFERENCES `people` (`id`),
  ADD CONSTRAINT `FK_department_people2` FOREIGN KEY (`approval_id`) REFERENCES `people` (`id`);

--
-- Constraints for table `grn`
--
ALTER TABLE `grn`
  ADD CONSTRAINT `FK_grn_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`),
  ADD CONSTRAINT `FK_grn_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`);

--
-- Constraints for table `grn_detail`
--
ALTER TABLE `grn_detail`
  ADD CONSTRAINT `FK_grn_detail_product_order` FOREIGN KEY (`order_id`) REFERENCES `product_order` (`id`);

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `FK_inventory_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_inventory_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`);

--
-- Constraints for table `inventory_check`
--
ALTER TABLE `inventory_check`
  ADD CONSTRAINT `FK_inventory_check_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_inventory_check_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`);

--
-- Constraints for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `FK_order_detail_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_order_detail_product_order` FOREIGN KEY (`order_id`) REFERENCES `product_order` (`id`);

--
-- Constraints for table `people_prop`
--
ALTER TABLE `people_prop`
  ADD CONSTRAINT `FK_people_prop_people` FOREIGN KEY (`people_id`) REFERENCES `people` (`id`),
  ADD CONSTRAINT `FK_people_prop_properties` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`);

--
-- Constraints for table `product_order`
--
ALTER TABLE `product_order`
  ADD CONSTRAINT `FK_product_order_people` FOREIGN KEY (`approver_id`) REFERENCES `people` (`id`),
  ADD CONSTRAINT `FK_product_order_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`),
  ADD CONSTRAINT `FK_product_order_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`);

--
-- Constraints for table `product_price`
--
ALTER TABLE `product_price`
  ADD CONSTRAINT `FK_product_price_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_product_price_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`);

--
-- Constraints for table `requisition`
--
ALTER TABLE `requisition`
  ADD CONSTRAINT `FK_requisition_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`id`),
  ADD CONSTRAINT `FK_requisition_people` FOREIGN KEY (`approver_id`) REFERENCES `people` (`id`),
  ADD CONSTRAINT `FK_requisition_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_requisition_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `FK_sales_people` FOREIGN KEY (`person_id`) REFERENCES `people` (`id`),
  ADD CONSTRAINT `FK_sales_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`id`);

--
-- Constraints for table `sales_detail`
--
ALTER TABLE `sales_detail`
  ADD CONSTRAINT `FK_sales_detail_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_sales_detail_sales` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`id`);

--
-- Constraints for table `store`
--
ALTER TABLE `store`
  ADD CONSTRAINT `FK_store_dept` FOREIGN KEY (`dept_id`) REFERENCES `department` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
