const Assignment = require("../models/tour_guide_assignment.model");
const TourGuide = require("../models/tour_guides.model");

// ===========================
// Gán hướng dẫn viên vào tour
// ===========================
const assignGuide = async (req, res) => {
  try {
    const { tour_id, tour_guide_id } = req.body;

    if (!tour_id || !tour_guide_id)
      return res.status(400).json({ message: "Thiếu thông tin" });

    const guides = await TourGuide.getAll();
    const guide = guides.find((g) => g.guide_id == tour_guide_id);

    if (!guide)
      return res.status(404).json({ message: "Không tìm thấy hướng dẫn viên" });

    await Assignment.create(tour_id, tour_guide_id);

    res.json({ success: true, message: "Gán hướng dẫn viên thành công!" });
  } catch (err) {
    console.log("Assign error:", err);
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

// ===========================
// Lấy danh sách HDV theo tour
// ===========================
const getGuidesByTour = async (req, res) => {
  try {
    const { tour_id } = req.params;
    const guides = await Assignment.getByTourId(tour_id);

    res.json(guides);
  } catch (err) {
    console.log("Get guides error:", err);
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

// ===========================
// Xóa gán hướng dẫn viên
// ===========================
const deleteAssignment = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await Assignment.delete(id);

    if (result.affectedRows === 0)
      return res.status(404).json({ message: "Không tìm thấy dữ liệu" });

    res.json({ success: true, message: "Xóa thành công" });
  } catch (err) {
    console.log("Delete assignment error:", err);
    res.status(500).json({ message: "Lỗi server", error: err.message });
  }
};

module.exports = {
  assignGuide,
  getGuidesByTour,
  deleteAssignment,
};
