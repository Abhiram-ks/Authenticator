import 'package:cloud_firestore/cloud_firestore.dart';

class FavlikeRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Add to favorites (like)
  Future<void> like({
    required String userId,
    required String docId,
  }) async {
    final ref = firestore.collection("favorite").doc(userId);
    await ref.set({
      "likedIds": FieldValue.arrayUnion([docId]),
      "userId": userId,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Remove from favorites (unlike)
  Future<void> unlike({
    required String userId,
    required String docId,
  }) async {
    final ref = firestore.collection("favorite").doc(userId);
    await ref.set({
      "likedIds": FieldValue.arrayRemove([docId]),
      "userId": userId,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Stream favorites
  Stream<List<String>> getFavorites(String userId) {
    return firestore.collection("favorite").doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data()?['likedIds'] != null) {
        return List<String>.from(doc['likedIds']);
      }
      return <String>[];
    });
  }
}