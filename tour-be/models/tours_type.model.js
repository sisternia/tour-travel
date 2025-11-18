// models/tours_type.model.js
const db = require("../config/db");

const TourType = {
  create: async (tourType) => {
    const [result] = await db.execute(
      "INSERT INTO tour_type (type_id, type_name, image) VALUES (?, ?, ?)",
      [tourType.type_id, tourType.type_name, tourType.image]
    );
    return result;
  },

  findById: async (type_id) => {
    const [rows] = await db.execute("SELECT * FROM tour_type WHERE type_id = ?", [type_id]);
    return rows[0];
  },

  findByName: async (type_name) => {
    const [rows] = await db.execute("SELECT * FROM tour_type WHERE type_name = ?", [type_name]);
    return rows[0];
  },

  getAll: async () => {
    const [rows] = await db.execute("SELECT * FROM tour_type");
    return rows;
  },

  update: async (type_id, tourType) => {
    const [result] = await db.execute(
      "UPDATE tour_type SET type_name = ?, image = ? WHERE type_id = ?",
      [tourType.type_name, tourType.image, type_id]
    );
    return result;
  },

  delete: async (type_id) => {
    const [result] = await db.execute("DELETE FROM tour_type WHERE type_id = ?", [type_id]);
    return result;
  },
};

module.exports = TourType;
