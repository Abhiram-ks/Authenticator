import 'package:authenticator/features/data/datasource/credential_remote_datasource.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/repo/credential_repo.dart';

class CredentialRemoteDataSourceImpl  implements CredentialRepositroy  {
  final CredentialRemoteDataSource remote;

  CredentialRemoteDataSourceImpl ({required this.remote});

  @override
  Future<bool> addCredential({required CredentialEntity credential}) async {
    final model = CredentialModel(
      uid: credential.uid,
      name: credential.name,
      notes: credential.notes,
      username: credential.username,
      password: credential.password,
      url: credential.url,
      cardHolderName: credential.cardHolderName,
      cardNumber: credential.cardNumber,
      cardType: credential.cardType,
      expiryDate: credential.expiryDate,
      pin: credential.pin,
      postalCode: credential.postalCode,
      firstName: credential.firstName,
      lastName: credential.lastName,
      sex: credential.sex,
      birthday: credential.birthday,
      occupation: credential.occupation,
      company: credential.company,
      department: credential.department,
      jobTitle: credential.jobTitle,
      identityAddress: credential.identityAddress,
      email: credential.email,
      homePhone: credential.homePhone,
      cellPhone: credential.cellPhone,
      addressLine1: credential.addressLine1,
      addressLine2: credential.addressLine2,
      city: credential.city,
      country: credential.country,
      state: credential.state,
      isAddress: credential.isAddress,
      isCreditCard: credential.isCreditCard,
      isIdentity: credential.isIdentity,
      isLogin: credential.isLogin,
      isNotes: credential.isNotes,
    );

    return await remote.addCredential(model);
  }
  

  //!Fetch credentials as a stream
  @override
  Stream<List<CredentialEntity>> fetchCredentials({required String uid}){
    return remote.fetchCredentials(uid);
  }

}