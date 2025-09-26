import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CredentialRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


 //! Add Credentials
  Future<bool> addCredential(CredentialModel model) async {
    try {
      await _firestore.collection("credentials").add(model.toJson());
      return true;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  //! Fetch Credentials as a stream
  Stream<List<CredentialModel>> fetchCredentials(String uid){
    try {
      return _firestore
      .collection("credentials")
      .where("uid", isEqualTo: uid)
      .orderBy("createdAt", descending: true) 
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => CredentialModel.fromJson(doc.data(), doc.id))
      .toList());
    } on FirebaseException catch (e) {
      throw Exception("Firebase error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occured: $e");
    }
  }
}
