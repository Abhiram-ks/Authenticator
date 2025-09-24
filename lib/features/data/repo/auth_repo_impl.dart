import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/auth_remote_datasource.dart';
import 'package:authenticator/features/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDS;
  final AuthLocalDatasource localDS;

  AuthRepositoryImpl({
    required this.remoteDS,
    required this.localDS,
  });

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final String uid = await remoteDS.signInWithGoogle();
      if (uid.isNotEmpty) {
        return await localDS.save(uid); 
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
