import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';

class ModernSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const ModernSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appColors.shimmerBase,
            appColors.shimmerHighlight,
            appColors.shimmerBase,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: 1500.ms,
      color: appColors.shimmerHighlight.withValues(alpha: 0.3),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return Container(
      width: width,
      height: height ?? 200,
      margin: margin ?? const EdgeInsets.all(8),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appColors.borderSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ModernSkeleton(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ModernSkeleton(
                      width: double.infinity,
                      height: 16,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    ModernSkeleton(
                      width: 120,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ModernSkeleton(
            width: double.infinity,
            height: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 8),
          ModernSkeleton(
            width: double.infinity,
            height: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 8),
          ModernSkeleton(
            width: 200,
            height: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ModernSkeleton(
                width: 80,
                height: 32,
                borderRadius: BorderRadius.circular(16),
              ),
              ModernSkeleton(
                width: 100,
                height: 32,
                borderRadius: BorderRadius.circular(16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonTable extends StatelessWidget {
  final int rows;
  final int columns;

  const SkeletonTable({
    super.key,
    this.rows = 5,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return Container(
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColors.surfaceElevated,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: List.generate(
                columns,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < columns - 1 ? 16 : 0,
                    ),
                    child: ModernSkeleton(
                      height: 16,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Rows
          ...List.generate(
            rows,
            (rowIndex) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: appColors.borderSubtle,
                    width: rowIndex < rows - 1 ? 1 : 0,
                  ),
                ),
              ),
              child: Row(
                children: List.generate(
                  columns,
                  (colIndex) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: colIndex < columns - 1 ? 16 : 0,
                      ),
                      child: ModernSkeleton(
                        height: 14,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const SkeletonList({
    super.key,
    this.itemCount = 8,
    this.itemHeight = 80,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => SkeletonListItem(
        height: itemHeight,
        margin: const EdgeInsets.only(bottom: 12),
      ),
    );
  }
}

class SkeletonListItem extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;

  const SkeletonListItem({
    super.key,
    this.height = 80,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return Container(
      height: height,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ModernSkeleton(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ModernSkeleton(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                ModernSkeleton(
                  width: 150,
                  height: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ModernSkeleton(
            width: 60,
            height: 24,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }
}

class SkeletonDashboard extends StatelessWidget {
  const SkeletonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ModernSkeleton(
            width: 300,
            height: 32,
            borderRadius: BorderRadius.circular(16),
            margin: const EdgeInsets.only(bottom: 8),
          ),
          ModernSkeleton(
            width: 200,
            height: 16,
            borderRadius: BorderRadius.circular(8),
            margin: const EdgeInsets.only(bottom: 32),
          ),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: SkeletonCard(height: 120),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SkeletonCard(height: 120),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SkeletonCard(height: 120),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Content Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SkeletonCard(height: 400),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: SkeletonCard(height: 400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ModernLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const ModernLoadingIndicator({
    super.key,
    this.message,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: appColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.white.withValues(alpha: 0.3),
          ),
        ).animate(
          onPlay: (controller) => controller.repeat(),
        ).rotate(duration: 1000.ms),
        
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ],
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: appColors.scaffold.withValues(alpha: 0.8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: appColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.shadow.withValues(alpha: 0.2),
                        blurRadius: 32,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: ModernLoadingIndicator(
                    message: message ?? 'Loading...',
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 200.ms),
      ],
    );
  }
}
