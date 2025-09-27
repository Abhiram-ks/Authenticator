import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/entity/credential_entity.dart';

abstract class CredentialRepositroy {
  //!Add credential
  Future<bool> addCredential({required CredentialEntity credential});

  //! Fetch credentials as a stream
  Stream<List<CredentialModel>> fetchCredentials({required String uid});
   
   //! Fetch credentials as a Strem
  Stream<CredentialModel> fetchSingleCredential({required String docId});

  //! Update credential
  Future<bool> updateCredential({required String docId, required CredentialEntity credential});

  //! Delete credential
  Future<bool> deleteCredential({required String docId});
}
