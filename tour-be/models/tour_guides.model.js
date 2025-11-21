// models/tour_guide.model.js
const db = require("../config/db");

const TourGuide = {
  getAll: async () => {
    const [rows] = await db.execute(
      "SELECT * FROM tour_guides ORDER BY guide_id DESC"
    );
    return rows;
  },
  create: async (data) => {
    const [result] = await db.execute(
      `INSERT INTO tour_guides 
      (guide_name, email, phone, birthday, gender, certification, address, avatar_image, language_job) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        data.guide_name,
        data.email,
        data.phone,
        data.birthday,
        data.gender,
        data.certification,
        data.address,
        data.avatar_image,
        data.language_job,
      ]
    );
    return result;
  },

  update: async (guide_id, data) => {
    const [result] = await db.execute(
      `UPDATE tour_guides SET 
        guide_name=?, 
        email=?, 
        phone=?, 
        birthday=?, 
        gender=?, 
        certification=?, 
        address=?, 
        avatar_image=?,
        language_job=?
      WHERE guide_id=?`,
      [
        data.guide_name,
        data.email,
        data.phone,
        data.birthday,
        data.gender,
        data.certification,
        data.address,
        data.avatar_image,
        data.language_job,
        guide_id,
      ]
    );
    return result;
  },
  delete: async (guide_id) => {
    const [result] = await db.execute(
      "DELETE FROM tour_guides WHERE guide_id = ?",
      [guide_id]
    );
    return result;
  },
};

module.exports = TourGuide;
