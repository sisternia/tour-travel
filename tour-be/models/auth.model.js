const db = require('../config/db');

const User = {
  create: async (user) => {
    const [result] = await db.execute(
      'INSERT INTO users (user_id, user_name, email, password) VALUES (?, ?, ?, ?)',
      [user.user_id, user.user_name, user.email, user.password]
    );
    return result;
  },
  createUserInfo: async (user_infor) => {
    const [result] = await db.execute(
      'INSERT INTO user_infor (user_infor_id, phone, dob, citizen_id, address, bio, avatar, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        user_infor.user_infor_id,
        null, // phone
        null, // dob
        null, // citizen_id
        null, // address
        null, // bio
        null, // avatar
        user_infor.user_id,
      ]
    );
    return result;
  },
  findByEmail: async (email) => {
    const [rows] = await db.execute('SELECT * FROM users WHERE email = ?', [email]);
    return rows[0];
  },
  findById: async (user_id) => {
    const [rows] = await db.execute('SELECT * FROM users WHERE user_id = ?', [user_id]);
    return rows[0];
  },
  updatePassword: async (user_id, hashedPassword) => {
    const [result] = await db.execute(
      'UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?',
      [hashedPassword, user_id]
    );
    return result;
  },
};

module.exports = User;
