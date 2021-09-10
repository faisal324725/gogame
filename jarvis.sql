-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 29, 2020 at 01:32 AM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.11

SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jarvis`
--

-- --------------------------------------------------------

--
-- Table structure for table `experience`
--

CREATE TABLE `experience` (
  `experience_id` int(11) NOT NULL,
  `product_name` varchar(25) NOT NULL,
  `parameter_id` int(11) NOT NULL,
  `logical` char(1) NOT NULL COMMENT 'only > / < / =',
  `experience_value` int(11) NOT NULL,
  `Diagnosis` varchar(255) NOT NULL,
  `Action` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `parameter`
--

CREATE TABLE `parameter` (
  `parameter_id` int(11) NOT NULL,
  `sampling_point_id` int(11) NOT NULL,
  `parameter_type` tinyint(4) NOT NULL COMMENT 'label or parameter',
  `parameter_name` varchar(50) NOT NULL,
  `UoM` varchar(15) DEFAULT NULL,
  `Min` int(11) DEFAULT NULL,
  `Max` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `plant`
--

CREATE TABLE `plant` (
  `plant_id` int(11) NOT NULL,
  `plant_name` varchar(50) NOT NULL
) ;

--
-- Dumping data for table `plant`
--

INSERT INTO `plant` (`plant_id`, `plant_name`) VALUES
(1, 'Process FA'),
(2, 'Process FBD'),
(3, 'Process Dove'),
(4, 'Process Soap'),
(5, 'Process WTP'),
(6, 'Process WWTP'),
(7, 'Update Tankfarm'),
(8, 'Dispatch Isotank'),
(9, 'Incoming CPKO'),
(10, 'Incoming Chemicals'),
(11, 'Others');

-- --------------------------------------------------------

--
-- Table structure for table `sampling_point`
--

CREATE TABLE `sampling_point` (
  `sampling_point_id` int(11) NOT NULL,
  `sampling_point_name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `schedule_id` int(11) NOT NULL,
  `schedule_date` date NOT NULL,
  `schedule_group` varchar(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_role` varchar(15) NOT NULL COMMENT 'Analyst or Team Leader',
  `shift_id` int(11) NOT NULL,
  `time_start` time NOT NULL,
  `time_end` time NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `shift`
--

CREATE TABLE `shift` (
  `shift_id` int(11) NOT NULL,
  `shift_code` varchar(3) NOT NULL,
  `shift_name` varchar(25) NOT NULL,
  `time_start` time NOT NULL,
  `time_end` time NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `trans`
--

CREATE TABLE `trans` (
  `trans_id` int(11) NOT NULL,
  `sample_in` datetime NOT NULL DEFAULT current_timestamp(),
  `barcode_id` varchar(50) NOT NULL,
  `plant_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `sample_check_in` datetime DEFAULT NULL,
  `unit_label1_name` varchar(25) DEFAULT NULL,
  `unit_label1_value` varchar(50) DEFAULT NULL,
  `unit_label2_name` varchar(25) DEFAULT NULL,
  `unit_label2_value` varchar(50) DEFAULT NULL,
  `unit_label3_name` varchar(25) DEFAULT NULL,
  `unit_label3_value` varchar(50) DEFAULT NULL,
  `unit_label4_name` varchar(25) DEFAULT NULL,
  `unit_label4_value` varchar(50) DEFAULT NULL,
  `sample_check_out` datetime DEFAULT NULL,
  `analyst_id` int(11) DEFAULT NULL,
  `approver_id` int(11) DEFAULT NULL,
  `approver_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `trans_detail`
--

CREATE TABLE `trans_detail` (
  `trans_detail_id` int(11) NOT NULL,
  `trans_id` int(11) NOT NULL,
  `unit_detail_id` int(11) NOT NULL,
  `sampling_point_id` int(11) NOT NULL,
  `parameter_id` int(11) NOT NULL,
  `trans_detail_value` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `unit`
--

CREATE TABLE `unit` (
  `unit_id` int(11) NOT NULL,
  `plant_id` int(11) NOT NULL,
  `unit_name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `unit_detail`
--

CREATE TABLE `unit_detail` (
  `unit_detail_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `unit_detail_type` tinyint(4) NOT NULL COMMENT 'label / sampling point',
  `unit_detail_value` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `experience`
--
ALTER TABLE `experience`
  ADD PRIMARY KEY (`experience_id`);

--
-- Indexes for table `parameter`
--
ALTER TABLE `parameter`
  ADD PRIMARY KEY (`parameter_id`);

--
-- Indexes for table `plant`
--
ALTER TABLE `plant`
  ADD PRIMARY KEY (`plant_id`);

--
-- Indexes for table `sampling_point`
--
ALTER TABLE `sampling_point`
  ADD PRIMARY KEY (`sampling_point_id`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`schedule_id`);

--
-- Indexes for table `shift`
--
ALTER TABLE `shift`
  ADD PRIMARY KEY (`shift_id`);

--
-- Indexes for table `trans`
--
ALTER TABLE `trans`
  ADD PRIMARY KEY (`trans_id`);

--
-- Indexes for table `unit`
--
ALTER TABLE `unit`
  ADD PRIMARY KEY (`unit_id`);

--
-- Indexes for table `unit_detail`
--
ALTER TABLE `unit_detail`
  ADD PRIMARY KEY (`unit_detail_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `experience`
--
ALTER TABLE `experience`
  MODIFY `experience_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parameter`
--
ALTER TABLE `parameter`
  MODIFY `parameter_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `plant`
--
ALTER TABLE `plant`
  MODIFY `plant_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sampling_point`
--
ALTER TABLE `sampling_point`
  MODIFY `sampling_point_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `schedule`
--
ALTER TABLE `schedule`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shift`
--
ALTER TABLE `shift`
  MODIFY `shift_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trans`
--
ALTER TABLE `trans`
  MODIFY `trans_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unit`
--
ALTER TABLE `unit`
  MODIFY `unit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unit_detail`
--
ALTER TABLE `unit_detail`
  MODIFY `unit_detail_id` int(11) NOT NULL AUTO_INCREMENT;


--
-- Metadata
--
USE phpmyadmin;

--
-- Metadata for table experience
--

--
-- Metadata for table parameter
--

--
-- Metadata for table plant
--

--
-- Metadata for table sampling_point
--

--
-- Metadata for table schedule
--

--
-- Metadata for table shift
--

--
-- Metadata for table trans
--

--
-- Metadata for table trans_detail
--

--
-- Metadata for table unit
--

--
-- Metadata for table unit_detail
--

--
-- Metadata for database jarvis
--
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
