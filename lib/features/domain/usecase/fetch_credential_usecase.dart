import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/repo/credential_repo.dart';

class FetchCredentialsUseCase {
  final CredentialRepositroy repository;
  FetchCredentialsUseCase(this.repository);

  Stream<List<CredentialEntity>> execute({required String uid}) {
    return repository.fetchCredentials(uid: uid);
  }
}