// models/post_images.model.js
const db = require("../config/db");

const PostImages = {
  create: async (image) => {
    const [result] = await db.execute(
      "INSERT INTO post_images (image_id, post_id, image_url) VALUES (?, ?, ?)",
      [image.image_id, image.post_id, image.image_url]
    );
    return result;
  },

  getByPostId: async (post_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM post_images WHERE post_id = ?",
      [post_id]
    );
    return rows;
  },

  deleteById: async (image_id) => {
    const [result] = await db.execute(
      "DELETE FROM post_images WHERE image_id = ?",
      [image_id]
    );
    return result;
  },

  deleteByPost: async (post_id) => {
    const [result] = await db.execute(
      "DELETE FROM post_images WHERE post_id = ?",
      [post_id]
    );
    return result;
  }
};

module.exports = PostImages;
