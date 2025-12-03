// models/orders.model.js
const db = require("../config/db");

module.exports = {
  getAllOrders: () => {
    return db.execute(`
    SELECT 
      o.*,
      tc.type_name,
      t.name AS tour_name,
      IFNULL(r.rated, 0) AS isRated
    FROM orders o
    LEFT JOIN type_confirms tc ON o.type_confirm_id = tc.id
    LEFT JOIN tours t ON o.tour_id = t.id
    LEFT JOIN (
      SELECT tour_id, user_id, COUNT(*) AS rated
      FROM tour_ratings
      GROUP BY tour_id, user_id
    ) r ON r.tour_id = o.tour_id AND r.user_id = o.user_id
    ORDER BY o.order_at DESC
  `);
  },

  getOrderById: (orderId) => {
    return db.execute(
      `
    SELECT 
      o.*,
      tc.type_name,
      t.name AS tour_name,
      IFNULL(r.rated, 0) AS isRated
    FROM orders o
    LEFT JOIN type_confirms tc ON o.type_confirm_id = tc.id
    LEFT JOIN tours t ON o.tour_id = t.id
    LEFT JOIN (
      SELECT tour_id, user_id, COUNT(*) AS rated
      FROM tour_ratings
      GROUP BY tour_id, user_id
    ) r ON r.tour_id = o.tour_id AND r.user_id = o.user_id
    WHERE o.id = ?
    `,
      [orderId]
    );
  },

  getOrdersByUser: (userId) => {
    return db.execute(
      `
    SELECT 
      o.*,
      tc.type_name,
      t.name AS tour_name,
      IFNULL(r.rated, 0) AS isRated
    FROM orders o
    LEFT JOIN type_confirms tc ON o.type_confirm_id = tc.id
    LEFT JOIN tours t ON o.tour_id = t.id
    LEFT JOIN (
      SELECT tour_id, user_id, COUNT(*) AS rated
      FROM tour_ratings
      GROUP BY tour_id, user_id
    ) r ON r.tour_id = o.tour_id AND r.user_id = o.user_id
    WHERE o.user_id = ?
    ORDER BY o.order_at DESC
    `,
      [userId]
    );
  },

  createOrder: (data) => {
    const {
      number_of_child,
      number_of_adult,
      name_tourist,
      phone_tourist,
      email_tourist,
      total,
      note,
      user_id,
      tour_id,
    } = data;

    return db.execute(
      `
      INSERT INTO orders (
        number_of_child, number_of_adult, name_tourist, phone_tourist,
        email_tourist, total, note, user_id, tour_id, type_confirm_id
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
    `,
      [
        number_of_child,
        number_of_adult,
        name_tourist,
        phone_tourist,
        email_tourist,
        total,
        note,
        user_id,
        tour_id,
      ]
    );
  },

  updateStatus: (orderId, type_confirm_id) => {
    return db.execute(
      `
      UPDATE orders 
      SET type_confirm_id = ?
      WHERE id = ?
    `,
      [type_confirm_id, orderId]
    );
  },

  deleteOrder: (orderId) => {
    return db.execute(`DELETE FROM orders WHERE id = ?`, [orderId]);
  },
};
