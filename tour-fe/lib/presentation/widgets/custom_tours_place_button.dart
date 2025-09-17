import 'package:flutter/material.dart';
import 'package:tour_fe/data/models/touris_places_model.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/services/tour_type_service.dart';

class TouristPlaces extends StatefulWidget {
  const TouristPlaces({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
      return Center(child: Text(error));
    }

    if (touristPlaces.isEmpty) {
      return const Center(child: Text('No tour types available.'));
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
              return Chip(
                label: Text(item.type_name),
                avatar: CircleAvatar(
                  backgroundImage: AssetImage(item.images),
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
