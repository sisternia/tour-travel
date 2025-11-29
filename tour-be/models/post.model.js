// models/post.model.js
const db = require("../config/db");

const Post = {
  create: async (post) => {
    const [result] = await db.execute(
      "INSERT INTO posts (post_id, user_id, content, privacy, shared_from_post_id, shared_from_user_id, shared_note) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [post.post_id, post.user_id, post.content, post.privacy, post.shared_from_post_id || null, post.shared_from_user_id || null, post.shared_note || null]
    );
    return result;
  },

  findById: async (post_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM posts WHERE post_id = ?",
      [post_id]
    );
    return rows[0];
  },

  getAll: async () => {
    const [rows] = await db.execute(
      `SELECT p.*, u.user_name, ui.avatar,
       (SELECT user_name FROM users WHERE user_id = p.shared_from_user_id) as shared_from_user_name,
       (SELECT ui2.avatar FROM user_infor ui2 WHERE ui2.user_id = p.shared_from_user_id) as shared_from_user_avatar
       FROM posts p 
       JOIN users u ON p.user_id = u.user_id 
       LEFT JOIN user_infor ui ON p.user_id = ui.user_id
       ORDER BY p.created_at DESC`
    );
    return rows;
  },

  getByUserId: async (user_id) => {
    const [rows] = await db.execute(
      `SELECT p.*, u.user_name, ui.avatar,
       (SELECT user_name FROM users WHERE user_id = p.shared_from_user_id) as shared_from_user_name,
       (SELECT ui2.avatar FROM user_infor ui2 WHERE ui2.user_id = p.shared_from_user_id) as shared_from_user_avatar
       FROM posts p 
       JOIN users u ON p.user_id = u.user_id 
       LEFT JOIN user_infor ui ON p.user_id = ui.user_id
       WHERE p.user_id = ? 
       ORDER BY p.created_at DESC`,
      [user_id]
    );
    return rows;
  },

  update: async (post_id, data) => {
    const [result] = await db.execute(
      "UPDATE posts SET content = ?, privacy = ? WHERE post_id = ?",
      [data.content, data.privacy, post_id]
    );
    return result;
  },

  delete: async (post_id) => {
    const [result] = await db.execute(
      "DELETE FROM posts WHERE post_id = ?",
      [post_id]
    );
    return result;
  }
};

module.exports = Post;
