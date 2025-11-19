// routes/profile.routes.js
const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth.middleware');
const { getProfile, updateProfile, getAllUserProfiles } = require('../controllers/profile.controller');
const multer = require('multer');

const upload = multer({ dest: "temp/" });

router.get('/', auth, getProfile);

router.put(
  '/',
  auth,
  upload.fields([
    { name: "avatar", maxCount: 1 },
    { name: "background", maxCount: 1 }
  ]),
  updateProfile
);

router.get('/all', getAllUserProfiles);

module.exports = router;

