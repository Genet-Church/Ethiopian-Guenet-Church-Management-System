import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/data/models/search_command_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:iconsax/iconsax.dart';

final searchServiceProvider = Provider((ref) {
  return SearchService();
});

class SearchService {
  List<SearchCommand> getCommandsForRole(UserRole role) {
    return _allCommands.where((command) => command.roles.contains(role)).toList();
  }

  final List<SearchCommand> _allCommands = [
    const SearchCommand(
        title: 'Dashboard',
        path: '/dashboard',
        icon: Iconsax.category,
        category: 'Navigation'),
    const SearchCommand(
        title: 'My Profile',
        path: '/profile',
        icon: Iconsax.user,
        category: 'User'),
    const SearchCommand(
        title: 'Communication Hub',
        path: '/communication-hub',
        icon: Iconsax.send_1,
        category: 'Tools',
        roles: [UserRole.SUPER_ADMIN, UserRole.PASTOR]),
    const SearchCommand(
        title: 'Analytics & Advanced Reports',
        path: '/advanced-reports',
        icon: Iconsax.chart_21,
        category: 'Reports',
        roles: [UserRole.SUPER_ADMIN]),
    const SearchCommand(
        title: 'View Church Reports',
        path: '/report-churchs',
        icon: Iconsax.building,
        category: 'Church',
        roles: [UserRole.SUPER_ADMIN]),
    const SearchCommand(
        title: 'Add a New Church',
        path: '/add-church',
        icon: Iconsax.add_square,
        category: 'Church',
        roles: [UserRole.SUPER_ADMIN]),
    const SearchCommand(
        title: 'View Pastor Reports',
        path: '/report-pastors',
        icon: Iconsax.user_octagon,
        category: 'Pastors',
        roles: [UserRole.SUPER_ADMIN]),
    const SearchCommand(
        title: 'Add a New Pastor',
        path: '/add-pastors',
        icon: Iconsax.user_add,
        category: 'Pastors',
        roles: [UserRole.SUPER_ADMIN]),
    const SearchCommand(
        title: 'Manage Permissions',
        path: '/permissions',
        icon: Iconsax.shield_tick,
        category: 'Settings',
        roles: [UserRole.SUPER_ADMIN]),
    const SearchCommand(
        title: 'View Member Categories',
        path: '/categories',
        icon: Iconsax.folder_2,
        category: 'Members',
        roles: [UserRole.PASTOR]),
  ];
}

final searchResultsProvider = StateProvider<List<SearchCommand>>((ref) => []);
final searchQueryProvider = StateProvider<String>((ref) => '');