-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th12 01, 2025 lúc 04:16 PM
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
-- Cơ sở dữ liệu: `tour-travel6`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` int NOT NULL,
  `user_id` char(36) COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `body` text COLLATE utf8mb4_general_ci,
  `type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reference_id` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `body`, `type`, `reference_id`, `is_read`, `created_at`, `updated_at`) VALUES
(3, 'f49004', 'Thanh toán thành công', 'Đơn hàng #39 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '39', 1, '2025-11-27 08:58:40', '2025-11-27 08:59:53'),
(11, 'f49004', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 1, '2025-11-27 09:50:27', '2025-11-27 09:52:46'),
(15, 'f49004', 'Thanh toán thành công', 'Đơn hàng #48 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '48', 0, '2025-11-28 02:11:26', '2025-11-28 02:11:26'),
(16, 'f49004', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #48 - Khám Phá Hà Giang - Lũng Cú đã được admin xác nhận thành công.', 'payment', '48', 1, '2025-11-28 02:11:40', '2025-11-29 11:37:52'),
(18, '869366', 'Thanh toán thành công', 'Đơn hàng #26 - Du lịch Phú Quốc đã được thanh toán thành công.', 'payment', '26', 1, '2025-11-29 07:23:56', '2025-11-30 03:23:01'),
(21, 'f49004', 'Thanh toán thành công', 'Đơn hàng #53 - Khám Phá Vịnh Hạ Long - Kỳ Quan Thiên Nhiên Thế Giới đã được thanh toán thành công.', 'payment', '53', 1, '2025-11-29 11:09:16', '2025-11-29 11:37:51'),
(22, 'f49004', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 0, '2025-11-29 11:23:55', '2025-11-29 11:23:55'),
(23, 'f49004', 'Thanh toán thành công', 'Đơn hàng #55 - Khám Phá Vịnh Hạ Long - Kỳ Quan Thiên Nhiên Thế Giới đã được thanh toán thành công.', 'payment', '55', 1, '2025-11-29 11:28:30', '2025-11-29 11:37:51'),
(25, 'f49004', 'Thanh toán thành công', 'Đơn hàng #57 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '57', 0, '2025-11-29 11:37:22', '2025-11-29 11:37:22'),
(26, '1a02f1', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 0, '2025-11-29 11:55:24', '2025-11-29 11:55:24'),
(27, 'a811e0', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 0, '2025-11-29 11:57:26', '2025-11-29 11:57:26'),
(28, '764674', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 0, '2025-11-29 12:00:58', '2025-11-29 12:00:58'),
(29, '764674', 'Cảm xúc mới', 'cuong3 đã thích bài viết của bạn', '', 'POST_9d8bc', 1, '2025-11-29 12:02:05', '2025-11-29 12:05:18'),
(30, '764674', 'Cảm xúc mới', 'cuong3 đã thả tim bài viết của bạn', '', 'POST_9d8bc', 1, '2025-11-29 12:02:27', '2025-11-29 12:05:18'),
(31, '764674', 'Cảm xúc mới', 'cuong2 đã cười bài viết của bạn', '', 'POST_9d8bc', 1, '2025-11-29 12:02:47', '2025-11-29 12:05:17'),
(32, '764674', 'Cảm xúc mới', 'CuongNguyen đã buồn bài viết của bạn', '', 'POST_9d8bc', 1, '2025-11-29 12:03:15', '2025-11-29 12:05:17'),
(33, '764674', 'Cảm xúc mới', 'cuong2 đã buồn bài viết của bạn', '', 'POST_9d8bc', 1, '2025-11-29 12:05:08', '2025-11-29 12:05:16'),
(34, 'f49004', 'Cảm xúc mới', 'cuong3 đã thả tim bài viết của bạn', '', 'POST_a0dfc', 1, '2025-11-29 12:11:40', '2025-11-29 13:37:08'),
(35, 'f49004', 'Cảm xúc mới', 'cuong7 đã wow bài viết của bạn', '', 'POST_a0dfc', 1, '2025-11-29 12:11:54', '2025-11-29 13:37:07'),
(36, 'f49004', 'Bình luận mới', 'cuong3 đã bình luận bài viết của bạn', '', 'POST_a0dfc', 1, '2025-11-29 12:12:08', '2025-11-29 12:12:15'),
(37, 'f49004', 'Bình luận mới', 'cuong7 đã bình luận bài viết của bạn', '', 'POST_a0dfc', 1, '2025-11-29 12:12:30', '2025-11-29 13:28:16'),
(38, 'f49004', 'Chia sẻ bài viết', 'cuong3 đã chia sẻ bài viết của CuongNguyen', '', 'POST_a0dfc', 0, '2025-11-29 13:30:02', '2025-11-29 13:30:02'),
(39, 'a811e0', 'Chia sẻ bài viết', 'CuongNguyen đã chia sẻ bài viết của cuong3', '', 'POST_4710d', 0, '2025-11-29 13:36:30', '2025-11-29 13:36:30'),
(40, 'f49004', 'Cảm xúc mới', 'cuong7 đã thích bài viết của bạn', '', 'POST_0f1db', 0, '2025-11-29 13:36:46', '2025-11-29 13:36:46'),
(41, 'f49004', 'Cảm xúc mới', 'cuong7 đã cười bài viết của bạn', '', 'POST_0f1db', 1, '2025-11-29 13:36:58', '2025-11-29 13:37:04'),
(42, 'f49004', 'Cảm xúc mới', 'cuong7 đã cười bài viết của bạn', '', 'POST_2107f', 0, '2025-11-29 13:37:29', '2025-11-29 13:37:29'),
(43, 'f49004', 'Thanh toán thành công', 'Đơn hàng #59 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '59', 0, '2025-11-29 13:48:46', '2025-11-29 13:48:46'),
(44, 'f49004', 'Thanh toán thành công', 'Đơn hàng #61 - Du lịch Phú Quốc đã được thanh toán thành công.', 'payment', '61', 0, '2025-11-29 14:26:57', '2025-11-29 14:26:57'),
(45, '869366', 'Thanh toán thành công', 'Đơn hàng #62 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '62', 1, '2025-11-29 15:40:22', '2025-11-30 03:23:01'),
(46, '869366', 'Thanh toán thành công', 'Đơn hàng #63 - Hàn Quốc - Seoul & Jeju đã được thanh toán thành công.', 'payment', '63', 1, '2025-11-30 02:02:25', '2025-11-30 03:23:01'),
(47, '869366', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #63 - Hàn Quốc - Seoul & Jeju đã được admin xác nhận thành công.', 'payment', '63', 1, '2025-11-30 04:10:10', '2025-11-30 07:34:35'),
(48, '869366', 'Thanh toán thành công', 'Đơn hàng #63 - Hàn Quốc - Seoul & Jeju đã được thanh toán thành công.', 'payment', '63', 0, '2025-11-30 08:00:29', '2025-11-30 08:00:29'),
(49, '869366', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #63 - Hàn Quốc - Seoul & Jeju đã được admin xác nhận thành công.', 'payment', '63', 0, '2025-11-30 08:00:32', '2025-11-30 08:00:32'),
(50, '869366', 'Thanh toán thành công', 'Đơn hàng #63 - Hàn Quốc - Seoul & Jeju đã được thanh toán thành công.', 'payment', '63', 0, '2025-11-30 08:00:34', '2025-11-30 08:00:34'),
(51, '869366', 'Thanh toán thành công', 'Đơn hàng #64 - Hà Giang - Lũng Cú khám phá núi đá đã được thanh toán thành công.', 'payment', '64', 1, '2025-11-30 08:15:36', '2025-11-30 08:15:49'),
(52, '869366', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #64 - Hà Giang - Lũng Cú khám phá núi đá đã được admin xác nhận thành công.', 'payment', '64', 0, '2025-11-30 08:16:10', '2025-11-30 08:16:10'),
(53, '869366', 'Thanh toán thành công', 'Đơn hàng #65 - Hà Giang - Lũng Cú khám phá núi đá đã được thanh toán thành công.', 'payment', '65', 0, '2025-11-30 09:06:22', '2025-11-30 09:06:22'),
(54, '869366', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #65 - Hà Giang - Lũng Cú khám phá núi đá đã được admin xác nhận thành công.', 'payment', '65', 0, '2025-11-30 09:06:54', '2025-11-30 09:06:54'),
(55, '869366', 'Thanh toán thành công', 'Đơn hàng #66 - Hàn Quốc - Seoul & Jeju đã được thanh toán thành công.', 'payment', '66', 0, '2025-11-30 09:23:14', '2025-11-30 09:23:14'),
(56, '869366', 'Thanh toán thành công', 'Đơn hàng #66 - Hàn Quốc - Seoul & Jeju đã được thanh toán thành công.', 'payment', '66', 0, '2025-11-30 09:23:16', '2025-11-30 09:23:16'),
(57, '869366', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #66 - Hàn Quốc - Seoul & Jeju đã được admin xác nhận thành công.', 'payment', '66', 0, '2025-11-30 09:24:28', '2025-11-30 09:24:28'),
(58, '869366', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #63 - Hàn Quốc - Seoul & Jeju đã được admin xác nhận thành công.', 'payment', '63', 0, '2025-11-30 09:34:52', '2025-11-30 09:34:52');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `number_of_child` int DEFAULT '0',
  `number_of_adult` int DEFAULT '1',
  `name_tourist` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `phone_tourist` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `email_tourist` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `total` decimal(15,2) NOT NULL,
  `order_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `note` text COLLATE utf8mb4_general_ci,
  `type_confirm_id` int NOT NULL DEFAULT '1',
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `tour_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `number_of_child`, `number_of_adult`, `name_tourist`, `phone_tourist`, `email_tourist`, `total`, `order_at`, `note`, `type_confirm_id`, `user_id`, `tour_id`) VALUES
(63, 1, 1, 'Le Thi Kim Oanh', '0332199694', 'lethikimoanh2k4@gmail.com', 27000000.00, '2025-11-30 09:01:22', '', 4, '869366', 6),
(64, 0, 2, 'Trần Văn Đạt', '0332199694', 'lethikimoanh2k4@gmail.com', 3000000.00, '2025-11-30 15:15:20', '', 4, '869366', 5);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `post_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `content` text COLLATE utf8mb4_general_ci,
  `privacy` enum('public','friends','private') COLLATE utf8mb4_general_ci DEFAULT 'public',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `shared_from_post_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shared_from_user_id` varchar(6) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `shared_note` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `posts`
--

INSERT INTO `posts` (`post_id`, `user_id`, `content`, `privacy`, `created_at`, `updated_at`, `shared_from_post_id`, `shared_from_user_id`, `shared_note`) VALUES
('POST_0f1db', 'f49004', 'tao là cường 3', 'public', '2025-11-29 13:36:30', '2025-11-29 13:36:30', 'POST_4710d', 'a811e0', 'Bạn đã chia sẻ bài viết của cuong3'),
('POST_2107f', 'f49004', 'hahaha', 'public', '2025-11-29 07:09:50', '2025-11-29 07:09:50', NULL, NULL, NULL),
('POST_28ccd', 'a811e0', 'ảnh đẹp không??', 'public', '2025-11-29 13:30:02', '2025-11-29 13:30:02', 'POST_a0dfc', 'f49004', 'Bạn đã chia sẻ bài viết của CuongNguyen'),
('POST_4710d', 'a811e0', 'tao là cường 3', 'public', '2025-11-29 12:01:57', '2025-11-29 12:01:57', NULL, NULL, NULL),
('POST_9b484', 'f49004', 'alo', 'public', '2025-11-29 11:07:44', '2025-11-29 11:07:44', NULL, NULL, NULL),
('POST_9d8bc', '764674', 'tao là cường 7', 'public', '2025-11-29 12:01:15', '2025-11-29 12:01:15', NULL, NULL, NULL),
('POST_a0dfc', 'f49004', 'ảnh đẹp không??', 'public', '2025-11-29 12:11:12', '2025-11-29 12:11:12', NULL, NULL, NULL),
('POST_a4782', 'ab7743', 'test bài nha', 'public', '2025-11-29 08:29:33', '2025-11-29 08:29:33', NULL, NULL, NULL),
('POST_b20ee', '1a02f1', 'tao là cường 2', 'public', '2025-11-29 12:01:47', '2025-11-29 12:01:47', NULL, NULL, NULL),
('POST_ca4cccac-cf07-42df-a63b-e2c91f85bedb', '869366', 'ok  nhe', 'public', '2025-11-30 03:22:46', '2025-11-30 03:22:46', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_comments`
--

CREATE TABLE `post_comments` (
  `comment_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `post_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `content` text COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_comments`
--

INSERT INTO `post_comments` (`comment_id`, `post_id`, `user_id`, `content`, `created_at`, `updated_at`) VALUES
('COMMENT_0c3df5b7-b7ca-4e00-9b52-82d043e32c87', 'POST_a0dfc', '764674', 'xấu vc', '2025-11-29 12:12:30', '2025-11-29 12:12:30'),
('COMMENT_183f6abc-813c-4bc8-bb71-e8c97c8c123a', 'POST_a0dfc', 'a811e0', 'đẹp quá hen', '2025-11-29 12:12:08', '2025-11-29 12:12:08'),
('COMMENT_6aaa84d9-e54c-460c-8ce5-33bc84e05dcd', 'POST_a4782', 'f49004', 'cmt', '2025-11-29 08:43:11', '2025-11-29 08:43:11'),
('COMMENT_779f100f-b3fe-4654-b9e3-5e929bba0877', 'POST_47fec', 'f49004', 'okoe', '2025-11-29 08:16:45', '2025-11-29 08:16:45'),
('COMMENT_929016e2-f931-463a-8232-c0edaf6558e2', 'POST_a4782', 'f49004', 'tao là cươnfg nè', '2025-11-29 08:30:23', '2025-11-29 08:30:23');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_images`
--

CREATE TABLE `post_images` (
  `image_id` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `post_id` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_images`
--

INSERT INTO `post_images` (`image_id`, `post_id`, `image_url`, `created_at`) VALUES
('IMG_14e466fe', 'POST_28ccd', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764418275/posts/CuongNguyen/ub4yb3wt6xlpryfj7lai.jpg', '2025-11-29 13:30:02'),
('IMG_5dc7eba8', 'POST_2107f', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764400193/posts/CuongNguyen2/taqvlkpao4wlqifrgbe9.jpg', '2025-11-29 07:09:53'),
('IMG_ab349713', 'POST_a0dfc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764418275/posts/CuongNguyen/ub4yb3wt6xlpryfj7lai.jpg', '2025-11-29 12:11:15'),
('IMG_b979a3cb', 'POST_a4782', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764404977/posts/Cuong2/x4faouaokp1ki6xmtong.png', '2025-11-29 08:29:37');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_reactions`
--

CREATE TABLE `post_reactions` (
  `reaction_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `post_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `reaction_type` enum('like','love','haha','wow','sad','angry') COLLATE utf8mb4_general_ci DEFAULT 'like',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_reactions`
--

INSERT INTO `post_reactions` (`reaction_id`, `post_id`, `user_id`, `reaction_type`, `created_at`) VALUES
('REACT_06130595-2621-4367-89e5-709f9e464710', 'POST_9d8bc', '1a02f1', 'sad', '2025-11-29 12:02:47'),
('REACT_11c5f821-6998-4abe-a8de-c42d7039e1a1', 'POST_d7305', 'f49004', 'like', '2025-11-29 08:17:21'),
('REACT_2e5f6daa-2371-4ee5-a8cc-ffb60238b9e1', 'POST_47fec', 'f49004', 'like', '2025-11-29 08:16:38'),
('REACT_372bc6ff-95ab-44d9-b4c0-b9a3be492f54', 'POST_2107f', '764674', 'haha', '2025-11-29 13:37:29'),
('REACT_473166ba-e103-42d9-bcfe-e316493a8c7b', 'POST_9d8bc', 'a811e0', 'love', '2025-11-29 12:02:27'),
('REACT_4dc81c86-5452-4782-9edf-465aeadff1d0', 'POST_9d8bc', 'f49004', 'sad', '2025-11-29 12:03:15'),
('REACT_5afcc93a-328e-43cf-ba27-18f5e40acfe0', 'POST_0f1db', '764674', 'haha', '2025-11-29 13:36:46'),
('REACT_6e982af5-e9ed-45a2-b08b-cf807f1c6cf1', 'POST_a0dfc', '764674', 'wow', '2025-11-29 12:11:54'),
('REACT_769157ae-722a-4601-b8db-0ece54b22b27', 'POST_ca4cccac-cf07-42df-a63b-e2c91f85bedb', '869366', 'like', '2025-12-01 15:11:49'),
('REACT_d96f62bc-671e-4afe-907e-fabb3e6e7449', 'POST_f4241', 'f49004', 'wow', '2025-11-29 11:06:52'),
('REACT_dbde0a81-b22b-421d-866d-2e12ed5b6760', 'POST_a4782', 'f49004', 'like', '2025-11-29 09:15:11'),
('REACT_e1cd4c87-8109-4ac8-8219-8e38abcf8524', 'POST_a0dfc', 'a811e0', 'love', '2025-11-29 12:11:40');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_shares`
--

CREATE TABLE `post_shares` (
  `share_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `post_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_shares`
--

INSERT INTO `post_shares` (`share_id`, `post_id`, `user_id`, `created_at`) VALUES
('SHARE_04521395-3a29-49d7-a48b-41df8bf22990', 'POST_1255b', 'f49004', '2025-11-29 08:39:26'),
('SHARE_7458149d-4581-4aee-b401-5f85b7c2e1ca', 'POST_92d2b', 'f49004', '2025-11-29 08:16:52'),
('SHARE_7942e985-b6ba-4d98-a2f7-616904decd13', 'POST_a0dfc', 'a811e0', '2025-11-29 12:12:48'),
('SHARE_80dcde2d-8d35-4c95-9f62-92e9b9712e17', 'POST_a0dfc', 'a811e0', '2025-11-29 13:30:02'),
('SHARE_c426ecc7-23ec-4556-a565-078aa74a78e0', 'POST_a4782', 'f49004', '2025-11-29 08:30:47'),
('SHARE_fa9f45bc-0985-4645-96cb-e3ad672865cf', 'POST_a4782', 'f49004', '2025-11-29 09:15:31'),
('SHARE_fb8b4554-35d4-45b1-bc6f-f57e69918c14', 'POST_4710d', 'f49004', '2025-11-29 13:36:30');

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
(5, 'Hà Giang - Lũng Cú khám phá núi đá', 20, '2025-12-15', '2025-12-18', 'Hà Nội', 'Hà Giang, Lũng Cú, Đồng Văn', '2025-11-29 23:02:59', 'Hoạt động', 1, 3, NULL),
(6, 'Hàn Quốc - Seoul & Jeju', 15, '2026-01-10', '2026-01-17', 'Hà Nội', 'Seoul, Jeju', '2025-11-30 08:38:42', 'Hoạt động', 2, 1, NULL);

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
(5, 'Lê Thị Kim Oanh', 'lethikimoanh2k4@gmail.com', '0332199694', '2004-09-10', 'female', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764466236/tour-guide/certifications/zmpmwaaoyczbo2mwvw3r.jpg', 'Phường Vũng Áng - Hà Tĩnh', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764466233/tour-guide/avatars/xsj2ezrfnbumqf4oammx.jpg'),
(6, 'Nguyễn Quốc Cường', 'cuongjit@gmail.com', '0965423874', '2004-05-09', 'male', 'Tiếng Hàn', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764467495/tour-guide/certifications/pic3otgs4gxlmjhjvh4d.jpg', 'Đắc Lắc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764467493/tour-guide/avatars/ddhxtq2v6qrvnqslmxqy.jpg'),
(7, 'Nguyễn Đình Anh Vũ', 'vunda@gmai.com', '0987541236', '2004-09-20', 'male', 'Tiếng Anh', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764467632/tour-guide/certifications/zahbohwpiw1tvudhpifq.jpg', 'Gia Lai', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764467628/tour-guide/avatars/azjkxck4qd2jfuo8x7ax.jpg');

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
(4, '2025-11-30 08:30:59', 5, 5),
(5, '2025-11-30 08:51:51', 6, 6);

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
(1, 1, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763459775/tour-images/DN/pmwy1ruzc8cbhv6sv0xb.jpg', '2025-11-18 16:55:22'),
(2, 1, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763697721/tour-images/DN/eefwwc8toh9hqpvhuyh8.jpg', '2025-11-21 11:02:03'),
(6, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720621/tour-images/Tour/k0jxlnimjyfjbgka3cmb.jpg', '2025-11-21 17:23:45'),
(7, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720624/tour-images/Tour/cvhtg3ihrexpr3kyudqh.jpg', '2025-11-21 17:23:45'),
(8, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764466949/tour-images/Tour/xjni8rik3dsjoafovjqw.jpg', '2025-11-30 08:42:30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tour_image_assignment`
--

CREATE TABLE `tour_image_assignment` (
  `id` int NOT NULL,
  `tour_img_id` int NOT NULL,
  `tour_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tour_image_assignment`
--

INSERT INTO `tour_image_assignment` (`id`, `tour_img_id`, `tour_id`) VALUES
(13, 6, 5),
(14, 8, 6);

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
(1, 'DN', '2025-11-12 19:33:37'),
(3, 'Tour', '2025-11-21 17:23:24');

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

--
-- Đang đổ dữ liệu cho bảng `tour_locations`
--

INSERT INTO `tour_locations` (`location_id`, `tour_id`, `location_name`, `description`, `latitude`, `longitude`) VALUES
(4, 5, 'Đền mẫu lũng cú hà giang', 'Xe và hướng dẫn viên đón tại Hà Nội, đi tham quan Cột cờ Lũng Cú', 23.35581226, 105.31941839),
(5, 6, 'Seoul', 'Trải nghiệm thiên nhiên và văn hóa Hàn Quốc', 37.566679, 126.978291);

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
(5, 1500000, 750000, '2025-12-11', '2025-12-19'),
(6, 15000000, 12000000, '2026-01-01', '2026-01-30');

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
(5, 5, 5),
(6, 6, 6);

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

--
-- Đang đổ dữ liệu cho bảng `tour_ratings`
--

INSERT INTO `tour_ratings` (`rating_id`, `tour_id`, `user_id`, `rating_value`, `comment`, `created_at`) VALUES
(6, 6, '869366', 5, 'tour tuyet voi', '2025-11-30 16:50:16'),
(7, 5, '869366', 5, 'huong dan vien nhiet tinh . 10d', '2025-11-30 16:56:55');

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

--
-- Đang đổ dữ liệu cho bảng `tour_schedules`
--

INSERT INTO `tour_schedules` (`schedule_id`, `tour_id`, `day_number`, `description`) VALUES
(3, 5, 1, 'Ngày 1: Hà Nội – Hà Giang – Cột Cờ Lũng Cú\n\nXe và hướng dẫn viên đón đoàn tại điểm hẹn ở Hà Nội, khởi hành đi Hà Giang.\n\nTrên đường đi, đoàn dừng chân nghỉ ngơi, ăn trưa tại Tuyên Quang.\n\nBuổi chiều đến Hà Giang, tiếp tục di chuyển lên Lũng Cú.\n\nTham quan Cột Cờ Lũng Cú – điểm cực Bắc thiêng liêng của Tổ quốc, chụp ảnh toàn cảnh thung lũng.\n\nNhận phòng, ăn tối và nghỉ ngơi ở Đồng Văn.'),
(4, 5, 2, 'Ngày 2: Phố Cổ Đồng Văn – Chợ Phiên – Đèo Mã Pì Lèng\n\nDùng bữa sáng tại khách sạn.\n\nTham quan Phố Cổ Đồng Văn, tìm hiểu kiến trúc nhà cổ của người Tày, H’Mông.\n\nGhé thăm chợ vùng cao Đồng Văn (nếu đúng ngày họp), thưởng thức ẩm thực đặc sản.\n\nDi chuyển qua Đèo Mã Pì Lèng, một trong “tứ đại đỉnh đèo” của Việt Nam, check-in sống ảo.\n\nLên thuyền trải nghiệm hẻm vực Tu Sản (nếu đăng ký).\n\nTối tự do khám phá ẩm thực Đồng Văn.'),
(5, 5, 3, 'Ngày 3: Cao Nguyên Đá – Nhà Vương – Quản Bạ\n\nXuất phát tham quan Dinh Thự Vua Mèo – Nhà Vương, công trình kiến trúc nổi tiếng của người Mông.\n\nTiếp tục check-in Cao nguyên đá Đồng Văn – di sản UNESCO.\n\nKhởi hành về Quản Bạ, dừng chân tại Cổng Trời Quản Bạ, ngắm Núi Đôi Cô Tiên.\n\nBuổi tối nghỉ ngơi tại Hà Giang.'),
(6, 5, 4, 'Ngày 4: Hà Giang – Hà Nội\n\nĂn sáng và khởi hành về Hà Nội.\n\nDừng chân mua đặc sản địa phương: cam Hàm Yên, chè Shan tuyết, thịt trâu gác bếp…\n\nVề đến Hà Nội khoảng 17:00 – 18:00, kết thúc tour.'),
(7, 6, 1, 'Ngày 1: Hà Nội – Seoul – Check-in Myeongdong\n\nBay từ Hà Nội tới sân bay Incheon (Hàn Quốc).\n\nLàm thủ tục nhập cảnh, xe đưa đoàn đến khách sạn nhận phòng.\n\nBuổi chiều tham quan khu phố thời trang nổi tiếng Myeongdong, thưởng thức street-food Hàn Quốc.\n\nNghỉ đêm tại Seoul.'),
(8, 6, 2, 'Ngày 2: Cung Điện Gyeongbokgung – Nhà Xanh – Suối Cheonggyecheon\n\nTham quan Gyeongbokgung, mặc Hanbok chụp ảnh.\n\nGhé qua Nhà Xanh – Phủ Tổng Thống Hàn Quốc (chụp ảnh bên ngoài).\n\nDạo bộ Suối nhân tạo Cheonggyecheon, điểm check-in nổi tiếng ở Seoul.\n\nBuổi tối tự do mua sắm hoặc tham gia show nghệ thuật Nanta (tuỳ chọn).'),
(9, 6, 3, 'Ngày 3: Đảo Nami – Làng Petite France\n\nKhởi hành đi Nami, địa điểm quay phim \"Bản Tình Ca Mùa Đông\".\n\nTham quan Petite France, làng mô phỏng kiến trúc Pháp.\n\nChiều tối về lại Seoul nghỉ ngơi.'),
(10, 5, 4, 'Ngày 4: Seoul – Bay Jeju – Thác Cheonjiyeon\n\nBay đến đảo Jeju – thiên đường du lịch Hàn Quốc.\n\nTham quan Thác Cheonjiyeon, chụp ảnh với rừng nhiệt đới Jeju.\n\nBuổi tối thưởng thức BBQ Hàn Quốc (nếu có trong chương trình).'),
(11, 6, 5, 'Ngày 5: Núi Hallasan – Seongsan Ilchulbong\n\nXe đưa đoàn tham quan Hallasan, ngọn núi cao nhất Hàn Quốc.\n\nChiều tham quan Seongsan Sunrise Peak – miệng núi lửa đẹp nhất châu Á.\n\nNghỉ đêm tại Jeju.'),
(12, 6, 6, 'Ngày 6: Chợ Dongmun – Bay về Seoul\n\nTham quan chợ Dongmun, mua đặc sản Jeju (cam Hallabong, chocolate).\n\nBay về Seoul, nhận phòng khách sạn.\n\nBuổi tối tự do.'),
(13, 6, 7, 'Ngày 7: Seoul – Tự do mua sắm – Trở về Hà Nội\n\nSáng: tham quan và mua sắm tại COEX Mall hoặc Lotte Duty-Free.\n\nTrả phòng, ra sân bay Incheon làm thủ tục về Việt Nam.\n\nVề tới Hà Nội, kết thúc tour.');

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
(1, 'Tour gia đình', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763695991/tour-type/w6arkv53vdofqqwwzerc.jpg', NULL, '2025-11-19 10:38:57'),
(2, 'Tour một mình', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763696009/tour-type/x8nocds1dby1mb8zrrgk.jpg', NULL, '2025-11-19 10:39:05'),
(3, 'Tour nhóm', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763696023/tour-type/xj5ti62a3et4oxoiyqtd.jpg', NULL, '2025-11-21 10:33:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `type_confirms`
--

CREATE TABLE `type_confirms` (
  `id` int NOT NULL,
  `type_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `type_confirms`
--

INSERT INTO `type_confirms` (`id`, `type_name`) VALUES
(1, 'Đang chờ xác nhận'),
(2, 'Đã xác nhận'),
(3, 'Đã thanh toán'),
(4, 'Người dùng xác nhận hoàn thành');

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
('1a02f1', 'cuong2', 'cuongkk57@gmail.com', '$2b$10$GL04l3nNVJ1buaCRkX2oUOiiygEXWheYw/RxKleorTKBQM.bHs5rm', '2025-11-29 11:50:59', '2025-11-29 11:55:24'),
('764674', 'cuong7', 'cuongkk58@gmail.com', '$2b$10$hLZ3CrGN.YSDl7/5hAxS0eNR7YsQRkZkMHWaFOgqHNL/19G/5x6VG', '2025-11-29 11:58:53', '2025-11-29 12:00:58'),
('869366', 'Kim Oanh', 'lethikimoanh2k4@gmail.com', '$2b$10$yooYL11H93BP.rtMIUl1OuxEBvU1zuCDBeQuFFoDhuPngB10K16AC', '2025-11-19 03:30:42', '2025-11-21 10:30:56'),
('890ec1', 'vua', 'michaelmuku15946@gmail.com', '$2b$10$OQ5RTBYjEgfgecHLFtaQt.RqwPfUZdhtL9vLWG4TX7fzst.tojY5a', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('a811e0', 'cuong3', 'cuongkk59@gmail.com', '$2b$10$8PmPULml/jFDJHPRucbfweGYrB87pMCKG1EygrFHLKijQ3qvuh.n6', '2025-11-29 11:56:05', '2025-11-29 11:57:26'),
('f0afeb', 'vu', 'vu784512000@gmail.com', '$2b$10$GHq/DEpMAyXEC3sbka/i1eS/DcGMdFCUv54fRhEjvvO8C5TmOQDlq', '2025-09-05 16:45:07', '2025-11-18 15:20:49'),
('f49004', 'CuongNguyen', 'cuongnq.jit@gmail.com', '$2b$10$z7OiFCKsiYJZpiQlShNcp.6n.6ODzsGjPwoCA3KhKGUkMhoXAV84G', '2025-11-24 16:09:52', '2025-11-29 11:23:55');

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
('58cfdef9f3', '0332199694', '2004-09-10', '042304011674', 'Vung Ang, Ha Tinh', 'Helloooooo', NULL, NULL, '869366', '2025-11-19 03:30:42', '2025-11-21 10:30:56'),
('a22cbd52fe', '123456789', '2004-11-16', '123456123000', 'cuong 7 nè', 'cuong 7 nè', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417657/avatar/uf0cx4xsnkljcvcveyzw.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417658/background/jqsq4mel9yoxyuwk51na.png', '764674', '2025-11-29 11:58:53', '2025-11-29 12:00:58'),
('b4f1f2c8d7', '1234567882', '2004-11-10', '123456789455', 'da nang 123', 'tui ten la cuong23', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764415434/avatar/rkrqnlxsovfrjbf5ckyq.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764404816/background/slrtl9ssfkawb71skrma.jpg', 'f49004', '2025-11-24 16:09:52', '2025-11-29 11:23:55'),
('cd114ad807', '0011225544', '2007-11-13', '012345678912', 'okokokok', 'okokoko taio la cuong 2', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417322/avatar/o9oq1c5luhunxj17k1ar.png', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417324/background/xrbm5s18x096vkuoxsar.png', '1a02f1', '2025-11-29 11:50:59', '2025-11-29 11:55:24'),
('dd37a81e6a', '0123456789', '2002-11-29', '123456789123', 'cuong 3 ne', 'tai la cuog 3', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417443/avatar/nr9y5yxozyfcqafjyjtf.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417445/background/l5rooavrgoz61dsurj9g.png', 'a811e0', '2025-11-29 11:56:05', '2025-11-29 11:57:26'),
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
('15ceca', '764674', '581922', 1, '2025-11-29 11:58:53', '2025-11-29 11:59:14'),
('673eb5', 'a811e0', '547512', 1, '2025-11-29 11:56:05', '2025-11-29 11:56:32'),
('6e26f4', 'f49004', '470978', 1, '2025-11-24 16:09:52', '2025-11-24 16:10:15'),
('714610', '890ec1', '236865', 0, '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('99b3a4', '869366', '879505', 1, '2025-11-19 03:30:42', '2025-11-19 03:30:57'),
('a0bc9f', '1a02f1', '487419', 1, '2025-11-29 11:50:59', '2025-11-29 11:51:20'),
('e4cffa', 'f0afeb', '516363', 1, '2025-09-05 16:45:07', '2025-09-11 12:19:39');

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
  ADD PRIMARY KEY (`post_id`);

--
-- Chỉ mục cho bảng `post_comments`
--
ALTER TABLE `post_comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `post_images`
--
ALTER TABLE `post_images`
  ADD PRIMARY KEY (`image_id`);

--
-- Chỉ mục cho bảng `post_reactions`
--
ALTER TABLE `post_reactions`
  ADD PRIMARY KEY (`reaction_id`),
  ADD UNIQUE KEY `uq_user_post_reaction` (`user_id`,`post_id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `post_shares`
--
ALTER TABLE `post_shares`
  ADD PRIMARY KEY (`share_id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT cho bảng `tours`
--
ALTER TABLE `tours`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `tour_categories`
--
ALTER TABLE `tour_categories`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `tour_guides`
--
ALTER TABLE `tour_guides`
  MODIFY `guide_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `tour_guide_assignment`
--
ALTER TABLE `tour_guide_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `tour_images`
--
ALTER TABLE `tour_images`
  MODIFY `tour_img_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `tour_image_assignment`
--
ALTER TABLE `tour_image_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `tour_image_folders`
--
ALTER TABLE `tour_image_folders`
  MODIFY `folder_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  MODIFY `location_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `tour_prices`
--
ALTER TABLE `tour_prices`
  MODIFY `price_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `tour_price_assignments`
--
ALTER TABLE `tour_price_assignments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `tour_ratings`
--
ALTER TABLE `tour_ratings`
  MODIFY `rating_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `tour_schedules`
--
ALTER TABLE `tour_schedules`
  MODIFY `schedule_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `tour_type`
--
ALTER TABLE `tour_type`
  MODIFY `type_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT cho bảng `type_confirms`
--
ALTER TABLE `type_confirms`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
