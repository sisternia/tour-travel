-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 14, 2025 lúc 08:14 AM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `tour-travel`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `guide_languages`
--

CREATE TABLE `guide_languages` (
  `id` int(11) NOT NULL,
  `guide_id` int(11) NOT NULL,
  `language_job` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tours`
--

CREATE TABLE `tours` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `number_of_people` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `departure_address` varchar(255) NOT NULL,
  `destination_address` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` varchar(50) DEFAULT NULL,
  `tour_category_id` int(11) DEFAULT NULL,
  `tour_type_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tours`
--

INSERT INTO `tours` (`id`, `name`, `number_of_people`, `start_date`, `end_date`, `departure_address`, `destination_address`, `created_at`, `status`, `tour_category_id`, `tour_type_id`) VALUES
(1, 'Đà Nẵng - Thiên đường', 30, '2025-11-11', '2025-11-16', 'Gia Lai', 'Đà Nẵng', '2025-11-11 09:01:36', 'Hoạt động', 1, 127);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_categories`
--

CREATE TABLE `tour_categories` (
  `category_id` int(11) NOT NULL,
  `categories_name` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_categories`
--

INSERT INTO `tour_categories` (`category_id`, `categories_name`, `image`, `created_at`) VALUES
(1, 'Nội địa ', NULL, '2025-11-05 17:18:06'),
(2, 'Quốc tế', '/assets/tour-category/1762943292102.png', '2025-11-05 17:18:18');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_guides`
--

CREATE TABLE `tour_guides` (
  `guide_id` int(11) NOT NULL,
  `guide_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `birthday` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `certification` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `avatar_image` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_guide_assignment`
--

CREATE TABLE `tour_guide_assignment` (
  `id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `tour_id` int(11) NOT NULL,
  `tour_guide_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_images`
--

CREATE TABLE `tour_images` (
  `tour_img_id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  `tour_img` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_images`
--

INSERT INTO `tour_images` (`tour_img_id`, `folder_id`, `tour_img`, `created_at`) VALUES
(11, 1, '/assets/tour-images/DN/1762954479901-309456981.jpg', '2025-11-12 20:34:39'),
(12, 1, '/assets/tour-images/DN/1763024873858-792292240.jpg', '2025-11-13 16:07:53'),
(13, 1, '/assets/tour-images/DN/1763026062573-255219337.jpg', '2025-11-13 16:27:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_image_assignment`
--

CREATE TABLE `tour_image_assignment` (
  `id` int(11) NOT NULL,
  `tour_img_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_image_assignment`
--

INSERT INTO `tour_image_assignment` (`id`, `tour_img_id`, `tour_id`) VALUES
(10, 12, 1),
(13, 11, 1),
(15, 13, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_image_folders`
--

CREATE TABLE `tour_image_folders` (
  `folder_id` int(11) NOT NULL,
  `folder_name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
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
  `location_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `location_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_prices`
--

CREATE TABLE `tour_prices` (
  `price_id` int(11) NOT NULL,
  `price_adult` double NOT NULL,
  `price_child` double NOT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_prices`
--

INSERT INTO `tour_prices` (`price_id`, `price_adult`, `price_child`, `valid_from`, `valid_to`) VALUES
(1, 1000000, 500000, '2025-11-11', '2025-11-30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_price_assignments`
--

CREATE TABLE `tour_price_assignments` (
  `id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `price_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_price_assignments`
--

INSERT INTO `tour_price_assignments` (`id`, `tour_id`, `price_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_ratings`
--

CREATE TABLE `tour_ratings` (
  `rating_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `rating_value` tinyint(4) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_schedules`
--

CREATE TABLE `tour_schedules` (
  `schedule_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `day_number` int(11) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_type`
--

CREATE TABLE `tour_type` (
  `type_id` int(11) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_type`
--

INSERT INTO `tour_type` (`type_id`, `type_name`, `image`, `description`, `created_at`) VALUES
(127, 'Vùng biển', '/assets/tour-type/1762335785712.png', NULL, '2025-11-05 16:43:05'),
(128, 'Vùng núi', '/assets/tour-type/1762336657958.png', NULL, '2025-11-05 16:57:37');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
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
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password`, `created_at`, `updated_at`) VALUES
('890ec1', 'vua', 'michaelmuku15946@gmail.com', '$2b$10$OQ5RTBYjEgfgecHLFtaQt.RqwPfUZdhtL9vLWG4TX7fzst.tojY5a', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('f0afeb', 'vua', 'vu784512000@gmail.com', '$2b$10$GHq/DEpMAyXEC3sbka/i1eS/DcGMdFCUv54fRhEjvvO8C5TmOQDlq', '2025-09-05 16:45:07', '2025-10-26 03:38:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_infor`
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
-- Đang đổ dữ liệu cho bảng `user_infor`
--

INSERT INTO `user_infor` (`user_infor_id`, `phone`, `dob`, `citizen_id`, `address`, `bio`, `avatar`, `background`, `user_id`, `created_at`, `updated_at`) VALUES
('189a8b69c5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '890ec1', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('eab00e57d9', '1', '2025-10-19', '121212', '121221', '2121212', '/assets/avatar/avatar-1761449887809-679564255.jpg', NULL, 'f0afeb', '2025-09-05 16:45:07', '2025-10-26 03:38:07');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `verify`
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
-- Đang đổ dữ liệu cho bảng `verify`
--

INSERT INTO `verify` (`verify_id`, `user_id`, `verify_code`, `verify_status`, `created_at`, `updated_at`) VALUES
('714610', '890ec1', '236865', 0, '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
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
  ADD KEY `fk_tour_category` (`tour_category_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tours`
--
ALTER TABLE `tours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tour_categories`
--
ALTER TABLE `tour_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_guides`
--
ALTER TABLE `tour_guides`
  MODIFY `guide_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_guide_assignment`
--
ALTER TABLE `tour_guide_assignment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_images`
--
ALTER TABLE `tour_images`
  MODIFY `tour_img_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `tour_image_assignment`
--
ALTER TABLE `tour_image_assignment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `tour_image_folders`
--
ALTER TABLE `tour_image_folders`
  MODIFY `folder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_prices`
--
ALTER TABLE `tour_prices`
  MODIFY `price_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tour_price_assignments`
--
ALTER TABLE `tour_price_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tour_ratings`
--
ALTER TABLE `tour_ratings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_schedules`
--
ALTER TABLE `tour_schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_type`
--
ALTER TABLE `tour_type`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

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
