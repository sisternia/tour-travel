// controllers/profile.controller.js
const {
  updateUserProfile,
  getUserProfile,
  getAllProfiles
} = require('../services/profile.service');

const cloudinary = require("../services/cloudinary.service");
const fs = require("fs");
const jwt = require('jsonwebtoken');
const NotificationService = require('../services/notification.service');

const getUserFromHeader = (req) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer '))
    throw new Error('Authentication token required');

  const token = authHeader.split(' ')[1];
  return jwt.verify(token, process.env.JWT_SECRET || 'secret');
};

const extractPublicId = (url, folder) => {
  if (!url) return null;

  const filename = url.split("/").slice(-1)[0].split(".")[0];
  return `${folder}/${filename}`;
};

const updateProfile = async (req, res) => {
  try {
    const user = getUserFromHeader(req);
    const userId = user.user_id;

    const userInfo = req.body;
    const old = await getUserProfile(userId);

    if (req.files && req.files.avatar) {
      const file = req.files.avatar[0];

      const uploadResult = await cloudinary.uploader.upload(file.path, {
        folder: "avatar",
      });

      fs.unlinkSync(file.path);

      if (old.avatar) {
        const oldPublicId = extractPublicId(old.avatar, "avatar");
        if (oldPublicId) {
          await cloudinary.uploader.destroy(oldPublicId);
        }
      }

      userInfo.avatar = uploadResult.secure_url;
    }

    if (req.files && req.files.background) {
      const file = req.files.background[0];

      const uploadResult = await cloudinary.uploader.upload(file.path, {
        folder: "background",
      });

      fs.unlinkSync(file.path);

      if (old.background) {
        const oldPublicId = extractPublicId(old.background, "background");
        if (oldPublicId) {
          await cloudinary.uploader.destroy(oldPublicId);
        }
      }

      userInfo.background = uploadResult.secure_url;
    }

    if (userInfo.dob === "") userInfo.dob = null;

    const infoFields = ['phone', 'dob', 'citizen_id', 'address', 'bio'];
    const updatedInfoFields = infoFields.filter((field) => userInfo[field] !== undefined);

    await updateUserProfile(userId, userInfo);

    if (updatedInfoFields.length) {
      await NotificationService.notifyProfileUpdated(userId, updatedInfoFields);
    }

    const refreshed = await getUserProfile(userId);

    res.json({
      success: true,
      data: refreshed
    });

  } catch (err) {
    const status =
      err.message === "Authentication token required" ? 401 : 500;

    res.status(status).json({ message: err.message });
  }
};

const getProfile = async (req, res) => {
  try {
    const user = getUserFromHeader(req);
    const profile = await getUserProfile(user.user_id);
    res.json(profile);
  } catch (err) {
    const status =
      err.message === "Authentication token required" ? 401 : 500;

    res.status(status).json({ message: err.message });
  }
};

const getAllUserProfiles = async (req, res) => {
  const users = await getAllProfiles();
  res.json({ success: true, data: users });
};

module.exports = {
  updateProfile,
  getProfile,
  getAllUserProfiles
};
