import 'package:dio/dio.dart';
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
import 'package:genet_church_portal/state/new_item_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/pastor_model.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/api_error_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../../core/localization/app_localization.dart';
import '../../core/utils/password_validator.dart';

class ReportPastorsScreen extends HookConsumerWidget {
  const ReportPastorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final pastorsAsync = ref.watch(pastorsProvider);
    final churchesAsync = ref.watch(churchesProvider);
    final newlyAddedItemId = ref.watch(newlyAddedItemIdProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    // Filter states
    final searchQuery = useState('');
    final selectedChurchFilter = useState<String?>(null);
    final isDeleting = useState<String?>(null);

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

    final churches = churchesAsync.valueOrNull ?? [];
    final churchMap = {for (var c in churches) c.id: c.name};

    final filterDropdowns = <FilterDropdownConfig>[
      FilterDropdownConfig(
        label: loc.navChurches,
        icon: Iconsax.building,
        options: churches
            .map((c) => FilterOption(label: c.name, value: c.id))
            .toList(),
        selectedValue: selectedChurchFilter.value,
        onChanged: (val) => selectedChurchFilter.value = val,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width < 600 ? 16 : 32,
            ),
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width < 600 ? 16 : 32,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.pastorRecords,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 24
                              : 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.managePastorsDesc,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 14
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                PrimaryButton(
                  onPressed: () => _showAddPastorDialog(context, ref, loc),
                  text: loc.addNewPastor,
                  icon: Iconsax.add,
                ),
              ],
            ),
          ),
          AdvancedFilterBar(
            searchHint: loc.searchPastorHint,
            searchValue: searchQuery.value,
            onSearchChanged: (val) => searchQuery.value = val,
            filterDropdowns: filterDropdowns,
            onClearAll: () {
              searchQuery.value = '';
              selectedChurchFilter.value = null;
            },
          ),
          const SizedBox(height: 24),
          churchesAsync.when(
            data: (_) => pastorsAsync.when(
              data: (pastors) {
                final filteredPastors = pastors.where((pastor) {
                  if (searchQuery.value.isNotEmpty) {
                    final query = searchQuery.value.toLowerCase();
                    final fullName = pastor.user?.fullName ?? '';
                    final email = pastor.user?.email ?? '';
                    if (!fullName.toLowerCase().contains(query) &&
                        !email.toLowerCase().contains(query)) {
                      return false;
                    }
                  }
                  if (selectedChurchFilter.value != null) {
                    if (pastor.churchId != selectedChurchFilter.value) {
                      return false;
                    }
                  }
                  return true;
                }).toList();

                if (filteredPastors.isEmpty) {
                  return _EmptyState(
                    hasFilters:
                    searchQuery.value.isNotEmpty ||
                        selectedChurchFilter.value != null,
                    onAddPressed: () => _showAddPastorDialog(context, ref, loc),
                    loc: loc,
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
                  children: filteredPastors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final pastor = entry.value;
                    final isNew = pastor.id == newlyAddedItemId;
                    final churchName =
                        churchMap[pastor.churchId] ?? loc.noneUnassigned;

                    return ModernDataCard(
                      index: index,
                      isNew: isNew,
                      leading: DataCardAvatar(
                        initials: getInitials(pastor.user?.fullName),
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                      title: pastor.user?.fullName ?? 'Unknown',
                      subtitle: pastor.user?.email ?? '',
                      chips: [
                        DataChip(
                          label: churchName,
                          icon: Iconsax.building,
                          color: pastor.churchId != null
                              ? theme.colorScheme.primary
                              : appColors.textSecondary,
                        ),
                      ],
                      actions: [
                        DataAction(
                          label: loc.assign,
                          icon: Iconsax.building,
                          color: theme.colorScheme.secondary,
                          onPressed: () =>
                              _showAssignChurchDialog(context, ref, pastor, loc),
                        ),
                        DataAction(
                          label: loc.edit,
                          icon: Iconsax.edit,
                          color: theme.colorScheme.primary,
                          onPressed: () =>
                              _showEditPastorDialog(context, ref, pastor, loc),
                        ),
                        DataAction(
                          label: loc.delete,
                          icon: Iconsax.trash,
                          isDestructive: true,
                          isLoading: isDeleting.value == pastor.id,
                          onPressed: () => _showDeleteConfirmationDialog(
                            context,
                            ref,
                            pastor,
                            isDeleting,
                            loc,
                          ),
                        ),
                      ],
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
            loading: () => CardGridShimmerLoader.responsive(context: context),
            error: (err, stack) => ModernCard(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: ApiErrorWidget(error: err),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context,
      WidgetRef ref,
      Pastor pastor,
      ValueNotifier<String?> isDeleting,
      AppLocalization loc,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.confirmDeletion),
          content: Text(
            loc.confirmPastorDeletion.replaceAll(
                '{name}', pastor.user?.fullName ?? ''),
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
                isDeleting.value = pastor.id;
                Navigator.of(dialogContext).pop();
                try {
                  await ref
                      .read(pastorsProvider.notifier)
                      .removePastor(pastor.id);
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.success,
                      message:
                      loc.pastorDeleted.replaceAll(
                          '{name}', pastor.user?.fullName ?? ''),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    String message = loc.failedDeletePastor;
                    if (e is DioException && e.response?.statusCode == 500) {
                      message = loc.failedDeletePastorServer;
                    }
                    context.showErrorNotification(
                      title: loc.error,
                      message: message,
                    );
                  }
                } finally {
                  if (context.mounted) {
                    isDeleting.value = null;
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddPastorDialog(BuildContext context, WidgetRef ref, AppLocalization loc) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return HookConsumer(
          builder: (context, ref, child) {
            final selectedChurchId = useState<String?>(null);
            final churchesAsync = ref.watch(churchesProvider);

            return AlertDialog(
              title: Text(loc.addNewPastor),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
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
                      const SizedBox(height: 20),
                      churchesAsync.when(
                        data: (churches) => ModernDropdown<String?>(
                          hintText: loc.assignChurchOptional,
                          icon: Iconsax.building,
                          value: selectedChurchId.value,
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text(loc.noneUnassigned),
                            ),
                            ...churches.map(
                                  (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            ),
                          ],
                          onChanged: (val) => selectedChurchId.value = val,
                        ),
                        loading: () =>
                        const InlineShimmerLoader(width: 200, height: 48),
                        error: (e, s) => Text(loc.couldNotLoadChurches),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(loc.cancel),
                ),
                PrimaryButton(
                  text: loc.addPastor,
                  onPressedAsync: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final newPastor = await ref
                            .read(pastorsProvider.notifier)
                            .addPastor(
                          fullName: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        if (selectedChurchId.value != null) {
                          await ref
                              .read(pastorsProvider.notifier)
                              .assignChurchToPastor(
                            pastorId: newPastor.id,
                            churchId: selectedChurchId.value!,
                          );
                        }

                        ref
                            .read(newlyAddedItemIdProvider.notifier)
                            .set(newPastor.id);

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                          context.showSuccessNotification(
                            title: loc.pastorAdded,
                            message:
                            loc.pastorAddedSuccess.replaceAll('{name}', nameController.text),
                          );
                        }
                      } catch (e) {
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                          context.showErrorNotification(
                            title: loc.failedAddPastor,
                            message:
                            e.toString(),
                          );
                        }
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

  void _showEditPastorDialog(
      BuildContext context,
      WidgetRef ref,
      Pastor pastor,
      AppLocalization loc,
      ) {
    final nameController = TextEditingController(
      text: pastor.user?.fullName ?? '',
    );
    final emailController = TextEditingController(
      text: pastor.user?.email ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(loc.editPastor),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ModernInput(
                  controller: nameController,
                  label: loc.fullName,
                  prefixIcon: Iconsax.user,
                  validator: (val) =>
                  val!.isEmpty ? loc.required : null,
                ),
                const SizedBox(height: 20),
                EmailInput(
                  controller: emailController,
                  label: loc.email,
                  validator: (val) =>
                  val!.isEmpty ? loc.required : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(loc.cancel),
            ),
            PrimaryButton(
              text: loc.saveChanges,
              onPressedAsync: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await ref
                        .read(pastorsProvider.notifier)
                        .updatePastor(
                      pastorId: pastor.id,
                      fullName: nameController.text,
                      email: emailController.text,
                    );
                    if (dialogContext.mounted) {
                      context.showSuccessNotification(
                        title: loc.success,
                        message: loc.pastorUpdatedSuccess,
                      );
                      Navigator.pop(dialogContext);
                    }
                  } catch (e) {
                    if (dialogContext.mounted) {
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
        );
      },
    );
  }

  void _showAssignChurchDialog(
      BuildContext context,
      WidgetRef ref,
      Pastor pastor,
      AppLocalization loc,
      ) {
    final churchesAsync = ref.watch(churchesProvider);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return HookConsumer(
          builder: (context, ref, child) {
            final validChurchIds =
                churchesAsync.valueOrNull?.map((c) => c.id).toSet() ?? {};
            final initialChurchId =
            pastor.churchId != null &&
                validChurchIds.contains(pastor.churchId)
                ? pastor.churchId
                : null;

            final selectedChurchId = useState(initialChurchId);
            final isUnassigning = useState(false);

            return AlertDialog(
              title: Text(loc.assignChurchTo.replaceAll('{name}', pastor.user?.fullName ?? '')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  churchesAsync.when(
                    data: (churches) => ModernDropdown<String?>(
                      hintText: loc.selectChurch,
                      icon: Iconsax.building,
                      value: selectedChurchId.value,
                      items: [
                        ...churches.map(
                              (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        selectedChurchId.value = val;
                      },
                    ),
                    loading: () =>
                    const InlineShimmerLoader(width: 200, height: 48),
                    error: (e, s) => Text(loc.couldNotLoadChurches),
                  ),
                  if (initialChurchId != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.errorContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                      child: TextButton(
                        onPressed: isUnassigning.value
                            ? null
                            : () async {
                          isUnassigning.value = true;
                          try {
                            await ref
                                .read(pastorsProvider.notifier)
                                .unassignChurch(pastorId: pastor.id);

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                              context.showSuccessNotification(
                                title: loc.unassignedSuccess,
                                message:
                                loc.pastorRemovedChurch,
                              );
                            }
                          } catch (e) {
                            if (dialogContext.mounted) {
                              context.showErrorNotification(
                                title: loc.failedUnassign,
                                message:
                                e.toString(),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              isUnassigning.value = false;
                            }
                          }
                        },
                        child: isUnassigning.value
                            ? const InlineShimmerLoader(width: 100, height: 20)
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.minus_square,
                              color: Theme.of(context).colorScheme.error,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              loc.unassignChurch,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(loc.cancel),
                ),
                PrimaryButton(
                  text: loc.assign,
                  onPressedAsync: () async {
                    if (selectedChurchId.value == null) return;
                    try {
                      await ref
                          .read(pastorsProvider.notifier)
                          .assignChurchToPastor(
                        pastorId: pastor.id,
                        churchId: selectedChurchId.value,
                      );
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        context.showSuccessNotification(
                          title: loc.success,
                          message: loc.churchAssigned,
                        );
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        context.showErrorNotification(
                          title: loc.error,
                          message: e.toString(),
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

class _EmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onAddPressed;
  final AppLocalization loc;

  const _EmptyState({required this.hasFilters, required this.onAddPressed, required this.loc});

  @override
  Widget build(BuildContext context) {
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
                hasFilters ? Iconsax.search_zoom_out : Iconsax.user_octagon,
                size: 48,
                color: theme.colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters ? loc.noPastorsMatch : loc.noPastorsFound,
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
                  : loc.addFirstPastorDesc,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasFilters) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: onAddPressed,
                text: loc.addFirstPastor,
                icon: Iconsax.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}