// models/post_comment.model.js
const db = require("../config/db");

const PostComment = {
  create: async (comment) => {
    const [result] = await db.execute(
      "INSERT INTO post_comments (comment_id, post_id, user_id, content) VALUES (?, ?, ?, ?)",
      [comment.comment_id, comment.post_id, comment.user_id, comment.content]
    );
    return result;
  },

  findByPostId: async (post_id) => {
    const [rows] = await db.execute(
      `SELECT c.*, u.user_name, ui.avatar 
       FROM post_comments c 
       JOIN users u ON c.user_id = u.user_id 
       LEFT JOIN user_infor ui ON c.user_id = ui.user_id
       WHERE c.post_id = ? 
       ORDER BY c.created_at ASC`,
      [post_id]
    );
    return rows;
  },

  findById: async (comment_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM post_comments WHERE comment_id = ?",
      [comment_id]
    );
    return rows[0];
  },

  update: async (comment_id, content) => {
    const [result] = await db.execute(
      "UPDATE post_comments SET content = ? WHERE comment_id = ?",
      [content, comment_id]
    );
    return result;
  },

  delete: async (comment_id) => {
    const [result] = await db.execute(
      "DELETE FROM post_comments WHERE comment_id = ?",
      [comment_id]
    );
    return result;
  },

  getCount: async (post_id) => {
    const [rows] = await db.execute(
      "SELECT COUNT(*) as count FROM post_comments WHERE post_id = ?",
      [post_id]
    );
    return rows[0]?.count || 0;
  }
};

module.exports = PostComment;

