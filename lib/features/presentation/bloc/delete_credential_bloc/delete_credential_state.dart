abstract class DeleteCredentialState {}

class DeleteCredentialInitial extends DeleteCredentialState {}

class DeleteCredentialLoading extends DeleteCredentialState {}

class DeleteCredentialSuccess extends DeleteCredentialState {
  final String message;
  DeleteCredentialSuccess({required this.message});
}

class DeleteCredentialError extends DeleteCredentialState {
  final String message;
  DeleteCredentialError({required this.message});
}
