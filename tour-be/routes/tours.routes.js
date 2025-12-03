const express = require("express");
const router = express.Router();
const ToursController = require("../controllers/tours.controller");
const RatingController = require("../controllers/rating.controller");

router.get("/", ToursController.getAllTours);
router.get("/latest", ToursController.getLatestWithPrices);

router.post("/:id/rating", RatingController.addRating);
router.get("/:id/rating", RatingController.getRatings);

router.get("/:id", ToursController.getTourById);
router.post("/", ToursController.createTour);
router.put("/:id", ToursController.updateTour);
router.delete("/:id", ToursController.deleteTour);

module.exports = router;
