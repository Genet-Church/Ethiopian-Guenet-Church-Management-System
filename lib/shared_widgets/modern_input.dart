import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

enum InputVariant { filled, outlined, underlined }

enum InputSize { small, medium, large }

class ModernInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final InputVariant variant;
  final InputSize size;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool showCharacterCount;
  final Color? fillColor;
  final Color? borderColor;

  const ModernInput({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixTap,
    this.variant = InputVariant.filled,
    this.size = InputSize.medium,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.focusNode,
    this.showCharacterCount = false,
    this.fillColor,
    this.borderColor,
  });

  @override
  State<ModernInput> createState() => _ModernInputState();
}

class _ModernInputState extends State<ModernInput> {
  late FocusNode _focusNode;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  _SizeConfig _getSizeConfig() {
    switch (widget.size) {
      case InputSize.small:
        return _SizeConfig(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: 8,
          fontSize: 14,
          iconSize: 18,
        );
      case InputSize.medium:
        return _SizeConfig(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 12,
          fontSize: 15,
          iconSize: 20,
        );
      case InputSize.large:
        return _SizeConfig(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          borderRadius: 16,
          fontSize: 16,
          iconSize: 22,
        );
    }
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final sizeConfig = _getSizeConfig();
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = widget.borderColor ?? theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? errorColor
        : _isFocused
        ? primaryColor
        : isDark
        ? appColors.border.withValues(alpha: 0.5)
        : appColors.border.withValues(alpha: 0.3);

    Widget? prefixWidget;
    if (widget.prefixIcon != null || widget.prefix != null) {
      prefixWidget =
          widget.prefix ??
          IgnorePointer(
            child: Container(
              margin: EdgeInsets.only(left: sizeConfig.padding.left, right: 8),
              child: Icon(
                widget.prefixIcon,
                color: _isFocused ? primaryColor : appColors.textSecondary,
                size: sizeConfig.iconSize,
              ),
            ),
          );
    }

    Widget? suffixWidget;
    if (widget.suffixIcon != null || widget.suffix != null) {
      suffixWidget =
          widget.suffix ??
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onSuffixTap,
              child: Container(
                margin: EdgeInsets.only(
                  right: sizeConfig.padding.right,
                  left: 8,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  widget.suffixIcon,
                  color: _isFocused ? primaryColor : appColors.textSecondary,
                  size: sizeConfig.iconSize,
                ),
              ),
            ),
          );
    }

    final defaultFillColor = isDark
        ? appColors.surfaceElevated.withValues(alpha: 0.5)
        : appColors.surface.withValues(alpha: 0.5);

    final focusedFillColor = isDark
        ? appColors.surfaceElevated.withValues(alpha: 0.8)
        : appColors.surface.withValues(alpha: 0.8);

    switch (widget.variant) {
      case InputVariant.filled:
        return InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          filled: true,
          fillColor:
              widget.fillColor ??
              (_isFocused ? focusedFillColor : defaultFillColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(
              color: isDark
                  ? appColors.border.withValues(alpha: 0.4)
                  : appColors.border.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: errorColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
          contentPadding: sizeConfig.padding,
          labelStyle: TextStyle(
            color: _isFocused ? primaryColor : appColors.textSecondary,
            fontSize: sizeConfig.fontSize - 1,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: appColors.textSecondary.withValues(alpha: 0.7),
            fontSize: sizeConfig.fontSize,
            fontWeight: FontWeight.w400,
          ),
          helperStyle: TextStyle(
            color: appColors.textSecondary,
            fontSize: sizeConfig.fontSize - 2,
          ),
          errorStyle: TextStyle(
            color: errorColor,
            fontSize: sizeConfig.fontSize - 2,
            fontWeight: FontWeight.w500,
          ),
        );

      case InputVariant.outlined:
        return InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(
              color: isDark
                  ? appColors.border.withValues(alpha: 0.5)
                  : appColors.border.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: errorColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
          contentPadding: sizeConfig.padding,
          labelStyle: TextStyle(
            color: _isFocused ? primaryColor : appColors.textSecondary,
            fontSize: sizeConfig.fontSize - 1,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: appColors.textSecondary.withValues(alpha: 0.7),
            fontSize: sizeConfig.fontSize,
          ),
        );

      case InputVariant.underlined:
        return InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDark
                  ? appColors.border.withValues(alpha: 0.6)
                  : appColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 1.5),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: sizeConfig.padding.horizontal / 2,
            vertical: sizeConfig.padding.vertical,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final sizeConfig = _getSizeConfig();

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: widget.onTap,
      style: TextStyle(
        fontSize: sizeConfig.fontSize,
        fontWeight: FontWeight.w500,
        color: appColors.textPrimary,
        letterSpacing: 0.2,
      ),
      decoration: _buildDecoration(context),
      buildCounter: widget.showCharacterCount && widget.maxLength != null
          ? (context, {required currentLength, required isFocused, maxLength}) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '$currentLength${maxLength != null ? '/$maxLength' : ''}',
                  style: TextStyle(
                    fontSize: sizeConfig.fontSize - 2,
                    color: appColors.textSecondary,
                  ),
                ),
              );
            }
          : null,
    );
  }
}

class _SizeConfig {
  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;
  final double iconSize;

  _SizeConfig({
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.fontSize,
    required this.iconSize,
  });
}

// Specialized input types
class PasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final InputVariant variant;
  final InputSize size;
  final bool enabled;
  final FocusNode? focusNode;

  const PasswordInput({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.variant = InputVariant.filled,
    this.size = InputSize.medium,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ModernInput(
      controller: widget.controller,
      label: widget.label ?? 'Password',
      hintText: widget.hintText ?? 'Enter your password',
      prefixIcon: Iconsax.lock_1,
      suffixIcon: _obscureText ? Iconsax.eye_slash : Iconsax.eye,
      onSuffixTap: () => setState(() => _obscureText = !_obscureText),
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      variant: widget.variant,
      size: widget.size,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final InputVariant variant;
  final InputSize size;
  final bool enabled;
  final FocusNode? focusNode;

  const EmailInput({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.variant = InputVariant.filled,
    this.size = InputSize.medium,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ModernInput(
      controller: controller,
      label: label ?? 'Email',
      hintText: hintText ?? 'Enter your email address',
      prefixIcon: Iconsax.sms,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      variant: variant,
      size: size,
      enabled: enabled,
      focusNode: focusNode,
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final InputSize size;
  final bool enabled;

  const SearchInput({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.size = InputSize.medium,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ModernInput(
      controller: controller,
      hintText: hintText ?? 'Search...',
      prefixIcon: Iconsax.search_normal,
      suffixIcon: controller?.text.isNotEmpty == true
          ? Iconsax.close_circle
          : null,
      onSuffixTap: () {
        controller?.clear();
        onClear?.call();
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      variant: InputVariant.filled,
      size: size,
      enabled: enabled,
    );
  }
}
