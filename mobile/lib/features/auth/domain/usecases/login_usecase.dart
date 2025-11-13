import 'package:dartz/dartz.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Exception, AuthTokens>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
