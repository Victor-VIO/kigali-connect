import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _locationNotifications = false;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get locationNotifications => _locationNotifications;

  static const List<String> categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
    'Utility Office',
  ];

  Stream<List<Listing>> get listingsStream => _firestoreService.getListings();

  Stream<List<Listing>> getUserListings(String uid) {
    return _firestoreService.getUserListings(uid);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleLocationNotifications(bool value) {
    _locationNotifications = value;
    notifyListeners();
  }

  // Filter listings based on search and category
  List<Listing> filterListings(List<Listing> listings) {
    return listings.where((listing) {
      final matchesSearch = _searchQuery.isEmpty ||
          listing.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || listing.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> addListing({
    required String name,
    required String category,
    required String address,
    required String contactNumber,
    required String description,
    required double latitude,
    required double longitude,
    required String createdBy,
  }) async {
    final data = {
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _firestoreService.addListing(data);
  }

  Future<void> updateListing({
    required String id,
    required String name,
    required String category,
    required String address,
    required String contactNumber,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    final data = {
      'name': name,
      'category': category,
      'address': address,
      'contactNumber': contactNumber,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _firestoreService.updateListing(id, data);
  }

  Future<void> deleteListing(String id) async {
    await _firestoreService.deleteListing(id);
  }
}
