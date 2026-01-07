import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/data/models/search_command_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/data/services/search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_providers.g.dart';

final rawSearchQueryProvider = StateProvider<String>((ref) => '');

@riverpod
Future<String> debouncedSearchQuery(Ref ref) async {
  final query = ref.watch(rawSearchQueryProvider);
  await Future.delayed(const Duration(milliseconds: 400));
  if (query != ref.read(rawSearchQueryProvider)) {
    throw StateError('Cancelled');
  }
  return query;
}

@riverpod
Future<List<SearchCommand>> searchResults(Ref ref) async {
  final query = ref.watch(debouncedSearchQueryProvider).valueOrNull ?? '';
  final user = ref.watch(authStateProvider);
  final currentRole = user?.roleEnum ?? UserRole.SERVANT;

  if (query.isEmpty) {
    return [];
  }

  final allCommands =
  ref.read(searchServiceProvider).getCommandsForRole(currentRole);
  return allCommands
      .where((cmd) => cmd.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
}