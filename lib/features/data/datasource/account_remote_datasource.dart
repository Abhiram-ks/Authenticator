import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountRemoteDataSource {
  final FirebaseFirestore _firestore;
  final AuthLocalDatasource _local;

  AccountRemoteDataSource({
    FirebaseFirestore? firestore,
    AuthLocalDatasource? local,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _local = local ?? AuthLocalDatasource();

  Future<String?> _uid() async {
    return await _local.get();
  }

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('accounts');
  }

  Future<void> saveAccount(AuthAccount account) async {
    final uid = await _uid();
    if (uid == null || uid.isEmpty) {
      throw Exception('Not signed in');
    }
    final docRef = _collection(uid).doc(account.id);
    await docRef.set(account.toMap(), SetOptions(merge: true));
  }

  Stream<List<AuthAccount>> streamAccounts() async* {
    final uid = await _uid();
    if (uid == null || uid.isEmpty) {
      yield <AuthAccount>[];
      return;
    }
    yield* _collection(uid)
        .orderBy('issuer', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => AuthAccount.fromMap(d.data(), fallbackId: d.id))
            .toList());
  }
}


