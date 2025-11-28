// models/notification.model.js
const db = require('../config/db');

const buildFilterQuery = ({ status, search }) => {
  const conditions = [];
  const params = [];

  if (status === 'unread') {
    conditions.push('is_read = 0');
  } else if (status === 'read') {
    conditions.push('is_read = 1');
  }

  if (search) {
    conditions.push('(title LIKE ? OR body LIKE ?)');
    const keyword = `%${search}%`;
    params.push(keyword, keyword);
  }

  return { conditions, params };
};

const Notification = {
  create: ({ user_id, title, body, type = 'general', reference_id = null }) => {
    return db.execute(
      `
        INSERT INTO notifications (user_id, title, body, type, reference_id)
        VALUES (?, ?, ?, ?, ?)
      `,
      [user_id, title, body, type, reference_id]
    );
  },

  findByUser: (userId, { status, search } = {}) => {
    const { conditions, params } = buildFilterQuery({ status, search });
    const where = ['user_id = ?'];

    if (conditions.length) where.push(...conditions);

    return db.execute(
      `
        SELECT id, user_id, title, body, type, reference_id, is_read, created_at, updated_at
        FROM notifications
        WHERE ${where.join(' AND ')}
        ORDER BY created_at DESC
      `,
      [userId, ...params]
    );
  },

  countUnread: (userId) => {
    return db.execute(
      `
        SELECT COUNT(*) AS total
        FROM notifications
        WHERE user_id = ? AND is_read = 0
      `,
      [userId]
    );
  },

  markAsRead: (notificationId, userId) => {
    return db.execute(
      `
        UPDATE notifications
        SET is_read = 1
        WHERE id = ? AND user_id = ?
      `,
      [notificationId, userId]
    );
  },

  markAllAsRead: (userId) => {
    return db.execute(
      `
        UPDATE notifications
        SET is_read = 1
        WHERE user_id = ? AND is_read = 0
      `,
      [userId]
    );
  },

  delete: (notificationId, userId) => {
    return db.execute(
      `
        DELETE FROM notifications
        WHERE id = ? AND user_id = ?
      `,
      [notificationId, userId]
    );
  },
};

module.exports = Notification;


