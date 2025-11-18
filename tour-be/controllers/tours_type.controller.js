// controllers\tours_type.controller.js

const TourType = require("../models/tours_type.model");
const cloudinary = require("../services/cloudinary.service");
const multer = require("multer");
const fs = require("fs");

const upload = multer({ dest: "temp/" });

const getAllTourTypes = async (req, res) => {
  try {
    const tourTypes = await TourType.getAll();
    res.status(200).json(tourTypes);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const createTourType = async (req, res) => {
  try {
    const { type_id, type_name } = req.body;

    if (!type_id || !type_name)
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc" });

    let imageUrl = null;

    if (req.file) {
      const uploaded = await cloudinary.uploader.upload(req.file.path, {
        folder: "tour-type",
      });

      imageUrl = uploaded.secure_url;
      fs.unlinkSync(req.file.path);
    }

    await TourType.create({ type_id, type_name, image: imageUrl });
    res.status(201).json({ success: true, message: "Thêm loại tour thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const updateTourType = async (req, res) => {
  try {
    const { type_id } = req.params;
    const { type_name } = req.body;

    const oldType = await TourType.findById(type_id);
    if (!oldType) return res.status(404).json({ message: "Không tìm thấy loại tour" });

    let newImage = oldType.image;

    if (req.file) {
      const uploaded = await cloudinary.uploader.upload(req.file.path, {
        folder: "tour-type",
      });

      newImage = uploaded.secure_url;
      fs.unlinkSync(req.file.path);

      if (oldType.image) {
        const publicId = oldType.image.split("/").pop().split(".")[0];
        await cloudinary.uploader.destroy(`tour-type/${publicId}`);
      }
    }

    const result = await TourType.update(type_id, {
      type_name,
      image: newImage,
    });

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

    const tourType = await TourType.findById(type_id);
    if (!tourType) return res.status(404).json({ message: "Không tìm thấy loại tour" });

    if (tourType.image) {
      const publicId = tourType.image.split("/").pop().split(".")[0];
      await cloudinary.uploader.destroy(`tour-type/${publicId}`);
    }

    await TourType.delete(type_id);
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
