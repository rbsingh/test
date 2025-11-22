import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phone,
    required super.kycStatus,
    required super.virtualBalance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      kycStatus: json['kycStatus'] as String? ?? 'pending',
      virtualBalance: (json['virtualBalance'] as num?)?.toDouble() ?? 1000000.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'kycStatus': kycStatus,
      'virtualBalance': virtualBalance,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      kycStatus: kycStatus,
      virtualBalance: virtualBalance,
    );
  }
}
