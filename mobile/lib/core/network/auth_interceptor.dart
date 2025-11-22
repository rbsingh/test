import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Dio dio;

  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for auth endpoints
    if (options.path.contains('/auth/register') ||
        options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    // Add access token to request
    final accessToken = await secureStorage.read(key: AppConfig.accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If 401 error, try to refresh token
    if (err.response?.statusCode == 401) {
      final refreshToken = await secureStorage.read(key: AppConfig.refreshTokenKey);

      if (refreshToken != null) {
        try {
          // Try to refresh token
          final response = await dio.post(
            '${AppConfig.baseUrl}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['data']['accessToken'];
            final newRefreshToken = response.data['data']['refreshToken'];

            // Save new tokens
            await secureStorage.write(
              key: AppConfig.accessTokenKey,
              value: newAccessToken,
            );
            await secureStorage.write(
              key: AppConfig.refreshTokenKey,
              value: newRefreshToken,
            );

            // Retry the original request
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Refresh failed, clear tokens and let error through
          await secureStorage.delete(key: AppConfig.accessTokenKey);
          await secureStorage.delete(key: AppConfig.refreshTokenKey);
        }
      }
    }

    return handler.next(err);
  }
}
