abstract class SettingsRepository {
  Stream<bool> streamBackup(String uid);
  Future<void> updateBackup(String uid, bool enabled);
}
