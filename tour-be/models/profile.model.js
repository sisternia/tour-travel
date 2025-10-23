// models/profile.model.js
const db = require('../config/db');

const Profile = {
  updateUserInfo: async (userId, userInfo) => {
    const fieldsToUpdate = [];
    const values = [];
    const allowedFields = ['phone', 'dob', 'citizen_id', 'address', 'bio', 'avatar', 'background'];

    allowedFields.forEach(field => {
      if (userInfo[field] !== undefined) {
        fieldsToUpdate.push(`${field} = ?`);
        values.push(userInfo[field]);
      }
    });

    if (fieldsToUpdate.length === 0) {
      return; // Nothing to update
    }

    // Always update the updated_at timestamp
    fieldsToUpdate.push('updated_at = NOW()');

    const sql = `UPDATE user_infor SET ${fieldsToUpdate.join(', ')} WHERE user_id = ?`;
    values.push(userId);

    const [result] = await db.execute(sql, values);
    return result;
  },

  getUserInfo: async (userId) => {
    const [rows] = await db.execute(
      'SELECT u.user_name, u.email, ui.* FROM users u JOIN user_infor ui ON u.user_id = ui.user_id WHERE u.user_id = ?',
      [userId]
    );
    return rows[0];
  }
};

module.exports = Profile;
