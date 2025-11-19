// routes/tours.routes.js
const express = require("express");
const router = express.Router();
const ToursController = require("../controllers/tours.controller");

router.get("/", ToursController.getAllTours);
router.post("/", ToursController.createTour);
router.put("/:id", ToursController.updateTour);
router.delete("/:id", ToursController.deleteTour);

module.exports = router;
