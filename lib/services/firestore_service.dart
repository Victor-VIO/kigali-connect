import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User methods ---

  Future<void> createUserProfile(String uid, String email, String displayName) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  // --- Listing methods ---

  Stream<List<Listing>> getListings() {
    return _db
        .collection('listings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList());
  }

  Stream<List<Listing>> getUserListings(String uid) {
    return _db
        .collection('listings')
        .where('createdBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList());
  }

  Future<void> addListing(Map<String, dynamic> data) async {
    await _db.collection('listings').add(data);
  }

  Future<void> updateListing(String id, Map<String, dynamic> data) async {
    await _db.collection('listings').doc(id).update(data);
  }

  Future<void> deleteListing(String id) async {
    await _db.collection('listings').doc(id).delete();
  }
}
