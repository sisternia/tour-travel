// lib/presentation/widgets/Image_List.dart
import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/color.dart';

class ImageListWidget extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int index) onSelect;

  const ImageListWidget({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    int extra = images.length > 3 ? images.length - 2 : 0;

    return Column(
      children: List.generate(
        images.length <= 3 ? images.length : 3,
        (i) {
          bool isLast = i == 2 && images.length > 3;
          bool isSelected = selectedIndex == i;

          return GestureDetector(
            onTap: () {
              if (!isLast) {
                onSelect(i);
              }
            },
            child: Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? tPrimaryColor : Colors.white,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: isLast
                    ? Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(
                          child: Text(
                            "+$extra",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : Image.network(
                        images[i],
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
