// controllers/profile.controller.js
const { updateUserProfile, getUserProfile, getAllProfiles } = require('../services/profile.service');
const cloudinary = require("../services/cloudinary.service");
const fs = require("fs");
const jwt = require('jsonwebtoken');

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

const getUserFromHeader = (req) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('Authentication token required');
  }

  const token = authHeader.split(' ')[1];
  return jwt.verify(token, process.env.JWT_SECRET || 'secret');
};

const updateProfile = async (req, res) => {
  try {
    const user = getUserFromHeader(req);
    const userId = user.user_id;
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

    // await updateUserProfile(userId, userInfo);
    // res.json({ success: true });
      await updateUserProfile(userId, userInfo);
      const updatedProfile = await getUserProfile(userId);
      res.json({ success: true, data: updatedProfile });
  } catch (err) {
    const status = err.message === 'Authentication token required' ? 401 : 500;
    res.status(status).json({ message: err.message });
  }
};

const getProfile = async (req, res) => {
  try {
    const user = getUserFromHeader(req);
    const profile = await getUserProfile(user.user_id);
    res.json(profile);
  } catch (err) {
    const status = err.message === 'Authentication token required' ? 401 : 500;
    res.status(status).json({ message: err.message });
  }
};

const getAllUserProfiles = async (req, res) => {
  const users = await getAllProfiles();
  res.json({ success: true, data: users });
};

module.exports = { updateProfile, getProfile, getAllUserProfiles };
