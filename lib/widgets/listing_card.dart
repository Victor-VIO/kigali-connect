import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../utils/app_colors.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    // Pseudo-random rating based on name length
    final ratingNum = '4.${(listing.name.length % 5) + 3}';
    final filledStars = 4;
    final distance =
        ((listing.name.length * 0.3) + 0.2).toStringAsFixed(1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Name + rating number
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    listing.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      ratingNum,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentAmber,
                      ),
                    ),
                    const Icon(Icons.star, size: 14, color: AppColors.accentAmber),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Row 2: Star icons
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < filledStars ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < filledStars
                      ? AppColors.starFilled
                      : AppColors.starEmpty,
                );
              }),
            ),
            const SizedBox(height: 10),
            // Row 3: Distance
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 14, color: AppColors.textGrey),
                const SizedBox(width: 4),
                Text(
                  '$distance km',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textGrey),
                ),
              ],
            ),
            // Action buttons for My Listings
            if (showActions) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.primaryNavy),
                    label: const Text('Edit',
                        style: TextStyle(color: AppColors.primaryNavy)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline,
                        size: 18, color: Colors.red.shade400),
                    label: Text('Delete',
                        style: TextStyle(color: Colors.red.shade400)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
