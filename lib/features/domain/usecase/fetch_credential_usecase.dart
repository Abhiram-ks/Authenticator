import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/repo/credential_repo.dart';

class FetchCredentialsUseCase {
  final CredentialRepositroy repository;
  FetchCredentialsUseCase(this.repository);

  Stream<List<CredentialModel>> execute({required String uid}) {
    return repository.fetchCredentials(uid: uid);
  }
}