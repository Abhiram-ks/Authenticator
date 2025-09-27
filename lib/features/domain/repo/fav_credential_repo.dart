import 'package:authenticator/features/data/models/credential_model.dart';

abstract class FechFavoriteRepository {
  Stream<List<CredentialModel>> fetchFavorites(String userId);
}
