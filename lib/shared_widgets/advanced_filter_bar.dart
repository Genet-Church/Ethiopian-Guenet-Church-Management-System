import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

/// Model for a filter option
class FilterOption {
  final String label;
  final String value;
  final bool isSelected;
  final IconData? icon;

  const FilterOption({
    required this.label,
    required this.value,
    this.isSelected = false,
    this.icon,
  });

  FilterOption copyWith({bool? isSelected}) {
    return FilterOption(
      label: label,
      value: value,
      isSelected: isSelected ?? this.isSelected,
      icon: icon,
    );
  }
}

/// Model for a dropdown filter
class FilterDropdownConfig {
  final String label;
  final IconData? icon;
  final List<FilterOption> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const FilterDropdownConfig({
    required this.label,
    this.icon,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  });
}

/// Advanced filter bar with search, chips, and dropdowns
class AdvancedFilterBar extends StatefulWidget {
  final String searchHint;
  final String? searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<FilterOption>? filterChips;
  final ValueChanged<FilterOption>? onChipToggled;
  final List<FilterDropdownConfig>? filterDropdowns;
  final VoidCallback? onClearAll;
  final bool showClearButton;
  final bool isExpanded;

  const AdvancedFilterBar({
    super.key,
    this.searchHint = 'Search...',
    this.searchValue,
    required this.onSearchChanged,
    this.filterChips,
    this.onChipToggled,
    this.filterDropdowns,
    this.onClearAll,
    this.showClearButton = true,
    this.isExpanded = true,
  });

  @override
  State<AdvancedFilterBar> createState() => _AdvancedFilterBarState();
}

class _AdvancedFilterBarState extends State<AdvancedFilterBar> {
  late TextEditingController _searchController;
  bool _hasActiveFilters = false;
  bool _isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue);
    _searchController.addListener(_onControllerTextChanged);
    _updateActiveFiltersState();
  }

  @override
  void didUpdateWidget(AdvancedFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update controller text if it's an external change, not from our onChanged
    // Compare with current controller text to avoid resetting cursor position
    if (widget.searchValue != oldWidget.searchValue &&
        widget.searchValue != _searchController.text) {
      _isProgrammaticChange = true;
      _searchController.text = widget.searchValue ?? '';
      _isProgrammaticChange = false;
    }
    _updateActiveFiltersState();
  }

  void _onControllerTextChanged() {
    // Avoid calling setState if this was triggered by programmatic change
    if (!_isProgrammaticChange && mounted) {
      _updateActiveFiltersState();
    }
  }

  void _updateActiveFiltersState() {
    final hasSearch = _searchController.text.isNotEmpty;
    final hasChips = widget.filterChips?.any((c) => c.isSelected) ?? false;
    final hasDropdowns =
        widget.filterDropdowns?.any((d) => d.selectedValue != null) ?? false;
    final newHasActiveFilters = hasSearch || hasChips || hasDropdowns;
    if (newHasActiveFilters != _hasActiveFilters) {
      setState(() {
        _hasActiveFilters = newHasActiveFilters;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onControllerTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.surface,
            appColors.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Row
          Row(
            children: [
              Expanded(
                child: _SearchField(
                  controller: _searchController,
                  hint: widget.searchHint,
                  onChanged: (value) {
                    widget.onSearchChanged(value);
                    _updateActiveFiltersState();
                  },
                ),
              ),
              if (widget.showClearButton && _hasActiveFilters) ...[
                SizedBox(width: isSmallScreen ? 8 : 12),
                _ClearAllButton(
                  onPressed: () {
                    _searchController.clear();
                    widget.onClearAll?.call();
                    _updateActiveFiltersState();
                  },
                ),
              ],
            ],
          ),
          // Filter Chips
          if (widget.filterChips != null && widget.filterChips!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.filterChips!.map((chip) {
                return _FilterChipWidget(
                  option: chip,
                  onTap: () {
                    widget.onChipToggled?.call(chip);
                    _updateActiveFiltersState();
                  },
                );
              }).toList(),
            ),
          ],
          // Dropdown Filters
          if (widget.filterDropdowns != null &&
              widget.filterDropdowns!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.filterDropdowns!.map((dropdown) {
                return _FilterDropdown(config: dropdown);
              }).toList(),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, duration: 300.ms);
  }
}

class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Trigger rebuild when text changes to update clear button visibility
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: appColors.scaffold,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: TextStyle(
          color: appColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: appColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal_1,
            color: appColors.textSecondary,
            size: 20,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Iconsax.close_circle,
                    color: appColors.textSecondary,
                    size: 18,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  final FilterOption option;
  final VoidCallback onTap;

  const _FilterChipWidget({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final isSelected = option.isSelected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : appColors.scaffold,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : appColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              Icon(
                option.icon,
                size: 14,
                color: isSelected ? Colors.white : appColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              option.label,
              style: TextStyle(
                color: isSelected ? Colors.white : appColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(Iconsax.tick_circle, size: 14, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final FilterDropdownConfig config;

  const _FilterDropdown({required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 120 : 160,
        maxWidth: isSmallScreen ? 160 : 220,
      ),
      height: isSmallScreen ? 40 : 44,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: appColors.scaffold,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: config.selectedValue != null
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : appColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: config.selectedValue,
          isExpanded: true,
          hint: Row(
            children: [
              if (config.icon != null) ...[
                Icon(config.icon, size: 16, color: appColors.textSecondary),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  config.label,
                  style: TextStyle(
                    color: appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          icon: Icon(
            Iconsax.arrow_down_1,
            color: appColors.textSecondary,
            size: 16,
          ),
          style: TextStyle(
            color: appColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          dropdownColor: appColors.surface,
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                'All ${config.label}',
                style: TextStyle(
                  color: appColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...config.options.map((option) {
              return DropdownMenuItem<String?>(
                value: option.value,
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        option.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          onChanged: config.onChanged,
        ),
      ),
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ClearAllButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.close_circle,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 6),
              Text(
                'Clear',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
