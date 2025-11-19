// models/tour_prices.model.js
const db = require("../config/db");

const TourPrices = {

  getAllPrices: async () => {
    const [rows] = await db.execute(`SELECT * FROM tour_prices ORDER BY price_id DESC`);
    return rows;
  },

  createPrice: async (data) => {
    const [result] = await db.execute(
      `INSERT INTO tour_prices (price_adult, price_child, valid_from, valid_to)
       VALUES (?, ?, ?, ?)`,
      [data.price_adult, data.price_child, data.valid_from, data.valid_to]
    );
    return result;
  },

  updatePrice: async (price_id, data) => {
    const [result] = await db.execute(
      `UPDATE tour_prices 
       SET price_adult=?, price_child=?, valid_from=?, valid_to=? 
       WHERE price_id=?`,
      [data.price_adult, data.price_child, data.valid_from, data.valid_to, price_id]
    );
    return result;
  },

  deletePrice: async (price_id) => {
    const [result] = await db.execute(`DELETE FROM tour_prices WHERE price_id=?`, [price_id]);
    return result;
  },

  getTours: async () => {
    const [rows] = await db.execute(`SELECT id, name FROM tours ORDER BY name ASC`);
    return rows;
  },

  getAssignments: async () => {
    const [rows] = await db.execute(`
      SELECT a.id, t.name AS tour_name, p.price_adult, p.price_child, p.valid_from, p.valid_to, a.tour_id, a.price_id
      FROM tour_price_assignments a
      LEFT JOIN tours t ON a.tour_id = t.id
      LEFT JOIN tour_prices p ON a.price_id = p.price_id
      ORDER BY a.id DESC
    `);
    return rows;
  },

  getAssignmentsByTour: async (tour_id) => {
    const [rows] = await db.execute(`
      SELECT a.id, t.name AS tour_name, p.price_adult, p.price_child, p.valid_from, p.valid_to, a.tour_id, a.price_id
      FROM tour_price_assignments a
      LEFT JOIN tours t ON a.tour_id = t.id
      LEFT JOIN tour_prices p ON a.price_id = p.price_id
      WHERE a.tour_id = ?
      ORDER BY a.id DESC
    `, [tour_id]);
    return rows;
  },

  createAssignment: async (tour_id, price_id) => {
    const [result] = await db.execute(
      `INSERT INTO tour_price_assignments (tour_id, price_id) VALUES (?, ?)`,
      [tour_id, price_id]
    );
    return result;
  },

  deleteAssignment: async (id) => {
    const [result] = await db.execute(`DELETE FROM tour_price_assignments WHERE id=?`, [id]);
    return result;
  },
};

module.exports = TourPrices;
