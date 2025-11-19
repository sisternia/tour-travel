// controllers/tour_prices.controller.js
const TourPrices = require("../models/tour_prices.model");

const getPrices = async (req, res) => {
  try {
    const data = await TourPrices.getAllPrices();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Lỗi lấy dữ liệu bảng giá", error: err.message });
  }
};

const createPrice = async (req, res) => {
  try {
    const { price_adult, price_child, valid_from, valid_to } = req.body;
    if (!price_adult || !price_child)
      return res.status(400).json({ message: "Thiếu thông tin giá" });

    await TourPrices.createPrice({ price_adult, price_child, valid_from, valid_to });
    res.status(201).json({ message: "Thêm bảng giá thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const updatePrice = async (req, res) => {
  try {
    const { price_id } = req.params;
    const { price_adult, price_child, valid_from, valid_to } = req.body;
    await TourPrices.updatePrice(price_id, { price_adult, price_child, valid_from, valid_to });
    res.status(200).json({ message: "Cập nhật bảng giá thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const deletePrice = async (req, res) => {
  try {
    await TourPrices.deletePrice(req.params.price_id);
    res.status(200).json({ message: "Xóa bảng giá thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const getTours = async (req, res) => {
  try {
    const data = await TourPrices.getTours();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Không thể tải danh sách tour", error: err.message });
  }
};

const getAssignments = async (req, res) => {
  try {
    const data = await TourPrices.getAssignments();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Không thể tải danh sách gán tour", error: err.message });
  }
};

const getAssignmentsByTour = async (req, res) => {
  try {
    const { tour_id } = req.params;
    if (!tour_id) return res.status(400).json({ message: "Thiếu tour_id" });
    const data = await TourPrices.getAssignmentsByTour(tour_id);
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ message: "Lỗi khi lấy bảng giá cho tour", error: err.message });
  }
};

const createAssignment = async (req, res) => {
  try {
    const { tour_id, price_id } = req.body;
    if (!tour_id || !price_id)
      return res.status(400).json({ message: "Thiếu thông tin gán" });

    await TourPrices.createAssignment(tour_id, price_id);
    res.status(201).json({ message: "Gán tour với bảng giá thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi khi gán tour", error: err.message });
  }
};

const deleteAssignment = async (req, res) => {
  try {
    await TourPrices.deleteAssignment(req.params.id);
    res.status(200).json({ message: "Hủy gán tour thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi khi xóa gán", error: err.message });
  }
};

module.exports = {
  getPrices,
  createPrice,
  updatePrice,
  deletePrice,
  getTours,
  getAssignments,
  getAssignmentsByTour,
  createAssignment,
  deleteAssignment,
};
