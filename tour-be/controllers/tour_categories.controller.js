// controllers/tour_categories.controller.js
const TourCategories = require("../models/tour_categories.model");
const cloudinary = require("../services/cloudinary.service");
const multer = require("multer");

const upload = multer({ dest: "temp/" });

const fs = require("fs");
const path = require("path");

const getAllCategories = async (req, res) => {
  try {
    const categories = await TourCategories.getAll();
    res.status(200).json(categories);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const createCategory = async (req, res) => {
  try {
    const { category_id, categories_name } = req.body;

    if (!category_id || !categories_name)
      return res.status(400).json({ message: "Thiếu dữ liệu" });

    let imageUrl = null;

    if (req.file) {
      const uploadResult = await cloudinary.uploader.upload(req.file.path, {
        folder: "tour-category",
      });

      imageUrl = uploadResult.secure_url;

      fs.unlinkSync(req.file.path); // Xóa file tạm
    }

    await TourCategories.create({
      category_id,
      categories_name,
      image: imageUrl,
    });

    res.status(201).json({ success: true, message: "Thêm thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const updateCategory = async (req, res) => {
  try {
    const { category_id } = req.params;
    const { categories_name } = req.body;

    const oldCategory = await TourCategories.findById(category_id);
    if (!oldCategory)
      return res.status(404).json({ message: "Không tìm thấy" });

    let updatedImage = oldCategory.image;

    if (req.file) {
      const uploadResult = await cloudinary.uploader.upload(req.file.path, {
        folder: "tour-category",
      });

      updatedImage = uploadResult.secure_url;

      fs.unlinkSync(req.file.path);

      // XÓA ẢNH CŨ
      if (oldCategory.image) {
        const publicId = oldCategory.image
          .split("/")
          .slice(-1)[0]
          .split(".")[0];

        await cloudinary.uploader.destroy(`tour-category/${publicId}`);
      }
    }

    await TourCategories.update(category_id, {
      categories_name,
      image: updatedImage,
    });

    res.status(200).json({ success: true, message: "Cập nhật thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const deleteCategory = async (req, res) => {
  try {
    const { category_id } = req.params;

    const category = await TourCategories.findById(category_id);
    if (!category)
      return res.status(404).json({ message: "Không tìm thấy" });

    if (category.image) {
      const publicId = category.image.split("/").slice(-1)[0].split(".")[0];
      await cloudinary.uploader.destroy(`tour-category/${publicId}`);
    }

    await TourCategories.delete(category_id);

    res.status(200).json({ success: true, message: "Xóa thành công" });
  } catch (error) {
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
