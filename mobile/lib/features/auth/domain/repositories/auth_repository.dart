import 'package:dartz/dartz.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Exception, AuthTokens>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  Future<Either<Exception, AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<Either<Exception, void>> logout();

  Future<Either<Exception, AuthTokens>> refreshToken(String refreshToken);

  Future<Either<Exception, bool>> isAuthenticated();

  Future<Either<Exception, User?>> getCurrentUser();
}
