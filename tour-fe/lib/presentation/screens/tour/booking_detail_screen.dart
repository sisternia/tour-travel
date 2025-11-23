import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../controllers/payment_controller.dart';
import '../../../services/order_service.dart';
import '../../../data/models/order_model.dart';

class BookingDetailScreen extends StatefulWidget {
  final int orderId;

  const BookingDetailScreen({super.key, required this.orderId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  OrderModel? order;
  bool loading = true;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    final result = await OrderService.getOrderById(widget.orderId);
    setState(() {
      order = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6ff),
      appBar: AppBar(
        title: Text("Đơn hàng #${widget.orderId}"),
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,
        foregroundColor: Colors.black87,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : order == null
              ? const Center(child: Text("Không tìm thấy đơn hàng"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Thông tin khách hàng"),
                      _buildInfoCard([
                        _infoRow(
                            "Tên khách", order!.nameTourist, Ionicons.person),
                        _infoRow("Số điện thoại", order!.phoneTourist,
                            Ionicons.call_outline),
                        _infoRow("Email", order!.emailTourist,
                            Ionicons.mail_outline),
                        _infoRow("Ghi chú", order!.note ?? "—",
                            Ionicons.document_text_outline),
                      ]),
                      const SizedBox(height: 26),
                      _buildSectionTitle("Chi tiết số lượng"),
                      _buildInfoCard([
                        _infoRow("Người lớn", "${order!.numberOfAdult}",
                            Ionicons.body_outline),
                        _infoRow("Trẻ em", "${order!.numberOfChild}",
                            Ionicons.happy_outline),
                      ]),
                      const SizedBox(height: 26),
                      _buildSectionTitle("Thanh toán"),
                      _buildInfoCard([
                        _infoRow(
                          "Tổng tiền",
                          "${order!.total.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} VNĐ",
                          Ionicons.pricetag_outline,
                          valueColor: Colors.red,
                          bold: true,
                        ),
                        _infoRow("Ngày đặt", _formatDate(order!.orderAt),
                            Ionicons.calendar_outline),
                      ]),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
      bottomNavigationBar: order == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, -2))
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await PaymentController.payWithVnPay(
                      amount: order!.total.toInt(),
                      orderId: widget.orderId,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi thanh toán: $e")),
                    );
                  }
                },
                icon: const Icon(Ionicons.card_outline, color: Colors.white),
                label: const Text(
                  "Thanh toán VNPAY",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 134, 224, 224),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffeef2ff), Color(0xffffffff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(
    String label,
    String value,
    IconData icon, {
    Color valueColor = Colors.black87,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 91, 203, 222), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              color: valueColor,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
