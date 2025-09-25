import 'package:authenticator/features/domain/entity/credential_entity.dart';

abstract class CredentialRepositroy {
  Future<bool> addCredential({required CredentialEntity credential});
}