// controllers/verify.controller.js
const crypto = require('crypto');
const Verify = require('../models/verify.model');
const User = require('../models/auth.model');
const { sendVerifyEmail } = require('../services/verify.service');

const sendCode = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: 'Thiếu email' });

    const user = await User.findByEmail(email);
    if (!user) return res.status(404).json({ message: 'Không tìm thấy user' });

    const verify_code = Math.floor(100000 + Math.random() * 900000).toString(); // 6 số
    const existing = await Verify.findByUserId(user.user_id);

    if (existing) {
      await Verify.updateCode(user.user_id, verify_code);
    } else {
      const verify_id = crypto.randomBytes(3).toString('hex'); // 6 ký tự
      await Verify.create({ verify_id, user_id: user.user_id, verify_code });
    }

    await sendVerifyEmail(email, verify_code);

    res.json({ message: 'Đã gửi mã xác nhận tới email' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
};

const verifyAccount = async (req, res) => {
  try {
    const { email, verify_code } = req.body;
    if (!email || !verify_code) {
      return res.status(400).json({ message: 'Thiếu dữ liệu' });
    }

    const user = await User.findByEmail(email);
    if (!user) return res.status(404).json({ message: 'Không tìm thấy user' });

    const result = await Verify.verifyAccount(user.user_id, verify_code);
    if (result.affectedRows === 0) {
      return res.status(400).json({ message: 'Mã xác nhận không đúng' });
    }

    res.json({ message: 'Xác nhận tài khoản thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
};

module.exports = { sendCode, verifyAccount };
