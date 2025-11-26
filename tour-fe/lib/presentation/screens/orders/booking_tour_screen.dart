import 'package:flutter/material.dart';
import '../../../services/order_service.dart';
import 'package:ionicons/ionicons.dart';
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Đặt Tour",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleSection("Thông tin số lượng"),
              _buildModernSelector(
                title: "Người lớn",
                value: adult,
                icon: Ionicons.person_outline,
                onAdd: () => setState(() => adult++),
                onMinus: () {
                  if (adult > 1) setState(() => adult--);
                },
              ),
              _buildModernSelector(
                title: "Trẻ em",
                value: child,
                icon: Ionicons.happy_outline,
                onAdd: () => setState(() => child++),
                onMinus: () {
                  if (child > 0) setState(() => child--);
                },
              ),
              const SizedBox(height: 28),
              _titleSection("Thông tin liên hệ"),
              _buildModernInput("Tên người đặt", nameCtrl,
                  validator: (v) => v!.isEmpty ? "Vui lòng nhập tên" : null,
                  icon: Ionicons.person_circle_outline),
              _buildModernInput("Số điện thoại", phoneCtrl,
                  validator: (v) =>
                      v!.isEmpty ? "Vui lòng nhập số điện thoại" : null,
                  keyboard: TextInputType.phone,
                  icon: Ionicons.call_outline),
              _buildModernInput("Email", emailCtrl,
                  keyboard: TextInputType.emailAddress,
                  icon: Ionicons.mail_outline),
              _buildModernInput("Ghi chú (không bắt buộc)", noteCtrl,
                  maxLines: 3, icon: Ionicons.document_text_outline),
              const SizedBox(height: 20),
              _buildPriceCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: loading ? null : _submitOrder,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xff1A73E8), Color(0xff0077FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            "Xác nhận đặt tour",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xff0A3D62),
        ),
      ),
    );
  }

  Widget _buildModernInput(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12.withOpacity(0.05),
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xff0077FF)),
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildModernSelector({
    required String title,
    required int value,
    required IconData icon,
    required Function onAdd,
    required Function onMinus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 1,
            color: Colors.black12.withOpacity(0.07),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Color(0xff0077FF)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          Row(
            children: [
              _circleActionBtn(Icons.remove, onMinus),
              const SizedBox(width: 16),
              Text(
                "$value",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              _circleActionBtn(Icons.add, onAdd),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleActionBtn(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
              blurRadius: 6,
              color: Colors.black12.withOpacity(0.1),
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Tổng tiền:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            "${total.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} VNĐ",
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
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
