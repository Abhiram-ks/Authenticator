part of 'googleauth_bloc.dart';

@immutable
abstract class GooglesignState {}

final class GooglesignInitial extends GooglesignState {}
final class GooglesingLoading extends GooglesignState {}
final class GooglesingSuccess extends GooglesignState {}
final class GooglesingFailure extends GooglesignState {
  final String message;

  GooglesingFailure({required this.message});
}