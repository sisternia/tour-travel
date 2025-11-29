// models/post_share.model.js
const db = require("../config/db");

const PostShare = {
  create: async (share) => {
    const [result] = await db.execute(
      "INSERT INTO post_shares (share_id, post_id, user_id) VALUES (?, ?, ?)",
      [share.share_id, share.post_id, share.user_id]
    );
    return result;
  },

  findByPostId: async (post_id) => {
    const [rows] = await db.execute(
      `SELECT s.*, u.user_name, ui.avatar 
       FROM post_shares s 
       JOIN users u ON s.user_id = u.user_id 
       LEFT JOIN user_infor ui ON s.user_id = ui.user_id
       WHERE s.post_id = ? 
       ORDER BY s.created_at DESC`,
      [post_id]
    );
    return rows;
  },

  findByUser: async (user_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM post_shares WHERE user_id = ? ORDER BY created_at DESC",
      [user_id]
    );
    return rows;
  },

  getCount: async (post_id) => {
    const [rows] = await db.execute(
      "SELECT COUNT(*) as count FROM post_shares WHERE post_id = ?",
      [post_id]
    );
    return rows[0]?.count || 0;
  },

  checkIfShared: async (user_id, post_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM post_shares WHERE user_id = ? AND post_id = ?",
      [user_id, post_id]
    );
    return rows.length > 0;
  }
};

module.exports = PostShare;

