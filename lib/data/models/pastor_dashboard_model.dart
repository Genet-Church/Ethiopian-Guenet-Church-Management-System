import 'dashboard_base_model.dart';
import 'dashboard_model.dart';

class PastorDashboardStats extends DashboardStatsBase {
  final String timeframe;
  final DashboardTotals? totals;
  final DashboardNewInTimeframe? newInTimeframe;
  final DashboardDistributions? distributions;

  PastorDashboardStats({
    required this.timeframe,
    this.totals,
    this.newInTimeframe,
    this.distributions,
  });

  factory PastorDashboardStats.fromJson(Map<String, dynamic> json) {
    return PastorDashboardStats(
      timeframe: json['timeframe'] as String? ?? 'all',
      // FIX: Map directly from root JSON to support flat structure
      totals: json['totals'] != null
          ? DashboardTotals.fromJson(json['totals'])
          : null,
      newInTimeframe: json['newInTimeframe'] != null
          ? DashboardNewInTimeframe.fromJson(json['newInTimeframe'])
          : null,
      distributions: json['distributions'] != null
          ? DashboardDistributions.fromJson(json['distributions'])
          : null,
    );
  }
}
