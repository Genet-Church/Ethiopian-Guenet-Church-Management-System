import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class CommandPalette extends ConsumerStatefulWidget {
  final Widget child;
  const CommandPalette({super.key, required this.child});

  @override
  ConsumerState<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<CommandPalette> {
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePalette() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            _togglePalette,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _togglePalette,
      },
      child: Stack(
        children: [
          widget.child,
          if (_isOpen) _CommandPaletteOverlay(onClose: _togglePalette),
        ],
      ),
    );
  }
}

class _CommandPaletteOverlay extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const _CommandPaletteOverlay({required this.onClose});

  @override
  ConsumerState<_CommandPaletteOverlay> createState() =>
      _CommandPaletteOverlayState();
}

class _CommandPaletteOverlayState
    extends ConsumerState<_CommandPaletteOverlay> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<CommandItem> _filteredCommands = [];
  int _selectedIndex = 0;

  late final List<CommandItem> _allCommands;

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
    _allCommands = _getCommands();
    _filteredCommands = _allCommands;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCommands = _allCommands.where((cmd) {
        return cmd.title.toLowerCase().contains(query) ||
            cmd.subtitle.toLowerCase().contains(query);
      }).toList();
      _selectedIndex = 0;
    });
  }

  List<CommandItem> _getCommands() {
    return [
      CommandItem(
        title: 'Go to Dashboard',
        subtitle: 'Navigate to the main dashboard',
        icon: Iconsax.category,
        action: () => context.go('/dashboard'),
      ),
      CommandItem(
        title: 'Go to Settings',
        subtitle: 'Manage app preferences',
        icon: Iconsax.setting_2,
        action: () => context.go('/settings'),
      ),
      CommandItem(
        title: 'Go to Profile',
        subtitle: 'View your profile',
        icon: Iconsax.user,
        action: () => context.go('/profile'),
      ),
      CommandItem(
        title: 'Toggle Theme',
        subtitle: 'Switch between light and dark mode',
        icon: Iconsax.moon,
        action: () {
          final current = ref.read(appThemeNotifierProvider);
          final next = current == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
          ref.read(appThemeNotifierProvider.notifier).setTheme(next);
        },
      ),
      CommandItem(
        title: 'Go to Members',
        subtitle: 'View all members',
        icon: Iconsax.people,
        action: () => context.go('/show-members'),
      ),
      CommandItem(
        title: 'Add Member',
        subtitle: 'Register a new member',
        icon: Iconsax.user_add,
        action: () => context.go('/add-members'),
      ),
    ];
  }

  void _handleSelection() {
    if (_filteredCommands.isNotEmpty) {
      widget.onClose();
      _filteredCommands[_selectedIndex].action();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: widget.onClose,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ).animate().fadeIn(duration: 200.ms),

        // Palette
        Center(
          child:
              Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 600,
                      constraints: const BoxConstraints(maxHeight: 400),
                      decoration: BoxDecoration(
                        color: appColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: appColors.border.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.search_normal,
                                  color: appColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _searchFocus,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: appColors.textPrimary,
                                        ),
                                    decoration: InputDecoration(
                                      hintText: 'Type a command or search...',
                                      hintStyle: TextStyle(
                                        color: appColors.textSecondary,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onSubmitted: (_) => _handleSelection(),
                                    onChanged: (_) {}, // Handled by listener
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),

                          // Results
                          Flexible(
                            child: _filteredCommands.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Text(
                                      'No commands found',
                                      style: TextStyle(
                                        color: appColors.textSecondary,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _filteredCommands.length,
                                    itemBuilder: (context, index) {
                                      final item = _filteredCommands[index];
                                      final isSelected =
                                          index == _selectedIndex;

                                      return MouseRegion(
                                        onEnter: (_) => setState(
                                          () => _selectedIndex = index,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.onClose();
                                            item.action();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? theme.primaryColor
                                                        .withValues(alpha: 0.1)
                                                  : null,
                                              border: Border(
                                                left: BorderSide(
                                                  color: isSelected
                                                      ? theme.primaryColor
                                                      : Colors.transparent,
                                                  width: 4,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  item.icon,
                                                  color: isSelected
                                                      ? theme.primaryColor
                                                      : appColors.textSecondary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: theme
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                              color: isSelected
                                                                  ? theme
                                                                        .primaryColor
                                                                  : appColors
                                                                        .textPrimary,
                                                              fontWeight:
                                                                  isSelected
                                                                  ? FontWeight
                                                                        .w600
                                                                  : FontWeight
                                                                        .normal,
                                                            ),
                                                      ),
                                                      Text(
                                                        item.subtitle,
                                                        style: theme
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color: appColors
                                                                  .textSecondary,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Icon(
                                                    Iconsax.arrow_right_1,
                                                    color: theme.primaryColor,
                                                    size: 16,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .scale(
                    duration: 200.ms,
                    curve: Curves.easeOutCubic,
                    begin: const Offset(0.95, 0.95),
                  )
                  .fadeIn(duration: 150.ms),
        ),
      ],
    );
  }
}

class CommandItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback action;

  CommandItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.action,
  });
}
