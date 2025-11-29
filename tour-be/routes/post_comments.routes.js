// routes/post_comments.routes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/post_comments.controller");

router.post("/", controller.addComment);
router.get("/post/:post_id", controller.getComments);
router.get("/post/:post_id/count", controller.getCommentCount);
router.put("/:comment_id", controller.updateComment);
router.delete("/:comment_id", controller.deleteComment);

module.exports = router;





