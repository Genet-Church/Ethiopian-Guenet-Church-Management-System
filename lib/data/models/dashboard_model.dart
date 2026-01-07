import 'dashboard_base_model.dart';

class SuperAdminDashboardStats extends DashboardStatsBase {
  final String timeframe;
  final DashboardTotals? totals;
  final DashboardNewInTimeframe? newInTimeframe;
  final DashboardDistributions? distributions;

  SuperAdminDashboardStats({
    required this.timeframe,
    this.totals,
    this.newInTimeframe,
    this.distributions,
  });

  factory SuperAdminDashboardStats.fromJson(Map<String, dynamic> json) {
    return SuperAdminDashboardStats(
      timeframe: json['timeframe'] as String? ?? 'all',
      // FIX: Map directly from root JSON because backend returns flat structure
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

class DashboardTotals {
  final int totalChurches;
  final int totalPastors;
  final int totalServants;
  final int totalMembers;

  DashboardTotals({
    required this.totalChurches,
    required this.totalPastors,
    required this.totalServants,
    required this.totalMembers,
  });

  factory DashboardTotals.fromJson(Map<String, dynamic> json) {
    // FIX: Look for keys either at root OR inside 'totals' to be safe
    final source = json.containsKey('totals')
        ? (json['totals'] as Map<String, dynamic>)
        : json;

    return DashboardTotals(
      totalChurches: source['totalChurches'] as int? ?? 0,
      totalPastors: source['totalPastors'] as int? ?? 0,
      totalServants: source['totalServants'] as int? ?? 0,
      totalMembers: source['totalMembers'] as int? ?? 0,
    );
  }
}

class DashboardNewInTimeframe {
  final int? newChurches;
  final int newMembers;
  final int newBaptisms;
  final int statusChanges;

  DashboardNewInTimeframe({
    this.newChurches,
    required this.newMembers,
    required this.newBaptisms,
    required this.statusChanges,
  });

  factory DashboardNewInTimeframe.fromJson(Map<String, dynamic> json) {
    // FIX: Look for keys either at root OR inside 'newInTimeframe'
    final source = json.containsKey('newInTimeframe')
        ? (json['newInTimeframe'] as Map<String, dynamic>)
        : json;

    return DashboardNewInTimeframe(
      newChurches: source['newChurches'] as int?,
      newMembers: source['newMembers'] as int? ?? 0,
      newBaptisms: source['newBaptisms'] as int? ?? 0,
      statusChanges: source['statusChanges'] as int? ?? 0,
    );
  }
}

class DashboardDistributions {
  final Map<String, int> membersByGender;
  final Map<String, int> membersByStatus;
  final Map<String, int> membersByBaptismStatus;

  DashboardDistributions({
    required this.membersByGender,
    required this.membersByStatus,
    required this.membersByBaptismStatus,
  });

  factory DashboardDistributions.fromJson(Map<String, dynamic> json) {
    // FIX: Look for keys either at root OR inside 'distributions'
    final source = json.containsKey('distributions')
        ? (json['distributions'] as Map<String, dynamic>)
        : json;

    return DashboardDistributions(
      membersByGender: Map<String, int>.from(source['membersByGender'] ?? {}),
      membersByStatus: Map<String, int>.from(source['membersByStatus'] ?? {}),
      membersByBaptismStatus: Map<String, int>.from(
        source['membersByBaptismStatus'] ?? {},
      ),
    );
  }
}
