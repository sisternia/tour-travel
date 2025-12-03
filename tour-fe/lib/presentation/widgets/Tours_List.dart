// lib/presentation/widgets/Tours_List.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/constants/color.dart';
import '../screens/orders/details_tour_screen.dart';

class TourCard extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final String category;
  final String departure;
  final String destination;
  final double rating;
  final int people;
  final String duration;
  final String priceAdult;
  final String priceChild;

  const TourCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.departure,
    required this.destination,
    required this.rating,
    required this.people,
    required this.duration,
    required this.priceAdult,
    required this.priceChild,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsCardScreen(
          tourId: id,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: kcontentColor,
                          child: const Center(
                            child: Icon(Ionicons.image_outline, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 13, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
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
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people,
                              size: 13, color: Colors.blue),
                          const SizedBox(width: 3),
                          Text(
                            "$people",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Ionicons.calendar_outline,
                            size: 14, color: Colors.orange.shade800),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            duration,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontSize: 12, color: darkGrey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Ionicons.compass_outline,
                            size: 14, color: darkGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            departure,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontSize: 12, color: darkGrey),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Ionicons.remove_outline,
                            size: 12, color: darkGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontSize: 12, color: darkGrey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Người lớn: $priceAdult",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              Text(
                                "Trẻ em: $priceChild",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FittedBox(
                          child: GestureDetector(
                            onTap: () => _navigateToDetails(context),
                            child: const Icon(
                              Ionicons.information_circle_outline,
                              size: 24,
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
