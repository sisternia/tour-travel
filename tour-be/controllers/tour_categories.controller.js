// controllers/tour_categories.controller.js
const fs = require("fs");
const path = require("path");
const multer = require("multer");
const TourCategories = require("../models/tour_categories.model");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "assets/tour-category/");
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    const fileName = Date.now() + ext;
    cb(null, fileName);
  },
});
const upload = multer({ storage });

const getAllCategories = async (req, res) => {
  try {
    const categories = await TourCategories.getAll();
    res.status(200).json(categories);
  } catch (error) {
    console.error("Error fetching categories:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const createCategory = async (req, res) => {
  try {
    const { category_id, categories_name } = req.body;
    const image = req.file ? `/assets/tour-category/${req.file.filename}` : null;

    if (!category_id || !categories_name)
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc" });

    await TourCategories.create({ category_id, categories_name, image });
    res.status(201).json({ success: true, message: "Thêm loại tour thành công" });
  } catch (error) {
    console.error("Error creating category:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const updateCategory = async (req, res) => {
  try {
    const { category_id } = req.params;
    const { categories_name } = req.body;
    const newImage = req.file ? `/assets/tour-category/${req.file.filename}` : null;

    const oldCategory = await TourCategories.findById(category_id);
    if (!oldCategory)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    if (newImage && oldCategory.image) {
      const oldImagePath = path.join(__dirname, "..", oldCategory.image);
      if (fs.existsSync(oldImagePath)) fs.unlinkSync(oldImagePath);
    }

    const updatedImage = newImage || oldCategory.image;

    const result = await TourCategories.update(category_id, {
      categories_name,
      image: updatedImage,
    });

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    res.status(200).json({ success: true, message: "Cập nhật thành công" });
  } catch (error) {
    console.error("Error updating category:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const deleteCategory = async (req, res) => {
  try {
    const { category_id } = req.params;

    const category = await TourCategories.findById(category_id);
    if (!category)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    if (category.image) {
      const imagePath = path.join(__dirname, "..", category.image);
      if (fs.existsSync(imagePath)) fs.unlinkSync(imagePath);
    }

    const result = await TourCategories.delete(category_id);
    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy loại tour" });

    res.status(200).json({ success: true, message: "Xóa loại tour thành công" });
  } catch (error) {
    console.error("Error deleting category:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

module.exports = {
  upload,
  getAllCategories,
  createCategory,
  updateCategory,
  deleteCategory,
};
