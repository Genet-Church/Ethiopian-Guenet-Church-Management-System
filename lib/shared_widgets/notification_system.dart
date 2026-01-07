import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

enum NotificationType { success, error, warning, info }

class NotificationData {
  final String title;
  final String message;
  final NotificationType type;
  final Duration duration;
  final VoidCallback? onTap;
  final String? actionLabel;
  final VoidCallback? onAction;

  const NotificationData({
    required this.title,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 4),
    this.onTap,
    this.actionLabel,
    this.onAction,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationData> _notifications = [];
  final StreamController<List<NotificationData>> _controller = 
      StreamController<List<NotificationData>>.broadcast();

  Stream<List<NotificationData>> get notifications => _controller.stream;
  List<NotificationData> get currentNotifications => List.unmodifiable(_notifications);

  void showSuccess({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _addNotification(NotificationData(
      title: title,
      message: message,
      type: NotificationType.success,
      duration: duration ?? const Duration(seconds: 4),
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    ));
  }

  void showError({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _addNotification(NotificationData(
      title: title,
      message: message,
      type: NotificationType.error,
      duration: duration ?? const Duration(seconds: 6),
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    ));
  }

  void showWarning({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _addNotification(NotificationData(
      title: title,
      message: message,
      type: NotificationType.warning,
      duration: duration ?? const Duration(seconds: 5),
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    ));
  }

  void showInfo({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _addNotification(NotificationData(
      title: title,
      message: message,
      type: NotificationType.info,
      duration: duration ?? const Duration(seconds: 4),
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    ));
  }

  void _addNotification(NotificationData notification) {
    _notifications.add(notification);
    _controller.add(_notifications);
    
    Timer(notification.duration, () {
      _removeNotification(notification);
    });
  }

  void _removeNotification(NotificationData notification) {
    _notifications.remove(notification);
    _controller.add(_notifications);
  }

  void removeNotification(NotificationData notification) {
    _removeNotification(notification);
  }

  void clearAll() {
    _notifications.clear();
    _controller.add(_notifications);
  }

  void dispose() {
    _controller.close();
  }
}

class NotificationOverlay extends StatelessWidget {
  const NotificationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationData>>(
      stream: NotificationService().notifications,
      initialData: NotificationService().currentNotifications,
      builder: (context, snapshot) {
        final notifications = snapshot.data ?? [];
        
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: notifications.map((notification) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NotificationCard(
                  notification: notification,
                  onDismiss: () => NotificationService().removeNotification(notification),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class NotificationCard extends StatefulWidget {
  final NotificationData notification;
  final VoidCallback onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (widget.notification.type) {
      case NotificationType.success:
        return const Color(0xFF10B981);
      case NotificationType.error:
        return const Color(0xFFEF4444);
      case NotificationType.warning:
        return const Color(0xFFF59E0B);
      case NotificationType.info:
        return theme.colorScheme.primary;
    }
  }

  IconData _getIcon() {
    switch (widget.notification.type) {
      case NotificationType.success:
        return Iconsax.tick_circle;
      case NotificationType.error:
        return Iconsax.close_circle;
      case NotificationType.warning:
        return Iconsax.warning_2;
      case NotificationType.info:
        return Iconsax.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final backgroundColor = _getBackgroundColor(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: backgroundColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: appColors.shadow.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Accent bar
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    backgroundColor,
                                    backgroundColor.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: backgroundColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getIcon(),
                                    color: backgroundColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Text content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.notification.title,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: appColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.notification.message,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: appColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                      if (widget.notification.actionLabel != null) ...[
                                        const SizedBox(height: 12),
                                        TextButton(
                                          onPressed: widget.notification.onAction,
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            widget.notification.actionLabel!,
                                            style: TextStyle(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Dismiss button
                                IconButton(
                                  onPressed: _dismiss,
                                  icon: Icon(
                                    Iconsax.close_square,
                                    color: appColors.textSecondary,
                                    size: 18,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().shimmer(
                duration: 2000.ms,
                color: backgroundColor.withValues(alpha: 0.1),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Extension for easy access
extension NotificationExtension on BuildContext {
  void showSuccessNotification({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    NotificationService().showSuccess(
      title: title,
      message: message,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showErrorNotification({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    NotificationService().showError(
      title: title,
      message: message,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showWarningNotification({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    NotificationService().showWarning(
      title: title,
      message: message,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showInfoNotification({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    NotificationService().showInfo(
      title: title,
      message: message,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
