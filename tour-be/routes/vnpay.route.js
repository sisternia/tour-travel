// routes/vnpay.route.js
const express = require("express");
const router = express.Router();
const VnpayService = require("../services/vnpay.service");
const PaymentService = require("../models/payment.model");
const crypto = require("crypto");
router.post("/create_payment_url", (req, res) => {
  console.log("BODY FROM FLUTTER:", req.body);

  try {
    const url = VnpayService.createPaymentUrl(req);
    return res.json({ paymentUrl: url });
  } catch (error) {
    console.error("Error creating VNPAY URL:", error);
    return res.status(500).json({ error: "Lỗi tạo URL thanh toán" });
  }
});

router.get("/ipn", async (req, res) => {
  console.log(" VNPAY IPN CALLBACK:", req.query);

  let vnp_Params = { ...req.query };

  const secureHash = vnp_Params["vnp_SecureHash"];
  delete vnp_Params["vnp_SecureHash"];
  delete vnp_Params["vnp_SecureHashType"];

  // Sort params
  const sortedData = {};
  const keys = Object.keys(vnp_Params).sort();
  keys.forEach((key) => (sortedData[key] = vnp_Params[key]));

  const signData = keys.map((k) => `${k}=${sortedData[k]}`).join("&");

  const secretKey = "PXK2804JM832B5YOO8YW83NXZ0QVHMNA";

  const signed = crypto
    .createHmac("sha512", secretKey)
    .update(Buffer.from(signData, "utf-8"))
    .digest("hex");

  console.log("SECURE HASH FROM VNP:", secureHash);
  console.log("SERVER GENERATED HASH:", signed);

  if (secureHash !== signed) {
    return res
      .status(200)
      .json({ RspCode: "97", Message: "Invalid signature" });
  }

  // Lưu DB
  try {
    await PaymentService.createPayment({
      order_id: vnp_Params.vnp_TxnRef,
      amount: parseInt(vnp_Params.vnp_Amount) / 100,
      vnp_TxnRef: vnp_Params.vnp_TxnRef,
      vnp_TransactionNo: vnp_Params.vnp_TransactionNo,
      vnp_ResponseCode: vnp_Params.vnp_ResponseCode,
      vnp_TransactionStatus: vnp_Params.vnp_TransactionStatus,
      vnp_OrderInfo: vnp_Params.vnp_OrderInfo,
      vnp_BankCode: vnp_Params.vnp_BankCode,
      vnp_PayDate: vnp_Params.vnp_PayDate,
    });

    return res.status(200).json({ RspCode: "00", Message: "Success" });
  } catch (error) {
    console.error("❌ IPN Save Error:", error);
    return res.status(500).json({ RspCode: "99", Message: "Unknown error" });
  }
});
router.get("/return", (req, res) => {
  console.log("🏁 User RETURNED:", req.query);
  res.json(req.query);
});

module.exports = router;
