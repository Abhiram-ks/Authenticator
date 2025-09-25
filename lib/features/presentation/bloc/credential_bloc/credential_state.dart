part of 'credential_bloc.dart';

@immutable
abstract class CredentialState {}
final class CredentialInitial extends CredentialState {}
final class CredentialLoading extends CredentialState {}
final class CredentialSuccess extends CredentialState {}
final class CredentialFailure extends CredentialState {
  final String message;
  
  CredentialFailure({required this.message});
}
