// routes\tours_type.routes.js

const express = require("express");
const router = express.Router();
const controller = require("../controllers/tours_type.controller");

router.get("/tour_type", controller.getAllTourTypes);
router.post("/tour_type", controller.upload.single("image"), controller.createTourType);
router.put("/tour_type/:type_id", controller.upload.single("image"), controller.updateTourType);
router.delete("/tour_type/:type_id", controller.deleteTourType);

module.exports = router;

