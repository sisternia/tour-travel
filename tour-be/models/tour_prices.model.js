// models/tour_prices.model.js
const db = require("../config/db");

const TourPrices = {
  // Lấy danh sách bảng giá
  getAllPrices: async () => {
    const [rows] = await db.execute(`SELECT * FROM tour_prices ORDER BY price_id DESC`);
    return rows;
  },

  // Tạo bảng giá mới
  createPrice: async (data) => {
    const [result] = await db.execute(
      `INSERT INTO tour_prices (price_adult, price_child, valid_from, valid_to)
       VALUES (?, ?, ?, ?)`,
      [data.price_adult, data.price_child, data.valid_from, data.valid_to]
    );
    return result;
  },

  // Cập nhật bảng giá
  updatePrice: async (price_id, data) => {
    const [result] = await db.execute(
      `UPDATE tour_prices 
       SET price_adult=?, price_child=?, valid_from=?, valid_to=? 
       WHERE price_id=?`,
      [data.price_adult, data.price_child, data.valid_from, data.valid_to, price_id]
    );
    return result;
  },

  // Xóa bảng giá
  deletePrice: async (price_id) => {
    const [result] = await db.execute(`DELETE FROM tour_prices WHERE price_id=?`, [price_id]);
    return result;
  },

  // Danh sách tour để gán giá
  getTours: async () => {
    const [rows] = await db.execute(`SELECT id, name FROM tours ORDER BY name ASC`);
    return rows;
  },

  // Danh sách gán tour với bảng giá
  getAssignments: async () => {
    const [rows] = await db.execute(`
      SELECT a.id, t.name AS tour_name, p.price_adult, p.price_child, p.valid_from, p.valid_to
      FROM tour_price_assignments a
      LEFT JOIN tours t ON a.tour_id = t.id
      LEFT JOIN tour_prices p ON a.price_id = p.price_id
      ORDER BY a.id DESC
    `);
    return rows;
  },

  // Gán tour với bảng giá
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
