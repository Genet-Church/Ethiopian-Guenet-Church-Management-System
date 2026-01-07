import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/data/models/church_model.dart';
import 'package:genet_church_portal/data/models/dashboard_model.dart';
import 'package:genet_church_portal/data/models/department_model.dart';
import 'package:genet_church_portal/data/models/member_model.dart';
import 'package:genet_church_portal/data/models/paginated_response.dart';
import 'package:genet_church_portal/data/models/pastor_model.dart';
import 'package:genet_church_portal/data/models/servant_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/services/api_service.dart';
import '../models/pastor_dashboard_model.dart';
import '../models/session_model.dart';

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiRepository(dio);
});

class ApiRepository {
  final Dio _dio;
  ApiRepository(this._dio);

  Future<SuperAdminDashboardStats> getSuperAdminDashboardStats({
    String timeframe = 'all',
  }) async {
    final response = await _dio.get(
      '/dashboard/super-admin',
      queryParameters: {'timeframe': timeframe},
    );
    return SuperAdminDashboardStats.fromJson(response.data);
  }

  Future<PastorDashboardStats> getPastorDashboardStats(
    String churchId, {
    String timeframe = 'all',
  }) async {
    final response = await _dio.get(
      '/dashboard/pastor',
      queryParameters: {'churchId': churchId, 'timeframe': timeframe},
    );
    return PastorDashboardStats.fromJson(response.data);
  }

  Future<void> addMember({
    required Member member,
    required String churchId,
  }) async {
    await _dio.post(
      '/church-members',
      queryParameters: {'churchId': churchId},
      data: member.toJson(),
    );
  }

  Future<PaginatedResult<Member>> getMembers(
    String churchId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/church-members',
        queryParameters: {'churchId': churchId, 'page': page, 'limit': limit},
      );
      final responseData = response.data['data'] as List;
      final meta = response.data['meta'];
      final members = responseData
          .map((json) => Member.fromJson(json))
          .toList();
      return PaginatedResult(
        data: members,
        currentPage: meta['currentPage'],
        totalPages: meta['totalPages'],
        totalItems: meta['totalItems'],
        itemCount: meta['itemCount'],
        itemsPerPage: meta['itemsPerPage'],
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 404) {
        return PaginatedResult(
          data: const [],
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
          itemCount: 0,
          itemsPerPage: limit,
        );
      }

      if (statusCode != null && statusCode >= 500 && statusCode < 600) {
        return PaginatedResult(
          data: const [],
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
          itemCount: 0,
          itemsPerPage: limit,
        );
      }
      rethrow;
    }
  }

  Future<Member> getMemberById(String memberId, String churchId) async {
    final response = await _dio.get(
      '/church-members/$memberId',
      queryParameters: {'churchId': churchId},
    );
    return Member.fromJson(response.data);
  }

  Future<void> removeMember(String memberId, String churchId) async {
    await _dio.delete(
      '/church-members/$memberId',
      queryParameters: {'churchId': churchId},
    );
  }

  Future<PaginatedResult<Pastor>> getPastors({
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _dio.get(
      '/pastors',
      queryParameters: {'page': page, 'limit': limit},
    );
    final responseData = response.data['data'] as List;
    final meta = response.data['meta'];
    final pastors = responseData.map((json) => Pastor.fromJson(json)).toList();
    return PaginatedResult(
      data: pastors,
      currentPage: meta['currentPage'],
      totalPages: meta['totalPages'],
      totalItems: meta['totalItems'],
      itemCount: meta['itemCount'],
      itemsPerPage: meta['itemsPerPage'],
    );
  }

  Future<Pastor> addPastor({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/pastors',
      data: {'fullName': fullName, 'email': email, 'password': password},
    );
    return Pastor.fromJson(response.data);
  }

  Future<Pastor> updatePastor({
    required String pastorId,
    required String fullName,
    required String email,
  }) async {
    final response = await _dio.patch(
      '/pastors/$pastorId',
      data: {'fullName': fullName, 'email': email},
    );
    return Pastor.fromJson(response.data);
  }

  Future<void> removePastor(String pastorId) async {
    await _dio.delete('/pastors/$pastorId');
  }

  Future<Pastor> assignChurchToPastor({
    required String pastorId,
    required String? churchId,
  }) async {
    final response = await _dio.patch(
      '/pastors/$pastorId/assign-church',
      data: {'churchId': churchId},
    );
    return Pastor.fromJson(response.data);
  }

  Future<void> unassignChurchFromPastor(String pastorId) async {
    await _dio.patch('/pastors/$pastorId/unassign-church');
  }

  Future<PaginatedResult<Church>> getChurches({
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _dio.get(
      '/churches',
      queryParameters: {'page': page, 'limit': limit},
    );
    final responseData = response.data['data'] as List;
    final meta = response.data['meta'];
    final churches = responseData.map((json) => Church.fromJson(json)).toList();
    return PaginatedResult(
      data: churches,
      currentPage: meta['currentPage'],
      totalPages: meta['totalPages'],
      totalItems: meta['totalItems'],
      itemCount: meta['itemCount'],
      itemsPerPage: meta['itemsPerPage'],
    );
  }

  Future<Church> addChurch(Church church) async {
    final response = await _dio.post('/churches', data: church.toCreateJson());
    return Church.fromJson(response.data);
  }

  Future<Church> updateChurch({
    required String churchId,
    required Church church,
  }) async {
    final response = await _dio.patch(
      '/churches/$churchId',
      data: church.toUpdateJson(),
    );
    return Church.fromJson(response.data);
  }

  Future<void> removeChurch(String id) async {
    await _dio.delete('/churches/$id');
  }

  Future<List<Department>> getDepartments(String churchId) async {
    final response = await _dio.get(
      '/departments',
      queryParameters: {'churchId': churchId},
    );
    final responseData = response.data as List;
    return responseData.map((json) => Department.fromJson(json)).toList();
  }

  Future<Department> addDepartment({required String name}) async {
    final response = await _dio.post('/departments', data: {'name': name});
    return Department.fromJson(response.data);
  }

  Future<Department> updateDepartment({
    required String departmentId,
    required String name,
  }) async {
    final response = await _dio.patch(
      '/departments/$departmentId',
      data: {'name': name},
    );
    return Department.fromJson(response.data);
  }

  Future<void> removeDepartment(String id) async {
    await _dio.delete('/departments/$id');
  }

  Future<void> assignServantToDepartment({
    required String departmentId,
    required String servantId,
  }) async {
    await _dio.post(
      '/departments/$departmentId/assign-servant',
      data: {'servantId': servantId},
    );
  }

  Future<PaginatedResult<Servant>> getServants(
    String churchId, {
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _dio.get(
      '/servants',
      queryParameters: {'churchId': churchId, 'page': page, 'limit': limit},
    );
    final responseData = response.data['data'] as List;
    final meta = response.data['meta'];
    final servants = responseData
        .map((json) => Servant.fromJson(json))
        .toList();
    return PaginatedResult(
      data: servants,
      currentPage: meta['currentPage'],
      totalPages: meta['totalPages'],
      totalItems: meta['totalItems'],
      itemCount: meta['itemCount'],
      itemsPerPage: meta['itemsPerPage'],
    );
  }

  Future<Servant> addServant({
    required String fullName,
    required String email,
    required String password,
    required String churchId,
  }) async {
    final response = await _dio.post(
      '/servants',
      data: {'fullName': fullName, 'email': email, 'password': password},
      queryParameters: {'churchId': churchId},
    );
    return Servant.fromJson(response.data);
  }

  Future<Servant> updateServant({
    required String servantId,
    required String fullName,
  }) async {
    final response = await _dio.patch(
      '/servants/$servantId',
      data: {'fullName': fullName},
    );
    return Servant.fromJson(response.data);
  }

  Future<void> removeServant(String id) async {
    await _dio.delete('/servants/$id');
  }

  Future<List<Session>> getSessions() async {
    final currentSessionResponse = await _dio.get('/sessions/current');
    final allSessionsResponse = await _dio.get('/sessions/all');

    final currentSessionId = currentSessionResponse.data['id'];
    final sessionsList = (allSessionsResponse.data as List)
        .map(
          (json) => Session.fromJson(json, currentSessionId: currentSessionId),
        )
        .toList();

    sessionsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessionsList;
  }

  Future<void> revokeSession(String sessionId) async {
    await _dio.delete('/sessions/$sessionId/revoke');
  }

  Future<void> revokeAllSessions({bool keepCurrent = false}) async {
    await _dio.delete(
      '/sessions/revoke-all',
      queryParameters: {'keepCurrent': keepCurrent},
    );
  }

  Future<PaginatedResult<UserModel>> getUsers() async {
    final response = await _dio.get('/person');
    final responseData = response.data['data'] as List;
    final meta = response.data['meta'];
    final users = responseData.map((json) => UserModel.fromJson(json)).toList();
    return PaginatedResult(
      data: users,
      currentPage: meta['currentPage'],
      totalPages: meta['totalPages'],
      totalItems: meta['totalItems'],
      itemCount: meta['itemCount'],
      itemsPerPage: meta['itemsPerPage'],
    );
  }
}
