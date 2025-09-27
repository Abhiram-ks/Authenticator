import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFavoriteRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<CredentialModel>> fetchFavoriteCredentials(String userId) {
    return firestore.collection("favorite").doc(userId).snapshots().asyncMap(
      (doc) async {
        if (!doc.exists || doc.data()?['likedIds'] == null) {
          return <CredentialModel>[];
        }

        final List<String> likedIds = List<String>.from(doc['likedIds']);

        if (likedIds.isEmpty) return <CredentialModel>[];
      
        final snapshot = await firestore
            .collection("credentials")
            .where(FieldPath.documentId, whereIn: likedIds)
            .get();

        return snapshot.docs
            .map((d) => CredentialModel.fromJson(d.data(), d.id))
            .toList();
      },
    );
  }
}