// lib/presentation/widgets/Card.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/constants/color.dart';
import '../screens/details_card_screen.dart';

class TourCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String country;
  final String category;
  final double rating;

  const TourCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.country,
    required this.category,
    required this.rating,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailsCardScreen(title: title),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Hiệu ứng fade + scale
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
          // Ảnh bên trái
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

          // Nội dung bên phải
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP: title + ghim + country
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Ionicons.eyedrop_outline,
                            color: primaryColor,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        country,
                        style: const TextStyle(
                          fontSize: 14,
                          color: darkGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // MIDDLE: route
                  Row(
                    children: [
                      const Icon(Ionicons.compass_outline,
                          size: 16, color: darkGrey),
                      const SizedBox(width: 4),
                      const Text(
                        "Việt Nam",
                        style: TextStyle(fontSize: 12, color: darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            6,
                            (i) => const Icon(
                              Ionicons.remove_outline,
                              size: 12,
                              color: darkGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        category == "Ngoài nước"
                            ? Ionicons.earth_outline
                            : Ionicons.location_outline,
                        size: 16,
                        color: darkGrey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          category == "Ngoài nước" ? country : "Việt Nam",
                          style: const TextStyle(
                            fontSize: 12,
                            color: darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // BOTTOM: rating + alert icon
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
