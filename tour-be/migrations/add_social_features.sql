-- Migration: Add social features (reactions, comments, shares)

-- Add shared_from_post_id to posts table to track shared posts
ALTER TABLE `posts` 
ADD COLUMN `shared_from_post_id` varchar(50) DEFAULT NULL,
ADD COLUMN `shared_from_user_id` varchar(6) DEFAULT NULL,
ADD COLUMN `shared_note` text DEFAULT NULL;

-- Create post_reactions table
CREATE TABLE IF NOT EXISTS `post_reactions` (
  `reaction_id` varchar(50) NOT NULL,
  `post_id` varchar(50) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `reaction_type` enum('like','love','haha','wow','sad','angry') DEFAULT 'like',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reaction_id`),
  UNIQUE KEY `uq_user_post_reaction` (`user_id`, `post_id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create post_comments table
CREATE TABLE IF NOT EXISTS `post_comments` (
  `comment_id` varchar(50) NOT NULL,
  `post_id` varchar(50) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create post_shares table
CREATE TABLE IF NOT EXISTS `post_shares` (
  `share_id` varchar(50) NOT NULL,
  `post_id` varchar(50) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`share_id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;





