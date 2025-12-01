// lib/presentation/screens/tour/details_tour_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../core/constants/color.dart';
import '../../../data/models/tour_images_model.dart';
import '../../../services/tour_images_service.dart';
import '../../widgets/Tab_Tour.dart';
import '../../widgets/Button.dart';
import '../../widgets/Image_List.dart';
import 'booking_tour_screen.dart';
import '../../screens/tour/tour_locations_screen.dart';

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

  double? priceAdult;
  double? priceChild;

  Timer? slideTimer;

  @override
  void initState() {
    super.initState();
    _futureImages = _imgService.getAllImages(widget.tourId);
  }

  @override
  void dispose() {
    slideTimer?.cancel();
    super.dispose();
  }

  void startAutoSlide() {
    slideTimer?.cancel();
    slideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || images.length <= 1) return;
      setState(() {
        selectedIndex = (selectedIndex + 1) % images.length;
      });
    });
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

            startAutoSlide();

            return Stack(
              children: [
                Column(
                  children: [
                    buildImageSection(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                        child: buildInfoSection(),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: PrimaryButton(
                      text: "Đặt Tour",
                      onPressed: () {
                        if (priceAdult == null || priceChild == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Đang tải bảng giá...")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingTourScreen(
                              tourId: widget.tourId,
                              priceAdult: priceAdult!.toInt(),
                              priceChild: priceChild!.toInt(),
                            ),
                          ),
                        );
                      },
                      loading: false,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildImageSection() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 350,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.network(
              images[selectedIndex],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Ionicons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: ImageListWidget(
              images: images,
              selectedIndex: selectedIndex,
              onSelect: (i) {
                setState(() => selectedIndex = i);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Ionicons.location_outline,
                  color: primaryColor,
                  size: 22,
                ),
              ),
            ),

            /// TITLE
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TabTourWidget(
          description: "",
          tourId: widget.tourId,
          onPriceLoaded: (adult, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                priceAdult = adult;
                priceChild = child;
              });
            });
          },
        ),
      ],
    );
  }
}
