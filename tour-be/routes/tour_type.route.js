const express = require("express");
const router = express.Router();
const TourTypeController = require("../controllers/tour_type.controller");

// GET all tour types
router.get("/tour_type", TourTypeController.getAllTourTypes);

// GET a tour type by its ID
router.get("/tour_type/:type_id", TourTypeController.getTourTypeById);

// GET a tour type by its name
router.get("/tour_type/name/:type_name", TourTypeController.getTourTypeByName);

module.exports = router;
