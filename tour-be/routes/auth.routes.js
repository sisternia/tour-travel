// routes/auth.routes.js
const express = require('express');
const router = express.Router();
const { register } = require('../controllers/auth.controller');
const { sendCode, verifyAccount } = require('../controllers/verify.controller');

// Đăng ký
router.post('/register', register);

// Gửi lại mã xác nhận
router.post('/send-verify-code', sendCode);

// Xác nhận tài khoản
router.post('/verify-account', verifyAccount);

module.exports = router;
