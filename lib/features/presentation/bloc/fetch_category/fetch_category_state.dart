part of 'fetch_category_bloc.dart';

@immutable
abstract class FetchCategoryState {}

final class FetchCategoryInitial extends FetchCategoryState {}
final class FetchCategoryLoading extends FetchCategoryState {}
final class FetchCategoryEmpty extends FetchCategoryState {}
final class FetchCategorySuccess extends FetchCategoryState {
  final List<CredentialModel> credentials;
  FetchCategorySuccess({required this.credentials});
}

final class FetchCategoryError extends FetchCategoryState {
  final String errorMessage;
  FetchCategoryError({required this.errorMessage});
}