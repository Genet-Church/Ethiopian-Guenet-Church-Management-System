import 'package:flutter/material.dart';
import 'package:genet_church_portal/data/models/user_model.dart';

class AppMenuItem {
  final String title;
  final String path;
  final IconData icon;
  final List<UserRole> roles;
  final Map<String, String>? children;

  const AppMenuItem({
    required this.title,
    required this.path,
    required this.icon,
    this.roles = const [UserRole.SUPER_ADMIN, UserRole.PASTOR, UserRole.SERVANT],
    this.children,
  });
}