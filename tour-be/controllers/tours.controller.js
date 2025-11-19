// controllers/tours.controller.js
const Tour = require("../models/tours.model");

const getAllTours = async (req, res) => {
  try {
    const tours = await Tour.getAll();
    res.status(200).json(tours);
  } catch (error) {
    console.error("Error fetching tours:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
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

    const result = await Tour.update(id, {
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

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy tour" });

    res.status(200).json({ success: true, message: "Cập nhật tour thành công" });
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

    res.status(200).json({ success: true, message: "Xóa tour thành công" });
  } catch (error) {
    console.error("Error deleting tour:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

module.exports = { getAllTours, createTour, updateTour, deleteTour };
