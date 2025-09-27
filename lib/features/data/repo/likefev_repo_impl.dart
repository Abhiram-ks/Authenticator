import 'package:authenticator/features/data/datasource/favlike_remote_datasource.dart';
import 'package:authenticator/features/domain/repo/likefev_repo.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavlikeRemoteDatasource remote;
  FavoriteRepositoryImpl({required this.remote});

  @override
  Future<void> like(String userId, String docId) {
    return remote.like(userId: userId, docId: docId);
  }

  @override
  Future<void> unlike(String userId, String docId) {
    return remote.unlike(userId: userId, docId: docId);
  }

  @override
  Stream<List<String>> getFavorites(String userId) {
    return remote.getFavorites(userId);
  }
}