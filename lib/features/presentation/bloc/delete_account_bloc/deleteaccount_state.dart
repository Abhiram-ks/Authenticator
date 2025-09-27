part of 'deleteaccount_bloc.dart';

@immutable
abstract class DeleteaccountState {}

final class DeleteaccountInitial extends DeleteaccountState {}

final class DeleteAccountWithoutSincAlert extends DeleteaccountState {}
final class DeleteAccountConfirmationAlert extends DeleteaccountState {}
final class DeleteAccountSuccess extends DeleteaccountState {}
final class DeleteAccountFailure extends DeleteaccountState {
  final String message;
  DeleteAccountFailure({required this.message});
}