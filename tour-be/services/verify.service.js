// services/verify.service.js
require('dotenv').config();
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const sendVerifyEmail = async (toEmail, code) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: toEmail,
    subject: 'Xác nhận tài khoản',
    text: `Mã xác nhận tài khoản của bạn là: ${code}`,
  };

  await transporter.sendMail(mailOptions);
};

const sendOrderStatusMail = async (toEmail, statusText, orderId) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: toEmail,
    subject: `Cập nhật trạng thái đơn hàng #${orderId}`,
    text: `Đơn hàng #${orderId} hiện có trạng thái: ${statusText}`,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = { sendVerifyEmail, sendOrderStatusMail };
