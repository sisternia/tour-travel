import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';
import '../data/models/order_model.dart';

class OrderService {
  // Tạo đơn hàng
  static Future<int?> createOrder(Map<String, dynamic> data) async {
    final url = Uri.parse(ApiConstants.orders);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("ORDER CREATE RESPONSE: ${response.body}");

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json["order_id"];
      } else {
        print("CREATE ORDER FAILED: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("CREATE ORDER ERROR: $e");
      return null;
    }
  }

  // Lấy danh sách đơn hàng
  static Future<List<OrderModel>> getOrders() async {
    try {
      final res = await http.get(Uri.parse(ApiConstants.orders));

      if (res.statusCode == 200) {
        List list = jsonDecode(res.body);
        return list.map((e) => OrderModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error get orders: $e");
      return [];
    }
  }

  // Lấy đơn theo ID
  static Future<OrderModel?> getOrderById(int id) async {
    try {
      final res = await http.get(Uri.parse(ApiConstants.orderById(id)));

      if (res.statusCode == 200) {
        return OrderModel.fromJson(jsonDecode(res.body));
      }
      return null;
    } catch (e) {
      print("Error get order by id: $e");
      return null;
    }
  }

  // Cập nhật trạng thái đơn (Admin)
  static Future<bool> updateStatus(int id, int typeConfirmId) async {
    try {
      final res = await http.put(
        Uri.parse(ApiConstants.updateOrderStatus(id)),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "type_confirm_id": typeConfirmId,
        }),
      );

      return res.statusCode == 200;
    } catch (e) {
      print("Error update order status: $e");
      return false;
    }
  }
}
