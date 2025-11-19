// models\tour_locations.model.js
const db = require("../config/db");

const TourLocations = {
  getAll: async () => {
    const [rows] = await db.execute(`
      SELECT 
        tl.*, 
        t.name AS tour_name
      FROM tour_locations tl
      JOIN tours t ON t.id = tl.tour_id
      ORDER BY tl.location_id DESC
    `);
    return rows;
  },

  getByTourId: async (tourId) => {
    const [rows] = await db.execute(
      `
      SELECT 
        tl.*, 
        t.name AS tour_name
      FROM tour_locations tl
      JOIN tours t ON t.id = tl.tour_id
      WHERE tl.tour_id = ?
      ORDER BY tl.location_id DESC
      `,
      [tourId]
    );
    return rows;
  },

  getById: async (id) => {
    const [rows] = await db.execute(
      `
      SELECT 
        tl.*, 
        t.name AS tour_name
      FROM tour_locations tl
      JOIN tours t ON t.id = tl.tour_id
      WHERE tl.location_id = ?
      LIMIT 1
      `,
      [id]
    );
    return rows[0];
  },

  create: async (location) => {
    const sql = `
      INSERT INTO tour_locations (tour_id, location_name, description, latitude, longitude)
      VALUES (?, ?, ?, ?, ?)
    `;
    const [res] = await db.execute(sql, [
      location.tour_id,
      location.location_name,
      location.description,
      location.latitude,
      location.longitude
    ]);
    return res;
  },

  update: async (id, location) => {
    const sql = `
      UPDATE tour_locations
      SET tour_id = ?, location_name = ?, description = ?, latitude = ?, longitude = ?
      WHERE location_id = ?
    `;
    const [res] = await db.execute(sql, [
      location.tour_id,
      location.location_name,
      location.description,
      location.latitude,
      location.longitude,
      id
    ]);
    return res;
  },

  delete: async (id) => {
    const [res] = await db.execute(
      `DELETE FROM tour_locations WHERE location_id = ?`,
      [id]
    );
    return res;
  }
};

module.exports = TourLocations;

