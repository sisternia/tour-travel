// controllers/post_reactions.controller.js
const PostReaction = require("../models/post_reaction.model");
const Post = require("../models/post.model");
const Notification = require("../models/notification.model");
const db = require("../config/db");
const crypto = require("crypto");

const addReaction = async (req, res) => {
  try {
    const { post_id, user_id, reaction_type } = req.body;
    const reaction_id = "REACT_" + crypto.randomUUID();

    await PostReaction.create({
      reaction_id,
      post_id,
      user_id,
      reaction_type: reaction_type || "like"
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

        // Tạo nội dung thông báo theo loại react
        const reactionLabels = {
          like: "đã thích",
          love: "đã thả tim",
          haha: "đã cười",
          wow: "đã wow",
          sad: "đã buồn",
          angry: "đã phẫn nộ"
        };
        const reactionLabel = reactionLabels[reaction_type] || "đã thích";

        await Notification.create({
          user_id: post.user_id,
          title: "Cảm xúc mới",
          body: `${userName} ${reactionLabel} bài viết của bạn`,
          type: "reaction",
          reference_id: post_id
        });
      }
    } catch (notifError) {
      console.error("Error creating notification:", notifError);
      // Không fail request nếu thông báo lỗi
    }

    res.status(201).json({
      success: true,
      message: "Đã thêm cảm xúc"
    });
  } catch (error) {
    console.error("🔥 ADD REACTION ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const removeReaction = async (req, res) => {
  try {
    const { post_id, user_id } = req.body;

    await PostReaction.delete(user_id, post_id);

    res.status(200).json({
      success: true,
      message: "Đã gỡ cảm xúc"
    });
  } catch (error) {
    console.error("🔥 REMOVE REACTION ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const getReactions = async (req, res) => {
  try {
    const { post_id } = req.params;
    const reactions = await PostReaction.findByPostId(post_id);
    const counts = await PostReaction.getReactionCounts(post_id);

    res.status(200).json({
      reactions,
      counts: counts.reduce((acc, item) => {
        acc[item.reaction_type] = item.count;
        return acc;
      }, {})
    });
  } catch (error) {
    console.error("🔥 GET REACTIONS ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const getUserReaction = async (req, res) => {
  try {
    const { post_id, user_id } = req.params;
    const reaction = await PostReaction.findByUserAndPost(user_id, post_id);

    res.status(200).json(reaction || null);
  } catch (error) {
    console.error("🔥 GET USER REACTION ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

module.exports = {
  addReaction,
  removeReaction,
  getReactions,
  getUserReaction
};





