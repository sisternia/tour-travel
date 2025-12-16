// services/vnpay.service.js
const crypto = require("crypto");

const tmnCode = process.env.VNP_TMNCODE;
const secretKey = process.env.VNP_HASHSECRET;
const vnpUrl = process.env.VNP_URL;
const returnUrl = process.env.VNP_RETURN_URL;

function sortObject(obj) {
  return Object.keys(obj)
    .sort()
    .reduce((acc, key) => {
      acc[key] = obj[key];
      return acc;
    }, {});
}

function buildVnpQuery(params) {
  return Object.keys(params)
    .map((key) => {
      const value = params[key];
      return (
        encodeURIComponent(key) +
        "=" +
        encodeURIComponent(value).replace(/%20/g, "+")
      );
    })
    .join("&");
}

function normalizeIp(ip) {
  if (!ip || ip === "::1") return "127.0.0.1";
  if (ip.includes("::ffff:")) return ip.split("::ffff:")[1];
  return ip;
}

function getVnDateString(date = new Date()) {
  const vnTime = new Date(date.getTime() + 7 * 60 * 60 * 1000);
  return vnTime.toISOString().replace(/[-:TZ.]/g, "").slice(0, 14);
}

module.exports = {
  createPaymentUrl(orderId, amount, ip) {
    const txnRef = `${orderId}_${Date.now()}`;

    let vnp_Params = {
      vnp_Version: "2.1.0",
      vnp_Command: "pay",
      vnp_TmnCode: tmnCode,
      vnp_Locale: "vn",
      vnp_CurrCode: "VND",
      vnp_TxnRef: txnRef,
      vnp_OrderInfo: `Thanh toan don hang #${orderId}`,
      vnp_OrderType: "other",
      vnp_Amount: amount * 100,
      vnp_ReturnUrl: returnUrl,
      vnp_IpAddr: normalizeIp(ip),
      vnp_CreateDate: getVnDateString(),
      vnp_ExpireDate: getVnDateString(
        new Date(Date.now() + 15 * 60 * 1000)
      ),
    };

    vnp_Params = sortObject(vnp_Params);

    const signData = buildVnpQuery(vnp_Params);
    console.log("VNPAY SIGN DATA:", signData);

    const secureHash = crypto
      .createHmac("sha512", secretKey)
      .update(signData, "utf8")
      .digest("hex");

    vnp_Params.vnp_SecureHashType = "SHA512";
    vnp_Params.vnp_SecureHash = secureHash;

    const payUrl = `${vnpUrl}?${buildVnpQuery(vnp_Params)}`;

    return { payUrl, txnRef };
  },

  verifyReturn(vnp_Params) {
    const secureHash = vnp_Params.vnp_SecureHash;

    delete vnp_Params.vnp_SecureHash;
    delete vnp_Params.vnp_SecureHashType;

    const sortedParams = sortObject(vnp_Params);
    const signData = buildVnpQuery(sortedParams);

    const checkHash = crypto
      .createHmac("sha512", secretKey)
      .update(signData, "utf8")
      .digest("hex");

    return secureHash === checkHash;
  },
};
