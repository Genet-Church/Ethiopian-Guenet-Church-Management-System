import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/visual_effects.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final user = ref.watch(authStateProvider);
    final pastor = ref.watch(currentPastorProvider);
    final churchesAsync = ref.watch(churchesProvider);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final userInitial = user.fullName.isNotEmpty
        ? user.fullName[0].toUpperCase()
        : '?';

    String? churchName;
    final churches = churchesAsync.valueOrNull;
    final churchIdToUse = pastor.value?.churchId;
    if (churchIdToUse != null && churches != null) {
      churchName = churches
          .where((c) => c.id == churchIdToUse)
          .map((c) => c.name)
          .cast<String?>()
          .firstWhere(
            (name) => name != null && name.isNotEmpty,
            orElse: () => null,
          );
    }

    void showEditProfileDialog() {
      final nameController = TextEditingController(text: user.fullName);
      final emailController = TextEditingController(text: user.email);

      showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: ModernCard(
              variant: CardVariant.glass,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Edit Profile',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: appColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ModernInput(
                    controller: nameController,
                    label: 'Full Name',
                    prefixIcon: Iconsax.user,
                  ),
                  const SizedBox(height: 16),
                  EmailInput(
                    controller: emailController,
                    label: 'Email Address',
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlineButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(dialogContext),
                        size: ButtonSize.medium,
                      ),
                      const SizedBox(width: 12),
                      ModernButton(
                        text: 'Save',
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.showSuccessNotification(
                            title: 'Profile Updated',
                            message:
                                'Your profile has been updated successfully.',
                          );
                        },
                        size: ButtonSize.medium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void showChangePasswordDialog() {
      final currentPasswordController = TextEditingController();
      final newPasswordController = TextEditingController();
      final confirmPasswordController = TextEditingController();
      final formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: ModernCard(
              variant: CardVariant.glass,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Change Password',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: appColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PasswordInput(
                      controller: currentPasswordController,
                      label: 'Current Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordInput(
                      controller: newPasswordController,
                      label: 'New Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordInput(
                      controller: confirmPasswordController,
                      label: 'Confirm New Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlineButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(dialogContext),
                          size: ButtonSize.medium,
                        ),
                        const SizedBox(width: 12),
                        ModernButton(
                          text: 'Change Password',
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              try {
                                final authRepo = ref.read(authRepositoryProvider);
                                await authRepo.changePassword(
                                  currentPasswordController.text,
                                  newPasswordController.text,
                                );
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                }
                                if (context.mounted) {
                                  context.showSuccessNotification(
                                    title: 'Password Changed',
                                    message:
                                        'Your password has been changed successfully.',
                                  );
                                }
                              } catch (e) {
                                if (dialogContext.mounted) {
                                  String errorMessage =
                                      'Failed to change password. Please try again.';
                                  if (e is DioException) {
                                    final errorData = e.response?.data;
                                    if (errorData != null &&
                                        errorData['message'] != null) {
                                      errorMessage = errorData['message'];
                                    }
                                  }
                                  context.showErrorNotification(
                                    title: 'Error',
                                    message: errorMessage,
                                  );
                                }
                              }
                            }
                          },
                          size: ButtonSize.medium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: isSmallScreen ? 20 : 40),
              // Ultra-modern avatar with glow effect
              Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: VisualEffects.createGlow(
                        color: theme.colorScheme.primary,
                        intensity: 0.4,
                        blur: 32,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.7),
                            theme.colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: isSmallScreen ? 40 : 60,
                        backgroundColor: appColors.surface,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            userInitial,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 32 : 48,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 28),
              // Name with gradient effect
              ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        appColors.textPrimary,
                        theme.colorScheme.primary,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      user.fullName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        fontSize: isSmallScreen ? 24 : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOut),
              const SizedBox(height: 12),
              // Holographic role badge
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                          theme.colorScheme.secondary.withValues(alpha: 0.2),
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.crown_15,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.role.replaceAll('_', ' ').toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 300.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOut),
              const SizedBox(height: 40),
              // Glass card for profile info
              Builder(
                    builder: (context) => ModernCard(
                      variant: CardVariant.glass,
                      child: Column(
                        children: [
                          _ProfileInfoRow(
                            icon: Iconsax.direct_right,
                            label: 'Email',
                            value: user.email,
                            gradientColors: const [
                              Color(0xFF667eea),
                              Color(0xFF764ba2),
                            ],
                          ),
                          if (churchName != null) ...[
                            Divider(
                              color: appColors.border.withValues(alpha: 0.3),
                            ),
                            _ProfileInfoRow(
                              icon: Iconsax.building_4,
                              label: 'Assigned Church',
                              value: churchName,
                              gradientColors: const [
                                Color(0xFF11998e),
                                Color(0xFF38ef7d),
                              ],
                            ),
                          ],
                          Divider(
                            color: appColors.border.withValues(alpha: 0.3),
                          ),
                          _ProfileInfoRow(
                            icon: Iconsax.key,
                            label: 'Password',
                            value: '••••••••',
                            gradientColors: const [
                              Color(0xFFf093fb),
                              Color(0xFFf5576c),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOut),
              const SizedBox(height: 32),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlineButton(
                          text: 'Change Password',
                          onPressed: showChangePasswordDialog,
                          icon: Iconsax.key,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ModernButton(
                          text: 'Edit Profile',
                          onPressed: showEditProfileDialog,
                          icon: Iconsax.edit,
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 500.ms)
                  .slideY(begin: 0.1, curve: Curves.easeOut),
              SizedBox(height: isSmallScreen ? 20 : 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradientColors;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradientColors,
  });

  @override
  State<_ProfileInfoRow> createState() => _ProfileInfoRowState();
}

class _ProfileInfoRowState extends State<_ProfileInfoRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _isHovered
              ? widget.gradientColors[0].withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? widget.gradientColors
                      : [
                          widget.gradientColors[0].withValues(alpha: 0.2),
                          widget.gradientColors[1].withValues(alpha: 0.1),
                        ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: widget.gradientColors[0].withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon,
                color: _isHovered ? Colors.white : widget.gradientColors[0],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: appColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: _isHovered
                          ? widget.gradientColors[0]
                          : appColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 1.0 : 0.0,
              child: Icon(
                Iconsax.arrow_right_3,
                size: 18,
                color: widget.gradientColors[0],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
