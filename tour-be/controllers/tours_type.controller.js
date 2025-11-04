const TourType = require("../models/tours_type.model");
const multer = require("multer");
const path = require("path");

// === MULTER CONFIG ===
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

// === CONTROLLER FUNCTIONS ===
const getAllTourTypes = async (req, res) => {
  try {
    const tourTypes = await TourType.getAll();
    res.status(200).json(tourTypes);
  } catch (error) {
    console.error("Error fetching tour types:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

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

const updateTourType = async (req, res) => {
  try {
    const { type_id } = req.params;
    const { type_name } = req.body;
    const image = req.file ? `/assets/tour-type/${req.file.filename}` : req.body.image || null;

    const result = await TourType.update(type_id, { type_name, image });
    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    res.status(200).json({ success: true, message: "Cập nhật loại tour thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const deleteTourType = async (req, res) => {
  try {
    const { type_id } = req.params;
    const result = await TourType.delete(type_id);
    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    res.status(200).json({ success: true, message: "Xóa loại tour thành công" });
  } catch (error) {
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
