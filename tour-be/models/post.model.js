// models/post.model.js
const db = require("../config/db");

const Post = {
  create: async (post) => {
    const [result] = await db.execute(
      "INSERT INTO posts (post_id, user_id, content, privacy) VALUES (?, ?, ?, ?)",
      [post.post_id, post.user_id, post.content, post.privacy]
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
      "SELECT * FROM posts ORDER BY created_at DESC"
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
