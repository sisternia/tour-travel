const express = require("express");
const router = express.Router();

const PaymentController = require("../controllers/payment.controller");

router.post("/", PaymentController.create);
router.get("/:order_id", PaymentController.getByOrderId);

module.exports = router;
