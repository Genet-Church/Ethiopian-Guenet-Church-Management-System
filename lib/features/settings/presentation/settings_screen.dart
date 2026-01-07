import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/settings/date_format_provider.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/theme_provider.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/localization/app_localization.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final themeMode = ref.watch(appThemeNotifierProvider);
    final dateFormat = ref.watch(dateFormatNotifierProvider);
    final currentLocale = ref.watch(languageNotifierProvider);
    final l10n = AppLocalization(currentLocale);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.scaffold,
            appColors.scaffold,
            theme.primaryColor.withValues(alpha: 0.03),
          ],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 900,
            ),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section with Gradient
                  _buildHeader(context, appColors, theme, isMobile, l10n),
                  SizedBox(height: isMobile ? 24 : 40),

                  // Power User Section
                  _buildGradientSectionHeader(
                    context,
                    l10n.powerUser,
                    Iconsax.flash_1,
                    [Colors.orange, Colors.deepOrange],
                    0,
                  ),
                  const SizedBox(height: 16),
                  _buildPowerUserCard(context, theme, appColors, isMobile, l10n)
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                  SizedBox(height: isMobile ? 24 : 32),

                  // Appearance Section
                  _buildGradientSectionHeader(
                    context,
                    l10n.appearance,
                    Iconsax.paintbucket,
                    [Colors.purple, Colors.deepPurple],
                    1,
                  ),
                  const SizedBox(height: 16),
                  _buildAppearanceCard(
                        context,
                        theme,
                        appColors,
                        themeMode,
                        ref,
                        isMobile,
                        isTablet,
                        l10n,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                  SizedBox(height: isMobile ? 24 : 32),

                  // Localization Section
                  _buildGradientSectionHeader(
                    context,
                    l10n.localization,
                    Iconsax.global,
                    [Colors.blue, Colors.indigo],
                    2,
                  ),
                  const SizedBox(height: 16),
                  _buildLocalizationCard(
                        context,
                        theme,
                        appColors,
                        dateFormat,
                        currentLocale,
                        ref,
                        isMobile,
                        isTablet,
                        l10n,
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                  SizedBox(height: isMobile ? 24 : 32),

                  // About Section
                  _buildGradientSectionHeader(
                    context,
                    l10n.about,
                    Iconsax.info_circle,
                    [Colors.teal, Colors.cyan],
                    3,
                  ),
                  const SizedBox(height: 16),
                  _buildAboutCard(context, theme, appColors, isMobile, l10n)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppColors appColors,
    ThemeData theme,
    bool isMobile,
    AppLocalization l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withValues(alpha: 0.1),
            theme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Iconsax.setting_2,
              color: Colors.white,
              size: isMobile ? 24 : 36,
            ),
          ),
          SizedBox(width: isMobile ? 16 : 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings,
                  style:
                      (isMobile
                              ? theme.textTheme.headlineSmall
                              : theme.textTheme.headlineMedium)
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: appColors.textPrimary,
                            fontSize: isMobile ? 20 : null,
                          ),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                const SizedBox(height: 4),
                Text(
                      l10n.customizeExperience,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textSecondary,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 300.ms)
                    .slideX(begin: -0.1),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildGradientSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    List<Color> colors,
    int index,
  ) {
    final theme = Theme.of(context);

    return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) =>
                  LinearGradient(colors: colors).createShader(bounds),
              child: Text(
                title.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.first.withValues(alpha: 0.5),
                      colors.first.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1);
  }

  Widget _buildPowerUserCard(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    bool isMobile,
    AppLocalization l10n,
  ) {
    return ModernCard(
      variant: CardVariant.glass,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildCommandIcon(theme),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCommandText(theme, appColors, l10n),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(child: _buildKeyboardShortcut(theme, appColors)),
                ],
              )
            : Row(
                children: [
                  _buildCommandIcon(theme),
                  const SizedBox(width: 20),
                  Expanded(child: _buildCommandText(theme, appColors, l10n)),
                  _buildKeyboardShortcut(theme, appColors),
                ],
              ),
      ),
    );
  }

  Widget _buildCommandIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withValues(alpha: 0.2),
            Colors.deepOrange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: const Icon(
        Iconsax.command_square,
        color: Colors.deepOrange,
        size: 28,
      ),
    );
  }

  Widget _buildCommandText(
    ThemeData theme,
    AppColors appColors,
    AppLocalization l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.globalCommandPalette,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.commandPaletteDesc,
          style: theme.textTheme.bodySmall?.copyWith(
            color: appColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboardShortcut(ThemeData theme, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.surfaceElevated,
            appColors.surfaceElevated.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.keyboard_command_key,
              size: 18,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'K',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    ThemeMode themeMode,
    WidgetRef ref,
    bool isMobile,
    bool isTablet,
    AppLocalization l10n,
  ) {
    return ModernCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildSettingIcon(
                        Iconsax.moon,
                        Colors.purple,
                        Colors.deepPurple,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.themeMode,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.chooseVisualPreference,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildThemeSelector(theme, themeMode, ref, true, l10n),
                ],
              )
            : Row(
                children: [
                  _buildSettingIcon(
                    Iconsax.moon,
                    Colors.purple,
                    Colors.deepPurple,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.themeMode,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.chooseVisualPreference,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildThemeSelector(theme, themeMode, ref, false, l10n),
                ],
              ),
      ),
    );
  }

  Widget _buildThemeSelector(
    ThemeData theme,
    ThemeMode themeMode,
    WidgetRef ref,
    bool isMobile,
    AppLocalization l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.light,
            icon: const Icon(Iconsax.sun_1, size: 18),
            label: Text(isMobile ? '' : l10n.light),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: const Icon(Iconsax.moon, size: 18),
            label: Text(isMobile ? '' : l10n.dark),
          ),
          ButtonSegment(
            value: ThemeMode.system,
            icon: const Icon(Iconsax.monitor, size: 18),
            label: Text(isMobile ? '' : l10n.system),
          ),
        ],
        selected: {themeMode},
        onSelectionChanged: (Set<ThemeMode> newSelection) {
          ref
              .read(appThemeNotifierProvider.notifier)
              .setTheme(newSelection.first);
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 8),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.primaryColor.withValues(alpha: 0.15);
            }
            return null;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
        ),
      ),
    );
  }

  Widget _buildLocalizationCard(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    DateFormatType dateFormat,
    Locale currentLocale,
    WidgetRef ref,
    bool isMobile,
    bool isTablet,
    AppLocalization l10n,
  ) {
    return ModernCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: Column(
          children: [
            // Language Setting
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildSettingIcon(
                            Iconsax.language_square,
                            Colors.blue,
                            Colors.indigo,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.language,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: appColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.selectLanguage,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildLanguageDropdown(
                        theme,
                        appColors,
                        currentLocale,
                        ref,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _buildSettingIcon(
                        Iconsax.language_square,
                        Colors.blue,
                        Colors.indigo,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.language,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.selectLanguage,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildLanguageDropdown(
                        theme,
                        appColors,
                        currentLocale,
                        ref,
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: appColors.border.withValues(alpha: 0.3),
                height: 1,
              ),
            ),
            // Date Format Setting
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildSettingIcon(
                            Iconsax.calendar_1,
                            Colors.teal,
                            Colors.cyan,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.dateFormat,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: appColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.chooseCalendarFormat,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDateFormatSelector(
                        theme,
                        dateFormat,
                        ref,
                        true,
                        l10n,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _buildSettingIcon(
                        Iconsax.calendar_1,
                        Colors.teal,
                        Colors.cyan,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dateFormat,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.chooseCalendarFormat,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildDateFormatSelector(
                        theme,
                        dateFormat,
                        ref,
                        false,
                        l10n,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(
    ThemeData theme,
    AppColors appColors,
    Locale currentLocale,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: appColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: currentLocale.languageCode == 'am' ? 'አማርኛ' : 'English',
        underline: const SizedBox(),
        dropdownColor: appColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        icon: Icon(
          Iconsax.arrow_down_1,
          color: appColors.textSecondary,
          size: 18,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: appColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        items: [
          DropdownMenuItem(
            value: 'English',
            child: Row(
              children: [
                const Text('🇺🇸'),
                const SizedBox(width: 8),
                Text('English'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'አማርኛ',
            child: Row(
              children: [
                const Text('🇪🇹'),
                const SizedBox(width: 8),
                Text('አማርኛ'),
              ],
            ),
          ),
        ],
        onChanged: (String? newValue) {
          if (newValue == 'English') {
            ref.read(languageNotifierProvider.notifier).setLanguage('en');
          } else if (newValue == 'አማርኛ') {
            ref.read(languageNotifierProvider.notifier).setLanguage('am');
          }
        },
      ),
    );
  }

  Widget _buildDateFormatSelector(
    ThemeData theme,
    DateFormatType dateFormat,
    WidgetRef ref,
    bool isMobile,
    AppLocalization l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SegmentedButton<DateFormatType>(
        segments: [
          ButtonSegment(
            value: DateFormatType.gregorian,
            icon: isMobile ? null : const Icon(Iconsax.calendar, size: 16),
            label: Text(l10n.gregorian),
          ),
          ButtonSegment(
            value: DateFormatType.ethiopian,
            icon: isMobile ? null : const Icon(Iconsax.calendar_2, size: 16),
            label: Text(l10n.ethiopian),
          ),
        ],
        selected: {dateFormat},
        onSelectionChanged: (Set<DateFormatType> newSelection) {
          ref
              .read(dateFormatNotifierProvider.notifier)
              .setDateFormat(newSelection.first);
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 8),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.primaryColor.withValues(alpha: 0.15);
            }
            return null;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.primaryColor;
            }
            return null;
          }),
        ),
      ),
    );
  }

  Widget _buildAboutCard(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    bool isMobile,
    AppLocalization l10n,
  ) {
    return ModernCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          children: [
            Row(
              children: [
                _buildSettingIcon(
                  Iconsax.info_circle,
                  Colors.teal,
                  Colors.cyan,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.version,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.withValues(alpha: 0.2),
                                  Colors.cyan.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '1.0.0+1',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${l10n.latest}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.tick_circle,
                    color: Colors.green,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    ThemeData theme,
    AppColors appColors,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: appColors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: appColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: appColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: appColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingIcon(IconData icon, Color color1, Color color2) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color1.withValues(alpha: 0.2),
            color2.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color1.withValues(alpha: 0.3)),
      ),
      child: Icon(icon, color: color1, size: 24),
    );
  }
}
