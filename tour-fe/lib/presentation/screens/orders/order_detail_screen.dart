// lib\presentation\screens\orders\order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../services/order_service.dart';
import '../../../controllers/payment_controller.dart';
import '../../../data/models/order_model.dart';
import '../../widgets/Rating_Dialog.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? order;
  bool loading = true;

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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  Widget _statusTag(int id) {
    String text = "";
    Color color = Colors.grey;

    switch (id) {
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
      case 4:
        text = "Đã hoàn thành";
        color = Colors.purple;
        break;
      default:
        text = "Không rõ";
        color = Colors.black45;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 3),
            color: Colors.black12,
          )
        ],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {Color valueColor = Colors.black87, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _vnpayButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        await PaymentController.payWithVnpay(
          context: context,
          orderId: widget.orderId,
          amount: order!.total.toInt(),
        );
        Future.delayed(const Duration(seconds: 1), () => loadOrder());
      },
      icon: const Icon(Ionicons.card_outline, color: Colors.white),
      label: const Text(
        "Thanh toán VNPAY",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _markCompletedButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final ok = await OrderService.markUserCompleted(order!.id);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bạn đã xác nhận hoàn thành tour")),
          );
          loadOrder();
        }
      },
      icon: const Icon(Ionicons.checkmark_circle_outline, color: Colors.white),
      label: const Text(
        "Đánh dấu đã hoàn thành",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _rateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => RatingDialog(
            tourId: order!.tourId,
            onRated: () async {
              await loadOrder();
            },
          ),
        );
      },
      icon: const Icon(Ionicons.star_outline, color: Colors.white),
      label: const Text(
        "Đánh giá tour",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _ratedButton() {
    return ElevatedButton.icon(
      onPressed: null,
      icon: const Icon(Ionicons.checkmark_circle_outline, color: Colors.white),
      label: const Text(
        "Đã đánh giá",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6ff),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : order == null
                ? const Center(child: Text("Không tìm thấy đơn hàng"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 28),
                              Text(
                                "Đơn hàng #${widget.orderId}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.close,
                                    size: 28, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        Row(children: [_statusTag(order!.typeConfirmId)]),
                        _sectionCard("Thông tin Tour", [
                          _infoRow(Ionicons.location_outline, "Tên tour",
                              order!.tourName ?? "—"),
                        ]),
                        _sectionCard("Thông tin khách hàng", [
                          _infoRow(Ionicons.person_outline, "Tên khách",
                              order!.nameTourist),
                          _infoRow(Ionicons.call_outline, "Điện thoại",
                              order!.phoneTourist),
                          _infoRow(Ionicons.mail_outline, "Email",
                              order!.emailTourist),
                          _infoRow(Ionicons.document_text_outline, "Ghi chú",
                              order!.note ?? "—"),
                        ]),
                        _sectionCard("Số lượng", [
                          _infoRow(Ionicons.body_outline, "Người lớn",
                              "${order!.numberOfAdult}"),
                          _infoRow(Ionicons.happy_outline, "Trẻ em",
                              "${order!.numberOfChild}"),
                        ]),
                        _sectionCard("Thanh toán", [
                          _infoRow(
                            Ionicons.pricetag_outline,
                            "Tổng tiền",
                            "${order!.total.toString().replaceAllMapped(
                                  RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                  (m) => '.',
                                )} VNĐ",
                            valueColor: Colors.red,
                            bold: true,
                          ),
                          _infoRow(Ionicons.calendar_outline, "Ngày đặt",
                              _formatDate(order!.orderAt)),
                        ]),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: order == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: _buildBottomButton(),
            ),
    );
  }

  Widget? _buildBottomButton() {
    if (order!.typeConfirmId == 1) return _vnpayButton();
    if (order!.typeConfirmId == 2) return _markCompletedButton();

    if (order!.typeConfirmId == 4) {
      return order!.isRated == 1 ? _ratedButton() : _rateButton();
    }

    return null;
  }
}
