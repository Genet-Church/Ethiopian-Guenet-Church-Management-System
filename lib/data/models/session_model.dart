class Session {
  final String id;
  final String userId;
  final String refreshToken;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime updatedAt;
  final String userAgent;
  final bool isCurrent;

  Session({
    required this.id,
    required this.userId,
    required this.refreshToken,
    required this.createdAt,
    required this.expiresAt,
    required this.updatedAt,
    required this.userAgent,
    this.isCurrent = false,
  });

  factory Session.fromJson(
    Map<String, dynamic> json, {
    String? currentSessionId,
  }) {
    final sessionId = json['id'] as String;
    return Session(
      id: sessionId,
      userId: json['userId'] as String,
      refreshToken: json['refreshToken'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userAgent: json['userAgent'] as String? ?? 'Unknown Device',
      isCurrent: currentSessionId != null && sessionId == currentSessionId,
    );
  }
}
