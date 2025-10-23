// controllers/tour_type.controller.js
const TourType = require("../models/tours_type.model");

const getAllTourTypes = async (req, res) => {
  try {
    const tourTypes = await TourType.getAll();

    // ✅ Trả về mảng trực tiếp, không bọc trong "data"
    res.status(200).json(tourTypes);
  } catch (error) {
    console.error("Error fetching tour types:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const getTourTypeById = async (req, res) => {
  try {
    const { type_id } = req.params;

    if (!type_id) {
      return res.status(400).json({ message: "Thiếu type_id" });
    }

    const tourType = await TourType.findById(type_id);
    if (!tourType) {
      return res.status(404).json({ message: "Không tìm thấy loại tour" });
    }

    res.status(200).json({
      success: true,
      message: "Lấy loại tour theo ID thành công",
      data: tourType,
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const getTourTypeByName = async (req, res) => {
  try {
    const { type_name } = req.params;

    if (!type_name) {
      return res.status(400).json({ message: "Thiếu type_name" });
    }

    const tourType = await TourType.findByName(type_name);
    if (!tourType) {
      return res.status(404).json({ message: "Không tìm thấy loại tour" });
    }

    res.status(200).json({
      success: true,
      message: "Lấy loại tour theo tên thành công",
      data: tourType,
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

module.exports = { getAllTourTypes, getTourTypeById, getTourTypeByName };
