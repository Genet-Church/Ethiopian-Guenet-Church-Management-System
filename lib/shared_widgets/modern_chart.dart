import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';

class ModernLineChart extends StatefulWidget {
  final List<FlSpot> data;
  final String title;
  final String? subtitle;
  final Color? lineColor;
  final List<Color>? gradientColors;
  final double maxY;
  final double minY;
  final List<String>? xLabels;

  const ModernLineChart({
    super.key,
    required this.data,
    required this.title,
    this.subtitle,
    this.lineColor,
    this.gradientColors,
    this.maxY = 100,
    this.minY = 0,
    this.xLabels,
  });

  @override
  State<ModernLineChart> createState() => _ModernLineChartState();
}

class _ModernLineChartState extends State<ModernLineChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final lineColor = widget.lineColor ?? theme.colorScheme.primary;
    final gradientColors = widget.gradientColors ?? [
      lineColor.withValues(alpha: 0.3),
      lineColor.withValues(alpha: 0.1),
    ];

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: appColors.textPrimary,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (widget.maxY - widget.minY) / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: appColors.border.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (widget.xLabels != null && 
                            value.toInt() < widget.xLabels!.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.xLabels![value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textTertiary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (widget.maxY - widget.minY) / 4,
                      reservedSize: 42,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: widget.data.length.toDouble() - 1,
                minY: widget.minY,
                maxY: widget.maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.data,
                    isCurved: true,
                    gradient: LinearGradient(colors: [lineColor, lineColor]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: touchedIndex == index ? 6 : 4,
                          color: lineColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: gradientColors,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                    if (response != null && response.lineBarSpots != null) {
                      setState(() {
                        touchedIndex = response.lineBarSpots!.first.spotIndex;
                      });
                    } else {
                      setState(() {
                        touchedIndex = -1;
                      });
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => appColors.surface,
                    tooltipPadding: const EdgeInsets.all(12),
                    tooltipMargin: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toInt()}',
                          TextStyle(
                            color: appColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
          ),
        ],
      ),
    );
  }
}

class ModernBarChart extends StatefulWidget {
  final List<BarChartGroupData> data;
  final String title;
  final String? subtitle;
  final double maxY;
  final List<String>? xLabels;
  final List<Color>? barColors;

  const ModernBarChart({
    super.key,
    required this.data,
    required this.title,
    this.subtitle,
    this.maxY = 100,
    this.xLabels,
    this.barColors,
  });

  @override
  State<ModernBarChart> createState() => _ModernBarChartState();
}

class _ModernBarChartState extends State<ModernBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final barColors = widget.barColors ?? [
      theme.colorScheme.primary,
      appColors.accent,
      appColors.success,
      appColors.warning,
    ];

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: appColors.textPrimary,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: widget.maxY,
                barTouchData: BarTouchData(
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => appColors.surface,
                    tooltipPadding: const EdgeInsets.all(12),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        TextStyle(
                          color: appColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (widget.xLabels != null && 
                            value.toInt() < widget.xLabels!.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.xLabels![value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textTertiary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: widget.maxY / 4,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: widget.data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final group = entry.value;
                  final isTouched = index == touchedIndex;
                  
                  return BarChartGroupData(
                    x: group.x,
                    barRods: group.barRods.asMap().entries.map((rodEntry) {
                      final rodIndex = rodEntry.key;
                      final rod = rodEntry.value;
                      final color = barColors[rodIndex % barColors.length];
                      
                      return BarChartRodData(
                        toY: rod.toY,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            color,
                            color.withValues(alpha: 0.7),
                          ],
                        ),
                        width: isTouched ? 25 : 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: widget.maxY,
                          color: appColors.surface,
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: widget.maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: appColors.border.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
          ),
        ],
      ),
    );
  }
}

class ModernPieChart extends StatefulWidget {
  final List<PieChartSectionData> sections;
  final String title;
  final String? subtitle;
  final double radius;
  final bool showPercentage;

  const ModernPieChart({
    super.key,
    required this.sections,
    required this.title,
    this.subtitle,
    this.radius = 80,
    this.showPercentage = true,
  });

  @override
  State<ModernPieChart> createState() => _ModernPieChartState();
}

class _ModernPieChartState extends State<ModernPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: appColors.textPrimary,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: widget.sections.asMap().entries.map((entry) {
                        final index = entry.key;
                        final section = entry.value;
                        final isTouched = index == touchedIndex;
                        final radius = isTouched ? widget.radius + 10 : widget.radius;
                        
                        return PieChartSectionData(
                          color: section.color,
                          value: section.value,
                          title: widget.showPercentage ? section.title : '',
                          radius: radius,
                          titleStyle: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          titlePositionPercentageOffset: 0.6,
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.sections.asMap().entries.map((entry) {
                    final index = entry.key;
                    final section = entry.value;
                    final isTouched = index == touchedIndex;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isTouched 
                            ? section.color.withValues(alpha: 0.1)
                            : appColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isTouched 
                              ? section.color
                              : appColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: section.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              section.title,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textPrimary,
                                fontWeight: isTouched 
                                    ? FontWeight.w600 
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '${section.value.toInt()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideX(
                      begin: 0.3,
                      delay: Duration(milliseconds: 100 * index),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
