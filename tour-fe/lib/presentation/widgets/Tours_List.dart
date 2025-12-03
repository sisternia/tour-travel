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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Container(
            width: 130,
            height: 130,
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

          // TEXT CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// DURATION
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
                  const SizedBox(height: 4),

                  /// ROUTE
                  Row(
                    children: [
                      const Icon(Ionicons.compass_outline,
                          size: 14, color: darkGrey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          departure,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: darkGrey),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Ionicons.remove_outline,
                          size: 12, color: darkGrey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          destination,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: darkGrey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// PRICE + MORE BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Người lớn: $priceAdult",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            Text(
                              "Trẻ em: $priceChild",
                              maxLines: 1,
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
