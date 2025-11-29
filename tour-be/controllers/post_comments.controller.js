// controllers/post_comments.controller.js
const PostComment = require("../models/post_comment.model");
const Post = require("../models/post.model");
const Notification = require("../models/notification.model");
const db = require("../config/db");
const crypto = require("crypto");

const addComment = async (req, res) => {
  try {
    const { post_id, user_id, content } = req.body;
    const comment_id = "COMMENT_" + crypto.randomUUID();

    await PostComment.create({
      comment_id,
      post_id,
      user_id,
      content
    });

    // Tạo thông báo cho chủ bài viết
    try {
      const post = await Post.findById(post_id);
      if (post && post.user_id && post.user_id !== user_id) {
        // Lấy tên người dùng
        const [userRows] = await db.execute(
          "SELECT user_name FROM users WHERE user_id = ?",
          [user_id]
        );
        const userName = userRows[0]?.user_name || "Người dùng";

        await Notification.create({
          user_id: post.user_id,
          title: "Bình luận mới",
          body: `${userName} đã bình luận bài viết của bạn`,
          type: "comment",
          reference_id: post_id
        });
      }
    } catch (notifError) {
      console.error("Error creating notification:", notifError);
      // Không fail request nếu thông báo lỗi
    }

    const comment = await PostComment.findById(comment_id);
    res.status(201).json({
      success: true,
      message: "Đã thêm bình luận",
      comment
    });
  } catch (error) {
    console.error("🔥 ADD COMMENT ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const getComments = async (req, res) => {
  try {
    const { post_id } = req.params;
    const comments = await PostComment.findByPostId(post_id);

    res.status(200).json(comments);
  } catch (error) {
    console.error("🔥 GET COMMENTS ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const updateComment = async (req, res) => {
  try {
    const { comment_id } = req.params;
    const { content } = req.body;

    await PostComment.update(comment_id, content);

    res.status(200).json({
      success: true,
      message: "Đã cập nhật bình luận"
    });
  } catch (error) {
    console.error("🔥 UPDATE COMMENT ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const deleteComment = async (req, res) => {
  try {
    const { comment_id } = req.params;

    await PostComment.delete(comment_id);

    res.status(200).json({
      success: true,
      message: "Đã xóa bình luận"
    });
  } catch (error) {
    console.error("🔥 DELETE COMMENT ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const getCommentCount = async (req, res) => {
  try {
    const { post_id } = req.params;
    const count = await PostComment.getCount(post_id);

    res.status(200).json({ count });
  } catch (error) {
    console.error("🔥 GET COMMENT COUNT ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

module.exports = {
  addComment,
  getComments,
  updateComment,
  deleteComment,
  getCommentCount
};





