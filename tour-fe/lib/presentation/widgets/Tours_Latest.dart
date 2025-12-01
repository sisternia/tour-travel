import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_fe/data/models/tours_model.dart';
import 'package:tour_fe/presentation/screens/orders/details_tour_screen.dart';

class ToursLatest extends StatelessWidget {
  final List<ToursModel> tours;

  ToursLatest({super.key, required this.tours});

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  String getDuration(String start, String end) {
    try {
      final d1 = DateTime.parse(start);
      final d2 = DateTime.parse(end);
      final diff = d2.difference(d1).inDays;

      if (diff <= 0) return "1 ngày";

      final nights = diff;
      final days = diff + 1;

      return "$days ngày $nights đêm";
    } catch (_) {
      return "Không rõ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tours.map((tour) {
        final priceAdult = currencyFormat.format(tour.priceAdult);
        final priceChild = currencyFormat.format(tour.priceChild);
        final people = tour.numberOfPeople;
        final duration = getDuration(tour.startDate, tour.endDate);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(
                      tour.firstImage.isNotEmpty
                          ? tour.firstImage
                          : "https://via.placeholder.com/300",
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            "4.7",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people,
                              size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            "$people",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 7, 45, 77),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 20, color: Color.fromARGB(255, 172, 164, 2)),
                        const SizedBox(width: 6),
                        Text(duration,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 95, 93, 93),
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person,
                                    color: Colors.green.shade700, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  priceAdult,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green.shade700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.child_care,
                                    color: Colors.orange.shade700, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  priceChild,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.orange.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DetailsCardScreen(
                                  tourId: tour.id,
                                  title: tour.name,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Xem chi tiết",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
