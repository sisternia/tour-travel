// lib/presentation/screens/tour/details_tour_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../core/constants/color.dart';
import '../../../data/models/tour_images_model.dart';
import '../../../services/tour_images_service.dart';
import '../../widgets/Image_List.dart';
import '../../widgets/NavigationBar.dart';
import '../../widgets/Tab_Tour.dart';
import '../../widgets/Button.dart';
import 'tour_locations_screen.dart';

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

class _DetailsCardScreenState extends State<DetailsCardScreen>
    with SingleTickerProviderStateMixin {
  final TourImagesService _imgService = TourImagesService();
  late Future<List<TourImageModel>> _futureImages;

  int selectedIndex = 0;
  List<String> images = [];
  bool isLoved = false;

  @override
  void initState() {
    super.initState();
    _futureImages = _imgService.getAllImages(widget.tourId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                ? data.map((e) => e.tourImg ?? "").toList()
                : ["https://via.placeholder.com/400"];

            return Stack(
              children: [
                Column(
                  children: [
                    buildImageSection(images),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                        child: buildInfoSection(),
                      ),
                    ),
                  ],
                ),

                /// NÚT ĐẶT TOUR — FIXED BOTTOM
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: Colors.white,
                    child: PrimaryButton(
                      text: "Đặt Tour",
                      onPressed: () {},
                      loading: false,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildImageSection(List<String> images) {
    return StatefulBuilder(
      builder: (context, setState) {
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

            /// BACK + HEART
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
                              const NavigationBarWidget(initialIndex: 1),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final slide = Tween(
                              begin: const Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic),
                            );
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
                  GestureDetector(
                    onTap: () {
                      setState(() => isLoved = !isLoved);
                    },
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 1.0, end: isLoved ? 1.3 : 1.0),
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Icon(
                                isLoved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLoved ? Colors.red : primaryColor,
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// IMAGE LIST
            if (images.length > 1)
              ImageListWidget(
                images: images,
                selectedIndex: selectedIndex,
                onSelect: (i) => setState(() => selectedIndex = i),
              ),

            /// RATING
            Positioned(
              bottom: -32,
              right: 32,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 26),
                    const SizedBox(height: 4),
                    Text(
                      widget.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TourLocationsScreen(tourId: widget.tourId),
                  ),
                );
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Ionicons.location_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.country,
                    style: const TextStyle(
                      fontSize: 16,
                      color: darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TabTourWidget(
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
          tourId: widget.tourId,
        ),
      ],
    );
  }
}
