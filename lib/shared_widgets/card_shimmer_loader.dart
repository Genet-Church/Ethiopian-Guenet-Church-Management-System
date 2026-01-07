import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// A beautiful shimmer loader for card-based grids
class CardGridShimmerLoader extends StatelessWidget {
  final int cardCount;
  final int crossAxisCount;
  final double spacing;

  const CardGridShimmerLoader({
    super.key,
    this.cardCount = 6,
    this.crossAxisCount = 2,
    this.spacing = 16,
  });

  factory CardGridShimmerLoader.responsive({
    Key? key,
    required BuildContext context,
    int cardCount = 6,
    double spacing = 16,
  }) {
    final width = MediaQuery.of(context).size.width;
    int columns;
    if (width < 600) {
      columns = 1;
    } else if (width < 900) {
      columns = 2;
    } else if (width < 1200) {
      columns = 3;
    } else {
      columns = 4;
    }

    return CardGridShimmerLoader(
      key: key,
      cardCount: cardCount,
      crossAxisCount: columns,
      spacing: spacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Shimmer.fromColors(
      baseColor: appColors.shimmerBase,
      highlightColor: appColors.shimmerHighlight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
              crossAxisCount;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(cardCount, (index) {
              return SizedBox(
                width: crossAxisCount == 1 ? constraints.maxWidth : itemWidth,
                child: _ShimmerCard(index: index),
              );
            }),
          );
        },
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final int index;

  const _ShimmerCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with avatar and title
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Chips row
              Row(
                children: [
                  Container(
                    height: 28,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 28,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action buttons row
              Row(
                children: [
                  Container(
                    height: 32,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 32,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 300.ms);
  }
}

/// A beautiful shimmer loader specifically for filter/search bars
class FilterBarShimmerLoader extends StatelessWidget {
  const FilterBarShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Shimmer.fromColors(
      baseColor: appColors.shimmerBase,
      highlightColor: appColors.shimmerHighlight,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 48,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full page shimmer loader for reports (filter bar + card grid)
class ReportPageShimmerLoader extends StatelessWidget {
  final int cardCount;

  const ReportPageShimmerLoader({super.key, this.cardCount = 6});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FilterBarShimmerLoader(),
        const SizedBox(height: 24),
        CardGridShimmerLoader.responsive(
          context: context,
          cardCount: cardCount,
        ),
      ],
    );
  }
}

/// Compact shimmer for inline loading states (replaces CircularProgressIndicator)
class InlineShimmerLoader extends StatelessWidget {
  final double width;
  final double height;

  const InlineShimmerLoader({super.key, this.width = 120, this.height = 20});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Shimmer.fromColors(
      baseColor: appColors.shimmerBase,
      highlightColor: appColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}
