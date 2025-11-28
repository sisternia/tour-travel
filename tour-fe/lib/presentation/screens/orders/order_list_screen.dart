import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../services/order_service.dart';
import '../../../data/models/order_model.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<OrderModel> orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final result = await OrderService.getOrdersByUser();
      setState(() {
        orders = result;
        loading = false;
      });
    } catch (e) {
      debugPrint("LOAD ORDER ERROR: $e");
      setState(() => loading = false);
    }
  }

  Widget _buildStatus(int status) {
    String text = "";
    Color color = Colors.grey;

    switch (status) {
      case 1:
        text = "Chưa thanh toán";
        color = Colors.orange;
        break;

      case 2:
        text = "Admin đã xác nhận thành công";
        color = Colors.green;
        break;

      case 3:
        text = "Đã thanh toán - chờ duyệt";
        color = Colors.blue;
        break;

      default:
        text = "Không xác định";
        color = Colors.black45;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style:
            TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _orderCard(OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: order.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: const Offset(0, 3),
              color: Colors.black12.withOpacity(0.15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đơn hàng #${order.id}",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                _buildStatus(order.typeConfirmId),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Ionicons.person_outline,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(order.nameTourist,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Ionicons.calendar_outline,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  "${order.orderAt.day.toString().padLeft(2, '0')}/"
                  "${order.orderAt.month.toString().padLeft(2, '0')}/"
                  "${order.orderAt.year}",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Ionicons.pricetag_outline,
                    size: 20, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  "${order.total.toString().replaceAllMapped(
                        RegExp(r'\B(?=(\d{3})+(?!\d))'),
                        (m) => '.',
                      )} VNĐ",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6ff),
      appBar: AppBar(
        title: const Text("Quản lý đơn hàng"),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    "Bạn chưa có đơn hàng nào",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadOrders,
                  child: ListView.builder(
                    itemCount: orders.length,
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) => _orderCard(orders[index]),
                  ),
                ),
    );
  }
}
