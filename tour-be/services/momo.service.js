// services\momo.service.js
const crypto = require("crypto");
const axios = require("axios");

const PARTNER_CODE = process.env.MOMO_PARTNER_CODE;
const ACCESS_KEY = process.env.MOMO_ACCESS_KEY;
const SECRET_KEY = process.env.MOMO_SECRET_KEY;
const ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";

class MomoService {
  static async createPayment(orderId, amount) {
    const momoOrderId = `${orderId}_${Date.now()}`; 

    const requestId = PARTNER_CODE + Date.now();
    const orderInfo = `Thanh toán đơn hàng #${orderId}`;
    const redirectUrl = process.env.MOMO_REDIRECT_URL;
    const ipnUrl = process.env.MOMO_IPN_URL;
    const extraData = "";
    const requestType = "captureWallet";

    const rawSignature =
      `accessKey=${ACCESS_KEY}` +
      `&amount=${amount}` +
      `&extraData=${extraData}` +
      `&ipnUrl=${ipnUrl}` +
      `&orderId=${momoOrderId}` + 
      `&orderInfo=${orderInfo}` +
      `&partnerCode=${PARTNER_CODE}` +
      `&redirectUrl=${redirectUrl}` +
      `&requestId=${requestId}` +
      `&requestType=${requestType}`;

    const signature = crypto
      .createHmac("sha256", SECRET_KEY)
      .update(rawSignature)
      .digest("hex");

    const body = {
      partnerCode: PARTNER_CODE,
      accessKey: ACCESS_KEY,
      requestId,
      amount: amount.toString(),
      orderId: momoOrderId, // FIX
      orderInfo,
      redirectUrl,
      ipnUrl,
      extraData,
      requestType,
      signature,
      lang: "vi",
    };

    console.log("MOMO SEND BODY:", body);

    const res = await axios.post(ENDPOINT, body, {
      headers: { "Content-Type": "application/json" },
    });

    console.log("MOMO RESPONSE:", res.data);

    if (!res.data.payUrl) {
      throw new Error(res.data.message);
    }

    return res.data.payUrl;
  }
}

module.exports = MomoService;
