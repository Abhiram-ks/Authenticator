import 'package:authenticator/features/domain/repo/setting_repo.dart';

class StreamBackupUseCase {
  final SettingsRepository repo;

  StreamBackupUseCase(this.repo);

  Stream<bool> call(String uid) => repo.streamBackup(uid);
  Future<void> execute(String uid, bool enabled) =>
      repo.updateBackup(uid, enabled);
}

