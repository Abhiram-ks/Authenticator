import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/repo/credential_repo.dart';

class FetchSingleCredentialUseCase {
  final CredentialRepositroy repository;

  FetchSingleCredentialUseCase(this.repository);

  Stream<CredentialModel> execute(String docId) {
    return repository.fetchSingleCredential(docId: docId);
  }
}
