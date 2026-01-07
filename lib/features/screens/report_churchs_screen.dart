import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/shared_widgets/advanced_filter_bar.dart';
import 'package:genet_church_portal/shared_widgets/card_shimmer_loader.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_data_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_date_picker.dart';
import 'package:genet_church_portal/state/new_item_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/church_model.dart';
import 'package:genet_church_portal/data/services/url_launcher_service.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/api_error_widget.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';
import '../../core/constants.dart';
import 'package:genet_church_portal/core/utils/date_formatter.dart';

import '../../core/localization/app_localization.dart';

class ReportChurchsScreen extends HookConsumerWidget {
  const ReportChurchsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final churchesAsync = ref.watch(churchesProvider);
    final newlyAddedItemId = ref.watch(newlyAddedItemIdProvider);
    final userRole = ref.watch(authStateProvider)?.roleEnum;
    final searchQuery = useState('');
    final isDeleting = useState<String?>(null);
    final urlLauncher = UrlLauncherService();
    final hasLocationFilter = useState(false);
    final sortOption = useState<String>('name_asc');
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    final sortDropdowns = <FilterDropdownConfig>[
      FilterDropdownConfig(
        label: loc.sortBy,
        icon: Iconsax.sort,
        options: [
          FilterOption(label: loc.nameAsc, value: 'name_asc'),
          FilterOption(label: loc.nameDesc, value: 'name_desc'),
          FilterOption(label: loc.newestFirst, value: 'date_desc'),
          FilterOption(label: loc.oldestFirst, value: 'date_asc'),
        ],
        selectedValue: sortOption.value,
        onChanged: (val) => sortOption.value = val!,
      ),
    ];

    final filterChips = <FilterOption>[
      FilterOption(
        label: loc.hasLocation,
        value: 'has_location',
        icon: Iconsax.location,
        isSelected: hasLocationFilter.value,
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
                        loc.churchRecords,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 24
                              : 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.manageChurchesDesc,
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
                if (userRole == UserRole.SUPER_ADMIN) ...[
                  const SizedBox(width: 24),
                  PrimaryButton(
                    onPressed: () => _showAddChurchDialog(context, ref),
                    text: loc.addChurch,
                    icon: Iconsax.add,
                  ),
                ],
              ],
            ),
          ),
          AdvancedFilterBar(
            searchHint: loc.searchChurchHint,
            searchValue: searchQuery.value,
            onSearchChanged: (val) => searchQuery.value = val,
            filterDropdowns: sortDropdowns,
            filterChips: filterChips,
            onChipToggled: (chip) {
              if (chip.value == 'has_location') {
                hasLocationFilter.value = !hasLocationFilter.value;
              }
            },
            onClearAll: () {
              searchQuery.value = '';
              hasLocationFilter.value = false;
              sortOption.value = 'name_asc';
            },
          ),
          const SizedBox(height: 24),
          churchesAsync.when(
            data: (churches) {
              var filteredChurches = churches.where((church) {
                if (searchQuery.value.isNotEmpty) {
                  if (!church.name.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  )) {
                    return false;
                  }
                }
                if (hasLocationFilter.value) {
                  if (church.locationLink == null ||
                      church.locationLink!.isEmpty) {
                    return false;
                  }
                }
                return true;
              }).toList();

              filteredChurches.sort((a, b) {
                switch (sortOption.value) {
                  case 'name_asc':
                    return a.name.compareTo(b.name);
                  case 'name_desc':
                    return b.name.compareTo(a.name);
                  case 'date_desc':
                    final dateA =
                        DateTime.tryParse(a.dateCreated ?? '') ??
                        DateTime(1970);
                    final dateB =
                        DateTime.tryParse(b.dateCreated ?? '') ??
                        DateTime(1970);
                    return dateB.compareTo(dateA);
                  case 'date_asc':
                    final dateA =
                        DateTime.tryParse(a.dateCreated ?? '') ??
                        DateTime(1970);
                    final dateB =
                        DateTime.tryParse(b.dateCreated ?? '') ??
                        DateTime(1970);
                    return dateA.compareTo(dateB);
                  default:
                    return 0;
                }
              });

              if (filteredChurches.isEmpty) {
                return _EmptyState(
                  hasFilters: searchQuery.value.isNotEmpty,
                  onAddPressed: () => _showAddChurchDialog(context, ref),
                  userCanAdd: userRole == UserRole.SUPER_ADMIN,
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
                children: filteredChurches.asMap().entries.map((entry) {
                  final index = entry.key;
                  final church = entry.value;
                  final isNew = church.id == newlyAddedItemId;
                  final hasLocation =
                      church.locationLink != null &&
                      Uri.tryParse(church.locationLink!)?.isAbsolute == true;

                  return ModernDataCard(
                    index: index,
                    isNew: isNew,
                    leading: DataCardAvatar(
                      icon: Iconsax.building,
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    title: church.name,
                    subtitle: church.establishmentDate != null
                        ? '${loc.est} ${AppDateFormatter.format(DateTime.parse(church.establishmentDate!), ref)}'
                        : null,
                    description: church.headOfficeId != null
                        ? '${loc.headOfficeId}: ${church.headOfficeId}'
                        : null,
                    chips: [
                      if (hasLocation)
                        DataChip(
                          label: loc.viewOnMap,
                          icon: Iconsax.location,
                          color: theme.colorScheme.secondary,
                        ),
                    ],
                    onTap: hasLocation
                        ? () => urlLauncher.openInNewTab(church.locationLink!)
                        : null,
                    actions: userRole == UserRole.SUPER_ADMIN
                        ? [
                            DataAction(
                              label: 'EDIT',
                              icon: Iconsax.edit,
                              color: theme.colorScheme.primary,
                              onPressed: () =>
                                  _showEditChurchDialog(context, ref, church),
                            ),
                            DataAction(
                              label: 'DELETE',
                              icon: Iconsax.trash,
                              isDestructive: true,
                              isLoading: isDeleting.value == church.id,
                              onPressed: () => _showDeleteConfirmationDialog(
                                context,
                                ref,
                                church,
                                isDeleting,
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
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    Church church,
    ValueNotifier<String?> isDeleting,
  ) {
    final locale = ref.read(languageNotifierProvider);
    final loc = AppLocalization(locale);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.confirmDeletion),
          content: Text(
            loc.deleteConfirmation.replaceAll('{name}', church.name),
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
                isDeleting.value = church.id;
                Navigator.of(dialogContext).pop();
                try {
                  await ref
                      .read(churchesProvider.notifier)
                      .removeChurch(church.id);
                  if (context.mounted) {
                    context.showSuccessNotification(
                      title: loc.churchDeleted,
                      message: loc.churchDeleteSuccess.replaceAll(
                        '{name}',
                        church.name,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorNotification(
                      title: loc.deleteFailed,
                      message: loc.failedDeleteChurch,
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

  void _showAddChurchDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    DateTime? selectedEstablishmentDate;
    final formKey = GlobalKey<FormState>();
    final locale = ref.read(languageNotifierProvider);
    final loc = AppLocalization(locale);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(loc.addChurch),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ModernInput(
                        controller: nameController,
                        label: loc.churchName,
                        prefixIcon: Iconsax.building,
                      ),
                      const SizedBox(height: 20),
                      ModernInput(
                        controller: locationController,
                        label: loc.googleMapsLink,
                        prefixIcon: Iconsax.map_1,
                      ),
                      const SizedBox(height: 20),
                      ModernDatePicker(
                        hintText: loc.churchEstablishmentDate,
                        icon: Iconsax.calendar_1,
                        selectedDate: selectedEstablishmentDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedEstablishmentDate = date;
                          });
                        },
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
                  text: loc.addChurch,
                  onPressedAsync: () async {
                    if (nameController.text.trim().isEmpty) {
                      context.showWarningNotification(
                        title: loc.validationError,
                        message: loc.churchNameRequired,
                      );
                      return;
                    }
                    try {
                      final newChurchData = Church(
                        id: '',
                        name: nameController.text.trim(),
                        locationLink: locationController.text.trim().isEmpty
                            ? null
                            : locationController.text.trim(),
                        establishmentDate: selectedEstablishmentDate
                            ?.toIso8601String(),
                        headOfficeId: AppConstants.addisAbabaHeadOfficeId,
                      );
                      final newChurch = await ref
                          .read(churchesProvider.notifier)
                          .addChurch(newChurchData);
                      ref
                          .read(newlyAddedItemIdProvider.notifier)
                          .set(newChurch.id);
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        context.showSuccessNotification(
                          title: loc.churchAdded,
                          message:
                              '"${nameController.text.trim()}" ${loc.churchAdded}',
                        );
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        context.showErrorNotification(
                          title: loc.addFailed,
                          message: '${loc.error}: ${e.toString()}',
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

  void _showEditChurchDialog(
    BuildContext context,
    WidgetRef ref,
    Church church,
  ) {
    final nameController = TextEditingController(text: church.name);
    final locationController = TextEditingController(text: church.locationLink);
    final formKey = GlobalKey<FormState>();
    final locale = ref.read(languageNotifierProvider);
    final loc = AppLocalization(locale);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(loc.editChurch),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ModernInput(
                        controller: nameController,
                        label: loc.churchName,
                        prefixIcon: Iconsax.building,
                      ),
                      const SizedBox(height: 20),
                      ModernInput(
                        controller: locationController,
                        label: loc.googleMapsLink,
                        prefixIcon: Iconsax.map_1,
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
                  text: loc.saveChanges,
                  onPressedAsync: () async {
                    if (nameController.text.trim().isEmpty) {
                      context.showWarningNotification(
                        title: loc.validationError,
                        message: loc.churchNameRequired,
                      );
                      return;
                    }
                    try {
                      final updatedChurch = Church(
                        id: church.id,
                        name: nameController.text.trim(),
                        locationLink: locationController.text.trim().isEmpty
                            ? null
                            : locationController.text.trim(),
                        establishmentDate: church.establishmentDate,
                        headOfficeId: church.headOfficeId,
                        dateCreated: church.dateCreated,
                      );
                      await ref
                          .read(churchesProvider.notifier)
                          .updateChurch(
                            churchId: church.id,
                            church: updatedChurch,
                          );
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        context.showSuccessNotification(
                          title: loc.churchUpdated,
                          message: loc.churchUpdateSuccess.replaceAll(
                            '{name}',
                            nameController.text.trim(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        context.showErrorNotification(
                          title: loc.updateFailed,
                          message: '${loc.error}: ${e.toString()}',
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
  final bool userCanAdd;

  const _EmptyState({
    required this.hasFilters,
    required this.onAddPressed,
    required this.userCanAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Consumer(
      builder: (context, ref, child) {
        final locale = ref.watch(languageNotifierProvider);
        final loc = AppLocalization(locale);

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
                    hasFilters ? Iconsax.search_zoom_out : Iconsax.building,
                    size: 48,
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  hasFilters ? loc.noChurchesMatch : loc.noChurchesFound,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: appColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  hasFilters ? loc.adjustSearchTerms : loc.addFirstChurchDesc,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!hasFilters && userCanAdd) ...[
                  const SizedBox(height: 24),
                  PrimaryButton(
                    onPressed: onAddPressed,
                    text: loc.addFirstChurch,
                    icon: Iconsax.add,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
