import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/repo/credential_repo.dart';

class CredentialUsecase {
  final CredentialRepositroy repo;
  CredentialUsecase({required this.repo});

  Future<bool> execute(CredentialEntity credential) async {
    return await repo.addCredential(credential: credential);
  }

}