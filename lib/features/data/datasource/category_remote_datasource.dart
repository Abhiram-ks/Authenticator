
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


 //! Add Credentials
  Stream<List<CredentialModel>> getCategorys({required String uid, required String category}){
    try {
      return _firestore
      .collection("credentials")
      .where("uid", isEqualTo: uid)
      .where(category, isEqualTo: true)
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
