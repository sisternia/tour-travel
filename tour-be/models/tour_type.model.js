const db = require("../config/db");

const TourType = {
  // Create a new tour type
  create: async (tourType) => {
    const [result] = await db.execute(
      "INSERT INTO tour_type (type_id, type_name, image) VALUES (?, ?, ?)",
      [tourType.type_id, tourType.type_name, tourType.image]
    );
    return result;
  },

  // Find a tour type by its ID
  findById: async (type_id) => {
    const [rows] = await db.execute(
      "SELECT * FROM tour_type WHERE type_id = ?",
      [type_id]
    );
    return rows[0];
  },

  // Find a tour type by its name
  findByName: async (type_name) => {
    const [rows] = await db.execute(
      "SELECT * FROM tour_type WHERE type_name = ?",
      [type_name]
    );
    return rows[0];
  },

  // Get all tour types
  getAll: async () => {
    const [rows] = await db.execute("SELECT * FROM tour_type");
    return rows;
  },
};

module.exports = TourType;
