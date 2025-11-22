import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/tour_prices_model.dart';
import 'package:tour_fe/services/tour_prices_service.dart';
import 'package:tour_fe/services/tours_service.dart';
import 'package:intl/intl.dart';

class TabTourWidget extends StatefulWidget {
  final String description;
  final int tourId;

  /// 👉 Callback gửi giá người lớn + trẻ em lên màn detail
  final Function(double adultPrice, double childPrice)? onPriceLoaded;

  const TabTourWidget({
    super.key,
    required this.description,
    required this.tourId,
    this.onPriceLoaded,
  });

  @override
  State<TabTourWidget> createState() => _TabTourWidgetState();
}

class _TabTourWidgetState extends State<TabTourWidget> {
  int selectedTab = 0;

  final TourPricesService _pricesService = TourPricesService();
  final ToursService _toursService = ToursService();

  late Future<List<TourPriceAssignmentModel>> _futureAssignment;
  late Future<Map<String, dynamic>> _futureTourInfo;

  bool _priceSent = false;

  /// 👈 Thêm biến này để tránh gọi lại nhiều lần

  @override
  void initState() {
    super.initState();
    _futureAssignment = _pricesService.fetchAssignmentByTour(widget.tourId);
    _futureTourInfo = _loadTourInfo();
  }

  Future<Map<String, dynamic>> _loadTourInfo() async {
    final all = await _toursService.fetchTours();
    final found = all.firstWhere(
      (t) => t.id == widget.tourId,
      orElse: () => throw Exception("Tour không tồn tại"),
    );

    return {
      "numberOfPeople": found.numberOfPeople,
      "status": found.status,
    };
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    final d = DateTime.tryParse(date);
    if (d == null) return "-";
    return DateFormat("dd/MM/yyyy").format(d);
  }

  @override
  Widget build(BuildContext context) {
    const tabs = ["Mô tả", "Bảng giá", "Bình luận"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(tabs.length, (i) {
            final isSelected = selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedTab = i),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        tabs[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? primaryColor : darkGrey,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 3,
                      width: 28,
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        if (selectedTab == 0)
          Text(
            widget.description,
            style: const TextStyle(fontSize: 16, color: darkGrey, height: 1.5),
          ),
        if (selectedTab == 1)
          FutureBuilder(
            future: Future.wait([_futureAssignment, _futureTourInfo]),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snap.hasError) {
                return Text("Lỗi tải bảng giá: ${snap.error}");
              }

              final assignments =
                  snap.data![0] as List<TourPriceAssignmentModel>;
              final tourData = snap.data![1] as Map<String, dynamic>;

              if (assignments.isEmpty) {
                return const Text(
                  "Chưa có bảng giá cho tour này.",
                  style: TextStyle(fontSize: 16, color: darkGrey),
                );
              }

              /// 👉 Chỉ gửi giá 1 lần duy nhất
              if (!_priceSent && widget.onPriceLoaded != null) {
                _priceSent = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onPriceLoaded!(
                    assignments.first.priceAdult,
                    assignments.first.priceChild,
                  );
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: assignments.map((a) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Giá người lớn: ${_formatCurrency(a.priceAdult)}",
                            style:
                                const TextStyle(fontSize: 16, color: darkGrey)),
                        Text("Giá trẻ em: ${_formatCurrency(a.priceChild)}",
                            style:
                                const TextStyle(fontSize: 16, color: darkGrey)),
                        Text(
                          "Áp dụng: ${formatDate(a.validFrom)} → ${formatDate(a.validTo)}",
                          style: const TextStyle(fontSize: 16, color: darkGrey),
                        ),
                        const SizedBox(height: 8),
                        Text("Số lượng: ${tourData["numberOfPeople"]}",
                            style:
                                const TextStyle(fontSize: 16, color: darkGrey)),
                        Text("Trạng thái: ${tourData["status"]}",
                            style:
                                const TextStyle(fontSize: 16, color: darkGrey)),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        if (selectedTab == 2)
          const Text("Chưa có bình luận nào.",
              style: TextStyle(fontSize: 16, color: darkGrey)),
      ],
    );
  }

  String _formatCurrency(double value) {
    final intValue = value.round();
    return intValue
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+$)'), (m) => "${m[1]}.");
  }
}
