import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // SAVE USER
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String mobile,
    String? photoUrl,
    String? location,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'mobile': mobile,
      'photoUrl': photoUrl,
      'location': location ?? 'Ghaziabad, Uttar Pradesh',
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  // UPDATE USER PROFILE
  Future<void> updateUserProfile({
    required String uid,
    Map<String, dynamic>? data,
  }) async {
    if (data != null && data.isNotEmpty) {
      await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
    }
  }

  
  // GET USER DATA

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  // ADD CROP LISTING

  Future<void> addCropListing({
    required String cropName,
    required String quantity,
    required String price,
    required String farmerName,
    required String location,
    String? imageUrl,
  }) async {
    await _firestore.collection('crop_listings').add({
      'cropName': cropName,
      'quantity': quantity,
      'price': price,
      'farmerName': farmerName,
      'location': location,
      'imageUrl': imageUrl,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': Timestamp.now(),
    });
  }

  // GET ALL CROP LISTINGS

  Stream<QuerySnapshot> getCropListings() {
    return _firestore
        .collection('crop_listings')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // GET MY LISTINGS

  Stream<QuerySnapshot> getMyListings() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection('crop_listings')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }


  // DELETE CROP LISTING

  Future<void> deleteCropListing(String docId) async {
    await _firestore
        .collection('crop_listings')
        .doc(docId)
        .delete();
  }

  // ADD ORDER

  Future<void> addOrder({
    required String cropName,
    required String buyerName,
  }) async {
    await _firestore.collection('orders').add({
      'cropName': cropName,
      'buyerName': buyerName,
      'status': 'Processing',
      'createdAt': Timestamp.now(),
    });
  }


  // GET ORDERS
 
  Stream<QuerySnapshot> getOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

 
  // ORDER HISTORY

  Stream<QuerySnapshot> getOrderHistory() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }


  // ADD FAVORITE

  Future<void> addFavorite({
    required String cropName,
    required String userId,
  }) async {
    // Check if already exists to prevent duplicate entries
    final query = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('cropName', isEqualTo: cropName)
        .get();

    if (query.docs.isEmpty) {
      await _firestore.collection('favorites').add({
        'cropName': cropName,
        'userId': userId,
        'createdAt': Timestamp.now(),
      });
    }
  }


  // REMOVE FAVORITE

  Future<void> removeFavorite({
    required String cropName,
    required String userId,
  }) async {
    final query = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('cropName', isEqualTo: cropName)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }


  // GET FAVORITES

  Stream<QuerySnapshot> getFavorites(String userId) {
    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }


  // ADD REVIEW
 
  Future<void> addReview({
    required String sellerId,
    required String buyerName,
    required double rating,
    required String comment,
  }) async {
    await _firestore.collection('reviews').add({
      'sellerId': sellerId,
      'buyerName': buyerName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.now(),
    });
  }


  // GET REVIEWS

  Stream<QuerySnapshot> getReviews(String sellerId) {
    return _firestore
        .collection('reviews')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}