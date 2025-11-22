const crypto = require("crypto");
const moment = require("moment");

const vnp_TmnCode = "NVXVMG86";
const vnp_HashSecret = "PXK2804JM832B5YOO8YW83NXZ0QVHMNA";
const vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
const vnp_ReturnUrl = "http://localhost:3000/api/vnpay/return";
function sortObject(obj) {
  const sorted = {};
  const keys = Object.keys(obj).sort();
  keys.forEach((key) => (sorted[key] = obj[key]));
  return sorted;
}

module.exports = {
  createPaymentUrl: (req) => {
    const { amount, orderId, orderInfo } = req.body;
    let ipAddr =
      req.headers["x-forwarded-for"] ||
      req.connection.remoteAddress ||
      req.socket.remoteAddress ||
      req.ip;

    if (!ipAddr) ipAddr = "127.0.0.1";

    if (ipAddr.startsWith("::ffff:")) {
      ipAddr = ipAddr.replace("::ffff:", "");
    }
    if (ipAddr === "::1") {
      ipAddr = "127.0.0.1";
    }
    const createDate = moment().format("YYYYMMDDHHmmss");
    const vnp_TxnRef = moment().format("HHmmss");

    let vnp_Params = {
      vnp_Version: "2.1.0",
      vnp_Command: "pay",
      vnp_TmnCode: vnp_TmnCode,
      vnp_Locale: "vn",
      vnp_CurrCode: "VND",
      vnp_TxnRef: vnp_TxnRef,
      vnp_OrderInfo: orderInfo,
      vnp_OrderType: "other",
      vnp_Amount: amount * 100,
      vnp_ReturnUrl: vnp_ReturnUrl,
      vnp_IpAddr: ipAddr,
      vnp_CreateDate: createDate,
    };
    vnp_Params = sortObject(vnp_Params);
    const signData = Object.keys(vnp_Params)
      .map((key) => `${key}=${vnp_Params[key]}`)
      .join("&");
    const signed = crypto
      .createHmac("sha512", vnp_HashSecret)
      .update(Buffer.from(signData, "utf-8"))
      .digest("hex");
    console.log("SIGN RAW:", signData);
    console.log("SIGNED BY NODE:", signed);
    vnp_Params["vnp_SecureHash"] = signed;

    const query = Object.keys(vnp_Params)
      .map((key) => `${key}=${encodeURIComponent(vnp_Params[key])}`)
      .join("&");

    return `${vnp_Url}?${query}`;
  },
};
