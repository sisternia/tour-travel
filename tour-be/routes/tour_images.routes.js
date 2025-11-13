// routes/tour_images.routes.js
const express = require("express");
const router = express.Router();
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const TourImagesController = require("../controllers/tour_images.controller");

const BASE_UPLOAD_DIR = path.join(__dirname, "../assets/tour-images");
if (!fs.existsSync(BASE_UPLOAD_DIR))
  fs.mkdirSync(BASE_UPLOAD_DIR, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const folderName = req.query.folder_name;
    if (!folderName) return cb(new Error("Thiếu folder_name"));
    const uploadDir = path.join(BASE_UPLOAD_DIR, folderName);
    if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const unique = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, unique + path.extname(file.originalname));
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
});

router.get("/folders", TourImagesController.getFolders);
router.post("/folders", TourImagesController.createFolder);
router.post(
  "/upload",
  upload.array("tour_images", 20),
  TourImagesController.uploadImages
);
router.get("/assignments", TourImagesController.getAssignments);
router.post("/assignments", TourImagesController.assignImage);
router.delete("/assignments/:id", TourImagesController.deleteAssignment);

router.get("/first/:tour_id", TourImagesController.getFirstImageByTour);

router.get("/all/:tour_id", TourImagesController.getAllImagesByTour);

module.exports = router;
