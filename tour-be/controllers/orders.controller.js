// controllers/orders.controller.js
const Order = require("../models/orders.model");
const NotificationService = require("../services/notification.service");
const { sendOrderStatusMail } = require("../services/verify.service");

const STATUS_TEXT = {
  1: "Đang chờ xác nhận",
  2: "Đã xác nhận",
  3: "Đã thanh toán",
  4: "Đã hoàn thành tour",
};

const OrderController = {
  getAll: async (req, res) => {
    try {
      const [rows] = await Order.getAllOrders();
      return res.status(200).json(rows);
    } catch (err) {
      console.error("Get all orders error:", err);
      return res.status(500).json({
        success: false,
        message: "Không thể lấy danh sách đơn hàng",
      });
    }
  },

  getById: async (req, res) => {
    try {
      const { id } = req.params;
      const [rows] = await Order.getOrderById(id);

      if (!rows.length) {
        return res.status(404).json({
          success: false,
          message: "Không tìm thấy đơn hàng",
        });
      }

      return res.status(200).json(rows[0]);
    } catch (err) {
      console.error("Get order by id error:", err);
      return res.status(500).json({
        success: false,
        message: "Lỗi server",
      });
    }
  },

  getByUser: async (req, res) => {
    try {
      const { userId } = req.params;

      const [rows] = await Order.getOrdersByUser(userId);

      return res.status(200).json(rows);
    } catch (err) {
      console.error("Get orders by user error:", err);
      return res.status(500).json({
        success: false,
        message: "Không thể lấy đơn hàng của người dùng",
      });
    }
  },

  create: async (req, res) => {
    try {
      const {
        number_of_child,
        number_of_adult,
        name_tourist,
        phone_tourist,
        email_tourist,
        total,
        note,
        user_id,
        tour_id,
      } = req.body;

      if (!name_tourist || !phone_tourist || !user_id || !tour_id) {
        return res.status(400).json({
          success: false,
          message: "Thiếu thông tin cần thiết để tạo đơn hàng",
        });
      }

      const [result] = await Order.createOrder({
        number_of_child,
        number_of_adult,
        name_tourist,
        phone_tourist,
        email_tourist,
        total,
        note,
        user_id,
        tour_id,
      });

      const orderId = result.insertId;

      await sendOrderStatusMail(email_tourist, STATUS_TEXT[1], orderId);

      return res.status(201).json({
        success: true,
        message: "Tạo đơn hàng thành công",
        order_id: orderId,
      });
    } catch (err) {
      console.error("Order create error:", err);
      return res.status(500).json({
        success: false,
        message: err.message || "Lỗi tạo đơn hàng",
      });
    }
  },

  updateStatus: async (req, res) => {
    try {
      const { id } = req.params;
      const { type_confirm_id } = req.body;

      await Order.updateStatus(id, type_confirm_id);

      const [[order]] = await Order.getOrderById(id);

      await sendOrderStatusMail(
        order.email_tourist,
        STATUS_TEXT[type_confirm_id],
        id
      );

      if (Number(type_confirm_id) === 3) {
        await NotificationService.notifyPaymentSuccess(id);
      } else if (Number(type_confirm_id) === 2) {
        await NotificationService.notifyAdminConfirmed(id);
      }

      return res.status(200).json({
        success: true,
        message: "Cập nhật trạng thái thành công",
      });
    } catch (err) {
      console.error("Update status error:", err);
      return res.status(500).json({
        success: false,
        message: "Lỗi cập nhật trạng thái",
      });
    }
  },
  userCompleted: async (req, res) => {
    try {
      const { id } = req.params;
      const { userId } = req.body;

      const [[order]] = await Order.getOrderById(id);

      if (!order) {
        return res.status(404).json({
          success: false,
          message: "Không tìm thấy đơn hàng",
        });
      }

      if (order.user_id !== userId) {
        return res.status(403).json({
          success: false,
          message: "Bạn không có quyền cập nhật đơn hàng này",
        });
      }

      await Order.updateStatus(id, 4);

      return res.status(200).json({
        success: true,
        message: "Bạn đã xác nhận hoàn thành tour!",
      });
    } catch (err) {
      console.error("User completed error:", err);
      return res.status(500).json({
        success: false,
        message: "Lỗi xác nhận hoàn thành",
      });
    }
  },
  delete: async (req, res) => {
    try {
      const { id } = req.params;

      await Order.deleteOrder(id);

      return res.status(200).json({
        success: true,
        message: "Xoá đơn hàng thành công",
      });
    } catch (err) {
      console.error("Delete order error:", err);
      return res.status(500).json({
        success: false,
        message: "Lỗi xoá đơn hàng",
      });
    }
  },
};

module.exports = OrderController;
