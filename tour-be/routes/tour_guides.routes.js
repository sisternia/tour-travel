// routes/tour_guide.routes.js
const express = require("express");
const router = express.Router();
const multer = require("multer");

const TourGuideController = require("../controllers/tour_guides.controller");

const upload = multer({ dest: "temp/tour_guides/" });

router.get("/", TourGuideController.getAllTourGuides);

router.post(
  "/",
  upload.fields([
    { name: "avatar", maxCount: 1 },
    { name: "certificates", maxCount: 10 },
  ]),
  TourGuideController.createTourGuide
);

router.put(
  "/:guide_id",
  upload.fields([
    { name: "avatar", maxCount: 1 },
    { name: "certificates", maxCount: 10 },
  ]),
  TourGuideController.updateTourGuide
);

router.delete("/:guide_id", TourGuideController.deleteTourGuide);

router.post(
  "/:guide_id/image/upload",
  upload.single("guide_image"),
  TourGuideController.uploadGuideImage
);

router.delete("/:guide_id/image", TourGuideController.deleteGuideImage);

module.exports = router;
