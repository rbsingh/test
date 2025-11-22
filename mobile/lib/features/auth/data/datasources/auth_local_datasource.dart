import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/config/app_config.dart';
import '../models/auth_tokens_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
  Future<bool> hasTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await secureStorage.write(
      key: AppConfig.accessTokenKey,
      value: tokens.accessToken,
    );
    await secureStorage.write(
      key: AppConfig.refreshTokenKey,
      value: tokens.refreshToken,
    );
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: AppConfig.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: AppConfig.refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(key: AppConfig.accessTokenKey);
    await secureStorage.delete(key: AppConfig.refreshTokenKey);
  }

  @override
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}
