// lib/presentation/widgets/Tours_List.dart
import 'package:flutter/material.dart';
import 'package:tour_fe/data/models/tours.model.dart';
import '../../services/tours_list_service.dart';

class TourListWidget extends StatefulWidget {
  const TourListWidget({super.key});

  @override
  State<TourListWidget> createState() => _TourListWidgetState();
}

class _TourListWidgetState extends State<TourListWidget> {
  late Future<List<TourModel>> _futureTours;

  @override
  void initState() {
    super.initState();
    _futureTours = TourListService().fetchTours();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TourModel>>(
      future: _futureTours,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Tour List trống'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tour List trống'));
        }

        final tours = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tours.length,
          itemBuilder: (context, index) {
            final tour = tours[index];
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
                  child: Image.network(
                    tour.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  tour.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text("Địa điểm: ${tour.destinationAddress}"),
                    Text("Giá người lớn: ${tour.priceAdult} VND"),
                    Text("Giá trẻ em: ${tour.priceChild} VND"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        );
      },
    );
  }
}
