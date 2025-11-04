// lib/presentation/widgets/Tour_Place.dart

import 'package:flutter/material.dart';
import 'package:tour_fe/data/models/tours_places_model.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/services/tours_type_service.dart';

class TouristPlaces extends StatefulWidget {
  const TouristPlaces({super.key});

  @override
  _TouristPlacesState createState() => _TouristPlacesState();
}

class _TouristPlacesState extends State<TouristPlaces> {
  List<TouristPlacesModel> touristPlaces = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _fetchTourTypes();
  }

  Future<void> _fetchTourTypes() async {
    try {
      final tourTypeService = TourTypeService();
      final fetchedPlaces = await tourTypeService.fetchTourTypes();
      setState(() {
        touristPlaces = fetchedPlaces;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return const Center(child: Text("Không thể tải dữ liệu loại tour"));
    }

    if (touristPlaces.isEmpty) {
      return const Center(child: Text("Tour Type trống"));
    }

    final firstRow = touristPlaces.take(7).toList();

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = firstRow[index];

              // ✅ Tạo URL ảnh đầy đủ
              final imageUrl = item.images.startsWith('http')
                  ? item.images
                  : '${ApiConstants.baseServerUrl}${item.images}';

              return Chip(
                label: Text(item.typeName),
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0.4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: tPrimaryColor, width: 1),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const Padding(padding: EdgeInsets.only(right: 10)),
            itemCount: firstRow.length,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
