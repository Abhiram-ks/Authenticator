import 'package:authenticator/features/domain/entity/credential_entity.dart';

abstract class EditCredentialEvent {}

class EditCredentialRequest extends EditCredentialEvent {
  final String docId;
  final CredentialEntity credential;

  EditCredentialRequest({
    required this.docId,
    required this.credential,
  });
}
