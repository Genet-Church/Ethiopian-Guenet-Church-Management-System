import 'package:flutter/material.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';

class ModernDropdown<T> extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const ModernDropdown({
    super.key,
    required this.hintText,
    required this.icon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Defensive check: If the current value is not in the list of items, treat it as null.
    // This prevents the "Assertion failed: items.where((DropdownMenuItem<T> item) => item.value == value).length == 1" error.
    final isValueInItems =
        value == null || items.any((item) => item.value == value);
    final T? currentValue = isValueInItems ? value : null;

    return DropdownButtonFormField<T>(
      initialValue: currentValue,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: appColors.textPrimary,
        fontSize: isSmallScreen ? 13 : 15,
        letterSpacing: 0.2,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: appColors.scaffold,
        hintText: hintText,
        hintStyle: TextStyle(
          color: appColors.textSecondary.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
          padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: appColors.textSecondary,
            size: isSmallScreen ? 16 : 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: appColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 12 : 20,
          horizontal: isSmallScreen ? 12 : 20,
        ),
      ),
    );
  }
}
