
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/repo/category_repo.dart';

class FetchCategoryUsecase {
  final CategoryRepository repository;
  FetchCategoryUsecase(this.repository);

  Stream<List<CredentialModel>> execute({required String uid, required String category}) {
    return repository.requestCategory(uid: uid,category: category);
  }
}