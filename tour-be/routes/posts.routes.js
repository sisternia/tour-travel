// routes/posts.routes.js

const express = require("express");
const router = express.Router();
const controller = require("../controllers/posts.controller");

router.get("/", controller.getAllPosts);

router.post(
  "/",
  controller.upload.array("images", 10),
  controller.createPost
);

router.put(
  "/:post_id",
  controller.upload.array("images", 10),
  controller.updatePost
);

router.delete("/:post_id", controller.deletePost);
router.get("/user/:user_id", controller.getPostsByUserId);

module.exports = router;
