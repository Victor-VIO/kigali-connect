import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ListingSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;

  const ListingSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search for a service',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.searchFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              const TextStyle(color: AppColors.textLight, fontSize: 15),
          suffixIcon: const Icon(Icons.search, color: AppColors.textGrey),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
