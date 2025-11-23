const db = require("../config/db");

module.exports = {
  createPayment: (data) => {
    const {
      order_id,
      amount,
      vnp_TxnRef,
      vnp_TransactionNo,
      vnp_ResponseCode,
      vnp_TransactionStatus,
      vnp_OrderInfo,
      vnp_BankCode,
      vnp_PayDate,
    } = data;

    return db.execute(
      `
            INSERT INTO payments (
                order_id, amount, vnp_TxnRef, vnp_TransactionNo,
                vnp_ResponseCode, vnp_TransactionStatus,
                vnp_OrderInfo, vnp_BankCode, vnp_PayDate
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `,
      [
        order_id,
        amount,
        vnp_TxnRef,
        vnp_TransactionNo,
        vnp_ResponseCode,
        vnp_TransactionStatus,
        vnp_OrderInfo,
        vnp_BankCode,
        vnp_PayDate,
      ]
    );
  },

  getByOrderId: (orderId) => {
    return db.execute(
      `
            SELECT * FROM payments WHERE order_id = ?
        `,
      [orderId]
    );
  },
};
