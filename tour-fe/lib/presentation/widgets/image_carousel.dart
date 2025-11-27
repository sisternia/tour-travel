// lib/presentation/widgets/Image_Carousel.dart
import 'dart:async';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  static const int _virtualPageCount = 999999; // vòng lặp ảo
  late final PageController _pageController;
  int currentIndex = 0;
  Timer? _timer;

  final List<Map<String, String>> sliders = const [
    {
      "image": "assets/images/slider1.jpg",
      "name": "National Park, Canada",
      "rating": "4.8"
    },
    {
      "image": "assets/images/slider2.jpg",
      "name": "Sachslen, Switzerland",
      "rating": "4.6"
    },
    {
      "image": "assets/images/slider3.jpg",
      "name": "Ha Giang, Vietnam",
      "rating": "4.7"
    },
    {
      "image": "assets/images/slider4.jpg",
      "name": "Sa Pa, Vietnam",
      "rating": "4.9"
    },
    {
      "image": "assets/images/slider5.jpg",
      "name": "Phu Quoc, Vietnam",
      "rating": "4.8"
    },
    {
      "image": "assets/images/slider6.jpg",
      "name": "Ninh Binh, Vietnam",
      "rating": "4.6"
    },
    {
      "image": "assets/images/slider7.jpg",
      "name": "Da Nang, Vietnam",
      "rating": "4.7"
    },
  ];

  @override
  void initState() {
    super.initState();

    final middleIndex = _virtualPageCount ~/ 2;
    _pageController = PageController(
      viewportFraction: 0.70,
      initialPage: middleIndex,
    );

    currentIndex = middleIndex % sliders.length;

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final nextPage = _pageController.page!.toInt() + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _virtualPageCount,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) =>
                setState(() => currentIndex = index % sliders.length),
            itemBuilder: (context, index) {
              final item = sliders[index % sliders.length];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(item["image"]!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.35)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.90),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  item["rating"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.redAccent, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item["name"]!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            sliders.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: currentIndex == i ? 22 : 8,
              decoration: BoxDecoration(
                color: currentIndex == i
                    ? Colors.blueAccent
                    : Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
