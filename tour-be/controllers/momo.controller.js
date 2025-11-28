const MomoService = require("../services/momo.service");
const Order = require("../models/orders.model");
const NotificationService = require('../services/notification.service');

class MomoController {
  static async createPayment(req, res) {
    try {
      const { orderId, amount } = req.body;

      if (!orderId || !amount) {
        return res
          .status(400)
          .json({ success: false, message: "Thiếu orderId hoặc amount" });
      }

      const payUrl = await MomoService.createPayment(orderId, amount);

      return res.status(200).json({
        success: true,
        payUrl,
      });
    } catch (err) {
      console.error("MOMO PAYMENT ERROR:", err);
      console.log("REQ BODY:", req.body);
      return res.status(500).json({ success: false, message: err.message });
    }
  }

  // MoMo IPN
  static async ipn(req, res) {
    try {
      const data = req.body;

      if (data.errorCode === 0) {
        await Order.updateStatus(data.orderId, 2);
        await NotificationService.notifyPaymentSuccess(data.orderId);
      } else {
        await Order.updateStatus(data.orderId, 3);
      }

      return res.json({ resultCode: 0, message: "Success" });
    } catch (err) {
      console.log(err);
      return res.json({ resultCode: -1, message: "Server Error" });
    }
  }

  static async redirect(req, res) {
    try {
      const { orderId } = req.query;

      const [rows] = await Order.getOrderById(orderId);

      return res.json({
        success: true,
        order: rows[0],
      });
    } catch (err) {
      console.error(err);
    }
  }
}

module.exports = MomoController;
