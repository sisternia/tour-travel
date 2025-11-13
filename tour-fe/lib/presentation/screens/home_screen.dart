// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';

import '../widgets/Icon_Button.dart';
import '../widgets/Image_Carousel.dart';
import '../widgets/Search_Bar.dart';
import '../widgets/Tours_Place.dart';
import '../widgets/NavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProfileService _profileService = ProfileService();
  final TokenService _tokenService = TokenService();

  late Future<ProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<ProfileModel> _loadProfile() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) throw Exception('Token not found');
      return await _profileService.getProfile(token);
    } catch (e) {
      debugPrint('Failed to load username in Home: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      body: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FutureBuilder<ProfileModel>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return _buildMainContent("Hi, bạn 👋", "Không thể tải hồ sơ");
              } else if (snapshot.hasData) {
                final profile = snapshot.data!;
                final userName = profile.userName ?? "Bạn";
                return _buildMainContent(
                    "Hi, $userName 👋", "Chúc bạn ngày mới tốt lành!");
              } else {
                return _buildMainContent(
                    "Hi, bạn 👋", "Không có dữ liệu hồ sơ");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(String greeting, String subtitle) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      children: [
        // Header
        _buildHeader(greeting, subtitle),
        const SizedBox(height: 20),

        // Thanh tìm kiếm
        SearchBarWidget(
          controller: searchController,
          onSubmitted: (value) => debugPrint("Tìm kiếm: $value"),
        ),
        const SizedBox(height: 20),

        // Top địa điểm
        Text(
          "📍Top địa điểm thịnh hành",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
        ),
        const SizedBox(height: 10),
        const ImageCarousel(
          hotelList: [
            {
              "image": "assets/images/slider1.jpg",
              "name": "Lũng Cú",
              "location": "Hà Giang",
            },
            {
              "image": "assets/images/slider2.jpg",
              "name": "Cầu Vàng",
              "location": "Đà Nẵng",
            },
            {
              "image": "assets/images/slider3.jpg",
              "name": "Hồ Kẻ Gỗ",
              "location": "Hà Tĩnh",
            },
          ],
        ),
        const SizedBox(height: 25),

        // Loại hình tour
        Text(
          "🗺️ Khám phá loại hình tour",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
        ),
        const SizedBox(height: 10),
        const TouristPlaces(),
        const SizedBox(height: 25),

        // Các tour nổi bật (placeholder thay cho TourList)
        Text(
          "🌟 Các tour nổi bật",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
        ),
        const SizedBox(height: 10),
        _buildPlaceholderTours(),
      ],
    );
  }

  Widget _buildHeader(String greeting, String subtitle) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const CustomIconButton(
            icon: Icon(Ionicons.notifications_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTours() {
    final tours = [
      {"name": "Tour Hạ Long - Kỳ Quan Thế Giới", "destination": "Hạ Long"},
      {"name": "Tour Phú Quốc - Thiên Đường Biển", "destination": "Phú Quốc"},
      {"name": "Tour Đà Lạt - Thành Phố Ngàn Hoa", "destination": "Đà Lạt"},
    ];

    return Column(
      children: tours.map((tour) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/slider1.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              tour["name"]!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Điểm đến: ${tour["destination"]!}"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      }).toList(),
    );
  }
}
