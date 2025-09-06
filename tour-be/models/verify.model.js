// models/verify.model.js
const db = require('../config/db');

const Verify = {
  create: async ({ verify_id, user_id, verify_code }) => {
    const [result] = await db.execute(
      'INSERT INTO verify (verify_id, user_id, verify_code, verify_status) VALUES (?, ?, ?, 0)',
      [verify_id, user_id, verify_code]
    );
    return result;
  },

  findByUserId: async (user_id) => {
    const [rows] = await db.execute('SELECT * FROM verify WHERE user_id = ?', [user_id]);
    return rows[0];
  },

  updateCode: async (user_id, verify_code) => {
    const [result] = await db.execute(
      'UPDATE verify SET verify_code = ?, verify_status = 0 WHERE user_id = ?',
      [verify_code, user_id]
    );
    return result;
  },

  verifyAccount: async (user_id, verify_code) => {
    const [result] = await db.execute(
      'UPDATE verify SET verify_status = 1 WHERE user_id = ? AND verify_code = ?',
      [user_id, verify_code]
    );
    return result;
  },
};

module.exports = Verify;
