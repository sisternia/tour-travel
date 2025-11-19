// lib/presentation/screens/tour/tourist_spot_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/color.dart';
import '../../../data/models/tours_model.dart';
import '../../../services/tours_service.dart';
import '../../widgets/Tours_List.dart';
import '../../widgets/Tours_Category.dart';

class TouristSpotScreen extends StatefulWidget {
  const TouristSpotScreen({super.key});

  @override
  State<TouristSpotScreen> createState() => _TouristSpotScreenState();
}

class _TouristSpotScreenState extends State<TouristSpotScreen> {
  String _selectedCategory = "Tất cả";
  final ToursService _toursService = ToursService();
  late Future<List<ToursModel>> _futureTours;

  @override
  void initState() {
    super.initState();
    _futureTours = _toursService.fetchTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<ToursModel>>(
          future: _futureTours,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text("Lỗi tải dữ liệu: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red)));
            }

            final tours = snapshot.data ?? [];
            final filteredTours = _selectedCategory == "Tất cả"
                ? tours
                : tours
                    .where((t) => t.categoryName == _selectedCategory)
                    .toList();

            return SingleChildScrollView(
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
                    children: filteredTours.map((tour) {
                      return TourCard(
                        id: tour.id,
                        title: tour.name,
                        imageUrl: tour.firstImage.isNotEmpty
                            ? tour.firstImage
                            : "https://via.placeholder.com/150",
                        country: "Việt Nam",
                        category: tour.categoryName,
                        rating: 4.8,
                        departure: tour.departureAddress,
                        destination: tour.destinationAddress,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
