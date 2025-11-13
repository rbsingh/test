import 'package:flutter/material.dart';

class AppConfig {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String wsUrl = 'ws://localhost:3000/ws';

  // App Colors
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color buyColor = Color(0xFF4CAF50);
  static const Color sellColor = Color(0xFFF44336);

  // App Constants
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';

  // Initial Virtual Balance
  static const double initialVirtualBalance = 1000000.00;

  // Rate Limiting
  static const int maxRequestsPerMinute = 100;
}
