// routes/profile.routes.js
const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { getProfile, updateProfile } = require('../controllers/profile.controller');
const multer = require('multer');

// Configure multer for avatar and background assets
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (file.fieldname === 'avatar') {
      cb(null, 'assets/avatar');
    } else if (file.fieldname === 'background') {
      cb(null, 'assets/background');
    }
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + '-' + uniqueSuffix + '.' + file.originalname.split('.').pop());
  }
});

const upload = multer({ storage: storage });

// Get user profile
router.get('/', authMiddleware, getProfile);

// Update user profile
router.put('/', authMiddleware, upload.fields([{ name: 'avatar', maxCount: 1 }, { name: 'background', maxCount: 1 }]), updateProfile);

module.exports = router;
