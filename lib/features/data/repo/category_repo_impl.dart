import 'package:authenticator/features/data/datasource/category_remote_datasource.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/repo/category_repo.dart';

class CategoryRepositroyImple implements CategoryRepository {
  final CategoryRemoteDatasource remote;

  CategoryRepositroyImple({required this.remote});

  @override
  Stream<List<CredentialModel>> requestCategory({
    required String uid,
    required String category,
  }) {
    return remote.getCategorys(uid: uid, category: category);
  }
}
