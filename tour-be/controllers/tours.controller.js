const Tour = require("../models/tour.model");
const { body, validationResult } = require("express-validator");

exports.validateTour = [
  body("name").notEmpty().withMessage("Name is required"),
  body("price_adult")
    .isFloat({ gt: 0 })
    .withMessage("Price for adult must be a positive number"),
  body("price_child")
    .optional()
    .isFloat({ min: 0 })
    .withMessage("Price for child must be >= 0"),
  body("start_date").isDate().withMessage("Start date must be a valid date"),
  body("end_date").isDate().withMessage("End date must be a valid date"),
  body("number_of_people")
    .optional()
    .isInt({ gt: 0 })
    .withMessage("Number of people must be a positive integer"),
];

// Middleware check error
const handleValidationErrors = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      errors: errors.array(),
    });
  }
};
// Tạo tour mới
exports.createTour = async (req, res) => {
  try {
    const result = await Tour.create(req.body);
    res
      .status(201)
      .json({ message: "Tour created successfully", id: result.insertId });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error creating tour", error: error.message });
  }
};

// Lấy tất cả tour
exports.getAllTours = async (req, res) => {
  try {
    const tours = await Tour.findAll();
    res.status(200).json(tours);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error fetching tours", error: error.message });
  }
};

// Lấy tour theo id
exports.getTourById = async (req, res) => {
  try {
    const tour = await Tour.findById(req.params.id);
    if (!tour) {
      return res.status(404).json({ message: "Tour not found" });
    }
    res.status(200).json(tour);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error fetching tour", error: error.message });
  }
};

// Cập nhật tour
exports.updateTour = async (req, res) => {
  try {
    const result = await Tour.update(req.params.id, req.body);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Tour not found" });
    }
    res.status(200).json({ message: "Tour updated successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error updating tour", error: error.message });
  }
};

// Xóa tour
exports.deleteTour = async (req, res) => {
  try {
    const result = await Tour.delete(req.params.id);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Tour not found" });
    }
    res.status(200).json({ message: "Tour deleted successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error deleting tour", error: error.message });
  }
  if (!req.body.name || !req.body.price_adult) {
    return res.status(400).json({ message: "Missing required fields" });
  }
};
// Lấy tour mới nhất
exports.getLatestTours = async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 5; // client có thể gửi ?limit=8
    const tours = await Tour.findLatest(limit);
    res.status(200).json(tours);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error fetching latest tours", error: error.message });
  }
};
