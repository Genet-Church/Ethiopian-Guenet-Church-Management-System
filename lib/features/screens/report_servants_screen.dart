import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/shared_widgets/advanced_filter_bar.dart';
import 'package:genet_church_portal/shared_widgets/card_shimmer_loader.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_data_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_dropdown.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/modern_report_list.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/servant_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/state/church_selection_provider.dart';
import 'package:genet_church_portal/shared_widgets/api_error_widget.dart';
import 'package:genet_church_portal/state/new_item_provider.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/page_header.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../../core/localization/app_localization.dart';
import '../../core/utils/password_validator.dart';

class ReportServantsScreen extends HookConsumerWidget {
  const ReportServantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final selectedChurchId = ref.watch(currentChurchProvider);
    final servantsAsync = ref.watch(servantsProvider);
    final departmentsAsync = ref.watch(departmentsProvider);
    final newlyAddedItemId = ref.watch(newlyAddedItemIdProvider);
    final userRole = ref.watch(authStateProvider)?.roleEnum;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    // Filter states
    final searchQuery = useState('');
    final selectedDepartmentId = useState<String?>(null);

    useEffect(() {
      if (newlyAddedItemId != null) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            ref.read(newlyAddedItemIdProvider.notifier).set(null);
          }
        });
      }
      return null;
    }, [newlyAddedItemId]);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: PageHeader(
              title: loc.servantRecords,
              description: loc.manageServantsDesc,
              action: userRole == UserRole.PASTOR
                  ? PrimaryButton(
                text: loc.addNewServant,
                icon: Iconsax.add,
                onPressed: () async {
                  if (selectedChurchId == null) {
                    context.showErrorNotification(
                      title: loc.actionRequired,
                      message: loc.selectChurchAddServant,
                    );
                    return;
                  }
                  _showAddServantDialog(context, ref, loc);
                },
              )
                  : null,
            ),
          ),
          if (selectedChurchId == null)
            NoChurchSelectedState(
              message: loc.selectChurchManageServants,
            )
          else
            _buildServantsList(
              context,
              ref,
              servantsAsync,
              departmentsAsync,
              searchQuery,
              selectedDepartmentId,
              newlyAddedItemId,
              userRole,
              theme,
              appColors,
              loc,
            ),
        ],
      ),
    );
  }

  Widget _buildServantsList(
      BuildContext context,
      WidgetRef ref,
      AsyncValue<List<Servant>> servantsAsync,
      AsyncValue<List<dynamic>> departmentsAsync,
      ValueNotifier<String> searchQuery,
      ValueNotifier<String?> selectedDepartmentId,
      String? newlyAddedItemId,
      UserRole? userRole,
      ThemeData theme,
      AppColors appColors,
      AppLocalization loc,
      ) {
    // Build department dropdown options
    final departments = departmentsAsync.valueOrNull ?? [];
    final departmentMap = {for (var d in departments) d.id: d.name};

    final filterDropdowns = <FilterDropdownConfig>[
      FilterDropdownConfig(
        label: loc.department,
        icon: Iconsax.folder,
        options: departments
            .map((d) => FilterOption(label: d.name, value: d.id))
            .toList(),
        selectedValue: selectedDepartmentId.value,
        onChanged: (val) => selectedDepartmentId.value = val,
      ),
    ];

    return Column(
      children: [
        // Advanced Filter Bar
        AdvancedFilterBar(
          searchHint: loc.searchServantHint,
          searchValue: searchQuery.value,
          onSearchChanged: (val) => searchQuery.value = val,
          filterDropdowns: filterDropdowns,
          onClearAll: () {
            searchQuery.value = '';
            selectedDepartmentId.value = null;
          },
        ),
        const SizedBox(height: 24),
        // Content
        servantsAsync.when(
          data: (servants) {
            // Apply filters
            final filteredServants = servants.where((servant) {
              // Search filter
              if (searchQuery.value.isNotEmpty) {
                final query = searchQuery.value.toLowerCase();
                final fullName = servant.user?.fullName.toLowerCase() ?? '';
                final email = servant.user?.email.toLowerCase() ?? '';
                if (!fullName.contains(query) && !email.contains(query)) {
                  return false;
                }
              }
              // Department filter
              if (selectedDepartmentId.value != null) {
                if (servant.departmentId != selectedDepartmentId.value) {
                  return false;
                }
              }
              return true;
            }).toList();

            if (filteredServants.isEmpty) {
              return _buildEmptyState(
                context,
                searchQuery.value.isNotEmpty ||
                    selectedDepartmentId.value != null,
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
              children: filteredServants.asMap().entries.map((entry) {
                final index = entry.key;
                final servant = entry.value;
                final isNew = servant.id == newlyAddedItemId;
                final departmentName =
                    departmentMap[servant.departmentId] ?? loc.noneUnassigned;

                return ModernDataCard(
                  index: index,
                  isNew: isNew,
                  leading: DataCardAvatar(
                    initials: getInitials(servant.user?.fullName),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  title: servant.user?.fullName ?? 'Unknown',
                  subtitle: servant.user?.email ?? '',
                  chips: [
                    DataChip(
                      label: departmentName,
                      icon: Iconsax.folder,
                      color: servant.departmentId != null
                          ? theme.colorScheme.secondary
                          : appColors.textSecondary,
                    ),
                  ],
                  actions: userRole == UserRole.PASTOR
                      ? [
                    DataAction(
                      label: loc.assign,
                      icon: Iconsax.building,
                      color: theme.colorScheme.secondary,
                      onPressed: () => _showAssignDepartmentDialog(
                        context,
                        ref,
                        servant,
                        loc,
                      ),
                    ),
                    DataAction(
                      label: loc.edit,
                      icon: Iconsax.edit,
                      color: theme.colorScheme.primary,
                      onPressed: () =>
                          _showEditServantDialog(context, ref, servant, loc),
                    ),
                    DataAction(
                      label: loc.delete,
                      icon: Iconsax.trash,
                      isDestructive: true,
                      onPressed: () => _showDeleteConfirmationDialog(
                        context,
                        ref,
                        servant,
                        loc,
                      ),
                    ),
                  ]
                      : null,
                );
              }).toList(),
            );
          },
          loading: () => CardGridShimmerLoader.responsive(context: context),
          error: (err, stack) => ModernCard(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: ApiErrorWidget(error: err),
            ),
          ),
        ),
      ],
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
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters ? Iconsax.search_zoom_out : Iconsax.people,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters
                  ? loc.noServantsMatch
                  : loc.noServantsFound,
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
                  ? loc.addFirstServantDesc
                  : loc.noServantsYet,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasFilters && userRole == UserRole.PASTOR) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: loc.addFirstServant,
                icon: Iconsax.add,
                onPressed: () => _showAddServantDialog(context, ref, loc),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddServantDialog(BuildContext context, WidgetRef ref, AppLocalization loc) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.addNewServant),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModernInput(
                controller: nameController,
                label: loc.fullName,
                prefixIcon: Iconsax.user,
                validator: (v) => v!.isEmpty ? loc.required : null,
              ),
              const SizedBox(height: 20),
              EmailInput(
                controller: emailController,
                label: loc.email,
                validator: (v) => v!.isEmpty ? loc.required : null,
              ),
              const SizedBox(height: 20),
              PasswordInput(
                controller: passwordController,
                label: loc.temporaryPassword,
                validator: PasswordValidator.validate,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(loc.cancel),
          ),
          PrimaryButton(
            text: loc.addServant,
            onPressedAsync: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final newServant = await ref
                      .read(servantsProvider.notifier)
                      .addServant(
                    fullName: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  ref
                      .read(newlyAddedItemIdProvider.notifier)
                      .set(newServant.id);
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.success,
                      message:
                      loc.servantAddedSuccess.replaceAll('{name}', nameController.text),
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorNotification(
                      title: loc.error,
                      message: loc.failedAddServant,
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

  void _showEditServantDialog(
      BuildContext context,
      WidgetRef ref,
      Servant servant,
      AppLocalization loc,
      ) {
    final nameController = TextEditingController(
      text: servant.user?.fullName ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.editServant),
        content: Form(
          key: formKey,
          child: ModernInput(
            controller: nameController,
            label: loc.newFullName,
            prefixIcon: Iconsax.user,
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
                      .read(servantsProvider.notifier)
                      .updateServant(
                    servantId: servant.id,
                    fullName: nameController.text,
                  );
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.success,
                      message: loc.servantUpdatedSuccess,
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorNotification(
                      title: loc.error,
                      message: loc.failedUpdateServant,
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
      Servant servant,
      AppLocalization loc,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.confirmDeletion),
        content: Text(
          loc.confirmServantDeletion.replaceAll('{name}', servant.user?.fullName ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(loc.delete),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref
                    .read(servantsProvider.notifier)
                    .removeServant(servant.id);
                if (context.mounted) {
                  context.showSuccessNotification(
                    title: loc.deleted,
                    message:
                    loc.servantRemoved.replaceAll('{name}', servant.user?.fullName ?? ''),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  context.showErrorNotification(
                    title: loc.error,
                    message: loc.failedRemoveServant,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAssignDepartmentDialog(
      BuildContext context,
      WidgetRef ref,
      Servant servant,
      AppLocalization loc,
      ) {
    final departmentsAsync = ref.watch(departmentsProvider);

    showDialog(
      context: context,
      builder: (context) {
        return HookConsumer(
          builder: (context, ref, child) {
            final selectedDepartmentId = useState(servant.departmentId);

            return AlertDialog(
              title: Text(loc.assignDepartment),
              content: departmentsAsync.when(
                data: (departments) => ModernDropdown<String>(
                  hintText: loc.selectDepartment,
                  icon: Iconsax.folder,
                  value: selectedDepartmentId.value,
                  items: departments
                      .map(
                        (d) =>
                        DropdownMenuItem(value: d.id, child: Text(d.name)),
                  )
                      .toList(),
                  onChanged: (val) => selectedDepartmentId.value = val,
                  validator: (v) => v == null ? loc.required : null,
                ),
                loading: () =>
                const InlineShimmerLoader(width: 200, height: 48),
                error: (e, s) => Text(loc.couldNotLoadDepartments),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.cancel),
                ),
                PrimaryButton(
                  text: loc.assign,
                  onPressedAsync: () async {
                    if (selectedDepartmentId.value == null) return;
                    try {
                      await ref
                          .read(servantsProvider.notifier)
                          .assignToDepartment(
                        departmentId: selectedDepartmentId.value!,
                        servantId: servant.id,
                      );
                      if (context.mounted) {
                        context.showSuccessNotification(
                          title: loc.success,
                          message: loc.departmentAssigned,
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.showErrorNotification(
                          title: loc.error,
                          message: loc.failedAssignDepartment,
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}