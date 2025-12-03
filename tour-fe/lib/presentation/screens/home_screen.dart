// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/data/models/tours_model.dart';
import 'package:tour_fe/presentation/screens/notification/notification_screen.dart';
import 'package:tour_fe/presentation/screens/orders/order_list_screen.dart';
import 'package:tour_fe/services/notification_service.dart';
import 'package:tour_fe/services/order_service.dart';
import 'package:tour_fe/core/utils/Order_Center.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';
import 'package:tour_fe/services/tours_service.dart';
import 'package:tour_fe/core/utils/Notification_Center.dart';
// import '../widgets/Icon_Button.dart';
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
  final NotificationCenter _notificationCenter = NotificationCenter.instance;
  final OrderCenter _orderCenter = OrderCenter.instance;
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );
  List<ToursModel> allTours = [];
  List<ToursModel> filteredTours = [];

  String getDuration(String start, String end) {
    try {
      final d1 = DateTime.parse(start);
      final d2 = DateTime.parse(end);
      final diff = d2.difference(d1).inDays;

      if (diff <= 0) return "1 ngày";

      final nights = diff;
      final days = diff + 1;

      return "$days ngày $nights đêm";
    } catch (_) {
      return "Không rõ";
    }
  }

  late Future<ProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
    _loadAllTours();
    OrderService.fetchPendingCount();
  }

  Future<void> _refreshNotificationCount() async {
    await NotificationService.fetchUnreadCount();
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationScreen(
          onStateChanged: _refreshNotificationCount,
        ),
      ),
    );
    _refreshNotificationCount();
  }

  Future<void> _loadAllTours() async {
    final tours = await ToursService().fetchAllTours();
    setState(() {
      allTours = tours;
      filteredTours = tours;
    });
  }

  void _searchTours(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTours = allTours;
      } else {
        filteredTours = allTours
            .where(
                (tour) => tour.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
    bool isSearching = searchController.text.isNotEmpty;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      children: [
        _buildHeader(greeting, subtitle),
        const SizedBox(height: 20),

        // 🔍 Search bar
        SearchBarWidget(
          controller: searchController,
          onChanged: (value) {
            setState(() {});
            _searchTours(value);
          },
          onSubmitted: (value) {
            setState(() {});
            _searchTours(value);
          },
        ),

        const SizedBox(height: 20),

        if (isSearching) _buildSearchResults(),
        if (!isSearching) ...[
          Text(
            "📍Top địa điểm thịnh hành",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
          ),
          const SizedBox(height: 10),
          const ImageCarousel(),
          const SizedBox(height: 25),
          Text(
            "🗺️ Khám phá tour",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
          ),
          const SizedBox(height: 10),
          const TouristPlaces(),
          const SizedBox(height: 25),
          Text(
            "🆕 Các tour mới nhất",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: ToursService().fetchLatestTours(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Chưa có tour mới nào!");
              }

              return _buildLatestTours(snapshot.data!);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResults() {
    if (filteredTours.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("Không tìm thấy tour nào"),
      );
    }

    return Column(
      children: filteredTours.map((tour) {
        final price = currencyFormat.format(tour.priceAdult);
        final duration = getDuration(tour.startDate, tour.endDate);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  tour.firstImage.isNotEmpty
                      ? tour.firstImage
                      : "https://via.placeholder.com/120",
                  width: 120,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(duration),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHeader(String greeting, String subtitle) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade400,
            Colors.blue.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.25,
              child: ClipPath(
                clipper: _WaveClipper(),
                child: Container(
                  width: 160,
                  height: 150,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 👋 Greeting + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Order management icon
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderListScreen(),
                          ),
                        );
                        OrderService.fetchPendingCount();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: ValueListenableBuilder<int>(
                          valueListenable: _orderCenter.pendingCount,
                          builder: (context, count, _) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Ionicons.receipt_outline,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                if (count > 0)
                                  Positioned(
                                    right: -4,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        count > 99 ? '99+' : '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Notification icon
                    GestureDetector(
                      onTap: _openNotifications,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: ValueListenableBuilder<int>(
                          valueListenable: _notificationCenter.unreadCount,
                          builder: (context, count, _) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Ionicons.notifications_outline,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                if (count > 0)
                                  Positioned(
                                    right: -4,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        count > 99 ? '99+' : '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestTours(List<ToursModel> tours) {
    return Column(
      children: tours.map((tour) {
        final priceAdult = currencyFormat.format(tour.priceAdult);
        final priceChild = currencyFormat.format(tour.priceChild);
        final people = tour.numberOfPeople;
        final duration = getDuration(tour.startDate, tour.endDate);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(
                      tour.firstImage.isNotEmpty
                          ? tour.firstImage
                          : "https://via.placeholder.com/300",
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            "4.7",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people,
                              size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            "$people",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 7, 45, 77),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 20, color: Color.fromARGB(255, 172, 164, 2)),
                        const SizedBox(width: 6),
                        Text(duration,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 95, 93, 93),
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person,
                                    color: Colors.green.shade700, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  priceAdult,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green.shade700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.child_care,
                                    color: Colors.orange.shade700, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  priceChild,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.orange.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // TODO: điều hướng
                          },
                          child: const Text(
                            "Xem chi tiết",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.6,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
