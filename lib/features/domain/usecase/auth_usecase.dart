import 'package:authenticator/features/domain/repo/auth_repo.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<bool> execute() async {
    return await repository.signInWithGoogle();
  }
}
