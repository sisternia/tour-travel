// lib\services\order_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';
import '../core/utils/Order_Center.dart';
import '../data/models/order_model.dart';
import '../services/token_service.dart';

class OrderService {
  static Future<int?> createOrder(Map<String, dynamic> data) async {
    final url = Uri.parse(ApiConstants.orders);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("CREATE ORDER RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json["order_id"];
      }

      return null;
    } catch (e) {
      print("CREATE ORDER ERROR: $e");
      return null;
    }
  }

  static Future<String> createMomoPayment({
    required int orderId,
    required int amount,
  }) async {
    final url = Uri.parse(ApiConstants.momoPayment);

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"orderId": orderId, "amount": amount}),
    );

    final data = jsonDecode(res.body);
    return data["payUrl"];
  }

  static Future<List<OrderModel>> getOrders() async {
    try {
      final res = await http.get(Uri.parse(ApiConstants.orders));
      if (res.statusCode == 200) {
        List json = jsonDecode(res.body);
        return json.map((e) => OrderModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error get orders: $e");
      return [];
    }
  }

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

  static Future<bool> updateStatus(int id, int typeConfirmId) async {
    try {
      final res = await http.put(
        Uri.parse(ApiConstants.updateOrderStatus(id)),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"type_confirm_id": typeConfirmId}),
      );

      return res.statusCode == 200;
    } catch (e) {
      print("Error update order status: $e");
      return false;
    }
  }

  static Future<List<OrderModel>> getOrdersByUser() async {
    try {
      final userId = await TokenService().getUserId();

      if (userId == null) {
        print("ERROR: userId is NULL in storage!");
        return [];
      }

      print("➡ Fetching orders for userId: $userId");

      final url = Uri.parse("${ApiConstants.orders}/user/$userId");

      final res = await http.get(url);

      print("ORDER BY USER RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        List list = jsonDecode(res.body);
        final orders = list.map((e) => OrderModel.fromJson(e)).toList();
        final pendingCount = orders.where((o) => o.typeConfirmId == 1).length;
        OrderCenter.instance.setCount(pendingCount);
        return orders;
      }

      return [];
    } catch (e) {
      print("ERROR get orders by user: $e");
      return [];
    }
  }

  static Future<void> fetchPendingCount() async {
    try {
      final orders = await getOrdersByUser();
      final pendingCount = orders.where((o) => o.typeConfirmId == 1).length;
      OrderCenter.instance.setCount(pendingCount);
    } catch (e) {
      print("ERROR fetch pending count: $e");
    }
  }

  static Future<bool> markUserCompleted(int orderId) async {
    try {
      final userId = await TokenService().getUserId();

      if (userId == null) {
        print("ERROR: userId is NULL in markUserCompleted!");
        return false;
      }

      final url = Uri.parse(ApiConstants.userCompleted(orderId));

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      print("USER COMPLETED RESPONSE: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      print("ERROR markUserCompleted: $e");
      return false;
    }
  }
}
