-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 29, 2025 lúc 10:13 AM
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
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` char(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `body` text DEFAULT NULL,
  `type` enum('payment','profile','general') DEFAULT 'general',
  `reference_id` varchar(100) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `body`, `type`, `reference_id`, `is_read`, `created_at`, `updated_at`) VALUES
(1, 'f0afeb', 'Thanh toán thành công', 'Đơn hàng #31 - Du lịch Phú Quốc đã được thanh toán thành công.', 'payment', '31', 1, '2025-11-29 08:36:06', '2025-11-29 08:51:56'),
(2, 'f0afeb', 'Thanh toán thành công', 'Đơn hàng #32 - Du lịch Phú Quốc đã được thanh toán thành công.', 'payment', '32', 0, '2025-11-29 08:55:07', '2025-11-29 08:55:07'),
(3, 'f0afeb', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #32 - Du lịch Phú Quốc đã được admin xác nhận thành công.', 'payment', '32', 0, '2025-11-29 08:55:28', '2025-11-29 08:55:28'),
(4, 'f0afeb', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 0, '2025-11-29 09:07:16', '2025-11-29 09:07:16');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `number_of_child` int(11) DEFAULT 0,
  `number_of_adult` int(11) DEFAULT 1,
  `name_tourist` varchar(100) NOT NULL,
  `phone_tourist` varchar(20) NOT NULL,
  `email_tourist` varchar(100) DEFAULT NULL,
  `total` decimal(15,2) NOT NULL,
  `order_at` datetime DEFAULT current_timestamp(),
  `note` text DEFAULT NULL,
  `type_confirm_id` int(11) NOT NULL DEFAULT 1,
  `user_id` varchar(6) NOT NULL,
  `tour_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `number_of_child`, `number_of_adult`, `name_tourist`, `phone_tourist`, `email_tourist`, `total`, `order_at`, `note`, `type_confirm_id`, `user_id`, `tour_id`) VALUES
(1, 2, 4, 'Lê Thị Kim Oanh', '0332199694', 'lethikimoanh2k4@gmail.com', 3000000.00, '2025-11-21 20:56:53', NULL, 2, '869366', 2),
(13, 1, 1, 'oanh', '0332199694', 'kimoanh@gmail.com', 1000000.00, '2025-11-22 11:30:35', '', 1, '869366', 2),
(14, 1, 2, 'Kim Oanh', '0332199694', 'lethikimoanh2k4@gmail.com', 2500000.00, '2025-11-22 11:52:29', '', 1, '869366', 4),
(15, 1, 1, 'oanh', '0123456789', 'oanh@gmail.com', 1500000.00, '2025-11-22 11:55:45', '', 1, '869366', 4),
(16, 1, 1, 'Oanh', '0332199694', 'kimoanh@gmail.com', 1500000.00, '2025-11-22 11:57:19', '', 1, '869366', 4),
(17, 1, 1, 'Ozzzz', '0123456789', 'lethikimoanh2k4@gmail.com', 1500000.00, '2025-11-22 12:12:56', '', 1, '869366', 4),
(18, 2, 2, 'Kim Oanh', '0332199694', 'lethikimoanh2k4@gmail.com', 3000000.00, '2025-11-22 12:38:44', '', 1, '869366', 4),
(19, 2, 1, 'Kim Oanh', '0332199694', 'oanhltk.22it@vku.udn.vn', 2000000.00, '2025-11-22 12:47:13', '', 1, '869366', 4),
(20, 3, 3, 'Anh Vu', '0123456789', 'anhvu@gmail.com', 4500000.00, '2025-11-22 14:31:55', '', 1, '869366', 4),
(21, 1, 1, 'Anh Vu', '0123456789', 'anhvu@gmail.com', 1500000.00, '2025-11-22 14:41:45', '', 1, '869366', 4),
(22, 1, 1, 'Cuong', '0987654321', 'cuongnq@gmail.com', 1000000.00, '2025-11-22 14:45:32', '', 1, '869366', 3),
(23, 0, 1, 'Cuong', '0987654321', 'cuongnq@gmail.com', 700000.00, '2025-11-22 14:49:19', '', 1, '869366', 3),
(24, 1, 1, 'Đạt', '0123456789', 'dat@gmail.com', 1500000.00, '2025-11-24 21:21:10', '', 1, '869366', 4),
(25, 1, 1, 'vu', '0123456789', 'vu@gmail.com', 1500000.00, '2025-11-24 22:03:56', '', 2, '869366', 4),
(26, 1, 2, 'cuong', '0123456789', 'vu@gmail.com', 2500000.00, '2025-11-24 22:11:18', '', 1, '869366', 4),
(27, 1, 2, 'cuong', '0123456789', 'vu@gmail.com', 2500000.00, '2025-11-24 22:13:30', '', 1, '869366', 4),
(28, 1, 1, 'vua', '123456789', 'vua@gmail.com', 1500000.00, '2025-11-24 23:25:35', '', 1, 'f0afeb', 4),
(29, 1, 1, 'Vu', '0905307261', 'vu784512000@gmail.com', 1500000.00, '2025-11-27 12:02:52', '123456', 1, 'f0afeb', 4),
(30, 1, 1, 'Vu', '0905307261', 'vu@gmail.com', 1500000.00, '2025-11-27 14:20:32', '123456', 3, 'f0afeb', 4),
(31, 1, 1, 'vua', '0123456789', 'vu784512000@gmail.com', 1500000.00, '2025-11-29 15:34:13', '', 3, 'f0afeb', 4),
(32, 0, 1, 'Vu', '0123456789', 'vu784512000@gmail.com', 1000000.00, '2025-11-29 15:54:05', '', 2, 'f0afeb', 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `post_id` varchar(10) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `content` text DEFAULT NULL,
  `privacy` enum('public','friends','private') DEFAULT 'public',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `posts`
--

INSERT INTO `posts` (`post_id`, `user_id`, `content`, `privacy`, `created_at`, `updated_at`) VALUES
('POST_e08e6', 'f0afeb', 'Đẹp', 'public', '2025-11-29 09:12:58', '2025-11-29 09:12:58');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_images`
--

CREATE TABLE `post_images` (
  `image_id` varchar(12) NOT NULL,
  `post_id` varchar(10) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_images`
--

INSERT INTO `post_images` (`image_id`, `post_id`, `image_url`, `created_at`) VALUES
('IMG_5cda0d46', 'POST_e08e6', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764407645/posts/vu/xgg1nnz2b0m18azx8cy4.png', '2025-11-29 09:13:05');

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
  `tour_type_id` int(11) DEFAULT NULL,
  `guide_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tours`
--

INSERT INTO `tours` (`id`, `name`, `number_of_people`, `start_date`, `end_date`, `departure_address`, `destination_address`, `created_at`, `status`, `tour_category_id`, `tour_type_id`, `guide_id`) VALUES
(2, 'Khám Phá Vịnh Hạ Long', 20, '2025-11-18', '2025-11-21', 'Sân bay Nội Bài, Hà Nội', 'Đà Lạt, Lâm Đồng', '2025-11-19 10:40:46', 'Hoạt động', 1, 1, NULL),
(3, 'Khám Phá Hà Giang - Lũng Cú', 15, '2025-11-21', '2025-11-29', 'Hà Nội', 'Lũng Cú', '2025-11-20 07:56:30', 'Hoạt động', 1, 1, NULL),
(4, 'Du lịch Phú Quốc', 10, '2025-11-25', '2025-11-28', 'Hà Nội', 'Phú Quốc', '2025-11-21 17:20:30', 'Hoạt động', 1, 3, NULL);

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
(1, 'Nội địa', NULL, '2025-11-19 10:38:38'),
(2, 'Quốc Tế', NULL, '2025-11-19 10:38:49');

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
  `language_job` varchar(255) DEFAULT NULL,
  `certification` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `avatar_image` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_guides`
--

INSERT INTO `tour_guides` (`guide_id`, `guide_name`, `email`, `phone`, `birthday`, `gender`, `language_job`, `certification`, `address`, `avatar_image`) VALUES
(2, 'Nguyễn Đình Anh Vũ', 'anhvu@gmail.com', '0332199694', '2004-10-05', 'male', 'Tiếng Anh', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720488/tour-guide/certifications/x7imo7b6wfxcfolurf2i.jpg', 'Gia Lai', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720485/tour-guide/avatars/x30vl8usqj51jyzmco6k.png'),
(3, 'Nguyễn Quốc Cường', 'cuongnq@gmail.com', '098765432', '2001-06-02', 'male', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634609/tour-guide/certifications/hz91iyzeydkjykkepouc.jpg', 'Thái Nguyên', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634607/tour-guide/avatars/f36skzkx92an7pojw1kw.jpg'),
(4, 'Lê Thị Kim Oanh', 'lethikimoanh2k4@gmail.com', '0332199694', '2004-09-09', 'female', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634990/tour-guide/certifications/recfr6oelua7nb7tjikc.jpg', 'Phường Vũng Áng - Hà Tĩnh', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634987/tour-guide/avatars/epldmaqgj2qsiksdol9r.jpg');

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

--
-- Đang đổ dữ liệu cho bảng `tour_guide_assignment`
--

INSERT INTO `tour_guide_assignment` (`id`, `created_at`, `tour_id`, `tour_guide_id`) VALUES
(1, '2025-11-20 14:46:31', 3, 2),
(2, '2025-11-20 16:46:16', 2, 3),
(3, '2025-11-21 17:20:39', 4, 4);

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
(1, 1, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763459775/tour-images/DN/pmwy1ruzc8cbhv6sv0xb.jpg', '2025-11-18 16:55:22'),
(2, 1, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763697721/tour-images/DN/eefwwc8toh9hqpvhuyh8.jpg', '2025-11-21 11:02:03'),
(6, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720621/tour-images/Tour%20Mate/k0jxlnimjyfjbgka3cmb.jpg', '2025-11-21 17:23:45'),
(7, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720624/tour-images/Tour%20Mate/cvhtg3ihrexpr3kyudqh.jpg', '2025-11-21 17:23:45');

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
(8, 2, 2),
(11, 7, 4),
(12, 6, 3),
(13, 6, 4);

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
(1, 'DN', '2025-11-12 19:33:37'),
(3, 'Tour Mate', '2025-11-21 17:23:24');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_locations`
--

CREATE TABLE `tour_locations` (
  `location_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `location_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_locations`
--

INSERT INTO `tour_locations` (`location_id`, `tour_id`, `location_name`, `description`, `latitude`, `longitude`) VALUES
(3, 4, 'Phú Quốc', NULL, 10.213949, 103.98626),
(4, 2, 'Hạ Long', 'Thiên đường sông nước của Việt Nam', 20.952133, 107.079765);

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
(2, 700000, 300000, '2025-11-20', '2025-11-28'),
(3, 1000000, 500000, '2025-11-22', '2025-11-30');

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
(1, 2, 2),
(2, 3, 2),
(3, 4, 3);

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

--
-- Đang đổ dữ liệu cho bảng `tour_schedules`
--

INSERT INTO `tour_schedules` (`schedule_id`, `tour_id`, `day_number`, `description`) VALUES
(1, 4, 6, 'Ok lắm ');

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
(1, 'Tour gia đình', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763695991/tour-type/w6arkv53vdofqqwwzerc.jpg', NULL, '2025-11-19 10:38:57'),
(2, 'Tour một mình', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763696009/tour-type/x8nocds1dby1mb8zrrgk.jpg', NULL, '2025-11-19 10:39:05'),
(3, 'Tour nhóm', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763696023/tour-type/xj5ti62a3et4oxoiyqtd.jpg', NULL, '2025-11-21 10:33:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `type_confirms`
--

CREATE TABLE `type_confirms` (
  `id` int(11) NOT NULL,
  `type_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `type_confirms`
--

INSERT INTO `type_confirms` (`id`, `type_name`) VALUES
(1, 'Đang chờ xác nhận'),
(2, 'Đã xác nhận'),
(3, 'Đã thanh toán');

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
('869366', 'Kim Oanh', 'lethikimoanh2k4@gmail.com', '$2b$10$yooYL11H93BP.rtMIUl1OuxEBvU1zuCDBeQuFFoDhuPngB10K16AC', '2025-11-19 03:30:42', '2025-11-21 10:30:56'),
('890ec1', 'vua', 'michaelmuku15946@gmail.com', '$2b$10$OQ5RTBYjEgfgecHLFtaQt.RqwPfUZdhtL9vLWG4TX7fzst.tojY5a', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('f0afeb', 'vu', 'vu784512000@gmail.com', '$2b$10$D7y.FwSfRJ37E0H76AL.nuP1bDYv/gachY6UdkmkXoy4e3/gps2M.', '2025-09-05 16:45:07', '2025-11-29 09:07:16');

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
('58cfdef9f3', '0332199694', '2004-09-10', '042304011674', 'Vung Ang, Ha Tinh', 'Helloooooo', NULL, NULL, '869366', '2025-11-19 03:30:42', '2025-11-21 10:30:56'),
('eab00e57d9', '123456789', '2025-10-07', '123456789012', '121221', '2121212213123', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764044502/avatar/sxuls6e58mfw4t1sxwba.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764407296/background/dbwmrmktusoplate3gej.png', 'f0afeb', '2025-09-05 16:45:07', '2025-11-29 09:07:16');

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
('99b3a4', '869366', '879505', 1, '2025-11-19 03:30:42', '2025-11-19 03:30:57'),
('e4cffa', 'f0afeb', '588749', 1, '2025-09-05 16:45:07', '2025-11-29 08:31:35');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user` (`user_id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type_confirm_id` (`type_confirm_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `tour_id` (`tour_id`);

--
-- Chỉ mục cho bảng `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `idx_posts_user` (`user_id`);

--
-- Chỉ mục cho bảng `post_images`
--
ALTER TABLE `post_images`
  ADD PRIMARY KEY (`image_id`);

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
-- Chỉ mục cho bảng `type_confirms`
--
ALTER TABLE `type_confirms`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT cho bảng `tours`
--
ALTER TABLE `tours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tour_categories`
--
ALTER TABLE `tour_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_guides`
--
ALTER TABLE `tour_guides`
  MODIFY `guide_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tour_guide_assignment`
--
ALTER TABLE `tour_guide_assignment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_images`
--
ALTER TABLE `tour_images`
  MODIFY `tour_img_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `tour_image_assignment`
--
ALTER TABLE `tour_image_assignment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `tour_image_folders`
--
ALTER TABLE `tour_image_folders`
  MODIFY `folder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tour_prices`
--
ALTER TABLE `tour_prices`
  MODIFY `price_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_price_assignments`
--
ALTER TABLE `tour_price_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_ratings`
--
ALTER TABLE `tour_ratings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tour_schedules`
--
ALTER TABLE `tour_schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tour_type`
--
ALTER TABLE `tour_type`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT cho bảng `type_confirms`
--
ALTER TABLE `type_confirms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`type_confirm_id`) REFERENCES `type_confirms` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`tour_id`) REFERENCES `tours` (`id`);

--
-- Các ràng buộc cho bảng `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `fk_posts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
