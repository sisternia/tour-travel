// lib/presentation/screens/tour/details_tour_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../core/constants/color.dart';
import '../../../core/constants/api.dart';
import '../../../data/models/tour_images_model.dart';
import '../../../services/tour_images_service.dart';
import 'tourist_spot_screen.dart';

class DetailsCardScreen extends StatefulWidget {
  final int tourId;
  final String title;
  final String country;
  final String category;
  final double rating;

  const DetailsCardScreen({
    super.key,
    required this.tourId,
    required this.title,
    this.country = "Việt Nam",
    this.category = "Trong nước",
    this.rating = 4.8,
  });

  @override
  State<DetailsCardScreen> createState() => _DetailsCardScreenState();
}

class _DetailsCardScreenState extends State<DetailsCardScreen> {
  final TourImagesService _imgService = TourImagesService();
  late Future<List<TourImageModel>> _futureImages;

  int selectedIndex = 0;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _futureImages = _imgService.getAllImages(widget.tourId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<TourImageModel>>(
          future: _futureImages,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snap.hasError) {
              return Center(
                child: Text(
                  "Lỗi tải ảnh: ${snap.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final data = snap.data ?? [];
            images = data.isNotEmpty
                ? data
                    .map((e) => ApiConstants.baseUrl + (e.tourImg ?? ""))
                    .toList()
                : ["https://via.placeholder.com/400"];

            return Column(
              children: [
                buildImageSection(images),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: buildInfoSection(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 🖼️ PHẦN ẢNH
  Widget buildImageSection(List<String> images) {
    int extra = images.length > 3 ? images.length - 2 : 0;

    return StatefulBuilder(
      builder: (context, setState) {
        // Auto slide
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && images.length > 1) {
            setState(() => selectedIndex = (selectedIndex + 1) % images.length);
          }
        });

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: const BoxDecoration(
                color: kcontentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.network(
                  images[selectedIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Nút Back + Tiêu đề
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, a, b) =>
                              const TouristSpotScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final slide = Tween(
                              begin: const Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: animation, curve: Curves.easeOutCubic));
                            return SlideTransition(
                                position: slide, child: child);
                          },
                        ),
                      );
                    },
                    child: const Icon(
                      Ionicons.arrow_undo_outline,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Icon(
                    Ionicons.eyedrop_outline,
                    color: primaryColor,
                    size: 28,
                  ),
                ],
              ),
            ),

            // Ô ảnh nhỏ
            if (images.length > 1)
              Positioned(
                bottom: 12,
                left: 12,
                child: Column(
                  children: List.generate(
                    images.length <= 3 ? images.length : 3,
                    (i) {
                      bool isLast = i == 2 && images.length > 3;
                      bool isSelected = selectedIndex == i;

                      return GestureDetector(
                        onTap: () {
                          if (!isLast) {
                            setState(() => selectedIndex = i);
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? tPrimaryColor : Colors.white,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: isLast
                                ? Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Center(
                                      child: Text(
                                        "+$extra",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    images[i],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // 🔎 Phần mô tả dưới ảnh
  Widget buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const Icon(Ionicons.location_outline, color: darkGrey, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.country,
          style: const TextStyle(fontSize: 18, color: darkGrey),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Ionicons.star, color: Colors.amber, size: 30),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.rating.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("4.500",
                        style: TextStyle(fontSize: 14, color: darkGrey)),
                  ],
                ),
              ],
            ),
            const Row(
              children: [
                Icon(Ionicons.heart_outline, color: primaryColor, size: 30),
                SizedBox(width: 6),
                Text("1.200", style: TextStyle(fontSize: 16, color: darkGrey)),
              ],
            ),
            const Row(
              children: [
                Icon(Ionicons.chatbubble_outline,
                    color: primaryColor, size: 30),
                SizedBox(width: 6),
                Text("350", style: TextStyle(fontSize: 16, color: darkGrey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
          "Phasellus feugiat, urna vel vestibulum fermentum...",
          style: TextStyle(
            fontSize: 16,
            color: darkGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
