
import 'package:authenticator/features/data/datasource/settings_remote_datasource.dart';
import 'package:authenticator/features/domain/repo/setting_repo.dart';


class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDatasource remote;

  SettingsRepositoryImpl({required this.remote});

  @override
  Stream<bool> streamBackup(String uid) {
    return remote.streamBackup(uid);
  }

  @override
  Future<void> updateBackup(String uid, bool enabled) {
    return remote.updateBackup(uid, enabled);
  }
}