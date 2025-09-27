import 'dart:async';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/domain/usecase/settings_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackupCubit extends Cubit<bool> {
  final StreamBackupUseCase streamBackupUseCase;
  final AuthLocalDatasource local;

  StreamSubscription<bool>? _subscription;

  BackupCubit({
    required this.streamBackupUseCase,
    required this.local,
  }) : super(false) {
    _init();
  }

  Future<void> _init() async {
    final userId = await local.get();
    if (userId != null && userId.isNotEmpty) {
      _listenBackup(userId);
    }
  }

  void _listenBackup(String uid) {
    _subscription = streamBackupUseCase(uid).listen((enabled) {
      emit(enabled);
    });
  }

  Future<void> toggleBackup(bool value) async {
    final userId = await local.get();
    if (userId != null && userId.isNotEmpty) {
      await streamBackupUseCase.execute(userId, value);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
