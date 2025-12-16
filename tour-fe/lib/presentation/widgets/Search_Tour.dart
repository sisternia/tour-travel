import 'package:flutter/material.dart';
import 'package:tour_fe/data/models/tours_model.dart';
import 'package:tour_fe/presentation/screens/tour/details_tour_screen.dart';

class SearchTour extends StatefulWidget {
  final List<ToursModel> allTours;

  const SearchTour({super.key, required this.allTours});

  @override
  State<SearchTour> createState() => _SearchTourState();
}

class _SearchTourState extends State<SearchTour> {
  final TextEditingController searchController = TextEditingController();
  List<ToursModel> filteredTours = [];

  @override
  void initState() {
    super.initState();
    filteredTours = widget.allTours;
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredTours = widget.allTours
          .where((tour) =>
              tour.name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBox(),
        const SizedBox(height: 15),
        if (searchController.text.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredTours.length,
            itemBuilder: (context, index) {
              final tour = filteredTours[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tour.firstImage.isNotEmpty
                        ? tour.firstImage
                        : "https://via.placeholder.com/60",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  tour.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Số lượng: ${tour.numberOfPeople} người"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailsCardScreen(tourId: tour.id, title: tour.name),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: searchController.text.isNotEmpty
              ? Colors.blue
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.blue, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Tìm tour bạn muốn...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          if (searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  searchController.clear();
                  filteredTours = widget.allTours;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.black54),
              ),
            )
        ],
      ),
    );
  }
}
