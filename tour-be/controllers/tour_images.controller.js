// controllers/tour_images.controller.js
const fs = require("fs");
const path = require("path");
const {
  TourImageFolders,
  TourImages,
  TourImageAssignment,
} = require("../models/tour_images.model");

const BASE_DIR = path.join(__dirname, "../assets/tour-images");

const TourImagesController = {
  async getFolders(req, res) {
    try {
      const folders = await TourImageFolders.getAllWithImages();
      res.json(folders);
    } catch (err) {
      console.error("Lỗi khi lấy danh sách thư mục:", err);
      res.status(500).json({ message: "Lỗi khi tải danh sách thư mục" });
    }
  },

  async createFolder(req, res) {
    try {
      const { folder_name } = req.body;
      if (!folder_name)
        return res.status(400).json({ message: "Thiếu tên thư mục" });

      const folderPath = path.join(BASE_DIR, folder_name);
      if (!fs.existsSync(folderPath))
        fs.mkdirSync(folderPath, { recursive: true });

      await TourImageFolders.create(folder_name);
      res.json({ success: true, message: "Tạo thư mục thành công" });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: "Lỗi khi tạo thư mục" });
    }
  },

  async uploadImages(req, res) {
    try {
      const { folder_id } = req.body;
      const folder_name = req.query.folder_name;
      const files = req.files;

      if (!folder_id || !folder_name)
        return res.status(400).json({ message: "Thiếu dữ liệu thư mục" });

      if (!files?.length)
        return res.status(400).json({ message: "Không có ảnh nào được tải lên" });

      const paths = files.map(
        (f) => `/assets/tour-images/${folder_name}/${f.filename}`
      );
      await TourImages.addImages(folder_id, paths);
      res.json({
        success: true,
        message: `Tải ${files.length} ảnh vào thư mục '${folder_name}' thành công`,
      });
    } catch (err) {
      console.error("Lỗi upload ảnh:", err);
      res.status(500).json({ message: "Lỗi khi tải ảnh" });
    }
  },

  async getAssignments(req, res) {
    const data = await TourImageAssignment.getAll();
    res.json(data);
  },

  async assignImage(req, res) {
    try {
      const { tour_id, tour_img_id } = req.body;
      if (!tour_id || !tour_img_id)
        return res.status(400).json({ message: "Thiếu dữ liệu" });

      await TourImageAssignment.create(tour_id, tour_img_id);
      res.json({ success: true, message: "Gán ảnh thành công" });
    } catch (err) {
      console.error("Lỗi gán ảnh:", err);
      res.status(500).json({ message: "Không thể gán ảnh (ảnh không tồn tại)" });
    }
  },

  async deleteAssignment(req, res) {
    const { id } = req.params;
    await TourImageAssignment.delete(id);
    res.json({ success: true, message: "Hủy gán thành công" });
  },

  async getFirstImageByTour(req, res) {
    try {
      const { tour_id } = req.params;
      if (!tour_id)
        return res.status(400).json({ message: "Thiếu tour_id" });

      const image = await TourImages.getFirstByTourId(tour_id);
      if (!image)
        return res.status(404).json({ message: "Chưa có ảnh cho tour này" });

      res.json(image);
    } catch (err) {
      console.error("Lỗi lấy ảnh đầu tiên:", err);
      res.status(500).json({ message: "Lỗi khi lấy ảnh đầu tiên" });
    }
  },

  async getAllImagesByTour(req, res) {
    try {
      const { tour_id } = req.params;
      if (!tour_id) return res.status(400).json({ message: "Thiếu tour_id" });
  
      const list = await TourImages.getAllByTourId(tour_id);
      res.json(list);
    } catch (err) {
      console.error("Lỗi tải tất cả ảnh:", err);
      res.status(500).json({ message: "Không thể tải danh sách ảnh" });
    }
  }  
};

module.exports = TourImagesController;
