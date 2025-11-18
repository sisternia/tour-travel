// 📁 routes/tour_categories.routes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/tour_categories.controller");

router.get("/", controller.getAllCategories);

router.post("/", controller.upload.single("image"), controller.createCategory);

router.put(
  "/:category_id",
  controller.upload.single("image"),
  controller.updateCategory
);

router.delete("/:category_id", controller.deleteCategory);

module.exports = router;

