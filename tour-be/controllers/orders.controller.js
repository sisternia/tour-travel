// controllers\orders.controller.js

const OrderService = require("../models/orders.model");
module.exports = {
  getAll: async (req, res) => {
    try {
      const [rows] = await OrderService.getAllOrders();
      res.status(200).json(rows);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  getById: async (req, res) => {
    try {
      const [rows] = await OrderService.getOrderById(req.params.id);
      res.status(200).json(rows[0]);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  create: async (req, res) => {
    try {
      const [result] = await OrderService.createOrder(req.body);

      res.status(201).json({
        message: "Tạo đơn hàng thành công",
        order_id: result.insertId,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  updateStatus: async (req, res) => {
    try {
      await OrderService.updateStatus(req.params.id, req.body.type_confirm_id);
      res.status(200).json({ message: "Cập nhật trạng thái thành công" });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  delete: async (req, res) => {
    try {
      await OrderService.deleteOrder(req.params.id);
      res.status(200).json({ message: "Xóa đơn hàng thành công" });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },
};
