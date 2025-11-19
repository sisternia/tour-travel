// routes/profile.routes.js
const express = require('express');
const router = express.Router();
const { getProfile, updateProfile, getAllUserProfiles } = require('../controllers/profile.controller');
const multer = require('multer');

const upload = multer({ dest: "temp/" });

router.get('/', getProfile);

router.put(
  '/',
  upload.fields([
    { name: "avatar", maxCount: 1 },
    { name: "background", maxCount: 1 }
  ]),
  updateProfile
);

router.get('/all', getAllUserProfiles);

module.exports = router;

