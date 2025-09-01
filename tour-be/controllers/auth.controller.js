// controllers/auth.controller.js
const User = require('../models/auth.model');
const { hashPassword } = require('../services/auth.service');
const { sendVerifyEmail } = require('../services/verify.service');
const Verify = require('../models/verify.model');
const crypto = require('crypto');

const register = async (req, res) => {
  try {
    const { user_name, email, password } = req.body;

    if (!user_name || !email || !password) {
      return res.status(400).json({ message: 'Thiếu dữ liệu' });
    }

    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: 'Email đã tồn tại' });
    }

    const hashedPassword = await hashPassword(password);
    const user_id = crypto.randomBytes(3).toString('hex');

    await User.create({ user_id, user_name, email, password: hashedPassword });

    const verify_id = crypto.randomBytes(3).toString('hex');
    const verify_code = Math.floor(100000 + Math.random() * 900000).toString();

    await Verify.create({ verify_id, user_id, verify_code });

    await sendVerifyEmail(email, verify_code);

    res.status(201).json({
      message: 'Đăng ký thành công, vui lòng kiểm tra email để xác nhận tài khoản',
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
};

module.exports = { register };
