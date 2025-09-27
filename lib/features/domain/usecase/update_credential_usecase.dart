import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/repo/credential_repo.dart';

class UpdateCredentialUseCase {
  final CredentialRepositroy repo;
  UpdateCredentialUseCase({required this.repo});

  Future<bool> execute({required String docId, required CredentialEntity credential}) async {
    return await repo.updateCredential(docId: docId, credential: credential);
  }
}
