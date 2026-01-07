import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/data/services/api_service.dart';
import 'package:genet_church_portal/features/dashboard/presentation/dashboard_screen.dart';
import 'package:genet_church_portal/features/screens/activity_log_screen.dart';
import 'package:genet_church_portal/features/screens/add_church_screen.dart';
import 'package:genet_church_portal/features/screens/add_members_screen.dart';
import 'package:genet_church_portal/features/screens/add_pastors_screen.dart';
import 'package:genet_church_portal/features/screens/advanced_reports_screen.dart';
import 'package:genet_church_portal/features/settings/presentation/settings_screen.dart';
import 'package:genet_church_portal/features/screens/profile_screen.dart';
import 'package:genet_church_portal/features/screens/report_churchs_screen.dart';
import 'package:genet_church_portal/features/screens/report_departments_screen.dart';
import 'package:genet_church_portal/features/screens/report_pastors_screen.dart';
import 'package:genet_church_portal/features/screens/report_servants_screen.dart';
import 'package:genet_church_portal/features/screens/show_members_screen.dart';
import 'package:genet_church_portal/shared_widgets/main_layout.dart';
import 'features/auth/presentation/login_screen.dart';

import 'features/screens/members_detail_screen.dart';
import 'features/screens/sessions_screen.dart';

final routerAuthRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(dioProvider), const FlutterSecureStorage()),
);

final Map<String, List<String>> _routeBreadcrumbs = {
  '/dashboard': ['App', 'Dashboard'],
  '/settings': ['App', 'Settings'],
  '/profile': ['App', 'User', 'Profile'],
  '/sessions': ['App', 'User', 'Security'],
  '/report-churchs': ['App', 'Church', 'Reports'],
  '/add-church': ['App', 'Church', 'Add Church'],
  '/report-pastors': ['App', 'Pastors', 'Reports'],
  '/add-pastors': ['App', 'Pastors', 'Add Pastor'],
  '/departments': ['App', 'Departments', 'Reports'],
  '/report-servants': ['App', 'Servants', 'Reports'],
  '/add-members': ['App', 'Members', 'Add Member'],
  '/show-members': ['App', 'Members', 'Show Members'],
  '/show-members/:memberId': ['App', 'Members', 'Member Details'],

  '/advanced-reports': ['App', 'Analytics'],
  '/activity-log': ['App', 'System', 'Activity Log'],
};

const _superAdminOnlyRoutes = [
  '/report-churchs',
  '/add-church',
  '/report-pastors',
  '/add-pastors',
  '/advanced-reports',
];

const _pastorOnlyRoutes = [];

const _pastorAndServantRoutes = ['/add-members'];

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',
      navigatorKey: _rootNavigatorKey,
      redirect: (BuildContext context, GoRouterState state) async {
        final authRepository = ref.read(routerAuthRepositoryProvider);
        final userFromRepo = await authRepository.getCurrentUser();
        final userFromState = ref.read(authStateProvider);

        final user = userFromState ?? userFromRepo;
        final isLoggedIn = user != null;
        final isLoggingIn = state.matchedLocation == '/login';

        if (userFromState == null && userFromRepo != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(authStateProvider.notifier).updateUser(userFromRepo);
          });
        }

        if (!isLoggedIn && !isLoggingIn) return '/login';
        if (isLoggedIn && isLoggingIn) return '/dashboard';

        if (isLoggedIn) {
          final role = user.roleEnum;
          final path = state.matchedLocation;

          if (role != UserRole.SUPER_ADMIN &&
              _superAdminOnlyRoutes.any((route) => path.startsWith(route))) {
            return '/dashboard';
          }
          if (role != UserRole.PASTOR &&
              _pastorOnlyRoutes.any((route) => path.startsWith(route))) {
            return '/dashboard';
          }
          if (role == UserRole.SUPER_ADMIN &&
              _pastorAndServantRoutes.any((route) => path.startsWith(route))) {
            return '/dashboard';
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            final breadcrumbs =
                _routeBreadcrumbs[state.matchedLocation] ?? ['App'];
            return MainLayout(breadcrumbs: breadcrumbs, child: child);
          },
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/sessions',
              builder: (context, state) => const SessionsScreen(),
            ),
            GoRoute(
              path: '/report-churchs',
              builder: (context, state) => const ReportChurchsScreen(),
            ),
            GoRoute(
              path: '/add-church',
              builder: (context, state) => const AddChurchScreen(),
            ),
            GoRoute(
              path: '/report-pastors',
              builder: (context, state) => const ReportPastorsScreen(),
            ),
            GoRoute(
              path: '/add-pastors',
              builder: (context, state) => const AddPastorsScreen(),
            ),
            GoRoute(
              path: '/departments',
              builder: (context, state) => const ReportDepartmentsScreen(),
            ),
            GoRoute(
              path: '/report-servants',
              builder: (context, state) => const ReportServantsScreen(),
            ),
            GoRoute(
              path: '/add-members',
              builder: (context, state) => const AddMembersScreen(),
            ),
            GoRoute(
              path: '/show-members',
              builder: (context, state) => const ShowMembersScreen(),
            ),
            GoRoute(
              path: '/show-members/:memberId',
              builder: (context, state) {
                final memberId = state.pathParameters['memberId']!;
                return MemberDetailsScreen(memberId: memberId);
              },
            ),

            GoRoute(
              path: '/advanced-reports',
              builder: (context, state) => const AdvancedReportsScreen(),
            ),
            GoRoute(
              path: '/activity-log',
              builder: (context, state) => const ActivityLogScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
