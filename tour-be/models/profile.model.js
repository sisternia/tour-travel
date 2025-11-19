// models/profile.model.js
const db = require('../config/db');

const Profile = {
  updateUserInfo: async (userId, userInfo) => {
    const fields = [];
    const values = [];
    const allowed = ['phone', 'dob', 'citizen_id', 'address', 'bio', 'avatar', 'background'];

    allowed.forEach(f => {
      if (userInfo[f] !== undefined) {
        fields.push(`${f} = ?`);
        values.push(userInfo[f]);
      }
    });

    if (!fields.length) return;

    fields.push('updated_at = NOW()');
    values.push(userId);

    await db.execute(
      `UPDATE user_infor SET ${fields.join(', ')} WHERE user_id = ?`,
      values
    );
  },

  getUserInfo: async (userId) => {
    const [rows] = await db.execute(
      `SELECT 
        u.user_id, u.user_name, u.email,
        ui.phone, ui.dob, ui.citizen_id, ui.address, ui.bio,
        ui.avatar, ui.background
      FROM users u
      JOIN user_infor ui ON u.user_id = ui.user_id
      WHERE u.user_id = ?`,
      [userId]
    );
    return rows[0];
  },

  getAllUsers: async () => {
    const [rows] = await db.execute(
      `SELECT 
        u.user_id, u.user_name, u.email,
        ui.phone, ui.dob, ui.citizen_id, ui.address, ui.bio,
        ui.avatar, ui.background
      FROM users u
      JOIN user_infor ui ON u.user_id = ui.user_id
      ORDER BY u.created_at DESC`
    );
    return rows;
  },
};

module.exports = Profile;
