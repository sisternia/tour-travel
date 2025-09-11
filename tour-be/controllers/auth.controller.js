// controllers/auth.controller.js
const User = require("../models/auth.model");
const Verify = require("../models/verify.model");
const {
  hashPassword,
  comparePassword,
  generateToken,
} = require("../services/auth.service");
const { sendVerifyEmail } = require("../services/verify.service");
const crypto = require("crypto");

const register = async (req, res) => {
  try {
    const { user_name, email, password } = req.body;

    if (!user_name || !email || !password) {
      return res.status(400).json({ message: "Thiếu dữ liệu" });
    }

    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: "Email đã tồn tại" });
    }

    const hashedPassword = await hashPassword(password);
    const user_id = crypto.randomBytes(3).toString("hex");

    // Tạo user
    await User.create({ user_id, user_name, email, password: hashedPassword });

    // Tạo user_infor với các field null
    const user_infor_id = crypto.randomBytes(5).toString("hex");
    await User.createUserInfo({ user_infor_id, user_id });

    // Tạo verify
    const verify_id = crypto.randomBytes(3).toString("hex");
    const verify_code = Math.floor(100000 + Math.random() * 900000).toString();

    await Verify.create({ verify_id, user_id, verify_code });

    await sendVerifyEmail(email, verify_code);

    res.status(201).json({
      message:
        "Đăng ký thành công, vui lòng kiểm tra email để xác nhận tài khoản",
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password)
      return res.status(400).json({ message: "Thiếu email hoặc mật khẩu" });

    const user = await User.findByEmail(email);
    if (!user) return res.status(400).json({ message: "Email không tồn tại" });

    const verify = await Verify.findByUserId(user.user_id);
    if (!verify || verify.verify_status === 0) {
      return res.status(403).json({ message: "Tài khoản chưa được xác nhận" });
    }

    const isMatch = await comparePassword(password, user.password);
    if (!isMatch) return res.status(400).json({ message: "Sai mật khẩu" });

    const token = generateToken({ user_id: user.user_id, email: user.email });

    // ✅ Trả về đúng data
    res.status(200).json({
      success: true,
      message: "Đăng nhập thành công",
      data: {
        token,
        user: {
          userId: user.user_id,
          userName: user.user_name,
          email: user.email,
        },
      },
    });

    console.log("User from DB:", user);
    console.log("Verify info:", verify);
    console.log("Password match:", isMatch);
    console.log("Generated token:", token);
    console.log("Response data:", {
      token,
      user: {
        userId: user.user_id,
        userName: user.user_name,
        email: user.email,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

module.exports = { register, login };
