// models\orders.model.js

const db = require("../config/db");

module.exports = {
  getAllOrders: () => {
    return db.execute(`
            SELECT o.*, t.type_name
            FROM orders o
            JOIN type_confirms t ON o.type_confirm_id = t.id
            ORDER BY o.order_at DESC
        `);
  },

  getOrderById: (orderId) => {
    return db.execute(
      `
            SELECT o.*, t.type_name
            FROM orders o
            JOIN type_confirms t ON o.type_confirm_id = t.id
            WHERE o.id = ?
        `,
      [orderId]
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
                email_tourist, total, note, user_id, tour_id
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
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
