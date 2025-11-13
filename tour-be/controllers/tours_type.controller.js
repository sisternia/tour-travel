// controllers\tours_type.controller.js

const fs = require("fs");
const path = require("path");
const TourType = require("../models/tours_type.model");
const multer = require("multer");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "assets/tour-type/");
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    const fileName = Date.now() + ext;
    cb(null, fileName);
  },
});
const upload = multer({ storage });

// Lấy tất cả loại tour
const getAllTourTypes = async (req, res) => {
  try {
    const tourTypes = await TourType.getAll();
    res.status(200).json(tourTypes);
  } catch (error) {
    console.error("Error fetching tour types:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Thêm loại tour
const createTourType = async (req, res) => {
  try {
    const { type_id, type_name } = req.body;
    const image = req.file ? `/assets/tour-type/${req.file.filename}` : null;

    if (!type_id || !type_name)
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc" });

    await TourType.create({ type_id, type_name, image });
    res.status(201).json({ success: true, message: "Thêm loại tour thành công" });
  } catch (error) {
    console.error("Error creating tour type:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Cập nhật loại tour
const updateTourType = async (req, res) => {
  try {
    const { type_id } = req.params;
    const { type_name } = req.body;
    const newImage = req.file ? `/assets/tour-type/${req.file.filename}` : null;

    const oldType = await TourType.findById(type_id);
    if (!oldType) return res.status(404).json({ message: "Không tìm thấy loại tour" });

    if (newImage && oldType.image) {
      const oldImagePath = path.join(__dirname, "..", oldType.image);
      if (fs.existsSync(oldImagePath)) fs.unlinkSync(oldImagePath);
    }

    const updatedImage = newImage || oldType.image;

    const result = await TourType.update(type_id, {
      type_name,
      image: updatedImage,
    });

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    res.status(200).json({ success: true, message: "Cập nhật loại tour thành công" });
  } catch (error) {
    console.error("Error updating tour type:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// Xóa loại tour
const deleteTourType = async (req, res) => {
  try {
    const { type_id } = req.params;

    const tourType = await TourType.findById(type_id);
    if (!tourType)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    if (tourType.image) {
      const imagePath = path.join(__dirname, "..", tourType.image);
      if (fs.existsSync(imagePath)) {
        try {
          fs.unlinkSync(imagePath);
          console.log("Đã xóa ảnh:", imagePath);
        } catch (err) {
          console.error("Không thể xóa ảnh:", err);
        }
      }
    }

    const result = await TourType.delete(type_id);
    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    res.status(200).json({ success: true, message: "Xóa loại tour thành công" });
  } catch (error) {
    console.error("Error deleting tour type:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

module.exports = {
  upload,
  getAllTourTypes,
  createTourType,
  updateTourType,
  deleteTourType,
};
