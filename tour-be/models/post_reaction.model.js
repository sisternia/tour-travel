// models/post_reaction.model.js
const db = require("../config/db");

const PostReaction = {
  create: async (reaction) => {
    const [result] = await db.execute(
      "INSERT INTO post_reactions (reaction_id, post_id, user_id, reaction_type) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE reaction_type = ?",
      [reaction.reaction_id, reaction.post_id, reaction.user_id, reaction.reaction_type, reaction.reaction_type]
    );
    return result;
  },

  findByPostId: async (post_id) => {
    const [rows] = await db.execute(
      `SELECT pr.*, u.user_name, ui.avatar 
       FROM post_reactions pr 
       JOIN users u ON pr.user_id = u.user_id 
       LEFT JOIN user_infor ui ON pr.user_id = ui.user_id
       WHERE pr.post_id = ? 
       ORDER BY pr.created_at DESC`,
      [post_id]
    );
    return rows;
  },

  findByUserAndPost: async (user_id, post_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM post_reactions WHERE user_id = ? AND post_id = ?",
      [user_id, post_id]
    );
    return rows[0];
  },

  delete: async (user_id, post_id) => {
    const [result] = await db.execute(
      "DELETE FROM post_reactions WHERE user_id = ? AND post_id = ?",
      [user_id, post_id]
    );
    return result;
  },

  getReactionCounts: async (post_id) => {
    const [rows] = await db.execute(
      `SELECT reaction_type, COUNT(*) as count 
       FROM post_reactions 
       WHERE post_id = ? 
       GROUP BY reaction_type`,
      [post_id]
    );
    return rows;
  }
};

module.exports = PostReaction;

