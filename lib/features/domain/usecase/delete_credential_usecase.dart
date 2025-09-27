import 'package:authenticator/features/domain/repo/credential_repo.dart';

class DeleteCredentialUseCase {
  final CredentialRepositroy repo;
  DeleteCredentialUseCase({required this.repo});

  Future<bool> execute({required String docId}) async {
    return await repo.deleteCredential(docId: docId);
  }
}
