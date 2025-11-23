const PaymentService = require("../models/payment.model");

module.exports = {
  create: async (req, res) => {
    try {
      await PaymentService.createPayment(req.body);
      res.status(201).json({ message: "Thanh toán đã lưu thành công" });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  getByOrderId: async (req, res) => {
    try {
      const [rows] = await PaymentService.getByOrderId(req.params.order_id);
      res.status(200).json(rows);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },
};
