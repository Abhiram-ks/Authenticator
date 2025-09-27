part of 'deleteaccount_bloc.dart';

@immutable
abstract class DeleteaccountEvent {}
final class DeleteRequest extends DeleteaccountEvent{}
final class DeleteConfirm extends DeleteaccountEvent{}
