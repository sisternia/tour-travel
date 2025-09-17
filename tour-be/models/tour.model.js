const db = require("../config/db");

const Tour = {
  create: async (tour) => {
    const [result] = await db.execute(
      `INSERT INTO tours 
        (name, price_adult, price_child, number_of_people, start_date, end_date, 
         departure_address, destination_address, rating, schedules, location, status, 
         tour_category_id, tour_type_id) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        tour.name,
        tour.price_adult,
        tour.price_child,
        tour.number_of_people,
        tour.start_date,
        tour.end_date,
        tour.departure_address,
        tour.destination_address,
        tour.rating || null,
        tour.schedules || null,
        tour.location || null,
        tour.status || "active",
        tour.tour_category_id || null,
        tour.tour_type_id || null,
      ]
    );
    return result;
  },

  // Lấy tất cả tour
  findAll: async () => {
    const [rows] = await db.execute("SELECT * FROM tours");
    return rows;
  },

  // Lấy tour theo id
  findById: async (id) => {
    const [rows] = await db.execute("SELECT * FROM tours WHERE id = ?", [id]);
    return rows[0];
  },

  // Cập nhật tour
  update: async (id, tour) => {
    const [result] = await db.execute(
      `UPDATE tours SET 
        name = ?, price_adult = ?, price_child = ?, number_of_people = ?, 
        start_date = ?, end_date = ?, departure_address = ?, destination_address = ?, 
        rating = ?, schedules = ?, location = ?, status = ?, 
        tour_category_id = ?, tour_type_id = ?, updated_at = CURRENT_TIMESTAMP 
       WHERE id = ?`,
      [
        tour.name,
        tour.price_adult,
        tour.price_child,
        tour.number_of_people,
        tour.start_date,
        tour.end_date,
        tour.departure_address,
        tour.destination_address,
        tour.rating,
        tour.schedules,
        tour.location,
        tour.status,
        tour.tour_category_id,
        tour.tour_type_id,
        id,
      ]
    );
    return result;
  },

  // Xóa tour
  delete: async (id) => {
    const [result] = await db.execute("DELETE FROM tours WHERE id = ?", [id]);
    return result;
  },
  findLatest: async (limit = 5) => {
    const [rows] = await db.execute(
      "SELECT id, name, price, thumbnail, start_date FROM tours ORDER BY created_at DESC LIMIT ?",
      [limit]
    );
    return rows;
  },
};

module.exports = Tour;
