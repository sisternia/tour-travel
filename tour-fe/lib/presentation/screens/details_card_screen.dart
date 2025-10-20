// lib/presentation/screens/details_card_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../widgets/NavigationBar.dart';
import '../../core/constants/color.dart';
import 'tourist_spot_screen.dart';

class DetailsCardScreen extends StatefulWidget {
  final String title;
  final String country;
  final String category;
  final double rating;

  const DetailsCardScreen({
    super.key,
    required this.title,
    this.country = "Việt Nam",
    this.category = "Trong nước",
    this.rating = 4.8,
  });

  @override
  State<DetailsCardScreen> createState() => _DetailsCardScreenState();
}

class _DetailsCardScreenState extends State<DetailsCardScreen> {
  int selectedIndex = 0;
  final List<String> images = ["Ảnh 1", "Ảnh 2", "Ảnh 3"];

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      currentIndex: 1,
      body: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Ảnh lớn
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
                    child: Center(
                      child: Text(
                        images[selectedIndex],
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkGrey),
                      ),
                    ),
                  ),

                  // Top Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) =>
                                    const TouristSpotScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final slide = Tween(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic));
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
                                  color: primaryColor),
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

                  // 3 ô vuông nhỏ
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        bool isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? tPrimaryColor
                                    : darkGrey.withOpacity(0.3),
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                images[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? tPrimaryColor : darkGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              // Nội dung dưới ảnh
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hàng 1: Địa điểm + icon Location
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ),
                          const Icon(Ionicons.location_outline,
                              color: darkGrey, size: 24),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Hàng 2: Đất nước
                      Text(
                        widget.country,
                        style: const TextStyle(fontSize: 18, color: darkGrey),
                      ),
                      const SizedBox(height: 16),

                      // Hàng 3: Rating + Heart + Chat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating: icon bên trái, số điểm + số người xếp dọc bên phải icon
                          Row(
                            children: [
                              const Icon(Ionicons.star,
                                  color: Colors.amber, size: 30),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.rating.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkGrey),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "4.500",
                                    style: TextStyle(
                                        fontSize: 14, color: darkGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Heart
                          const Row(
                            children: [
                              Icon(Ionicons.heart_outline,
                                  color: primaryColor, size: 30),
                              SizedBox(width: 6),
                              Text(
                                "1.200",
                                style: TextStyle(fontSize: 16, color: darkGrey),
                              ),
                            ],
                          ),

                          // Chat
                          const Row(
                            children: [
                              Icon(Ionicons.chatbubble_outline,
                                  color: primaryColor, size: 30),
                              SizedBox(width: 6),
                              Text(
                                "350",
                                style: TextStyle(fontSize: 16, color: darkGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Mô tả tour
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        "Phasellus feugiat, urna vel vestibulum fermentum, ligula ligula "
                        "ultrices justo, nec luctus turpis nulla at quam. Duis vitae massa "
                        "in magna aliquam euismod.",
                        style: TextStyle(
                            fontSize: 16, color: darkGrey, height: 1.5),
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
  }
}
