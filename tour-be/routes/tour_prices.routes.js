// routes/tour_prices.routes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/tour_prices.controller");

// Quản lý bảng giá
router.get("/prices", controller.getPrices);
router.post("/prices", controller.createPrice);
router.put("/prices/:price_id", controller.updatePrice);
router.delete("/prices/:price_id", controller.deletePrice);

// Quản lý gán tour
router.get("/assignments", controller.getAssignments);
router.get("/assignment/:tour_id", controller.getAssignmentsByTour); 
router.post("/assignments", controller.createAssignment);
router.delete("/assignments/:id", controller.deleteAssignment);

// Danh sách tour để chọn
router.get("/tours", controller.getTours);

module.exports = router;
