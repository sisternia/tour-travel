// lib/presentation/widgets/Category.dart
import 'package:flutter/material.dart';
import '../../core/constants/color.dart';

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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCategoryButton("Tất cả", Icons.all_inclusive),
        const SizedBox(width: 12),
        _buildCategoryButton("Trong nước", Icons.location_on),
        const SizedBox(width: 12),
        _buildCategoryButton("Ngoài nước", Icons.public),
      ],
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    final bool isSelected = widget.selectedCategory == category;

    return InkWell(
      onTap: () {
        widget.onCategorySelected(category);
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 92,
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
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: child,
              ),
              child: Icon(
                icon,
                key: ValueKey(isSelected),
                size: 20,
                color: isSelected ? Colors.white : tPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              child: Text(category, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
