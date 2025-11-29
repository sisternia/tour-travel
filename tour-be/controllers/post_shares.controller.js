// controllers/post_shares.controller.js
const PostShare = require("../models/post_share.model");
const Post = require("../models/post.model");
const PostImages = require("../models/post_images.model");
const Notification = require("../models/notification.model");
const crypto = require("crypto");

const sharePost = async (req, res) => {
  try {
    const { post_id, user_id, shared_from_user_id } = req.body;

    // Get original post
    const originalPost = await Post.findById(post_id);
    if (!originalPost) {
      return res.status(404).json({ message: "Không tìm thấy bài viết" });
    }

    // Determine the original post ID (if this post is already a share, use the original)
    const originalPostId = originalPost.shared_from_post_id || post_id;
    // Nếu bài viết đã được share, dùng shared_from_user_id; nếu là bài viết gốc, dùng user_id của bài viết
    const originalUserId = originalPost.shared_from_user_id || originalPost.user_id;

    // Get original user name
    const db = require("../config/db");
    const [userRows] = await db.execute(
      "SELECT user_name FROM users WHERE user_id = ?",
      [originalUserId]
    );
    const sharedFromUserName = userRows[0]?.user_name || "Người dùng";

    // Check if sharing own post
    const sharedNote = originalUserId === user_id 
      ? "Bạn đã chia sẻ bài viết của chính mình"
      : `Bạn đã chia sẻ bài viết của ${sharedFromUserName}`;

    // Create share record for the ORIGINAL post (not the shared post)
    const share_id = "SHARE_" + crypto.randomUUID();
    await PostShare.create({
      share_id,
      post_id: originalPostId, // Share count goes to original post
      user_id
    });

    // Create new post with shared note
    const newPostId = "POST_" + crypto.randomUUID();
    await Post.create({
      post_id: newPostId,
      user_id,
      content: originalPost.content,
      privacy: "public",
      shared_from_post_id: originalPostId, // Reference to original post
      shared_from_user_id: originalUserId, // Reference to original user
      shared_note: sharedNote
    });

    // Copy images from original post
    const originalImages = await PostImages.getByPostId(post_id);
    for (const img of originalImages) {
      const imgId = "IMG_" + crypto.randomBytes(8).toString("hex");
      await PostImages.create({
        image_id: imgId,
        post_id: newPostId,
        image_url: img.image_url
      });
    }

    // Tạo thông báo cho chủ bài viết gốc
    try {
      if (originalUserId && originalUserId !== user_id) {
        // Lấy tên người chia sẻ
        const [sharerRows] = await db.execute(
          "SELECT user_name FROM users WHERE user_id = ?",
          [user_id]
        );
        const sharerName = sharerRows[0]?.user_name || "Người dùng";

        // Lấy tên người đăng bài gốc (đã có từ sharedFromUserName ở trên)
        const postOwnerName = sharedFromUserName;

        await Notification.create({
          user_id: originalUserId,
          title: "Chia sẻ bài viết",
          body: `${sharerName} đã chia sẻ bài viết của ${postOwnerName}`,
          type: "share",
          reference_id: originalPostId
        });
      }
    } catch (notifError) {
      console.error("Error creating share notification:", notifError);
      // Không fail request nếu thông báo lỗi
    }

    res.status(201).json({
      success: true,
      message: "Đã chia sẻ bài viết",
      post_id: newPostId
    });
  } catch (error) {
    console.error("🔥 SHARE POST ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const getShares = async (req, res) => {
  try {
    const { post_id } = req.params;
    const shares = await PostShare.findByPostId(post_id);

    res.status(200).json(shares);
  } catch (error) {
    console.error("🔥 GET SHARES ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

const getShareCount = async (req, res) => {
  try {
    const { post_id } = req.params;
    const count = await PostShare.getCount(post_id);

    res.status(200).json({ count });
  } catch (error) {
    console.error("🔥 GET SHARE COUNT ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message
    });
  }
};

module.exports = {
  sharePost,
  getShares,
  getShareCount
};


