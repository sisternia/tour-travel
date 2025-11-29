// controllers/posts.controller.js

const Post = require("../models/post.model");
const PostImages = require("../models/post_images.model");
const cloudinary = require("../services/cloudinary.service");
const multer = require("multer");
const crypto = require("crypto");
const streamifier = require("streamifier");

const upload = multer({ storage: multer.memoryStorage() });

const uploadToCloudinary = (buffer, folder) => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder },
      (err, result) => {
        if (err) return reject(err);
        resolve(result);
      }
    );
    streamifier.createReadStream(buffer).pipe(stream);
  });
};

const createPost = async (req, res) => {
  try {
    const generatedPostId = "POST_" + crypto.randomUUID();   
    const { user_id, user_name, content, privacy } = req.body;

    await Post.create({
      post_id: generatedPostId,
      user_id,
      content,
      privacy: privacy || "public"
    });

    const files = req.files || [];
    const uploadedImages = [];

    for (const file of files) {
      const result = await uploadToCloudinary(
        file.buffer,
        `posts/${user_name}`
      );

      const imgId = "IMG_" + crypto.randomBytes(8).toString("hex");

      await PostImages.create({
        image_id: imgId,
        post_id: generatedPostId,
        image_url: result.secure_url
      });

      uploadedImages.push(result.secure_url);
    }

    res.status(201).json({
      success: true,
      message: "Đăng bài thành công",
      post_id: generatedPostId,     
      images: uploadedImages
    });

  } catch (error) {
    console.error("🔥 CREATE POST ERROR:", error);
    res.status(500).json({
      message: "Lỗi server",
      error: error.message,
      stack: error.stack
    });
  }
};

const updatePost = async (req, res) => {
  try {
    const { post_id } = req.params;
    const { user_name, content, privacy } = req.body;

    const oldPost = await Post.findById(post_id);
    if (!oldPost) return res.status(404).json({ message: "Không tìm thấy bài viết" });

    await Post.update(post_id, { content, privacy });

    // Nếu không có ảnh mới → giữ ảnh cũ
    if (!req.files || req.files.length === 0) {
      return res.status(200).json({ success: true, message: "Cập nhật bài viết thành công" });
    }

    // Xóa ảnh cũ trên Cloudinary
    const oldImages = await PostImages.getByPostId(post_id);
    for (let img of oldImages) {
      const publicId = img.image_url.split("/").pop().split(".")[0];
      await cloudinary.uploader.destroy(`posts/${user_name}/${publicId}`);
    }

    await PostImages.deleteByPost(post_id);

    // Upload ảnh mới
    for (const file of req.files) {
      const result = await uploadToCloudinary(
        file.buffer,
        `posts/${user_name}`
      );

      await PostImages.create({
        image_id: `IMG${Date.now()}`,
        post_id,
        image_url: result.secure_url
      });
    }

    res.status(200).json({ success: true, message: "Cập nhật bài viết thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const deletePost = async (req, res) => {
  try {
    const { post_id } = req.params;
    const { user_name } = req.body;

    const images = await PostImages.getByPostId(post_id);

    for (let img of images) {
      const publicId = img.image_url.split("/").pop().split(".")[0];
      await cloudinary.uploader.destroy(`posts/${user_name}/${publicId}`);
    }

    await PostImages.deleteByPost(post_id);
    await Post.delete(post_id);

    res.status(200).json({ success: true, message: "Xóa bài viết thành công" });
  } catch (err) {
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const getAllPosts = async (req, res) => {
  try {
    const posts = await Post.getAll();

    const fullPosts = [];

    for (const post of posts) {
      const images = await PostImages.getByPostId(post.post_id);

      fullPosts.push({
        ...post,
        images: images.map(img => ({
          image_id: img.image_id,
          image_url: img.image_url
        }))
      });
    }

    res.status(200).json(fullPosts);

  } catch (err) {
    res.status(500).json({
      message: "Lỗi server",
      error: err.message,
    });
  }
};

const getPostsByUserId = async (req, res) => {
  try {
    const { user_id } = req.params;
    const posts = await Post.getByUserId(user_id);

    const fullPosts = [];

    for (const post of posts) {
      const images = await PostImages.getByPostId(post.post_id);

      fullPosts.push({
        ...post,
        images: images.map(img => ({
          image_id: img.image_id,
          image_url: img.image_url
        }))
      });
    }

    res.status(200).json(fullPosts);

  } catch (err) {
    res.status(500).json({
      message: "Lỗi server",
      error: err.message,
    });
  }
};

module.exports = {
  upload,
  createPost,
  updatePost,
  deletePost,
  getAllPosts,
  getPostsByUserId
};
