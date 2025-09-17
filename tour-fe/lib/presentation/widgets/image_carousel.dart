import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatefulWidget {
  final List<Map<String, String>> hotelList;
  const ImageCarousel({Key? key, required this.hotelList}) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider.builder(
              carouselController: _controller,
              itemCount: widget.hotelList.length,
              itemBuilder: (context, index, realIndex) {
                final hotel = widget.hotelList[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.25),
                        blurRadius: 24,
                        spreadRadius: 4,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.12),
                        blurRadius: 40,
                        spreadRadius: 8,
                        offset: const Offset(0, 24),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.10),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(-4, -4),
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 186, 220, 219),
                        Color.fromARGB(255, 94, 192, 212)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.08),
                            BlendMode.darken,
                          ),
                          child: Image.asset(
                            hotel["image"]!,
                            fit: BoxFit.cover,
                            color: Colors.white.withOpacity(0.92),
                            colorBlendMode: BlendMode.modulate,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.5),
                              width: 1,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.cyanAccent.withOpacity(0.08),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 186, 236, 244)
                                  .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 80, 181, 221)
                                      .withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on,
                                    size: 18, color: Colors.orange),
                                const SizedBox(width: 6),
                                Text(
                                  hotel["name"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade300,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  hotel["rating"] ?? "4.8",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 220,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index),
              ),
            ),

            // Nút Previous
            Positioned(
              left: 10,
              child: GestureDetector(
                onTap: () => _controller.previousPage(),
                child: _buildArrowButton(Icons.arrow_back),
              ),
            ),

            // Nút Next
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: () => _controller.nextPage(),
                child: _buildArrowButton(Icons.arrow_forward),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.black54, Colors.black26],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}
