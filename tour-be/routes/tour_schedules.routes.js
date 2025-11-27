const express = require("express");
const router = express.Router();
const controller = require("../controllers/tour_schedules.controller");

// Lấy toàn bộ lịch trình
router.get("/", controller.getSchedules);

// Lấy lịch trình theo tour
router.get("/tour/:tour_id", controller.getSchedulesByTour);

// Tạo mới lịch trình
router.post("/", controller.createSchedule);

// Cập nhật lịch trình
router.put("/:schedule_id", controller.updateSchedule);

// Xóa lịch trình
router.delete("/:schedule_id", controller.deleteSchedule);

// Lấy danh sách tour
router.get("/tours/list", controller.getTours);

module.exports = router;
