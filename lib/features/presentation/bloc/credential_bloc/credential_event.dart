part of 'credential_bloc.dart';

@immutable
abstract class CredentialEvent {}

final class SubmitCredential extends CredentialEvent {
  final ItemType type;
  final Map<String, String> val;

  SubmitCredential({required this.type, required this.val});
}

