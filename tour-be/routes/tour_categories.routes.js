// 📁 routes/tour_categories.routes.js
const express = require("express");
const router = express.Router();
const TourCategoriesController = require("../controllers/tour_categories.controller");

router.get("/", TourCategoriesController.getAllCategories);
router.post(
  "/",
  TourCategoriesController.upload.single("image"),
  TourCategoriesController.createCategory
);
router.put(
  "/:category_id",
  TourCategoriesController.upload.single("image"),
  TourCategoriesController.updateCategory
);
router.delete("/:category_id", TourCategoriesController.deleteCategory);

module.exports = router;
