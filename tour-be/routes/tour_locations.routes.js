// routes/tour_locations.routes.js
const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/tour_locations.controller");

// GET all
router.get("/", ctrl.getAll);

// GET by tourId
router.get("/:tourId", ctrl.getLocations);

// CRUD
router.post("/", ctrl.createLocation);
router.put("/:id", ctrl.updateLocation);
router.delete("/:id", ctrl.deleteLocation);

module.exports = router;
