const db = require("../config/db");

const RatingController = {
  addRating: async (req, res) => {
    try {
      console.log(">> DEBUG rating:", {
        params: req.params,
        tourId: req.params.id,
        body: req.body,
      });

      const { id: tourId } = req.params;
      const { userId, rating, comment } = req.body;

      if (!tourId || !userId) {
        return res.status(400).json({ message: "Thiếu dữ liệu" });
      }
      const [existing] = await db.query(
        `SELECT rating_id 
         FROM tour_ratings 
         WHERE tour_id = ? AND user_id = ?`,
        [tourId, userId]
      );

      if (existing.length > 0) {
        await db.query(
          `UPDATE tour_ratings 
           SET rating_value = ?, comment = ?, created_at = NOW()
           WHERE tour_id = ? AND user_id = ?`,
          [rating, comment, tourId, userId]
        );

        return res.json({ success: true, updated: true });
      }
      await db.query(
        `INSERT INTO tour_ratings (tour_id, user_id, rating_value, comment)
         VALUES (?, ?, ?, ?)`,
        [tourId, userId, rating, comment]
      );

      res.json({ success: true, inserted: true });
    } catch (err) {
      console.error("Add rating error:", err);
      res.status(500).json({ message: "Lỗi server" });
    }
  },

  getRatings: async (req, res) => {
    try {
      const tourId = req.params.id;

      const [rows] = await db.query(
        `SELECT r.*, u.user_name 
         FROM tour_ratings r
         JOIN users u ON r.user_id = u.user_id
         WHERE r.tour_id = ?
         ORDER BY r.created_at DESC`,
        [tourId]
      );

      res.json(rows);
    } catch (error) {
      console.error("Get ratings error:", error);
      res.status(500).json({ message: "Lỗi server" });
    }
  },
};

module.exports = RatingController;
