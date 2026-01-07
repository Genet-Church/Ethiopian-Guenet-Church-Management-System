import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/shared_widgets/advanced_filter_bar.dart';
import 'package:genet_church_portal/shared_widgets/card_shimmer_loader.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_data_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/modern_report_list.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/department_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/state/church_selection_provider.dart';
import 'package:genet_church_portal/shared_widgets/api_error_widget.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/page_header.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../../core/localization/app_localization.dart';

class ReportDepartmentsScreen extends HookConsumerWidget {
  const ReportDepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final departmentsAsync = ref.watch(departmentsProvider);
    final selectedChurchId = ref.watch(currentChurchProvider);
    final userRole = ref.watch(authStateProvider)?.roleEnum;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    final searchQuery = useState('');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: loc.departmentRecords,
            description: loc.manageDepartmentsDesc,
            action: userRole == UserRole.PASTOR
                ? PrimaryButton(
              text: loc.addNewDepartment,
              icon: Iconsax.add,
              onPressed: () async {
                if (selectedChurchId == null) {
                  context.showErrorNotification(
                    title: loc.actionRequired,
                    message: loc.selectChurchFirst,
                  );
                  return;
                }
                _showAddDepartmentDialog(context, ref, loc);
              },
            )
                : null,
          ),
          const SizedBox(height: 24),
          if (selectedChurchId == null)
            NoChurchSelectedState(
              message: loc.selectChurchManageDepartments,
            )
          else
            Column(
              children: [
                AdvancedFilterBar(
                  searchHint: loc.searchDepartmentHint,
                  searchValue: searchQuery.value,
                  onSearchChanged: (val) => searchQuery.value = val,
                  onClearAll: () => searchQuery.value = '',
                ),
                const SizedBox(height: 24),
                departmentsAsync.when(
                  data: (departments) {
                    final filteredDepartments = departments.where((dept) {
                      if (searchQuery.value.isEmpty) return true;
                      return dept.name.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      );
                    }).toList();

                    if (filteredDepartments.isEmpty) {
                      return _buildEmptyState(
                        context,
                        searchQuery.value.isNotEmpty,
                        userRole,
                        ref,
                        loc,
                      );
                    }

                    return ModernDataGrid.responsive(
                      context: context,
                      mainAxisSpacing: MediaQuery.of(context).size.width < 600
                          ? 12
                          : 16,
                      crossAxisSpacing: MediaQuery.of(context).size.width < 600
                          ? 12
                          : 16,
                      children: filteredDepartments.asMap().entries.map((
                          entry,
                          ) {
                        final index = entry.key;
                        final department = entry.value;

                        return ModernDataCard(
                          index: index,
                          leading: DataCardAvatar(
                            icon: Iconsax.folder,
                            backgroundColor: theme.colorScheme.secondary,
                          ),
                          title: department.name,
                          subtitle: 'ID: ${department.id}',
                          chips: [
                            DataChip(
                              label: loc.department,
                              icon: Iconsax.category,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                          actions: userRole == UserRole.PASTOR
                              ? [
                            DataAction(
                              label: loc.edit,
                              icon: Iconsax.edit,
                              color: theme.colorScheme.primary,
                              onPressed: () => _showEditDepartmentDialog(
                                context,
                                ref,
                                department,
                                loc,
                              ),
                            ),
                            DataAction(
                              label: loc.delete,
                              icon: Iconsax.trash,
                              isDestructive: true,
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(
                                    context,
                                    ref,
                                    department.id,
                                    department.name,
                                    loc,
                                  ),
                            ),
                          ]
                              : null,
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      CardGridShimmerLoader.responsive(context: context),
                  error: (err, stack) => ModernCard(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: ApiErrorWidget(error: err),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      bool hasFilters,
      UserRole? userRole,
      WidgetRef ref,
      AppLocalization loc,
      ) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ModernCard(
      child: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters ? Iconsax.search_zoom_out : Iconsax.folder_open,
                size: 48,
                color: theme.colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters
                  ? loc.noDepartmentsMatch
                  : loc.noDepartmentsFound,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: appColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              hasFilters
                  ? loc.adjustSearchTerms
                  : userRole == UserRole.PASTOR
                  ? loc.addFirstDepartmentDesc
                  : loc.noDepartmentsYet,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasFilters && userRole == UserRole.PASTOR) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: loc.addFirstDepartment,
                icon: Iconsax.add,
                onPressed: () => _showAddDepartmentDialog(context, ref, loc),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddDepartmentDialog(BuildContext context, WidgetRef ref, AppLocalization loc) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.addNewDepartment),
        content: Form(
          key: formKey,
          child: ModernInput(
            controller: nameController,
            label: loc.departmentName,
            prefixIcon: Iconsax.folder,
            validator: (v) => v!.trim().isEmpty ? loc.required : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(loc.cancel),
          ),
          PrimaryButton(
            text: loc.addDepartment,
            onPressedAsync: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  await ref
                      .read(departmentsProvider.notifier)
                      .addDepartment(name: nameController.text);
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.success,
                      message:
                      loc.departmentAddedSuccess.replaceAll('{name}', nameController.text),
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorNotification(
                      title: loc.error,
                      message: e is DioException
                          ? (e.response?.data['message'] ?? 'An error occurred')
                          : 'An unknown error occurred.',
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDepartmentDialog(
      BuildContext context,
      WidgetRef ref,
      Department department,
      AppLocalization loc,
      ) {
    final nameController = TextEditingController(text: department.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.editDepartment.replaceAll('{name}', department.name)),
        content: Form(
          key: formKey,
          child: ModernInput(
            controller: nameController,
            label: loc.departmentName,
            prefixIcon: Iconsax.folder,
            validator: (v) => v!.trim().isEmpty ? loc.required : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(loc.cancel),
          ),
          PrimaryButton(
            text: loc.saveChanges,
            onPressedAsync: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  await ref
                      .read(departmentsProvider.notifier)
                      .updateDepartment(
                    departmentId: department.id,
                    name: nameController.text,
                  );
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.success,
                      message: loc.departmentUpdatedSuccess,
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorNotification(
                      title: loc.error,
                      message: loc.failedUpdate,
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context,
      WidgetRef ref,
      String departmentId,
      String departmentName,
      AppLocalization loc,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.confirmDeletion),
          content: Text(
            loc.confirmDepartmentDeletion.replaceAll('{name}', departmentName),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(loc.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(loc.delete),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await ref
                      .read(departmentsProvider.notifier)
                      .removeDepartment(departmentId);
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.deleted,
                      message: loc.departmentRemoved.replaceAll('{name}', departmentName),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorNotification(
                      title: loc.error,
                      message: loc.failedDeleteDepartment,
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}