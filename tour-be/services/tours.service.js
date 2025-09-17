const Tour = require("../models/tour.model");

const createTour = async (tourData) => {
  try {
    return await Tour.create(tourData);
  } catch (error) {
    console.error("Error in createTour service:", error);
    throw error;
  }
};

const getAllTours = async () => {
  try {
    return await Tour.findAll();
  } catch (error) {
    console.error("Error in getAllTours service:", error);
    throw error;
  }
};

const getTourById = async (id) => {
  try {
    return await Tour.findById(id);
  } catch (error) {
    console.error(`Error in getTourById service (id=${id}):`, error);
    throw error;
  }
};

const updateTour = async (id, tourData) => {
  try {
    return await Tour.update(id, tourData);
  } catch (error) {
    console.error(`Error in updateTour service (id=${id}):`, error);
    throw error;
  }
};

const deleteTour = async (id) => {
  try {
    return await Tour.delete(id);
  } catch (error) {
    console.error(`Error in deleteTour service (id=${id}):`, error);
    throw error;
  }
};

const getLatestTours = async (limit) => {
  try {
    return await Tour.findLatest(limit);
  } catch (error) {
    console.error("Error in getLatestTours service:", error);
    throw error;
  }
};

module.exports = {
  createTour,
  getAllTours,
  getTourById,
  updateTour,
  deleteTour,
  getLatestTours,
};
