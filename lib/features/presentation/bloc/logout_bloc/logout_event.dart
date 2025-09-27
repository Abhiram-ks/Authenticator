part of 'logout_bloc.dart';

@immutable
abstract class LogoutEvent {}
final class Logoutrequest extends LogoutEvent{}
final class LogoutConfirmation extends LogoutEvent{}
