abstract class EditCredentialState {}

class EditCredentialInitial extends EditCredentialState {}

class EditCredentialLoading extends EditCredentialState {}

class EditCredentialSuccess extends EditCredentialState {
  final String message;
  EditCredentialSuccess({required this.message});
}

class EditCredentialError extends EditCredentialState {
  final String message;
  EditCredentialError({required this.message});
}
