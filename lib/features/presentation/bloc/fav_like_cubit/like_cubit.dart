import 'dart:async';

import 'package:authenticator/features/domain/usecase/likefev_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  final LikeUseCase likeUseCase;
  final UnlikeUseCase unlikeUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final String userId;

  StreamSubscription? _subscription;

  LikeCubit({
    required this.likeUseCase,
    required this.unlikeUseCase,
    required this.getFavoritesUseCase,
    required this.userId,
  }) : super(LikeInitial());

  void watchFavorites(String docId) {
    emit(LikeLoading());

    _subscription = getFavoritesUseCase(userId).listen((favorites) {
      final isLiked = favorites.contains(docId);
      emit(LikeLoaded(isLiked: isLiked));
    }, onError: (e) {
      emit(LikeError(e.toString()));
    });
  }

  Future<void> toggleLike(String docId, bool isLiked) async {
    if (isLiked) {
      await unlikeUseCase(userId, docId);
    } else {
      await likeUseCase(userId, docId);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
