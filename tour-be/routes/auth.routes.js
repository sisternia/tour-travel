// routes/auth.routes.js
const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/auth.controller');
const { sendCode, verifyAccount, resetPassword } = require('../controllers/verify.controller');

// Đăng ký
router.post('/register', register);

// Đăng nhập
router.post('/login', login);

// Gửi lại mã xác nhận
router.post('/send-verify-code', sendCode);

// Xác nhận tài khoản
router.post('/verify-account', verifyAccount);

// Reset password (sau khi verify-account type=forgot thành công)
router.post('/reset-password', resetPassword);

module.exports = router;
