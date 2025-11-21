// controllers/tour_locations.controller.js
const Model = require("../models/tour_locations.model");

module.exports = {
  getAll: async (req, res) => {
    try {
      const data = await Model.getAll();
      res.json({ success: true, data });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  getLocations: async (req, res) => {
    try {
      const tourId = Number(req.params.tourId);
      const data = await Model.getByTourId(tourId);
      res.json({ success: true, data });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  createLocation: async (req, res) => {
    try {
      const location = req.body;

      location.tour_id = Number(location.tour_id);
      location.latitude = Number(location.latitude);
      location.longitude = Number(location.longitude);

      if (!location.tour_id || !location.latitude || !location.longitude) {
        return res.status(400).json({
          success: false,
          message: "tour_id, latitude, longitude required"
        });
      }

      // ⭐ Duplicate check
      const existing = await Model.findDuplicate(location);
      if (existing) {
        return res.status(200).json({
          success: true,
          message: "Location already exists",
          data: existing,
        });
      }

      const result = await Model.create(location);

      return res.status(201).json({
        success: true,
        message: "Created successfully",
        insertId: result.insertId
      });

    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  updateLocation: async (req, res) => {
    try {
      const id = Number(req.params.id);
      const location = req.body;

      location.tour_id = Number(location.tour_id);
      location.latitude = Number(location.latitude);
      location.longitude = Number(location.longitude);

      const result = await Model.update(id, location);

      res.json({ success: true, message: "Updated successfully", result });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  deleteLocation: async (req, res) => {
    try {
      const id = Number(req.params.id);
      const result = await Model.delete(id);
      res.json({ success: true, message: "Deleted successfully", result });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },
};
