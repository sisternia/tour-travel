// app.js
require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const authRoutes = require('./routes/auth.routes');
const profileRoutes = require('./routes/profile.routes');
const tourTypeRoutes = require("./routes/tours_type.routes");
const tourRoutes = require("./routes/tours.routes");
const pool = require('./config/db');

const app = express();

app.use(bodyParser.json());
app.use(cors({ origin: '*' }));

// Serve static folders
app.use('/assets', express.static('assets'));

// 🆕 Serve admin dashboard
app.use('/admin', express.static('admin'));

app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use("/api/tour-types", tourTypeRoutes);
app.use("/api/tours", tourRoutes);

app.get('/', (req, res) => {
  res.send('Server đang chạy!');
});

pool.getConnection()
  .then((connection) => {
    console.log('Kết nối cơ sở dữ liệu thành công');
    connection.release();

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Server chạy trên cổng ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Lỗi kết nối cơ sở dữ liệu:', err.message);
    process.exit(1);
  });
