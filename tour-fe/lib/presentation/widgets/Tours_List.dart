// lib/presentation/widgets/Tours_List.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/constants/color.dart';
import '../screens/tour/details_tour_screen.dart';

class TourCard extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final String country;
  final String category;
  final String departure;
  final String destination;
  final double rating;

  const TourCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.country,
    required this.category,
    required this.departure,
    required this.destination,
    required this.rating,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailsCardScreen(
          tourId: id,
          title: title,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
          final scale = Tween(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          );

          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }

  IconData get destinationIcon =>
      category == "Quốc tế" ? Ionicons.earth_outline : Ionicons.compass_outline;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: kcontentColor,
                  child: const Center(child: Icon(Ionicons.image_outline)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Ionicons.compass_outline,
                          size: 16, color: darkGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          departure,
                          style: const TextStyle(fontSize: 12, color: darkGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          8,
                          (index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.0),
                            child: Icon(
                              Ionicons.remove_outline,
                              size: 12,
                              color: darkGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(destinationIcon, size: 16, color: darkGrey),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Ionicons.star,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _navigateToDetails(context),
                        child: const Icon(
                          Ionicons.alert_circle_outline,
                          color: primaryColor,
                          size: 22,
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
