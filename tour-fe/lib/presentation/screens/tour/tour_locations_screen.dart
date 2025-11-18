import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api.dart';
import '../../../data/models/tour_locations_model.dart';
import '../../../services/tour_locations_service.dart';

class TourLocationsScreen extends StatefulWidget {
  final int tourId;

  const TourLocationsScreen({super.key, required this.tourId});

  @override
  State<TourLocationsScreen> createState() => _TourLocationsScreenState();
}

class _TourLocationsScreenState extends State<TourLocationsScreen> {
  final TourLocationsService service = TourLocationsService();

  late Future<List<TourLocationModel>> futureLocations;

  String mapboxToken = "";

  @override
  void initState() {
    super.initState();
    futureLocations = service.fetchLocationsByTour(widget.tourId);
    loadMapToken();
  }

  Future<void> loadMapToken() async {
    final res =
        await http.get(Uri.parse("${ApiConstants.baseUrl}/api/mapbox/token"));
    final jsonMap = jsonDecode(res.body);

    setState(() {
      mapboxToken = jsonMap["token"] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ❌ KHÔNG APPBAR — tự build nút X
      body: SafeArea(
        child: FutureBuilder<List<TourLocationModel>>(
          future: futureLocations,
          builder: (context, snap) {
            if (!snap.hasData || mapboxToken.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final locations = snap.data!;
            if (locations.isEmpty) {
              return const Center(child: Text("Chưa có địa điểm"));
            }

            final first =
                LatLng(locations.first.latitude, locations.first.longitude);

            return Stack(
              children: [
                // MAP
                FlutterMap(
                  options: MapOptions(
                    initialCenter: first,
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken",
                      additionalOptions: {
                        "accessToken": mapboxToken,
                      },
                    ),
                    MarkerLayer(
                      markers: locations.map((loc) {
                        return Marker(
                          point: LatLng(loc.latitude, loc.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // ❌ NÚT X ĐÓNG
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                // LIST ĐỊA ĐIỂM
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white.withOpacity(0.9),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: locations.length,
                        itemBuilder: (context, i) {
                          final loc = locations[i];
                          return GestureDetector(
                            onTap: () {
                              MapController controller = MapController();
                              controller.move(
                                LatLng(loc.latitude, loc.longitude),
                                15,
                              );
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.locationName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    loc.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
