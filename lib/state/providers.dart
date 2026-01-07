import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/data/models/activity_log_model.dart';
import 'package:genet_church_portal/data/models/church_model.dart';
import 'package:genet_church_portal/data/models/dashboard_base_model.dart';
import 'package:genet_church_portal/data/models/department_model.dart';
import 'package:genet_church_portal/data/models/member_model.dart';
import 'package:genet_church_portal/data/models/pastor_model.dart';
import 'package:genet_church_portal/data/models/servant_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/models/paginated_response.dart';
import 'package:genet_church_portal/data/repositories/api_repository.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/state/church_selection_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

final dashboardTimeframeProvider = StateProvider<String>((ref) => 'all');

final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStatsBase?>((
  ref,
) async {
  final user = ref.watch(authStateProvider);
  final api = ref.watch(apiRepositoryProvider);

  final timeframe = ref.watch(dashboardTimeframeProvider);

  if (user == null) {
    return null;
  }

  switch (user.roleEnum) {
    case UserRole.SUPER_ADMIN:
      return await api.getSuperAdminDashboardStats(timeframe: timeframe);
    case UserRole.PASTOR:
      final churchId = ref.read(currentChurchProvider);
      if (churchId == null) {
        return null;
      }
      return await api.getPastorDashboardStats(churchId, timeframe: timeframe);
    default:
      return null;
  }
});

@riverpod
Future<List<UserModel>> users(Ref ref) async {
  try {
    final users = await ref.watch(apiRepositoryProvider).getUsers();
    return users.data;
  } catch (e) {
    return [];
  }
}

@riverpod
Future<Pastor?> currentPastor(Ref ref) async {
  final user = ref.watch(authStateProvider);

  if (user == null || user.roleEnum != UserRole.PASTOR) {
    return null;
  }

  if (user.pastorDetails != null) {
    return Pastor(
      id: user.pastorDetails!['id'] ?? '',
      userId: user.id,
      churchId: user.pastorDetails!['churchId'],
      user: user,
    );
  }

  return null;
}

@riverpod
class Pastors extends _$Pastors {
  @override
  Future<List<Pastor>> build() async {
    final user = ref.watch(authStateProvider);
    if (user?.roleEnum != UserRole.SUPER_ADMIN) {
      return [];
    }
    final pastorsResult = await ref.watch(apiRepositoryProvider).getPastors();
    return pastorsResult.data;
  }

  Future<Pastor> addPastor({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final newPastor = await api.addPastor(
      fullName: fullName,
      email: email,
      password: password,
    );
    ref.invalidateSelf();
    await future;
    return newPastor;
  }

  Future<void> updatePastor({
    required String pastorId,
    required String fullName,
    required String email,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;

    state = AsyncValue.data(
      previousState.map((pastor) {
        if (pastor.id == pastorId) {
          final updatedUser = UserModel(
            id: pastor.userId,
            fullName: fullName,
            email: email,
            role: pastor.user?.role ?? 'PASTOR',
            isActive: pastor.user?.isActive ?? true,
            createdAt: pastor.user?.createdAt ?? '',
          );
          return Pastor(
            id: pastor.id,
            userId: pastor.userId,
            churchId: pastor.churchId,
            user: updatedUser,
          );
        }
        return pastor;
      }).toList(),
    );

    try {
      await api.updatePastor(
        pastorId: pastorId,
        fullName: fullName,
        email: email,
      );
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> assignChurchToPastor({
    required String pastorId,
    required String? churchId,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;

    state = AsyncValue.data(
      previousState.map((p) {
        if (p.id == pastorId) {
          return Pastor(
            id: p.id,
            userId: p.userId,
            churchId: churchId,
            user: p.user,
          );
        }
        return p;
      }).toList(),
    );

    try {
      await api.assignChurchToPastor(pastorId: pastorId, churchId: churchId);
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> unassignChurch({required String pastorId}) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;

    state = AsyncValue.data(
      previousState.map((p) {
        if (p.id == pastorId) {
          return Pastor(
            id: p.id,
            userId: p.userId,
            churchId: null,
            user: p.user,
          );
        }
        return p;
      }).toList(),
    );

    try {
      await api.unassignChurchFromPastor(pastorId);
      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> removePastor(String pastorId) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;

    state = AsyncValue.data(
      previousState.where((p) => p.id != pastorId).toList(),
    );

    try {
      await api.removePastor(pastorId);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }
}

@riverpod
class Churches extends _$Churches {
  @override
  Future<List<Church>> build() async {
    final churches = await ref.watch(apiRepositoryProvider).getChurches();
    return churches.data;
  }

  Future<Church> addChurch(Church church) async {
    final api = ref.read(apiRepositoryProvider);
    final newChurch = await api.addChurch(church);
    ref.invalidateSelf();
    await future;
    return newChurch;
  }

  Future<void> updateChurch({
    required String churchId,
    required Church church,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;
    state = AsyncValue.data(
      previousState.map((c) => c.id == churchId ? church : c).toList(),
    );

    try {
      await api.updateChurch(churchId: churchId, church: church);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> removeChurch(String id) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;
    state = AsyncValue.data(previousState.where((c) => c.id != id).toList());

    try {
      await api.removeChurch(id);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }
}

@riverpod
class Departments extends _$Departments {
  @override
  Future<List<Department>> build() {
    final churchId = ref.watch(currentChurchProvider);
    if (churchId == null) return Future.value([]);
    return ref.watch(apiRepositoryProvider).getDepartments(churchId);
  }

  Future<void> addDepartment({required String name}) async {
    final api = ref.read(apiRepositoryProvider);
    await api.addDepartment(name: name);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateDepartment({
    required String departmentId,
    required String name,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;
    state = AsyncValue.data(
      previousState.map((d) {
        if (d.id == departmentId) {
          return Department(id: d.id, name: name, churchId: d.churchId);
        }
        return d;
      }).toList(),
    );

    try {
      await api.updateDepartment(departmentId: departmentId, name: name);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> removeDepartment(String id) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;
    state = AsyncValue.data(previousState.where((d) => d.id != id).toList());

    try {
      await api.removeDepartment(id);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }
}

@riverpod
class Servants extends _$Servants {
  @override
  Future<List<Servant>> build() async {
    final churchId = ref.watch(currentChurchProvider);
    if (churchId == null) return [];
    final servantsResult = await ref
        .watch(apiRepositoryProvider)
        .getServants(churchId);
    return servantsResult.data;
  }

  Future<Servant> addServant({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final churchId = ref.read(currentChurchProvider);
    if (churchId == null) throw Exception('A church must be selected.');
    final api = ref.read(apiRepositoryProvider);
    final newServant = await api.addServant(
      fullName: fullName,
      email: email,
      password: password,
      churchId: churchId,
    );
    ref.invalidateSelf();
    await future;
    return newServant;
  }

  Future<void> updateServant({
    required String servantId,
    required String fullName,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;

    try {
      final updatedServant = await api.updateServant(
        servantId: servantId,
        fullName: fullName,
      );
      state = AsyncValue.data(
        previousState.map((s) {
          if (s.id == servantId) {
            return updatedServant;
          }
          return s;
        }).toList(),
      );
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> assignToDepartment({
    required String departmentId,
    required String servantId,
  }) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;
    state = AsyncValue.data(
      previousState.map((s) {
        if (s.id == servantId) {
          return Servant(
            id: s.id,
            userId: s.userId,
            churchId: s.churchId,
            departmentId: departmentId,
            user: s.user,
          );
        }
        return s;
      }).toList(),
    );

    try {
      await api.assignServantToDepartment(
        departmentId: departmentId,
        servantId: servantId,
      );
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> removeServant(String id) async {
    final api = ref.read(apiRepositoryProvider);
    final previousState = await future;
    state = AsyncValue.data(previousState.where((s) => s.id != id).toList());

    try {
      await api.removeServant(id);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }
}

@riverpod
class Members extends _$Members {
  @override
  void build() {}

  Future<void> addMember({required Member member}) async {
    final churchId = ref.read(currentChurchProvider);
    if (churchId == null) {
      throw Exception("No church selected.");
    }
    await ref
        .read(apiRepositoryProvider)
        .addMember(member: member, churchId: churchId);
    ref.invalidate(membersListProvider);
  }
}

class MemberListState {
  final List<Member> members;
  final int page;
  final bool hasMore;
  final bool isFetchingNextPage;

  const MemberListState({
    this.members = const [],
    this.page = 1,
    this.hasMore = true,
    this.isFetchingNextPage = false,
  });

  MemberListState copyWith({
    List<Member>? members,
    int? page,
    bool? hasMore,
    bool? isFetchingNextPage,
  }) {
    return MemberListState(
      members: members ?? this.members,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
    );
  }
}

@riverpod
class MembersList extends _$MembersList {
  final int _limit = 20;

  @override
  Future<MemberListState> build() async {
    final churchId = ref.watch(currentChurchProvider);
    final user = ref.watch(authStateProvider);

    if (user == null) {
      return const MemberListState(hasMore: false, members: []);
    }

    if (user.roleEnum != UserRole.PASTOR &&
        user.roleEnum != UserRole.SERVANT &&
        user.roleEnum != UserRole.SUPER_ADMIN) {
      return const MemberListState(hasMore: false, members: []);
    }

    if (churchId == null) {
      return const MemberListState(hasMore: false, members: []);
    }

    final result = await ref
        .read(apiRepositoryProvider)
        .getMembers(churchId, page: 1, limit: _limit);
    return MemberListState(
      members: result.data,
      page: 1,
      hasMore: result.currentPage < result.totalPages,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isFetchingNextPage) {
      return;
    }

    final churchId = ref.read(currentChurchProvider);
    if (churchId == null) return;

    state = AsyncData(currentState.copyWith(isFetchingNextPage: true));

    final nextPage = currentState.page + 1;
    try {
      final result = await ref
          .read(apiRepositoryProvider)
          .getMembers(churchId, page: nextPage, limit: _limit);

      state = AsyncValue.data(
        currentState.copyWith(
          members: [...currentState.members, ...result.data],
          page: nextPage,
          hasMore: result.currentPage < result.totalPages,
          isFetchingNextPage: false,
        ),
      );
    } catch (e) {
      state = AsyncData(currentState.copyWith(isFetchingNextPage: false));
    }
  }

  Future<void> removeMember(String memberId) async {
    final churchId = ref.read(currentChurchProvider);
    if (churchId == null) throw Exception("No church selected.");

    final currentState = state.value;
    if (currentState == null) return;

    final updatedMembers = currentState.members
        .where((m) => m.id != memberId)
        .toList();
    state = AsyncData(currentState.copyWith(members: updatedMembers));

    try {
      await ref.read(apiRepositoryProvider).removeMember(memberId, churchId);
    } catch (e) {
      state = AsyncData(currentState);
      rethrow;
    }
  }
}

@riverpod
class ActivityLog extends _$ActivityLog {
  @override
  Future<List<ActivityLogItem>> build() async {
    final user = ref.watch(authStateProvider);
    if (user == null) {
      return [];
    }

    final List<ActivityLogItem> activities = [];

    if (user.roleEnum == UserRole.SUPER_ADMIN) {
      List<Church> churches = [];
      List<Pastor> pastors = [];

      try {
        final results = await Future.wait([
          ref.watch(churchesProvider.future),
          ref.watch(pastorsProvider.future),
        ]);
        churches = results[0] as List<Church>;
        pastors = results[1] as List<Pastor>;
      } catch (_) {}

      for (var p in pastors) {
        if (user.roleEnum == UserRole.SUPER_ADMIN && p.user != null) {
          activities.add(
            ActivityLogItem(
              title: 'New Pastor Added',
              subtitle: '${p.user!.fullName} joined the pastoral team.',
              timestamp: DateTime.tryParse(p.user!.createdAt) ?? DateTime.now(),
              type: ActivityType.pastor,
              path: '/report-pastors',
            ),
          );
        }
      }

      for (var c in churches) {
        activities.add(
          ActivityLogItem(
            title: 'New Church Registered',
            subtitle: '${c.name} is now part of the network.',
            timestamp: DateTime.tryParse(c.dateCreated ?? '') ?? DateTime.now(),
            type: ActivityType.church,
            path: '/report-churchs',
          ),
        );
      }
    } else if (user.roleEnum == UserRole.PASTOR) {
      final churchId = ref.watch(currentChurchProvider);
      if (churchId != null) {
        final api = ref.watch(apiRepositoryProvider);

        try {
          // Fetch data in parallel
          final results = await Future.wait([
            api.getMembers(churchId, limit: 10),
            api.getServants(churchId, limit: 10),
            api.getDepartments(churchId),
          ]);

          final members = (results[0] as PaginatedResult<Member>).data;
          final servants = (results[1] as PaginatedResult<Servant>).data;
          final departments = results[2] as List<Department>;

          for (var m in members) {
            activities.add(
              ActivityLogItem(
                title: 'New Member Added',
                subtitle: '${m.fullName} joined the church.',
                timestamp:
                    DateTime.tryParse(m.dateCreated ?? '') ?? DateTime.now(),
                type: ActivityType.member,
                path: '/show-members',
              ),
            );
          }

          for (var s in servants) {
            if (s.user != null) {
              activities.add(
                ActivityLogItem(
                  title: 'New Servant Added',
                  subtitle: '${s.user!.fullName} joined the serving team.',
                  timestamp:
                      DateTime.tryParse(s.user!.createdAt) ?? DateTime.now(),
                  type: ActivityType.servant,
                  path: '/report-servants',
                ),
              );
            }
          }

          for (var d in departments) {
            activities.add(
              ActivityLogItem(
                title: 'New Department Created',
                subtitle: '${d.name} department was created.',
                timestamp:
                    DateTime.tryParse(d.dateCreated ?? '') ?? DateTime.now(),
                type: ActivityType.department,
                path: '/departments',
              ),
            );
          }
        } catch (e) {
          // Silently fail for activity log or log error
          // Silently fail for activity log or log error
        }
      }
    }

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }
}

@riverpod
Future<Member> memberDetails(Ref ref, String memberId) {
  final churchId = ref.watch(currentChurchProvider);
  if (churchId == null) {
    throw Exception('A church must be selected to view member details.');
  }
  return ref.watch(apiRepositoryProvider).getMemberById(memberId, churchId);
}
