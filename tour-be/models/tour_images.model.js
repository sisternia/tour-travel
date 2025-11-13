// models/tour_images.model.js
const pool = require("../config/db");

const TourImageFolders = {
  async getAllWithImages() {
    const [rows] = await pool.query(`
      SELECT 
        f.folder_id, 
        f.folder_name,
        COALESCE(
          GROUP_CONCAT(
            CONCAT(i.tour_img_id, ':', i.tour_img) SEPARATOR '|'
          ), 
          ''
        ) AS images
      FROM tour_image_folders f
      LEFT JOIN tour_images i ON f.folder_id = i.folder_id
      GROUP BY f.folder_id
      ORDER BY f.folder_id DESC
    `);

    return rows.map(r => ({
      folder_id: r.folder_id,
      folder_name: r.folder_name,
      images: r.images
        ? r.images.split("|").filter(Boolean).map(i => {
            const [id, path] = i.split(":");
            return { tour_img_id: Number(id), tour_img: path };
          })
        : []
    }));
  },

  async create(folder_name) {
    const [res] = await pool.query(
      "INSERT INTO tour_image_folders (folder_name) VALUES (?)",
      [folder_name]
    );
    return res.insertId;
  },

  async delete(id) {
    await pool.query("DELETE FROM tour_image_folders WHERE folder_id = ?", [id]);
  },
};

const TourImages = {
  async addImages(folder_id, paths) {
    for (const p of paths) {
      await pool.query(
        "INSERT INTO tour_images (folder_id, tour_img) VALUES (?, ?)",
        [folder_id, p]
      );
    }
  },
  async delete(id) {
    await pool.query("DELETE FROM tour_images WHERE tour_img_id = ?", [id]);
  },
  async getFirstByTourId(tour_id) {
    const [rows] = await pool.query(`
      SELECT i.tour_img
      FROM tour_image_assignment a
      JOIN tour_images i ON a.tour_img_id = i.tour_img_id
      WHERE a.tour_id = ?
      ORDER BY a.id ASC
      LIMIT 1
    `, [tour_id]);
    return rows[0] || null;
  },
  async getAllByTourId(tour_id) {
    const [rows] = await pool.query(`
      SELECT i.tour_img_id, i.tour_img
      FROM tour_image_assignment a
      JOIN tour_images i ON a.tour_img_id = i.tour_img_id
      WHERE a.tour_id = ?
      ORDER BY a.id ASC
    `, [tour_id]);
    return rows;
  }
  
};

const TourImageAssignment = {
  async getAll() {
    const [rows] = await pool.query(`
      SELECT a.id, t.name AS tour_name, i.tour_img, f.folder_name
      FROM tour_image_assignment a
      JOIN tours t ON a.tour_id = t.id
      JOIN tour_images i ON a.tour_img_id = i.tour_img_id
      JOIN tour_image_folders f ON i.folder_id = f.folder_id
      ORDER BY a.id DESC
    `);
    return rows;
  },

  async create(tour_id, tour_img_id) {
    await pool.query(
      "INSERT INTO tour_image_assignment (tour_id, tour_img_id) VALUES (?, ?)",
      [tour_id, tour_img_id]
    );
  },

  async delete(id) {
    await pool.query("DELETE FROM tour_image_assignment WHERE id = ?", [id]);
  },
};

module.exports = { TourImageFolders, TourImages, TourImageAssignment };
