import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onFilterPressed;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search, // Enter = Search
        decoration: InputDecoration(
          hintText: "Tìm kiếm...",

          // 👉 ICON SEARCH CÓ onTap
          prefixIcon: GestureDetector(
            onTap: () {
              if (onSubmitted != null) {
                onSubmitted!(controller.text.trim());
              }
            },
            child: const Icon(
              Icons.search,
              color: Color.fromARGB(231, 171, 169, 169),
            ),
          ),

          // 👉 ICON FILTER
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.grey),
            onPressed: onFilterPressed ??
                () {
                  debugPrint("Filter button pressed!");
                },
          ),

          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
                color: Color.fromARGB(110, 71, 130, 179), width: 1.5),
          ),
        ),
      ),
    );
  }
}
