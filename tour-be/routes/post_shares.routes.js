// routes/post_shares.routes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/post_shares.controller");

router.post("/", controller.sharePost);
router.get("/post/:post_id", controller.getShares);
router.get("/post/:post_id/count", controller.getShareCount);

module.exports = router;





