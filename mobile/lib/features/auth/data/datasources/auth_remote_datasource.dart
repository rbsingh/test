import '../../../../core/network/dio_client.dart';
import '../models/auth_tokens_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AuthTokensModel> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final response = await dioClient.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        if (phone != null) 'phone': phone,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return AuthTokensModel.fromJson(response.data['data']);
    } else {
      throw Exception('Registration failed');
    }
  }

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dioClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return AuthTokensModel.fromJson(response.data['data']);
    } else {
      throw Exception('Login failed');
    }
  }

  @override
  Future<void> logout() async {
    await dioClient.post('/auth/logout');
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final response = await dioClient.post(
      '/auth/refresh',
      data: {
        'refreshToken': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      return AuthTokensModel.fromJson(response.data['data']);
    } else {
      throw Exception('Token refresh failed');
    }
  }
}
