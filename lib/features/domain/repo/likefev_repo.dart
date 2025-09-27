abstract class FavoriteRepository {
  Future<void> like(String userId, String docId);
  Future<void> unlike(String userId, String docId);
  Stream<List<String>> getFavorites(String userId);
}
