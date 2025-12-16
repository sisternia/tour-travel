const db = require("../config/db");

module.exports = {
  create: (data) => {
    const { order_id, vnp_TxnRef, vnp_Amount, vnp_OrderInfo } = data;
    return db.execute(
      `INSERT INTO vnpay_payments (order_id, vnp_TxnRef, vnp_Amount, vnp_OrderInfo)
       VALUES (?, ?, ?, ?)`,
      [order_id, vnp_TxnRef, vnp_Amount, vnp_OrderInfo]
    );
  },

  updateResult: (vnp_TxnRef, data) => {
    const {
      vnp_ResponseCode,
      vnp_TransactionNo,
      vnp_BankCode,
      vnp_PayDate,
      status,
    } = data;

    return db.execute(
      `UPDATE vnpay_payments
       SET vnp_ResponseCode=?, vnp_TransactionNo=?, vnp_BankCode=?, vnp_PayDate=?, status=?
       WHERE vnp_TxnRef=?`,
      [
        vnp_ResponseCode,
        vnp_TransactionNo,
        vnp_BankCode,
        vnp_PayDate,
        status,
        vnp_TxnRef,
      ]
    );
  },

  findByTxnRef: (vnp_TxnRef) => {
    return db.execute(
      `SELECT * FROM vnpay_payments WHERE vnp_TxnRef=?`,
      [vnp_TxnRef]
    );
  },
};
