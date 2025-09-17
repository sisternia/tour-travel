require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const authRoutes = require("./routes/auth.route");
const pool = require("./config/db");
const tourTypeRoutes = require("./routes/tour_type.route");
const tourRoutes = require("./routes/tours.route");
const app = express();

app.use(bodyParser.json());

app.use(
  cors({
    origin: "*",
  })
);

app.get("/", (req, res) => {
  res.send("Server đang chạy!");
});

app.use("/api/auth", authRoutes);
app.use("/api/tour-types", tourTypeRoutes);
app.use("/api/tours", tourRoutes);

pool
  .getConnection()
  .then((connection) => {
    console.log("Kết nối cơ sở dữ liệu thành công");
    connection.release();

    const PORT = process.env.PORT || 3000;
    const HOST = "0.0.0.0";
    app.listen(PORT, HOST, () => {
      console.log(`Server chạy trên cổng ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Lỗi kết nối cơ sở dữ liệu:", err.message);
    process.exit(1);
  });
