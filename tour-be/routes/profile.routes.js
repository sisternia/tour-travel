// routes/profile.routes.js
const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { getProfile, updateProfile, getAllUserProfiles } = require('../controllers/profile.controller');
const multer = require('multer');

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (file.fieldname === 'avatar') cb(null, 'assets/avatar');
    else if (file.fieldname === 'background') cb(null, 'assets/background');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + '-' + uniqueSuffix + '.' + file.originalname.split('.').pop());
  }
});
const upload = multer({ storage });

// Profile cá nhân
router.get('/', authMiddleware, getProfile);
router.put('/', authMiddleware, upload.fields([{ name: 'avatar', maxCount: 1 }, { name: 'background', maxCount: 1 }]), updateProfile);

// 🆕 Route admin (không cần auth nếu dashboard nội bộ)
router.get('/all', getAllUserProfiles);

module.exports = router;
