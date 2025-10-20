// lib/presentation/screens/tourist_spot_screen.dart
import 'package:flutter/material.dart';
import '../widgets/NavigationBar.dart';
import '../widgets/Card.dart';
import '../widgets/Category.dart';
import '../../core/constants/color.dart';

class TouristSpotScreen extends StatefulWidget {
  const TouristSpotScreen({super.key});

  @override
  State<TouristSpotScreen> createState() => _TouristSpotScreenState();
}

class _TouristSpotScreenState extends State<TouristSpotScreen> {
  String _selectedCategory = "Tất cả";

  final List<Map<String, dynamic>> spots = [
    {
      "title": "Hạ Long Bay",
      "rating": 4.8,
      "imageUrl":
          "https://cdn.nhandan.vn/images/1ef398c4e2fb4bf07980a2ded785b3ef6da51f0c0ad991901283c66f347bc9e4d58e4d136e1acc0db3f24dc37fea202906c522dbc4618ece616ac55e7f30c60f8406a232827ab86e3d65c7fe743a016955c126705bce996d098c0f82e90164ad5cfacd5ee898d181029010948d9846a0/z4815475993971-548209818492c12193e9d817277b1dad-2657.jpg",
      "category": "Trong nước",
      "country": "Việt Nam",
    },
    {
      "title": "Phú Quốc",
      "rating": 4.6,
      "imageUrl":
          "https://bcp.cdnchinhphu.vn/334894974524682240/2025/6/23/phu-quoc-17506756503251936667562.jpg",
      "category": "Trong nước",
      "country": "Việt Nam",
    },
    {
      "title": "Đà Nẵng",
      "rating": 4.7,
      "imageUrl":
          "https://cdn-media.sforum.vn/storage/app/media/ctvseo_MH/%E1%BA%A3nh%20%C4%91%E1%BA%B9p%20%C4%91%C3%A0%20n%E1%BA%B5ng/anh-dep-da-nang-thumb.jpg",
      "category": "Trong nước",
      "country": "Việt Nam",
    },
    {
      "title": "Nha Trang",
      "rating": 4.5,
      "imageUrl":
          "https://xaviahotel.com/vnt_upload/news/11_2017/nha-trang_1.jpg",
      "category": "Trong nước",
      "country": "Việt Nam",
    },
    {
      "title": "Sapa",
      "rating": 4.9,
      "imageUrl":
          "https://media.thanhtra.com.vn/public/data/images/0/2020/12/31/congdinh/01.jpg?w=1319",
      "category": "Trong nước",
      "country": "Việt Nam",
    },
    {
      "title": "Paris",
      "rating": 4.8,
      "imageUrl":
          "https://cdn.britannica.com/94/178794-050-86CC6B8E/Eiffel-Tower-Seine-River-Paris.jpg",
      "category": "Ngoài nước",
      "country": "Pháp",
    },
    {
      "title": "Tokyo",
      "rating": 4.7,
      "imageUrl":
          "https://cdn.britannica.com/36/9436-050-4D4742A3/Tokyo-Tower-Japan.jpg",
      "category": "Ngoài nước",
      "country": "Nhật Bản",
    },
  ];

  List<Map<String, dynamic>> get filteredSpots {
    List<Map<String, dynamic>> list;
    if (_selectedCategory == "Tất cả") {
      list = spots;
    } else {
      list =
          spots.where((spot) => spot["category"] == _selectedCategory).toList();
    }
    list.sort(
        (a, b) => (b["rating"] as double).compareTo(a["rating"] as double));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      currentIndex: 1,
      body: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tour Nổi bật",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                CategorySelector(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: filteredSpots
                      .map((spot) => TourCard(
                            title: spot["title"] ?? '',
                            imageUrl: spot["imageUrl"] ?? '',
                            country: spot["country"] ?? '',
                            category: spot["category"] ?? '',
                            rating: (spot["rating"] as num).toDouble(),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
