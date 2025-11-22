import 'package:dartz/dartz.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Exception, AuthTokens>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final tokens = await remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      await localDataSource.saveTokens(tokens);

      return Right(tokens.toEntity());
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveTokens(tokens);

      return Right(tokens.toEntity());
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearTokens();

      return const Right(null);
    } catch (e) {
      // Clear local tokens even if remote logout fails
      await localDataSource.clearTokens();
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, AuthTokens>> refreshToken(String refreshToken) async {
    try {
      final tokens = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.saveTokens(tokens);

      return Right(tokens.toEntity());
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> isAuthenticated() async {
    try {
      final hasTokens = await localDataSource.hasTokens();
      return Right(hasTokens);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, User?>> getCurrentUser() async {
    try {
      // TODO: Implement get current user from API
      return const Right(null);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }
}
