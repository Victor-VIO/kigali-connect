import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/listing_model.dart';
import '../../providers/listing_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/search_bar.dart';
import '../listing/listing_detail_screen.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listingProvider = context.watch<ListingProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text(
          'Kigali City',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ListingProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = ListingProvider.categories[index];
                  return CategoryChip(
                    label: category,
                    isSelected:
                        listingProvider.selectedCategory == category,
                    onTap: () => listingProvider.setCategory(category),
                  );
                },
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: ListingSearchBar(
              onChanged: (query) => listingProvider.setSearchQuery(query),
            ),
          ),

          // Section header
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              listingProvider.selectedCategory == 'All'
                  ? 'Near You'
                  : 'Services',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),

          // Listings list
          Expanded(
            child: StreamBuilder<List<Listing>>(
              stream: listingProvider.listingsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryNavy),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}'));
                }

                final allListings = snapshot.data ?? [];
                final filtered =
                    listingProvider.filterListings(allListings);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off,
                            size: 64, color: AppColors.textGrey),
                        SizedBox(height: 12),
                        Text(
                          'No listings found',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final listing = filtered[index];
                    return ListingCard(
                      listing: listing,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ListingDetailScreen(listing: listing),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
