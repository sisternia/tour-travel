const express = require("express");
const router = express.Router();
const toursController = require("../controllers/tours.controller");

// Tạo tour mới
router.post("/", toursController.createTour);

// Lấy tất cả tour
router.get("/", toursController.getAllTours);

// Lấy tour theo id
router.get("/:id", toursController.getTourById);

// Cập nhật tour
router.put("/:id", toursController.updateTour);

// Xóa tour
router.delete("/:id", toursController.deleteTour);
// Lấy các tour mới nhất
router.get("/latest", toursController.getLatestTours);

module.exports = router;
