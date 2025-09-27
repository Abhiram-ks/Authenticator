
import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/repo/category_repo.dart';

class FetchCategoryUsecase {
  final CategoryRepository repository;
  FetchCategoryUsecase(this.repository);

  Stream<List<CredentialEntity>> execute({required String uid, required String category}) {
    return repository.requestCategory(uid: uid,category: category);
  }
}