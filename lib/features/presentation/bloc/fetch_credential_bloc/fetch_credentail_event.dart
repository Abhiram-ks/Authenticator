part of 'fetch_credentail_bloc.dart';

@immutable
abstract  class FetchCredentailEvent {}
class FetchCredentialsEvent extends FetchCredentailEvent {}

class FetchCredentialsSearch extends FetchCredentailEvent {
  final String query;
  FetchCredentialsSearch({required this.query});
}