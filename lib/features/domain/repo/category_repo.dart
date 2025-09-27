import 'package:authenticator/features/domain/entity/credential_entity.dart';

abstract class CategoryRepository {
 Stream<List<CredentialEntity>> requestCategory({required String uid, required String category});
}
