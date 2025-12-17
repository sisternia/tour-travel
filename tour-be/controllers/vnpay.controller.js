// controllers/vnpay.controller.js
const VnpayService = require("../services/vnpay.service");
const VnpayModel = require("../models/vnpay.model");
const Order = require("../models/orders.model");
const NotificationService = require("../services/notification.service");
const { sendOrderStatusMail } = require("../services/verify.service");

module.exports = {
  createPayment: async (req, res) => {
    try {
      const { orderId, amount } = req.body;
      const ip = req.headers["x-forwarded-for"] || req.socket.remoteAddress;

      const { payUrl, txnRef } =
        VnpayService.createPaymentUrl(orderId, amount, ip);

      await VnpayModel.create({
        order_id: orderId,
        vnp_TxnRef: txnRef,
        vnp_Amount: amount * 100,
        vnp_OrderInfo: `Thanh toán đơn hàng #${orderId}`,
      });

      res.json({ success: true, payUrl });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  // 🔥 RETURN URL — KHÔNG REDIRECT
  returnUrl: async (req, res) => {
    const vnp_Params = req.query;

    if (!VnpayService.verifyReturn({ ...vnp_Params })) {
      return res.status(400).send("INVALID SIGNATURE");
    }

    const txnRef = vnp_Params.vnp_TxnRef;
    const responseCode = vnp_Params.vnp_ResponseCode;

    const [[payment]] = await VnpayModel.findByTxnRef(txnRef);
    if (!payment) return res.status(404).send("NOT FOUND");

    if (responseCode === "00") {
      await VnpayModel.updateResult(txnRef, {
        ...vnp_Params,
        status: "SUCCESS",
      });

      await Order.updateStatus(payment.order_id, 3);
      await NotificationService.notifyPaymentSuccess(payment.order_id);

      const [[order]] = await Order.getOrderById(payment.order_id);
      if (order?.email_tourist) {
        await sendOrderStatusMail(
          order.email_tourist,
          "Đã thanh toán",
          payment.order_id
        );
      }
    } else {
      await VnpayModel.updateResult(txnRef, {
        ...vnp_Params,
        status: "FAILED",
      });
    }

    // ✅ HTML RESPONSE
    // - WEB: window.close()
    // - MOBILE: WebView bắt URL ?success=1
    res.set("Content-Type", "text/html");
    res.send(`
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8" />
          <title>VNPAY</title>
        </head>
        <body>
          <script>
            try {
              window.location.href = "vnpay-return://success?orderId=${payment.order_id}";
              window.close();
            } catch (e) {}
          </script>
          <p>Payment processed. You can close this window.</p>
        </body>
      </html>
    `);
  },

  ipn: async (req, res) => {
    const vnp_Params = req.query;

    if (!VnpayService.verifyReturn({ ...vnp_Params })) {
      return res.json({ RspCode: "97", Message: "Invalid signature" });
    }

    res.json({ RspCode: "00", Message: "Confirm Success" });
  },
};
