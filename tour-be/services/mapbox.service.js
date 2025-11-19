const express = require("express");
const router = express.Router();

router.get("/token", (req, res) => {
  res.json({
    success: true,
    token: process.env.MAPBOX_TOKEN || ""
  });
});

module.exports = router;
