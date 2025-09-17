const TourType = require("../models/tour_type.model");

const TourTypeController = {
  // Get all tour types
  getAllTourTypes: async (req, res) => {
    try {
      const tourTypes = await TourType.getAll();
      res.status(200).json(tourTypes);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  },

  // Get a single tour type by ID
  getTourTypeById: async (req, res) => {
    try {
      const { type_id } = req.params;
      const tourType = await TourType.findById(type_id);
      if (tourType) {
        res.status(200).json(tourType);
      } else {
        res.status(404).json({ message: "Tour type not found" });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  },

  // Get a single tour type by name
  getTourTypeByName: async (req, res) => {
    try {
      const { type_name } = req.params;
      const tourType = await TourType.findByName(type_name);
      if (tourType) {
        res.status(200).json(tourType);
      } else {
        res.status(404).json({ message: "Tour type not found" });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server Error" });
    }
  },
};

module.exports = TourTypeController;
