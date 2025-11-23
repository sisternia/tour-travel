const db = require("../config/db");

const Assignment = {
  // Tạo gán hướng dẫn viên cho tour
  create: async (tour_id, tour_guide_id) => {
    const [result] = await db.execute(
      `INSERT INTO tour_guide_assignment (tour_id, tour_guide_id)
       VALUES (?, ?)`,
      [tour_id, tour_guide_id]
    );
    return result;
  },

  // Lấy danh sách hướng dẫn viên của 1 tour
  getByTourId: async (tour_id) => {
    const [rows] = await db.execute(
      `SELECT a.id, g.guide_id, g.guide_name, g.email, g.avatar_image, g.language_job 
       FROM tour_guide_assignment a
       JOIN tour_guides g ON g.guide_id = a.tour_guide_id
       WHERE a.tour_id = ?`,
      [tour_id]
    );
    return rows;
  },

  // Xóa gán
  delete: async (id) => {
    const [result] = await db.execute(
      `DELETE FROM tour_guide_assignment WHERE id = ?`,
      [id]
    );
    return result;
  },
};

module.exports = Assignment;
