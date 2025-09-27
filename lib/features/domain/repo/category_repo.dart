import 'package:authenticator/features/data/models/credential_model.dart';

abstract class CategoryRepository {
 Stream<List<CredentialModel>> requestCategory({required String uid, required String category});
}
