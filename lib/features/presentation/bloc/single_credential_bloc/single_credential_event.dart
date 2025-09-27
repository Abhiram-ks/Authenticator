part of 'single_credential_bloc.dart';

@immutable
abstract class SingleCredentialEvent {}

final class SingleCredentialRequest extends SingleCredentialEvent {
  final String docId;
  SingleCredentialRequest({required this.docId});
}