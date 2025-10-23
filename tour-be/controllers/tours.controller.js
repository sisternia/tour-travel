const Tour = require("../models/tours.model");
const { body, validationResult } = require("express-validator");

const validateTour = [
  body("name").notEmpty().withMessage("Thiếu tên tour"),
  body("price_adult")
    .isFloat({ gt: 0 })
    .withMessage("Giá người lớn phải là số dương"),
  body("price_child")
    .optional()
    .isFloat({ min: 0 })
    .withMessage("Giá trẻ em phải >= 0"),
  body("start_date").isDate().withMessage("Ngày bắt đầu không hợp lệ"),
  body("end_date").isDate().withMessage("Ngày kết thúc không hợp lệ"),
  body("number_of_people")
    .optional()
    .isInt({ gt: 0 })
    .withMessage("Số lượng người phải là số nguyên dương"),
];

// Middleware xử lý lỗi validation
const handleValidationErrors = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: "Dữ liệu không hợp lệ",
      errors: errors.array(),
    });
  }
};  

// Tạo tour mới
const createTour = async (req, res) => {
  try {
    handleValidationErrors(req, res);

    const { name, price_adult } = req.body;
    if (!name || !price_adult) {
      return res.status(400).json({ message: "Thiếu trường bắt buộc" });
    }

    const result = await Tour.create(req.body);

    res.status(201).json({
      success: true,
      message: "Tạo tour thành công",
      data: { id: result.insertId },
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server khi tạo tour", error: error.message });
  }
};

// Lấy tất cả tour
const getAllTours = async (req, res) => {
  try {
    const tours = await Tour.findAll();
    return res.status(200).json(tours); // ✅ chỉ trả về mảng
  } catch (error) {
    console.error("Error fetching tours:", error);
    res.status(500).json({ message: "Lỗi server khi lấy danh sách tour" });
  }
};

// Lấy tour theo ID
const getTourById = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) return res.status(400).json({ message: "Thiếu ID tour" });

    const tour = await Tour.findById(id);
    if (!tour) return res.status(404).json({ message: "Không tìm thấy tour" });

    res.status(200).json({
      success: true,
      message: "Lấy tour theo ID thành công",
      data: tour,
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server khi lấy tour", error: error.message });
  }
};

// Cập nhật tour
const updateTour = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) return res.status(400).json({ message: "Thiếu ID tour" });

    const result = await Tour.update(id, req.body);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy tour cần cập nhật" });
    }

    res.status(200).json({
      success: true,
      message: "Cập nhật tour thành công",
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server khi cập nhật tour", error: error.message });
  }
};

// Xóa tour
const deleteTour = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) return res.status(400).json({ message: "Thiếu ID tour" });

    const result = await Tour.delete(id);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy tour cần xóa" });
    }

    res.status(200).json({
      success: true,
      message: "Xóa tour thành công",
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server khi xóa tour", error: error.message });
  }
};

// Lấy tour mới nhất
const getLatestTours = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 5;
    const tours = await Tour.findLatest(limit);

    if (!tours || tours.length === 0) {
      return res.status(404).json({ message: "Không có tour mới nào" });
    }

    res.status(200).json({
      success: true,
      message: "Lấy tour mới nhất thành công",
      data: tours,
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server khi lấy tour mới nhất", error: error.message });
  }
};

module.exports = {
  validateTour,
  createTour,
  getAllTours,
  getTourById,
  updateTour,
  deleteTour,
  getLatestTours,
};
