
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/repo/fav_credential_repo.dart';

class FetchFavoritesUseCase {
  final FechFavoriteRepository repo;

  FetchFavoritesUseCase(this.repo);

  Stream<List<CredentialModel>> call(String userId) {
    return repo.fetchFavorites(userId);
  }
}