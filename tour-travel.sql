-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th12 02, 2025 lúc 05:01 AM
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
(3, 'f49004', 'Thanh toán thành công', 'Đơn hàng #39 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '39', 1, '2025-11-27 08:58:40', '2025-11-27 08:59:53'),
(11, 'f49004', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 1, '2025-11-27 09:50:27', '2025-11-27 09:52:46'),
(15, 'f49004', 'Thanh toán thành công', 'Đơn hàng #48 - Khám Phá Hà Giang - Lũng Cú đã được thanh toán thành công.', 'payment', '48', 0, '2025-11-28 02:11:26', '2025-11-28 02:11:26'),
(16, 'f49004', 'Admin đã xác nhận đơn hàng', 'Đơn hàng #48 - Khám Phá Hà Giang - Lũng Cú đã được admin xác nhận thành công.', 'payment', '48', 1, '2025-11-28 02:11:40', '2025-11-29 11:37:52'),
(18, '869366', 'Thanh toán thành công', 'Đơn hàng #26 - Du lịch Phú Quốc đã được thanh toán thành công.', 'payment', '26', 0, '2025-11-29 07:23:56', '2025-11-29 07:23:56'),
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
(45, 'f0afeb', 'Cập nhật hồ sơ thành công', 'Thông tin cá nhân của bạn đã được cập nhật.', 'profile', NULL, 1, '2025-11-29 15:23:23', '2025-11-29 15:28:23');

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
(44, 2, 1, 'cường6', '111111111', 'jjjj@gmail.com', 1300000.00, '2025-11-27 16:24:31', 'test status dơn hang', 2, 'f49004', 2),
(45, 0, 1, 'cuong 7', '55555555', 'kkk@gmail.com', 700000.00, '2025-11-27 16:27:25', 'test status + thog bao', 2, 'f49004', 2),
(47, 5, 1, 'cuong9', '323232323', 'kkkkk@gmail.com', 2200000.00, '2025-11-27 16:51:24', 'test số đơn hàg ch tt', 2, 'f49004', 3),
(49, 0, 1, 'Cùowng11', '0123455222', 'kdfjjhdf@gmail.com', 1000000.00, '2025-11-29 15:14:17', 'g', 1, 'f49004', 4),
(50, 1, 3, 'cường12', '1122334455', 'kạksja@gmail.com', 2400000.00, '2025-11-29 15:36:09', '', 1, 'f49004', 3),
(51, 2, 1, 'cường88', '1122332211', 'cccc@gmail.com', 1300000.00, '2025-11-29 18:08:23', '', 1, 'f49004', 2),
(53, 1, 1, 'cường99', '112233444', 'cuong@gmail.com', 1000000.00, '2025-11-29 18:09:14', '', 3, 'f49004', 2),
(54, 1, 2, 'cường40', '00002222', 'kjkjkj@gmail.com', 1700000.00, '2025-11-29 18:19:00', '', 3, 'f49004', 3),
(55, 1, 2, 'cuong50', '23232323', 'akdjklsadsjad', 1700000.00, '2025-11-29 18:24:52', '', 3, 'f49004', 2),
(56, 1, 3, 'cường70', '000111', 'sạdhkjádhjá', 2400000.00, '2025-11-29 18:33:11', '', 1, 'f49004', 2),
(57, 1, 3, 'cuong90', '22223333', 'dsfdsfdss', 2400000.00, '2025-11-29 18:36:55', '', 3, 'f49004', 3),
(58, 0, 1, 'cường0909', '12121212', 'jljhjhkjh', 700000.00, '2025-11-29 20:38:32', '', 1, '764674', 3),
(59, 2, 1, 'cuong0088', '0022554422', 'sadsdfadfcxx v', 1300000.00, '2025-11-29 20:47:42', '', 3, 'f49004', 3),
(60, 1, 2, 'cuong7878', '021032101', 'ghnghnhnnbbnv', 2500000.00, '2025-11-29 21:05:36', '', 1, 'f49004', 4),
(61, 2, 1, 'cuong5655', '22222222222', 'gffgfgff', 2000000.00, '2025-11-29 21:12:37', '', 3, 'f49004', 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `post_id` varchar(10) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `content` text DEFAULT NULL,
  `privacy` enum('public','friends','private') DEFAULT 'public',
  `shared_from_post_id` varchar(10) DEFAULT NULL,
  `shared_from_user_id` varchar(6) DEFAULT NULL,
  `shared_note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `posts`
--

INSERT INTO `posts` (`post_id`, `user_id`, `content`, `privacy`, `shared_from_post_id`, `shared_from_user_id`, `shared_note`, `created_at`, `updated_at`) VALUES
('POST_04277', 'f0afeb', 'Đẹp ko', 'public', NULL, NULL, NULL, '2025-11-30 11:35:57', '2025-11-30 11:35:57'),
('POST_517fc', 'f0afeb', 'Đẹp ko', 'public', 'POST_04277', 'f0afeb', 'Bạn đã chia sẻ bài viết của chính mình', '2025-11-30 11:36:22', '2025-11-30 11:36:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_comments`
--

CREATE TABLE `post_comments` (
  `comment_id` varchar(50) NOT NULL,
  `post_id` varchar(10) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
('IMG_0381aa9a', 'POST_517fc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502631/posts/vu/yceufnrmrvkybcqscpjo.jpg', '2025-11-30 11:36:22'),
('IMG_074af6d5', 'POST_517fc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502630/posts/vu/lz2oqcelei9z5wliaoqg.jpg', '2025-11-30 11:36:22'),
('IMG_07a4637c', 'POST_517fc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502637/posts/vu/qsyur9rebigqyzplyr48.jpg', '2025-11-30 11:36:22'),
('IMG_9a3e2f0a', 'POST_04277', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502637/posts/vu/qsyur9rebigqyzplyr48.jpg', '2025-11-30 11:36:16'),
('IMG_a76a4466', 'POST_517fc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502635/posts/vu/q3e0hmu4ukrzvcqs2jh4.png', '2025-11-30 11:36:22'),
('IMG_c599fc67', 'POST_04277', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502633/posts/vu/lhypx85g8cl2bquxeaxx.jpg', '2025-11-30 11:36:11'),
('IMG_ce47756f', 'POST_517fc', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502633/posts/vu/lhypx85g8cl2bquxeaxx.jpg', '2025-11-30 11:36:22'),
('IMG_d5b3346d', 'POST_04277', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502630/posts/vu/lz2oqcelei9z5wliaoqg.jpg', '2025-11-30 11:36:09'),
('IMG_de2123e0', 'POST_04277', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502631/posts/vu/yceufnrmrvkybcqscpjo.jpg', '2025-11-30 11:36:10'),
('IMG_f3abf5e2', 'POST_04277', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764502635/posts/vu/q3e0hmu4ukrzvcqs2jh4.png', '2025-11-30 11:36:13');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_reactions`
--

CREATE TABLE `post_reactions` (
  `reaction_id` varchar(50) NOT NULL,
  `post_id` varchar(10) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `reaction_type` enum('like','love','haha','wow','sad','angry') DEFAULT 'like',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_reactions`
--

INSERT INTO `post_reactions` (`reaction_id`, `post_id`, `user_id`, `reaction_type`, `created_at`) VALUES
('REACT_050e93ec-ffb5-41a6-97c6-b553d119388f', 'POST_517fc', 'f0afeb', 'love', '2025-11-30 11:36:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_shares`
--

CREATE TABLE `post_shares` (
  `share_id` varchar(50) NOT NULL,
  `post_id` varchar(10) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_shares`
--

INSERT INTO `post_shares` (`share_id`, `post_id`, `user_id`, `created_at`) VALUES
('SHARE_704afb39-5454-45fc-96d2-e33612373d23', 'POST_04277', 'f0afeb', '2025-11-30 11:36:22');

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
(2, 'Khám Phá Vịnh Hạ Long - Kỳ Quan Thiên Nhiên Thế Giới', 20, '2025-11-20', '2025-11-23', 'Sân bay Nội Bài, Hà Nội', 'Đà Lạt, Lâm Đồng', '2025-11-19 10:40:46', 'active', 1, 1, NULL),
(3, 'Khám Phá Hà Giang - Lũng Cú', 15, '2025-11-22', '2025-11-30', 'Hà Nội', 'Lũng Cú', '2025-11-20 07:56:30', 'active', 1, 1, NULL),
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
(3, 'Nguyễn Quốc Cường', 'cuongnq@gmail.com', '098765432', '2001-05-31', '', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634609/tour-guide/certifications/hz91iyzeydkjykkepouc.jpg', 'Thái Nguyên', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634607/tour-guide/avatars/f36skzkx92an7pojw1kw.jpg'),
(4, 'Lê Thị Kim Oanh', 'lethikimoanh2k4@gmail.com', '0332199694', '2004-09-10', 'female', 'Tiếng Nhật', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634990/tour-guide/certifications/recfr6oelua7nb7tjikc.jpg', 'Phường Vũng Áng - Hà Tĩnh', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763634987/tour-guide/avatars/epldmaqgj2qsiksdol9r.jpg');

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
(6, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720621/tour-images/Tour/k0jxlnimjyfjbgka3cmb.jpg', '2025-11-21 17:23:45'),
(7, 3, 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1763720624/tour-images/Tour/cvhtg3ihrexpr3kyudqh.jpg', '2025-11-21 17:23:45');

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
(12, 6, 3);

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
(3, 'Tour', '2025-11-21 17:23:24');

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
('1a02f1', 'cuong2', 'cuongkk57@gmail.com', '$2b$10$GL04l3nNVJ1buaCRkX2oUOiiygEXWheYw/RxKleorTKBQM.bHs5rm', '2025-11-29 11:50:59', '2025-11-29 11:55:24'),
('764674', 'cuong7', 'cuongkk58@gmail.com', '$2b$10$hLZ3CrGN.YSDl7/5hAxS0eNR7YsQRkZkMHWaFOgqHNL/19G/5x6VG', '2025-11-29 11:58:53', '2025-11-29 12:00:58'),
('869366', 'Kim Oanh', 'lethikimoanh2k4@gmail.com', '$2b$10$yooYL11H93BP.rtMIUl1OuxEBvU1zuCDBeQuFFoDhuPngB10K16AC', '2025-11-19 03:30:42', '2025-11-21 10:30:56'),
('890ec1', 'vua', 'michaelmuku15946@gmail.com', '$2b$10$OQ5RTBYjEgfgecHLFtaQt.RqwPfUZdhtL9vLWG4TX7fzst.tojY5a', '2025-09-07 09:22:04', '2025-09-07 09:22:04'),
('a811e0', 'cuong3', 'cuongkk59@gmail.com', '$2b$10$8PmPULml/jFDJHPRucbfweGYrB87pMCKG1EygrFHLKijQ3qvuh.n6', '2025-11-29 11:56:05', '2025-11-29 11:57:26'),
('f0afeb', 'vu', 'vu784512000@gmail.com', '$2b$10$GHq/DEpMAyXEC3sbka/i1eS/DcGMdFCUv54fRhEjvvO8C5TmOQDlq', '2025-09-05 16:45:07', '2025-11-29 15:23:23'),
('f49004', 'CuongNguyen', 'cuongnq.jit@gmail.com', '$2b$10$z7OiFCKsiYJZpiQlShNcp.6n.6ODzsGjPwoCA3KhKGUkMhoXAV84G', '2025-11-24 16:09:52', '2025-11-29 11:23:55');

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
('a22cbd52fe', '123456789', '2004-11-16', '123456123000', 'cuong 7 nè', 'cuong 7 nè', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417657/avatar/uf0cx4xsnkljcvcveyzw.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417658/background/jqsq4mel9yoxyuwk51na.png', '764674', '2025-11-29 11:58:53', '2025-11-29 12:00:58'),
('b4f1f2c8d7', '1234567882', '2004-11-10', '123456789455', 'da nang 123', 'tui ten la cuong23', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764415434/avatar/rkrqnlxsovfrjbf5ckyq.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764404816/background/slrtl9ssfkawb71skrma.jpg', 'f49004', '2025-11-24 16:09:52', '2025-11-29 11:23:55'),
('cd114ad807', '0011225544', '2007-11-13', '012345678912', 'okokokok', 'okokoko taio la cuong 2', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417322/avatar/o9oq1c5luhunxj17k1ar.png', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417324/background/xrbm5s18x096vkuoxsar.png', '1a02f1', '2025-11-29 11:50:59', '2025-11-29 11:55:24'),
('dd37a81e6a', '0123456789', '2002-11-29', '123456789123', 'cuong 3 ne', 'tai la cuog 3', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417443/avatar/nr9y5yxozyfcqafjyjtf.jpg', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764417445/background/l5rooavrgoz61dsurj9g.png', 'a811e0', '2025-11-29 11:56:05', '2025-11-29 11:57:26'),
('eab00e57d9', '123456789', '2025-10-11', '123456789012', '121221', '2121212213123', 'https://res.cloudinary.com/dygkdxqmq/image/upload/v1764429863/avatar/xk7qgajg5wbhsftd8qv5.png', NULL, 'f0afeb', '2025-09-05 16:45:07', '2025-11-29 15:23:23');

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
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `idx_posts_user` (`user_id`),
  ADD KEY `idx_posts_shared_post` (`shared_from_post_id`),
  ADD KEY `idx_posts_shared_user` (`shared_from_user_id`);

--
-- Chỉ mục cho bảng `post_comments`
--
ALTER TABLE `post_comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `idx_post_comments_post` (`post_id`),
  ADD KEY `idx_post_comments_user` (`user_id`);

--
-- Chỉ mục cho bảng `post_images`
--
ALTER TABLE `post_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `idx_post_images_post` (`post_id`);

--
-- Chỉ mục cho bảng `post_reactions`
--
ALTER TABLE `post_reactions`
  ADD PRIMARY KEY (`reaction_id`),
  ADD UNIQUE KEY `uq_user_post_reaction` (`user_id`,`post_id`),
  ADD KEY `idx_post_reactions_post` (`post_id`),
  ADD KEY `idx_post_reactions_user` (`user_id`);

--
-- Chỉ mục cho bảng `post_shares`
--
ALTER TABLE `post_shares`
  ADD PRIMARY KEY (`share_id`),
  ADD KEY `idx_post_shares_post` (`post_id`),
  ADD KEY `idx_post_shares_user` (`user_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `tour_image_folders`
--
ALTER TABLE `tour_image_folders`
  MODIFY `folder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `tour_locations`
--
ALTER TABLE `tour_locations`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `fk_posts_shared_post` FOREIGN KEY (`shared_from_post_id`) REFERENCES `posts` (`post_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_posts_shared_user` FOREIGN KEY (`shared_from_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_posts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `post_comments`
--
ALTER TABLE `post_comments`
  ADD CONSTRAINT `fk_post_comments_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_post_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `post_images`
--
ALTER TABLE `post_images`
  ADD CONSTRAINT `fk_post_images_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `post_reactions`
--
ALTER TABLE `post_reactions`
  ADD CONSTRAINT `fk_post_reactions_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_post_reactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `post_shares`
--
ALTER TABLE `post_shares`
  ADD CONSTRAINT `fk_post_shares_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_post_shares_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

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
