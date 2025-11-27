const TourSchedules = require("../models/tour_schedules.model");

const getSchedules = async (req, res) => {
  try {
    const data = await TourSchedules.getAllSchedules();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Lỗi lấy dữ liệu lịch trình", error: err.message });
  }
};

const getSchedulesByTour = async (req, res) => {
  try {
    const { tour_id } = req.params;
    if (!tour_id) return res.status(400).json({ message: "Thiếu tour_id" });

    const data = await TourSchedules.getSchedulesByTour(tour_id);
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Lỗi tải lịch trình theo tour", error: err.message });
  }
};

const createSchedule = async (req, res) => {
  try {
    const { tour_id, day_number, description } = req.body;

    if (!tour_id || !day_number)
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc" });

    await TourSchedules.createSchedule({ tour_id, day_number, description });
    res.status(201).json({ message: "Thêm lịch trình thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const updateSchedule = async (req, res) => {
  try {
    const { schedule_id } = req.params;
    const { tour_id, day_number, description } = req.body;

    await TourSchedules.updateSchedule(schedule_id, { tour_id, day_number, description });
    res.status(200).json({ message: "Cập nhật lịch trình thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const deleteSchedule = async (req, res) => {
  try {
    await TourSchedules.deleteSchedule(req.params.schedule_id);
    res.status(200).json({ message: "Xóa lịch trình thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server khi xóa", error: err.message });
  }
};

const getTours = async (req, res) => {
  try {
    const data = await TourSchedules.getTours();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Không thể tải danh sách tour", error: err.message });
  }
};

module.exports = {
  getSchedules,
  getSchedulesByTour,
  createSchedule,
  updateSchedule,
  deleteSchedule,
  getTours,
};
