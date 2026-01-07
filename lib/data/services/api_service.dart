import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genet_church_portal/core/constants.dart';
import 'package:genet_church_portal/data/models/user_model.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: 'accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          const storage = FlutterSecureStorage();
          final refreshToken = await storage.read(key: 'refreshToken');
          if (refreshToken != null) {
            try {
              final refreshDio = Dio(
                BaseOptions(baseUrl: AppConstants.baseUrl),
              );
              final refreshResponse = await refreshDio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );

              if (refreshResponse.statusCode == 200) {
                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];
                final userJson = refreshResponse.data['user'];

                await storage.write(key: 'accessToken', value: newAccessToken);
                if (newRefreshToken != null) {
                  await storage.write(
                    key: 'refreshToken',
                    value: newRefreshToken,
                  );
                }

                if (userJson != null) {
                  final user = UserModel.fromJson(userJson);
                  await storage.write(
                    key: 'user',
                    value: jsonEncode(user.toJson()),
                  );
                }

                e.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final clonedRequest = await dio.request(
                  e.requestOptions.path,
                  options: Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers,
                  ),
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                );
                return handler.resolve(clonedRequest);
              }
            } catch (refreshError) {
              await storage.deleteAll();
            }
          }
        }
        return handler.next(e);
      },
    ),
  );

  if (const bool.fromEnvironment('dart.vm.product') == false) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  return dio;
});
