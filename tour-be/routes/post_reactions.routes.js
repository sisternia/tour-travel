// routes/post_reactions.routes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/post_reactions.controller");

router.post("/", controller.addReaction);
router.delete("/", controller.removeReaction);
router.get("/post/:post_id", controller.getReactions);
router.get("/user/:user_id/post/:post_id", controller.getUserReaction);

module.exports = router;





