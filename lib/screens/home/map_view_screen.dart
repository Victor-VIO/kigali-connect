import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../models/listing_model.dart';
import '../../providers/listing_provider.dart';
import '../../utils/app_colors.dart';
import '../listing/listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _mapController;
  bool _mapError = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        await Permission.location.request();
      }
    } catch (e) {
      debugPrint('Location permission error: $e');
    }
    if (mounted) setState(() {});
  }

  static const LatLng _kigaliCenter = LatLng(-1.9403, 29.8739);

  Set<Marker> _buildMarkers(List<Listing> listings) {
    return listings.map((listing) {
      return Marker(
        markerId: MarkerId(listing.id),
        position: LatLng(listing.latitude, listing.longitude),
        infoWindow: InfoWindow(
          title: listing.name,
          snippet: listing.category,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListingDetailScreen(listing: listing),
              ),
            );
          },
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    if (_mapError) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryNavy,
          title: const Text('Map View',
              style: TextStyle(color: Colors.white)),
          elevation: 0,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 60, color: AppColors.textGrey),
              SizedBox(height: 12),
              Text('Unable to load map'),
              SizedBox(height: 4),
              Text(
                'Please check your internet connection',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text('Map View',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: StreamBuilder<List<Listing>>(
        stream: context.read<ListingProvider>().listingsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error loading listings: ${snapshot.error}'));
          }

          final listings = snapshot.data ?? [];
          final markers = _buildMarkers(listings);

          try {
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _kigaliCenter,
                zoom: 13,
              ),
              markers: markers,
              onMapCreated: (controller) =>
                  _mapController = controller,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            );
          } catch (e) {
            debugPrint('GoogleMap widget error: $e');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _mapError = true);
            });
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_map_view',
        onPressed: () {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(_kigaliCenter, 13),
          );
        },
        backgroundColor: AppColors.accentAmber,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
