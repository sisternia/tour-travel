-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 02, 2025 at 02:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tour-travel`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(6) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password`, `created_at`, `updated_at`) VALUES
('65b027', 'cuogngueen', 'cuongnq.22it@vku.udn.vn', '$2b$10$s/OtJu09xAOuHz8ASsmOpegNdd0RwOUgjs/LMWnAiVKb7WFxyn/5K', '2025-09-07 13:47:17', '2025-09-07 13:47:17'),
('f0afeb', 'vua', 'vu784512000@gmail.com', '$2b$10$GHq/DEpMAyXEC3sbka/i1eS/DcGMdFCUv54fRhEjvvO8C5TmOQDlq', '2025-09-05 16:45:07', '2025-09-05 16:45:07');

-- --------------------------------------------------------

--
-- Table structure for table `user_infor`
--

CREATE TABLE `user_infor` (
  `user_infor_id` varchar(10) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `citizen_id` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `background` varchar(255) DEFAULT NULL,
  `user_id` varchar(6) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_infor`
--

INSERT INTO `user_infor` (`user_infor_id`, `phone`, `dob`, `citizen_id`, `address`, `bio`, `avatar`, `background`, `user_id`, `created_at`, `updated_at`) VALUES
('36d706e6e0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '65b027', '2025-09-07 13:47:17', '2025-09-07 13:47:17'),
('eab00e57d9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'f0afeb', '2025-09-05 16:45:07', '2025-09-05 16:45:07');

-- --------------------------------------------------------

--
-- Table structure for table `verify`
--

CREATE TABLE `verify` (
  `verify_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `verify_code` varchar(6) NOT NULL,
  `verify_status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `verify`
--

INSERT INTO `verify` (`verify_id`, `user_id`, `verify_code`, `verify_status`, `created_at`, `updated_at`) VALUES
('7e7b47', '65b027', '415126', 1, '2025-09-07 13:47:17', '2025-09-07 13:47:57'),
('e4cffa', 'f0afeb', '244095', 0, '2025-09-05 16:45:07', '2025-09-06 01:23:30');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_infor`
--
ALTER TABLE `user_infor`
  ADD PRIMARY KEY (`user_infor_id`),
  ADD KEY `fk_user_infor_user` (`user_id`);

--
-- Indexes for table `verify`
--
ALTER TABLE `verify`
  ADD PRIMARY KEY (`verify_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `user_infor`
--
ALTER TABLE `user_infor`
  ADD CONSTRAINT `fk_user_infor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `verify`
--
ALTER TABLE `verify`
  ADD CONSTRAINT `verify_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
