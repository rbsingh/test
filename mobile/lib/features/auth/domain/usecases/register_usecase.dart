import 'package:dartz/dartz.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Exception, AuthTokens>> call({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) {
    return repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
  }
}
