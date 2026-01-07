import 'package:genet_church_portal/data/models/user_model.dart';

class Pastor {
  final String id;
  final String userId;
  final String? churchId;
  final UserModel? user;

  Pastor({required this.id, required this.userId, this.churchId, this.user});

  factory Pastor.fromJson(Map<String, dynamic> json) {
    return Pastor(
      id: json['id'] as String,
      userId: json['userId'] as String,
      churchId: json['churchId'] as String?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  static Map<String, dynamic> creationToJson({
    required String fullName,
    required String email,
    required String password,
  }) {
    return {'fullName': fullName, 'email': email, 'password': password};
  }
}
