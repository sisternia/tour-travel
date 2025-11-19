// routes\tours_type.routes.js

const express = require("express");
const router = express.Router();
const TourTypeController = require("../controllers/tours_type.controller");

// READ
router.get("/tour_type", TourTypeController.getAllTourTypes);

// CREATE
router.post("/tour_type", TourTypeController.upload.single("image"), TourTypeController.createTourType);

// UPDATE
router.put("/tour_type/:type_id", TourTypeController.upload.single("image"), TourTypeController.updateTourType);

// DELETE
router.delete("/tour_type/:type_id", TourTypeController.deleteTourType);

module.exports = router;
