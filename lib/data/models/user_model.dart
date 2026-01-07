enum UserRole { SUPER_ADMIN, PASTOR, SERVANT }

UserRole mapRoleFromString(String? roleString) {
  switch (roleString?.toUpperCase()) {
    case 'SUPER_ADMIN':
      return UserRole.SUPER_ADMIN;
    case 'PASTOR':
      return UserRole.PASTOR;
    case 'SERVANT':
      return UserRole.SERVANT;
    default:
      return UserRole.SERVANT;
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final String createdAt;
  final Map<String, dynamic>? pastorDetails;
  final Map<String, dynamic>? servantDetails;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.pastorDetails,
    this.servantDetails,
  });

  UserRole get roleEnum => mapRoleFromString(role);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      pastorDetails: json['Pastor'] as Map<String, dynamic>?,
      servantDetails: json['Servant'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt,
      if (pastorDetails != null) 'Pastor': pastorDetails,
      if (servantDetails != null) 'Servant': servantDetails,
    };
  }
}