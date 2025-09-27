abstract class DeleteCredentialEvent {}

class DeleteCredentialRequest extends DeleteCredentialEvent {
  final String docId;
  final String uid;

  DeleteCredentialRequest({required this.docId, required this.uid});
}

class DeleteCredentialRequestConfirm extends DeleteCredentialEvent {
  final String docId;
  DeleteCredentialRequestConfirm({required this.docId});
}