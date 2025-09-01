// app.js
require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth.routes');
const pool = require('./config/db');

const app = express();

app.use(bodyParser.json());
app.use('/api/auth', authRoutes);

// Kiểm tra kết nối cơ sở dữ liệu trước khi khởi động server
pool.getConnection()
  .then((connection) => {
    console.log('Kết nối cơ sở dữ liệu thành công');
    connection.release(); // Giải phóng kết nối sau khi kiểm tra

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Server chạy trên cổng ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Lỗi kết nối cơ sở dữ liệu:', err.message);
    process.exit(1); // Thoát chương trình nếu không kết nối được
  });
