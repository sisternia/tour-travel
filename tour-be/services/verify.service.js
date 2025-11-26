// services/verify.service.js
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'vu784512000@gmail.com',
    pass: 'mjyf gtna tjyl gjns', 
  },
});

const sendVerifyEmail = async (toEmail, code) => {
  const mailOptions = {
    from: 'vu784512000@gmail.com',
    to: toEmail,
    subject: 'Xác nhận tài khoản',
    text: `Mã xác nhận tài khoản của bạn là: ${code}`,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = { sendVerifyEmail };
