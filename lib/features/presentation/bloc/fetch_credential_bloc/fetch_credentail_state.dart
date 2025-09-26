part of 'fetch_credentail_bloc.dart';

@immutable
abstract class FetchCredentailState {}

final class FetchCredentailInitial extends FetchCredentailState {}

class FetchCredentailLoading extends FetchCredentailState {}

class FetchCredentailEmpty extends FetchCredentailState {}

class FetchCredentailError extends FetchCredentailState {
  final String message;
  FetchCredentailError(this.message);
}

class FetchCredentailLoad extends FetchCredentailState {
  final List<CredentialEntity> credentials;
  FetchCredentailLoad(this.credentials);
}