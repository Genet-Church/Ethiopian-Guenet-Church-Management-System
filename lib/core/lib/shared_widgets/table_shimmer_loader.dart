import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gdev_frontend/core/theme/app_colors.dart';

class TableShimmerLoader extends StatelessWidget {
  final int rowCount;
  final int columnCount;

  const TableShimmerLoader({super.key, this.rowCount = 5, this.columnCount = 5});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Shimmer.fromColors(
      baseColor: appColors.shimmerBase,
      highlightColor: appColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: List.generate(rowCount, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(columnCount, (colIndex) => Expanded(
                flex: colIndex == columnCount - 1 ? 2 : 1,
                child: Container(
                  height: colIndex == columnCount - 1 ? 36 : 20,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                ),
              )),
            ),
          )),
        ),
      ),
    );
  }
}