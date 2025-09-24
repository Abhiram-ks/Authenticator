import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  static const _keyUserId = "USER_ID";
  final FlutterSecureStorage _store = const FlutterSecureStorage();

  Future<bool> save(String uid) async {
    try {
      await _store.write(key: _keyUserId, value: uid);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> get() async {
    try {
      return await _store.read(key: _keyUserId);
    } catch (_) {
      return null; 
    }
  }

  Future<bool> clear() async {
    try {
      await _store.delete(key: _keyUserId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
