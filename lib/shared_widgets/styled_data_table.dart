import 'package:flutter/material.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';

class StyledDataTable extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> rows;

  const StyledDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.surface,
            appColors.surface.withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: <Color>[Colors.transparent, Colors.black, Colors.black],
            stops: const [0.0, 0.05, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 64,
                  dataRowMinHeight: 72,
                  dataRowMaxHeight: 72,
                  horizontalMargin: 28,
                  columnSpacing: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appColors.scaffold.withValues(alpha: 0.6),
                        appColors.scaffold.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  headingRowColor: WidgetStateProperty.all(Colors.transparent),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: appColors.textPrimary,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    letterSpacing: 0.8,
                  ),
                  dataTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: appColors.textSecondary,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                  columns: columns
                      .map(
                        (col) => DataColumn(
                          label: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.04,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            child: Text(col),
                          ),
                        ),
                      )
                      .toList(),
                  rows: rows
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(
                          color: WidgetStateProperty.resolveWith<Color?>((
                            Set<WidgetState> states,
                          ) {
                            if (states.contains(WidgetState.hovered)) {
                              return theme.colorScheme.primary.withValues(
                                alpha: 0.04,
                              );
                            }
                            if (entry.key % 2 != 0) {
                              return appColors.scaffold.withValues(alpha: 0.3);
                            }
                            return Colors.transparent;
                          }),
                          cells: entry.value.cells.map((cell) {
                            return DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                child: cell.child,
                              ),
                            );
                          }).toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
