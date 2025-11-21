-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th10 21, 2025 lúc 03:33 AM
-- Phiên bản máy phục vụ: 8.0.37
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `tour-travel5`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `guide_languages`
--

CREATE TABLE `guide_languages` (
  `id` int NOT NULL,
  `guide_id` int NOT NULL,
  `language_job` varchar(50) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tours`
--

CREATE TABLE `tours` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `number_of_people` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `departure_address` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `destination_address` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tour_category_id` int DEFAULT NULL,
  `tour_type_id` int DEFAULT NULL,
  `guide_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tours`
--

INSERT INTO `tours` (`id`, `name`, `number_of_people`, `start_date`, `end_date`, `departure_address`, `destination_address`, `created_at`, `status`, `tour_category_id`, `tour_type_id`, `guide_id`) VALUES
(2, 'Khám Phá Vịnh Hạ Long - Kỳ Quan Thiên Nhiên Thế Giới', 20, '2025-11-20', '2025-11-23', 'Sân bay Nội Bài, Hà Nội', 'Đà Lạt, Lâm Đồng', '2025-11-19 10:40:46', 'active', 1, 1, NULL),
(3, 'Khám Phá Hà Giang - Lũng Cú', 15, '2025-11-22', '2025-11-30', 'Hà Nội', 'Lũng Cú', '2025-11-20 07:56:30', 'active', 1, 1, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_categories`
--

CREATE TABLE `tour_categories` (
  `category_id` int NOT NULL,
  `categories_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_categories`
--

INSERT INTO `tour_categories` (`category_id`, `categories_name`, `image`, `created_at`) VALUES
(1, 'Nội địa', NULL, '2025-11-19 10:38:38'),
(2, 'Quốc Tế', NULL, '2025-11-19 10:38:49');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_guides`
--

CREATE TABLE `tour_guides` (
  `guide_id` int NOT NULL,
  `guide_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `birthday` date DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language_job` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `certification` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar_image` tinytext COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_guides`
--

INSERT INTO `tour_guides` (`guide_id`, `guide_name`, `email`, `phone`, `birthday`, `gender`, `language_job`, `certification`, `address`, `avatar_image`) VALUES
(2, 'Nguyễn Đình Anh Vũ', 'anhvu@gmail.com', '0332199694', '2004-10-06', 'male', NULL, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763622601/tour-guide/certifications/hq0mczewp3v7ye3lcjdx.jpg', 'Gia Lai', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763622599/tour-guide/avatars/wvk17zyrflgchbdljfof.jpg'),
(3, 'Nguyễn Quốc Cường', 'cuongnq@gmail.com', '098765432', '2001-06-02', 'male', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634609/tour-guide/certifications/hz91iyzeydkjykkepouc.jpg', 'Thái Nguyên', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634607/tour-guide/avatars/f36skzkx92an7pojw1kw.jpg'),
(4, 'Lê Thị Kim Oanh', 'lethikimoanh2k4@gmail.com', '0332199694', '2004-09-10', 'female', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634990/tour-guide/certifications/recfr6oelua7nb7tjikc.jpg', 'Phường Vũng Áng - Hà Tĩnh', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634987/tour-guide/avatars/epldmaqgj2qsiksdol9r.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_guide_assignment`
--

CREATE TABLE `tour_guide_assignment` (
  `id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `tour_id` int NOT NULL,
  `tour_guide_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_guide_assignment`
--

INSERT INTO `tour_guide_assignment` (`id`, `created_at`, `tour_id`, `tour_guide_id`) VALUES
(1, '2025-11-20 14:46:31', 3, 2),
(2, '2025-11-20 16:46:16', 2, 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_images`
--

CREATE TABLE `tour_images` (
  `tour_img_id` int NOT NULL,
  `folder_id` int NOT NULL,
  `tour_img` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_images`
--

INSERT INTO `tour_images` (`tour_img_id`, `folder_id`, `tour_img`, `created_at`) VALUES
(1, 1, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763459775/tour-images/DN/pmwy1ruzc8cbhv6sv0xb.jpg', '2025-11-18 16:55:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_image_assignment`
--

CREATE TABLE `tour_image_assignment` (
  `id` int NOT NULL,
  `tour_img_id` int NOT NULL,
  `tour_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_image_folders`
--

CREATE TABLE `tour_image_folders` (
  `folder_id` int NOT NULL,
  `folder_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_image_folders`
--

INSERT INTO `tour_image_folders` (`folder_id`, `folder_name`, `created_at`) VALUES
(1, 'DN', '2025-11-12 19:33:37');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_locations`
--

CREATE TABLE `tour_locations` (
  `location_id` int NOT NULL,
  `tour_id` int NOT NULL,
  `location_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_prices`
--

CREATE TABLE `tour_prices` (
  `price_id` int NOT NULL,
  `price_adult` double NOT NULL,
  `price_child` double NOT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_prices`
--

INSERT INTO `tour_prices` (`price_id`, `price_adult`, `price_child`, `valid_from`, `valid_to`) VALUES
(2, 700000, 300000, '2025-11-20', '2025-11-28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_price_assignments`
--

CREATE TABLE `tour_price_assignments` (
  `id` int NOT NULL,
  `tour_id` int NOT NULL,
  `price_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_price_assignments`
--

INSERT INTO `tour_price_assignments` (`id`, `tour_id`, `price_id`) VALUES
(1, 2, 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_ratings`
--

CREATE TABLE `tour_ratings` (
  `rating_id` int NOT NULL,
  `tour_id` int NOT NULL,
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `rating_value` tinyint NOT NULL,
  `comment` text COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_schedules`
--

CREATE TABLE `tour_schedules` (
  `schedule_id` int NOT NULL,
  `tour_id` int NOT NULL,
  `day_number` int NOT NULL,
  `description` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_type`
--

CREATE TABLE `tour_type` (
  `type_id` int NOT NULL,
  `type_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_type`
--

INSERT INTO `tour_type` (`type_id`, `type_name`, `image`, `description`, `created_at`) VALUES
(1, 'Tour gia đình', NULL, NULL, '2025-11-19 10:38:57'),
(2, 'Tour một mình', NULL, NULL, '2025-11-19 10:39:05');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `user_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password`, `created_at`, `updated_at`) VALUES
('869366', 'Kim Oanh', 'lethikimoanh2k4@gmail.com', '$2b$10$yooYL11H93BP.rtMIUl1OuxEBvU1zuCDBeQuFFoDhuPngB10K16AC', '2025-11-19 03:30:42', '2025-11-19 03:30:42'),
('890ec1', 'vua', 'michaelmuku15946@gmail.com', '$2b$10$OQ5RTBYjEgfgecHLFtaQt.RqwPfUZdhtL9vLWG4TX7fzst.tojY5a', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('f0afeb', 'vu', 'vu784512000@gmail.com', '$2b$10$GHq/DEpMAyXEC3sbka/i1eS/DcGMdFCUv54fRhEjvvO8C5TmOQDlq', '2025-09-05 16:45:07', '2025-11-18 15:20:49');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_infor`
--

CREATE TABLE `user_infor` (
  `user_infor_id` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `citizen_id` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_general_ci,
  `avatar` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `background` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user_infor`
--

INSERT INTO `user_infor` (`user_infor_id`, `phone`, `dob`, `citizen_id`, `address`, `bio`, `avatar`, `background`, `user_id`, `created_at`, `updated_at`) VALUES
('189a8b69c5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '890ec1', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('58cfdef9f3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '869366', '2025-11-19 03:30:42', '2025-11-19 03:30:42'),
('eab00e57d9', '123456789', '2025-10-12', '123456789012', '121221', '2121212213123', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763460981/avatar/vjmiwxd2rxrv9r4iwl49.jpg', NULL, 'f0afeb', '2025-09-05 16:45:07', '2025-11-18 15:20:49');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `verify`
--

CREATE TABLE `verify` (
  `verify_id` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `verify_code` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `verify_status` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `verify`
--

INSERT INTO `verify` (`verify_id`, `user_id`, `verify_code`, `verify_status`, `created_at`, `updated_at`) VALUES
('714610', '890ec1', '236865', 0, '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('99b3a4', '869366', '879505', 1, '2025-11-19 03:30:42', '2025-11-19 03:30:57'),
('e4cffa', 'f0afeb', '516363', 1, '2025-09-05 16:45:07', '2025-09-11 12:19:39');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `guide_languages`
--
ALTER TABLE `guide_languages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guide_id` (`guide_id`);

--
-- Chỉ mục cho bảng `tours`
--
ALTER TABLE `tours`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tour_type` (`tour_type_id`),
  ADD KEY `fk_tour_category` (`tour_category_id`),
  ADD KEY `fk_tour_guide` (`guide_id`);

--
-- Chỉ mục cho bảng `tour_categories`
--
ALTER TABLE `tour_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Chỉ mục cho bảng `tour_guides`
--
ALTER TABLE `tour_guides`
  ADD PRIMARY KEY (`guide_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `tour_guide_assignment`
--
ALTER TABLE `tour_guide_assignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tour_guide` (`tour_id`,`tour_guide_id`),
  ADD KEY `tour_guide_id` (`tour_guide_id`);

--
-- Chỉ mục cho bảng `tour_images`
--
ALTER TABLE `tour_images`
  ADD PRIMARY KEY (`tour_img_id`),
  ADD KEY `folder_id` (`folder_id`);

--
-- Chỉ mục cho bảng `tour_image_assignment`
--
ALTER TABLE `tour_image_assignment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tour_img_id` (`tour_img_id`),
  ADD KEY `tour_id` (`tour_id`);

--
-- Chỉ mục cho bảng `tour_image_folders`
--
ALTER TABLE `tour_image_folders`
  ADD PRIMARY KEY (`folder_id`),
  ADD UNIQUE KEY `folder_name` (`folder_name`);

--
-- Chỉ mục cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `tour_id` (`tour_id`);

--
-- Chỉ mục cho bảng `tour_prices`
--
ALTER TABLE `tour_prices`
  ADD PRIMARY KEY (`price_id`);

--
-- Chỉ mục cho bảng `tour_price_assignments`
--
ALTER TABLE `tour_price_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tour_id` (`tour_id`),
  ADD KEY `price_id` (`price_id`);

--
-- Chỉ mục cho bảng `tour_ratings`
--
ALTER TABLE `tour_ratings`
  ADD PRIMARY KEY (`rating_id`),
  ADD KEY `tour_id` (`tour_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `tour_schedules`
--
ALTER TABLE `tour_schedules`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `tour_id` (`tour_id`);

--
-- Chỉ mục cho bảng `tour_type`
--
ALTER TABLE `tour_type`
  ADD PRIMARY KEY (`type_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `user_infor`
--
ALTER TABLE `user_infor`
  ADD PRIMARY KEY (`user_infor_id`),
  ADD KEY `fk_user_infor_user` (`user_id`);

--
-- Chỉ mục cho bảng `verify`
--
ALTER TABLE `verify`
  ADD PRIMARY KEY (`verify_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `guide_languages`
--
ALTER TABLE `guide_languages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tours`
--
ALTER TABLE `tours`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_categories`
--
ALTER TABLE `tour_categories`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_guides`
--
ALTER TABLE `tour_guides`
  MODIFY `guide_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tour_guide_assignment`
--
ALTER TABLE `tour_guide_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_images`
--
ALTER TABLE `tour_images`
  MODIFY `tour_img_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tour_image_assignment`
--
ALTER TABLE `tour_image_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `tour_image_folders`
--
ALTER TABLE `tour_image_folders`
  MODIFY `folder_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  MODIFY `location_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_prices`
--
ALTER TABLE `tour_prices`
  MODIFY `price_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_price_assignments`
--
ALTER TABLE `tour_price_assignments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tour_ratings`
--
ALTER TABLE `tour_ratings`
  MODIFY `rating_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_schedules`
--
ALTER TABLE `tour_schedules`
  MODIFY `schedule_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_type`
--
ALTER TABLE `tour_type`
  MODIFY `type_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `guide_languages`
--
ALTER TABLE `guide_languages`
  ADD CONSTRAINT `guide_languages_ibfk_1` FOREIGN KEY (`guide_id`) REFERENCES `tour_guides` (`guide_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tours`
--
ALTER TABLE `tours`
  ADD CONSTRAINT `fk_tour_category` FOREIGN KEY (`tour_category_id`) REFERENCES `tour_categories` (`category_id`),
  ADD CONSTRAINT `fk_tour_guide` FOREIGN KEY (`guide_id`) REFERENCES `tour_guides` (`guide_id`),
  ADD CONSTRAINT `fk_tour_type` FOREIGN KEY (`tour_type_id`) REFERENCES `tour_type` (`type_id`);

--
-- Các ràng buộc cho bảng `tour_guide_assignment`
--
ALTER TABLE `tour_guide_assignment`
  ADD CONSTRAINT `tour_guide_assignment_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tour_guide_assignment_ibfk_2` FOREIGN KEY (`tour_guide_id`) REFERENCES `tour_guides` (`guide_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tour_images`
--
ALTER TABLE `tour_images`
  ADD CONSTRAINT `tour_images_ibfk_1` FOREIGN KEY (`folder_id`) REFERENCES `tour_image_folders` (`folder_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tour_image_assignment`
--
ALTER TABLE `tour_image_assignment`
  ADD CONSTRAINT `tour_image_assignment_ibfk_1` FOREIGN KEY (`tour_img_id`) REFERENCES `tour_images` (`tour_img_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tour_image_assignment_ibfk_2` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  ADD CONSTRAINT `tour_locations_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tour_price_assignments`
--
ALTER TABLE `tour_price_assignments`
  ADD CONSTRAINT `tour_price_assignments_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tour_price_assignments_ibfk_2` FOREIGN KEY (`price_id`) REFERENCES `tour_prices` (`price_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tour_ratings`
--
ALTER TABLE `tour_ratings`
  ADD CONSTRAINT `tour_ratings_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tour_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tour_schedules`
--
ALTER TABLE `tour_schedules`
  ADD CONSTRAINT `tour_schedules_ibfk_1` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `user_infor`
--
ALTER TABLE `user_infor`
  ADD CONSTRAINT `fk_user_infor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `verify`
--
ALTER TABLE `verify`
  ADD CONSTRAINT `verify_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
