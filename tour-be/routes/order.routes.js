const express = require("express");
const router = express.Router();

const OrderController = require("../controllers/orders.controller");

router.get("/user/:userId", OrderController.getByUser);

router.get("/", OrderController.getAll);

router.get("/:id", OrderController.getById);

router.post("/", OrderController.create);

router.put("/:id/status", OrderController.updateStatus);

router.delete("/:id", OrderController.delete);

module.exports = router;
