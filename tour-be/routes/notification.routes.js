// routes/notification.routes.js
const express = require('express');
const router = express.Router();
const NotificationController = require('../controllers/notification.controller');

router.get('/user/:userId', NotificationController.listByUser);
router.get('/user/:userId/unread-count', NotificationController.countUnread);
router.patch('/:id/read', NotificationController.markAsRead);
router.patch('/user/:userId/read-all', NotificationController.markAllAsRead);
router.delete('/:id', NotificationController.remove);

module.exports = router;


