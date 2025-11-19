// controllers/tour_images.controller.js
const fs = require("fs");
const cloudinary = require("../services/cloudinary.service");
const {
  TourImageFolders,
  TourImages,
  TourImageAssignment,
} = require("../models/tour_images.model");

const extractPublicId = (url) => {
  if (!url) return null;
  const parts = url.split("/");
  const file = parts.pop();
  const versionIndex = parts.findIndex((p) => p === "upload");
  if (versionIndex === -1) return null;
  const publicPath = parts.slice(versionIndex + 1).join("/") + "/" + file.split(".")[0];
  return publicPath;
};

const TourImagesController = {
  async getFolders(req, res) {
    try {
      const folders = await TourImageFolders.getAllWithImages();
      res.json(folders);
    } catch (err) {
      res.status(500).json({ message: "Lỗi khi lấy danh sách thư mục" });
    }
  },

  async createFolder(req, res) {
    try {
      const { folder_name } = req.body;
      if (!folder_name) return res.status(400).json({ message: "Thiếu tên thư mục" });
      await TourImageFolders.create(folder_name);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ message: "Lỗi khi tạo thư mục" });
    }
  },

  async uploadImages(req, res) {
    try {
      const { folder_id } = req.body;
      const folder_name = req.query.folder_name;
      const files = req.files;

      if (!folder_id || !folder_name) return res.status(400).json({ message: "Thiếu dữ liệu" });
      if (!files?.length) return res.status(400).json({ message: "Không có ảnh" });

      const urls = [];

      for (const file of files) {
        const uploaded = await cloudinary.uploader.upload(file.path, {
          folder: `tour-images/${folder_name}`,
        });
        urls.push(uploaded.secure_url);
        try { fs.unlinkSync(file.path); } catch (e) { /* ignore */ }
      }

      await TourImages.addImages(folder_id, urls);
      res.json({ success: true, uploaded: urls.length, urls });
    } catch (err) {
      res.status(500).json({ message: "Lỗi upload", error: err.message });
    }
  },

  async getAssignments(req, res) {
    try {
      const data = await TourImageAssignment.getAll();
      res.json(data);
    } catch (err) {
      res.status(500).json({ message: "Lỗi" });
    }
  },

  async assignImage(req, res) {
    try {
      const { tour_id, tour_img_id } = req.body;
      if (!tour_id || !tour_img_id) return res.status(400).json({ message: "Thiếu dữ liệu" });
      await TourImageAssignment.create(tour_id, tour_img_id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ message: "Không thể gán ảnh (ảnh không tồn tại)" });
    }
  },

  async deleteAssignment(req, res) {
    try {
      const { id } = req.params;
      await TourImageAssignment.delete(id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ message: "Lỗi hủy gán" });
    }
  },

  async deleteImage(req, res) {
    try {
      const { id } = req.params;
      const img = await TourImages.findById(id);
      if (!img) return res.status(404).json({ message: "Không tồn tại" });

      const publicId = extractPublicId(img.tour_img);
      if (publicId) await cloudinary.uploader.destroy(publicId);

      await TourImages.delete(id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ message: "Lỗi xóa ảnh" });
    }
  },

  async deleteFolder(req, res) {
    try {
      const { folder_id } = req.params;
      const images = await TourImages.getByFolder(folder_id);
      for (const img of images) {
        const publicId = extractPublicId(img.tour_img);
        if (publicId) await cloudinary.uploader.destroy(publicId);
      }
      await TourImageFolders.delete(folder_id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ message: "Lỗi xóa folder" });
    }
  },

  async getFirstImageByTour(req, res) {
    try {
      const { tour_id } = req.params;
      if (!tour_id) return res.status(400).json({ message: "Thiếu tour_id" });
      const image = await TourImages.getFirstByTourId(tour_id);
      if (!image) return res.status(404).json({ message: "Không có ảnh" });
      res.json(image);
    } catch (err) {
      res.status(500).json({ message: "Lỗi lấy ảnh" });
    }
  },

  async getAllImagesByTour(req, res) {
    try {
      const { tour_id } = req.params;
      if (!tour_id) return res.status(400).json({ message: "Thiếu tour_id" });
      const list = await TourImages.getAllByTourId(tour_id);
      res.json(list);
    } catch (err) {
      res.status(500).json({ message: "Không thể tải danh sách ảnh" });
    }
  },
};

module.exports = TourImagesController;

