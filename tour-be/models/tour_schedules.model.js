const db = require("../config/db");

const TourSchedules = {
  // Lấy toàn bộ lịch trình
  getAllSchedules: async () => {
    const [rows] = await db.execute(`
      SELECT s.*, t.name AS tour_name
      FROM tour_schedules s
      LEFT JOIN tours t ON s.tour_id = t.id
      ORDER BY s.schedule_id DESC
    `);
    return rows;
  },

  // Lấy lịch trình theo tour_id
  getSchedulesByTour: async (tour_id) => {
    const [rows] = await db.execute(`
      SELECT s.*, t.name AS tour_name
      FROM tour_schedules s
      LEFT JOIN tours t ON s.tour_id = t.id
      WHERE s.tour_id = ?
      ORDER BY s.day_number ASC
    `, [tour_id]);
    return rows;
  },

  // Tạo lịch trình mới
  createSchedule: async (data) => {
    const [result] = await db.execute(
      `INSERT INTO tour_schedules (tour_id, day_number, description)
       VALUES (?, ?, ?)`,
      [data.tour_id, data.day_number, data.description]
    );
    return result;
  },

  // Cập nhật lịch trình
  updateSchedule: async (schedule_id, data) => {
    const [result] = await db.execute(
      `UPDATE tour_schedules
       SET tour_id=?, day_number=?, description=?
       WHERE schedule_id=?`,
      [data.tour_id, data.day_number, data.description, schedule_id]
    );
    return result;
  },

  // Xóa lịch trình
  deleteSchedule: async (schedule_id) => {
    const [result] = await db.execute(
      `DELETE FROM tour_schedules WHERE schedule_id=?`,
      [schedule_id]
    );
    return result;
  },

  // Danh sách tour để chọn
  getTours: async () => {
    const [rows] = await db.execute(`
      SELECT id, name FROM tours ORDER BY name ASC
    `);
    return rows;
  }
};

module.exports = TourSchedules;
