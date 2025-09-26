import 'package:authenticator/features/domain/entity/credential_entity.dart';

abstract class CredentialRepositroy {
  //!Add credential
  Future<bool> addCredential({required CredentialEntity credential});

  //! Fetch credentials as a stream
  Stream<List<CredentialEntity>> fetchCredentials({required String uid});
}
