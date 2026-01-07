import 'package:flutter/material.dart';
import 'package:genet_church_portal/data/models/user_model.dart';

class SearchCommand {
  final String title;
  final String path;
  final IconData icon;
  final String category;
  final List<UserRole> roles;

  const SearchCommand({
    required this.title,
    required this.path,
    required this.icon,
    required this.category,
    this.roles = const [
      UserRole.SUPER_ADMIN,
      UserRole.PASTOR,
      UserRole.SERVANT,
    ],
  });
}