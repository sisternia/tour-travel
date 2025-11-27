// lib\presentation\screens\tour\booking_tour_screen.dart
import 'package:flutter/material.dart';
import '../../../services/order_service.dart';
import 'package:ionicons/ionicons.dart';
import '../../widgets/Button.dart';
import '../../widgets/TextField.dart';
import 'booking_detail_screen.dart';
import '../../../services/token_service.dart';

class BookingTourScreen extends StatefulWidget {
  final int tourId;
  final int priceAdult;
  final int priceChild;

  const BookingTourScreen({
    super.key,
    required this.tourId,
    required this.priceAdult,
    required this.priceChild,
  });

  @override
  State<BookingTourScreen> createState() => _BookingTourScreenState();
}

class _BookingTourScreenState extends State<BookingTourScreen> {
  final _formKey = GlobalKey<FormState>();

  int adult = 1;
  int child = 0;

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();

  int get total => adult * widget.priceAdult + child * widget.priceChild;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- TITLE ---
              const Text(
                "Thông tin số lượng",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              /// Người lớn
              _buildNumberSelector(
                title: "Người lớn",
                value: adult,
                icon: Ionicons.person,
                onAdd: () => setState(() => adult++),
                onMinus: () {
                  if (adult > 1) setState(() => adult--);
                },
              ),

              const SizedBox(height: 15),

              /// Trẻ em
              _buildNumberSelector(
                title: "Trẻ em",
                value: child,
                icon: Ionicons.happy_outline,
                onAdd: () => setState(() => child++),
                onMinus: () {
                  if (child > 0) setState(() => child--);
                },
              ),

              const SizedBox(height: 30),
              const Text(
                "Thông tin liên hệ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildInput("Tên người đặt", nameCtrl,
                  validator: (v) => v!.isEmpty ? "Vui lòng nhập tên" : null,
                  icon: Ionicons.person_circle_outline),

              _buildInput("Số điện thoại", phoneCtrl,
                  validator: (v) =>
                      v!.isEmpty ? "Vui lòng nhập số điện thoại" : null,
                  keyboard: TextInputType.phone,
                  icon: Ionicons.call_outline),

              _buildInput("Email", emailCtrl,
                  keyboard: TextInputType.emailAddress,
                  icon: Ionicons.mail_outline),

              _buildInput("Ghi chú (không bắt buộc)", noteCtrl,
                  maxLines: 3, icon: Ionicons.document_text_outline),

              const SizedBox(height: 20),

              /// PRICE BOX
              _buildPriceBox(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.redAccent, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Hủy",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: PrimaryButton(
                text: "Xác nhận",
                loading: loading,
                onPressed: _submitOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {int maxLines = 1,
      String? Function(String?)? validator,
      TextInputType keyboard = TextInputType.text,
      IconData? icon}) {
    return CustomTextField(
      controller: controller,
      label: label,
      validator: validator,
      keyboardType: keyboard,
      maxLines: maxLines,
      icon: icon,
    );
  }

  Widget _buildNumberSelector({
    required String title,
    required int value,
    required IconData icon,
    required Function onAdd,
    required Function onMinus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 1),
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          Row(
            children: [
              _circleBtn(Icons.remove, onMinus),
              const SizedBox(width: 12),
              Text("$value",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              _circleBtn(Icons.add, onAdd),
            ],
          )
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildPriceBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tổng tiền:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(
            "${total.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} VNĐ",
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final tokenService = TokenService();
    final userId = await tokenService.getUserId();

    if (userId == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy tài khoản người dùng!")),
      );
      return;
    }

    final orderId = await OrderService.createOrder({
      "number_of_child": child,
      "number_of_adult": adult,
      "name_tourist": nameCtrl.text,
      "phone_tourist": phoneCtrl.text,
      "email_tourist": emailCtrl.text,
      "total": total,
      "note": noteCtrl.text,
      "user_id": userId,
      "tour_id": widget.tourId,
    });

    setState(() => loading = false);

    if (orderId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailScreen(orderId: orderId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo đơn hàng thất bại!")),
      );
    }
  }
}
