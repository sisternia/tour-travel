// services/notification.service.js
const Notification = require('../models/notification.model');
const Order = require('../models/orders.model');

const NotificationService = {
  async notifyPaymentSuccess(orderId) {
    try {
      const [rows] = await Order.getOrderById(orderId);
      if (!rows.length) return;

      const order = rows[0];
      if (!order?.user_id) return;

      await Notification.create({
        user_id: order.user_id,
        title: 'Thanh toán thành công',
        body: `Đơn hàng #${order.id} - ${order.tour_name || 'tour du lịch'} đã được thanh toán thành công.`,
        type: 'payment',
        reference_id: order.id?.toString(),
      });
    } catch (error) {
      console.error('[NotificationService][notifyPaymentSuccess]', error.message);
    }
  },

  async notifyProfileUpdated(userId, updatedFields = []) {
    try {
      if (!userId || !updatedFields.length) return;

      await Notification.create({
        user_id: userId,
        title: 'Cập nhật hồ sơ thành công',
        body: 'Thông tin cá nhân của bạn đã được cập nhật.',
        type: 'profile',
      });
    } catch (error) {
      console.error('[NotificationService][notifyProfileUpdated]', error.message);
    }
  },

  async notifyAdminConfirmed(orderId) {
    try {
      const [rows] = await Order.getOrderById(orderId);
      if (!rows.length) return;

      const order = rows[0];
      if (!order?.user_id) return;

      await Notification.create({
        user_id: order.user_id,
        title: 'Admin đã xác nhận đơn hàng',
        body: `Đơn hàng #${order.id} - ${order.tour_name || 'tour du lịch'} đã được admin xác nhận thành công.`,
        type: 'payment',
        reference_id: order.id?.toString(),
      });
    } catch (error) {
      console.error('[NotificationService][notifyAdminConfirmed]', error.message);
    }
  },
};

module.exports = NotificationService;

