import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CredentialRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
