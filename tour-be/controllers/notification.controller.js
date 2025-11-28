// controllers/notification.controller.js
const Notification = require('../models/notification.model');

const NotificationController = {
  async listByUser(req, res) {
    try {
      const { userId } = req.params;
      const { status = 'all', q = '' } = req.query;

      if (!userId) {
        return res.status(400).json({ success: false, message: 'Thiếu userId' });
      }

      const [rows] = await Notification.findByUser(userId, {
        status,
        search: q.trim(),
      });

      return res.json({ success: true, data: rows });
    } catch (error) {
      console.error('[NotificationController][listByUser]', error);
      return res.status(500).json({ success: false, message: 'Lỗi lấy thông báo' });
    }
  },

  async countUnread(req, res) {
    try {
      const { userId } = req.params;
      if (!userId) {
        return res.status(400).json({ success: false, message: 'Thiếu userId' });
      }

      const [rows] = await Notification.countUnread(userId);
      const total = rows[0]?.total || 0;
      return res.json({ success: true, count: total });
    } catch (error) {
      console.error('[NotificationController][countUnread]', error);
      return res.status(500).json({ success: false, message: 'Lỗi đếm thông báo' });
    }
  },

  async markAsRead(req, res) {
    try {
      const { id } = req.params;
      const { user_id } = req.body;

      if (!id || !user_id) {
        return res.status(400).json({ success: false, message: 'Thiếu thông tin' });
      }

      await Notification.markAsRead(id, user_id);
      return res.json({ success: true, message: 'Đã đánh dấu đã đọc' });
    } catch (error) {
      console.error('[NotificationController][markAsRead]', error);
      return res.status(500).json({ success: false, message: 'Không thể cập nhật' });
    }
  },

  async markAllAsRead(req, res) {
    try {
      const { userId } = req.params;
      if (!userId) {
        return res.status(400).json({ success: false, message: 'Thiếu userId' });
      }

      await Notification.markAllAsRead(userId);
      return res.json({ success: true, message: 'Đã đánh dấu tất cả là đã đọc' });
    } catch (error) {
      console.error('[NotificationController][markAllAsRead]', error);
      return res.status(500).json({ success: false, message: 'Không thể cập nhật' });
    }
  },

  async remove(req, res) {
    try {
      const { id } = req.params;
      const { user_id } = req.body;

      if (!id || !user_id) {
        return res.status(400).json({ success: false, message: 'Thiếu thông tin' });
      }

      await Notification.delete(id, user_id);
      return res.json({ success: true, message: 'Đã xoá thông báo' });
    } catch (error) {
      console.error('[NotificationController][remove]', error);
      return res.status(500).json({ success: false, message: 'Không thể xoá' });
    }
  },
};

module.exports = NotificationController;


