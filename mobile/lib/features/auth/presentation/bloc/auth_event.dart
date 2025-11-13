import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String? phone;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, fullName, phone];
}

class LogoutEvent extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent(this.refreshToken);

  @override
  List<Object?> get props => [refreshToken];
}
