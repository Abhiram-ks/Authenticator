abstract class DeleteCredentialEvent {}

class DeleteCredentialRequest extends DeleteCredentialEvent {
  final String docId;

  DeleteCredentialRequest({required this.docId});
}
