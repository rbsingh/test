import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String kycStatus;
  final double virtualBalance;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.kycStatus,
    required this.virtualBalance,
  });

  @override
  List<Object?> get props => [id, email, fullName, phone, kycStatus, virtualBalance];
}
