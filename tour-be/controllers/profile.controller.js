// controllers/profile.controller.js
const { updateUserProfile, getUserProfile, getAllProfiles } = require('../services/profile.service');
const cloudinary = require("../services/cloudinary.service");
const fs = require("fs");

const extractPublicId = (url) => {
  if (!url) return null;
  const parts = url.split("/");
  const file = parts.pop();
  const idx = parts.indexOf("upload");
  return `${parts.slice(idx + 1).join("/")}/${file.split(".")[0]}`;
};

const uploadToCloudinary = async (file, folder) => {
  const uploaded = await cloudinary.uploader.upload(file.path, { folder });
  fs.unlinkSync(file.path);
  return uploaded.secure_url;
};

const updateProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const userInfo = req.body;

    const old = await getUserProfile(userId);

    if (req.files) {
      if (req.files.avatar) {
        const url = await uploadToCloudinary(req.files.avatar[0], "avatar");
        const oldId = extractPublicId(old.avatar);
        if (oldId) cloudinary.uploader.destroy(oldId);
        userInfo.avatar = url;
      }

      if (req.files.background) {
        const url = await uploadToCloudinary(req.files.background[0], "background");
        const oldId = extractPublicId(old.background);
        if (oldId) cloudinary.uploader.destroy(oldId);
        userInfo.background = url;
      }
    }

    if (userInfo.dob === '') userInfo.dob = null;

    await updateUserProfile(userId, userInfo);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getProfile = async (req, res) => {
  const userId = req.user.user_id;
  const profile = await getUserProfile(userId);
  res.json(profile);
};

const getAllUserProfiles = async (req, res) => {
  const users = await getAllProfiles();
  res.json({ success: true, data: users });
};

module.exports = { updateProfile, getProfile, getAllUserProfiles };
