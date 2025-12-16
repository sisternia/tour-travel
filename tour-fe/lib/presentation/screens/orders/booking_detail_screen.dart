// lib\presentation\screens\orders\booking_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../controllers/payment_controller.dart';
import '../../../services/order_service.dart';
import '../../../data/models/order_model.dart';
import 'payment_success_screen.dart';
import '../../../core/constants/color.dart';

class BookingDetailScreen extends StatefulWidget {
  final int orderId;

  const BookingDetailScreen({super.key, required this.orderId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen>
    with SingleTickerProviderStateMixin {
  OrderModel? order;
  bool loading = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    loadOrder();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
      Future.delayed(const Duration(milliseconds: 700), () {
        _checkPaymentSuccess();
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> loadOrder() async {
    final result = await OrderService.getOrderById(widget.orderId);
    setState(() {
      order = result;
      loading = false;
    });
  }

  Future<void> _checkPaymentSuccess() async {
    final updatedOrder = await OrderService.getOrderById(widget.orderId);

    if (updatedOrder != null && updatedOrder.typeConfirmId == 3) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f0f8),
      appBar: AppBar(
        title: Text("Đơn hàng #${widget.orderId}"),
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        foregroundColor: Colors.black87,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: tPrimaryColor),
            )
          : order == null
              ? const Center(child: Text("Không tìm thấy đơn hàng"))
              : FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _vnpaySection("Thông tin khách hàng"),
                          _vnpayCard([
                            _vnpayRow("Tên khách", order!.nameTourist,
                                Ionicons.person_outline),
                            _vnpayRow("Số điện thoại", order!.phoneTourist,
                                Ionicons.call_outline),
                            _vnpayRow("Email", order!.emailTourist,
                                Ionicons.mail_outline),
                            _vnpayRow("Ghi chú", order!.note ?? "—",
                                Ionicons.document_text_outline),
                          ]),
                          const SizedBox(height: 26),
                          _vnpaySection("Chi tiết số lượng"),
                          _vnpayCard([
                            _vnpayRow("Người lớn", "${order!.numberOfAdult}",
                                Ionicons.body_outline),
                            _vnpayRow("Trẻ em", "${order!.numberOfChild}",
                                Ionicons.happy_outline),
                          ]),
                          const SizedBox(height: 26),
                          _vnpaySection("Thanh toán"),
                          _vnpayCard([
                            _vnpayRow(
                              "Tổng tiền",
                              "${order!.total.toString().replaceAllMapped(
                                    RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                    (m) => '.',
                                  )} VNĐ",
                              Ionicons.pricetag_outline,
                              valueColor: Colors.red,
                              bold: true,
                            ),
                            _vnpayRow("Ngày đặt", _formatDate(order!.orderAt),
                                Ionicons.calendar_outline),
                          ]),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: order == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await PaymentController.payWithVnpay(
                      context: context,
                      orderId: widget.orderId,
                      amount: order!.total.toInt(),
                    );

                    Future.delayed(const Duration(seconds: 2), () {
                      _checkPaymentSuccess();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Lỗi thanh toán: $e",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Ionicons.card_outline, color: Colors.white),
                label: const Text(
                  "Thanh toán VNPAY",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _vnpaySection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: tPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vnpayCard(List<Widget> children) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black12.withOpacity(.08),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _vnpayRow(
    String label,
    String value,
    IconData icon, {
    Color valueColor = Colors.black87,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tPrimaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tPrimaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              color: valueColor,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
