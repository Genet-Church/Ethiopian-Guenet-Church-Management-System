import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genet_church_portal/data/models/login_response.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/services/api_service.dart';
import 'package:genet_church_portal/state/church_selection_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref.watch(dioProvider), const FlutterSecureStorage());
});

final isLoggingOutProvider = StateProvider<bool>((ref) => false);

final authStateProvider = StateNotifierProvider<AuthStateNotifier, UserModel?>((
  ref,
) {
  return AuthStateNotifier(ref.read(authRepositoryProvider), ref);
});

class AuthStateNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthStateNotifier(this._authRepository, this._ref) : super(null) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final userFromStorage = await _authRepository.getCurrentUser();
    if (userFromStorage != null) {
      state = userFromStorage;
      try {
        final freshUser = await _authRepository.fetchAndStoreUserDetails();
        state = freshUser;
      } catch (e) {
        // Failed to refresh, proceed with stale data from storage
      }
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    state = await _authRepository.login(email, password, rememberMe);
  }

  Future<void> logout() async {
    _ref.read(isLoggingOutProvider.notifier).state = true;
    try {
      await _authRepository.logout();
      _ref.read(currentChurchProvider.notifier).selectChurch(null);
      state = null;
    } finally {
      _ref.read(isLoggingOutProvider.notifier).state = false;
    }
  }

  void updateUser(UserModel user) {
    state = user;
  }
}

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<UserModel> login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      await _storage.write(
        key: 'accessToken',
        value: loginResponse.accessToken,
      );
      await _storage.write(
        key: 'refreshToken',
        value: loginResponse.refreshToken,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', rememberMe);
      if (rememberMe) {
        await prefs.setString('email', email);
      } else {
        await prefs.remove('email');
      }

      await _storage.write(
        key: 'user',
        value: jsonEncode(loginResponse.user.toJson()),
      );

      return loginResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await _storage.deleteAll();
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('rememberMe') == false) {
        await prefs.remove('email');
      }
      await prefs.remove('rememberMe');
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<UserModel?> getCurrentUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<UserModel> fetchAndStoreUserDetails() async {
    final user = await me();
    await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
    return user;
  }

  Future<UserModel> me() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _dio.post(
        '/auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
