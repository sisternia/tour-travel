// routes/tour_images.routes.js
const express = require("express");
const router = express.Router();
const multer = require("multer");
const TourImagesController = require("../controllers/tour_images.controller");

const upload = multer({ dest: "temp/" });

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

router.delete("/image/:id", TourImagesController.deleteImage);
router.delete("/folder/:folder_id", TourImagesController.deleteFolder);

router.get("/first/:tour_id", TourImagesController.getFirstImageByTour);
router.get("/all/:tour_id", TourImagesController.getAllImagesByTour);

module.exports = router;
