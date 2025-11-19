// models/tours.model.js
const db = require("../config/db");

const Tour = {
  getAll: async () => {
    const [rows] = await db.execute("SELECT * FROM tours ORDER BY created_at DESC");
    return rows;
  },

  create: async (data) => {
    const [result] = await db.execute(
      `INSERT INTO tours 
      (name, number_of_people, start_date, end_date, departure_address, destination_address, status, tour_category_id, tour_type_id) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        data.name,
        data.number_of_people,
        data.start_date,
        data.end_date,
        data.departure_address,
        data.destination_address,
        data.status,
        data.tour_category_id,
        data.tour_type_id,
      ]
    );
    return result;
  },

  update: async (id, data) => {
    const [result] = await db.execute(
      `UPDATE tours SET name=?, number_of_people=?, start_date=?, end_date=?, departure_address=?, destination_address=?, status=?, tour_category_id=?, tour_type_id=? WHERE id=?`,
      [
        data.name,
        data.number_of_people,
        data.start_date,
        data.end_date,
        data.departure_address,
        data.destination_address,
        data.status,
        data.tour_category_id,
        data.tour_type_id,
        id,
      ]
    );
    return result;
  },

  delete: async (id) => {
    const [result] = await db.execute("DELETE FROM tours WHERE id = ?", [id]);
    return result;
  },
};

module.exports = Tour;
