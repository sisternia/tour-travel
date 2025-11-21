const db = require("../config/db");

const Tour = {
  getAll: async () => {
    const [rows] = await db.execute(
      "SELECT * FROM tours ORDER BY created_at DESC"
    );
    return rows;
  },
  getLatestWithPrices: async () => {
    const [rows] = await db.execute(`
    SELECT 
      t.*, 
      p.price_adult, 
      p.price_child
    FROM tours t
    LEFT JOIN tour_price_assignments a ON a.tour_id = t.id
    LEFT JOIN tour_prices p ON p.price_id = a.price_id
    ORDER BY t.created_at DESC
    LIMIT 5
  `);

    return rows;
  },

  getTourById: async (id) => {
    const [rows] = await db.execute(
      "SELECT * FROM tours WHERE id = ? LIMIT 1",
      [id]
    );
    return rows[0] || null;
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
