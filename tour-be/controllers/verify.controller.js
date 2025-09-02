const crypto = require('crypto');
const Verify = require('../models/verify.model');
const User = require('../models/auth.model');
const { sendVerifyEmail } = require('../services/verify.service');
const { hashPassword } = require('../services/auth.service'); 

// Gửi mã xác nhận
const sendCode = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: 'Thiếu email' });

    const user = await User.findByEmail(email);
    if (!user) return res.status(404).json({ message: 'Không tìm thấy user' });

    const verify_code = Math.floor(100000 + Math.random() * 900000).toString();
    const existing = await Verify.findByUserId(user.user_id);

    if (existing) {
      await Verify.updateCode(user.user_id, verify_code);
    } else {
      const verify_id = crypto.randomBytes(3).toString('hex');
      await Verify.create({ verify_id, user_id: user.user_id, verify_code });
    }

    await sendVerifyEmail(email, verify_code);

    res.json({ message: 'Đã gửi mã xác nhận tới email' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
};

// Xác nhận tài khoản hoặc quên mật khẩu
const verifyAccount = async (req, res) => {
  try {
    const { email, verify_code, type } = req.body;
    if (!email || !verify_code || !type) {
      return res.status(400).json({ message: 'Thiếu dữ liệu' });
    }

    const user = await User.findByEmail(email);
    if (!user) return res.status(404).json({ message: 'Không tìm thấy user' });

    const v = await Verify.findByUserId(user.user_id);
    if (!v) return res.status(400).json({ message: 'Chưa có mã xác nhận cho user này' });

    if (v.verify_code !== verify_code) {
      return res.status(400).json({ message: 'Mã xác nhận không đúng' });
    }

    if (type === 'register') {
      const result = await Verify.verifyAccount(user.user_id, verify_code);
      if (result.affectedRows === 0) {
        return res.status(400).json({ message: 'Mã xác nhận không đúng hoặc đã xác nhận' });
      }
      return res.json({ message: 'Xác nhận tài khoản thành công' });
    } else if (type === 'forgot') {
      return res.json({ message: 'Mã xác nhận hợp lệ, tiếp tục đặt lại mật khẩu' });
    } else {
      return res.status(400).json({ message: 'Loại xác minh không hợp lệ' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
};

// Reset mật khẩu
const resetPassword = async (req, res) => {
  try {
    const { email, new_password } = req.body;
    if (!email || !new_password) {
      return res.status(400).json({ message: 'Thiếu dữ liệu' });
    }

    const user = await User.findByEmail(email);
    if (!user) return res.status(404).json({ message: 'Không tìm thấy user' });

    const hashed = await hashPassword(new_password); // 👈 giờ hashPassword có rồi
    await User.updatePassword(user.user_id, hashed);

    res.json({ message: 'Đặt lại mật khẩu thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
};

module.exports = { sendCode, verifyAccount, resetPassword };
