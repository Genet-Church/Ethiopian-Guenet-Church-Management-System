import 'package:flutter/material.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/shared_widgets/advanced_filter_bar.dart';
import 'package:genet_church_portal/shared_widgets/card_shimmer_loader.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_data_card.dart';
import 'package:iconsax/iconsax.dart';

/// Configuration for a modern report list
class ModernReportConfig<T> {
  /// Function to build a ModernDataCard from an item
  final ModernDataCard Function(T item, int index) cardBuilder;

  /// Function to filter items based on search query
  final bool Function(T item, String query)? searchFilter;

  /// Additional filter functions (key = filter name, value = filter function)
  final Map<String, bool Function(T item, dynamic filterValue)>? customFilters;

  const ModernReportConfig({
    required this.cardBuilder,
    this.searchFilter,
    this.customFilters,
  });
}

/// A reusable modern report list with cards, filtering, and shimmer loading
class ModernReportList<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final String? error;
  final ModernReportConfig<T> config;

  // Filter bar configuration
  final String searchHint;
  final String? searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<FilterOption>? filterChips;
  final ValueChanged<FilterOption>? onChipToggled;
  final List<FilterDropdownConfig>? filterDropdowns;
  final VoidCallback? onClearAll;

  // Empty state
  final String emptyTitle;
  final String emptyDescription;
  final IconData emptyIcon;
  final Widget? emptyAction;

  // Error state
  final VoidCallback? onRetry;

  const ModernReportList({
    super.key,
    required this.items,
    required this.isLoading,
    this.error,
    required this.config,
    this.searchHint = 'Search...',
    this.searchValue,
    required this.onSearchChanged,
    this.filterChips,
    this.onChipToggled,
    this.filterDropdowns,
    this.onClearAll,
    this.emptyTitle = 'No Items Found',
    this.emptyDescription = 'There are no items to display.',
    this.emptyIcon = Iconsax.document,
    this.emptyAction,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Bar
        AdvancedFilterBar(
          searchHint: searchHint,
          searchValue: searchValue,
          onSearchChanged: onSearchChanged,
          filterChips: filterChips,
          onChipToggled: onChipToggled,
          filterDropdowns: filterDropdowns,
          onClearAll: onClearAll,
        ),
        const SizedBox(height: 24),

        // Content
        if (isLoading)
          CardGridShimmerLoader.responsive(context: context)
        else if (error != null)
          _ErrorState(error: error!, onRetry: onRetry)
        else if (items.isEmpty)
          _EmptyState(
            title: emptyTitle,
            description: emptyDescription,
            icon: emptyIcon,
            action: emptyAction,
          )
        else
          ModernDataGrid.responsive(
            context: context,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return config.cardBuilder(item, index);
            }).toList(),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Widget? action;

  const _EmptyState({
    required this.title,
    required this.description,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ModernCard(
      child: Container(
        padding: const EdgeInsets.all(48),
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
                icon,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: appColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const _ErrorState({required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ModernCard(
      child: Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Data',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: appColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Iconsax.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A helper widget that displays a beautiful "no church selected" state
class NoChurchSelectedState extends StatelessWidget {
  final String message;

  const NoChurchSelectedState({
    super.key,
    this.message = 'Please select a church from the header to continue.',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ModernCard(
      child: Container(
        padding: const EdgeInsets.all(48),
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
                Iconsax.building_4,
                size: 48,
                color: theme.colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select a Church',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: appColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A helper to get initials from a full name
String getInitials(String? fullName) {
  if (fullName == null || fullName.isEmpty) return '?';
  final parts = fullName.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return parts[0][0].toUpperCase();
}
