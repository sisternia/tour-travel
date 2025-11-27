// app.js

require("dotenv").config();
const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/auth.routes");
const profileRoutes = require("./routes/profile.routes");
const tourTypeRoutes = require("./routes/tours_type.routes");
const tourCategoriesRoutes = require("./routes/tour_categories.routes");
const tourRoutes = require("./routes/tours.routes");
const tourPricesRoutes = require("./routes/tour_prices.routes");
const tourImagesRoutes = require("./routes/tour_images.routes");
const tourLocationsRoutes = require("./routes/tour_locations.routes");
const tourGuideRoutes = require("./routes/tour_guides.routes");
const tourGuideAssignmentRoutes = require("./routes/tour_guide_assignment.routes");
const tourSchedulesRoutes = require("./routes/tour_schedules.routes");
const mapboxRoutes = require("./services/mapbox.service");
const postRoutes = require("./routes/posts.routes");
const orderRoutes = require("./routes/order.routes");
const momoRoute = require("./routes/momo.routes");
// const vnpayRoute = require("./routes/vnpay.route");

const pool = require("./config/db");

const app = express();

app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

app.use(
  cors({
    origin: "*",
    methods: "GET,POST,PUT,DELETE",
    allowedHeaders: "Content-Type,Authorization",
  })
);

// Serve admin dashboard
app.use("/assets", express.static("assets"));
app.use("/admin", express.static("admin"));

// API routes
app.use("/api/auth", authRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/tour-types", tourTypeRoutes);
app.use("/api/tour-categories", tourCategoriesRoutes);
app.use("/api/tours", tourRoutes);
app.use("/api/tour-images", tourImagesRoutes);
app.use("/api/tour-prices", tourPricesRoutes);
app.use("/api/tour-locations", tourLocationsRoutes);
app.use("/api/tour-guides", tourGuideRoutes);
app.use("/api/tour-guide-assignment", tourGuideAssignmentRoutes);
app.use("/api/tour-schedules", tourSchedulesRoutes);
app.use("/api/orders", orderRoutes);
// app.use("/api/vnpay", vnpayRoute);
app.use("/api/mapbox", mapboxRoutes);
app.use("/api/momo", momoRoute);
app.use("/api/posts", postRoutes);

app.get("/", (req, res) => {
  res.send("Server đang chạy!");
});

pool
  .getConnection()
  .then((connection) => {
    console.log("Kết nối cơ sở dữ liệu thành công");
    connection.release();

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Server chạy trên cổng ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Lỗi kết nối cơ sở dữ liệu:", err.message);
    process.exit(1);
  });
