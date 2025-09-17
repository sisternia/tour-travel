// lib/presentation/screens/HomeScreen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import '../../services/storage_service.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tour_fe/presentation/widgets/custom_icon_button.dart';
import 'package:tour_fe/presentation/widgets/custom_tours_place_button.dart';
import 'package:tour_fe/presentation/widgets/image_carousel.dart';
import 'package:tour_fe/presentation/widgets/search_bar_widget.dart';
import 'package:tour_fe/presentation/widgets/tour_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final name = await StorageService.getUsername();
    print('Loaded username: $name');
    setState(() {
      _username = name ?? 'Unknown word';
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120), // cao hơn chút
          child: Stack(
            children: [
              ClipPath(
                clipper: AppBarClipper(),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${_username ?? "Guest"} 👋",
                            style: const TextStyle(
                                color: Color.fromARGB(179, 212, 13, 13),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Text(
                                "Chúc bạn ngày mới tốt lành !",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          CustomIconButton(
                            icon: Icon(
                              Ionicons.notifications_circle_outline,
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
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: [
            SearchBarWidget(
              controller: searchController,
              onSubmitted: (value) {
                print("Tìm kiếm: $value");
              },
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📍Top địa điểm thịnh hành",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                ),
              ],
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
                {
                  "image": "assets/images/slider4.jpg",
                  "name": "Phố Cổ",
                  "location": "Hội An",
                },
                {
                  "image": "assets/images/slider5.jpg",
                  "name": "Tháp Rùa",
                  "location": "Hà Nội",
                },
                {
                  "image": "assets/images/slider6.jpg",
                  "name": "Thị trấn hoàng hôn",
                  "location": "Phú Quốc",
                },
                {
                  "image": "assets/images/slider7.jpg",
                  "name": "Thác Bản Giốc",
                  "location": "Cao Bằng",
                },
              ],
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "🗺️ Khám phá loại hình tour",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tourist places chips
            const TouristPlaces(),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " 🌟 Các tour nổi bật ",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                ),
              ],
            ),
            const TourListWidget(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 25);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 25,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
