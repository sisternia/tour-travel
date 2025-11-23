// controllers/tours.controller.js
const Tour = require("../models/tours.model");
const TourCategories = require("../models/tour_categories.model");
const TourType = require("../models/tours_type.model");
const TourPrices = require("../models/tour_prices.model");
const TourLocations = require("../models/tour_locations.model");
const { TourImages } = require("../models/tour_images.model");
const Assignment = require("../models/tour_guide_assignment.model");

const getAllTours = async (req, res) => {
  try {
    const search = req.query.search;

    let tours = await Tour.getAll();

    if (search) {
      const keyword = search.toLowerCase();
      tours = tours.filter(
        (t) =>
          t.name.toLowerCase().includes(keyword) ||
          t.destination_address.toLowerCase().includes(keyword)
      );
    }

    res.status(200).json(tours);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const getLatestWithPrices = async (req, res) => {
  try {
    const tours = await Tour.getLatestWithPrices();
    res.status(200).json(tours);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const getTourById = async (req, res) => {
  try {
    const { id } = req.params;

    const tour = await Tour.getById(id);
    if (!tour) return res.status(404).json({ message: "Không tìm thấy tour" });

    const category = await TourCategories.findById(tour.tour_category_id);

    // Kiểu tour
    let typeList = [];
    if (tour.tour_type_id) {
      const typeIds = tour.tour_type_id.split(",").map((id) => id.trim());
      typeList = await Promise.all(
        typeIds.map((tid) => TourType.findById(tid))
      );
    }

    const images = await TourImages.getAllByTourId(id);
    const prices = await TourPrices.getAssignmentsByTour(id);
    const locations = await TourLocations.getByTourId(id);
    const guides = await Assignment.getByTourId(id);

    res.json({
      ...tour,
      category,
      types: typeList,
      images,
      prices,
      locations,
      guides,
    });
  } catch (err) {
    console.error("Error getTourById:", err);
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

const createTour = async (req, res) => {
  try {
    const {
      name,
      number_of_people,
      start_date,
      end_date,
      departure_address,
      destination_address,
      status,
      tour_category_id,
      tour_type_id,
    } = req.body;

    if (
      !name ||
      !number_of_people ||
      !start_date ||
      !end_date ||
      !departure_address ||
      !destination_address
    ) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc" });
    }

    await Tour.create({
      name,
      number_of_people,
      start_date,
      end_date,
      departure_address,
      destination_address,
      status,
      tour_category_id,
      tour_type_id,
    });

    res.status(201).json({ success: true, message: "Thêm tour thành công" });
  } catch (error) {
    console.error("Error creating tour:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const updateTour = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;

    const result = await Tour.update(id, data);

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy tour" });

    res.json({ success: true, message: "Cập nhật tour thành công" });
  } catch (error) {
    console.error("Error updating tour:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

const deleteTour = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await Tour.delete(id);

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy tour" });

    res.json({ success: true, message: "Xóa tour thành công" });
  } catch (error) {
    console.error("Error deleting tour:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

module.exports = {
  getAllTours,
  getLatestWithPrices,
  getTourById,
  createTour,
  updateTour,
  deleteTour,
};
