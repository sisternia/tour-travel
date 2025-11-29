// controllers\tour_guides.controller.js

const fs = require("fs");
const cloudinary = require("../services/cloudinary.service");
const TourGuide = require("../models/tour_guides.model");

const extractPublicId = (url) => {
  if (!url) return null;

  const parts = url.split("/");
  const uploadIndex = parts.indexOf("upload");

  if (uploadIndex === -1) return null;

  const publicPath = parts.slice(uploadIndex + 2).join("/");
  return publicPath.replace(/\.[^/.]+$/, "");
};

const getAllTourGuides = async (req, res) => {
  try {
    const guides = await TourGuide.getAll();
    res.status(200).json(guides);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const createTourGuide = async (req, res) => {
  try {
    let { guide_name, email, phone, birthday, gender, address, language_job } =
      req.body;

    if (!guide_name || !email || !phone) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc" });
    }

    let avatarUrl = null;
    if (req.files?.avatar?.[0]) {
      const file = req.files.avatar[0];
      const uploaded = await cloudinary.uploader.upload(file.path, {
        folder: "tour-guide/avatars",
      });
      avatarUrl = uploaded.secure_url;
      fs.unlinkSync(file.path);
    }

    let certificationUrl = null;
    if (req.files?.certificates?.[0]) {
      const file = req.files.certificates[0];
      const uploaded = await cloudinary.uploader.upload(file.path, {
        folder: "tour-guide/certifications",
      });
      certificationUrl = uploaded.secure_url;
      fs.unlinkSync(file.path);
    }

    const result = await TourGuide.create({
      guide_name,
      email,
      phone,
      birthday: birthday || null,
      gender: gender || null,
      address: address || null,
      language_job: language_job || null, 
      certification: certificationUrl,
      avatar_image: avatarUrl,
    });

    res.status(201).json({
      success: true,
      message: "Thêm hướng dẫn viên thành công",
      guide_id: result.insertId,
    });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const updateTourGuide = async (req, res) => {
  try {
    const { guide_id } = req.params;

    const guides = await TourGuide.getAll();
    const oldData = guides.find((g) => g.guide_id == guide_id);

    if (!oldData)
      return res.status(404).json({ message: "Không tìm thấy hướng dẫn viên" });

    let { guide_name, email, phone, birthday, gender, address, language_job } =
      req.body;

    guide_name = guide_name || oldData.guide_name;
    email = email || oldData.email;
    phone = phone || oldData.phone;
    birthday = birthday || oldData.birthday;
    gender = gender || oldData.gender;
    address = address || oldData.address;
    language_job = language_job || oldData.language_job; 

    let avatarUrl = oldData.avatar_image;
    if (req.files?.avatar?.[0]) {
      const file = req.files.avatar[0];
      const uploaded = await cloudinary.uploader.upload(file.path, {
        folder: "tour-guide/avatars",
      });
      avatarUrl = uploaded.secure_url;
      fs.unlinkSync(file.path);

      const oldId = extractPublicId(oldData.avatar_image);
      if (oldId) await cloudinary.uploader.destroy(oldId);
    }

    let certificationUrl = oldData.certification;
    if (req.files?.certificates?.[0]) {
      const file = req.files.certificates[0];
      const uploaded = await cloudinary.uploader.upload(file.path, {
        folder: "tour-guide/certifications",
      });
      certificationUrl = uploaded.secure_url;
      fs.unlinkSync(file.path);

      const oldId = extractPublicId(oldData.certification);
      if (oldId) await cloudinary.uploader.destroy(oldId);
    }

    await TourGuide.update(guide_id, {
      guide_name,
      email,
      phone,
      birthday,
      gender,
      address,
      language_job,
      avatar_image: avatarUrl,
      certification: certificationUrl,
    });

    res.json({ success: true, message: "Cập nhật hướng dẫn viên thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const deleteTourGuide = async (req, res) => {
  try {
    const { guide_id } = req.params;

    const guides = await TourGuide.getAll();
    const guide = guides.find((g) => g.guide_id == guide_id);

    if (!guide)
      return res.status(404).json({ message: "Không tìm thấy hướng dẫn viên" });

    if (guide.avatar_image) {
      const publicId = extractPublicId(guide.avatar_image);
      if (publicId) await cloudinary.uploader.destroy(publicId);
    }

    if (guide.certification) {
      const publicId = extractPublicId(guide.certification);
      if (publicId) await cloudinary.uploader.destroy(publicId);
    }

    await TourGuide.delete(guide_id);

    res.json({ success: true, message: "Xóa hướng dẫn viên thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const uploadGuideImage = async (req, res) => {
  try {
    const { guide_id } = req.params;

    if (!req.file)
      return res.status(400).json({ message: "Không có ảnh upload" });

    const file = req.file;

    const uploaded = await cloudinary.uploader.upload(file.path, {
      folder: "tour-guide/avatars",
    });

    fs.unlinkSync(file.path);

    const guides = await TourGuide.getAll();
    const guide = guides.find((g) => g.guide_id == guide_id);

    if (guide?.avatar_image) {
      const oldPublicId = extractPublicId(guide.avatar_image);
      if (oldPublicId) await cloudinary.uploader.destroy(oldPublicId);
    }

    await TourGuide.update(guide_id, {
      ...guide,
      avatar_image: uploaded.secure_url,
    });

    res.json({
      success: true,
      message: "Upload avatar thành công",
      url: uploaded.secure_url,
    });
  } catch (err) {
    res.status(500).json({ message: "Lỗi upload", error: err.message });
  }
};

const deleteGuideImage = async (req, res) => {
  try {
    const { guide_id } = req.params;

    const guides = await TourGuide.getAll();
    const guide = guides.find((g) => g.guide_id == guide_id);

    if (!guide)
      return res.status(404).json({ message: "Không tìm thấy hướng dẫn viên" });

    const publicId = extractPublicId(guide.avatar_image);
    if (publicId) await cloudinary.uploader.destroy(publicId);

    await TourGuide.update(guide_id, { ...guide, avatar_image: null });

    res.json({ success: true, message: "Xóa avatar thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi xóa ảnh", error: err.message });
  }
};

const uploadCertification = async (req, res) => {
  try {
    const { guide_id } = req.params;

    if (!req.file)
      return res.status(400).json({ message: "Không có file chứng chỉ" });

    const file = req.file;

    const uploaded = await cloudinary.uploader.upload(file.path, {
      folder: "tour-guide/certifications",
    });

    fs.unlinkSync(file.path);

    const guides = await TourGuide.getAll();
    const guide = guides.find((g) => g.guide_id == guide_id);

    if (guide?.certification) {
      const oldPublicId = extractPublicId(guide.certification);
      if (oldPublicId) await cloudinary.uploader.destroy(oldPublicId);
    }

    await TourGuide.update(guide_id, {
      ...guide,
      certification: uploaded.secure_url,
    });

    res.json({
      success: true,
      message: "Upload chứng chỉ thành công",
      url: uploaded.secure_url,
    });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Lỗi upload chứng chỉ", error: err.message });
  }
};

module.exports = {
  getAllTourGuides,
  createTourGuide,
  updateTourGuide,
  deleteTourGuide,
  uploadGuideImage,
  deleteGuideImage,
  uploadCertification,
};
