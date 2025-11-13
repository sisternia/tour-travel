// models/tour_categories.model.js
const db = require("../config/db");

const TourCategories = {
  create: async (category) => {
    const [result] = await db.execute(
      "INSERT INTO tour_categories (category_id, categories_name, image) VALUES (?, ?, ?)",
      [category.category_id, category.categories_name, category.image]
    );
    return result;
  },
  findById: async (category_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM tour_categories WHERE category_id = ?",
      [category_id]
    );
    return rows[0];
  },
  getAll: async () => {
    const [rows] = await db.execute("SELECT * FROM tour_categories");
    return rows;
  },
  update: async (category_id, category) => {
    const [result] = await db.execute(
      "UPDATE tour_categories SET categories_name = ?, image = ? WHERE category_id = ?",
      [category.categories_name, category.image, category_id]
    );
    return result;
  },
  delete: async (category_id) => {
    const [result] = await db.execute(
      "DELETE FROM tour_categories WHERE category_id = ?",
      [category_id]
    );
    return result;
  },
};

module.exports = TourCategories;
