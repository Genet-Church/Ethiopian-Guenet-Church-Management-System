import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'church_selection_provider.g.dart';

@riverpod
class CurrentChurch extends _$CurrentChurch {
  @override
  String? build() {
    final user = ref.watch(authStateProvider);

    if (user != null) {
      // Handle PASTOR role
      if (user.roleEnum == UserRole.PASTOR) {
        // First, try to get church ID from user's pastorDetails
        if (user.pastorDetails != null &&
            user.pastorDetails!['churchId'] != null) {
          final churchId = user.pastorDetails!['churchId'] as String?;
          if (churchId != null && churchId.isNotEmpty) {
            return churchId;
          }
        }
        // If not in pastorDetails, try to get from currentPastorProvider
        final pastorAsync = ref.watch(currentPastorProvider);
        if (pastorAsync.hasValue && pastorAsync.value?.churchId != null) {
          final churchId = pastorAsync.value!.churchId;
          if (churchId != null && churchId.isNotEmpty) {
            return churchId;
          }
        }
      }
      
      // Handle SERVANT role
      if (user.roleEnum == UserRole.SERVANT) {
        // Try to get church ID from user's servantDetails
        if (user.servantDetails != null &&
            user.servantDetails!['churchId'] != null) {
          final churchId = user.servantDetails!['churchId'] as String?;
          if (churchId != null && churchId.isNotEmpty) {
            return churchId;
          }
        }
      }
    }

    return state;
  }

  void selectChurch(String? churchId) {
    final user = ref.read(authStateProvider);

    if (user != null && user.roleEnum == UserRole.SUPER_ADMIN) {
      state = churchId;
    }
  }
}