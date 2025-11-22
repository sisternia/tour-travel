// // app.js
// require("dotenv").config();
// const express = require("express");
// const bodyParser = require("body-parser");
// const cors = require("cors");
// const authRoutes = require("./routes/auth.routes");
// const profileRoutes = require("./routes/profile.routes");
// const tourTypeRoutes = require("./routes/tours_type.routes");
// const tourCategoriesRoutes = require("./routes/tour_categories.routes");
// const tourRoutes = require("./routes/tours.routes");
// const tourPricesRoutes = require("./routes/tour_prices.routes");
// const tourImagesRoutes = require("./routes/tour_images.routes");
// const tourLocationsRoutes = require("./routes/tour_locations.routes");
// const tourGuideRoutes = require("./routes/tour_guides.routes");
// const tourGuideAssignmentRoutes = require("./routes/tour_guide_assignment.routes");
// const mapboxRoutes = require("./services/mapbox.service");
// const orderRoutes = require("./routes/order.routes");
// const vnpayRoute = require("./routes/vnpay.route");

// // const paymentRoutes = require("./routes/payment.routes");

// const pool = require("./config/db");

// const app = express();

// // app.use(bodyParser.json());
// // app.use(cors({ origin: "*" }));

// // // Serve static folders
// // app.use("/assets", express.static("assets"));

// // // 🆕 Serve admin dashboard
// // app.use("/admin", express.static("admin"));

// // app.use("/api/auth", authRoutes);
// // app.use("/api/profile", profileRoutes);
// // app.use("/api/tour-types", tourTypeRoutes);
// // app.use("/api/tour-categories", tourCategoriesRoutes);
// // app.use("/api/tours", tourRoutes);
// // app.use("/api/tour-images", tourImagesRoutes);
// // app.use("/api/tour-prices", tourPricesRoutes);
// // app.use("/api/tour-locations", tourLocationsRoutes);
// // app.use("/api/tour-guides", tourGuideRoutes);
// // app.use("/api/tour-guide-assignment", tourGuideAssignmentRoutes);
// // app.use("/api/orders", orderRoutes);
// // app.use("/api/vnpay", vnpayRoute);
// // // app.use("/api/payments", paymentRoutes);
// // app.use("/api/mapbox", mapboxRoutes);

// // app.get("/", (req, res) => {
// //   res.send("Server đang chạy!");
// // });
// // app.use(
// //   cors({
// //     origin: "*",
// //     methods: ["GET", "POST", "PUT", "DELETE"],
// //     allowedHeaders: ["Content-Type", "Authorization"],
// //   })
// // );

// // pool
// //   .getConnection()
// //   .then((connection) => {
// //     console.log("Kết nối cơ sở dữ liệu thành công");
// //     connection.release();

// //     const PORT = process.env.PORT || 3000;
// //     app.listen(PORT, () => {
// //       console.log(`Server chạy trên cổng ${PORT}`);
// //     });
// //   })
// //   .catch((err) => {
// //     console.error("Lỗi kết nối cơ sở dữ liệu:", err.message);
// //     process.exit(1);
// //   });
// app.use(bodyParser.json());

// app.use(
//   cors({
//     origin: "*",
//     methods: ["GET", "POST", "PUT", "DELETE"],
//     allowedHeaders: ["Content-Type", "Authorization"],
//   })
// );

// // Serve static files
// app.use("/assets", express.static("assets"));
// app.use("/admin", express.static("admin"));

// // API routes
// app.use("/api/auth", authRoutes);
// app.use("/api/profile", profileRoutes);
// app.use("/api/tour-types", tourTypeRoutes);
// app.use("/api/tour-categories", tourCategoriesRoutes);
// app.use("/api/tours", tourRoutes);
// app.use("/api/tour-images", tourImagesRoutes);
// app.use("/api/tour-prices", tourPricesRoutes);
// app.use("/api/tour-locations", tourLocationsRoutes);
// app.use("/api/tour-guides", tourGuideRoutes);
// app.use("/api/tour-guide-assignment", tourGuideAssignmentRoutes);
// app.use("/api/orders", orderRoutes);
// app.use("/api/vnpay", vnpayRoute);
// app.use("/api/mapbox", mapboxRoutes);

// app.get("/", (req, res) => {
//   res.send("Server đang chạy!");
// });
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
const mapboxRoutes = require("./services/mapbox.service");
const orderRoutes = require("./routes/order.routes");
const vnpayRoute = require("./routes/vnpay.route");
const pool = require("./config/db");

const app = express();

// ============================
// FIX 1 — KHÔNG dùng body-parser nữa
// ============================
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

// ============================
// FIX 2 — chỉ dùng CORS 1 lần
// ============================
app.use(
  cors({
    origin: "*",
    methods: "GET,POST,PUT,DELETE",
    allowedHeaders: "Content-Type,Authorization",
  })
);

// Serve static files
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
app.use("/api/orders", orderRoutes);
app.use("/api/vnpay", vnpayRoute);
app.use("/api/mapbox", mapboxRoutes);

app.get("/", (req, res) => {
  res.send("Server đang chạy!");
});

// ============================
// DATABASE + START SERVER
// ============================
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
