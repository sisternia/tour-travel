// services/profile.service.js
const Profile = require('../models/profile.model');
const User = require('../models/auth.model');

const updateUserProfile = async (userId, userInfo) => {
  // Update user_name in users table
  if (userInfo.user_name) {
    await User.update({ user_id: userId, user_name: userInfo.user_name });
  }

  // Update other info in user_infor table
  return await Profile.updateUserInfo(userId, userInfo);
};

const getUserProfile = async (userId) => {
  return await Profile.getUserInfo(userId);
};

module.exports = { updateUserProfile, getUserProfile };
