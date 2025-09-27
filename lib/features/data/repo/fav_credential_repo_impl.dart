import 'package:authenticator/features/data/datasource/favlike_credentials_remote_datasource.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/repo/fav_credential_repo.dart';

class FetchFavoriteRepositoryImpl implements FechFavoriteRepository {
  final FetchFavoriteRemoteDataSource remote;

  FetchFavoriteRepositoryImpl({required this.remote});

  @override
  Stream<List<CredentialModel>> fetchFavorites(String userId) {
    return remote.fetchFavoriteCredentials(userId);
  }
}