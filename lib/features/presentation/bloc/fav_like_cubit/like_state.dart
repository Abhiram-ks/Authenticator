part of 'like_cubit.dart';

@immutable
abstract class LikeState {}

class LikeInitial extends LikeState {}
class LikeLoading extends LikeState {}
class LikeLoaded extends LikeState {
  final bool isLiked;
  LikeLoaded({required this.isLiked});
}
class LikeError extends LikeState {
  final String message;
  LikeError(this.message);
}
