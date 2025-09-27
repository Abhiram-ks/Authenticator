part of 'fetch_category_bloc.dart';

@immutable
abstract class FetchCategoryEvent {}
final class FetchCategoryFilter extends FetchCategoryEvent {
  final String category;
  FetchCategoryFilter({required this.category});
}