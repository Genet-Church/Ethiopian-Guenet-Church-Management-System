import 'package:genet_church_portal/data/models/user_model.dart';

class Servant {
  final String id;
  final String userId;
  final String churchId;
  final String? departmentId;
  final UserModel? user;

  Servant({
    required this.id,
    required this.userId,
    required this.churchId,
    this.departmentId,
    this.user,
  });

  factory Servant.fromJson(Map<String, dynamic> json) {
    return Servant(
      id: json['id'],
      userId: json['userId'],
      churchId: json['churchId'],
      departmentId: json['departmentId'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
