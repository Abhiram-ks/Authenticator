abstract class DeleteCredentialState {}

class DeleteCredentialInitial extends DeleteCredentialState {}

class DeleteCredentialWithFavConfirmationAlert extends DeleteCredentialState {}
class DeleteCredentialConfirmationAlert extends DeleteCredentialState {}

class DeleteCredentialLoading extends DeleteCredentialState {}

class DeleteCredentialSuccess extends DeleteCredentialState {}

class DeleteCredentialError extends DeleteCredentialState {
  final String message;
  DeleteCredentialError({required this.message});
}
