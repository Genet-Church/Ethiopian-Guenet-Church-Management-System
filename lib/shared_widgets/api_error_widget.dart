import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

class ApiErrorWidget extends StatelessWidget {
  final Object error;
  const ApiErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    String title = 'An Error Occurred';
    String message = 'Failed to load data. Please try again later.';
    IconData icon = Iconsax.warning_2;

    if (error is DioException) {
      final dioError = error as DioException;
      final statusCode = dioError.response?.statusCode;

      if (statusCode == 403) {
        title = 'Access Denied';
        message = 'You do not have permission to view this content.';
        icon = Iconsax.lock;
      } else if (statusCode == 404) {
        title = 'Not Found';
        message = 'The requested resource could not be found on the server.';
        icon = Iconsax.search_zoom_out;
      } else if (statusCode != null && statusCode >= 500) {
        title = 'Server Error';
        message =
        'There was a problem communicating with the server.';
        icon = Iconsax.danger;
      }
    }

    return Center(
      heightFactor: 5,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
            color: theme.colorScheme.error.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.2))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.error, size: 32),
            const SizedBox(height: 16),
            Text(title,
                style: theme.textTheme.titleLarge?.copyWith(color: appColors.textPrimary)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: appColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}