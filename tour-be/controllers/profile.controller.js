// controllers/profile.controller.js
const { updateUserProfile, getUserProfile } = require('../services/profile.service');

const updateProfile = async (req, res) => {
  try {
    const userId = req.user.user_id; // Assuming auth middleware adds user to req
    const userInfo = req.body;

    // Handle avatar and background assets
    if (req.files) {
      if (req.files.avatar) {
        userInfo.avatar = `/assets/avatar/${req.files.avatar[0].filename}`;
      }
      if (req.files.background) {
        userInfo.background = `/assets/background/${req.files.background[0].filename}`;
      }
    }

    // Handle empty dob
    if (userInfo.dob === '') {
      userInfo.dob = null;
    }

    await updateUserProfile(userId, userInfo);
    res.status(200).json({ success: true, message: 'Profile updated successfully' });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

const getProfile = async (req, res) => {
  try {
    const userId = req.user.user_id; // Assuming auth middleware adds user to req
    const profile = await getUserProfile(userId);
    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }
    res.status(200).json(profile);
  } catch (error) {
    console.error('Error getting profile:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

module.exports = { updateProfile, getProfile };
