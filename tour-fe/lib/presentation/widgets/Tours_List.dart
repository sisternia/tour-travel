import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/constants/color.dart';
import '../screens/tour/details_tour_screen.dart';

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
    Navigator.of(context).push(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ============ IMAGE + BADGES (NEW) ============
          Stack(
            children: [
              Container(
                width: 140,
                height: 140,
                margin: const EdgeInsets.all(8),
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
                left: 16,
                top: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people, size: 13, color: Colors.blue),
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
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
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

                  /// CATEGORY & DURATION
                  Row(
                    children: [
                      Icon(Ionicons.calendar_outline,
                          size: 14, color: Colors.orange.shade800),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          duration,
                          style: const TextStyle(fontSize: 12, color: darkGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  /// DEPARTURE → DESTINATION
                  Row(
                    children: [
                      const Icon(Ionicons.compass_outline,
                          size: 14, color: darkGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          departure,
                          style: const TextStyle(fontSize: 12, color: darkGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Ionicons.remove_outline,
                          size: 12, color: darkGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          destination,
                          style: const TextStyle(fontSize: 12, color: darkGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  /// PRICE & BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // PRICES
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Người lớn: $priceAdult",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            "Trẻ em: $priceChild",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () => _navigateToDetails(context),
                        child: const Icon(
                          Ionicons.information_circle_outline,
                          size: 24,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
