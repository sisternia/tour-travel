// lib/presentation/widgets/Tours_Category.dart
import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/color.dart';

class CategorySelector extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tất cả', 'icon': Icons.all_inclusive},
    {'name': 'Nội địa', 'icon': Icons.home_outlined},
    {'name': 'Quốc tế', 'icon': Icons.public_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final bool isSelected = widget.selectedCategory == category['name'];

          return InkWell(
            onTap: () => widget.onCategorySelected(category['name']),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 90,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? tPrimaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: tPrimaryColor.withOpacity(0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'],
                    size: 22,
                    color: isSelected ? Colors.white : tPrimaryColor,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
