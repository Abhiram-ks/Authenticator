part of 'single_credential_bloc.dart';


@immutable
abstract class SingleCredentialState {}

final class SingleCredentialInitial extends SingleCredentialState {}

final class SingleCredentialLoading extends SingleCredentialState {}

final class SingleCredentialLoaded extends SingleCredentialState {
  final CredentialModel model;
  SingleCredentialLoaded({required this.model});
}

final class SingleCredentialError extends SingleCredentialState {
  final String message;
  SingleCredentialError(this.message);
}
