const express = require("express");
const router = express.Router();
const controller = require("../controllers/tour_guide_assignment.controller");

router.post("/", controller.assignGuide);
router.get("/:tour_id", controller.getGuidesByTour);
router.delete("/:id", controller.deleteAssignment);

module.exports = router;
