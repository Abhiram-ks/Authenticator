import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsRemoteDatasource {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<bool> streamBackup(String uid) {
    return _firestore.collection("backup").doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data()?['backup'] != null) {
        return doc['backup'] as bool;
      }
      return false; 
    });
  }

  Future<void> updateBackup(String uid, bool enabled) async {
    await _firestore.collection("backup").doc(uid).set(
      {
        "backup": enabled,
        "userId": uid,
        "updatedAt": FieldValue.serverTimestamp(), 
      },
      SetOptions(merge: true),
    );
  }
}