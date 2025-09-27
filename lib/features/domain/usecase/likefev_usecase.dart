import 'package:authenticator/features/domain/repo/likefev_repo.dart';

class LikeUseCase {
  final FavoriteRepository repo;
  LikeUseCase(this.repo);

  Future<void> call(String userId, String docId) => repo.like(userId, docId);
}

class UnlikeUseCase {
  final FavoriteRepository repo;
  UnlikeUseCase(this.repo);

  Future<void> call(String userId, String docId) => repo.unlike(userId, docId);
}

class GetFavoritesUseCase {
  final FavoriteRepository repo;
  GetFavoritesUseCase(this.repo);

  Stream<List<String>> call(String userId) => repo.getFavorites(userId);

    Future<bool> isFavorite(String userId, String docId) async {
    final snapshot = await repo.getFavorites(userId).first; 
    return snapshot.contains(docId);
  }
}
