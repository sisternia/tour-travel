const express = require("express");
const router = express.Router();
const VnpayController = require("../controllers/vnpay.controller");

router.post("/payment", VnpayController.createPayment);
router.get("/return", VnpayController.returnUrl);
router.get("/ipn", VnpayController.ipn);

module.exports = router;
